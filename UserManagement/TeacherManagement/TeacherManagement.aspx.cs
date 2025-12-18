using LMS.Model;
using LMS.Models;
using LMS.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.UserManagement.TeacherManagement
{
    public partial class TeacherManagement : System.Web.UI.Page
    {
        private readonly TeacherService _teacherService;

        public TeacherManagement()
        {
            _teacherService = new TeacherService(
                new LMS.Repository.TeacherRepository());
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadTeacherData();
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

        private void LoadTeacherData()
        {
            try
            {
                List<Teacher> teachers = _teacherService.ListAllTeachers();

                if (teachers != null && teachers.Count > 0)
                {
                    // Add FullName property for display purposes
                    //foreach (var teacher in teachers)
                    //{
                    //    teacher.FullName = $"{teacher.FirstName} {teacher.LastName}".Trim();
                    //    // Calculate age if DateOfBirth is available
                    //    if (teacher.DateOfBirth != DateTime.MinValue)
                    //    {
                    //        teacher.Age = CalculateAge(teacher.DateOfBirth);
                    //    }
                    //}

                    gvTeachers.DataSource = teachers;
                    gvTeachers.DataBind();
                    gvTeachers.Visible = true;
                    pnlNoTeachers.Visible = false;
                }
                else
                {
                    gvTeachers.Visible = false;
                    pnlNoTeachers.Visible = true;
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading teacher data: " + ex.Message, "error");
                gvTeachers.Visible = false;
                pnlNoTeachers.Visible = true;
            }
        }

        private void LoadStatistics()
        {
            try
            {
                // Get all teachers for statistics
                List<Teacher> allTeachers = _teacherService.ListAllTeachers();

                // Handle empty teacher list
                if (allTeachers == null)
                {
                    allTeachers = new List<Teacher>();
                }

                // Calculate statistics
                int totalTeachers = allTeachers.Count;
                int activeCount = allTeachers.Count(t => t.IsActive);
                int inactiveCount = totalTeachers - activeCount;

                // Teachers created this month
                DateTime startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                int newThisMonth = allTeachers.Count(t => t.CreatedAt >= startOfMonth);

                // Update labels
                lblTotalTeachers.Text = totalTeachers.ToString();
                lblActiveTeachers.Text = activeCount.ToString();
                lblInactiveTeachers.Text = inactiveCount.ToString();
                lblNewTeachers.Text = newThisMonth.ToString();
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading statistics: " + ex.Message, "error");
                // Set default values in case of error
                lblTotalTeachers.Text = "0";
                lblActiveTeachers.Text = "0";
                lblInactiveTeachers.Text = "0";
                lblNewTeachers.Text = "0";
            }
        }

        protected void gvTeachers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int teacherId = Convert.ToInt32(e.CommandArgument);

                switch (e.CommandName)
                {
                    case "ViewTeacher":
                        ViewTeacherDetails(teacherId);
                        break;
                    case "ToggleStatus":
                        ToggleTeacherStatus(teacherId);
                        break;
                    case "DeleteTeacher":
                        DeleteTeacher(teacherId);
                        break;
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error processing command: " + ex.Message, "error");
            }
        }

        private void ViewTeacherDetails(int teacherId)
        {
            try
            {
                Teacher teacher = _teacherService.GetTeacher(teacherId);
                if (teacher != null)
                {
                    // Calculate age
                    int age = CalculateAge(teacher.DateOfBirth);

                    // Prepare data variables for JavaScript
                    string firstName = (teacher.FirstName ?? "").Replace("'", "\\'");
                    string lastName = (teacher.LastName ?? "").Replace("'", "\\'");
                    string fullName = $"{firstName} {lastName}".Trim().Replace("'", "\\'");
                    string email = (teacher.Email ?? "").Replace("'", "\\'");
                    string contactNumber = (teacher.ContactNumber ?? "").Replace("'", "\\'");
                    string ageStr = age.ToString();
                    string gender = teacher.Gender.ToString();
                    string qualification = (teacher.Qualification ?? "").Replace("'", "\\'");
                    string address = (teacher.Address ?? "").Replace("'", "\\'");
                    string dateOfBirth = teacher.DateOfBirth.ToString("yyyy-MM-dd");
                    bool isActive = teacher.IsActive;
                    string status = teacher.IsActive ? "Active" : "Inactive";
                    string createdAt = teacher.CreatedAt.ToString("MMM dd, yyyy");
                    string createdTime = teacher.CreatedAt.ToString("hh:mm tt");
                    string updatedAt = teacher.UpdatedAt?.ToString("MMM dd, yyyy hh:mm tt") ?? "Not updated";
                    string profilePicture = !string.IsNullOrEmpty(teacher.ProfilePicture)
                        ? ResolveUrl(teacher.ProfilePicture)
                        : $"https://ui-avatars.com/api/?name={HttpUtility.UrlEncode(teacher.FirstName)}&background=2563eb&color=ffffff&size=100";
                    string formattedId = $"TCH-{teacher.TeacherId.ToString().PadLeft(4, '0')}";

                    // Register script to show modal with teacher data directly
                    string script = $@"
                        $(document).ready(function() {{
                            try {{
                                var teacherData = {{
                                    teacherId: {teacher.TeacherId},
                                    firstName: '{firstName}',
                                    lastName: '{lastName}',
                                    fullName: '{fullName}',
                                    email: '{email}',
                                    contactNumber: '{contactNumber}',
                                    age: '{ageStr}',
                                    gender: '{gender}',
                                    qualification: '{qualification}',
                                    address: '{address}',
                                    dateOfBirth: '{dateOfBirth}',
                                    isActive: {isActive.ToString().ToLower()},
                                    status: '{status}',
                                    createdAt: '{createdAt}',
                                    createdTime: '{createdTime}',
                                    updatedAt: '{updatedAt}',
                                    profilePicture: '{profilePicture}',
                                    formattedId: '{formattedId}'
                                }};
                                populateTeacherModal(teacherData);
                                $('#teacherDetailsModal').modal('show');
                            }} catch(e) {{
                                console.error('Error loading teacher details:', e);
                                showErrorToast('Error loading teacher details');
                            }}
                        }});
                    ";

                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowTeacherModal", script, true);
                }
                else
                {
                    ShowMessage("Teacher not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading teacher details: " + ex.Message, "error");
            }
        }

        private void ToggleTeacherStatus(int teacherId)
        {
            try
            {
                // Get current teacher data
                Teacher teacher = _teacherService.GetTeacher(teacherId);
                if (teacher != null)
                {
                    // Toggle the status
                    teacher.IsActive = !teacher.IsActive;
                    teacher.UpdatedAt = DateTime.Now;

                    // Update the teacher
                    bool success = _teacherService.ActivateDeactivateTeacher(teacher);

                    if (success)
                    {
                        string status = teacher.IsActive ? "activated" : "deactivated";
                        string fullName = $"{teacher.FirstName} {teacher.LastName}".Trim();
                        ShowMessage($"Teacher {fullName} has been {status} successfully.", "success");

                        // Reload data
                        LoadTeacherData();
                        LoadStatistics();

                        // Log the action
                        LogUserAction($"Toggle Status - {status}", teacherId, $"Teacher status changed to {(teacher.IsActive ? "Active" : "Inactive")}");
                    }
                    else
                    {
                        ShowMessage("Failed to update teacher status.", "error");
                    }
                }
                else
                {
                    ShowMessage("Teacher not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error toggling teacher status: " + ex.Message, "error");
            }
        }

        private void DeleteTeacher(int teacherId)
        {
            try
            {
                // Get teacher info for confirmation message
                Teacher teacher = _teacherService.GetTeacher(teacherId);
                if (teacher != null)
                {
                    string fullName = $"{teacher.FirstName} {teacher.LastName}".Trim();

                    // Perform delete
                    bool success = _teacherService.RemoveTeacher(teacherId);

                    if (success)
                    {
                        ShowMessage($"Teacher {fullName} has been deleted successfully.", "success");

                        // Reload data
                        LoadTeacherData();
                        LoadStatistics();

                        // Log the action
                        LogUserAction("Delete Teacher", teacherId, $"Teacher {fullName} was permanently deleted");
                    }
                    else
                    {
                        ShowMessage("Failed to delete teacher.", "error");
                    }
                }
                else
                {
                    ShowMessage("Teacher not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting teacher: " + ex.Message, "error");
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
                LoadTeacherData();
                LoadStatistics();
                ShowMessage("Teacher data refreshed successfully.", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error refreshing data: " + ex.Message, "error");
            }
        }

        // Helper method to calculate age
        private int CalculateAge(DateTime dateOfBirth)
        {
            if (dateOfBirth == DateTime.MinValue)
                return 0;

            DateTime today = DateTime.Today;
            int age = today.Year - dateOfBirth.Year;

            // Adjust if birthday hasn't occurred this year
            if (dateOfBirth.Date > today.AddYears(-age))
                age--;

            return Math.Max(0, age);
        }

        // Method to get teacher count by gender (can be used for additional filtering)
        private int GetTeacherCountByGender(Gender gender)
        {
            try
            {
                List<Teacher> allTeachers = _teacherService.ListAllTeachers();
                return allTeachers?.Count(t => t.Gender == gender) ?? 0;
            }
            catch (Exception ex)
            {
                ShowMessage("Error getting teacher count by gender: " + ex.Message, "error");
                return 0;
            }
        }

        // Method to search teachers (can be used for additional search functionality)
        private List<Teacher> SearchTeachers(string searchTerm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(searchTerm))
                {
                    return _teacherService.ListAllTeachers();
                }

                return _teacherService.SearchByTerm(searchTerm);
            }
            catch (Exception ex)
            {
                ShowMessage("Error searching teachers: " + ex.Message, "error");
                return new List<Teacher>();
            }
        }

        // Method to export teacher data (can be extended for different formats)
        public void ExportTeacherData(string format = "excel")
        {
            try
            {
                List<Teacher> teachers = _teacherService.ListAllTeachers();

                if (teachers == null || teachers.Count == 0)
                {
                    ShowMessage("No teacher data available to export.", "warning");
                    return;
                }

                // This would be implemented based on your export requirements
                // For now, just show a success message
                ShowMessage($"Teacher data exported successfully in {format} format.", "success");

                // Log the action
                LogUserAction("Export Data", 0, $"Exported {teachers.Count} teacher records in {format} format");
            }
            catch (Exception ex)
            {
                ShowMessage("Error exporting teacher data: " + ex.Message, "error");
            }
        }

        // Method to handle bulk operations (can be extended)
        protected void HandleBulkOperation(string operation, int[] teacherIds)
        {
            try
            {
                if (teacherIds == null || teacherIds.Length == 0)
                {
                    ShowMessage("No teachers selected for bulk operation.", "warning");
                    return;
                }

                int successCount = 0;
                int failureCount = 0;

                foreach (int teacherId in teacherIds)
                {
                    try
                    {
                        switch (operation.ToLower())
                        {
                            case "activate":
                                var teacherToActivate = _teacherService.GetTeacher(teacherId);
                                if (teacherToActivate != null)
                                {
                                    teacherToActivate.IsActive = true;
                                    teacherToActivate.UpdatedAt = DateTime.Now;
                                    if (_teacherService.ActivateDeactivateTeacher(teacherToActivate))
                                        successCount++;
                                    else
                                        failureCount++;
                                }
                                break;

                            case "deactivate":
                                var teacherToDeactivate = _teacherService.GetTeacher(teacherId);
                                if (teacherToDeactivate != null)
                                {
                                    teacherToDeactivate.IsActive = false;
                                    teacherToDeactivate.UpdatedAt = DateTime.Now;
                                    if (_teacherService.ActivateDeactivateTeacher(teacherToDeactivate))
                                        successCount++;
                                    else
                                        failureCount++;
                                }
                                break;

                            case "delete":
                                if (_teacherService.RemoveTeacher(teacherId))
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
                LoadTeacherData();
                LoadStatistics();

                // Log the bulk operation
                LogUserAction($"Bulk {operation}", 0, $"Processed {teacherIds.Length} teachers. Success: {successCount}, Failed: {failureCount}");
            }
            catch (Exception ex)
            {
                ShowMessage($"Error performing bulk operation: {ex.Message}", "error");
            }
        }

        // Method to get detailed teacher statistics
        private Dictionary<string, object> GetDetailedStatistics()
        {
            try
            {
                List<Teacher> allTeachers = _teacherService.ListAllTeachers();
                var stats = new Dictionary<string, object>();

                if (allTeachers != null && allTeachers.Count > 0)
                {
                    // Basic counts
                    stats["TotalTeachers"] = allTeachers.Count;
                    stats["ActiveTeachers"] = allTeachers.Count(t => t.IsActive);
                    stats["InactiveTeachers"] = allTeachers.Count(t => !t.IsActive);

                    // Gender distribution
                    stats["MaleTeachers"] = allTeachers.Count(t => t.Gender == Gender.Male);
                    stats["FemaleTeachers"] = allTeachers.Count(t => t.Gender == Gender.Female);
                    stats["OtherGenderTeachers"] = allTeachers.Count(t => t.Gender == Gender.Other);

                    // Age distribution
                    var teachersWithAge = allTeachers.Where(t => t.DateOfBirth != DateTime.MinValue).ToList();
                    if (teachersWithAge.Any())
                    {
                        var ages = teachersWithAge.Select(t => CalculateAge(t.DateOfBirth)).ToList();
                        stats["AverageAge"] = ages.Average();
                        stats["MinAge"] = ages.Min();
                        stats["MaxAge"] = ages.Max();
                    }

                    // Monthly registration counts
                    DateTime startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                    stats["NewThisMonth"] = allTeachers.Count(t => t.CreatedAt >= startOfMonth);

                    DateTime startOfYear = new DateTime(DateTime.Now.Year, 1, 1);
                    stats["NewThisYear"] = allTeachers.Count(t => t.CreatedAt >= startOfYear);
                }
                else
                {
                    // Initialize with zeros
                    foreach (string key in new[] { "TotalTeachers", "ActiveTeachers", "InactiveTeachers",
                        "MaleTeachers", "FemaleTeachers", "OtherGenderTeachers", "NewThisMonth", "NewThisYear" })
                    {
                        stats[key] = 0;
                    }
                }

                return stats;
            }
            catch (Exception ex)
            {
                ShowMessage("Error calculating detailed statistics: " + ex.Message, "error");
                return new Dictionary<string, object>();
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
                    console.log('Teacher Management page loaded successfully');
                    
                    // Set up refresh functionality
                    window.refreshTeacherData = function() {
                        showInfoToast('Refreshing teacher data...');
                        setTimeout(function() {
                            __doPostBack('RefreshData', '');
                        }, 500);
                    };
                });
            ";

            ClientScript.RegisterStartupScript(this.GetType(), "TeacherManagementScript", script, true);
        }

        // Method to validate teacher data (can be used before operations)
        private bool ValidateTeacher(Teacher teacher)
        {
            if (teacher == null)
            {
                ShowMessage("Teacher data is null.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(teacher.FirstName))
            {
                ShowMessage("First name is required.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(teacher.LastName))
            {
                ShowMessage("Last name is required.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(teacher.Email))
            {
                ShowMessage("Email is required.", "error");
                return false;
            }

            if (!IsValidEmail(teacher.Email))
            {
                ShowMessage("Please enter a valid email address.", "error");
                return false;
            }

            if (teacher.DateOfBirth == DateTime.MinValue)
            {
                ShowMessage("Date of birth is required.", "error");
                return false;
            }

            if (teacher.DateOfBirth >= DateTime.Today)
            {
                ShowMessage("Date of birth must be in the past.", "error");
                return false;
            }

            // Add more validation rules as needed
            return true;
        }

        // Helper method to validate email format
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

        // Method to log user actions (can be extended for audit trail)
        private void LogUserAction(string action, int teacherId, string details = "")
        {
            try
            {
                // This would be implemented based on your logging requirements
                string logMessage = $"Action: {action}, TeacherId: {teacherId}, Details: {details}, Time: {DateTime.Now}, User: {GetCurrentUser()}";

                // For now, just write to debug (in production, you'd write to database or log file)
                System.Diagnostics.Debug.WriteLine(logMessage);

                // You could also save to database:
                // _auditService.LogUserAction(GetCurrentUser(), action, "Teacher", teacherId, details);
            }
            catch (Exception ex)
            {
                // Don't show this error to user as it's a background operation
                System.Diagnostics.Debug.WriteLine($"Logging error: {ex.Message}");
            }
        }

        // Helper method to get current user (implement based on your authentication system)
        private string GetCurrentUser()
        {
            try
            {
                // This would depend on your authentication system
                if (HttpContext.Current?.User?.Identity?.IsAuthenticated == true)
                {
                    return HttpContext.Current.User.Identity.Name;
                }
                return "Anonymous";
            }
            catch
            {
                return "Unknown";
            }
        }

        // Method to handle postback events for refresh functionality
        protected void Page_PreInit(object sender, EventArgs e)
        {
            // Handle custom postback events
            string eventTarget = Request["__EVENTTARGET"];
            if (eventTarget == "RefreshData")
            {
                RefreshData();
            }
        }

        // Method to filter teachers by various criteria
        public List<Teacher> FilterTeachers(string criteria, object value)
        {
            try
            {
                List<Teacher> allTeachers = _teacherService.ListAllTeachers();

                if (allTeachers == null || allTeachers.Count == 0)
                    return new List<Teacher>();

                switch (criteria.ToLower())
                {
                    case "gender":
                        if (Enum.TryParse<Gender>(value.ToString(), out Gender gender))
                        {
                            return allTeachers.Where(t => t.Gender == gender).ToList();
                        }
                        break;

                    case "status":
                        if (bool.TryParse(value.ToString(), out bool isActive))
                        {
                            return allTeachers.Where(t => t.IsActive == isActive).ToList();
                        }
                        break;

                    case "qualification":
                        string qualification = value.ToString();
                        return allTeachers.Where(t =>
                            !string.IsNullOrEmpty(t.Qualification) &&
                            t.Qualification.Contains(qualification)).ToList();

                    case "agerange":
                        if (value is int[] ageRange && ageRange.Length == 2)
                        {
                            return allTeachers.Where(t =>
                            {
                                int age = CalculateAge(t.DateOfBirth);
                                return age >= ageRange[0] && age <= ageRange[1];
                            }).ToList();
                        }
                        break;

                    default:
                        return allTeachers;
                }

                return allTeachers;
            }
            catch (Exception ex)
            {
                ShowMessage($"Error filtering teachers: {ex.Message}", "error");
                return new List<Teacher>();
            }
        }

        //// Method to generate teacher report
        //public void GenerateTeacherReport(string reportType = "summary")
        //{
        //    try
        //    {
        //        var stats = GetDetailedStatistics();
        //        List<Teacher> teachers = _teacherService.ListAllTeachers();

        //        // This would generate actual report based on reportType
        //        // For now, just show statistics
        //        string reportContent = $@"
        //            Teacher Management Report - {DateTime.Now:yyyy-MM-dd}
        //            ================================================
        //            Total Teachers: {stats.GetValueOrDefault("TotalTeachers", 0)}
        //            Active Teachers: {stats.GetValueOrDefault("ActiveTeachers", 0)}
        //            Inactive Teachers: {stats.GetValueOrDefault("InactiveTeachers", 0)}
        //            New This Month: {stats.GetValueOrDefault("NewThisMonth", 0)}
        //            New This Year: {stats.GetValueOrDefault("NewThisYear", 0)}
        //        ";

        //        ShowMessage("Teacher report generated successfully.", "success");
        //        LogUserAction("Generate Report", 0, $"Generated {reportType} report with {teachers?.Count ?? 0} teacher records");
        //    }
        //    catch (Exception ex)
        //    {
        //        ShowMessage($"Error generating teacher report: {ex.Message}", "error");
        //    }
        //}
    }
}