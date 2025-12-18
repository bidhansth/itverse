using System;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using LMS.Model;
using LMS.Service;
using LMS.Services;
using LMS.Repository;

namespace LMS.CourseManagement
{
    public partial class AddCourse : System.Web.UI.Page
    {
        private readonly CourseService _courseService;
        private readonly TeacherService _teacherService;

        public AddCourse()
        {
            var courseRepository = new CourseRepository();
            _courseService = new CourseService(courseRepository);

            var teacherRepository = new TeacherRepository();
            _teacherService = new TeacherService(teacherRepository);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeForm();
                LoadTeachers();

                string idParam = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idParam) && int.TryParse(idParam, out int courseId))
                {
                    LoadCourseDetails(courseId);
                }
            }
        }

        private void LoadCourseDetails(int courseId)
        {
            try
            {
                Course course = _courseService.GetCourse(courseId);
                if (course != null)
                {
                    // Update UI for edit mode
                    iconTitle.Attributes["class"] = "fas fa-edit me-3";
                    litPageTitle.Text = "Edit Course";
                    litPageSubtitle.Text = "Update the course information";
                    litBreadcrumb.Text = "Edit Course";
                    pnlEditMode.Visible = true;

                    // Populate form fields
                    txtCourseName.Text = course.CourseName;
                    txtDescription.Text = course.Description;
                    txtDuration.Text = course.Duration;
                    txtYouTubeLink.Text = course.YouTubeLink;
                    ddlTeacher.SelectedValue = course.TeacherId.ToString();
                    chkIsActive.Checked = course.IsActive;

                    // Update button text
                    btnSave.Text = "UPDATE COURSE";

                    // Load existing thumbnail if available
                    if (!string.IsNullOrEmpty(course.Thumbnail))
                    {
                        string script = $@"
                            document.addEventListener('DOMContentLoaded', function() {{
                                document.getElementById('thumbnailImage').src = '{ResolveUrl(course.Thumbnail)}';
                                document.getElementById('thumbnailImage').style.display = 'block';
                                document.getElementById('thumbnailPlaceholder').style.display = 'none';
                            }});
                        ";
                        ClientScript.RegisterStartupScript(this.GetType(), "LoadThumbnail", script, true);
                    }
                }
            }
            catch (Exception ex)
            {
                string script = $"showErrorMessage('{EscapeJavaScriptString(ex.Message)}');";
                ClientScript.RegisterStartupScript(this.GetType(), "ShowError", script, true);
            }
        }

        private void InitializeForm()
        {
            // Clear any previous data
            ClearForm();
        }

        private void LoadTeachers()
        {
            try
            {
                var teachers = _teacherService.ListAllTeachers();

                ddlTeacher.Items.Clear();
                ddlTeacher.Items.Add(new ListItem("-- Select Teacher --", ""));

                foreach (var teacher in teachers)
                {
                    // Only show active teachers
                    if (teacher.IsActive)
                    {
                        string displayText = $"{teacher.FullName} ({teacher.Email})";
                        ddlTeacher.Items.Add(new ListItem(displayText, teacher.TeacherId.ToString()));
                    }
                }

                // If no active teachers found, show a message
                if (ddlTeacher.Items.Count == 1) // Only the default "Select Teacher" item
                {
                    ddlTeacher.Items.Add(new ListItem("No active teachers available", ""));
                    ddlTeacher.Enabled = false;
                }
            }
            catch (Exception ex)
            {
                string script = $"showErrorMessage('Error loading teachers: {EscapeJavaScriptString(ex.Message)}');";
                ClientScript.RegisterStartupScript(this.GetType(), "ShowError", script, true);

                // Add a fallback option
                ddlTeacher.Items.Clear();
                ddlTeacher.Items.Add(new ListItem("-- Error loading teachers --", ""));
                ddlTeacher.Enabled = false;
            }
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
                        var course = UpdateCourseFromForm();
                        bool updated = _courseService.UpdateCourseDetails(course);

                        if (updated)
                        {
                            string script = $"showSuccessMessage('Course \"{course.CourseName}\" has been successfully updated.');";
                            ClientScript.RegisterStartupScript(this.GetType(), "ShowSuccess", script, true);
                        }
                        else
                        {
                            string script = "showErrorMessage('Failed to update course.');";
                            ClientScript.RegisterStartupScript(this.GetType(), "ShowError", script, true);
                        }
                    }
                    else
                    {
                        var course = CreateCourseFromForm();
                        int courseId = _courseService.CreateCourse(course);

                        // Show success message using client-side script
                        string script = $"showSuccessMessage('Course \"{course.CourseName}\" has been successfully created with ID: {courseId}');";
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
            Response.Redirect("CourseManagement.aspx");
        }

        private Course CreateCourseFromForm()
        {
            var course = new Course
            {
                CourseName = txtCourseName.Text.Trim(),
                Description = txtDescription.Text.Trim(),
                Duration = !string.IsNullOrWhiteSpace(txtDuration.Text) ? txtDuration.Text.Trim() : null,
                YouTubeLink = !string.IsNullOrWhiteSpace(txtYouTubeLink.Text) ? txtYouTubeLink.Text.Trim() : null,
                TeacherId = Convert.ToInt32(ddlTeacher.SelectedValue),
                Thumbnail = HandleThumbnailUpload(),
                IsActive = chkIsActive.Checked,
                CreatedAt = DateTime.Now
            };

            return course;
        }

        private Course UpdateCourseFromForm()
        {
            var course = new Course
            {
                CourseId = Convert.ToInt32(Request.QueryString["id"]),
                CourseName = txtCourseName.Text.Trim(),
                Description = txtDescription.Text.Trim(),
                Duration = !string.IsNullOrWhiteSpace(txtDuration.Text) ? txtDuration.Text.Trim() : null,
                YouTubeLink = !string.IsNullOrWhiteSpace(txtYouTubeLink.Text) ? txtYouTubeLink.Text.Trim() : null,
                TeacherId = Convert.ToInt32(ddlTeacher.SelectedValue),
                Thumbnail = HandleThumbnailUpload(),
                IsActive = chkIsActive.Checked,
                UpdatedAt = DateTime.Now
            };

            return course;
        }

        private string HandleThumbnailUpload()
        {
            if (fuThumbnail.HasFile)
            {
                try
                {
                    // Validate file
                    if (!IsValidImageFile(fuThumbnail))
                    {
                        throw new ArgumentException("Please upload a valid image file (JPG, PNG, GIF) smaller than 5MB.");
                    }

                    // Create directory if it doesn't exist
                    string relativeFolder = "~/Uploads/CourseThumbnails/";
                    string uploadsPath = Server.MapPath(relativeFolder);
                    if (!Directory.Exists(uploadsPath))
                    {
                        Directory.CreateDirectory(uploadsPath);
                    }

                    // Generate unique filename
                    string fileExtension = Path.GetExtension(fuThumbnail.FileName);
                    string fileName = $"course_thumbnail_{Guid.NewGuid():N}{fileExtension}";
                    string filePath = Path.Combine(uploadsPath, fileName);

                    // Save file
                    fuThumbnail.SaveAs(filePath);

                    // Return relative path for database storage
                    return $"{relativeFolder}{fileName}";
                }
                catch (Exception ex)
                {
                    throw new Exception($"Error uploading course thumbnail: {ex.Message}");
                }
            }

            // If updating and no new file uploaded, keep existing thumbnail
            if (btnSave.Text.ToUpper().Contains("UPDATE"))
            {
                try
                {
                    var existingCourse = _courseService.GetCourse(Convert.ToInt32(Request.QueryString["id"]));
                    return existingCourse?.Thumbnail;
                }
                catch
                {
                    return null;
                }
            }

            return null; // No file uploaded for new course
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

            // Validate course name length
            if (!string.IsNullOrEmpty(txtCourseName.Text.Trim()) && txtCourseName.Text.Trim().Length < 3)
            {
                errorMessages += "Course name must be at least 3 characters long.\\n";
                isValid = false;
            }

            // Validate course name length (max)
            if (!string.IsNullOrEmpty(txtCourseName.Text.Trim()) && txtCourseName.Text.Trim().Length > 100)
            {
                errorMessages += "Course name cannot exceed 100 characters.\\n";
                isValid = false;
            }

            // Validate description length
            if (!string.IsNullOrEmpty(txtDescription.Text.Trim()) && txtDescription.Text.Trim().Length > 500)
            {
                errorMessages += "Description cannot exceed 500 characters.\\n";
                isValid = false;
            }

            // Validate YouTube URL format if provided
            if (!string.IsNullOrEmpty(txtYouTubeLink.Text.Trim()))
            {
                string youtubeUrl = txtYouTubeLink.Text.Trim();
                if (!IsValidYouTubeUrl(youtubeUrl))
                {
                    errorMessages += "Please enter a valid YouTube URL.\\n";
                    isValid = false;
                }
            }

            // Validate teacher selection
            if (string.IsNullOrEmpty(ddlTeacher.SelectedValue))
            {
                errorMessages += "Please select a teacher for this course.\\n";
                isValid = false;
            }
            else
            {
                // Validate teacher exists and is active
                try
                {
                    int teacherId = Convert.ToInt32(ddlTeacher.SelectedValue);
                    var teacher = _teacherService.GetTeacher(teacherId);
                    if (teacher == null || !teacher.IsActive)
                    {
                        errorMessages += "Selected teacher is not valid or inactive.\\n";
                        isValid = false;
                    }
                }
                catch
                {
                    errorMessages += "Invalid teacher selection.\\n";
                    isValid = false;
                }
            }

            // Validate duration format if provided
            if (!string.IsNullOrEmpty(txtDuration.Text.Trim()) && txtDuration.Text.Trim().Length > 50)
            {
                errorMessages += "Duration cannot exceed 50 characters.\\n";
                isValid = false;
            }

            // Validate thumbnail upload if it's a new course and file is provided
            if (fuThumbnail.HasFile && !IsValidImageFile(fuThumbnail))
            {
                errorMessages += "Please upload a valid image file (JPG, PNG, GIF) smaller than 5MB.\\n";
                isValid = false;
            }

            if (!isValid)
            {
                string script = $"showErrorMessage('{errorMessages}');";
                ClientScript.RegisterStartupScript(this.GetType(), "ValidationError", script, true);
            }

            return isValid;
        }

        private bool IsValidYouTubeUrl(string url)
        {
            if (string.IsNullOrWhiteSpace(url))
                return false;

            try
            {
                // Basic YouTube URL validation
                Uri uri = new Uri(url);
                string host = uri.Host.ToLower();

                return host == "www.youtube.com" ||
                       host == "youtube.com" ||
                       host == "youtu.be" ||
                       host == "m.youtube.com";
            }
            catch
            {
                return false;
            }
        }

        private void ClearForm()
        {
            txtCourseName.Text = "";
            txtDescription.Text = "";
            txtDuration.Text = "";
            txtYouTubeLink.Text = "";
            chkIsActive.Checked = true;

            if (ddlTeacher.Items.Count > 0)
            {
                ddlTeacher.SelectedIndex = 0;
            }

            // Reset thumbnail preview
            string script = @"
                document.addEventListener('DOMContentLoaded', function() {
                    document.getElementById('thumbnailImage').style.display = 'none';
                    document.getElementById('thumbnailPlaceholder').style.display = 'block';
                });
            ";
            ClientScript.RegisterStartupScript(this.GetType(), "ClearThumbnail", script, true);
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
                    // Additional client-side validation
                    function validateCourseForm() {
                        return validateForm(); // This calls the existing JS function
                    }
                ";
                ClientScript.RegisterClientScriptBlock(this.GetType(), "FormValidation", validationScript, true);
            }
        }
    }
}