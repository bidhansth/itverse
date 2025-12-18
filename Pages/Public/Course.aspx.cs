using LMS.Models;
using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace LMS.Pages.Public
{
    public partial class Course : System.Web.UI.Page
    {
        private readonly string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

        // Backing fields
        public string idParam;
        public int? student_id;
        public bool isEnrolled = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Retrieve course id from query string early and validate
            idParam = Request.QueryString["id"];
            if (!int.TryParse(idParam, out int courseId))
            {
                // invalid or missing course id
                Response.Redirect("Course.aspx");
                return;
            }

            // Retrieve logged-in student from session
            if (Session["LoggedInUser"] is Student student)
            {
                student_id = student.StudentId;
                // Optionally persist in session for other pages (as int)
                Session["student_id"] = student.StudentId;
            }
            else if (Session["student_id"] != null && int.TryParse(Session["student_id"].ToString(), out int sidFromSession))
            {
                student_id = sidFromSession;
            }
            if (!IsPostBack)
            {
                LoadCourse(courseId);

                hlResources.NavigateUrl = $"Resources.aspx?id={courseId}";
                hlAssignments.NavigateUrl = $"AssignmentPerSubject.aspx?id={courseId}";
                hlForum.NavigateUrl = $"Forum.aspx?id={courseId}";
            }

            // Only check enrollment if we have a valid student and course
            if (student_id.HasValue)
            {
                CheckEnrollment(courseId);
            }
            else
            {
                isEnrolled = false;
            }

            UpdateButton();
        }

        private void LoadCourse(int courseId)
        {
            try
            {
                const string query = "SELECT coursename FROM courses WHERE courseid = @cid";

                using (SqlConnection conn = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@cid", courseId);
                    conn.Open();

                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        courseTitle.InnerText = result.ToString();
                    }
                    else
                    {
                        // Course not found, redirect back
                        Response.Redirect("Courses.aspx");
                    }
                }
            }
            catch (Exception ex)
            {
                // log and optionally show friendly message
                System.Diagnostics.Debug.WriteLine("LoadCourse Error: " + ex.ToString());
                lblMessage.Text = "Unable to load course information at this time.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        private void CheckEnrollment(int courseId)
        {
            try
            {
                const string query = "SELECT COUNT(*) FROM studentcourses WHERE student_id = @sid AND course_id = @cid";

                using (SqlConnection conn = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@sid", student_id.Value);
                    cmd.Parameters.AddWithValue("@cid", courseId);
                    conn.Open();

                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    isEnrolled = count > 0;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CheckEnrollment Error: " + ex.ToString());
                isEnrolled = false;
            }
        }

        private void UpdateButton()
        {
            btnEnrollUnenroll.Text = isEnrolled ? "Unenroll" : "Enroll";
            if (isEnrolled)
            {
                btnEnrollUnenroll.OnClientClick = "return confirm('Are you sure you want to unenroll?');";
            }
            else
            {
                btnEnrollUnenroll.OnClientClick = null;
            }
        }

        protected void btnEnrollUnenroll_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(idParam, out int courseId))
            {
                lblMessage.Text = "Invalid course.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (!student_id.HasValue)
            {
                lblMessage.Text = "You must be logged in to enroll.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd;
                    if (isEnrolled)
                    {
                        // Unenroll
                        cmd = new SqlCommand("DELETE FROM studentcourses WHERE student_id = @sid AND course_id = @cid", conn);
                    }
                    else
                    {
                        // Enroll
                        cmd = new SqlCommand("INSERT INTO studentcourses (student_id, course_id) VALUES (@sid, @cid)", conn);
                    }

                    cmd.Parameters.AddWithValue("@sid", student_id.Value);
                    cmd.Parameters.AddWithValue("@cid", courseId);
                    int affected = cmd.ExecuteNonQuery();

                    if (affected > 0)
                    {
                        // Toggle enrollment state
                        isEnrolled = !isEnrolled;
                        UpdateButton();
                        lblMessage.Text = isEnrolled
                            ? "You have been enrolled."
                            : "You have been unenrolled.";
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                    }
                    else
                    {
                        lblMessage.Text = "No changes were made.";
                        lblMessage.ForeColor = System.Drawing.Color.Orange;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Enroll/Unenroll Error: " + ex.ToString());
                lblMessage.Text = "An error occurred while updating enrollment.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}
