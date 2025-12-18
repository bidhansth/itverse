using System;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using LMS.Models;
using LMS.Services;
using LMS.Repository;

namespace LMS.UserManagement.StudentMangement
{
    public partial class AddStudent : System.Web.UI.Page
    {
        private readonly StudentService _studentService;

        public AddStudent()
        {
            var studentRepository = new StudentRepository();
            _studentService = new StudentService(studentRepository);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeForm();
                string idParam = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idParam))
                {
                    int studentId = int.Parse(idParam);
                    LoadStudentDetails(studentId); // method to get student from DB
                }
            }
        }

        private void LoadStudentDetails(int studentId)
        {
            Student student = _studentService.GetStudentById(studentId); // from service/repo layer
            if (student != null)
            {
                iconTitle.Attributes["class"] = "fas fa-user-edit me-3";
                litPageTitle.Text = "Edit Student";
                lblPageSubtitle.InnerText = "Update the student information";
                txtFirstName.Text = student.FirstName;
                txtLastName.Text = student.LastName;
                txtEmail.Text = student.Email;
                txtDateOfBirth.Text = student.DateOfBirth.ToString("yyyy-MM-dd");
                txtAge.Text = student.Age.ToString();
                txtContactNumber.Text = student.ContactNumber;
                btnSave.Text = "UPDATE STUDENT";
            }
        }

        private void InitializeForm()
        {
            // Clear any previous data
            ClearForm();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && ValidateCustomFields())
            {
                try
                {

                    if (btnSave.Text.ToUpper().Contains("UPDATE"))
                    {
                        // Perform update logic
                        var student = EditStudent();
                        bool updated = _studentService.UpdateStudentProfile(student);

                        if (updated)
                        {
                            string script = $"showSuccessMessage('Student {student.FullName} has been successfully updated.');";
                            ClientScript.RegisterStartupScript(this.GetType(), "ShowSuccess", script, true);
                        }
                        else
                        {
                            string script = $"showErrorMessage('Failed to update student.');";
                            ClientScript.RegisterStartupScript(this.GetType(), "ShowError", script, true);
                        }
                    }
                    else
                    {
                        var student = CreateStudentFromForm();

                        int studentId = _studentService.RegisterStudent(student);

                        // Show success message using client-side script
                        string script = $"showSuccessMessage('Student has been successfully registered with ID: {studentId}');";
                        ClientScript.RegisterStartupScript(this.GetType(), "ShowSuccess", script, true);

                    }

                }
                catch (Exception ex)
                {
                    // Show error message using client-side script
                    string script = $"showErrorMessage('{EscapeJavaScriptString(ex.Message)}');";
                    ClientScript.RegisterStartupScript(this.GetType(), "ShowError", script, true);
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("StudentManagement.aspx");
        }

        private Student CreateStudentFromForm()
        {
            var student = new Student
            {
                FirstName = txtFirstName.Text.Trim(),
                LastName = txtLastName.Text.Trim(),
                Email = txtEmail.Text.Trim().ToLower(),
                DateOfBirth = Convert.ToDateTime(txtDateOfBirth.Text),
                Gender = GetSelectedGender(),
                ContactNumber = !string.IsNullOrWhiteSpace(txtContactNumber.Text) ? txtContactNumber.Text.Trim() : null,
                Password = HashPassword(txtPassword.Text.Trim()),
                ProfilePicture = HandleProfilePictureUpload(),
                IsActive = true,
                CreatedAt = DateTime.Now
            };

            return student;
        }

        private Student EditStudent()
        {
            var student = new Student
            {
                StudentId =  Convert.ToInt32(Request.QueryString["id"].ToString()),
                FirstName = txtFirstName.Text.Trim(),
                LastName = txtLastName.Text.Trim(),
                Email = txtEmail.Text.Trim().ToLower(),
                DateOfBirth = Convert.ToDateTime(txtDateOfBirth.Text),
                Gender = GetSelectedGender(),
                ContactNumber = !string.IsNullOrWhiteSpace(txtContactNumber.Text) ? txtContactNumber.Text.Trim() : null,
                Password = HashPassword(txtPassword.Text.Trim()),
                ProfilePicture = HandleProfilePictureUpload(),
                UpdatedAt = DateTime.Now
            };

            return student;
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

        private string HandleProfilePictureUpload()
        {
            if (fuProfilePicture.HasFile)
            {
                try
                {
                    // Validate file
                    if (!IsValidImageFile(fuProfilePicture))
                    {
                        throw new ArgumentException("Please upload a valid image file (JPG, PNG, GIF) smaller than 5MB.");
                    }

                    // Create directory if it doesn't exist
                    string relativeFolder = "~/Uploads/ProfilePictures/";
                    string uploadsPath = Server.MapPath(relativeFolder);
                    if (!Directory.Exists(uploadsPath))
                    {
                        Directory.CreateDirectory(uploadsPath);
                    }

                    // Generate unique filename
                    string fileExtension = Path.GetExtension(fuProfilePicture.FileName);
                    string fileName = $"profile_{Guid.NewGuid():N}{fileExtension}";
                    string filePath = Path.Combine(uploadsPath, fileName);

                    // Save file
                    fuProfilePicture.SaveAs(filePath);

                    // Return relative path for database storage
                    return $"{relativeFolder}{fileName}";
                }
                catch (Exception ex)
                {
                    throw new Exception($"Error uploading profile picture: {ex.Message}");
                }
            }

            return null; // No file uploaded
        }

        private bool IsValidImageFile(FileUpload fileUpload)
        {
            // Check file size (5MB limit)
            if (fileUpload.PostedFile.ContentLength > 5 * 1024 * 1024)
            {
                return false;
            }

            // Check file extension
            string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };
            string fileExtension = Path.GetExtension(fileUpload.FileName).ToLower();

            foreach (string ext in allowedExtensions)
            {
                if (fileExtension == ext)
                {
                    return true;
                }
            }

            return false;
        }

        private bool ValidateCustomFields()
        {
            bool isValid = true;
            string errorMessages = "";

            // Validate gender selection
            if (string.IsNullOrEmpty(hdnGender.Value))
            {
                errorMessages += "Please select a gender.\\n";
                isValid = false;
            }

            // Validate age (should be reasonable)
            if (!string.IsNullOrEmpty(txtDateOfBirth.Text))
            {
                DateTime dob = Convert.ToDateTime(txtDateOfBirth.Text);
                int age = DateTime.Today.Year - dob.Year;
                if (dob.Date > DateTime.Today.AddYears(-age)) age--;

                if (age < 3 || age > 100)
                {
                    errorMessages += "Age must be between 3 and 100 years.\\n";
                    isValid = false;
                }

                if (dob > DateTime.Today)
                {
                    errorMessages += "Date of birth cannot be in the future.\\n";
                    isValid = false;
                }
            }

            // Validate email uniqueness (this will be handled by the service layer)
            // Validate password strength
            if (!string.IsNullOrEmpty(txtPassword.Text))
            {
                if (txtPassword.Text.Length < 6)
                {
                    errorMessages += "Password must be at least 6 characters long.\\n";
                    isValid = false;
                }

                if (txtPassword.Text != txtConfirmPassword.Text)
                {
                    errorMessages += "Passwords do not match.\\n";
                    isValid = false;
                }
            }

            // Additional custom validations can be added here

            if (!isValid)
            {
                string script = $"showErrorMessage('{errorMessages}');";
                ClientScript.RegisterStartupScript(this.GetType(), "ValidationError", script, true);
            }

            return isValid;
        }

        private void ClearForm()
        {
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtEmail.Text = "";
            txtDateOfBirth.Text = "";
            txtAge.Text = "";
            txtContactNumber.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            hdnGender.Value = "";

            // Clear file upload
            // Note: FileUpload control cannot be cleared programmatically for security reasons

            // Reset gender selection UI
            string script = @"
                document.querySelectorAll('.gender-card').forEach(card => {
                    card.classList.remove('selected');
                });
            ";
            ClientScript.RegisterStartupScript(this.GetType(), "ClearGender", script, true);
        }

        private string EscapeJavaScriptString(string input)
        {
            if (string.IsNullOrEmpty(input))
                return "";

            return input.Replace("\\", "\\\\")
                       .Replace("'", "\\'")
                       .Replace("\"", "\\\"")
                       .Replace("\r", "\\r")
                       .Replace("\n", "\\n")
                       .Replace("\t", "\\t");
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // Ensure client-side validation is set up properly
            if (!ClientScript.IsClientScriptBlockRegistered("FormValidation"))
            {
                string validationScript = @"
                    // Additional client-side validation can be added here
                    function validateStudentForm() {
                        return validateForm(); // This calls the existing JS function
                    }
                ";
                ClientScript.RegisterClientScriptBlock(this.GetType(), "FormValidation", validationScript, true);
            }
        }
    }
}