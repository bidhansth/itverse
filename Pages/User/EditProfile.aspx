<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="EditProfile.aspx.cs" Inherits="LMS.Pages.User.EditProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <form id="form1" runat="server" >
    <div class="container mt-3">
        <div class="row">
            <div class="col-sm-6">
                <h3>Edit Profile</h3>

                <asp:Label ID="lblMessage" runat="server" CssClass="text-success" EnableViewState="false"></asp:Label>

                <div class="form-group">
                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true" />
                </div>

                <div class="form-group">
                    <label>First Name</label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" required="required" />
                </div>

                <div class="form-group">
                    <label>Last Name</label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" required="required" />
                </div>

                <div class="form-group">
                    <label>Date of Birth</label>
                    <asp:TextBox ID="txtDOB" runat="server" TextMode="Date" CssClass="form-control" required="required" />
                </div>

                <div class="form-group">
                    <label>Gender</label>
                    <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control" required="required">
                        <asp:ListItem Text="Select Gender" Value="" />
                        <asp:ListItem Text="Male" Value="1" />
                        <asp:ListItem Text="Female" Value="2" />
                        <asp:ListItem Text="Other" Value="3" />
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label>Contact Number</label>
                    <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" required="required" />
                </div>

                <div class="form-group">
                    <label>Profile Picture</label>
                    <asp:FileUpload ID="fuProfilePic" runat="server" />
                    <asp:Image ID="imgProfile" runat="server" Width="100" class="d-block mt-2" />
                </div>

                <asp:Button ID="btnUpdate" runat="server" CssClass="btn btn-primary" Text="Update Profile" OnClick="btnUpdate_Click" />
            </div>
        </div>
    </div>
</form>
</asp:Content>

