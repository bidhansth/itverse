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
    public partial class SearchCourse : System.Web.UI.Page
    {
        public string searchParam;
        protected void Page_Load(object sender, EventArgs e)
        {
            searchParam = Request.QueryString["q"];

            if (!IsPostBack)
            {
                SearchCourses();
            }
        }
        private void SearchCourses()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            string query = "SELECT CourseId,CourseName FROM courses where CourseName like @a";


            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                cmd.Parameters.AddWithValue("@a", "%" + searchParam + "%");

                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string id = reader["CourseId"].ToString();
                    string name = reader["CourseName"].ToString();

                    HtmlGenericControl colDiv = new HtmlGenericControl("div");
                    colDiv.Attributes.Add("class", "col-sm-3 m-4 d-inline-block");

                    // Create the card with a link to course.aspx
                    colDiv.InnerHtml = $@"
                        <a href='course.aspx?id={HttpUtility.UrlEncode(id)}' style='text-decoration:none; color:inherit;'>
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