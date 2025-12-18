using LMS.Models;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace LMS.Pages.User
{
    public partial class ChangeUserPassword : System.Web.UI.Page
    {
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
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            string currentPassword = txtCurrentPassword.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            if (newPassword != confirmPassword)
            {
                lblMessage.CssClass = "text-danger";
                lblMessage.Text = "New password and confirmation do not match.";
                return;
            }

            if (!IsPasswordComplex(newPassword))
            {
                lblMessage.CssClass = "text-danger";
                lblMessage.Text = "Password must be at least 6 characters and contain an uppercase letter, lowercase letter, digit, and special character.";
                return;
            }

            string hashedCurrentPassword = HashPassword(currentPassword);
            string hashedNewPassword = HashPassword(newPassword);

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand checkCmd = new SqlCommand("SELECT Password FROM Students WHERE StudentId = @StudentId", conn);
                checkCmd.Parameters.AddWithValue("@StudentId", student_id);

                string dbPassword = checkCmd.ExecuteScalar()?.ToString();

                if (dbPassword != hashedCurrentPassword)
                {
                    lblMessage.CssClass = "text-danger";
                    lblMessage.Text = "Current password is incorrect.";
                    return;
                }

                SqlCommand updateCmd = new SqlCommand("UPDATE Students SET Password = @NewPassword, UpdatedAt = GETDATE() WHERE StudentId = @StudentId", conn);
                updateCmd.Parameters.AddWithValue("@NewPassword", hashedNewPassword);
                updateCmd.Parameters.AddWithValue("@StudentId", student_id);

                updateCmd.ExecuteNonQuery();

                lblMessage.CssClass = "text-success";
                lblMessage.Text = "Password updated successfully.";
            }
        }

        private bool IsPasswordComplex(string password)
        {
            if (password.Length < 6)
                return false;

            bool hasUpper = false, hasLower = false, hasDigit = false, hasSpecial = false;
            foreach (char c in password)
            {
                if (char.IsUpper(c)) hasUpper = true;
                else if (char.IsLower(c)) hasLower = true;
                else if (char.IsDigit(c)) hasDigit = true;
                else if ("!@#$%^&*()".Contains(c)) hasSpecial = true;
            }

            return hasUpper && hasLower && hasDigit && hasSpecial;
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                string saltedPassword = password + "your_salt_here";  // Replace with secure salt in production
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(saltedPassword));
                return Convert.ToBase64String(bytes);
            }
        }
    }
}
