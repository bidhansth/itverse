<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="SearchCourse.aspx.cs" Inherits="LMS.Pages.Public.SearchCourse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <form id="form1" runat="server" >
        <header class="bg-dark py-5">
        <div class="container px-4 px-lg-5 my-5">
            <div class="text-center text-white">
                <h1 class="display-4 fw-bolder">Courses</h1>
            </div>
        </div>
    </header>
    <div class="container mt-5">
        <div class="row">
            <div class="col" id="cardsContainer" runat="server">

            </div>
        </div>
    </div>
         </form>
</asp:Content>
