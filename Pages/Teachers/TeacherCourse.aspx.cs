using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Pages.Teachers
{
    public partial class TeacherCourse : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        private string idParam;
        protected void Page_Load(object sender, EventArgs e)
        {
            idParam = Request.QueryString["id"];
            if (!IsPostBack)
            {
                LoadCourse();
                int courseId;
                if (int.TryParse(Request.QueryString["id"], out courseId))
                {
                    hlResources.NavigateUrl = $"AddResource.aspx?id={courseId}";
                    hlAssignments.NavigateUrl = $"/Pages/Public/Assignment.aspx";
                    hlForum.NavigateUrl = $"/Pages/Public/Forum.aspx?id={courseId}";
                }
                else
                {
                    Response.Redirect("~/LoginPage.aspx");
                    return;
                }
            }
        }

        private void LoadCourse()
        {
            string query = "SELECT CourseName FROM courses WHERE Courseid = @a";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                cmd.Parameters.AddWithValue("@a", idParam);

                string courseName = (string)cmd.ExecuteScalar();
                if (courseName != null)
                {
                    courseTitle.InnerText = courseName;
                }
            }
        }
    }
}