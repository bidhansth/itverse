using LMS.Model;
using LMS.Service;
using System;
using System.Web.UI;

namespace LMS
{
    public partial class LoginPage : System.Web.UI.Page
    {
        private readonly LoginService _loginService = new LoginService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Clear any existing error messages
                //pnlError.Visible = false;
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                // Client-side validation failed
                return;
            }

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            try
            {
                LoginResult result = _loginService.Login(email, password);

                if (result != null && result.User != null)
                {
                    Session["LoggedInUser"] = result.User;

                    switch (result.Role)
                    {
                        case "Admin":
                            Response.Redirect("~/AdminDefault.aspx");
                            break;
                        case "Teacher":
                            Response.Redirect("~/Homepage.aspx");
                            break;
                        case "Student":
                            Response.Redirect("~/Homepage.aspx");
                            break;
                        default:
                            ShowErrorMessage("Invalid user role");
                            break;
                    }
                }
                else
                {
                    ShowErrorMessage("Invalid email or password");
                }
            }
            catch (Exception ex)
            {
                // Log the exception (you might want to add logging here)
                ShowErrorMessage("An error occurred during login. Please try again."+ ex.Message);
            }
        }

        private void ShowErrorMessage(string message)
        {
            pnlError.Visible = true;
            lblError.Text = message;
            
        }
    }
}