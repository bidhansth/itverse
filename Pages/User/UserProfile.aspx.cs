using LMS.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace LMS.Pages.User
{
    public partial class UserProfile : System.Web.UI.Page
    {
        public int student_id;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LoggedInUser"] != null)
            {
                if (Session["LoggedInUser"] is Student student)
                {
                    student_id = student.StudentId;
                    Session["student_id"] = student.StudentId;
                }
            }
            else
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStudentProfile();
                LoadCourses();
            }
        }
        private void LoadStudentProfile()
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                SELECT FirstName, LastName, Email, ContactNumber, ProfilePicture
                FROM Students
                WHERE StudentId = @id";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", student_id);
                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblFullName.Text = reader["FirstName"] + " " + reader["LastName"];
                    lblEmail.Text = reader["Email"].ToString();
                    lblContact.Text = reader["ContactNumber"].ToString();

                    string profilePic = ResolveUrl(reader["ProfilePicture"].ToString());
                    imgProfile.ImageUrl = string.IsNullOrEmpty(profilePic) ? "~/Images/default.jpg" : profilePic;
                }
            }
        }

        private void LoadCourses()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            string query = @"
                           SELECT c.CourseId AS CourseId, c.CourseName AS CourseName
                            FROM
                                students s
                            JOIN
                                studentcourses sc ON s.StudentId = sc.student_id
                            JOIN
                                courses c ON sc.course_id = c.Courseid
                            WHERE
                                s.StudentId = @a";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                cmd.Parameters.AddWithValue("@a", student_id);
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string id = reader["CourseId"].ToString();
                    string name = reader["CourseName"].ToString();

                    HtmlGenericControl colDiv = new HtmlGenericControl("div");
                    colDiv.Attributes.Add("class", "col-sm-3 m-4 d-inline-block");

                    colDiv.InnerHtml = $@"
                        <a href='/Pages/Public/course.aspx?id={HttpUtility.UrlEncode(id)}' style='text-decoration:none; color:inherit;'>
                            <div class='card shadow-sm'>
                                <div class='card-body'>
                                    <h5 class='card-title'>{name}</h5>
                                </div>
                            </div>
                        </a>";

                    cardsContainer.Controls.Add(colDiv);
                }
            }
        }
    }
}