using System;
using System.Collections.Generic;
using LMS.Repository;

namespace LMS.Services
{
    public class DashboardService
    {
        private readonly DashboardRepository _repository;

        public DashboardService()
        {
            _repository = new DashboardRepository();
        }

        public Dictionary<string, int> GetDashboardStats()
        {
            return new Dictionary<string, int>
            {
                ["TotalStudents"] = _repository.GetActiveStudentsCount(),
                ["ActiveTeachers"] = _repository.GetActiveTeachersCount(),
                ["ActiveCourses"] = _repository.GetActiveCoursesCount()
            };
        }

        public List<Dictionary<string, string>> GetRecentActivities(int count = 5)
        {
            var activities = new List<Dictionary<string, string>>();

            // Get 2 recent students
            activities.AddRange(_repository.GetRecentStudentActivities(2));

            // Get 1 recent teacher
            activities.AddRange(_repository.GetRecentTeacherActivities(1));

            // Get 2 recent courses
            activities.AddRange(_repository.GetRecentCourseActivities(2));

            // Sort by date and take requested count
            activities.Sort((a, b) => DateTime.Parse(b["CreatedAt"]).CompareTo(DateTime.Parse(a["CreatedAt"])));
            return activities.GetRange(0, Math.Min(count, activities.Count));
        }

        public List<Dictionary<string, string>> GetTopCourses(int count = 4)
        {
            return _repository.GetTopCourses(count);
        }

        public string GetTimeAgo(DateTime date)
        {
            var span = DateTime.Now - date;
            if (span.TotalDays > 365) return $"{(int)(span.TotalDays / 365)} years ago";
            if (span.TotalDays > 30) return $"{(int)(span.TotalDays / 30)} months ago";
            if (span.TotalDays > 0) return $"{(int)span.TotalDays} days ago";
            if (span.TotalHours > 0) return $"{(int)span.TotalHours} hours ago";
            if (span.TotalMinutes > 0) return $"{(int)span.TotalMinutes} minutes ago";
            return "just now";
        }
    }
}