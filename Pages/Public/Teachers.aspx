<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="Teachers.aspx.cs" Inherits="LMS.Pages.Public.Teachers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <header class="bg-dark py-5">
        <div class="container px-4 px-lg-5 my-5">
            <div class="text-center text-white">
                <h1 class="display-4 fw-bolder">Teachers</h1>
                <p class="lead fw-normal text-white-50 mb-0">View all of our teachers</p>
            </div>
        </div>
    </header>
    <div class="container mt-5">
        <div class="row">
            <div class="col" id="teachersDiv" runat="server">

            </div>
        </div>
    </div>
</asp:Content>
