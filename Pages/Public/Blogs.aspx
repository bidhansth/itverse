<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="Blogs.aspx.cs" Inherits="LMS.Pages.Public.Blogs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link rel="stylesheet" href="<%: ResolveUrl("~/Styles/blog.css") %>" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <main class="container my-5">
        <h1 class="text-center fw-bold mb-5">Our Blog</h1>
        <div class="row g-4">

            <!-- Blog Post Card 1 -->
            <div class="col-md-4">
                <div class="blog-card">
                    <img src='<%= ResolveUrl("~/Images/data.jpg") %>' alt="Post 1" class="img-fluid rounded-top" />
                    <div class="blog-card-body">
                        <h4 class="blog-title">How to Start Learning Data Science</h4>
                        <p class="blog-summary">A beginner-friendly guide to kickstart your journey in the field of Data Science with practical steps.</p>
                        <a href="BlogDetail.aspx" class="read-more">Read More →</a>
                    </div>
                </div>
            </div>

            <!-- Blog Post Card 2-->
            <div class="col-md-4">
                <div class="blog-card">
                    <img src='<%= ResolveUrl("~/Images/studying1.jpg") %>' alt="Post 2" class="img-fluid rounded-top" />
                    <div class="blog-card-body">
                        <h4 class="blog-title">Top 5 Cybersecurity Practices in 2025</h4>
                        <p class="blog-summary">Learn how to protect your systems, networks, and personal data using modern cybersecurity tools and tips.</p>
                        <a href="BlogDetail.aspx" class="read-more">Read More →</a>
                    </div>
                </div>
            </div>

            <!-- Blog Post Card 3-->
            <div class="col-md-4">
                <div class="blog-card">
                    <img src='<%= ResolveUrl("~/Images/cloud.jpg") %>' alt="Post 3" class="img-fluid rounded-top" />
                    <div class="blog-card-body">
                        <h4 class="blog-title">Why Cloud Computing Matters in Nepal</h4>
                        <p class="blog-summary">Discover how cloud technology is transforming businesses in Nepal and what you should know about it.</p>
                        <a href="BlogDetail.aspx" class="read-more">Read More →</a>
                    </div>
                </div>
            </div>

        </div>
    </main>
</asp:Content>
