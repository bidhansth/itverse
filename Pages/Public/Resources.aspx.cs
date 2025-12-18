using LMS.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Pages.Public
{
    public partial class Resources : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        private string idParam;
        public int student_id = 0;


        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["LoggedInUser"] != null)
            {
                if (Session["LoggedInUser"] is Student student)
                {
                    student_id = student.StudentId;

                }
            }

            idParam = Request.QueryString["id"];
            if (!IsPostBack)
            {
                LoadCourse();
                LoadFiles();
            }
        }

        private void LoadCourse()
        {
            string query = "SELECT CourseName FROM courses WHERE CourseId = @a";

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


        private void LoadFiles()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT id, title FROM resources where course_id = @a";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                cmd.Parameters.AddWithValue("@a", idParam);

                GridView1.DataSource = cmd.ExecuteReader();
                GridView1.DataBind();
                GridView1.Columns[0].Visible = false;

            }
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DownloadFile")
            {
                if (student_id == 0)
                {
                    Response.Write("<script>alert('You must be logged in to download resources.');</script>");
                    return;
                }


                int rowIndex = Convert.ToInt32(e.CommandArgument);
                string fileId = GridView1.Rows[rowIndex].Cells[0].Text;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT path, type FROM resources WHERE id = @id";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@id", fileId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        string path = Server.MapPath("~/Resources/" + reader["path"].ToString());
                        string type = reader["type"].ToString();

                        Response.Clear();
                        Response.ContentType = type;
                        Response.AppendHeader("Content-Disposition", $"attachment; fileid={fileId}");
                        Response.TransmitFile(path);
                        Response.End();
                    }
                }
            }
        }
    }
}