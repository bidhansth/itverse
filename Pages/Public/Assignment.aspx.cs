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
    public partial class Assignment : System.Web.UI.Page
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
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT CourseId, CourseName FROM courses ORDER BY CourseName";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    conn.Open();

                    ddlCourse.DataSource = cmd.ExecuteReader();
                    ddlCourse.DataTextField = "CourseName";
                    ddlCourse.DataValueField = "CourseId";
                    ddlCourse.DataBind();

                    ddlCourse.Items.Insert(0, new ListItem("-- Select Course --", "0"));
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading courses. Please try again." + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;

                System.Diagnostics.Debug.WriteLine("LoadCourses Error: " + ex.Message);
            }
        }

        protected void btnInsert_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";

            try
            {
                string title = txtTitle.Text.Trim();
                string description = txtDescription.Text.Trim();
                string deadlineText = txtDeadline.Text.Trim();
                string courseValue = ddlCourse.SelectedValue;

                // Validate required fields
                if (string.IsNullOrEmpty(title))
                {
                    lblMessage.Text = "Please enter an assignment title.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                if (string.IsNullOrEmpty(description))
                {
                    lblMessage.Text = "Please enter an assignment description.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                if (string.IsNullOrEmpty(deadlineText))
                {
                    lblMessage.Text = "Please select a deadline date.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                if (courseValue == "0" || string.IsNullOrEmpty(courseValue))
                {
                    lblMessage.Text = "Please select a course.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // Parse date and course ID
                DateTime deadline;
                if (!DateTime.TryParse(deadlineText, out deadline))
                {
                    lblMessage.Text = "Please enter a valid deadline date.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                int courseId;
                if (!int.TryParse(courseValue, out courseId))
                {
                    lblMessage.Text = "Please select a valid course.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // Insert into database
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "INSERT INTO assignments (title, deadline, description, course_id) VALUES (@Title, @Deadline, @Description, @CourseId)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Deadline", deadline);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);

                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        lblMessage.Text = "Assignment inserted successfully!";
                        lblMessage.ForeColor = System.Drawing.Color.Green;

                        // Clear form after successful insertion
                        ClearForm();
                    }
                    else
                    {
                        lblMessage.Text = "Failed to insert assignment.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                lblMessage.Text = "Database error: " + sqlEx.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("SQL Error: " + sqlEx.Message);
            }
            catch (Exception ex)
            {
                lblMessage.Text = "An error occurred: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("General Error: " + ex.Message);
            }
        }

        private void ClearForm()
        {
            txtTitle.Text = "";
            txtDescription.Text = "";
            txtDeadline.Text = "";
            ddlCourse.SelectedIndex = 0;
        }
    }
  }
