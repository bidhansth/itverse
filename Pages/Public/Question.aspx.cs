using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Pages.Public
{
    public partial class Question : System.Web.UI.Page
    {
        private int questionId;
        private string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        public string student_id;

        protected void Page_Load(object sender, EventArgs e)
        {
            //set session id for testing purposes
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
                if (Request.QueryString["id"] == null || !int.TryParse(Request.QueryString["id"], out questionId))
                {
                    Response.Redirect("Courses.aspx");
                    return;
                }

                LoadQuestion(questionId);
                LoadComments(questionId);
            }
        }

        private void LoadQuestion(int qId)
        {

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                SELECT q.text, q.created_on, u.firstname, u.lastname 
                FROM questions q
                JOIN students u ON q.student_id = u.studentid
                WHERE q.id = @id";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", qId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblQuestionText.InnerText = reader["text"].ToString();
                    lblAskerName.InnerText = reader["firstname"].ToString() + " " + reader["lastname"].ToString();
                    lblDate.InnerText = Convert.ToDateTime(reader["created_on"]).ToString("yyyy-MM-dd HH:mm");
                }
                conn.Close();
            }
        }

        private void LoadComments(int qId)
        {

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                SELECT c.text, c.created_on, u.firstname AS username, u.lastname AS lastname
                FROM comments c
                JOIN students u ON c.student_id = u.studentid
                WHERE c.question_id = @qid
                ORDER BY c.created_on DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@qid", qId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptComments.DataSource = dt;
                rptComments.DataBind();
            }
        }

        protected void btnSubmitComment_Click(object sender, EventArgs e)
        {
            if (Session["student_id"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(student_id);
            int qId = Convert.ToInt32(Request.QueryString["id"]);
            string commentText = txtComment.Text.Trim();

            if (string.IsNullOrEmpty(commentText))
                return;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO comments (text, student_id, question_id) VALUES (@text, @user_id, @question_id)";
                SqlCommand cmd = new SqlCommand(sql, conn);

                cmd.Parameters.AddWithValue("@text", commentText);
                cmd.Parameters.AddWithValue("@user_id", userId);
                cmd.Parameters.AddWithValue("@question_id", qId);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            Response.Redirect(Request.RawUrl); // Reload to show new comment
        }
    }
}