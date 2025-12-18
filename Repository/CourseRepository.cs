using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using LMS.Model;

namespace LMS.Repository
{
    public class CourseRepository
    {
        private readonly string _connectionString;

        public CourseRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        }

        #region CRUD Operations

        public int AddCourse(Course course)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        INSERT INTO Courses (CourseName, Description, YouTubeLink, Thumbnail, 
                                           Duration, TeacherId, IsActive, CreatedAt)
                        VALUES (@CourseName, @Description, @YouTubeLink, @Thumbnail, 
                                @Duration, @TeacherId, @IsActive, @CreatedAt);
                        SELECT SCOPE_IDENTITY();";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseName", course.CourseName);
                        cmd.Parameters.AddWithValue("@Description", (object)course.Description ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@YouTubeLink", (object)course.YouTubeLink ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Thumbnail", (object)course.Thumbnail ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Duration", (object)course.Duration ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@TeacherId", course.TeacherId);
                        cmd.Parameters.AddWithValue("@IsActive", course.IsActive);
                        cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);

                        conn.Open();
                        var result = cmd.ExecuteScalar();
                        return Convert.ToInt32(result);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error adding course: {ex.Message}", ex);
            }
        }

        public Course GetCourseById(int courseId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT CourseId, CourseName, Description, YouTubeLink, Thumbnail, 
                               Duration, TeacherId, IsActive, CreatedAt, UpdatedAt
                        FROM Courses 
                        WHERE CourseId = @CourseId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                return MapCourseFromReader(reader);
                            }
                        }
                    }
                }
                return null;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving course: {ex.Message}", ex);
            }
        }

        public List<Course> GetAllCourses()
        {
            try
            {
                List<Course> courses = new List<Course>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT CourseId, CourseName, Description, YouTubeLink, Thumbnail, 
                               Duration, TeacherId, IsActive, CreatedAt, UpdatedAt
                        FROM Courses 
                        ORDER BY CourseName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                courses.Add(MapCourseFromReader(reader));
                            }
                        }
                    }
                }
                return courses;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving courses: {ex.Message}", ex);
            }
        }

        public List<Course> GetActiveCourses()
        {
            try
            {
                List<Course> courses = new List<Course>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT CourseId, CourseName, Description, YouTubeLink, Thumbnail, 
                               Duration, TeacherId, IsActive, CreatedAt, UpdatedAt
                        FROM Courses 
                        WHERE IsActive = 1
                        ORDER BY CourseName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                courses.Add(MapCourseFromReader(reader));
                            }
                        }
                    }
                }
                return courses;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving active courses: {ex.Message}", ex);
            }
        }

        public bool UpdateCourse(Course course)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        UPDATE Courses 
                        SET CourseName = @CourseName, 
                            Description = @Description, 
                            YouTubeLink = @YouTubeLink, 
                            Thumbnail = @Thumbnail,
                            Duration = @Duration, 
                            TeacherId = @TeacherId, 
                            IsActive = @IsActive,
                            UpdatedAt = @UpdatedAt
                        WHERE CourseId = @CourseId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", course.CourseId);
                        cmd.Parameters.AddWithValue("@CourseName", course.CourseName);
                        cmd.Parameters.AddWithValue("@Description", (object)course.Description ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@YouTubeLink", (object)course.YouTubeLink ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Thumbnail", (object)course.Thumbnail ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Duration", (object)course.Duration ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@TeacherId", course.TeacherId);
                        cmd.Parameters.AddWithValue("@IsActive", course.IsActive);
                        cmd.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error updating course: {ex.Message}", ex);
            }
        }

        public bool ActivateDeactivateCourse(Course course)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        UPDATE Courses 
                        SET IsActive = @IsActive,
                            UpdatedAt = @UpdatedAt
                        WHERE CourseId = @CourseId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", course.CourseId);
                        cmd.Parameters.AddWithValue("@IsActive", course.IsActive);
                        cmd.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error updating course status: {ex.Message}", ex);
            }
        }

        public bool DeleteCourse(int courseId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "DELETE FROM Courses WHERE CourseId = @CourseId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error deleting course: {ex.Message}", ex);
            }
        }

        #endregion

        #region Additional Methods

        public bool IsCourseNameExists(string courseName, int? excludeCourseId = null)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Courses WHERE CourseName = @CourseName";

                    if (excludeCourseId.HasValue)
                    {
                        query += " AND CourseId != @ExcludeCourseId";
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseName", courseName);

                        if (excludeCourseId.HasValue)
                        {
                            cmd.Parameters.AddWithValue("@ExcludeCourseId", excludeCourseId.Value);
                        }

                        conn.Open();
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error checking course name existence: {ex.Message}", ex);
            }
        }

        public List<Course> SearchCourses(string searchTerm)
        {
            try
            {
                List<Course> courses = new List<Course>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT CourseId, CourseName, Description, YouTubeLink, Thumbnail, 
                               Duration, TeacherId, IsActive, CreatedAt, UpdatedAt
                        FROM Courses 
                        WHERE (CourseName LIKE @SearchTerm OR Description LIKE @SearchTerm)
                        ORDER BY CourseName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SearchTerm", $"%{searchTerm}%");

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                courses.Add(MapCourseFromReader(reader));
                            }
                        }
                    }
                }
                return courses;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error searching courses: {ex.Message}", ex);
            }
        }

        public List<Course> GetCoursesByTeacher(int teacherId)
        {
            try
            {
                List<Course> courses = new List<Course>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT CourseId, CourseName, Description, YouTubeLink, Thumbnail, 
                               Duration, TeacherId, IsActive, CreatedAt, UpdatedAt
                        FROM Courses 
                        WHERE TeacherId = @TeacherId
                        ORDER BY CourseName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacherId);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                courses.Add(MapCourseFromReader(reader));
                            }
                        }
                    }
                }
                return courses;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving courses by teacher: {ex.Message}", ex);
            }
        }

        public int GetTotalCourseCount()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Courses";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error getting total course count: {ex.Message}", ex);
            }
        }

        public int GetActiveCourseCount()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Courses WHERE IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error getting active course count: {ex.Message}", ex);
            }
        }

        public bool IsTeacherValid(int teacherId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Teachers WHERE TeacherId = @TeacherId AND IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacherId);

                        conn.Open();
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error validating teacher: {ex.Message}", ex);
            }
        }

        #endregion

        #region Helper Methods

        private Course MapCourseFromReader(SqlDataReader reader)
        {
            return new Course
            {
                CourseId = Convert.ToInt32(reader["CourseId"]),
                CourseName = reader["CourseName"].ToString(),
                Description = reader["Description"] == DBNull.Value ? null : reader["Description"].ToString(),
                YouTubeLink = reader["YouTubeLink"] == DBNull.Value ? null : reader["YouTubeLink"].ToString(),
                Thumbnail = reader["Thumbnail"] == DBNull.Value ? null : reader["Thumbnail"].ToString(),
                Duration = reader["Duration"] == DBNull.Value ? null : reader["Duration"].ToString(),
                TeacherId = Convert.ToInt32(reader["TeacherId"]),
                IsActive = Convert.ToBoolean(reader["IsActive"]),
                CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                UpdatedAt = reader["UpdatedAt"] == DBNull.Value ? null : (DateTime?)Convert.ToDateTime(reader["UpdatedAt"])
            };
        }

        #endregion
    }
}