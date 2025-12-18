using LMS.Model;
using LMS.Models;
using LMS.Repository;
using LMS.Services;
using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.UserManagement.TeacherManagement
{
    public partial class AddTeacher : System.Web.UI.Page
    {
        private readonly TeacherService _teacherService;

        public AddTeacher()
        {
            var teacherRepository = new TeacherRepository();
            _teacherService = new TeacherService(teacherRepository);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeForm();
                string idParam = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idParam))
                {
                    int teacherId = int.Parse(idParam);
                    LoadTeacherDetails(teacherId); // method to get teacher from DB
                }
            }
        }

        private void LoadTeacherDetails(int teacherId)
        {
            Teacher teacher = _teacherService.GetTeacher(teacherId); // from service/repo layer
            if (teacher != null)
            {
                iconTitle.Attributes["class"] = "fas fa-user-edit me-3";
                litPageTitle.Text = "Edit Teacher";
                lblPageSubtitle.InnerText = "Update the teacher information";
                txtFirstName.Text = teacher.FirstName;
                txtLastName.Text = teacher.LastName;
                txtEmail.Text = teacher.Email;
                txtDateOfBirth.Text = teacher.DateOfBirth.ToString("yyyy-MM-dd");
                txtAge.Text = teacher.Age.ToString();
                txtContactNumber.Text = teacher.ContactNumber;
                txtAddress.Text = teacher.Address;
                txtQualification.Text = teacher.Qualification;
                btnSave.Text = "UPDATE TEACHER";

                // Set gender selection
                string script = $"setTimeout(function() {{ selectGenderOnLoad('{teacher.Gender}'); }}, 500);";
                ClientScript.RegisterStartupScript(this.GetType(), "SetGender", script, true);
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
                        var teacher = EditTeacher();
                        bool updated = _teacherService.UpdateTeacherProfile(teacher);

                        if (updated)
                        {
                            string script = $"showSuccessMessage('Teacher {teacher.FullName} has been successfully updated.');";
                            ClientScript.RegisterStartupScript(this.GetType(), "ShowSuccess", script, true);
                        }
                        else
                        {
                            string script = $"showErrorMessage('Failed to update teacher.');";
                            ClientScript.RegisterStartupScript(this.GetType(), "ShowError", script, true);
                        }
                    }
                    else
                    {
                        var teacher = CreateTeacherFromForm();

                        int teacherId = _teacherService.RegisterTeacher(teacher);

                        // Show success message using client-side script
                        string script = $"showSuccessMessage('Teacher has been successfully registered with ID: {teacherId}');";
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
            Response.Redirect("TeacherManagement.aspx");
        }

        private Teacher CreateTeacherFromForm()
        {
            var teacher = new Teacher
            {
                FirstName = txtFirstName.Text.Trim(),
                LastName = txtLastName.Text.Trim(),
                Email = txtEmail.Text.Trim().ToLower(),
                DateOfBirth = Convert.ToDateTime(txtDateOfBirth.Text),
                Gender = GetSelectedGender(),
                ContactNumber = !string.IsNullOrWhiteSpace(txtContactNumber.Text) ? txtContactNumber.Text.Trim() : null,
                Address = txtAddress.Text.Trim(),
                Qualification = txtQualification.Text.Trim(),
                //Password = HashPassword(txtPassword.Text.Trim()),
                Password = HashPassword(txtPassword.Text.Trim()),
                ProfilePicture = HandleProfilePictureUpload(),
                IsActive = true,
                CreatedAt = DateTime.Now
            };

            return teacher;
        }

        private Teacher EditTeacher()
        {
            var teacher = new Teacher
            {
                TeacherId = Convert.ToInt32(Request.QueryString["id"].ToString()),
                FirstName = txtFirstName.Text.Trim(),
                LastName = txtLastName.Text.Trim(),
                Email = txtEmail.Text.Trim().ToLower(),
                DateOfBirth = Convert.ToDateTime(txtDateOfBirth.Text),
                Gender = GetSelectedGender(),
                ContactNumber = !string.IsNullOrWhiteSpace(txtContactNumber.Text) ? txtContactNumber.Text.Trim() : null,
                Address = txtAddress.Text.Trim(),
                Qualification = txtQualification.Text.Trim(),
                Password = HashPassword(txtPassword.Text.Trim()),
                ProfilePicture = HandleProfilePictureUpload(),
                UpdatedAt = DateTime.Now
            };

            return teacher;
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

            //using (SHA256 sha = SHA256.Create())
            //{
            //    byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
            //    return BitConverter.ToString(bytes).Replace("-", "").ToLower();
            //}

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
                    string fileName = $"teacher_profile_{Guid.NewGuid():N}{fileExtension}";
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

            // Validate age (should be reasonable for teachers)
            if (!string.IsNullOrEmpty(txtDateOfBirth.Text))
            {
                DateTime dob = Convert.ToDateTime(txtDateOfBirth.Text);
                int age = DateTime.Today.Year - dob.Year;
                if (dob.Date > DateTime.Today.AddYears(-age)) age--;

                if (age < 18 || age > 80)
                {
                    errorMessages += "Age must be between 18 and 80 years.\\n";
                    isValid = false;
                }

                if (dob > DateTime.Today)
                {
                    errorMessages += "Date of birth cannot be in the future.\\n";
                    isValid = false;
                }
            }

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

            // Validate address length
            if (!string.IsNullOrEmpty(txtAddress.Text))
            {
                if (txtAddress.Text.Trim().Length < 10)
                {
                    errorMessages += "Address must be at least 10 characters long.\\n";
                    isValid = false;
                }
            }

            // Validate qualification length
            if (!string.IsNullOrEmpty(txtQualification.Text))
            {
                if (txtQualification.Text.Trim().Length < 10)
                {
                    errorMessages += "Qualification must be at least 10 characters long.\\n";
                    isValid = false;
                }
            }

            // Validate email format (additional check)
            if (!string.IsNullOrEmpty(txtEmail.Text))
            {
                if (!IsValidEmail(txtEmail.Text.Trim()))
                {
                    errorMessages += "Please enter a valid email address.\\n";
                    isValid = false;
                }
            }

            // Validate contact number format (if provided)
            if (!string.IsNullOrEmpty(txtContactNumber.Text))
            {
                if (!IsValidPhoneNumber(txtContactNumber.Text.Trim()))
                {
                    errorMessages += "Please enter a valid contact number.\\n";
                    isValid = false;
                }
            }

            if (!isValid)
            {
                string script = $"showErrorMessage('{errorMessages}');";
                ClientScript.RegisterStartupScript(this.GetType(), "ValidationError", script, true);
            }

            return isValid;
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private bool IsValidPhoneNumber(string phoneNumber)
        {
            // Simple phone number validation
            return System.Text.RegularExpressions.Regex.IsMatch(phoneNumber, @"^\+?[1-9]\d{1,14}$");
        }

        private void ClearForm()
        {
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtEmail.Text = "";
            txtDateOfBirth.Text = "";
            txtAge.Text = "";
            txtContactNumber.Text = "";
            txtAddress.Text = "";
            txtQualification.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            hdnGender.Value = "";

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
                    function validateTeacherForm() {
                        return validateForm(); // This calls the existing JS function
                    }
                    
                    // Function to set gender on load (for edit mode)
                    function selectGenderOnLoad(gender) {
                        const genderCards = document.querySelectorAll('.gender-card');
                        genderCards.forEach(card => {
                            card.classList.remove('selected');
                            if (card.textContent.trim().toLowerCase() === gender.toLowerCase()) {
                                card.classList.add('selected');
                                document.getElementById('" + hdnGender.ClientID + @"').value = gender;
                            }
                        });
                    }
                ";
                ClientScript.RegisterClientScriptBlock(this.GetType(), "FormValidation", validationScript, true);
            }
        }
    }
}