using LMS.Model;
using LMS.Models;
using LMS.Service;
using LMS.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.CourseManagement
{
    public partial class CourseManagement : System.Web.UI.Page
    {
        private readonly CourseService _courseService;
        private readonly TeacherService _teacherService;

        public CourseManagement()
        {
            _courseService = new CourseService(
                new LMS.Repository.CourseRepository());
            _teacherService = new TeacherService(new LMS.Repository.TeacherRepository ());
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadCourseData();
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

        private void LoadCourseData()
        {
            try
            {
                List<Course> courses = _courseService.ListAllCourses();

                if (courses != null && courses.Count > 0)
                {
                    gvCourses.DataSource = courses;
                    gvCourses.DataBind();
                    gvCourses.Visible = true;
                    pnlNoCourses.Visible = false;
                }
                else
                {
                    gvCourses.Visible = false;
                    pnlNoCourses.Visible = true;
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading course data: " + ex.Message, "error");
                gvCourses.Visible = false;
                pnlNoCourses.Visible = true;
            }
        }

        private void LoadStatistics()
        {
            try
            {
                // Get all courses for statistics
                List<Course> allCourses = _courseService.ListAllCourses();

                // Handle empty course list
                if (allCourses == null)
                {
                    allCourses = new List<Course>();
                }

                List<Course> activeCourses = _courseService.ListActiveCourses();
                if (activeCourses == null)
                {
                    activeCourses = new List<Course>();
                }

                // Calculate statistics
                int totalCourses = allCourses.Count;
                int activeCount = activeCourses.Count;
                int inactiveCount = totalCourses - activeCount;

                // Courses created this month
                DateTime startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                int newThisMonth = allCourses.Count(c => c.CreatedAt >= startOfMonth);

                // Update labels
                lblTotalCourses.Text = totalCourses.ToString();
                lblActiveCourses.Text = activeCount.ToString();
                lblInactiveCourses.Text = inactiveCount.ToString();
                lblNewCourses.Text = newThisMonth.ToString();
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading statistics: " + ex.Message, "error");
                // Set default values in case of error
                lblTotalCourses.Text = "0";
                lblActiveCourses.Text = "0";
                lblInactiveCourses.Text = "0";
                lblNewCourses.Text = "0";
            }
        }

        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int courseId = Convert.ToInt32(e.CommandArgument);

                switch (e.CommandName)
                {
                    case "ViewCourse":
                        ViewCourseDetails(courseId);
                        break;
                    case "ToggleStatus":
                        ToggleCourseStatus(courseId);
                        break;
                    case "DeleteCourse":
                        DeleteCourse(courseId);
                        break;
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error processing command: " + ex.Message, "error");
            }
        }

        [WebMethod]
        public static Course GetCourseDetails(int courseId)
        {
            try
            {
                CourseService courseService = new CourseService(new LMS.Repository.CourseRepository());
                Course course = courseService.GetCourse(courseId);

                if (course != null)
                {
                    // Ensure thumbnail URL is resolved
                    if (!string.IsNullOrEmpty(course.Thumbnail))
                    {
                        HttpContext context = HttpContext.Current;
                        course.Thumbnail = context.Request.Url.GetLeftPart(UriPartial.Authority) +
                                          VirtualPathUtility.ToAbsolute(course.Thumbnail);
                    }
                    return course;
                }
                return null;
            }
            catch
            {
                return null;
            }
        }

        private void ViewCourseDetails(int courseId)
        {
            try
            {
                Course course = _courseService.GetCourse(courseId);
                if (course != null)
                {
                    // Prepare data variables for JavaScript
                    string courseName = (course.CourseName ?? "").Replace("'", "\\'");
                    string description = (course.Description ?? "").Replace("'", "\\'");
                    string duration = (course.Duration ?? "").Replace("'", "\\'");
                    int teacherId = course.TeacherId;
                    var teacher = _teacherService.GetTeacher(teacherId);
                    bool isActive = course.IsActive;
                    string status = course.IsActive ? "Active" : "Inactive";
                    string createdAt = course.CreatedAt.ToString("MMM dd, yyyy");
                    string createdTime = course.CreatedAt.ToString("hh:mm tt");
                    string updatedAt = course.UpdatedAt?.ToString("MMM dd, yyyy hh:mm tt") ?? "Not updated";
                    string thumbnail = !string.IsNullOrEmpty(course.Thumbnail)
                        ? ResolveUrl(course.Thumbnail)
                        : "https://via.placeholder.com/120x80/2563eb/ffffff?text=Course";
                    string formattedId = $"CRS-{course.CourseId.ToString().PadLeft(4, '0')}";

                    // Register script to show modal with course data directly
                    string script = $@"
                        $(document).ready(function() {{
                            try {{
                                var courseData = {{
                                    courseId: {course.CourseId},
                                    courseName: '{courseName}',
                                    description: '{description}',
                                    duration: '{duration}',
                                    teacherId: {teacherId},
                                    isActive: {isActive.ToString().ToLower()},
                                    status: '{status}',
                                    createdAt: '{createdAt}',
                                    createdTime: '{createdTime}',
                                    updatedAt: '{updatedAt}',
                                    thumbnail: '{thumbnail}',
                                    formattedId: '{formattedId}'
                                }};
                                populateCourseModal(courseData);
                                $('#courseDetailsModal').modal('show');
                            }} catch(e) {{
                                console.error('Error loading course details:', e);
                                showErrorToast('Error loading course details');
                            }}
                        }});
                    ";

                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowCourseModal", script, true);
                }
                else
                {
                    ShowMessage("Course not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading course details: " + ex.Message, "error");
            }
        }

        private void ToggleCourseStatus(int courseId)
        {
            try
            {
                // Get current course data
                Course course = _courseService.GetCourse(courseId);
                if (course != null)
                {
                    // Toggle the status
                    course.IsActive = !course.IsActive;
                    course.UpdatedAt = DateTime.Now;

                    // Update the course
                    bool success = _courseService.ActivateDeactivateCourse(course);

                    if (success)
                    {
                        string status = course.IsActive ? "activated" : "deactivated";
                        ShowMessage($"Course '{course.CourseName}' has been {status} successfully.", "success");

                        // Reload data
                        LoadCourseData();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowMessage("Failed to update course status.", "error");
                    }
                }
                else
                {
                    ShowMessage("Course not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error toggling course status: " + ex.Message, "error");
            }
        }

        private void DeleteCourse(int courseId)
        {
            try
            {
                // Get course info for confirmation message
                Course course = _courseService.GetCourse(courseId);
                if (course != null)
                {
                    // Perform delete
                    bool success = _courseService.RemoveCourse(courseId);

                    if (success)
                    {
                        ShowMessage($"Course '{course.CourseName}' has been deleted successfully.", "success");

                        // Reload data
                        LoadCourseData();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowMessage("Failed to delete course.", "error");
                    }
                }
                else
                {
                    ShowMessage("Course not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting course: " + ex.Message, "error");
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
                LoadCourseData();
                LoadStatistics();
                ShowMessage("Course data refreshed successfully.", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error refreshing data: " + ex.Message, "error");
            }
        }

        // Method to get course count by teacher (can be used for additional filtering)
        private int GetCourseCountByTeacher(int teacherId)
        {
            try
            {
                List<Course> courses = _courseService.GetCoursesByTeacher(teacherId);
                return courses?.Count ?? 0;
            }
            catch (Exception ex)
            {
                ShowMessage("Error getting course count by teacher: " + ex.Message, "error");
                return 0;
            }
        }

        // Method to search courses (can be used for additional search functionality)
        private List<Course> SearchCourses(string searchTerm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(searchTerm))
                {
                    return _courseService.ListAllCourses();
                }

                return _courseService.SearchByTerm(searchTerm);
            }
            catch (Exception ex)
            {
                ShowMessage("Error searching courses: " + ex.Message, "error");
                return new List<Course>();
            }
        }

        // Method to export course data (can be extended for different formats)
        public void ExportCourseData(string format = "excel")
        {
            try
            {
                List<Course> courses = _courseService.ListAllCourses();

                if (courses == null || courses.Count == 0)
                {
                    ShowMessage("No course data available to export.", "warning");
                    return;
                }

                // Prepare course data for export
                System.Text.StringBuilder csvContent = new System.Text.StringBuilder();

                // Add headers
                csvContent.AppendLine("Course ID,Course Name,Description,Duration,Teacher ID,Status,Created Date,Updated Date");

                // Add course data
                foreach (var course in courses)
                {
                    string formattedId = $"CRS-{course.CourseId.ToString().PadLeft(4, '0')}";
                    string description = (course.Description ?? "").Replace(",", ";").Replace("\n", " ").Replace("\r", "");
                    string courseName = (course.CourseName ?? "").Replace(",", ";");
                    string duration = (course.Duration ?? "").Replace(",", ";");
                    string status = course.IsActive ? "Active" : "Inactive";
                    string createdDate = course.CreatedAt.ToString("yyyy-MM-dd HH:mm:ss");
                    string updatedDate = course.UpdatedAt?.ToString("yyyy-MM-dd HH:mm:ss") ?? "";

                    csvContent.AppendLine($"{formattedId},{courseName},{description},{duration},{course.TeacherId},{status},{createdDate},{updatedDate}");
                }

                // Set response headers for file download
                Response.Clear();
                Response.ContentType = "text/csv";
                Response.AddHeader("Content-Disposition", $"attachment;filename=CourseData_{DateTime.Now:yyyyMMdd_HHmmss}.csv");
                Response.Write(csvContent.ToString());
                Response.End();
            }
            catch (Exception ex)
            {
                ShowMessage("Error exporting course data: " + ex.Message, "error");
            }
        }

        // Method to handle bulk operations (can be extended)
        protected void HandleBulkOperation(string operation, int[] courseIds)
        {
            try
            {
                if (courseIds == null || courseIds.Length == 0)
                {
                    ShowMessage("No courses selected for bulk operation.", "warning");
                    return;
                }

                int successCount = 0;
                int failureCount = 0;

                foreach (int courseId in courseIds)
                {
                    try
                    {
                        switch (operation.ToLower())
                        {
                            case "activate":
                                var courseToActivate = _courseService.GetCourse(courseId);
                                if (courseToActivate != null)
                                {
                                    courseToActivate.IsActive = true;
                                    courseToActivate.UpdatedAt = DateTime.Now;
                                    if (_courseService.ActivateDeactivateCourse(courseToActivate))
                                        successCount++;
                                    else
                                        failureCount++;
                                }
                                break;

                            case "deactivate":
                                var courseToDeactivate = _courseService.GetCourse(courseId);
                                if (courseToDeactivate != null)
                                {
                                    courseToDeactivate.IsActive = false;
                                    courseToDeactivate.UpdatedAt = DateTime.Now;
                                    if (_courseService.ActivateDeactivateCourse(courseToDeactivate))
                                        successCount++;
                                    else
                                        failureCount++;
                                }
                                break;

                            case "delete":
                                if (_courseService.RemoveCourse(courseId))
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
                LoadCourseData();
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
                    console.log('Course Management page loaded successfully');
                    
                    // Bind refresh button if needed
                    $('#btnRefresh').on('click', function() {
                        refreshCourseData();
                    });
                });
            ";

            ClientScript.RegisterStartupScript(this.GetType(), "CourseManagementScript", script, true);
        }

        // Method to validate course data (can be used before operations)
        private bool ValidateCourse(Course course)
        {
            if (course == null)
            {
                ShowMessage("Course data is null.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(course.CourseName))
            {
                ShowMessage("Course name is required.", "error");
                return false;
            }

            if (course.TeacherId <= 0)
            {
                ShowMessage("Valid teacher assignment is required.", "error");
                return false;
            }

            // Add more validation rules as needed
            return true;
        }

        // Method to validate teacher assignment
        private bool ValidateTeacherAssignment(int teacherId)
        {
            try
            {
                return _courseService.ValidateTeacher(teacherId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error validating teacher assignment: " + ex.Message, "error");
                return false;
            }
        }

        // Method to assign teacher to course
        protected void AssignTeacherToCourse(int courseId, int teacherId)
        {
            try
            {
                if (!ValidateTeacherAssignment(teacherId))
                {
                    ShowMessage("Selected teacher is not valid or inactive.", "error");
                    return;
                }

                bool success = _courseService.AssignTeacherToCourse(courseId, teacherId);

                if (success)
                {
                    ShowMessage("Teacher assigned to course successfully.", "success");
                    LoadCourseData();
                }
                else
                {
                    ShowMessage("Failed to assign teacher to course.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error assigning teacher to course: " + ex.Message, "error");
            }
        }

        // Method to get course statistics by date range
        protected Dictionary<string, int> GetCourseStatsByDateRange(DateTime startDate, DateTime endDate)
        {
            try
            {
                List<Course> allCourses = _courseService.ListAllCourses();
                var filteredCourses = allCourses.Where(c => c.CreatedAt >= startDate && c.CreatedAt <= endDate).ToList();

                return new Dictionary<string, int>
                {
                    ["Total"] = filteredCourses.Count,
                    ["Active"] = filteredCourses.Count(c => c.IsActive),
                    ["Inactive"] = filteredCourses.Count(c => !c.IsActive)
                };
            }
            catch (Exception ex)
            {
                ShowMessage("Error getting course statistics: " + ex.Message, "error");
                return new Dictionary<string, int>();
            }
        }

        // Method to get courses by status with pagination
        protected List<Course> GetCoursesByStatus(bool isActive, int pageIndex = 0, int pageSize = 10)
        {
            try
            {
                List<Course> allCourses = _courseService.ListAllCourses();
                var filteredCourses = allCourses.Where(c => c.IsActive == isActive)
                                               .Skip(pageIndex * pageSize)
                                               .Take(pageSize)
                                               .ToList();
                return filteredCourses;
            }
            catch (Exception ex)
            {
                ShowMessage("Error getting courses by status: " + ex.Message, "error");
                return new List<Course>();
            }
        }

        // Method to handle course duplication
        protected void DuplicateCourse(int courseId)
        {
            try
            {
                Course originalCourse = _courseService.GetCourse(courseId);
                if (originalCourse != null)
                {
                    // Create a new course with duplicated data
                    Course duplicatedCourse = new Course
                    {
                        CourseName = originalCourse.CourseName + " (Copy)",
                        Description = originalCourse.Description,
                        Duration = originalCourse.Duration,
                        TeacherId = originalCourse.TeacherId,
                        Thumbnail = originalCourse.Thumbnail,
                        IsActive = false, // Start as inactive
                        CreatedAt = DateTime.Now,
                        UpdatedAt = DateTime.Now
                    };

                    int newCourseId = _courseService.CreateCourse(duplicatedCourse);

                    if (newCourseId > 0)
                    {
                        ShowMessage($"Course '{originalCourse.CourseName}' has been duplicated successfully.", "success");
                        LoadCourseData();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowMessage("Failed to duplicate course.", "error");
                    }
                }
                else
                {
                    ShowMessage("Original course not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error duplicating course: " + ex.Message, "error");
            }
        }

        // Method to archive courses (soft delete)
        protected void ArchiveCourse(int courseId)
        {
            try
            {
                Course course = _courseService.GetCourse(courseId);
                if (course != null)
                {
                    // Set course as inactive instead of deleting
                    course.IsActive = false;
                    course.UpdatedAt = DateTime.Now;

                    bool success = _courseService.ActivateDeactivateCourse(course);

                    if (success)
                    {
                        ShowMessage($"Course '{course.CourseName}' has been archived successfully.", "success");
                        LoadCourseData();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowMessage("Failed to archive course.", "error");
                    }
                }
                else
                {
                    ShowMessage("Course not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error archiving course: " + ex.Message, "error");
            }
        }

        // Method to restore archived courses
        protected void RestoreCourse(int courseId)
        {
            try
            {
                Course course = _courseService.GetCourse(courseId);
                if (course != null)
                {
                    course.IsActive = true;
                    course.UpdatedAt = DateTime.Now;

                    bool success = _courseService.ActivateDeactivateCourse(course);

                    if (success)
                    {
                        ShowMessage($"Course '{course.CourseName}' has been restored successfully.", "success");
                        LoadCourseData();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowMessage("Failed to restore course.", "error");
                    }
                }
                else
                {
                    ShowMessage("Course not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error restoring course: " + ex.Message, "error");
            }
        }

        // Clean up resources
        protected override void OnUnload(EventArgs e)
        {
            // Clean up any resources if needed
            base.OnUnload(e);
        }
    }
}