<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="ContactUs.aspx.cs" Inherits="LMS.Pages.Public.ContactUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>       
        body {
           font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .header {
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('/imgs/city-banner.jpg') no-repeat center center;
            background-size: cover;
            height: 150px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .header h1 {
            font-size: 42px;
            margin-bottom: 12px;
            color: #FF5722;
            font-weight: 700;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            letter-spacing: 1px;
        }

        .header p {
            font-size: 16px;
            max-width: 700px;
            margin: 0 auto;
            padding: 0 15px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
        }

        .contact-section {
            display: flex;
            justify-content: center;
            gap: 25px;
            padding: 60px 10px;
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            flex-wrap: wrap;
            max-width: 1400px;
            margin: 0 auto;
        }

        .contact-card {
            flex: 1 1 280px;
            max-width: 320px;
            padding: 30px 20px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 1px solid #e9ecef;
            position: relative;
        }

        .contact-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #FF5722, #FF8A50);
        }

        .contact-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 14px 32px rgba(0, 0, 0, 0.15);
        }

        .icon-container {
            width: 65px;
            height: 65px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #FF5722, #FF8A50);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .contact-card img {
            width: 32px;
            height: 32px;
            filter: brightness(0) invert(1);
        }

        .contact-card h3 {
            color: #2c3e50;
            font-size: 20px;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .contact-card p {
            color: #6c757d;
            font-size: 14px;
            margin: 8px 0;
        }

        .contact-card .highlight {
            color: #FF5722;
            font-weight: 700;
            font-size: 15px;
            margin-top: 12px;
            padding: 8px;
            background: rgba(255, 87, 34, 0.1);
            border-radius: 6px;
            border-left: 4px solid #FF5722;
        }

        @media (max-width: 768px) {
            .header h1 {
                font-size: 32px;
            }

            .contact-section {
                padding: 30px 10px;
            }

            .contact-card {
                margin: 15px 0;
            }
        }

        @media (max-width: 480px) {
            .header {
                height: 220px;
            }

            .header h1 {
                font-size: 26px;
            }

            .contact-card {
                padding: 25px 15px;
            }
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="header">
        <h1>CONTACT US</h1>
        <p>Need an expert? You are more than welcome to leave your contact info and we will be in touch shortly.</p>
    </div>

    <div class="contact-section">
        <!-- Visit Us -->
        <div class="contact-card">
            <div class="icon-container">
                <img src="/Images/visit.svg" alt="Visit Us" />
            </div>
            <h3>VISIT US</h3>
            <p>Come and visit our office at the heart of the city.</p>
            <p class="highlight">Maitidevi, Kathmandu</p>
        </div>

        <!-- Call Us -->
        <div class="contact-card">
            <div class="icon-container">
                <img src="/Images/call.svg" alt="Call Us" />
            </div>
            <h3>CALL US</h3>
            <p>We are always happy to chat and answer your questions.</p>
            <p class="highlight">015970295</p>
        </div>

        <!-- Email Us -->
        <div class="contact-card">
            <div class="icon-container">
                <img src="/Images/email.svg" alt="Email Us" />
            </div>
            <h3>EMAIL US</h3>
            <p>Send us an email anytime and we'll respond quickly.</p>
            <p class="highlight">info@itverse.com</p>
        </div>
    </div>
</asp:Content>