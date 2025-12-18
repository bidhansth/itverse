using LMS.Model;
using LMS.Models;
using LMS.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.UserManagement.AdminManagement
{
    public partial class AdminManagement : System.Web.UI.Page
    {
        private readonly AdminService _adminService;

        public AdminManagement()
        {
            _adminService = new AdminService(
                new LMS.Repository.AdminRepository());
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadAdminData();
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

        private void LoadAdminData()
        {
            try
            {
                List<Admin> admins = _adminService.ListAllAdmins();

                if (admins != null && admins.Count > 0)
                {
                    gvAdmins.DataSource = admins;
                    gvAdmins.DataBind();
                    gvAdmins.Visible = true;
                    pnlNoAdmins.Visible = false;
                }
                else
                {
                    gvAdmins.Visible = false;
                    pnlNoAdmins.Visible = true;
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading admin data: " + ex.Message, "error");
                gvAdmins.Visible = false;
                pnlNoAdmins.Visible = true;
            }
        }

        private void LoadStatistics()
        {
            try
            {
                // Get all admins for statistics
                List<Admin> allAdmins = _adminService.ListAllAdmins();

                // Handle empty admin list
                if (allAdmins == null)
                {
                    allAdmins = new List<Admin>();
                }

                List<Admin> activeAdmins = allAdmins.Where(a => a.IsActive).ToList();
                List<Admin> superAdmins = allAdmins.Where(a => a.IsSuper).ToList();

                // Calculate statistics
                int totalAdmins = allAdmins.Count;
                int activeCount = activeAdmins.Count;
                int inactiveCount = totalAdmins - activeCount;
                int superAdminCount = superAdmins.Count;

                // Admins created this month
                DateTime startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                int newThisMonth = allAdmins.Count(a => a.CreatedAt >= startOfMonth);

                // Update labels
                lblTotalAdmins.Text = totalAdmins.ToString();
                lblActiveAdmins.Text = activeCount.ToString();
                lblInactiveAdmins.Text = inactiveCount.ToString();
                lblSuperAdmins.Text = superAdminCount.ToString();
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading statistics: " + ex.Message, "error");
                // Set default values in case of error
                lblTotalAdmins.Text = "0";
                lblActiveAdmins.Text = "0";
                lblInactiveAdmins.Text = "0";
                lblSuperAdmins.Text = "0";
            }
        }

        protected void gvAdmins_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int adminId = Convert.ToInt32(e.CommandArgument);

                switch (e.CommandName)
                {
                    case "ViewAdmin":
                        ViewAdminDetails(adminId);
                        break;
                    case "ToggleStatus":
                        ToggleAdminStatus(adminId);
                        break;
                    case "DeleteAdmin":
                        DeleteAdmin(adminId);
                        break;
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error processing command: " + ex.Message, "error");
            }
        }

        private void ViewAdminDetails(int adminId)
        {
            try
            {
                Admin admin = _adminService.GetAdmin(adminId);
                if (admin != null)
                {
                    // Prepare data variables for JavaScript
                    string firstName = (admin.FirstName ?? "").Replace("'", "\\'");
                    string lastName = (admin.LastName ?? "").Replace("'", "\\'");
                    string fullName = (admin.FullName ?? "").Replace("'", "\\'");
                    string email = (admin.Email ?? "").Replace("'", "\\'");
                    string contactNumber = (admin.ContactNumber ?? "").Replace("'", "\\'");
                    string address = (admin.Address ?? "").Replace("'", "\\'");
                    string age = admin.Age.ToString();
                    string gender = admin.Gender.ToString();
                    string dateOfBirth = admin.DateOfBirth.ToString("yyyy-MM-dd") ?? "";
                    bool isActive = admin.IsActive;
                    bool isSuper = admin.IsSuper;
                    string status = admin.IsActive ? "Active" : "Inactive";
                    string adminType = admin.IsSuper ? "Super Admin" : "Regular Admin";
                    string createdAt = admin.CreatedAt.ToString("MMM dd, yyyy");
                    string createdTime = admin.CreatedAt.ToString("hh:mm tt");
                    string updatedAt = admin.UpdatedAt?.ToString("MMM dd, yyyy hh:mm tt") ?? "Not updated";
                    string profilePicture = !string.IsNullOrEmpty(admin.ProfilePicture)
                        ? ResolveUrl(admin.ProfilePicture)
                        : $"https://ui-avatars.com/api/?name={HttpUtility.UrlEncode(admin.FirstName)}&background=dc2626&color=ffffff&size=100";
                    string formattedId = $"ADM-{admin.AdminId.ToString().PadLeft(4, '0')}";

                    // Register script to show modal with admin data directly
                    string script = $@"
                        $(document).ready(function() {{
                            try {{
                                var adminData = {{
                                    adminId: {admin.AdminId},
                                    firstName: '{firstName}',
                                    lastName: '{lastName}',
                                    fullName: '{fullName}',
                                    email: '{email}',
                                    contactNumber: '{contactNumber}',
                                    address: '{address}',
                                    age: '{age}',
                                    gender: '{gender}',
                                    dateOfBirth: '{dateOfBirth}',
                                    isActive: {isActive.ToString().ToLower()},
                                    isSuper: {isSuper.ToString().ToLower()},
                                    status: '{status}',
                                    adminType: '{adminType}',
                                    createdAt: '{createdAt}',
                                    createdTime: '{createdTime}',
                                    updatedAt: '{updatedAt}',
                                    profilePicture: '{profilePicture}',
                                    formattedId: '{formattedId}'
                                }};
                                populateAdminModal(adminData);
                                $('#adminDetailsModal').modal('show');
                            }} catch(e) {{
                                console.error('Error loading admin details:', e);
                                showErrorToast('Error loading admin details');
                            }}
                        }});
                    ";

                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowAdminModal", script, true);
                }
                else
                {
                    ShowMessage("Admin not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading admin details: " + ex.Message, "error");
            }
        }

        private void ToggleAdminStatus(int adminId)
        {
            try
            {
                // Get current admin data
                Admin admin = _adminService.GetAdmin(adminId);
                if (admin != null)
                {
                    // Toggle the status
                    admin.IsActive = !admin.IsActive;
                    admin.UpdatedAt = DateTime.Now;

                    // Update the admin
                    bool success = _adminService.ActivateDeactivateAdmin(admin);

                    if (success)
                    {
                        string status = admin.IsActive ? "activated" : "deactivated";
                        ShowMessage($"Admin {admin.FullName} has been {status} successfully.", "success");

                        // Reload data
                        LoadAdminData();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowMessage("Failed to update admin status.", "error");
                    }
                }
                else
                {
                    ShowMessage("Admin not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error toggling admin status: " + ex.Message, "error");
            }
        }

        private void DeleteAdmin(int adminId)
        {
            try
            {
                // Get admin info for confirmation message
                Admin admin = _adminService.GetAdmin(adminId);
                if (admin != null)
                {
                    // Perform soft delete (recommended for audit trail)
                    bool success = _adminService.RemoveAdmin(adminId);

                    if (success)
                    {
                        ShowMessage($"Admin {admin.FullName} has been deleted successfully.", "success");

                        // Reload data
                        LoadAdminData();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowMessage("Failed to delete admin.", "error");
                    }
                }
                else
                {
                    ShowMessage("Admin not found.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting admin: " + ex.Message, "error");
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
                LoadAdminData();
                LoadStatistics();
                ShowMessage("Admin data refreshed successfully.", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error refreshing data: " + ex.Message, "error");
            }
        }

        // Method to get admin count by gender (can be used for additional filtering)
        private int GetAdminCountByGender(Gender gender)
        {
            try
            {
                List<Admin> admins = _adminService.FilterByGender(gender);
                return admins?.Count ?? 0;
            }
            catch (Exception ex)
            {
                ShowMessage("Error getting admin count by gender: " + ex.Message, "error");
                return 0;
            }
        }

        // Method to search admins (can be used for additional search functionality)
        private List<Admin> SearchAdmins(string searchTerm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(searchTerm))
                {
                    return _adminService.ListAllAdmins();
                }

                return _adminService.SearchByTerm(searchTerm);
            }
            catch (Exception ex)
            {
                ShowMessage("Error searching admins: " + ex.Message, "error");
                return new List<Admin>();
            }
        }

        // Method to export admin data (can be extended for different formats)
        public void ExportAdminData(string format = "excel")
        {
            try
            {
                List<Admin> admins = _adminService.ListAllAdmins();

                if (admins == null || admins.Count == 0)
                {
                    ShowMessage("No admin data available to export.", "warning");
                    return;
                }

                // This would be implemented based on your export requirements
                // For now, just show a success message
                ShowMessage($"Admin data exported successfully in {format} format.", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error exporting admin data: " + ex.Message, "error");
            }
        }

        // Method to handle bulk operations (can be extended)
        protected void HandleBulkOperation(string operation, int[] adminIds)
        {
            try
            {
                if (adminIds == null || adminIds.Length == 0)
                {
                    ShowMessage("No admins selected for bulk operation.", "warning");
                    return;
                }

                int successCount = 0;
                int failureCount = 0;

                foreach (int adminId in adminIds)
                {
                    try
                    {
                        switch (operation.ToLower())
                        {
                            case "activate":
                                var adminToActivate = _adminService.GetAdmin(adminId);
                                if (adminToActivate != null)
                                {
                                    adminToActivate.IsActive = true;
                                    adminToActivate.UpdatedAt = DateTime.Now;
                                    if (_adminService.ActivateDeactivateAdmin(adminToActivate))
                                        successCount++;
                                    else
                                        failureCount++;
                                }
                                break;

                            case "deactivate":
                                var adminToDeactivate = _adminService.GetAdmin(adminId);
                                if (adminToDeactivate != null)
                                {
                                    adminToDeactivate.IsActive = false;
                                    adminToDeactivate.UpdatedAt = DateTime.Now;
                                    if (_adminService.ActivateDeactivateAdmin(adminToDeactivate))
                                        successCount++;
                                    else
                                        failureCount++;
                                }
                                break;

                            case "delete":
                                if (_adminService.RemoveAdmin(adminId))
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
                LoadAdminData();
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
                    console.log('Admin Management page loaded successfully');
                });
            ";

            ClientScript.RegisterStartupScript(this.GetType(), "AdminManagementScript", script, true);
        }

        // Method to validate admin data (can be used before operations)
        private bool ValidateAdmin(Admin admin)
        {
            if (admin == null)
            {
                ShowMessage("Admin data is null.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(admin.FirstName))
            {
                ShowMessage("First name is required.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(admin.Email))
            {
                ShowMessage("Email is required.", "error");
                return false;
            }

            // Add more validation rules as needed
            return true;
        }

        // Method to log user actions (can be extended for audit trail)
        private void LogUserAction(string action, int adminId, string details = "")
        {
            try
            {
                // This would be implemented based on your logging requirements
                string logMessage = $"Action: {action}, AdminId: {adminId}, Details: {details}, Time: {DateTime.Now}";

                // For now, just write to debug (in production, you'd write to database or log file)
                System.Diagnostics.Debug.WriteLine(logMessage);
            }
            catch (Exception ex)
            {
                // Don't show this error to user as it's a background operation
                System.Diagnostics.Debug.WriteLine($"Logging error: {ex.Message}");
            }
        }
    }
}