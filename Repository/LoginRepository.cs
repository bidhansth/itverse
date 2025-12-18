using LMS.Model;
using LMS.Models;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace LMS.Repository
{
    public class LoginRepository
    {
        private readonly string _connectionString;

        public LoginRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                string saltedPassword = password + "your_salt_here"; // Ensure same salt as used when storing
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(saltedPassword));
                Console.WriteLine(Convert.ToBase64String(bytes).ToString());
                return Convert.ToBase64String(bytes);
            }
        }

        public LoginResult ValidateLogin(string email, string password)
        {
            string hashedPassword = password;

            using (SqlConnection con = new SqlConnection(_connectionString))
            {
                con.Open();

                // Check Admin
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM Admins WHERE Email = @Email AND Password = @Password AND IsActive = 1", con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            var admin = new Admin
                            {
                                AdminId = Convert.ToInt32(reader["AdminId"]),
                                FirstName = reader["FirstName"].ToString(),
                                LastName = reader["LastName"].ToString(),
                                ProfilePicture = reader["ProfilePicture"].ToString(),
                                Email = reader["Email"].ToString(),
                                IsActive = Convert.ToBoolean(reader["IsActive"])
                            };

                            return new LoginResult { Role = "Admin", User = admin };
                        }
                    }
                }

                // Check Teacher
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM Teachers WHERE Email = @Email AND Password = @Password AND IsActive = 1", con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            var teacher = new Teacher
                            {
                                TeacherId = Convert.ToInt32(reader["TeacherId"]),
                                FirstName = reader["FirstName"].ToString(),
                                LastName = reader["LastName"].ToString(),
                                ProfilePicture = reader["ProfilePicture"].ToString(),
                                Email = reader["Email"].ToString(),
                                IsActive = Convert.ToBoolean(reader["IsActive"])
                            };
                            return new LoginResult { Role = "Teacher", User = teacher };
                        }
                    }
                }

                // Check Student
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM Students WHERE Email = @Email AND Password = @Password AND IsActive = 1", con))
                {
                    System.Diagnostics.Debug.WriteLine("Debug: Checking login method" + email + hashedPassword);

                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            var student = new Student
                            {
                                StudentId = Convert.ToInt32(reader["StudentId"]),
                                FirstName = reader["FirstName"].ToString(),
                                LastName = reader["LastName"].ToString(),
                                ProfilePicture = reader["ProfilePicture"].ToString(),
                                Email = reader["Email"].ToString(),
                                IsActive = Convert.ToBoolean(reader["IsActive"])
                            };
                            System.Diagnostics.Debug.WriteLine("found" + student.IsActive);

                            return new LoginResult { Role = "Student", User = student };
                        }
                    }
                }

                return null; 
            }
        }
    }
}
