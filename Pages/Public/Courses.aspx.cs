using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace LMS.Pages.Public
{
    public partial class Courses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourses();
            }
        }

        private void LoadCourses()
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT CourseId, CourseName, Description, Thumbnail FROM Courses WHERE IsActive = 1";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string id = reader["CourseId"].ToString();
                    string name = reader["CourseName"].ToString();
                    string desc = reader["Description"].ToString();
                    string thumb = reader["Thumbnail"].ToString();
                    string thumbUrl = ResolveUrl(thumb);

                    // Build each card
                    string cardHtml = $@"
                <div class='col-md-4 mb-4'>
                    <a href='course.aspx?id={id}' class='course-card'>
                        <div class='card h-100 shadow-sm'>
                            <img src='{thumbUrl}' class='card-img-top' alt='{name}' />
                            <div class='card-body'>
                                <h5 class='card-title'>{name}</h5>
                                <p class='card-text'>{desc}</p>
                            </div>
                        </div>
                    </a>
                </div>";

                    courseContainer.InnerHtml += cardHtml;
                }
            }
        }

    }
}