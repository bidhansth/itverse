<%@ Page Title="Student Registration" Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master"  CodeBehind="RegistrationPage.aspx.cs" Inherits="LMS.UserManagement.StudentMangement.RegistrationPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --card-bg: #ffffff;
            --radius: 8px;
            --shadow-md: 0 10px 30px rgba(0, 0, 0, 0.08);
            --focus-border: #3498db;
            --text-color: #2c3e50;
            --muted: #6c757d;
        }

        .registration-page * {
            box-sizing: border-box;
        }

        .reg-container {
            width: 100%;
            max-width: 600px;
            margin: 50px auto; /* top and bottom breathing room */
            padding: 30px;
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow-md);
            position: relative;
        }

        .reg-header {
            margin-top: 1rem;
            margin-bottom: 2rem;
            text-align: center;
        }

        .reg-header h1 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 1.75rem;
        }

        .reg-form-group {
            margin-bottom: 20px;
        }

        .reg-form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: var(--text-color);
        }

        .reg-form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
            transition: border-color .2s, box-shadow .2s;
        }

        .reg-form-control:focus {
            border-color: var(--focus-border);
            outline: none;
            box-shadow: 0 0 0 3px rgba(52,152,219,0.2);
        }

        .reg-btn {
            background-color: #4f46E5;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background-color 0.3s;
        }

        .reg-btn:hover {
            background-color: #4338ca;
        }

        .reg-btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .reg-btn-secondary:hover {
            background-color: #5a6268;
        }

        .reg-validation-message {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 5px;
            display: block;
        }

        .reg-gender-options {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .reg-gender-option {
            flex: 1;
            text-align: center;
        }

        .reg-gender-btn {
            width: 100%;
            padding: 10px;
            background: #f8f9fa;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            transition: background .2s, border-color .2s;
        }

        .reg-gender-btn.selected {
            background: #3498db;
            color: white;
            border-color: #3498db;
        }

        .reg-photo-upload {
            text-align: center;
            margin: 20px 0;
        }

        .reg-photo-preview {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 3px solid #ddd;
            margin: 0 auto 15px;
            overflow: hidden;
            position: relative;
            background-color: #f8f9fa;
        }

        .reg-photo-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: none;
        }

        .reg-photo-placeholder {
            font-size: 50px;
            color: #adb5bd;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        .reg-file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
        }

        .reg-file-input-wrapper input[type="file"] {
            position: absolute;
            left: -9999px;
        }

        .reg-file-info {
            margin-top: 10px;
            font-size: 14px;
            color: var(--muted);
        }

        .reg-footer-note {
            text-align: center;
            margin-top: 30px; /* bottom breathing room */
            font-size: 0.85rem;
            color: #6b7280;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="registration-page">
    <form id="form1" runat="server" enctype="multipart/form-data">
      <div class="reg-container">
        <div class="reg-header">
          <h1><i class="fas fa-user-plus"></i> Registration Form</h1>
        </div>

        <div class="reg-photo-upload">
          <div class="reg-photo-preview">
            <i class="fas fa-user reg-photo-placeholder" id="photoPlaceholder"></i>
            <img id="photoPreview" alt="Preview" />
          </div>
          <div class="reg-file-input-wrapper">
            <asp:FileUpload ID="fuProfilePhoto" runat="server" 
                accept="image/*" 
                onchange="previewPhoto(this)" 
                style="display: none;" />
            <button type="button" class="reg-btn reg-btn-secondary" onclick="document.getElementById('<%= fuProfilePhoto.ClientID %>').click();">
              <i class="fas fa-camera"></i> Choose Photo
            </button>
          </div>
          <div class="reg-file-info">Max size: 2MB (JPG, PNG)</div>
          <asp:CustomValidator ID="cvProfilePhoto" runat="server" 
              ErrorMessage="Please upload a valid image file (max 2MB)" 
              CssClass="reg-validation-message" Display="Dynamic"
              ClientValidationFunction="validatePhoto"
              OnServerValidate="cvProfilePhoto_ServerValidate"></asp:CustomValidator>
        </div>

        <div class="reg-form-group">
          <label for="txtFirstName">First Name</label>
          <asp:TextBox ID="txtFirstName" runat="server" CssClass="reg-form-control" placeholder="First Name"></asp:TextBox>
          <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" 
              ControlToValidate="txtFirstName" ErrorMessage="First name is required" 
              CssClass="reg-validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>

        <div class="reg-form-group">
          <label for="txtLastName">Last Name</label>
          <asp:TextBox ID="txtLastName" runat="server" CssClass="reg-form-control" placeholder="Last Name"></asp:TextBox>
          <asp:RequiredFieldValidator ID="rfvLastName" runat="server" 
              ControlToValidate="txtLastName" ErrorMessage="Last name is required" 
              CssClass="reg-validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>

        <div class="reg-form-group">
          <label for="txtEmail">Email</label>
          <asp:TextBox ID="txtEmail" runat="server" CssClass="reg-form-control" 
              TextMode="Email" placeholder="student@example.com"></asp:TextBox>
          <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
              ControlToValidate="txtEmail" ErrorMessage="Email is required" 
              CssClass="reg-validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
          <asp:RegularExpressionValidator ID="revEmail" runat="server" 
              ControlToValidate="txtEmail" ErrorMessage="Invalid email format" 
              ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" 
              CssClass="reg-validation-message" Display="Dynamic"></asp:RegularExpressionValidator>
        </div>

        <div class="reg-form-group">
          <label for="txtDateOfBirth">Date of Birth</label>
          <asp:TextBox ID="txtDateOfBirth" runat="server" CssClass="reg-form-control" 
              TextMode="Date"></asp:TextBox>
          <asp:RequiredFieldValidator ID="rfvDateOfBirth" runat="server" 
              ControlToValidate="txtDateOfBirth" ErrorMessage="Date of birth is required" 
              CssClass="reg-validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>

        <div class="reg-form-group">
          <label>Gender</label>
          <div class="reg-gender-options">
            <div class="reg-gender-option">
              <button type="button" class="reg-gender-btn" onclick="selectGender('Male', this)">
                  <i class="fas fa-male"></i> Male
              </button>
            </div>
            <div class="reg-gender-option">
              <button type="button" class="reg-gender-btn" onclick="selectGender('Female', this)">
                  <i class="fas fa-female"></i> Female
              </button>
            </div>
            <div class="reg-gender-option">
              <button type="button" class="reg-gender-btn" onclick="selectGender('Other', this)">
                  <i class="fas fa-genderless"></i> Other
              </button>
            </div>
          </div>
          <asp:HiddenField ID="hdnGender" runat="server" />
          <asp:CustomValidator ID="cvGender" runat="server" 
              ErrorMessage="Please select a gender" 
              CssClass="reg-validation-message" Display="Dynamic"
              ClientValidationFunction="validateGender"></asp:CustomValidator>
        </div>

        <div class="reg-form-group">
          <label for="txtContactNumber">Contact Number</label>
          <asp:TextBox ID="txtContactNumber" runat="server" 
              CssClass="reg-form-control" 
              placeholder="+977 xxxxxxxxxx"
              MaxLength="15" />
          <asp:RegularExpressionValidator ID="revContactNumber" runat="server" 
              ControlToValidate="txtContactNumber"
              ErrorMessage="Please enter a valid phone number"
              ValidationExpression="^(\+977)?9\d{9}$"
              CssClass="reg-validation-message"
              Display="Dynamic" />
        </div>

        <div class="reg-form-group">
          <label for="txtPassword">Password</label>
          <asp:TextBox ID="txtPassword" runat="server" CssClass="reg-form-control" 
              TextMode="Password" placeholder="Password"></asp:TextBox>
          <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
              ControlToValidate="txtPassword" ErrorMessage="Password is required" 
              CssClass="reg-validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>

        <div class="reg-form-group">
          <label for="txtConfirmPassword">Confirm Password</label>
          <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="reg-form-control" 
              TextMode="Password" placeholder="Confirm Password"></asp:TextBox>
          <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
              ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm password" 
              CssClass="reg-validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
          <asp:CompareValidator ID="cvPassword" runat="server" 
              ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" 
              ErrorMessage="Passwords do not match" CssClass="reg-validation-message" 
              Display="Dynamic"></asp:CompareValidator>
        </div>

        <div class="reg-form-group">
          <asp:Button ID="btnRegister" runat="server" Text="Register" 
              CssClass="reg-btn" OnClick="btnRegister_Click" />
        </div>

        <div class="reg-form-group" style="text-align: center; margin-top: 20px;">
          <span>Already registered?</span>
          <a href="LoginPage.aspx" style="margin-left: 5px; color: #3498db; text-decoration: none;">Login</a>
        </div>

        <div class="reg-form-group" style="text-align: center;">
          <asp:Label ID="lblMessage" runat="server" CssClass="reg-validation-message"></asp:Label>
        </div>

        <div class="reg-footer-note">
          © ITVerse LMS • All rights reserved.
        </div>
      </div>
    </form>
  </div>

  <script>
      function selectGender(gender, element) {
          document.querySelectorAll('.reg-gender-btn').forEach(btn => {
              btn.classList.remove('selected');
          });
          element.classList.add('selected');
          document.getElementById('<%= hdnGender.ClientID %>').value = gender;
    }

    function validateGender(sender, args) {
        var gender = document.getElementById('<%= hdnGender.ClientID %>').value;
        args.IsValid = gender !== '';
    }

    function previewPhoto(input) {
        if (input.files && input.files[0]) {
            var file = input.files[0];

            if (file.size > 2 * 1024 * 1024) {
                alert('File size must be less than 2MB');
                input.value = '';
                return;
            }

            if (!file.type.match('image.*')) {
                alert('Please select an image file (JPG, PNG)');
                input.value = '';
                return;
            }

            var reader = new FileReader();
            reader.onload = function(e) {
                var preview = document.getElementById('photoPreview');
                var placeholder = document.getElementById('photoPlaceholder');

                preview.src = e.target.result;
                preview.style.display = 'block';
                placeholder.style.display = 'none';
            };
            reader.readAsDataURL(file);
        }
    }

    function validatePhoto(sender, args) {
        var fileUpload = document.getElementById('<%= fuProfilePhoto.ClientID %>');
          args.IsValid = fileUpload.files.length > 0;
      }
  </script>
</asp:Content>
