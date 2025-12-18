using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace LMS.Repository
{
    public class DashboardRepository
    {
        private readonly string _connectionString;

        public DashboardRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        }

        public int GetActiveStudentsCount()
        {
            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Students WHERE IsActive = 1", conn))
            {
                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        public int GetActiveTeachersCount()
        {
            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Teachers WHERE IsActive = 1", conn))
            {
                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        public int GetActiveCoursesCount()
        {
            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Courses WHERE IsActive = 1", conn))
            {
                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        public List<Dictionary<string, string>> GetRecentStudentActivities(int count)
        {
            return GetActivities(
                "SELECT TOP (@Count) 'New Student' as Title, FirstName + ' ' + LastName + ' registered' as Description, " +
                "'fas fa-user-plus' as Icon, 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' as IconColor, CreatedAt " +
                "FROM Students ORDER BY CreatedAt DESC",
                count
            );
        }

        public List<Dictionary<string, string>> GetRecentTeacherActivities(int count)
        {
            return GetActivities(
                "SELECT TOP (@Count) 'New Teacher' as Title, FirstName + ' ' + LastName + ' joined' as Description, " +
                "'fas fa-chalkboard-teacher' as Icon, 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)' as IconColor, CreatedAt " +
                "FROM Teachers ORDER BY CreatedAt DESC",
                count
            );
        }

        public List<Dictionary<string, string>> GetRecentCourseActivities(int count)
        {
            return GetActivities(
                "SELECT TOP (@Count) 'New Course' as Title, CourseName + ' published' as Description, " +
                "'fas fa-book' as Icon, 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)' as IconColor, CreatedAt " +
                "FROM Courses ORDER BY CreatedAt DESC",
                count
            );
        }

        public List<Dictionary<string, string>> GetTopCourses(int count)
        {
            var courses = new List<Dictionary<string, string>>();

            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand(
                "SELECT TOP (@Count) CourseId, CourseName, Description, Thumbnail FROM Courses WHERE IsActive = 1 ORDER BY CreatedAt DESC",
                conn))
            {
                cmd.Parameters.AddWithValue("@Count", count);
                conn.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        courses.Add(new Dictionary<string, string>
                        {
                            ["CourseId"] = reader["CourseId"].ToString(),
                            ["CourseName"] = reader["CourseName"].ToString(),
                            ["Description"] = reader["Description"].ToString(),
                            ["Thumbnail"] = reader["Thumbnail"] != DBNull.Value
                                ? reader["Thumbnail"].ToString()
                                : "https://via.placeholder.com/50"
                        });
                    }
                }
            }

            return courses;
        }

        private List<Dictionary<string, string>> GetActivities(string query, int count)
        {
            var activities = new List<Dictionary<string, string>>();

            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Count", count);
                conn.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        activities.Add(new Dictionary<string, string>
                        {
                            ["Title"] = reader["Title"].ToString(),
                            ["Description"] = reader["Description"].ToString(),
                            ["Icon"] = reader["Icon"].ToString(),
                            ["IconColor"] = reader["IconColor"].ToString(),
                            ["CreatedAt"] = Convert.ToDateTime(reader["CreatedAt"]).ToString("o")
                        });
                    }
                }
            }

            return activities;
        }
    }
}