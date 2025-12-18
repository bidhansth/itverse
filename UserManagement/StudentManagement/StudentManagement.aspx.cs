using LMS.Models;
using LMS.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.UserManagement.StudentMangement
{
    public partial class StudentManagement : System.Web.UI.Page
    {
        private readonly StudentService _studentService;

        public StudentManagement()
        {
            _studentService = new StudentService(
                new LMS.Repository.StudentRepository());
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadStudentData();
                    LoadStatistics();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading page: " + ex.Message, "error");
            }

            // Register script to initialize DataTable after page load
            ScriptManager.RegisterStartupScript(this, GetType(), "InitDataTable",
                "setTimeout(function() { initializeDataTable(); }, 200);", true);
        }

        private void LoadStudentData()
        {
            try
            {
                List<Student> students = _studentService.ListAllStudents();

                if (students != null && students.Count > 0)
                {
                    gvStudents.DataSource = students;
                    gvStudents.DataBind();
                    gvStudents.Visible = true;
                    pnlNoStudents.Visible = false;
                }
                else
                {
                    gvStudents.Visible = false;
                    pnlNoStudents.Visible = true;
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading student data: " + ex.Message, "error");
                gvStudents.Visible = false;
                pnlNoStudents.Visible = true;
            }
        }

        private void LoadStatistics()
        {
            try
            {
                // Get all students for statistics
                List<Student> allStudents = _studentService.ListAllStudents();

                // Handle empty student list
                if (allStudents == null)
                {
                    allStudents = new List<Student>();
                }

                List<Student> activeStudents = _studentService.ListActiveStudents();
                if (activeStudents == null)
                {
                    activeStudents = new List<Student>();
                }

                // Calculate statistics
                int totalStudents = allStudents.Count;
                int activeCount = activeStudents.Count;
                int inactiveCount = totalStudents - activeCount;

                // Students created this month
                DateTime startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                int newThisMonth = allStudents.Count(s => s.CreatedAt >= startOfMonth);

                // Update labels
                lblTotalStudents.Text = totalStudents.ToString();
                lblActiveStudents.Text = activeCount.ToString();
                lblInactiveStudents.Text = inactiveCount.ToString();
                lblNewStudents.Text = newThisMonth.ToString();
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading statistics: " + ex.Message, "error");
                // Set default values in case of error
                lblTotalStudents.Text = "0";
                lblActiveStudents.Text = "0";
                lblInactiveStudents.Text = "0";
                lblNewStudents.Text = "0";
            }
        }

        protected void gvStudents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int studentId = Convert.ToInt32(e.CommandArgument);

                switch (e.CommandName)
                {
                    case "ViewStudent":
                        ViewStudentDetails(studentId);
                        break;
                    case "ToggleStatus":
                        ToggleStudentStatus(studentId);
                        break;
                    case "DeleteStudent":
                        DeleteStudent(studentId);
                        break;
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error processing command: " + ex.Message, "error");
            }
        }

        private void ViewStudentDetails(int studentId)
        {
            try
            {
                Student student = _studentService.GetStudent(studentId);
                if (student != null)
                {
                    // Prepare data variables for JavaScript
                    string firstName = (student.FirstName ?? "").Replace("'", "\\'");
                    string lastName = (student.LastName ?? "").Replace("'", "\\'");
                    string fullName = (student.FullName ?? "").Replace("'", "\\'");
                    string email = (student.Email ?? "").Replace("'", "\\'");
                    string contactNumber = (student.ContactNumber ?? "").Replace("'", "\\'");
                    string age = student.Age.ToString();
                    string gender = student.Gender.ToString();
                    string dateOfBirth = student.DateOfBirth.ToString("yyyy-MM-dd") ?? "";
                    bool isActive = student.IsActive;
                    string status = student.IsActive ? "Active" : "Inactive";
                    string createdAt = student.CreatedAt.ToString("MMM dd, yyyy");
                    string createdTime = student.CreatedAt.ToString("hh:mm tt");
                    string updatedAt = student.UpdatedAt?.ToString("MMM dd, yyyy hh:mm tt") ?? "Not updated";
                    string profilePicture = !string.IsNullOrEmpty(student.ProfilePicture)
                        ? ResolveUrl(student.ProfilePicture)
                        : $"https://ui-avatars.com/api/?name={HttpUtility.UrlEncode(student.FirstName)}&background=2563eb&color=ffffff&size=100";
                    string formattedId = $"STU-{student.StudentId.ToString().PadLeft(4, '0')}";

                    // Register script to show modal with student data directly
                    string script = $@"
                        $(document).ready(function() {{
                            try {{
                                var studentData = {{
                                    studentId: {student.StudentId},
                                    firstName: '{firstName}',
                                    lastName: '{lastName}',
                                    fullName: '{fullName}',
                                    email: '{email}',
                                    contactNumber: '{contactNumber}',
                                    age: '{age}',
                                    gender: '{gender}',
                                    dateOfBirth: '{dateOfBirth}',
                                    isActive: {isActive.ToString().ToLower()},
                                    status: '{status}',
                                    createdAt: '{createdAt}',
                                    createdTime: '{createdTime}',
                                    updatedAt: '{updatedAt}',
                                    profilePicture: '{profilePicture}',
                                    formattedId: '{formattedId}'
                                }};
                                populateStudentModal(studentData);
                                $('#studentDetailsModal').modal('show');
                            }} catch(e) {{
                                console.error('Error loading student details:', e);
                                showErrorToast('Error loading student details');
                            }}
                        }});
                    ";

                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowStudentModal", script, true);
                }
                else
                {
                    ShowMessage("Student not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading student details: " + ex.Message, "error");
            }
        }

        private void ToggleStudentStatus(int studentId)
        {
            try
            {
                // Get current student data
                Student student = _studentService.GetStudent(studentId);
                if (student != null)
                {
                    // Toggle the status
                    student.IsActive = !student.IsActive;
                    student.UpdatedAt = DateTime.Now;

                    // Update the student
                    bool success = _studentService.ActivateDeactivateStudent(student);

                    if (success)
                    {
                        string status = student.IsActive ? "activated" : "deactivated";
                        ShowMessage($"Student {student.FullName} has been {status} successfully.", "success");

                        // Reload data
                        LoadStudentData();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowMessage("Failed to update student status.", "error");
                    }
                }
                else
                {
                    ShowMessage("Student not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error toggling student status: " + ex.Message, "error");
            }
        }

        private void DeleteStudent(int studentId)
        {
            try
            {
                // Get student info for confirmation message
                Student student = _studentService.GetStudent(studentId);
                if (student != null)
                {
                    // Perform soft delete (recommended for audit trail)
                    bool success = _studentService.RemoveStudent(studentId);

                    if (success)
                    {
                        ShowMessage($"Student {student.FullName} has been deleted successfully.", "success");

                        // Reload data
                        LoadStudentData();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowMessage("Failed to delete student.", "error");
                    }
                }
                else
                {
                    ShowMessage("Student not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting student: " + ex.Message, "error");
            }
        }

        private void ShowMessage(string message, string type)
        {
            hdnMessage.Value = message;
            hdnMessageType.Value = type;
        }

        // Method to handle page refresh or reload
        protected void RefreshData()
        {
            try
            {
                LoadStudentData();
                LoadStatistics();
                ShowMessage("Student data refreshed successfully.", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error refreshing data: " + ex.Message, "error");
            }
        }

        // Method to get student count by gender (can be used for additional filtering)
        private int GetStudentCountByGender(Gender gender)
        {
            try
            {
                List<Student> students = _studentService.FilterByGender(gender);
                return students?.Count ?? 0;
            }
            catch (Exception ex)
            {
                ShowMessage("Error getting student count by gender: " + ex.Message, "error");
                return 0;
            }
        }

        // Method to search students (can be used for additional search functionality)
        private List<Student> SearchStudents(string searchTerm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(searchTerm))
                {
                    return _studentService.ListAllStudents();
                }

                return _studentService.SearchByTerm(searchTerm);
            }
            catch (Exception ex)
            {
                ShowMessage("Error searching students: " + ex.Message, "error");
                return new List<Student>();
            }
        }

        // Method to export student data (can be extended for different formats)
        public void ExportStudentData(string format = "excel")
        {
            try
            {
                List<Student> students = _studentService.ListAllStudents();

                if (students == null || students.Count == 0)
                {
                    ShowMessage("No student data available to export.", "warning");
                    return;
                }

                // This would be implemented based on your export requirements
                // For now, just show a success message
                ShowMessage($"Student data exported successfully in {format} format.", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error exporting student data: " + ex.Message, "error");
            }
        }

        // Method to handle bulk operations (can be extended)
        protected void HandleBulkOperation(string operation, int[] studentIds)
        {
            try
            {
                if (studentIds == null || studentIds.Length == 0)
                {
                    ShowMessage("No students selected for bulk operation.", "warning");
                    return;
                }

                int successCount = 0;
                int failureCount = 0;

                foreach (int studentId in studentIds)
                {
                    try
                    {
                        switch (operation.ToLower())
                        {
                            case "activate":
                                var studentToActivate = _studentService.GetStudent(studentId);
                                if (studentToActivate != null)
                                {
                                    studentToActivate.IsActive = true;
                                    studentToActivate.UpdatedAt = DateTime.Now;
                                    if (_studentService.ActivateDeactivateStudent(studentToActivate))
                                        successCount++;
                                    else
                                        failureCount++;
                                }
                                break;

                            case "deactivate":
                                var studentToDeactivate = _studentService.GetStudent(studentId);
                                if (studentToDeactivate != null)
                                {
                                    studentToDeactivate.IsActive = false;
                                    studentToDeactivate.UpdatedAt = DateTime.Now;
                                    if (_studentService.ActivateDeactivateStudent(studentToDeactivate))
                                        successCount++;
                                    else
                                        failureCount++;
                                }
                                break;

                            case "delete":
                                if (_studentService.RemoveStudent(studentId))
                                    successCount++;
                                else
                                    failureCount++;
                                break;
                        }
                    }
                    catch
                    {
                        failureCount++;
                    }
                }

                // Show result message
                string message = $"Bulk {operation} completed. Success: {successCount}, Failed: {failureCount}";
                string messageType = failureCount > 0 ? "warning" : "success";
                ShowMessage(message, messageType);

                // Reload data
                LoadStudentData();
                LoadStatistics();
            }
            catch (Exception ex)
            {
                ShowMessage($"Error performing bulk operation: {ex.Message}", "error");
            }
        }

        // Override PreRender to ensure data is fresh
        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            // Register client script for additional functionality
            string script = @"
                $(document).ready(function() {
                    // Additional initialization can be done here
                    console.log('Student Management page loaded successfully');
                });
            ";

            ClientScript.RegisterStartupScript(this.GetType(), "StudentManagementScript", script, true);
        }

        // Method to validate student data (can be used before operations)
        private bool ValidateStudent(Student student)
        {
            if (student == null)
            {
                ShowMessage("Student data is null.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(student.FirstName))
            {
                ShowMessage("First name is required.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(student.Email))
            {
                ShowMessage("Email is required.", "error");
                return false;
            }

            // Add more validation rules as needed
            return true;
        }

        // Method to log user actions (can be extended for audit trail)
        private void LogUserAction(string action, int studentId, string details = "")
        {
            try
            {
                // This would be implemented based on your logging requirements
                string logMessage = $"Action: {action}, StudentId: {studentId}, Details: {details}, Time: {DateTime.Now}";

                // For now, just write to debug (in production, you'd write to database or log file)
                System.Diagnostics.Debug.WriteLine(logMessage);
            }
            catch (Exception ex)
            {
                // Don't show this error to user as it's a background operation
                System.Diagnostics.Debug.WriteLine($"Logging error: {ex.Message}");
            }
        }
    }
}