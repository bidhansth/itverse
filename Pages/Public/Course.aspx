<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="Course.aspx.cs" Inherits="LMS.Pages.Public.Course" %>

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
                    <p class="card-text">View notes, slides, and reading material.</p>
                </div>
            </div>
            </asp:HyperLink>

            <asp:HyperLink ID="hlAssignments" runat="server" CssClass="text-decoration-none">
            <div class="card mb-3 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Assignments</h5>
                    <p class="card-text">Submit and view assignment status.</p>
                </div>
            </div>
            </asp:HyperLink>

            <asp:HyperLink ID="hlForum" runat="server" CssClass="text-decoration-none">
            <div class="card mb-3 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Forum</h5>
                    <p class="card-text">Join discussions and ask questions.</p>
                </div>
            </div>
            </asp:HyperLink>

            <asp:Button ID="btnEnrollUnenroll" runat="server" OnClick="btnEnrollUnenroll_Click" CssClass="btn btn-outline-info" Style="width:200px; margin-left:10px;"/>
            <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
   </form>
</asp:Content>
