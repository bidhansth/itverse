using LMS.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Pages.Teachers
{
    public partial class AddResource : System.Web.UI.Page
    {
        public int teacher_id;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LoggedInUser"] != null)
            {
                if (Session["LoggedInUser"] is Teacher teacher)
                {
                    teacher_id = teacher.TeacherId;

                }
            }
            else
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            if (Request.QueryString["id"] == null)
            {
                Response.Write("Missing course ID.");
                Response.End();
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (!fileUpload.HasFile)
                return;

            int courseId = int.Parse(Request.QueryString["id"]);
            string title = txtTitle.Text.Trim();
            string originalFileName = Path.GetFileName(fileUpload.FileName);
            string fileExt = Path.GetExtension(originalFileName).ToLower();

            if (string.IsNullOrEmpty(title))
            {
                lblMessage.Text = "Title is required.";
                return;
            }

            string[] allowedExtensions = { ".pdf", ".doc", ".docx", ".ppt", ".pptx", ".jpg", ".jpeg", ".png" };
            if (Array.IndexOf(allowedExtensions, fileExt) == -1)
            {
                lblMessage.Text = "File type not allowed.";
                return;
            }

            // Generate unique file name
            string uniqueName = Path.GetFileNameWithoutExtension(originalFileName)
                                + "_" + Guid.NewGuid().ToString("N").Substring(0, 8) + fileExt;

            string savePath = Server.MapPath("/Resources/") + uniqueName;
            fileUpload.SaveAs(savePath);

            // Auto-detect file type
            string type = GetFileType(fileExt);

            // Save record to DB
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (var con = new System.Data.SqlClient.SqlConnection(connStr))
            {
                con.Open();
                string query = "INSERT INTO resources (title, course_id, type, path) VALUES (@title, @course_id, @type, @path)";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.Parameters.AddWithValue("@course_id", courseId);
                    cmd.Parameters.AddWithValue("@type", type);
                    cmd.Parameters.AddWithValue("@path", uniqueName);
                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "Resource uploaded successfully.";
            txtTitle.Text = "";
        }

        private string GetFileType(string ext)
        {
            switch (ext)
            {
                case ".pdf":
                case ".doc":
                case ".docx":
                    return "application/msword";
                case ".txt":
                    return "text/plain";
                case ".jpg":
                case ".jpeg":
                    return "image/jpeg";
                case ".mp4":
                case ".avi":
                case ".mov":
                    return "Video";
                default:
                    return "Other";
            }
        }
    }
}