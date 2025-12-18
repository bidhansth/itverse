using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Pages.Public
{
    public partial class AssignmentPerSubject : System.Web.UI.Page
    {
        public int student_id;
        protected void Page_Load(object sender, EventArgs e)
        {

            string idParam = Request.QueryString["id"];
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(idParam) && int.TryParse(idParam, out int courseId))
                {
                    LoadCourseTitle(courseId);
                    LoadAssignments(courseId);
                }

                else
                {
                    litCourseTitle.Text = "<h2>Invalid course selected.</h2>";
                }
            }
        }


        private void LoadCourseTitle(int courseId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT coursename FROM courses WHERE courseid = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", courseId);
                conn.Open();
                var courseName = cmd.ExecuteScalar();
                litCourseTitle.Text = courseName != null ? $"<h2>Assignments for {courseName}</h2>" : "<h2>Course not found</h2>";
            }
        }

        private void LoadAssignments(int courseId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT id, title, deadline, description FROM assignments WHERE course_id = @courseId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@courseId", courseId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptAssignments.DataSource = dt;
                rptAssignments.DataBind();
            }
        }

        protected void rptAssignments_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int assignmentId = Convert.ToInt32(drv["id"]);
                Literal litSubmissionStatus = (Literal)e.Item.FindControl("litSubmissionStatus");
                CheckSubmissionStatus(assignmentId, litSubmissionStatus);
            }
        }

        private void CheckSubmissionStatus(int assignmentId, Literal litSubmissionStatus)
        {
            int currentUserId = GetCurrentUserId();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT file_name, submission_date 
                                 FROM submissions 
                                 WHERE assignment_id = @assignmentId AND student_id = @studentId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@assignmentId", assignmentId);
                cmd.Parameters.AddWithValue("@studentId", currentUserId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string fileName = reader["file_name"].ToString();
                    DateTime submissionDate = Convert.ToDateTime(reader["submission_date"]);

                    litSubmissionStatus.Text = $@"
                        <div class='submission-status submitted'>
                            <i class='fas fa-check-circle'></i>
                            <strong>Submitted:</strong> {fileName} on {submissionDate:MMM dd, yyyy}
                        </div>";
                }
                else
                {
                    litSubmissionStatus.Text = @"
                        <div class='submission-status not-submitted'>
                            <i class='fas fa-clock'></i>
                            <strong>Status:</strong> Not submitted yet
                        </div>";
                }
            }
        }

        protected void btnSubmit_Command(object sender, CommandEventArgs e)
        {

            //if (Session["student_id"] == null)
            //{
            //    // Student not logged in
            //    Response.Redirect("Error.aspx");
            //    return;
            //}

            //int currentUserId = Convert.ToInt32(Session["student_id"]);


            Button btn = (Button)sender;
            RepeaterItem item = (RepeaterItem)btn.NamingContainer;
            FileUpload fileUpload = (FileUpload)item.FindControl("fileUpload");

            int assignmentId = Convert.ToInt32(e.CommandArgument);

            // 🔴 TEMPORARY: Hardcoded student ID for testing only
            int currentUserId = 3;


            if (!fileUpload.HasFile)
            {
                ShowMessage(item, "Please select a file to upload.", "error");
                return;
            }

            if (!ValidateFile(fileUpload))
            {
                ShowMessage(item, "Invalid file. Allowed types: .pdf, .doc, .docx, .txt, .zip, .rar and max size 10MB.", "error");
                return;
            }

            string fileName = SaveUploadedFile(fileUpload, assignmentId, currentUserId, out string filePath);

            if (!string.IsNullOrEmpty(fileName))
            {
                SaveSubmissionToDatabase(assignmentId, currentUserId, fileName, fileUpload.FileName, filePath);
                ShowMessage(item, "Assignment submitted successfully!", "success");

                Literal litSubmissionStatus = (Literal)item.FindControl("litSubmissionStatus");
                CheckSubmissionStatus(assignmentId, litSubmissionStatus);

                // Optional: if you want to reload entire assignments list uncomment below:
                // LoadAssignments(GetCourseIdFromQuery());
            }
            else
            {
                ShowMessage(item, "Failed to upload file. Please try again.", "error");
            }
        }

        private bool ValidateFile(FileUpload fileUpload)
        {
            if (fileUpload.PostedFile.ContentLength > 10 * 1024 * 1024) // 10 MB
                return false;

            string extension = Path.GetExtension(fileUpload.FileName).ToLower();
            string[] allowedExtensions = { ".pdf", ".doc", ".docx", ".txt", ".zip", ".rar" };

            return allowedExtensions.Contains(extension);
        }

        private string SaveUploadedFile(FileUpload fileUpload, int assignmentId, int userId, out string fullPath)
        {
            try
            {
                string uploadsPath = Server.MapPath("/Uploads/Assignments");

                if (!Directory.Exists(uploadsPath))
                    Directory.CreateDirectory(uploadsPath);

                string originalFileName = Path.GetFileNameWithoutExtension(fileUpload.FileName);
                string extension = Path.GetExtension(fileUpload.FileName);
                string timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
                string uniqueFileName = $"{originalFileName}_{userId}_{timestamp}{extension}";

                fullPath = Path.Combine(uploadsPath, uniqueFileName);
                fileUpload.SaveAs(fullPath);

                return uniqueFileName;
            }
            catch
            {
                fullPath = null;
                return null;
            }
        }

        private void SaveSubmissionToDatabase(int assignmentId, int studentId, string fileName, string originalFileName, string filePath)
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string checkQuery = "SELECT COUNT(*) FROM submissions WHERE assignment_id = @assignmentId AND student_id = @studentId";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@assignmentId", assignmentId);
                checkCmd.Parameters.AddWithValue("@studentId", studentId);

                conn.Open();
                int existingCount = (int)checkCmd.ExecuteScalar();

                string query;
                if (existingCount > 0)
                {
                    query = @"UPDATE submissions 
                              SET file_name = @fileName, 
                                  original_file_name = @originalFileName,
                                  file_path = @filePath,
                                  submission_date = @submissionDate
                              WHERE assignment_id = @assignmentId AND student_id = @studentId";
                }
                else
                {
                    query = @"INSERT INTO submissions 
                              (assignment_id, student_id,file_Name, file_data, submission_date)
                              VALUES (@assignmentId, @studentId, @fileName, @originalFileName, @submissionDate)";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@assignmentId", assignmentId);
                cmd.Parameters.AddWithValue("@studentId", studentId);
                cmd.Parameters.AddWithValue("@fileName", fileName);
                cmd.Parameters.AddWithValue("@originalFileName", originalFileName);
                cmd.Parameters.AddWithValue("@filePath", filePath);
                cmd.Parameters.AddWithValue("@submissionDate", DateTime.Now);

                cmd.ExecuteNonQuery();
            }
        }

        private void ShowMessage(RepeaterItem item, string message, string type)
        {
            Literal messageContainer = new Literal();
            messageContainer.Text = $@"
                <div class='status-message status-{type}'>
                    <i class='fas fa-{(type == "success" ? "check-circle" : "exclamation-circle")}'></i>
                    {message}
                </div>";

            var submissionSection = item.FindControl("fileUpload").Parent;
            submissionSection.Controls.Add(messageContainer);
        }

        private int GetCurrentUserId()
        {
            return Session["student_id"] != null ? (int)Session["student_id"] : 1;
        }
    }
}