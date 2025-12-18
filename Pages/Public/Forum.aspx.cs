using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Pages.Public
{
    public partial class Forum : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        private int courseId;
        public string student_id;

        protected void Page_Load(object sender, EventArgs e)
        {
            Session["student_id"] = 1;

            if (Session["student_id"] == null)
            {
                Response.Redirect("LoginPage.aspx");
            }
            else
            {
                student_id = Session["student_id"].ToString();
            }
            if (!IsPostBack)
            {
                if (int.TryParse(Request.QueryString["id"], out courseId))
                {
                    LoadCourse();
                    LoadQuestions(courseId);
                    btnAsk.NavigateUrl = $"Ask.aspx?course_id={courseId}";
                }
                else
                {
                    Response.Redirect("Courses.aspx");
                }
            }
        }
        private void LoadCourse()
        {
            string query = "SELECT CourseName FROM courses WHERE CourseId = @a";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                cmd.Parameters.AddWithValue("@a", courseId);

                string courseName = (string)cmd.ExecuteScalar();
                if (courseName != null)
                {
                    courseTitle.InnerText = courseName;
                }
            }
        }

        private void LoadQuestions(int courseId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                SELECT q.id, q.text, q.created_on, u.firstname, u.lastname
                FROM questions q
                INNER JOIN students u ON q.student_id = u.studentid
                WHERE q.course_id = @courseId
                ORDER BY q.created_on DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@courseId", courseId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        string questionId = reader["id"].ToString();
                        string text = reader["text"].ToString();
                        string name = reader["firstname"].ToString() + " " + reader["lastname"].ToString();
                        string date = Convert.ToDateTime(reader["created_on"]).ToString("yyyy-MM-dd");

                        litQuestions.Text += $@"
                        <div class='card mb-3'>
                            <div class='card-body'>
                                <h5 class='card-title'><a href='Question.aspx?id={questionId}'>{text}</a></h5>
                                <h6 class='card-subtitle mb-2 text-muted'>Asked by {name} on {date}</h6>
                            </div>
                        </div>";
                    }
                }
                else
                {
                    litQuestions.Text = "<p>No questions yet for this subject.</p>";
                }
            }
        }
    }
}