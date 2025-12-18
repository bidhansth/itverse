<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="Forum.aspx.cs" Inherits="LMS.Pages.Public.Forum" %>

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
    <div class="container py-4">
        <h2 class="mb-4">Forum</h2>

        <asp:HyperLink ID="btnAsk" runat="server" CssClass="btn btn-primary mb-4">Ask a Question</asp:HyperLink>

        <asp:Literal ID="litQuestions" runat="server" />
    </div>
</form>
</asp:Content>
