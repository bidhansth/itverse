using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using LMS.Model;
using LMS.Models;

namespace LMS.Repository
{
    public class TeacherRepository
    {
        private readonly string _connectionString;

        public TeacherRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        }

        #region CRUD Operations

        public int AddTeacher(Teacher teacher)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        INSERT INTO Teachers (FirstName, LastName, Email, Address, Qualification, Password, DateOfBirth, 
                                              Gender, ProfilePicture, ContactNumber, IsActive, CreatedAt)
                        VALUES (@FirstName, @LastName, @Email, @Address, @Qualification, @Password, @DateOfBirth, 
                                @Gender, @ProfilePicture, @ContactNumber, @IsActive, @CreatedAt);
                        SELECT SCOPE_IDENTITY();";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FirstName", teacher.FirstName);
                        cmd.Parameters.AddWithValue("@LastName", teacher.LastName);
                        cmd.Parameters.AddWithValue("@Email", teacher.Email);
                        cmd.Parameters.AddWithValue("@Address", teacher.Address);
                        cmd.Parameters.AddWithValue("@Qualification", teacher.Qualification);
                        cmd.Parameters.AddWithValue("@Password", teacher.Password);
                        cmd.Parameters.AddWithValue("@DateOfBirth", teacher.DateOfBirth);
                        cmd.Parameters.AddWithValue("@Gender", (int)teacher.Gender);
                        cmd.Parameters.AddWithValue("@ProfilePicture", (object)teacher.ProfilePicture ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@ContactNumber", (object)teacher.ContactNumber ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsActive", teacher.IsActive);
                        cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);

                        conn.Open();
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error adding teacher: {ex.Message}", ex);
            }
        }

        public Teacher GetTeacherById(int teacherId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT * FROM Teachers 
                        WHERE TeacherId = @TeacherId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacherId);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                return MapTeacherFromReader(reader);
                            }
                        }
                    }
                }
                return null;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving teacher: {ex.Message}", ex);
            }
        }

        public List<Teacher> GetAllTeachers()
        {
            try
            {
                List<Teacher> teachers = new List<Teacher>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT * FROM Teachers ORDER BY FirstName, LastName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                teachers.Add(MapTeacherFromReader(reader));
                            }
                        }
                    }
                }

                return teachers;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving teachers: {ex.Message}", ex);
            }
        }

        public bool UpdateTeacher(Teacher teacher)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        UPDATE Teachers
                        SET FirstName = @FirstName,
                            LastName = @LastName,
                            Email = @Email,
                            Password = @Password,
                            Address = @Address,   
                            Qualification = @Qualification,
                            DateOfBirth = @DateOfBirth,
                            Gender = @Gender,
                            ProfilePicture = @ProfilePicture,
                            ContactNumber = @ContactNumber,
                            IsActive = @IsActive,
                            UpdatedAt = @UpdatedAt
                        WHERE TeacherId = @TeacherId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacher.TeacherId);
                        cmd.Parameters.AddWithValue("@FirstName", teacher.FirstName);
                        cmd.Parameters.AddWithValue("@LastName", teacher.LastName);
                        cmd.Parameters.AddWithValue("@Email", teacher.Email);
                        cmd.Parameters.AddWithValue("@Password", teacher.Password);
                        cmd.Parameters.AddWithValue("@Address", teacher.Address);
                        cmd.Parameters.AddWithValue("@Qualification", teacher.Qualification);
                        cmd.Parameters.AddWithValue("@DateOfBirth", teacher.DateOfBirth);
                        cmd.Parameters.AddWithValue("@Gender", (int)teacher.Gender);
                        cmd.Parameters.AddWithValue("@ProfilePicture", (object)teacher.ProfilePicture ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@ContactNumber", (object)teacher.ContactNumber ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsActive", teacher.IsActive);
                        cmd.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                        conn.Open();
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error updating teacher: {ex.Message}", ex);
            }
        }

        public bool DeleteTeacher(int teacherId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "DELETE FROM Teachers WHERE TeacherId = @TeacherId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacherId);

                        conn.Open();
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error deleting teacher: {ex.Message}", ex);
            }
        }

        #endregion

        #region Additional Methods

        public bool IsEmailExists(string email, int? excludeTeacherId = null)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Teachers WHERE Email = @Email";

                    if (excludeTeacherId.HasValue)
                        query += " AND TeacherId != @ExcludeTeacherId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        if (excludeTeacherId.HasValue)
                            cmd.Parameters.AddWithValue("@ExcludeTeacherId", excludeTeacherId.Value);

                        conn.Open();
                        return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error checking email existence: {ex.Message}", ex);
            }
        }

        public List<Teacher> SearchTeachers(string searchTerm)
        {
            try
            {
                List<Teacher> teachers = new List<Teacher>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT * FROM Teachers
                        WHERE (FirstName LIKE @SearchTerm OR LastName LIKE @SearchTerm OR Email LIKE @SearchTerm)
                        ORDER BY FirstName, LastName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SearchTerm", $"%{searchTerm}%");

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                teachers.Add(MapTeacherFromReader(reader));
                            }
                        }
                    }
                }

                return teachers;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error searching teachers: {ex.Message}", ex);
            }
        }

        public int GetTotalTeacherCount()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Teachers";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error getting total teacher count: {ex.Message}", ex);
            }
        }

        public int GetActiveTeacherCount()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Teachers WHERE IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error getting active teacher count: {ex.Message}", ex);
            }
        }

        #endregion

        #region Helper Methods

        private Teacher MapTeacherFromReader(SqlDataReader reader)
        {
            return new Teacher
            {
                TeacherId = Convert.ToInt32(reader["TeacherId"]),
                FirstName = reader["FirstName"].ToString(),
                LastName = reader["LastName"].ToString(),
                Email = reader["Email"].ToString(),
                Address = reader["Address"].ToString(),
                Qualification = reader["Qualification"].ToString(),
                Password = reader["Password"].ToString(),
                DateOfBirth = Convert.ToDateTime(reader["DateOfBirth"]),
                Gender = (Gender)Convert.ToInt32(reader["Gender"]),
                ProfilePicture = reader["ProfilePicture"] == DBNull.Value ? null : reader["ProfilePicture"].ToString(),
                ContactNumber = reader["ContactNumber"] == DBNull.Value ? null : reader["ContactNumber"].ToString(),
                IsActive = Convert.ToBoolean(reader["IsActive"]),
                CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                UpdatedAt = reader["UpdatedAt"] == DBNull.Value ? null : (DateTime?)Convert.ToDateTime(reader["UpdatedAt"])
            };
        }

        public bool ActivateDeactivateTeacher(Teacher teacher)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        UPDATE Teachers 
                        SET  IsActive = @IsActive,
                            UpdatedAt = @UpdatedAt
                        WHERE TeacherId = @TeacherId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacher.TeacherId);
                        cmd.Parameters.AddWithValue("@IsActive", teacher.IsActive);
                        cmd.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error updating teacher status: {ex.Message}", ex);
            }
        }

        #endregion
    }
}
