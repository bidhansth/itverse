using LMS.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace LMS.Pages.Public
{
    public partial class Teachers : System.Web.UI.Page
    {
        public int student_id;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LoggedInUser"] != null)
            {
                if (Session["LoggedInUser"] is Student student)
                {
                    student_id = student.StudentId;

                }
            }

            if (!IsPostBack)
            {
                LoadTeachers();
            }
        }

        private void LoadTeachers()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            string query = "SELECT teacherid, firstname, lastname, ProfilePicture, Email, Qualification, ContactNumber FROM teachers";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string id = reader["teacherid"].ToString();
                    string name = reader["firstname"].ToString() + " " + reader["lastname"].ToString();
                    string profilePicture = reader["ProfilePicture"] != DBNull.Value ? "/Images/" + reader["ProfilePicture"].ToString() : "https://placehold.co/50x50/cccccc/000000?text=No+Img"; // Placeholder if no picture
                    string email = reader["Email"].ToString();
                    string qualification = reader["Qualification"].ToString();
                    string contactNumber = reader["ContactNumber"] != DBNull.Value ? reader["ContactNumber"].ToString() : "N/A";

                    HtmlGenericControl colDiv = new HtmlGenericControl("div");
                    colDiv.Attributes.Add("class", "col-sm-3 m-4 d-inline-block");

                    string chatButtonHtml = "";
                    if (student_id > 0)
                    {
                        chatButtonHtml = $"<a href='chat.aspx?id={HttpUtility.UrlEncode(id)}' class='btn btn-primary btn-sm mt-2'>Chat</a>";
                    }

                    // Updated InnerHtml to include profile picture, email, qualification, and contact number
                    colDiv.InnerHtml = $@"
                                <div class='card shadow-sm'>
                                    <div class='card-body text-center'>
                                        <img src='{profilePicture}' class='rounded-circle mb-3' alt='Profile Picture' style='width: 80px; height: 80px; object-fit: cover;'>
                                        <h5 class='card-title mb-1'>{name}</h5>
                                        <p class='card-text text-muted mb-1'><small>{qualification}</small></p>
                                        <p class='card-text text-muted mb-1'><small>{email}</small></p>
                                        <p class='card-text text-muted'><small>{contactNumber}</small></p>
                                        {chatButtonHtml}
                                    </div>
                                </div>";

                    teachersDiv.Controls.Add(colDiv);
                }
            }
        }
    }
}