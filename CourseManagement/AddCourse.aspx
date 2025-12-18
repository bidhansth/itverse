<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/AdminDashboard.Master" AutoEventWireup="true" CodeBehind="AddCourse.aspx.cs" Inherits="LMS.CourseManagement.AddCourse" %>


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

         .form-control, .form-select {
            border: 2px solid rgba(102, 126, 234, 0.2);
            border-radius: 12px;
            padding: 0.875rem 1rem;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            color: #222429;
         }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            outline: none;
            background: rgba(255, 255, 255, 1);
        }

        .form-control:hover, .form-select:hover {
            border-color: rgba(102, 126, 234, 0.4);
        }

        /* Thumbnail Upload */
        .thumbnail-upload-container {
            text-align: center;
            margin-bottom: 2rem;
        }

        .thumbnail-preview {
            width: 200px;
            height: 120px;
            border-radius: 16px;
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

        .thumbnail-preview:hover {
            transform: scale(1.05);
            box-shadow: var(--shadow-xl);
        }

        .thumbnail-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .thumbnail-placeholder {
            font-size: 3rem;
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

        /* YouTube Link Input */
        .youtube-input-group {
            position: relative;
        }

        .youtube-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #ff0000;
            font-size: 1.1rem;
        }

        .youtube-input {
            padding-left: 3rem;
        }

        /* Active Status Toggle */
        .status-toggle-container {
            background: rgba(255, 255, 255, 0.8);
            border: 2px solid rgba(102, 126, 234, 0.2);
            border-radius: 12px;
            padding: 1.5rem;
            transition: all 0.3s ease;
        }

        .status-toggle-container:hover {
            border-color: var(--primary-color);
            background: rgba(255, 255, 255, 1);
        }

        .custom-switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
            margin-right: 1rem;
        }

        .custom-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: var(--success-color);
        }

        input:checked + .slider:before {
            transform: translateX(26px);
        }

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
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-modern {
                min-width: auto;
                width: 100%;
            }
            
            .thumbnail-preview {
                width: 160px;
                height: 100px;
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

        /* Help Text */
        .help-text {
            font-size: 0.8rem;
            color: #6b7280;
            margin-top: 0.5rem;
            font-style: italic;
        }

        /* Edit Mode Indicator */
        .edit-mode-badge {
            background: linear-gradient(135deg, var(--warning-color), #f59e0b);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-left: 1rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <nav aria-label="breadcrumb" class="animate-fade-in">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href='<%= ResolveUrl("~/AdminDefault.aspx") %>'><i class="fas fa-home me-1"></i>Dashboard</a></li>
            <li class="breadcrumb-item"><a href='<%= ResolveUrl("~/CourseManagement/CourseManagement.aspx") %>'><i class="fas fa-book me-1"></i>Course Management</a></li>
            <li class="breadcrumb-item active"><i class="fas fa-plus me-1"></i><asp:Literal ID="litBreadcrumb" runat="server" Text="Add Course"></asp:Literal></li>
        </ol>
    </nav>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-content">
            <div class="spinner"></div>
            <h5 id="loadingTitle">Adding Course...</h5>
            <p class="text-muted mb-0">Please wait while we process the information</p>
        </div>
    </div>

    <!-- Page Header -->
    <div class="page-header animate-slide-up">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 runat="server" id="lblPageTitle" class="page-title mb-2">
                    <i runat="server" id="iconTitle" class="fas fa-book me-3"></i>
                    <asp:Literal ID="litPageTitle" runat="server" Text="Add New Course"></asp:Literal>
                    <asp:Panel ID="pnlEditMode" runat="server" Visible="false" Style="display: inline;">
                        <span class="edit-mode-badge">
                            <i class="fas fa-edit"></i>Edit Mode
                        </span>
                    </asp:Panel>
                </h1>

                <p runat="server" id="lblPageSubtitle" class="page-subtitle mb-0">
                    <asp:Literal ID="litPageSubtitle" runat="server" Text="Create a new course for the learning management system"></asp:Literal>
                </p>
            </div>
        </div>
    </div>

    <!-- Form Container -->
    <div class="form-container animate-fade-in">
        <div class="form-content">
           
            <!-- Course Thumbnail Section -->
            <div class="form-section">
                <div class="section-header">
                    <div class="section-icon">
                        <i class="fas fa-image"></i>
                    </div>
                    <h3 class="section-title">Course Thumbnail</h3>
                </div>
                
                <div class="thumbnail-upload-container">
                    <div class="thumbnail-preview" id="thumbnailPreview">
                        <i class="fas fa-book thumbnail-placeholder" id="thumbnailPlaceholder"></i>
                        <img id="thumbnailImage" style="display: none;" alt="Course Thumbnail" />
                    </div>
                    <div class="file-input-wrapper">
                        <asp:FileUpload ID="fuThumbnail" runat="server" 
                            accept="image/*" 
                            onchange="previewThumbnail(this)" 
                            CssClass="form-control" />
                        <button type="button" class="upload-btn" onclick="document.getElementById('<%= fuThumbnail.ClientID %>').click();">
                            <i class="fas fa-cloud-upload-alt me-2"></i>Choose Thumbnail
                        </button>
                    </div>
                    <div class="help-text">
                         Supported formats: JPG, PNG, GIF (Max: 5MB) - Recommended size: 400x240px
                    </div>
                </div>
            </div>

            <!-- Course Information Section -->
            <div class="form-section">
                <div class="section-header">
                    <div class="section-icon">
                        <i class="fas fa-info-circle"></i>
                    </div>
                    <h3 class="section-title">Course Information</h3>
                </div>
                
                <div class="row">
                    <div class="col-md-8">
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-graduation-cap"></i>Course Name<span class="required">*</span>
                            </label>
                            <asp:TextBox ID="txtCourseName" runat="server" 
                                CssClass="form-control" 
                                placeholder="Enter course name"
                                MaxLength="100" />
                            <asp:RequiredFieldValidator ID="rfvCourseName" runat="server" 
                                ControlToValidate="txtCourseName"
                                ErrorMessage="Course name is required"
                                CssClass="validation-message"
                                Display="Dynamic">
                                <i class="fas fa-exclamation-circle"></i> Course name is required
                            </asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-clock"></i>Duration
                            </label>
                            <asp:TextBox ID="txtDuration" runat="server" 
                                CssClass="form-control" 
                                placeholder="e.g., 8 weeks, 40 hours"
                                MaxLength="50" />
                            <div class="help-text">
                                Format examples: "8 weeks", "40 hours", "3 months"
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-align-left"></i>Course Description
                    </label>
                    <asp:TextBox ID="txtDescription" runat="server" 
                        CssClass="form-control" 
                        placeholder="Enter detailed course description"
                        TextMode="MultiLine"
                        Rows="4"
                        MaxLength="500" />
                    <div class="help-text">
                        Provide a comprehensive description of what students will learn in this course (Max: 500 characters)
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fab fa-youtube"></i>YouTube Course Link
                    </label>
                    <div class="youtube-input-group">
                        <i class="fab fa-youtube youtube-icon"></i>
                        <asp:TextBox ID="txtYouTubeLink" runat="server" 
                            CssClass="form-control youtube-input" 
                            placeholder="https://www.youtube.com/watch?v=..."
                            MaxLength="255" />
                    </div>
                    <asp:RegularExpressionValidator ID="revYouTubeLink" runat="server" 
                        ControlToValidate="txtYouTubeLink"
                        ErrorMessage="Please enter a valid YouTube URL"
                        ValidationExpression="^(https?\:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/.+"
                        CssClass="validation-message"
                        Display="Dynamic">
                        <i class="fas fa-exclamation-circle"></i> Please enter a valid YouTube URL
                    </asp:RegularExpressionValidator>
                    <div class="help-text">
                        Optional: Link to YouTube playlist or main course video
                    </div>
                </div>
            </div>

            <!-- Teacher Assignment Section -->
            <div class="form-section">
                <div class="section-header">
                    <div class="section-icon">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <h3 class="section-title">Teacher Assignment</h3>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-user-tie"></i>Assign Teacher<span class="required">*</span>
                    </label>
                    <asp:DropDownList ID="ddlTeacher" runat="server" 
                        CssClass="form-select" 
                        DataTextField="DisplayText"
                        DataValueField="TeacherId">
                        <asp:ListItem Value="" Text="-- Select Teacher --"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvTeacher" runat="server" 
                        ControlToValidate="ddlTeacher"
                        InitialValue=""
                        ErrorMessage="Please select a teacher"
                        CssClass="validation-message"
                        Display="Dynamic">
                        <i class="fas fa-exclamation-circle"></i> Please select a teacher for this course
                    </asp:RequiredFieldValidator>
                    <div class="help-text">
                        Select the teacher who will be responsible for this course
                    </div>
                </div>
            </div>

            <!-- Course Settings Section -->
            <div class="form-section">
                <div class="section-header">
                    <div class="section-icon">
                        <i class="fas fa-cog"></i>
                    </div>
                    <h3 class="section-title">Course Settings</h3>
                </div>
                
                <div class="form-group">
                    <div class="status-toggle-container">
                        <label class="form-label d-flex align-items-center">
                            <label class="custom-switch">
                                <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                                <span class="slider"></span>
                            </label>
                            <div>
                                <i class="fas fa-toggle-on"></i>Course Status
                                <div class="help-text mb-0">
                                    Toggle to activate or deactivate this course. Active courses are visible to students.
                                </div>
                            </div>
                        </label>
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
                   />
                <asp:Button ID="btnSave" runat="server" 
                    Text="Add Course" 
                    CssClass="btn-modern btn-primary-modern"
                    OnClick ="btnSave_Click"
                    OnClientClick="return validateForm();"
                     />
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/11.7.32/sweetalert2.min.js"></script>
    
    <script type="text/javascript">
        // Thumbnail Preview
        function previewThumbnail(input) {
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
                    document.getElementById('thumbnailImage').src = e.target.result;
                    document.getElementById('thumbnailImage').style.display = 'block';
                    document.getElementById('thumbnailPlaceholder').style.display = 'none';
                };
                reader.readAsDataURL(file);
            }
        }

        // Form Validation
        function validateForm() {
            let isValid = true;
            let errorMessage = '';

            // Validate YouTube URL format (if provided)
            const youtubeUrl = document.getElementById('<%= txtYouTubeLink.ClientID %>').value.trim();
            if (youtubeUrl && !isValidYouTubeUrl(youtubeUrl)) {
                errorMessage += '• Please enter a valid YouTube URL\n';
                isValid = false;
            }

            // Validate course name length
            const courseName = document.getElementById('<%= txtCourseName.ClientID %>').value.trim();
            if (courseName && courseName.length < 3) {
                errorMessage += '• Course name must be at least 3 characters long\n';
                isValid = false;
            }

            // Validate description length
            const description = document.getElementById('<%= txtDescription.ClientID %>').value.trim();
            if (description && description.length > 500) {
                errorMessage += '• Description cannot exceed 500 characters\n';
                isValid = false;
            }

            // Validate teacher selection
            const teacherId = document.getElementById('<%= ddlTeacher.ClientID %>').value;
            if (!teacherId) {
                errorMessage += '• Please select a teacher for this course\n';
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

        // YouTube URL validation
        function isValidYouTubeUrl(url) {
            const pattern = /^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/.+/;
            return pattern.test(url);
        }

        // Cancel Confirmation
        function confirmCancel() {
            return confirm('Are you sure you want to cancel? All entered data will be lost.');
        }

        // Loading Overlay
        function showLoading() {
            const isEdit = document.getElementById('<%= pnlEditMode.ClientID %>').style.display !== 'none';
            document.getElementById('loadingTitle').textContent = isEdit ? 'Updating Course...' : 'Adding Course...';
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

            // YouTube URL input enhancements
            const youtubeInput = document.getElementById('<%= txtYouTubeLink.ClientID %>');
            if (youtubeInput) {
                youtubeInput.addEventListener('paste', function(e) {
                    setTimeout(() => {
                        validateYouTubeUrl(this.value);
                    }, 100);
                });

                youtubeInput.addEventListener('blur', function() {
                    validateYouTubeUrl(this.value);
                });
            }
        });

        // YouTube URL validation on input
        function validateYouTubeUrl(url) {
            const input = document.getElementById('<%= txtYouTubeLink.ClientID %>');
            const inputGroup = input.closest('.youtube-input-group');
            
            if (url && !isValidYouTubeUrl(url)) {
                inputGroup.style.borderColor = '#ef4444';
                input.style.borderColor = '#ef4444';
            } else if (url) {
                inputGroup.style.borderColor = '#10b981';
                input.style.borderColor = '#10b981';
            } else {
                inputGroup.style.borderColor = '';
                input.style.borderColor = '';
            }
        }

        // Success/Error Messages from Server
        function showSuccessMessage(message) {
            hideLoading();
            Swal.fire({
                icon: 'success',
                title: 'Success!',
                text: message,
                confirmButtonColor: '#10b981'
            }).then(() => {
                window.location.href = 'CourseManagement.aspx';
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

        function showWarningMessage(message) {
            hideLoading();
            Swal.fire({
                icon: 'warning',
                title: 'Warning!',
                text: message,
                confirmButtonColor: '#f59e0b'
            });
        }

        // Character counter for description
        const descriptionTextarea = document.getElementById('<%= txtDescription.ClientID %>');
        if (descriptionTextarea) {
            const maxLength = 500;
            
            // Create character counter element
            const counterDiv = document.createElement('div');
            counterDiv.className = 'help-text text-end mt-1';
            counterDiv.id = 'descriptionCounter';
            descriptionTextarea.parentNode.appendChild(counterDiv);
            
            function updateCounter() {
                const currentLength = descriptionTextarea.value.length;
                const remaining = maxLength - currentLength;
                counterDiv.textContent = ${currentLength}/${maxLength} characters;
                
                if (remaining < 50) {
                    counterDiv.style.color = '#ef4444';
                } else if (remaining < 100) {
                    counterDiv.style.color = '#f59e0b';
                } else {
                    counterDiv.style.color = '#6b7280';
                }
            }
            
            descriptionTextarea.addEventListener('input', updateCounter);
            updateCounter(); // Initialize counter
        }
    </script>
</asp:Content>