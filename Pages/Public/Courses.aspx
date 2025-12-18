<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="Courses.aspx.cs" Inherits="LMS.Pages.Public.Courses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .course-card {
            transition: transform 0.2s;
            text-decoration: none;
            color: inherit;
        }

        .course-card:hover {
            transform: scale(1.03);
            text-decoration: none;
        }

        .card-img-top {
            height: 200px;
            object-fit: cover;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
        }

        .card-text {
            max-height: 60px;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <form id="form1" runat="server" >
    <header class="bg-dark py-5">
        <div class="container px-4 px-lg-5 my-5">
            <div class="text-center text-white">
                <h1 class="display-4 fw-bolder">Courses</h1>
                <p class="lead fw-normal text-white-50 mb-0">View all of our courses</p>
            </div>
        </div>
    </header>
    <div class="container mt-5">
        <div class="row">
            <div class="row" id="courseContainer" runat="server"></div>
        </div>
    </div>
    </form>
</asp:Content>
