using LMS.Model;
using LMS.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace LMS.Repository
{
    public class AdminRepository
    {
        private readonly string _connectionString;

        public AdminRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        }

        #region CRUD Operations

        public int AddAdmin(Admin admin)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        INSERT INTO Admins (IsSuper, FirstName, LastName, Email, Address, Password, DateOfBirth, 
                                            Gender, ProfilePicture, ContactNumber, IsActive, CreatedAt)
                        VALUES (@IsSuper, @FirstName, @LastName, @Email, @Address, @Password, @DateOfBirth, 
                                @Gender, @ProfilePicture, @ContactNumber, @IsActive, @CreatedAt);
                        SELECT SCOPE_IDENTITY();";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@IsSuper", admin.IsSuper);
                        cmd.Parameters.AddWithValue("@FirstName", admin.FirstName);
                        cmd.Parameters.AddWithValue("@LastName", admin.LastName);
                        cmd.Parameters.AddWithValue("@Email", admin.Email);
                        cmd.Parameters.AddWithValue("@Address", admin.Address);
                        cmd.Parameters.AddWithValue("@Password", admin.Password);
                        cmd.Parameters.AddWithValue("@DateOfBirth", admin.DateOfBirth);
                        cmd.Parameters.AddWithValue("@Gender", (int)admin.Gender);
                        cmd.Parameters.AddWithValue("@ProfilePicture", (object)admin.ProfilePicture ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@ContactNumber", (object)admin.ContactNumber ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsActive", admin.IsActive);
                        cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);

                        conn.Open();
                        var result = cmd.ExecuteScalar();
                        return Convert.ToInt32(result);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error adding admin: " + ex.Message, ex);
            }
        }

        public Admin GetAdminById(int adminId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT * FROM Admins WHERE AdminId = @AdminId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AdminId", adminId);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                                return MapAdminFromReader(reader);
                        }
                    }
                }
                return null;
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving admin: " + ex.Message, ex);
            }
        }

        public List<Admin> GetAllAdmins()
        {
            try
            {
                List<Admin> admins = new List<Admin>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT * FROM Admins ORDER BY FirstName, LastName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                                admins.Add(MapAdminFromReader(reader));
                        }
                    }
                }

                return admins;
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving admins: " + ex.Message, ex);
            }
        }
        public bool ActivateDeactivateAdmin(Admin admin)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                UPDATE Admins 
                SET IsActive = @IsActive,
                    UpdatedAt = @UpdatedAt
                WHERE AdminId = @AdminId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AdminId", admin.AdminId);
                        cmd.Parameters.AddWithValue("@IsActive", admin.IsActive);
                        cmd.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error updating admin status: {ex.Message}", ex);
            }
        }

        public bool UpdateAdmin(Admin admin)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                        UPDATE Admins SET
                            FirstName = @FirstName,
                            LastName = @LastName,
                            Email = @Email,
                            Password = @Password,
                            Address = @Address,
                            DateOfBirth = @DateOfBirth,
                            Gender = @Gender,
                            ProfilePicture = @ProfilePicture,
                            ContactNumber = @ContactNumber,
                            IsSuper = @IsSuper,
                            IsActive = @IsActive,
                            UpdatedAt = @UpdatedAt
                        WHERE AdminId = @AdminId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AdminId", admin.AdminId);
                        cmd.Parameters.AddWithValue("@FirstName", admin.FirstName);
                        cmd.Parameters.AddWithValue("@LastName", admin.LastName);
                        cmd.Parameters.AddWithValue("@Email", admin.Email);
                        cmd.Parameters.AddWithValue("@Password", admin.Password);
                        cmd.Parameters.AddWithValue("@Address", admin.Address);
                        cmd.Parameters.AddWithValue("@DateOfBirth", admin.DateOfBirth);
                        cmd.Parameters.AddWithValue("@Gender", (int)admin.Gender);
                        cmd.Parameters.AddWithValue("@ProfilePicture", (object)admin.ProfilePicture ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@ContactNumber", (object)admin.ContactNumber ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsSuper", admin.IsSuper);
                        cmd.Parameters.AddWithValue("@IsActive", admin.IsActive);
                        cmd.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                        conn.Open();
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating admin: " + ex.Message, ex);
            }
        }

        public bool DeleteAdmin(int adminId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "DELETE FROM Admins WHERE AdminId = @AdminId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AdminId", adminId);

                        conn.Open();
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error deleting admin: " + ex.Message, ex);
            }
        }

        #endregion

        #region Additional Methods

        public bool IsEmailExists(string email, int? excludeAdminId = null)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Admins WHERE Email = @Email";

                    if (excludeAdminId.HasValue)
                    {
                        query += " AND AdminId != @ExcludeAdminId";
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);

                        if (excludeAdminId.HasValue)
                        {
                            cmd.Parameters.AddWithValue("@ExcludeAdminId", excludeAdminId.Value);
                        }

                        conn.Open();
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error checking email existence: " + ex.Message, ex);
            }
        }

        public List<Admin> SearchAdmins(string searchTerm)
        {
            try
            {
                List<Admin> admins = new List<Admin>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                SELECT * FROM Admins
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
                                admins.Add(MapAdminFromReader(reader));
                            }
                        }
                    }
                }

                return admins;
            }
            catch (Exception ex)
            {
                throw new Exception("Error searching admins: " + ex.Message, ex);
            }
        }

        public List<Admin> GetAdminsByGender(Gender gender)
        {
            try
            {
                List<Admin> admins = new List<Admin>();

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = @"
                SELECT * FROM Admins
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
                                admins.Add(MapAdminFromReader(reader));
                            }
                        }
                    }
                }

                return admins;
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving admins by gender: " + ex.Message, ex);
            }
        }

        public int GetTotalAdminCount()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Admins";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error getting total admin count: " + ex.Message, ex);
            }
        }

        public int GetActiveAdminCount()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Admins WHERE IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error getting active admin count: " + ex.Message, ex);
            }
        }

        #endregion


        #region Helper Methods

        private Admin MapAdminFromReader(SqlDataReader reader)
        {
            return new Admin
            {
                AdminId = Convert.ToInt32(reader["AdminId"]),
                IsSuper = Convert.ToBoolean(reader["IsSuper"]),
                FirstName = reader["FirstName"].ToString(),
                LastName = reader["LastName"].ToString(),
                Email = reader["Email"].ToString(),
                Address = reader["Address"].ToString(),
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
