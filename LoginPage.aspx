<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="LoginPage.aspx.cs" Inherits="LMS.LoginPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

  <style>
    .login-page * {
      box-sizing: border-box;
    }

    :root {
      --primary-color: #4f46e5;
      --primary-dark: #4338ca;
      --primary-light: #e0e7ff;
      --secondary-color: #64748b;
      --dark-color: #1e293b;
      --light-color: #f8fafc;
      --gray-100: #f3f4f6;
      --gray-200: #e5e7eb;
      --gray-400: #9ca3af;
      --gray-600: #4b5563;
      --gray-800: #1f2937;
      --white: #ffffff;
      --border-radius: 8px;
      --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
      --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
      --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    }


    .login-page body {
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background-color: #f9fafb;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 1rem;
    }

    .login-page .lp-login-container {
      width: 100%;
      max-width: 500px;
      margin: 0 auto;
      margin-top:20px;
      margin-bottom:20px;
    }

    .login-page .lp-login-form {
      padding: 3rem;
      width: 100%;
    }

    .login-page .lp-login-card {
      background: var(--white);
      border-radius: var(--border-radius);
      box-shadow: var(--shadow-md);
      overflow: hidden;
      border: 1px solid var(--gray-200);
    }

    .login-page .lp-login-header {
      padding: 1.5rem 2rem;
      text-align: center;
      border-bottom: 1px solid var(--gray-200);
    }

    .login-page .lp-brand-logo {
      width: 48px;
      height: 48px;
      background: var(--primary-light);
      border-radius: var(--border-radius);
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 0.75rem;
    }

    .login-page .lp-brand-logo i {
      font-size: 1.5rem;
      color: var(--primary-color);
    }

    .login-page .lp-brand-title {
      color: var(--gray-800);
      font-size: 1.5rem;
      font-weight: 600;
      margin-bottom: 0.25rem;
    }

    .login-page .lp-brand-subtitle {
      color: var(--gray-600);
      font-size: 0.875rem;
      font-weight: 400;
    }

    .login-page .lp-welcome-text {
      text-align: center;
      margin-bottom: 1.5rem;
    }

    .login-page .lp-welcome-title {
      color: var(--gray-800);
      font-size: 1.25rem;
      font-weight: 600;
      margin-bottom: 0.25rem;
    }

    .login-page .lp-welcome-subtitle {
      color: var(--gray-600);
      font-size: 0.875rem;
    }

    .login-page .lp-form-group {
      margin-bottom: 1.25rem;
    }

    .login-page .lp-form-label {
      display: block;
      color: var(--gray-800);
      font-weight: 500;
      font-size: 0.875rem;
      margin-bottom: 0.5rem;
    }

    .login-page .lp-input-group {
      position: relative;
    }

    .login-page .lp-form-control {
      width: 100%;
      padding: 0.75rem 1rem;
      border: 1px solid var(--gray-200);
      border-radius: var(--border-radius);
      font-size: 0.9375rem;
      color: var(--gray-800);
      background: var(--white);
      transition: all 0.2s ease;
    }

    .login-page .lp-form-control:focus {
      outline: none;
      border-color: var(--primary-color);
      box-shadow: 0 0 0 3px var(--primary-light);
    }

    .login-page .lp-form-control.is-invalid {
      border-color: #dc2626;
      box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
    }

    .login-page .lp-password-toggle {
      position: absolute;
      right: 1rem;
      top: 50%;
      transform: translateY(-50%);
      background: none;
      border: none;
      color: var(--gray-400);
      cursor: pointer;
      padding: 0.25rem;
    }

    .login-page .lp-btn-login {
      width: 100%;
      padding: 0.75rem 1.5rem;
      background: var(--primary-color);
      color: var(--white);
      border: none;
      border-radius: var(--border-radius);
      font-size: 0.9375rem;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .login-page .lp-btn-login:hover {
      background: var(--primary-dark);
    }

    .login-page .lp-btn-login:disabled {
      opacity: 0.6;
      cursor: not-allowed;
    }

    .login-page .lp-error-message {
      background: #fef2f2;
      border: 1px solid #fecaca;
      color: #dc2626;
      padding: 0.75rem 1rem;
      border-radius: var(--border-radius);
      font-size: 0.875rem;
      margin-bottom: 1.25rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .login-page .lp-validation-error {
      color: #dc2626;
      font-size: 0.75rem;
      margin-top: 0.25rem;
      display: block;
    }

    @media (max-width: 576px) {
      .login-page .lp-login-form {
        padding: 1.5rem;
      }

      .login-page .lp-login-header {
        padding: 1.25rem;
      }
    }
  </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="login-page">
    <form id="form1" runat="server">
      <div class="lp-login-container">
        <div class="lp-login-card">
          <!-- Header -->
          <div class="lp-login-header">
            <div class="lp-brand-logo">
              <i class="fas fa-graduation-cap"></i>
            </div>
            <h1 class="lp-brand-title">ITVerse</h1>
            <p class="lp-brand-subtitle">Learning Management System</p>
          </div>

          <!-- Form Body -->
          <div class="lp-login-form">
            <div class="lp-welcome-text">
              <h2 class="lp-welcome-title">Welcome Back</h2>
              <p class="lp-welcome-subtitle">Sign in to continue to your account</p>
            </div>

            <asp:Label ID="lblErr" runat="server" Text="" />

            <!-- Error Message -->
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="lp-error-message">
              <i class="fas fa-exclamation-circle"></i>
              <asp:Label ID="lblError" runat="server" Text="" />
            </asp:Panel>

            <!-- Email Field -->
            <div class="lp-form-group">
              <label for="txtEmail" class="lp-form-label">Email Address</label>
              <div class="lp-input-group">
                <asp:TextBox ID="txtEmail" runat="server"
                             CssClass="lp-form-control"
                             placeholder="Enter your email"
                             TextMode="Email"
                             autocomplete="email" />
              </div>
              <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                  ControlToValidate="txtEmail"
                  ErrorMessage="Email is required"
                  CssClass="lp-validation-error"
                  Display="Dynamic" />
              <asp:RegularExpressionValidator ID="revEmail" runat="server"
                  ControlToValidate="txtEmail"
                  ValidationExpression="^[^\s@]+@[^\s@]+\.[^\s@]+$"
                  ErrorMessage="Please enter a valid email address"
                  CssClass="lp-validation-error"
                  Display="Dynamic" />
            </div>

            <!-- Password Field -->
            <div class="lp-form-group">
              <label for="txtPassword" class="lp-form-label">Password</label>
              <div class="lp-input-group">
                <asp:TextBox ID="txtPassword" runat="server"
                             CssClass="lp-form-control"
                             placeholder="Enter your password"
                             TextMode="Password"
                             autocomplete="current-password" />
                <button type="button" class="lp-password-toggle" onclick="togglePassword()">
                  <i class="fas fa-eye" id="passwordToggleIcon"></i>
                </button>
              </div>
              <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                  ControlToValidate="txtPassword"
                  ErrorMessage="Password is required"
                  CssClass="lp-validation-error"
                  Display="Dynamic" />
            </div>

            <!-- Login Button -->
            <asp:Button ID="btnLogin" runat="server"
                        Text="Sign In"
                        OnClick="btnLogin_Click"
                        CssClass="lp-btn-login" />

            <div class="mt-3 text-center">
              <span>Not registered?</span>
              <a href="RegistrationPage.aspx">Register</a>
            </div>
          </div>
        </div>
      </div>
    </form>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>

    <script>
        // Password Toggle
        function togglePassword() {
            const passwordField = document.getElementById('<%= txtPassword.ClientID %>');
            const toggleIcon = document.getElementById('passwordToggleIcon');

            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
    </script>
  </div>
</asp:Content>
