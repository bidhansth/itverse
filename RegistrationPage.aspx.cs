using System;
using System.IO;
using System.Web.UI;
using LMS.Models;
using LMS.Services;
using LMS.Repository;

namespace LMS.UserManagement.StudentMangement
{
    public partial class RegistrationPage : System.Web.UI.Page
    {
        private readonly StudentService _studentService;

        public RegistrationPage()
        {
            var studentRepository = new StudentRepository();
            _studentService = new StudentService(studentRepository);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialize form if needed
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    var student = CreateStudentFromForm();
                    int studentId = _studentService.RegisterStudent(student);

                    // Show success message
                    lblMessage.Text = $"Registration successful!";
                    lblMessage.Style["color"] = "green";

                    Response.Redirect("~/LoginPage.aspx");
                }
                catch (Exception ex)
                {
                    lblMessage.Text = $"{ex.Message}";
                }
            }
        }

        protected void cvProfilePhoto_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            args.IsValid = false;

            if (fuProfilePhoto.HasFile)
            {
                // Check file size (2MB limit)
                if (fuProfilePhoto.PostedFile.ContentLength > 2 * 1024 * 1024)
                {
                    cvProfilePhoto.ErrorMessage = "File size must be less than 2MB";
                    return;
                }

                // Check file extension
                string[] allowedExtensions = { ".jpg", ".jpeg", ".png" };
                string fileExtension = Path.GetExtension(fuProfilePhoto.FileName).ToLower();

                foreach (string ext in allowedExtensions)
                {
                    if (fileExtension == ext)
                    {
                        args.IsValid = true;
                        return;
                    }
                }

                cvProfilePhoto.ErrorMessage = "Please upload a JPG or PNG image";
            }
        }

        private Student CreateStudentFromForm()
        {
            return new Student
            {
                FirstName = txtFirstName.Text.Trim(),
                LastName = txtLastName.Text.Trim(),
                Email = txtEmail.Text.Trim().ToLower(),
                DateOfBirth = Convert.ToDateTime(txtDateOfBirth.Text),
                ContactNumber = !string.IsNullOrWhiteSpace(txtContactNumber.Text) ? txtContactNumber.Text.Trim() : null,
                Gender = GetSelectedGender(),
                Password = HashPassword(txtPassword.Text.Trim()),
                ProfilePicture = HandleProfilePhotoUpload(),
                IsActive = true,
                CreatedAt = DateTime.Now
            };
        }

        private string HandleProfilePhotoUpload()
        {
            if (fuProfilePhoto.HasFile && fuProfilePhoto.PostedFile.ContentLength > 0)
            {
                try
                {
                    // Create directory if it doesn't exist
                    string uploadFolder = Server.MapPath("~/Uploads/ProfilePhotos/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    // Generate unique filename
                    string fileExtension = Path.GetExtension(fuProfilePhoto.FileName);
                    string fileName = $"photo_{Guid.NewGuid():N}{fileExtension}";
                    string filePath = Path.Combine(uploadFolder, fileName);

                    // Save file
                    fuProfilePhoto.SaveAs(filePath);

                    // Return relative path for database storage
                    return $"/Uploads/ProfilePhotos/{fileName}";
                }
                catch (Exception ex)
                {
                    throw new Exception($"Error uploading profile photo: {ex.Message}");
                }
            }

            return null; // No photo uploaded
        }

        private Gender GetSelectedGender()
        {
            string selectedGender = hdnGender.Value;

            switch (selectedGender?.ToLower())
            {
                case "male":
                    return Gender.Male;
                case "female":
                    return Gender.Female;
                case "other":
                    return Gender.Other;
                default:
                    throw new ArgumentException("Please select a valid gender.");
            }
        }

        private string HashPassword(string password)
        {
            // Implement proper password hashing here
            // This is a placeholder - use BCrypt, Argon2, or similar in production
            // For now, using SHA256 with salt (replace with proper hashing in production)
            using (var sha256 = System.Security.Cryptography.SHA256.Create())
            {
                string saltedPassword = password + "your_salt_here"; // Use a proper salt generation
                byte[] hashedBytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(saltedPassword));
                return Convert.ToBase64String(hashedBytes);
            }
        }

        private void ClearForm()
        {
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtEmail.Text = "";
            txtDateOfBirth.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            hdnGender.Value = "";

            // Reset photo upload
            ScriptManager.RegisterStartupScript(this, GetType(), "ResetPhoto",
                @"document.getElementById('photoPreview').style.display = 'none';
                  document.getElementById('photoPlaceholder').style.display = 'block';", true);
        }
    }
}