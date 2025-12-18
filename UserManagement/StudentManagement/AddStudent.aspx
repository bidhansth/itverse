<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/AdminDashboard.Master" AutoEventWireup="true" CodeBehind="AddStudent.aspx.cs" Inherits="LMS.UserManagement.StudentMangement.AddStudent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <!-- Modern CSS Libraries -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/11.7.32/sweetalert2.min.css">
    
    <style>
        :root {
            --primary-color: #667eea;
            --primary-gradient: #2563eb;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --info-color: #3b82f6;
            --dark-color: #1f2937;
            --light-color: #f8fafc;
            --border-radius: 16px;
            --shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
        }


        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-color);
            margin: 0;
        }

        /* Page Header */
        .page-header {
            background: #ffffff;
            color: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.1;
        }

        .page-header .page-title {
            font-size: 1.9rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 1;
            color: #111827;
        }

        .page-header .page-subtitle {
            font-size: 1rem;
            opacity: 0.9;
            font-weight: 300;
            position: relative;
            z-index: 1;
            color:#9ca3af;
        }

        /* Form Container */
        .form-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: var(--border-radius);
            padding: 2.5rem;
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.03) 0%, transparent 70%);
            animation: float 8s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-10px) rotate(180deg); }
        }

        .form-content {
            position: relative;
            z-index: 1;
        }

        /* Form Section Headers */
        .form-section {
            margin-bottom: 2.5rem;
        }

        .section-header {
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid rgba(102, 126, 234, 0.1);
        }

        .section-icon {
            background: var(--primary-gradient);
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            font-size: 1.2rem;
            box-shadow: var(--shadow-md);
        }

        /* Modern Form Controls */
        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            font-size: 0.95rem;
        }

        .form-label i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }

        .form-label .required {
            color: var(--danger-color);
            margin-left: 0.25rem;
        }


         .form-control {
            border: 2px solid rgba(102, 126, 234, 0.2);
            border-radius: 12px;
            padding: 0.875rem 1rem;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            color: #222429;
         }


        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            outline: none;
            background: rgba(255, 255, 255, 1);
        }

        .form-control:hover {
            border-color: rgba(102, 126, 234, 0.4);
        }

        /* Profile Picture Upload */
        .profile-upload-container {
            text-align: center;
            margin-bottom: 2rem;
        }

        .profile-preview {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 4px solid var(--primary-color);
            margin: 0 auto 1rem;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .profile-preview:hover {
            transform: scale(1.05);
            box-shadow: var(--shadow-xl);
        }

        .profile-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-placeholder {
            font-size: 4rem;
            color: rgba(102, 126, 234, 0.3);
        }

        .upload-btn {
            background: var(--primary-gradient);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-md);
        }

        .upload-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        /* Gender Selection */
        .gender-options {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .gender-option {
            flex: 1;
            min-width: 120px;
        }

        .gender-card {
            background: rgba(255, 255, 255, 0.8);
            border: 2px solid rgba(102, 126, 234, 0.2);
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .gender-card:hover {
            border-color: var(--primary-color);
            background: rgba(255, 255, 255, 1);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .gender-card.selected {
            border-color: var(--primary-color);
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(255, 255, 255, 1) 100%);
            box-shadow: var(--shadow-md);
        }

        .gender-card i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .gender-card.male i { color: #3b82f6; }
        .gender-card.female i { color: #ec4899; }
        .gender-card.other i { color: #8b5cf6; }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid rgba(102, 126, 234, 0.1);
        }

        .btn-modern {
            padding: 0.625rem 1.25rem;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.15s ease;
            border: none;
            position: relative;
            overflow: hidden;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.8rem;
            min-width: 150px;
        }

        .btn-modern::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            transition: left 0.3s ease;
        }

        .btn-modern:hover::before {
            left: 100%;
        }

        .btn-primary-modern {
            background: #0d6efd;
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
        }

        .btn-secondary-modern {
            background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(107, 114, 128, 0.4);
        }

        .btn-secondary-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(107, 114, 128, 0.6);
        }

        /* Validation Messages */
        .validation-message {
            color: var(--danger-color);
            font-size: 0.85rem;
            margin-top: 0.25rem;
            display: flex;
            align-items: center;
        }

        .validation-message i {
            margin-right: 0.25rem;
        }

        /* Loading Overlay */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            z-index: 9999;
            display: none;
            align-items: center;
            justify-content: center;
        }

        .loading-content {
            background: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            text-align: center;
            box-shadow: var(--shadow-xl);
        }

        .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid rgba(102, 126, 234, 0.2);
            border-left: 4px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 1rem;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-slide-up {
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-header {
                padding: 1.5rem;
            }
            
            .page-header .page-title {
                font-size: 2rem;
            }
            
            .form-container {
                padding: 1.5rem;
            }
            
            .gender-options {
                flex-direction: column;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-modern {
                min-width: auto;
                width: 100%;
            }
            
            .profile-preview {
                width: 120px;
                height: 120px;
            }
        }

        /* Custom File Input */
        .file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
        }

        .file-input-wrapper input[type=file] {
            position: absolute;
            left: -9999px;
        }

        /* Date Input Enhancement */
        .form-control[type="date"] {
            color-scheme: light;
        }

        .form-control[type="date"]::-webkit-calendar-picker-indicator {
            background: var(--primary-color);
            border-radius: 3px;
            cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <nav aria-label="breadcrumb" class="animate-fade-in">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href='<%= ResolveUrl("~/AdminDefault.aspx") %>'><i class="fas fa-home me-1"></i>Dashboard</a></li>
            <li class="breadcrumb-item"><a href='<%= ResolveUrl("~/UserManagement/StudentManagement/StudentManagement.aspx") %>'><i class="fas fa-users me-1"></i>Student Management</a></li>
            <li class="breadcrumb-item active"><i class="fas fa-user-plus me-1"></i>Add Student</li>
        </ol>
    </nav>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-content">
            <div class="spinner"></div>
            <h5>Adding Student...</h5>
            <p class="text-muted mb-0">Please wait while we process the information</p>
        </div>
    </div>

    <!-- Page Header -->

    <div class="page-header animate-slide-up">
    <div class="d-flex justify-content-between align-items-center">
        <div>
            <h1 runat="server" id="lblPageTitle" class="page-title mb-2">
                <i runat="server" id="iconTitle" class="fas fa-user-plus me-3"></i>
                <asp:Literal ID="litPageTitle" runat="server" Text="Add New Student"></asp:Literal>
            </h1>

            <p runat="server" id="lblPageSubtitle" class="page-subtitle mb-0">
                Register a new student to the learning management system
            </p>
        </div>
    </div>
</div>


    <!-- Form Container -->
    <div class="form-container animate-fade-in">
        <div class="form-content">
           
                <!-- Profile Picture Section -->
                <div class="form-section">
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-camera"></i>
                        </div>
                        <h3 class="section-title">Profile Picture</h3>
                    </div>
                    
                    <div class="profile-upload-container">
                        <div class="profile-preview" id="profilePreview">
                            <i class="fas fa-user profile-placeholder" id="profilePlaceholder"></i>
                            <img id="profileImage" style="display: none;" alt="Profile Preview" />
                        </div>
                        <div class="file-input-wrapper">
                            <asp:FileUpload ID="fuProfilePicture" runat="server" 
                                accept="image/*" 
                                onchange="previewProfileImage(this)" 
                                CssClass="form-control" />
                            <button type="button" class="upload-btn" onclick="document.getElementById('<%= fuProfilePicture.ClientID %>').click();">
                                <i class="fas fa-cloud-upload-alt me-2"></i>Choose Photo
                            </button>
                        </div>
                        <div>
                             <small class="text-muted">Supported formats: JPG, PNG, GIF (Max: 5MB)</small>
                        </div>
                       
                    </div>
                </div>

                <!-- Personal Information Section -->
                <div class="form-section">
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-user"></i>
                        </div>
                        <h3 class="section-title">Personal Information</h3>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-signature"></i>First Name<span class="required">*</span>
                                </label>
                                <asp:TextBox ID="txtFirstName" runat="server" 
                                    CssClass="form-control" 
                                    placeholder="Enter first name"
                                    MaxLength="50" />
                                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" 
                                    ControlToValidate="txtFirstName"
                                    ErrorMessage="First name is required"
                                    CssClass="validation-message"
                                    Display="Dynamic">
                                    <i class="fas fa-exclamation-circle"></i> First name is required
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-signature"></i>Last Name<span class="required">*</span>
                                </label>
                                <asp:TextBox ID="txtLastName" runat="server" 
                                    CssClass="form-control" 
                                    placeholder="Enter last name"
                                    MaxLength="50" />
                                <asp:RequiredFieldValidator ID="rfvLastName" runat="server" 
                                    ControlToValidate="txtLastName"
                                    ErrorMessage="Last name is required"
                                    CssClass="validation-message"
                                    Display="Dynamic">
                                    <i class="fas fa-exclamation-circle"></i> Last name is required
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-calendar-alt"></i>Date of Birth<span class="required">*</span>
                                </label>
                                <asp:TextBox ID="txtDateOfBirth" runat="server" 
                                    CssClass="form-control" 
                                    TextMode="Date"
                                    onchange="calculateAge()" />
                                <asp:RequiredFieldValidator ID="rfvDateOfBirth" runat="server" 
                                    ControlToValidate="txtDateOfBirth"
                                    ErrorMessage="Date of birth is required"
                                    CssClass="validation-message"
                                    Display="Dynamic">
                                    <i class="fas fa-exclamation-circle"></i> Date of birth is required
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-hashtag"></i>Age
                                </label>
                                <asp:TextBox ID="txtAge" runat="server" 
                                    CssClass="form-control" 
                                    placeholder="Age will be calculated"
                                    ReadOnly="true" />
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-venus-mars"></i>Gender<span class="required">*</span>
                        </label>
                        <div class="gender-options">
                            <div class="gender-option">
                                <div class="gender-card male" onclick="selectGender('Male', this)">
                                    <i class="fas fa-mars"></i>
                                    <div>Male</div>
                                </div>
                            </div>
                            <div class="gender-option">
                                <div class="gender-card female" onclick="selectGender('Female', this)">
                                    <i class="fas fa-venus"></i>
                                    <div>Female</div>
                                </div>
                            </div>
                            <div class="gender-option">
                                <div class="gender-card other" onclick="selectGender('Other', this)">
                                    <i class="fas fa-genderless"></i>
                                    <div>Other</div>
                                </div>
                            </div>
                        </div>
                        <asp:HiddenField ID="hdnGender" runat="server" />
                    </div>
                </div>

                <!-- Contact Information Section -->
                <div class="form-section">
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-address-card"></i>
                        </div>
                        <h3 class="section-title">Contact Information</h3>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-envelope"></i>Email Address<span class="required">*</span>
                                </label>
                                <asp:TextBox ID="txtEmail" runat="server" 
                                    CssClass="form-control" 
                                    placeholder="student@example.com"
                                    TextMode="Email"
                                    MaxLength="100" />
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                    ControlToValidate="txtEmail"
                                    ErrorMessage="Email is required"
                                    CssClass="validation-message"
                                    Display="Dynamic">
                                    <i class="fas fa-exclamation-circle"></i> Email is required
                                </asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                                    ControlToValidate="txtEmail"
                                    ErrorMessage="Please enter a valid email address"
                                    ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                    CssClass="validation-message"
                                    Display="Dynamic">
                                    <i class="fas fa-exclamation-circle"></i> Please enter a valid email address
                                </asp:RegularExpressionValidator>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-phone"></i>Contact Number
                                </label>
                                <asp:TextBox ID="txtContactNumber" runat="server" 
                                    CssClass="form-control" 
                                    placeholder="+977 xxxxxxxxxx"
                                    MaxLength="15" />
                                <asp:RegularExpressionValidator ID="revContactNumber" runat="server" 
                                    ControlToValidate="txtContactNumber"
                                    ErrorMessage="Please enter a valid phone number"
                                    ValidationExpression="^\+?[1-9]\d{1,14}$"
                                    CssClass="validation-message"
                                    Display="Dynamic">
                                    <i class="fas fa-exclamation-circle"></i> Please enter a valid phone number
                                </asp:RegularExpressionValidator>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-lock"></i>Password<span class="required">*</span>
                                </label>
                                <asp:TextBox ID="txtPassword" runat="server" 
                                    CssClass="form-control" 
                                    placeholder="Enter password"
                                    TextMode="Password"
                                    MaxLength="50" />
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                                    ControlToValidate="txtPassword"
                                    ErrorMessage="Password is required"
                                    CssClass="validation-message"
                                    Display="Dynamic">
                                    <i class="fas fa-exclamation-circle"></i> Password is required
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-lock"></i>Confirm Password<span class="required">*</span>
                                </label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" 
                                    CssClass="form-control" 
                                    placeholder="Confirm password"
                                    TextMode="Password"
                                    MaxLength="50" />
                                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                                    ControlToValidate="txtConfirmPassword"
                                    ErrorMessage="Please confirm your password"
                                    CssClass="validation-message"
                                    Display="Dynamic">
                                    <i class="fas fa-exclamation-circle"></i> Please confirm your password
                                </asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="cvPassword" runat="server" 
                                    ControlToValidate="txtConfirmPassword"
                                    ControlToCompare="txtPassword"
                                    ErrorMessage="Passwords do not match"
                                    CssClass="validation-message"
                                    Display="Dynamic">
                                    <i class="fas fa-exclamation-circle"></i> Passwords do not match
                                </asp:CompareValidator>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <asp:Button ID="btnCancel" runat="server" 
                        Text="Cancel" 
                        CssClass="btn-modern btn-secondary-modern"
                        OnClientClick="return confirmCancel();"
                        CausesValidation="false"
                        OnClick="btnCancel_Click" />
                    <asp:Button ID="btnSave" runat="server" 
                        Text="Add Student" 
                        CssClass="btn-modern btn-primary-modern"
                        OnClientClick="return validateForm();"
                        OnClick="btnSave_Click" />
                </div>
          
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/11.7.32/sweetalert2.min.js"></script>
    
    <script type="text/javascript">
        // Profile Image Preview
        function previewProfileImage(input) {
            if (input.files && input.files[0]) {
                const file = input.files[0];

                // Validate file size (5MB)
                if (file.size > 5 * 1024 * 1024) {
                    Swal.fire({
                        icon: 'error',
                        title: 'File Too Large',
                        text: 'Please select an image smaller than 5MB.',
                        confirmButtonColor: '#667eea'
                    });
                    input.value = '';
                    return;
                }

                // Validate file type
                if (!file.type.match('image.*')) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Invalid File Type',
                        text: 'Please select a valid image file (JPG, PNG, GIF).',
                        confirmButtonColor: '#667eea'
                    });
                    input.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('profileImage').src = e.target.result;
                    document.getElementById('profileImage').style.display = 'block';
                    document.getElementById('profilePlaceholder').style.display = 'none';
                };
                reader.readAsDataURL(file);
            }
        }

        // Gender Selection
        function selectGender(gender, element) {
            // Remove selected class from all cards
            document.querySelectorAll('.gender-card').forEach(card => {
                card.classList.remove('selected');
            });

            // Add selected class to clicked card
            element.classList.add('selected');

            // Set hidden field value
            document.getElementById('<%= hdnGender.ClientID %>').value = gender;
        }

        // Age Calculator
        function calculateAge() {
            const dobInput = document.getElementById('<%= txtDateOfBirth.ClientID %>');
            const ageInput = document.getElementById('<%= txtAge.ClientID %>');

            if (dobInput.value) {
                const dob = new Date(dobInput.value);
                const today = new Date();
                let age = today.getFullYear() - dob.getFullYear();
                const monthDiff = today.getMonth() - dob.getMonth();

                if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
                    age--;
                }

                ageInput.value = age;
            } else {
                ageInput.value = '';
            }
        }

        // Form Validation
        function validateForm() {
            let isValid = true;
            let errorMessage = '';

            // Check if gender is selected
            const gender = document.getElementById('<%= hdnGender.ClientID %>').value;
            if (!gender) {
                errorMessage += '• Please select a gender\n';
                isValid = false;
            }

            // Validate age
            const age = parseInt(document.getElementById('<%= txtAge.ClientID %>').value);
            if (age && (age < 3 || age > 100)) {
                errorMessage += '• Age must be between 3 and 100 years\n';
                isValid = false;
            }

            // Validate date of birth
            const dobDate = document.getElementById('<%= txtDateOfBirth.ClientID %>').value;
            if (dobDate) {
                const dob = new Date(dobDate);
                const today = new Date();
                if (dob > today) {
                    errorMessage += '• Date of birth cannot be in the future\n';
                    isValid = false;
                }
            }

            // Validate password match
            const password = document.getElementById('<%= txtPassword.ClientID %>').value;
            const confirmPassword = document.getElementById('<%= txtConfirmPassword.ClientID %>').value;
            if (password && confirmPassword && password !== confirmPassword) {
                errorMessage += '• Passwords do not match\n';
                isValid = false;
            }

            // Validate password strength (optional)
            if (password && password.length < 6) {
                errorMessage += '• Password must be at least 6 characters long\n';
                isValid = false;
            }

            if (!isValid) {
                Swal.fire({
                    icon: 'error',
                    title: 'Validation Error',
                    text: errorMessage,
                    confirmButtonColor: '#667eea'
                });
                return false;
            }

            // Show loading overlay
            showLoading();
            return true;
        }

        // Cancel Confirmation
        function confirmCancel() {
            return confirm('Are you sure you want to cancel? All entered data will be lost.');
        }

        // Loading Overlay
        function showLoading() {
            document.getElementById('loadingOverlay').style.display = 'flex';
        }

        function hideLoading() {
            document.getElementById('loadingOverlay').style.display = 'none';
        }

        // Initialize form
        document.addEventListener('DOMContentLoaded', function () {
            // Add animation classes
            setTimeout(() => {
                document.querySelectorAll('.form-section').forEach((section, index) => {
                    setTimeout(() => {
                        section.classList.add('animate-fade-in');
                    }, index * 200);
                });
            }, 500);
        });

        // Success/Error Messages from Server
        function showSuccessMessage(message) {
            hideLoading();
            Swal.fire({
                icon: 'success',
                title: 'Success!',
                text: message,
                confirmButtonColor: '#10b981'
            }).then(() => {
                window.location.href = 'StudentManagement.aspx';
            });
        }

        function showErrorMessage(message) {
            hideLoading();
            Swal.fire({
                icon: 'error',
                title: 'Error!',
                text: message,
                confirmButtonColor: '#ef4444'
            });
        }
    </script>
</asp:Content>