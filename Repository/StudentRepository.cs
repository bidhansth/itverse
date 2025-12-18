using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using LMS.Models;
using System.Security.Cryptography;
using System.Text;

namespace LMS.Repository
{
    public class StudentRepository 
    {
        private readonly string _connectionString;

        public StudentRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        }

        #region CRUD Operations

        public int AddStudent(Student student)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        INSERT INTO Students (FirstName, LastName, Email, Password, DateOfBirth, 
                                            Gender, ProfilePicture, ContactNumber, IsActive, CreatedAt)
                        VALUES (@FirstName, @LastName, @Email, @Password, @DateOfBirth, 
                                @Gender, @ProfilePicture, @ContactNumber, @IsActive, @CreatedAt);
                        SELECT SCOPE_IDENTITY();";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FirstName", student.FirstName);
                        cmd.Parameters.AddWithValue("@LastName", student.LastName);
                        cmd.Parameters.AddWithValue("@Email", student.Email);
                        cmd.Parameters.AddWithValue("@Password", student.Password);
                        cmd.Parameters.AddWithValue("@DateOfBirth", student.DateOfBirth);
                        cmd.Parameters.AddWithValue("@Gender", (int)student.Gender);
                        cmd.Parameters.AddWithValue("@ProfilePicture", (object)student.ProfilePicture ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@ContactNumber", (object)student.ContactNumber ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsActive", student.IsActive);
                        cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);

                        conn.Open();
                        var result = cmd.ExecuteScalar();
                        return Convert.ToInt32(result);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error adding student: {ex.Message}", ex);
            }
        }

        public Student GetStudentById(int studentId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT StudentId, FirstName, LastName, Email, Password, DateOfBirth, 
                               Gender, ProfilePicture, ContactNumber, IsActive, CreatedAt, UpdatedAt
                        FROM Students 
                        WHERE StudentId = @StudentId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", studentId);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                return MapStudentFromReader(reader);
                            }
                        }
                    }
                }
                return null;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving student: {ex.Message}", ex);
            }
        }

        public List<Student> GetAllStudents()
        {
            try
            {
                List<Student> students = new List<Student>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT StudentId, FirstName, LastName, Email, Password, DateOfBirth, 
                               Gender, ProfilePicture, ContactNumber, IsActive, CreatedAt, UpdatedAt
                        FROM dbo.Students 
                        ORDER BY FirstName, LastName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                students.Add(MapStudentFromReader(reader));
                            }
                        }
                    }
                }
                return students;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving students: {ex.Message}", ex);
            }
        }

        public List<Student> GetActiveStudents()
        {
            try
            {
                List<Student> students = new List<Student>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT StudentId, FirstName, LastName, Email, Password, DateOfBirth, 
                               Gender, ProfilePicture, ContactNumber, IsActive, CreatedAt, UpdatedAt
                        FROM Students 
                        WHERE IsActive = 1
                        ORDER BY FirstName, LastName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                students.Add(MapStudentFromReader(reader));
                            }
                        }
                    }
                }
                return students;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving active students: {ex.Message}", ex);
            }
        }

        public bool ActivateDeactivateStudent(Student student)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        UPDATE Students 
                        SET  IsActive = @IsActive,
                            UpdatedAt = @UpdatedAt
                        WHERE StudentId = @StudentId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", student.StudentId);
                        cmd.Parameters.AddWithValue("@IsActive", student.IsActive);
                        cmd.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error updating student status: {ex.Message}", ex);
            }
        }
        public bool UpdateStudent(Student student)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        UPDATE Students 
                        SET FirstName = @FirstName, 
                            LastName = @LastName, 
                            Email = @Email, 
                            Password = @Password,
                            DateOfBirth = @DateOfBirth, 
                            Gender = @Gender, 
                            ProfilePicture = @ProfilePicture, 
                            ContactNumber = @ContactNumber,
                            UpdatedAt = @UpdatedAt
                        WHERE StudentId = @StudentId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", student.StudentId);
                        cmd.Parameters.AddWithValue("@FirstName", student.FirstName);
                        cmd.Parameters.AddWithValue("@LastName", student.LastName);
                        cmd.Parameters.AddWithValue("@Email", student.Email);
                        cmd.Parameters.AddWithValue("@Password", student.Password);
                        cmd.Parameters.AddWithValue("@DateOfBirth", student.DateOfBirth);
                        cmd.Parameters.AddWithValue("@Gender", (int)student.Gender);
                        cmd.Parameters.AddWithValue("@ProfilePicture", (object)student.ProfilePicture ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@ContactNumber", (object)student.ContactNumber ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsActive", student.IsActive);
                        cmd.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error updating student: {ex.Message}", ex);
            }
        }

        public bool DeleteStudent(int studentId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "DELETE FROM Students WHERE StudentId = @StudentId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", studentId);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error deleting student: {ex.Message}", ex);
            }
        }


        #endregion

        #region Additional Methods

        public bool IsEmailExists(string email, int? excludeStudentId = null)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Students WHERE Email = @Email";

                    if (excludeStudentId.HasValue)
                    {
                        query += " AND StudentId != @ExcludeStudentId";
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);

                        if (excludeStudentId.HasValue)
                        {
                            cmd.Parameters.AddWithValue("@ExcludeStudentId", excludeStudentId.Value);
                        }

                        conn.Open();
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error checking email existence: {ex.Message}", ex);
            }
        }

        public List<Student> SearchStudents(string searchTerm)
        {
            try
            {
                List<Student> students = new List<Student>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT StudentId, FirstName, LastName, Email, Password, DateOfBirth, 
                               Gender, ProfilePicture, ContactNumber, IsActive, CreatedAt, UpdatedAt
                        FROM Students 
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
                                students.Add(MapStudentFromReader(reader));
                            }
                        }
                    }
                }
                return students;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error searching students: {ex.Message}", ex);
            }
        }

        public List<Student> GetStudentsByGender(Gender gender)
        {
            try
            {
                List<Student> students = new List<Student>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        SELECT StudentId, FirstName, LastName, Email, Password, DateOfBirth, 
                               Gender, ProfilePicture, ContactNumber, IsActive, CreatedAt, UpdatedAt
                        FROM Students 
                        WHERE Gender = @Gender AND IsActive = 1
                        ORDER BY FirstName, LastName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Gender", (int)gender);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                students.Add(MapStudentFromReader(reader));
                            }
                        }
                    }
                }
                return students;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving students by gender: {ex.Message}", ex);
            }
        }

        public int GetTotalStudentCount()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Students";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error getting total student count: {ex.Message}", ex);
            }
        }

        public int GetActiveStudentCount()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Students WHERE IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error getting active student count: {ex.Message}", ex);
            }
        }

        #endregion

        #region Helper Methods

        private Student MapStudentFromReader(SqlDataReader reader)
        {
            return new Student
            {
                StudentId = Convert.ToInt32(reader["StudentId"]),
                FirstName = reader["FirstName"].ToString(),
                LastName = reader["LastName"].ToString(),
                Email = reader["Email"].ToString(),
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

        #endregion
    }
}