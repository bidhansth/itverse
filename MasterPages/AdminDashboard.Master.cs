using LMS.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.MasterPages
{
    public partial class AdminDashboard : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LoggedInUser"] != null)
            {
                if (Session["LoggedInUser"] is Admin admin)
                {
                    lblAdminName.Text = $"Welcome, {admin.FirstName}";
                    if (!string.IsNullOrEmpty(admin.ProfilePicture))
                    {
                        imgProfile.ImageUrl = ResolveUrl(admin.ProfilePicture);
                    }
                    else
                    {
                        string avatarUrl = "https://ui-avatars.com/api/?name=" +
                                           Server.UrlEncode(admin.FirstName) +
                                           "&background=2563eb&color=ffffff&size=40";
                        imgProfile.ImageUrl = avatarUrl;
                    }
                }
            }
            else
            {
                Response.Redirect("~/LoginPage.aspx");
            }
        }
    }
}
