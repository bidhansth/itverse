<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="ChangeUserPassword.aspx.cs" Inherits="LMS.Pages.User.ChangeUserPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <form id="form1" runat="server" >
    <div class="container mt-3">
        <div class="row">
            <div class="col-sm-6">
                <h3 class="mb-4">Change Password</h3>

                <asp:Label ID="lblMessage" runat="server" CssClass="text-success"></asp:Label>

                <div class="mb-3">
                    <label for="txtCurrentPassword" class="form-label">Current Password</label>
                    <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password" required="required" />
                </div>

                <div class="mb-3">
                    <label for="txtNewPassword" class="form-label">New Password</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" required="required" />
                </div>

                <div class="mb-3">
                    <label for="txtConfirmPassword" class="form-label">Confirm New Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" required="required" />
                </div>

                <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" CssClass="btn btn-primary" OnClick="btnChangePassword_Click" />


            </div>
        </div>
    </div>
         </form>
</asp:Content>
