<%@ Page Language="C#" AutoEventWireup="true"  MasterPageFile="~/MasterPages/Public.Master" CodeBehind="TeacherCourse.aspx.cs" Inherits="LMS.Pages.Teachers.TeacherCourse" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <form id="form1" runat="server" >
    <header class="bg-dark py-5">
    <div class="container px-4 px-lg-5 my-5">
        <div class="text-center text-white">
            <h1 class="display-4 fw-bolder" id="courseTitle" runat="server">Course</h1>
        </div>
    </div>
</header>
<div class="container">
    <div class="row mt-4">
        <asp:HyperLink ID="hlResources" runat="server" CssClass="text-decoration-none">
<div class="card mb-3 shadow-sm">
    <div class="card-body">
        <h5 class="card-title">Resources</h5>
        <p class="card-text">Add notes, slides, and reading material.</p>
    </div>
</div>
        </asp:HyperLink>

        <asp:HyperLink ID="hlAssignments" runat="server" CssClass="text-decoration-none">
<div class="card mb-3 shadow-sm">
    <div class="card-body">
        <h5 class="card-title">Assignments</h5>
        <p class="card-text">Add assignments.</p>
    </div>
</div>
        </asp:HyperLink>

        <asp:HyperLink ID="hlForum" runat="server" CssClass="text-decoration-none">
<div class="card mb-3 shadow-sm">
    <div class="card-body">
        <h5 class="card-title">Forum</h5>
        <p class="card-text">Join discussions and answer questions.</p>
    </div>
</div>
        </asp:HyperLink>

    </div>
</div>
         </form>
</asp:Content>


