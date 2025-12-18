using LMS.Model;
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

namespace LMS.Pages.Teachers
{
    public partial class TeacherDashboard : System.Web.UI.Page
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

            if (!IsPostBack)
            {
                LoadTeacherProfile();
                LoadCourses();
            }
        }

        private void LoadTeacherProfile()
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                SELECT FirstName, LastName, Email, ContactNumber, ProfilePicture
                FROM teachers
                WHERE teacherid = @id";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", teacher_id);
                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblFullName.Text = reader["FirstName"] + " " + reader["LastName"];
                    lblEmail.Text = reader["Email"].ToString();
                    lblContact.Text = reader["ContactNumber"].ToString();

                    string profilePic = reader["ProfilePicture"].ToString();
                    imgProfile.ImageUrl = string.IsNullOrEmpty(profilePic) ? "~/Images/default.jpg" : "~/Images/" + profilePic;
                }
            }
        }

        private void LoadCourses()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            string query = "SELECT CourseId,CourseName FROM courses";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string id = reader["CourseId"].ToString();
                    string name = reader["CourseName"].ToString();

                    HtmlGenericControl colDiv = new HtmlGenericControl("div");
                    colDiv.Attributes.Add("class", "col-sm-3 m-4 d-inline-block");

                    // Create the card with a link to course.aspx
                    colDiv.InnerHtml = $@"
                        <a href='teachercourse.aspx?id={HttpUtility.UrlEncode(id)}' style='text-decoration:none; color:inherit;'>
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