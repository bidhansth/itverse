<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master"  CodeBehind="TeacherDashboard.aspx.cs" Inherits="LMS.Pages.Teachers.TeacherDashboard" %>

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
            </div>

            <!-- Right panel -->
            <div class="col-md-8">
                <h3>Courses</h3>
                <div class="border rounded p-3">
                    <div class="col" id="cardsContainer" runat="server">
 
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>
</asp:Content>

