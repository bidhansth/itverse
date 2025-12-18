<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="AboutUs.aspx.cs" Inherits="LMS.Pages.Public.AboutUs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>

        /* Container for About Section */
        .about-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 50px;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Content Section */
        .about-content {
            flex: 1;
            padding-right: 50px;
            color: black !important; /* Ensure text inside is black */
        }

        .about-content h2 {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 20px;
            color: black !important; /* Ensure black */
            border-bottom: 2px solid black;
            display: inline-block;
        }

        .about-content p {
            margin-bottom: 20px;
            font-size: 18px;
            color: black !important; /* Ensure black */
        }

        .about-content ul {
            list-style-type: disc;
            padding-left: 20px;
            font-size: 18px;
            color: black !important; /* Ensure black */
        }

        .about-content ul li {
            margin-bottom: 10px;
            position: relative;
            color: black !important; /* Ensure black */
        }

        .about-content ul li::before {
            content: '';
            position: absolute;
            left: -20px;
            top: 8px;
            width: 8px;
            height: 8px;
            background-color: black;
            border-radius: 50%;
        }

        /* Image Section */
        .about-image {
            flex: 1;
            text-align: center;
        }

        /* Image styling remains unchanged */
        .about-image img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        /* Media Queries for Responsiveness */
        @media (max-width: 768px) {
            .about-container {
                flex-direction: column;
                padding: 20px;
            }

            .about-content {
                padding-right: 0;
                text-align: center;
                color: black !important; /* Ensure black on small screens too */
            }

            .about-image {
                margin-top: 20px;
            }
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="about-container">
    <div class="about-content">
        <h2>About ITVerse</h2>
        <p> 
           ITVerse is your gateway to mastering the digital world. Whether you're just starting out or looking to refine your skills, ITVerse provides an engaging and inclusive platform to help you grow in today's ever-evolving tech landscape. Designed for learners, by learners — we believe in making technology accessible, practical, and empowering for everyone.
       </p>
        <p>Our mission is to create a collaborative environment where learning and teaching are seamless, and where programmers can connect and grow together.</p>

        <h3>Our Features</h3>
        <ul>
            <li>Diverse learning resources covering various programming languages and frameworks</li>
            <li>Interactive discussions and community support</li>
            <li>Hands-on assessments to test and improve your skills</li>
            <li>Virtual labs for practical experience</li>
        </ul>
    </div>

    <div class="about-image">
        <img src="/Images/coding.jpg" />
    </div>
</div>
</asp:Content>
