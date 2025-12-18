using System;
using System.Collections.Generic;
using LMS.Model;
using LMS.Models;
using LMS.Repository;

namespace LMS.Services
{
    public class AdminService
    {
        private readonly AdminRepository _adminRepository;

        public AdminService(AdminRepository adminRepository)
        {
            _adminRepository = adminRepository ?? throw new ArgumentNullException(nameof(adminRepository));
        }

        public int RegisterAdmin(Admin admin)
        {
            try
            {
                if (_adminRepository.IsEmailExists(admin.Email))
                    throw new Exception("Email is already registered.");

                admin.IsActive = true;
                return _adminRepository.AddAdmin(admin);
            }
            catch (Exception ex)
            {
                throw new Exception($"Registration failed: {ex.Message}", ex);
            }
        }

        public Admin GetAdmin(int adminId)
        {
            try
            {
                var admin = _adminRepository.GetAdminById(adminId);
                if (admin == null)
                    throw new Exception("Admin not found.");

                return admin;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving admin: {ex.Message}", ex);
            }
        }

        public List<Admin> ListAllAdmins()
        {
            try
            {
                return _adminRepository.GetAllAdmins();
            }
            catch (Exception ex)
            {
                throw new Exception("Error listing all admins.", ex);
            }
        }

        public bool UpdateAdminProfile(Admin admin)
        {
            try
            {
                if (_adminRepository.IsEmailExists(admin.Email, admin.AdminId))
                    throw new Exception("Email already in use by another admin.");

                return _adminRepository.UpdateAdmin(admin);
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating admin profile.", ex);
            }
        }

        public bool ActivateDeactivateAdmin(Admin admin)
        {
            try
            {
                return _adminRepository.ActivateDeactivateAdmin(admin);
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating admin status.", ex);
            }
        }

        public bool RemoveAdmin(int adminId)
        {
            try
            {
                return _adminRepository.DeleteAdmin(adminId);
            }
            catch (Exception ex)
            {
                throw new Exception("Error deleting admin.", ex);
            }
        }

        public List<Admin> SearchByTerm(string term)
        {
            try
            {
                return _adminRepository.SearchAdmins(term);
            }
            catch (Exception ex)
            {
                throw new Exception("Error searching admins.", ex);
            }
        }

        public List<Admin> FilterByGender(Gender gender)
        {
            try
            {
                return _adminRepository.GetAdminsByGender(gender);
            }
            catch (Exception ex)
            {
                throw new Exception("Error filtering admins by gender.", ex);
            }
        }

        public int CountTotalAdmins()
        {
            try
            {
                return _adminRepository.GetTotalAdminCount();
            }
            catch (Exception ex)
            {
                throw new Exception("Error counting total admins.", ex);
            }
        }

        public int CountActiveAdmins()
        {
            try
            {
                return _adminRepository.GetActiveAdminCount();
            }
            catch (Exception ex)
            {
                throw new Exception("Error counting active admins.", ex);
            }
        }
    }
}
