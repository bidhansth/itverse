<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="UserProfile.aspx.cs" Inherits="LMS.Pages.User.UserProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>
    .profile-pic {
        width: 150px;
        height: 150px;
        object-fit: cover;
        border-radius: 50%;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <form id="form1" runat="server" >
    <div class="container py-4">
        <div class="row">
            <!-- Left panel -->
            <div class="col-md-4 text-center">
                <asp:Image ID="imgProfile" runat="server" CssClass="profile-pic mb-3" ImageUrl="~/images/default.png" />
                <h4>
                    <asp:Label ID="lblFullName" runat="server" /></h4>
                <p><strong>Email:</strong>
                    <asp:Label ID="lblEmail" runat="server" /></p>
                <p><strong>Contact:</strong>
                    <asp:Label ID="lblContact" runat="server" /></p>
                <p>
                    <asp:Button ID="btnEditProfile" runat="server" Text="Edit Profile" PostBackUrl="/Pages/User/EditProfile.aspx" CssClass="btn btn-outline-success" Style="width:200px;" />
                </p>
                <p>
                    <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" PostBackUrl="/Pages/User/ChangeUserPassword.aspx" CssClass="btn btn-outline-success" Style="width:200px;" />
                </p>
            </div>

            <!-- Right panel -->
            <div class="col-md-8">
                <h3>My Courses</h3>
                <div class="border rounded p-3">
                    <div class="col" id="cardsContainer" runat="server">
 
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>
</asp:Content>