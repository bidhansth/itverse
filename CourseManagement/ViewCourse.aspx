<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/AdminDashboard.Master" AutoEventWireup="true" CodeBehind="ViewCourse.aspx.cs" Inherits="LMS.CourseManagement.ViewCourse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <!-- Modern CSS Libraries -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/11.7.32/sweetalert2.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-dark: #1d4ed8;
            --primary-light: #dbeafe;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --info-color: #0891b2;
            --gray-50: #f9fafb;
            --gray-100: #f3f4f6;
            --gray-200: #e5e7eb;
            --gray-300: #d1d5db;
            --gray-400: #9ca3af;
            --gray-500: #6b7280;
            --gray-600: #4b5563;
            --gray-700: #374151;
            --gray-800: #1f2937;
            --gray-900: #111827;
            --border-radius: 12px;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        * {
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, var(--gray-50) 0%, #ffffff 100%);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: var(--gray-800);
            line-height: 1.6;
        }

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            border-radius: var(--border-radius);
            padding: 3rem 2rem;
            margin-bottom: 3rem;
            box-shadow: var(--shadow-lg);
            position: relative;
            overflow: hidden;
        }

        /* Page Header - Minimalist */
        .page-header {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--border-radius);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-sm);
        }

        .page-title {
            font-size: 1.875rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            font-size: 1rem;
            color: var(--gray-500);
            margin: 0;
        }

        /* Search and Filter Section */
        .search-section {
            background: white;
            border-radius: var(--border-radius);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            border: 1px solid var(--gray-200);
        }

        .search-controls {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-input {
            flex: 1;
            min-width: 300px;
            padding: 0.75rem 1rem;
            border: 2px solid var(--gray-300);
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: all 0.2s ease;
            background: var(--gray-50);
        }

        .search-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            outline: none;
            background: white;
        }

        .filter-select {
            padding: 0.75rem 1rem;
            border: 2px solid var(--gray-300);
            border-radius: var(--border-radius);
            background: var(--gray-50);
            font-size: 1rem;
            min-width: 150px;
            transition: all 0.2s ease;
        }

        .filter-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            outline: none;
            background: white;
        }

        .btn-modern {
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-primary-modern {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            box-shadow: var(--shadow);
        }

        .btn-primary-modern:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            color: white;
        }

        /* Statistics Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stats-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 2rem;
            box-shadow: var(--shadow);
            border: 1px solid var(--gray-200);
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--info-color));
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
        }

        .stats-number {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .stats-label {
            font-size: 1rem;
            color: var(--gray-600);
            font-weight: 500;
        }

        .stats-icon {
            font-size: 2rem;
            color: var(--primary-color);
            opacity: 0.2;
            margin-bottom: 1rem;
        }

        /* Course Cards Grid */
        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .course-card {
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow);
            border: 1px solid var(--gray-200);
            transition: all 0.3s ease;
            position: relative;
        }

        .course-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-xl);
            border-color: var(--primary-color);
        }

        .course-thumbnail {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: linear-gradient(135deg, var(--primary-light), #ffffff);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: var(--primary-color);
            position: relative;
        }

        .course-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .course-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(to bottom, transparent 0%, rgba(0,0,0,0.7) 100%);
            opacity: 0;
            transition: opacity 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .course-card:hover .course-overlay {
            opacity: 1;
        }

        .play-button {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            font-size: 1.5rem;
            transition: all 0.3s ease;
        }

        .play-button:hover {
            background: white;
            transform: scale(1.1);
        }

        .course-content {
            padding: 1.5rem;
        }

        .course-header {
            display: flex;
            justify-content: between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .course-id {
            background: var(--primary-light);
            color: var(--primary-color);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: inline-block;
        }

        .course-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.75rem;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .course-description {
            color: var(--gray-600);
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .course-meta {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--gray-500);
            font-size: 0.85rem;
        }

        .meta-item i {
            color: var(--primary-color);
        }

        .course-status {
            position: absolute;
            top: 1rem;
            right: 1rem;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .status-active {
            background: rgba(5, 150, 105, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(5, 150, 105, 0.2);
        }

        .status-inactive {
            background: rgba(217, 119, 6, 0.1);
            color: var(--warning-color);
            border: 1px solid rgba(217, 119, 6, 0.2);
        }

        .course-actions {
            display: flex;
            gap: 0.75rem;
            justify-content: space-between;
            align-items: center;
        }

        .btn-view-more {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            padding: 0.6rem 1.25rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            font-size: 0.85rem;
            text-decoration: none;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            flex: 1;
            justify-content: center;
        }

        .btn-view-more:hover {
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .btn-youtube {
            background: #ff0000;
            color: white;
            padding: 0.6rem;
            border-radius: var(--border-radius);
            text-decoration: none;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 40px;
        }

        .btn-youtube:hover {
            background: #cc0000;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .btn-youtube.disabled {
            background: var(--gray-400);
            cursor: not-allowed;
            pointer-events: none;
        }

        /* Modal Styles */
        .modal-content {
            border: none;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-xl);
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border: none;
            padding: 2rem;
            position: relative;
        }

        .modal-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--info-color), var(--success-color));
        }

        .modal-title {
            font-weight: 700;
            font-size: 1.5rem;
            margin: 0;
        }

        .btn-close {
            filter: brightness(0) invert(1);
            opacity: 0.8;
            width: 1.5rem;
            height: 1.5rem;
        }

        .btn-close:hover {
            opacity: 1;
            transform: scale(1.1);
        }

        .modal-body {
            padding: 0;
            max-height: 70vh;
            overflow-y: auto;
        }

        /* Course Detail Sections */
        .course-detail-header {
            background: var(--gray-50);
            padding: 2rem;
            text-align: center;
            border-bottom: 1px solid var(--gray-200);
        }

        .detail-thumbnail {
            width: 200px;
            height: 120px;
            border-radius: var(--border-radius);
            object-fit: cover;
            border: 4px solid white;
            box-shadow: var(--shadow-lg);
            margin-bottom: 1.5rem;
        }

        .detail-course-name {
            font-size: 2rem;
            font-weight: 800;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }

        .detail-course-id {
            font-size: 1.125rem;
            color: var(--gray-500);
            font-weight: 600;
        }

        .course-details-content {
            padding: 2rem;
        }

        .detail-section {
            margin-bottom: 2.5rem;
        }

        .detail-section:last-child {
            margin-bottom: 0;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--gray-200);
        }

        .section-title i {
            color: var(--primary-color);
            font-size: 1.1rem;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .detail-item {
            background: var(--gray-50);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            border-left: 4px solid var(--primary-color);
            transition: all 0.2s ease;
        }

        .detail-item:hover {
            background: var(--primary-light);
            transform: translateX(4px);
        }

        .detail-label {
            font-size: 0.875rem;
            color: var(--gray-500);
            font-weight: 600;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .detail-value {
            font-size: 1.125rem;
            color: var(--gray-900);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .detail-value.empty {
            color: var(--gray-400);
            font-style: italic;
            font-weight: 400;
        }

        .detail-value i {
            color: var(--primary-color);
        }

        .description-section {
            background: white;
            border: 2px solid var(--gray-200);
            border-radius: var(--border-radius);
            padding: 2rem;
        }

        .description-text {
            font-size: 1rem;
            line-height: 1.7;
            color: var(--gray-700);
        }

        .youtube-section {
            background: linear-gradient(135deg, #ff000010, #ffffff);
            border: 2px solid #ff000020;
            border-radius: var(--border-radius);
            padding: 2rem;
            text-align: center;
        }

        .youtube-link {
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            background: #ff0000;
            color: white;
            padding: 1rem 2rem;
            border-radius: var(--border-radius);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s ease;
            font-size: 1.1rem;
        }

        .youtube-link:hover {
            background: #cc0000;
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            color: white;
        }

        .modal-footer {
            background: var(--gray-50);
            border-top: 1px solid var(--gray-200);
            padding: 1.5rem 2rem;
        }

        /* No Courses State */
        .no-courses {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            border: 1px solid var(--gray-200);
        }

        .no-courses-icon {
            font-size: 4rem;
            color: var(--gray-300);
            margin-bottom: 2rem;
        }

        .no-courses-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 1rem;
        }

        .no-courses-text {
            color: var(--gray-500);
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-title {
                font-size: 2rem;
            }
            
            .search-controls {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-input {
                min-width: auto;
            }
            
            .courses-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .course-meta {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .course-actions {
                flex-direction: column;
            }
            
            .modal-dialog {
                margin: 0.5rem;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
            }
            
            .detail-course-name {
                font-size: 1.5rem;
            }
        }

        /* Loading Animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Fade In Animation */
        .animate-fade-in {
            animation: fadeIn 0.3s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <nav aria-label="breadcrumb" class="fade-in">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href='<%= ResolveUrl("~/AdminDefault.aspx") %>'><i class="fas fa-home me-1"></i>Dashboard</a></li>
            <li class="breadcrumb-item"><a href='<%= ResolveUrl("~/CourseManagement/CourseManagement.aspx") %>'><i class="fas fa-cog me-1"></i>Course Management</a></li>
            <li class="breadcrumb-item active"><i class="fas fa-eye me-1"></i>View Courses</li>
        </ol>
    </nav>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Hidden fields for client-side operations -->
    <asp:HiddenField ID="hdnMessage" runat="server" />
    <asp:HiddenField ID="hdnMessageType" runat="server" />

        <div class="page-header animate-fade-in">
        <div class="d-flex justify-content-between align-items-center flex-wrap">
            <div>
                <h1 class="page-title">
                    <i class="fas fa-graduation-cap me-2"></i>Course Catalog
                </h1>
                <p class="page-subtitle">Manage and organize course catalog efficiently</p>
            </div>
            <div class="d-flex gap-2">
                <button type="button" class="btn-modern btn-outline-modern" onclick="refreshCourseData()">
                    <i class="fas fa-sync-alt"></i>Refresh
                </button>
            </div>
        </div>
    </div>

<%--    <!-- Page Header -->
    <div class="page-header fade-in">
        <div class="content">
            <h1 class="page-title">
                <i class="fas fa-graduation-cap me-3"></i>Course Catalog
            </h1>
            <p class="page-subtitle">Explore and discover our comprehensive course collection</p>
        </div>
    </div>--%>

    <!-- Search and Filter Section -->
    <div class="search-section fade-in">
        <div class="search-controls">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search courses by name, description, or teacher..." />
            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="filter-select">
                <asp:ListItem Value="" Text="All Courses" Selected="True" />
                <asp:ListItem Value="Active" Text="Active Courses" />
                <asp:ListItem Value="Inactive" Text="Inactive Courses" />
            </asp:DropDownList>
            <asp:Button ID="btnSearch" runat="server" CssClass="btn-modern btn-primary-modern" Text="Search" OnClick="btnSearch_Click" />
            <button type="button" class="btn-modern btn-primary-modern" onclick="clearFilters()">
                <i class="fas fa-times"></i>Clear
            </button>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="stats-container fade-in">
        <div class="stats-card">
            <i class="fas fa-book stats-icon"></i>
            <div class="stats-number">
                <asp:Label ID="lblTotalCourses" runat="server" Text="0" />
            </div>
            <div class="stats-label">Total Courses</div>
        </div>
        <div class="stats-card">
            <i class="fas fa-play-circle stats-icon"></i>
            <div class="stats-number">
                <asp:Label ID="lblActiveCourses" runat="server" Text="0" />
            </div>
            <div class="stats-label">Active Courses</div>
        </div>
        <div class="stats-card">
            <i class="fas fa-pause-circle stats-icon"></i>
            <div class="stats-number">
                <asp:Label ID="lblInactiveCourses" runat="server" Text="0" />
            </div>
            <div class="stats-label">Inactive Courses</div>
        </div>
        <div class="stats-card">
            <i class="fas fa-video stats-icon"></i>
            <div class="stats-number">
                <asp:Label ID="lblCoursesWithVideos" runat="server" Text="0" />
            </div>
            <div class="stats-label">With Videos</div>
        </div>
    </div>

    <!-- No Courses Message -->
    <asp:Panel ID="pnlNoCourses" runat="server" Visible="false">
        <div class="no-courses fade-in">
            <div class="no-courses-icon">
                <i class="fas fa-graduation-cap"></i>
            </div>
            <h3 class="no-courses-title">No Courses Found</h3>
            <p class="no-courses-text">
                <asp:Label ID="lblNoCoursesMessage" runat="server" Text="No courses match your current search criteria. Try adjusting your filters or search terms." />
            </p>
            <a href='<%= ResolveUrl("~/CourseManagement/AddCourse.aspx") %>' class="btn-modern btn-primary-modern">
                <i class="fas fa-plus me-2"></i>Add First Course
            </a>
        </div>
    </asp:Panel>

    <!-- Courses Grid -->
    <div class="courses-grid fade-in">
        <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
            <ItemTemplate>
                <div class="course-card">
                    <!-- Course Status Badge -->
                    <div class='course-status <%# Convert.ToBoolean(Eval("IsActive")) ? "status-active" : "status-inactive" %>'>
                        <i class='fas <%# Convert.ToBoolean(Eval("IsActive")) ? "fa-check-circle" : "fa-pause-circle" %> me-1'></i>
                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                    </div>

                    <!-- Course Thumbnail -->
                    <div class="course-thumbnail">
                        <%# !string.IsNullOrEmpty(Eval("Thumbnail")?.ToString()) ? 
                            $"<img src='{ResolveUrl(Eval("Thumbnail").ToString())}' alt='Course Thumbnail' />" : 
                            "<i class='fas fa-graduation-cap'></i>" %>

                        <!-- Overlay for YouTube link -->
                        <%# !string.IsNullOrEmpty(Eval("YouTubeLink")?.ToString()) ? 
                            $"<a href='{Eval("YouTubeLink")}' target='_blank' class='course-overlay' title='Watch on YouTube'>" +
                            "<div class='play-button'><i class='fas fa-play'></i></div></a>" : 
                            "" %>
                    </div>

                    <!-- Course Content -->
                    <div class="course-content">
                        <div class="course-id">CRS-<%# Eval("CourseId").ToString().PadLeft(4, '0') %></div>
                        <h3 class="course-title"><%# Eval("CourseName") %></h3>
                        <p class="course-description">
                            <%# !string.IsNullOrEmpty(Eval("Description")?.ToString()) ? 
                                (Eval("Description").ToString().Length > 120 ? 
                                    Eval("Description").ToString().Substring(0, 120) + "..." : 
                                    Eval("Description").ToString()) : 
                                "No description available for this course." %>
                        </p>
                        
                        <!-- Course Meta Information -->
                        <div class="course-meta">
                            <div class="meta-item">
                                <i class="fas fa-chalkboard-teacher"></i>
                                <span>Teacher ID: <%# Eval("TeacherId") %></span>
                            </div>
                            <%# !string.IsNullOrEmpty(Eval("Duration")?.ToString()) ? 
                                $"<div class='meta-item'><i class='fas fa-clock'></i><span>{Eval("Duration")}</span></div>" : 
                                "<div class='meta-item'><i class='fas fa-clock'></i><span>Duration not specified</span></div>" %>
                            <div class="meta-item">
                                <i class="fas fa-calendar-alt"></i>
                                <span><%# Convert.ToDateTime(Eval("CreatedAt")).ToString("MMM dd, yyyy") %></span>
                            </div>
                        </div>

                        <!-- Course Actions -->
                        <div class="course-actions">
                            <asp:LinkButton ID="btnViewMore" runat="server" 
                                CssClass="btn-view-more" 
                                CommandName="ViewDetails" 
                                CommandArgument='<%# Eval("CourseId") %>'
                                OnClientClick="return false;">
                                <i class="fas fa-eye"></i>View Details
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- Course Details Modal -->
    <div class="modal fade" id="courseDetailsModal" tabindex="-1" aria-labelledby="courseDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title" id="courseDetailsModalLabel">
                        <i class="fas fa-graduation-cap me-3"></i>Course Details
                    </h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Course Detail Header -->
                    <div class="course-detail-header">
                        <img id="modalCourseThumbnail" src="" alt="Course" class="detail-thumbnail">
                        <h2 id="modalCourseName" class="detail-course-name"></h2>
                        <p id="modalCourseId" class="detail-course-id"></p>
                        <div id="modalCourseStatusBadge" class="course-status"></div>
                    </div>

                    <!-- Course Details Content -->
                    <div class="course-details-content">
                        <!-- Basic Information Section -->
                        <div class="detail-section">
                            <h4 class="section-title">
                                <i class="fas fa-info-circle"></i>Basic Information
                            </h4>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <div class="detail-label">Course Name</div>
                                    <div id="modalCourseNameDetail" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Course ID</div>
                                    <div id="modalCourseIdDetail" class="detail-value">
                                        <i class="fas fa-hashtag"></i>
                                        <span></span>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Duration</div>
                                    <div id="modalCourseDuration" class="detail-value">
                                        <i class="fas fa-clock"></i>
                                        <span></span>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Teacher</div>
                                    <div id="modalCourseTeacher" class="detail-value">
                                        <i class="fas fa-chalkboard-teacher"></i>
                                        <span></span>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Status</div>
                                    <div id="modalCourseStatusDetail" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Created Date</div>
                                    <div id="modalCourseCreated" class="detail-value">
                                        <i class="fas fa-calendar-plus"></i>
                                        <span></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Description Section -->
                        <div class="detail-section">
                            <h4 class="section-title">
                                <i class="fas fa-align-left"></i>Course Description
                            </h4>
                            <div class="description-section">
                                <div id="modalCourseDescription" class="description-text"></div>
                            </div>
                        </div>

                        <!-- YouTube Video Section -->
                        <div class="detail-section" id="youtubeSection" style="display: none;">
                            <h4 class="section-title">
                                <i class="fab fa-youtube"></i>Video Content
                            </h4>
                            <div class="youtube-section">
                                <p class="mb-3">Watch this course on YouTube</p>
                                <a id="modalYouTubeLink" href="#" target="_blank" class="youtube-link">
                                    <i class="fab fa-youtube"></i>Watch on YouTube
                                </a>
                            </div>
                        </div>

                        <!-- Timeline Section -->
                        <div class="detail-section">
                            <h4 class="section-title">
                                <i class="fas fa-history"></i>Timeline
                            </h4>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <div class="detail-label">Created On</div>
                                    <div id="modalCourseCreatedFull" class="detail-value">
                                        <i class="fas fa-calendar-plus"></i>
                                        <span></span>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Last Updated</div>
                                    <div id="modalCourseUpdated" class="detail-value">
                                        <i class="fas fa-calendar-edit"></i>
                                        <span></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Close
                    </button>
                    <a id="modalEditBtn" href="#" class="btn btn-primary">
                        <i class="fas fa-edit me-2"></i>Edit Course
                    </a>
                    <a id="modalYouTubeBtnFooter" href="#" target="_blank" class="btn btn-danger" style="display: none;">
                        <i class="fab fa-youtube me-2"></i>Watch Video
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <!-- JavaScript Libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/11.7.32/sweetalert2.min.js"></script>

    <script type="text/javascript">
        // Global variables
        let currentCourseData = null;

        // Document ready function
        $(document).ready(function() {
            // Check for messages from server
            checkForMessages();
            
            // Bind events
            bindEvents();
            
            // Initialize tooltips if Bootstrap is available
            if (typeof bootstrap !== 'undefined') {
                $('[data-bs-toggle="tooltip"]').tooltip();
            }
        });

        // Refresh course data
        function refreshCourseData() {
            showLoadingToast('Refreshing course data...');
            setTimeout(() => {
                window.location.reload();
            }, 500);
        }


        // Check for server messages
        function checkForMessages() {
            const message = $('#<%= hdnMessage.ClientID %>').val();
            const messageType = $('#<%= hdnMessageType.ClientID %>').val();
            
            if (message && message.trim() !== '') {
                switch (messageType) {
                    case 'success':
                        showSuccessToast(message);
                        break;
                    case 'error':
                        showErrorToast(message);
                        break;
                    case 'warning':
                        showWarningToast(message);
                        break;
                    case 'info':
                        showInfoToast(message);
                        break;
                    default:
                        showInfoToast(message);
                }
                
                // Clear the hidden fields
                $('#<%= hdnMessage.ClientID %>').val('');
                $('#<%= hdnMessageType.ClientID %>').val('');
            }
        }

        // Bind all events
        function bindEvents() {
            // Bind view more button clicks
            $('[id*="btnViewMore"]').off('click').on('click', function(e) {
                e.preventDefault();
                const courseId = $(this).attr('data-courseid') || extractCourseId($(this));
                if (courseId) {
                    viewCourseDetails(courseId);
                }
                return false;
            });

            // Bind course overlay clicks for YouTube
            $('.course-overlay').off('click').on('click', function(e) {
                e.preventDefault();
                const youtubeLink = $(this).closest('.course-card').find('.btn-youtube').attr('href');
                if (youtubeLink && youtubeLink !== '#') {
                    window.open(youtubeLink, '_blank');
                }
            });

            // Search on Enter key
            $('#<%= txtSearch.ClientID %>').off('keypress').on('keypress', function(e) {
                if (e.which === 13) {
                    e.preventDefault();
                    $('#<%= btnSearch.ClientID %>').click();
                }
            });
        }

        // Extract course ID from button
        function extractCourseId(button) {
            try {
                const commandArg = button.attr('commandargument');
                if (commandArg) return commandArg;
                
                // Try to find from card structure
                const courseIdElement = button.closest('.course-card').find('.course-id');
                if (courseIdElement.length > 0) {
                    const idText = courseIdElement.text();
                    const match = idText.match(/CRS-(\d+)/);
                    return match ? parseInt(match[1]) : null;
                }
                
                return null;
            } catch (error) {
                console.error('Error extracting course ID:', error);
                return null;
            }
        }

        // View course details - triggers server-side method
        function viewCourseDetails(courseId) {
            try {
                // Show loading state
                showLoadingToast('Loading course details...');
                
                // Trigger server-side postback
                __doPostBack('<%= rptCourses.UniqueID %>', 'ViewDetails + courseId);
                
            } catch (error) {
                console.error('Error viewing course details:', error);
                showErrorToast('Error loading course details');
            }
        }

        // Populate modal with course data (called from server-side)
        function populateCourseModal(courseData) {
            try {
                currentCourseData = courseData;
                
                // Set thumbnail
                const thumbnailSrc = courseData.thumbnail || 'https://via.placeholder.com/200x120/2563eb/ffffff?text=Course';
                $('#modalCourseThumbnail').attr('src', thumbnailSrc);
                
                // Set basic info
                $('#modalCourseName').text(courseData.courseName);
                $('#modalCourseId').text(courseData.formattedId);
                
                // Set status badge
                const statusClass = courseData.isActive ? 'status-active' : 'status-inactive';
                const statusIcon = courseData.isActive ? 'fa-check-circle' : 'fa-pause-circle';
                $('#modalCourseStatusBadge').removeClass('status-active status-inactive')
                    .addClass('course-status ' + statusClass)
                    .html(`<i class="fas ${statusIcon} me-1"></i>${courseData.status}`);
                
                // Set detail fields
                $('#modalCourseNameDetail').text(courseData.courseName);
                $('#modalCourseIdDetail span').text(courseData.formattedId);
                
                // Duration
                const durationText = courseData.duration || 'Not specified';
                $('#modalCourseDuration span').text(durationText);
                if (!courseData.duration) {
                    $('#modalCourseDuration').addClass('empty');
                } else {
                    $('#modalCourseDuration').removeClass('empty');
                }
                
                // Teacher
                $('#modalCourseTeacher span').text(`Teacher ID: ${courseData.teacherId}`);
                
                // Status detail
                $('#modalCourseStatusDetail').html(`<i class="fas ${statusIcon}"></i><span class="${statusClass.replace('status-', '')}">${courseData.status}</span>`);
                
                // Dates
                $('#modalCourseCreated span').text(courseData.createdDate);
                $('#modalCourseCreatedFull span').text(courseData.createdDateFull);
                
                const updatedText = courseData.updatedDate || 'Never updated';
                $('#modalCourseUpdated span').text(updatedText);
                if (!courseData.updatedDate) {
                    $('#modalCourseUpdated').addClass('empty');
                } else {
                    $('#modalCourseUpdated').removeClass('empty');
                }
                
                // Description
                const descriptionText = courseData.description || 'No description available for this course.';
                $('#modalCourseDescription').text(descriptionText);
                if (!courseData.description) {
                    $('#modalCourseDescription').addClass('empty');
                } else {
                    $('#modalCourseDescription').removeClass('empty');
                }
                
                // YouTube section
                if (courseData.youTubeLink) {
                    $('#youtubeSection').show();
                    $('#modalYouTubeLink').attr('href', courseData.youTubeLink);
                    $('#modalYouTubeBtnFooter').attr('href', courseData.youTubeLink).show();
                } else {
                    $('#youtubeSection').hide();
                    $('#modalYouTubeBtnFooter').hide();
                }
                
                // Edit button
                $('#modalEditBtn').attr('href', `AddCourse.aspx?id=${courseData.courseId}`);
                
                // Show modal
                $('#courseDetailsModal').modal('show');
                
            } catch (error) {
                console.error('Error populating course modal:', error);
                showErrorToast('Error displaying course details');
            }
        }

        // Clear filters function
        function clearFilters() {
            $('#<%= txtSearch.ClientID %>').val('');
            $('#<%= ddlStatusFilter.ClientID %>').val('');
            $('#<%= btnSearch.ClientID %>').click();
        }

        // Toast notification functions
        function showSuccessToast(message) {
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'success',
                title: message,
                showConfirmButton: false,
                timer: 4000,
                timerProgressBar: true,
                customClass: {
                    popup: 'animate__animated animate__fadeInRight'
                }
            });
        }


        function showErrorToast(message) {
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'error',
                title: message,
                showConfirmButton: false,
                timer: 5000,
                timerProgressBar: true,
                customClass: {
                    popup: 'animate__animated animate__fadeInRight'
                }
            });
        }

        function showWarningToast(message) {
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'warning',
                title: message,
                showConfirmButton: false,
                timer: 4000,
                timerProgressBar: true,
                customClass: {
                    popup: 'animate__animated animate__fadeInRight'
                }
            });
        }

        function showInfoToast(message) {
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'info',
                title: message,
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true,
                customClass: {
                    popup: 'animate__animated animate__fadeInRight'
                }
            });
        }

        function showLoadingToast(message) {
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'info',
                title: message,
                showConfirmButton: false,
                timer: 2000,
                timerProgressBar: true,
                customClass: {
                    popup: 'animate__animated animate__fadeInRight'
                }
            });
        }

        // Modal event handlers
        $('#courseDetailsModal').on('shown.bs.modal', function () {
            // Modal shown - can add any additional logic here
        });

        $('#courseDetailsModal').on('hidden.bs.modal', function () {
            // Clear modal data when hidden
            currentCourseData = null;
        });

        // Re-bind events after postback
        function rebindEvents() {
            bindEvents();
        }

        // Page methods for server-side calls
        window.rebindEvents = rebindEvents;
        window.populateCourseModal = populateCourseModal;
        
    </script>
</asp:Content>