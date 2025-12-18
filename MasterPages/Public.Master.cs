using LMS.Model;
using LMS.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.MasterPages
{
    public partial class Public : System.Web.UI.MasterPage
    {
        public string conStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LoggedInUser"] != null)
            {
                if (Session["LoggedInUser"] is Teacher teacher)
                {
                    lblUserName.Text = $"Welcome, {teacher.FirstName}";

                    if (!string.IsNullOrEmpty(teacher.ProfilePicture))
                        imgProfile.ImageUrl = ResolveUrl(teacher.ProfilePicture);
                    else
                        imgProfile.ImageUrl = $"https://ui-avatars.com/api/?name={Server.UrlEncode(teacher.FirstName)}&background=2563eb&color=ffffff&size=40";

                    lnkProfile.HRef = "/Pages/Teachers/TeacherDashboard.aspx";
                }
                else if (Session["LoggedInUser"] is Student student)
                {
                    lblUserName.Text = $"Welcome, {student.FirstName}";

                    if (!string.IsNullOrEmpty(student.ProfilePicture))
                        imgProfile.ImageUrl = ResolveUrl(student.ProfilePicture);
                    else
                        imgProfile.ImageUrl = $"https://ui-avatars.com/api/?name={Server.UrlEncode(student.FirstName)}&background=2563eb&color=ffffff&size=40";

                    lnkProfile.HRef = "/Pages/User/UserProfile.aspx";
                }

                pnlProfile.Visible = true;
                btnLogout.Visible = true;
                btnLogin.Visible = false;
            }
            else
            {
                pnlProfile.Visible = false;
                btnLogout.Visible = false;
                btnLogin.Visible = true;
            }

        }

    }
}