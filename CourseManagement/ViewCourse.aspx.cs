using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using LMS.Model;
using LMS.Service;
using LMS.Repository;

namespace LMS.CourseManagement
{
    public partial class ViewCourse : System.Web.UI.Page
    {
        private CourseService _courseService;
        private List<Course> _allCourses;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                _courseService = new CourseService(new CourseRepository());

                if (!IsPostBack)
                {
                    LoadCourseData();
                }
                else
                {
                    HandlePostBackEvents();
                }
            }
            catch (Exception ex)
            {
                SetMessage($"Error loading page: {ex.Message}", "error");
            }
        }

        private void HandlePostBackEvents()
        {
            try
            {
                string eventTarget = Request["__EVENTTARGET"];
                string eventArgument = Request["__EVENTARGUMENT"];

                if (eventTarget == rptCourses.UniqueID && !string.IsNullOrEmpty(eventArgument))
                {
                    string[] args = eventArgument.Split('$');
                    if (args.Length == 2)
                    {
                        string command = args[0];
                        string courseIdStr = args[1];

                        if (command == "ViewDetails" && int.TryParse(courseIdStr, out int courseId))
                        {
                            ShowCourseDetails(courseId);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                SetMessage($"Error handling event: {ex.Message}", "error");
            }
        }

        private void LoadCourseData()
        {
            try
            {
                _allCourses = _courseService.ListAllCourses() ?? new List<Course>();
                ApplyFilters();
                BindCourseData();
                UpdateStatistics();
            }
            catch (Exception ex)
            {
                SetMessage($"Error loading courses: {ex.Message}", "error");
                _allCourses = new List<Course>();
                BindCourseData();
            }
        }

        private void ApplyFilters()
        {
            try
            {
                if (_allCourses == null) return;

                var filteredCourses = _allCourses.AsEnumerable();

                string searchTerm = txtSearch.Text.Trim();
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    filteredCourses = filteredCourses.Where(c =>
                        (c.CourseName?.IndexOf(searchTerm, StringComparison.OrdinalIgnoreCase) >= 0) ||
                        (c.Description?.IndexOf(searchTerm, StringComparison.OrdinalIgnoreCase) >= 0) ||
                        (c.TeacherId.ToString().Contains(searchTerm))
                    );
                }

                string statusFilter = ddlStatusFilter.SelectedValue;
                if (!string.IsNullOrEmpty(statusFilter))
                {
                    bool isActive = statusFilter.Equals("Active", StringComparison.OrdinalIgnoreCase);
                    filteredCourses = filteredCourses.Where(c => c.IsActive == isActive);
                }

                _allCourses = filteredCourses.ToList();
            }
            catch (Exception ex)
            {
                SetMessage($"Error applying filters: {ex.Message}", "error");
            }
        }

        private void BindCourseData()
        {
            try
            {
                if (_allCourses == null || _allCourses.Count == 0)
                {
                    pnlNoCourses.Visible = true;
                    rptCourses.Visible = false;

                    string message = "No courses are available in the system.";
                    if (!string.IsNullOrEmpty(txtSearch.Text.Trim()) || !string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
                    {
                        message = "No courses match your current search criteria. Try adjusting your filters or search terms.";
                    }
                    lblNoCoursesMessage.Text = message;
                }
                else
                {
                    pnlNoCourses.Visible = false;
                    rptCourses.Visible = true;
                    rptCourses.DataSource = _allCourses;
                    rptCourses.DataBind();
                }
            }
            catch (Exception ex)
            {
                SetMessage($"Error binding course data: {ex.Message}", "error");
                pnlNoCourses.Visible = true;
                rptCourses.Visible = false;
            }
        }

        private void UpdateStatistics()
        {
            try
            {
                var allCourses = _courseService.ListAllCourses() ?? new List<Course>();

                int totalCourses = allCourses.Count;
                int activeCourses = allCourses.Count(c => c.IsActive);
                int inactiveCourses = totalCourses - activeCourses;
                int coursesWithVideos = allCourses.Count(c => !string.IsNullOrEmpty(c.YouTubeLink));

                lblTotalCourses.Text = totalCourses.ToString();
                lblActiveCourses.Text = activeCourses.ToString();
                lblInactiveCourses.Text = inactiveCourses.ToString();
                lblCoursesWithVideos.Text = coursesWithVideos.ToString();
            }
            catch (Exception ex)
            {
                lblTotalCourses.Text = "0";
                lblActiveCourses.Text = "0";
                lblInactiveCourses.Text = "0";
                lblCoursesWithVideos.Text = "0";
                SetMessage($"Error updating statistics: {ex.Message}", "warning");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                LoadCourseData();
                SetMessage("Search completed successfully.", "success");
            }
            catch (Exception ex)
            {
                SetMessage($"Error performing search: {ex.Message}", "error");
            }
        }

        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "ViewDetails" && int.TryParse(e.CommandArgument.ToString(), out int courseId))
                {
                    ShowCourseDetails(courseId);
                }
            }
            catch (Exception ex)
            {
                SetMessage($"Error handling command: {ex.Message}", "error");
            }
        }

        private void ShowCourseDetails(int courseId)
        {
            try
            {
                var course = _courseService.GetCourseById(courseId);
                if (course == null)
                {
                    SetMessage("Course not found.", "error");
                    return;
                }

                string jsonData = $@"{{
                    courseId: {course.CourseId},
                    courseName: ""{(course.CourseName ?? "Untitled Course").Replace("\"", "\\\"")}"",
                    formattedId: ""CRS-{course.CourseId.ToString().PadLeft(4, '0')}"",
                    description: ""{(course.Description ?? "").Replace("\"", "\\\"")}"",
                    duration: ""{(course.Duration ?? "").Replace("\"", "\\\"")}"",
                    teacherId: {course.TeacherId},
                    isActive: {(course.IsActive.ToString().ToLower())},
                    status: ""{(course.IsActive ? "Active" : "Inactive")}"",
                    thumbnail: ""{(course.Thumbnail ?? "").Replace("\"", "\\\"")}"",
                    youTubeLink: ""{(course.YouTubeLink ?? "").Replace("\"", "\\\"")}"",
                    createdDate: ""{course.CreatedAt:MMM dd, yyyy}"",
                    createdDateFull: ""{course.CreatedAt:MMM dd, yyyy 'at' hh:mm tt}"",
                    updatedDate: ""{(course.UpdatedAt?.ToString("MMM dd, yyyy 'at' hh:mm tt") ?? "")}""
                }}";

                string script = $@"
                    setTimeout(function() {{
                        try {{
                            var courseData = {jsonData};
                            populateCourseModal(courseData);
                        }} catch (e) {{
                            console.error('Error showing course details:', e);
                            showErrorToast('Error displaying course details');
                        }}
                    }}, 100);
                ";

                ClientScript.RegisterStartupScript(this.GetType(), "ShowCourseDetails", script, true);
            }
            catch (Exception ex)
            {
                SetMessage($"Error loading course details: {ex.Message}", "error");
            }
        }

        private void SetMessage(string message, string type = "info")
        {
            try
            {
                hdnMessage.Value = message;
                hdnMessageType.Value = type;
            }
            catch (Exception ex)
            {
                string script = $"alert('Error: {ex.Message}');";
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorAlert", script, true);
            }
        }

        [WebMethod]
        public static string RefreshCourseData()
        {
            try
            {
                var courseService = new CourseService(new CourseRepository());
                var courses = courseService.ListAllCourses() ?? new List<Course>();

                int totalCourses = courses.Count;
                int activeCourses = courses.Count(c => c.IsActive);
                int inactiveCourses = totalCourses - activeCourses;
                int coursesWithVideos = courses.Count(c => !string.IsNullOrEmpty(c.YouTubeLink));

                string jsonResult = $@"{{
                    ""success"": true,
                    ""data"": {{
                        ""totalCourses"": {totalCourses},
                        ""activeCourses"": {activeCourses},
                        ""inactiveCourses"": {inactiveCourses},
                        ""coursesWithVideos"": {coursesWithVideos}
                    }}
                }}";

                return jsonResult;
            }
            catch (Exception ex)
            {
                return $@"{{ ""success"": false, ""message"": ""{ex.Message.Replace("\"", "\\\"")}"" }}";
            }
        }

        [WebMethod]
        public static string GetCourseDetails(int courseId)
        {
            try
            {
                var courseService = new CourseService(new CourseRepository());
                var course = courseService.GetCourseById(courseId);

                if (course == null)
                {
                    return @"{ ""success"": false, ""message"": ""Course not found"" }";
                }

                string json = $@"{{
                    ""success"": true,
                    ""data"": {{
                        ""courseId"": {course.CourseId},
                        ""courseName"": ""{(course.CourseName ?? "Untitled Course").Replace("\"", "\\\"")}"",
                        ""formattedId"": ""CRS-{course.CourseId.ToString().PadLeft(4, '0')}"",
                        ""description"": ""{(course.Description ?? "").Replace("\"", "\\\"")}"",
                        ""duration"": ""{(course.Duration ?? "").Replace("\"", "\\\"")}"",
                        ""teacherId"": {course.TeacherId},
                        ""isActive"": {(course.IsActive.ToString().ToLower())},
                        ""status"": ""{(course.IsActive ? "Active" : "Inactive")}"",
                        ""thumbnail"": ""{(course.Thumbnail ?? "").Replace("\"", "\\\"")}"",
                        ""youTubeLink"": ""{(course.YouTubeLink ?? "").Replace("\"", "\\\"")}"",
                        ""createdDate"": ""{course.CreatedAt:MMM dd, yyyy}"",
                        ""createdDateFull"": ""{course.CreatedAt:MMM dd, yyyy 'at' hh:mm tt}"",
                        ""updatedDate"": ""{(course.UpdatedAt?.ToString("MMM dd, yyyy 'at' hh:mm tt") ?? "")}""
                    }}
                }}";

                return json;
            }
            catch (Exception ex)
            {
                return $@"{{ ""success"": false, ""message"": ""{ex.Message.Replace("\"", "\\\"")}"" }}";
            }
        }
    }
}
