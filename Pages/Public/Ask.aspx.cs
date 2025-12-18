using LMS.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Pages.Public
{
    public partial class Ask : System.Web.UI.Page
    {
        public int student_id;
        protected void Page_Load(object sender, EventArgs e)
        {
            // Require login
            if (Session["LoggedInUser"] is Student student)
            {
                student_id = student.StudentId;
            }
            else { 
                Response.Redirect("~/LoginPage.aspx");
            }

            // Require course ID in URL
            if (Request.QueryString["course_id"] == null)
            {
                Response.Write("Course ID missing in URL.");
                Response.End();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string questionText = txtQuestion.Text.Trim();
            int studentId = Convert.ToInt32(student_id);
            int courseId = Convert.ToInt32(Request.QueryString["course_id"]);


            if (string.IsNullOrWhiteSpace(questionText))
            {
                lblStatus.Text = "Please enter your question.";
                return;
            }

            if (questionText.All(char.IsDigit))
            {
                lblStatus.Text = "Question cannot be only numbers.";
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "INSERT INTO questions (text, student_id, course_id) VALUES (@text, @student_id, @course_id)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@text", questionText);
                cmd.Parameters.AddWithValue("@student_id", studentId);
                cmd.Parameters.AddWithValue("@course_id", courseId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            // Redirect to forum or course detail
            Response.Redirect("~/Pages/Public/forum.aspx?id=" + courseId);
        }
    }
}