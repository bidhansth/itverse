using LMS.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Pages.User
{
    public partial class EditProfile : System.Web.UI.Page
    {
        public string connstr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        public int student_id;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LoggedInUser"] != null)
            {
                if (Session["LoggedInUser"] is Student student)
                {
                    student_id = student.StudentId;
                    Session["student_id"] = student.StudentId;
                }
            }
            else
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        private void LoadProfile()
        {
            using (SqlConnection conn = new SqlConnection(connstr))
            {
                string query = "SELECT * FROM Students WHERE StudentId = @StudentId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@StudentId", student_id);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtEmail.Text = reader["Email"].ToString();
                    txtFirstName.Text = reader["FirstName"].ToString();
                    txtLastName.Text = reader["LastName"].ToString();
                    txtDOB.Text = Convert.ToDateTime(reader["DateOfBirth"]).ToString("yyyy-MM-dd");
                    ddlGender.SelectedValue = reader["Gender"].ToString();
                    txtContact.Text = reader["ContactNumber"].ToString();
                    imgProfile.ImageUrl = reader["ProfilePicture"].ToString();
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string profilePicFileName = null;

            if (fuProfilePic.HasFile)
            {
                string ext = Path.GetExtension(fuProfilePic.FileName);
                if (ext == ".jpg" || ext == ".png" || ext == ".jpeg")
                {
                    string uniqueName = "profile_" + student_id + "_" + DateTime.Now.Ticks + ext;
                    string savePath = Server.MapPath("/Images/students/") + uniqueName;
                    fuProfilePic.SaveAs(savePath);
                    profilePicFileName = "/Images/students/" + uniqueName;
                }
            }

            using (SqlConnection conn = new SqlConnection(connstr))
            {
                string query = @"UPDATE Students SET 
                                 FirstName = @FirstName,
                                 LastName = @LastName,
                                 DateOfBirth = @DOB,
                                 Gender = @Gender,
                                 ContactNumber = @Contact,
                                 UpdatedAt = GETDATE()";

                if (profilePicFileName != null)
                    query += ", ProfilePicture = @ProfilePicture";

                query += " WHERE StudentId = @StudentId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                cmd.Parameters.AddWithValue("@DOB", txtDOB.Text);
                cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
                cmd.Parameters.AddWithValue("@Contact", txtContact.Text.Trim());
                cmd.Parameters.AddWithValue("@StudentId", student_id);

                if (profilePicFileName != null)
                    cmd.Parameters.AddWithValue("@ProfilePicture", profilePicFileName);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Profile updated successfully!";
        }
    }
}