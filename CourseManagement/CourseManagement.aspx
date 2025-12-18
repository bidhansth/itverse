<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/AdminDashboard.Master" AutoEventWireup="true" CodeBehind="CourseManagement.aspx.cs" Inherits="LMS.CourseManagement.CourseManagement" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <!-- Modern DataTables CSS -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.bootstrap5.min.css">
    
    <!-- Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/11.7.32/sweetalert2.min.css">
    
    <style>
        :root {
            --primary-color: #2563eb;
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
            --gray-700: #374151;
            --gray-800: #1f2937;
            --gray-900: #111827;
            --border-radius: 8px;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        * {
            box-sizing: border-box;
        }

        body {
            background-color: var(--gray-50);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: var(--gray-800);
            line-height: 1.6;
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

        /* Modern Buttons */
        .btn-modern {
            padding: 0.625rem 1.25rem;
            border-radius: var(--border-radius);
            font-weight: 500;
            font-size: 0.875rem;
            transition: all 0.15s ease-in-out;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-primary-modern {
            background-color: var(--primary-color);
            color: white;
            border: 1px solid var(--primary-color);
        }

        .btn-primary-modern:hover {
            background-color: #1d4ed8;
            border-color: #1d4ed8;
            color: white;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .btn-outline-modern {
            background-color: white;
            color: var(--gray-700);
            border: 1px solid var(--gray-300);
        }

        .btn-outline-modern:hover {
            background-color: var(--gray-50);
            border-color: var(--gray-400);
            color: var(--gray-700);
            transform: translateY(-1px);
            box-shadow: var(--shadow);
        }

        /* Statistics Cards - Clean Design */
        .stats-card {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            box-shadow: var(--shadow-sm);
            transition: all 0.15s ease-in-out;
            position: relative;
        }

        .stats-card:hover {
            border-color: var(--gray-300);
            box-shadow: var(--shadow);
        }

        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }

        .stats-label {
            font-size: 0.875rem;
            color: var(--gray-500);
            font-weight: 500;
        }

        .stats-icon {
            position: absolute;
            top: 1.5rem;
            right: 1.5rem;
            font-size: 1.25rem;
            color: var(--gray-300);
        }

        /* Color variants for stats cards */
        .stats-card.total .stats-number { color: var(--primary-color); }
        .stats-card.total .stats-icon { color: var(--primary-color); opacity: 0.2; }
        
        .stats-card.active .stats-number { color: var(--success-color); }
        .stats-card.active .stats-icon { color: var(--success-color); opacity: 0.2; }
        
        .stats-card.inactive .stats-number { color: var(--warning-color); }
        .stats-card.inactive .stats-icon { color: var(--warning-color); opacity: 0.2; }
        
        .stats-card.new .stats-number { color: var(--danger-color); }
        .stats-card.new .stats-icon { color: var(--danger-color); opacity: 0.2; }

        /* Table Container - Clean and Modern */
        .table-container {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
        }

        .table-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--gray-200);
            background: var(--gray-50);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .table-header h5 {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--gray-900);
            margin: 0;
        }

        .filter-group {
            display: flex;
            gap: 0.75rem;
            align-items: center;
        }

        .filter-select {
            padding: 0.5rem 0.75rem;
            border: 1px solid var(--gray-300);
            border-radius: var(--border-radius);
            background: white;
            font-size: 0.875rem;
            color: var(--gray-700);
            min-width: 200px;
            transition: all 0.15s ease-in-out;
        }

        .filter-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            outline: none;
        }

        /* Table Styles - Clean and Modern */
        .table {
            margin-bottom: 0;
            font-size: 0.875rem;
        }

        .table thead th {
            background-color: var(--gray-50) !important;
            border-bottom: 2px solid var(--gray-200) !important;
            color: var(--gray-700) !important;
            font-weight: 600 !important;
            font-size: 0.875rem !important;
            padding: 1rem !important;
            position: sticky !important;
            top: 0 !important;
            z-index: 10 !important;
            border-top: none !important;
        }

        .table tbody tr {
            transition: background-color 0.15s ease-in-out;
            border: none;
        }

        .table tbody tr:hover {
            background-color: var(--gray-50);
        }

        .table tbody td {
            padding: 1rem;
            border-bottom: 1px solid var(--gray-200);
            vertical-align: middle;
            border-top: none;
        }

        /* Course Thumbnail */
        .course-thumbnail {
            width: 60px;
            height: 40px;
            border-radius: var(--border-radius);
            object-fit: cover;
            border: 2px solid var(--gray-200);
        }

        /* Status Badges */
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .status-active {
            background-color: #dcfce7;
            color: var(--success-color);
        }

        .status-inactive {
            background-color: #fef3c7;
            color: var(--warning-color);
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            justify-content: center;
        }

        .action-btn {
            width: 32px;
            height: 32px;
            border-radius: var(--border-radius);
            border: 1px solid;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            transition: all 0.15s ease-in-out;
            text-decoration: none;
            cursor: pointer;
        }

        .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: var(--shadow);
        }

        .btn-view {
            background-color: #f0f9ff;
            border-color: var(--info-color);
            color: var(--info-color);
        }

        .btn-view:hover {
            background-color: var(--info-color);
            color: white;
        }

        .btn-edit {
            background-color: var(--primary-light);
            border-color: var(--primary-color);
            color: var(--primary-color);
        }

        .btn-edit:hover {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-toggle {
            background-color: #fef3c7;
            border-color: var(--warning-color);
            color: var(--warning-color);
        }

        .btn-toggle:hover {
            background-color: var(--warning-color);
            color: white;
        }

        .btn-delete {
            background-color: #fef2f2;
            border-color: var(--danger-color);
            color: var(--danger-color);
        }

        .btn-delete:hover {
            background-color: var(--danger-color);
            color: white;
        }

        /* Course Details Modal Styles */
        .modal-content {
            border: none;
            border-radius: 12px;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(135deg, var(--primary-color), #1d4ed8);
            color: white;
            border: none;
            padding: 1.5rem 2rem;
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
            font-weight: 600;
            font-size: 1.25rem;
            margin: 0;
        }

        .btn-close {
            filter: brightness(0) invert(1);
            opacity: 0.8;
        }

        .btn-close:hover {
            opacity: 1;
        }

        .modal-body {
            padding: 0;
        }

        /* Course Profile Header */
        .course-profile-header {
            background: var(--gray-50);
            padding: 2rem;
            text-align: center;
            border-bottom: 1px solid var(--gray-200);
        }

        .course-thumbnail-large {
            width: 120px;
            height: 80px;
            border-radius: var(--border-radius);
            object-fit: cover;
            border: 4px solid white;
            box-shadow: var(--shadow-md);
            margin-bottom: 1rem;
        }

        .course-name {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }

        .course-id {
            font-size: 1rem;
            color: var(--gray-500);
            font-weight: 500;
        }

        .course-status {
            margin-top: 1rem;
        }

        /* Course Details Grid */
        .course-details {
            padding: 2rem;
        }

        .detail-section {
            margin-bottom: 2rem;
        }

        .detail-section:last-child {
            margin-bottom: 0;
        }

        .section-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-title i {
            color: var(--primary-color);
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .detail-item {
            background: var(--gray-50);
            border-radius: var(--border-radius);
            padding: 1rem;
            border-left: 3px solid var(--primary-color);
        }

        .detail-label {
            font-size: 0.875rem;
            color: var(--gray-500);
            font-weight: 500;
            margin-bottom: 0.25rem;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .detail-value {
            font-size: 1rem;
            color: var(--gray-900);
            font-weight: 500;
        }

        .detail-value.empty {
            color: var(--gray-400);
            font-style: italic;
        }

        .detail-value .icon {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }

        /* Modal Footer */
        .modal-footer {
            background: var(--gray-50);
            border-top: 1px solid var(--gray-200);
            padding: 1rem 2rem;
            justify-content: space-between;
        }

        .modal-footer .btn {
            border-radius: var(--border-radius);
            font-weight: 500;
            padding: 0.5rem 1rem;
        }

        /* No Data Container */
        .no-data-container {
            padding: 3rem 2rem;
            text-align: center;
            background: white;
        }

        .no-data-icon {
            font-size: 3rem;
            color: var(--gray-300);
            margin-bottom: 1rem;
        }

        .no-data-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }

        .no-data-text {
            color: var(--gray-500);
            margin-bottom: 1.5rem;
        }

        /* Duration Badge */
        .duration-badge {
            background-color: var(--primary-light);
            color: var(--primary-color);
            padding: 0.25rem 0.5rem;
            border-radius: var(--border-radius);
            font-size: 0.75rem;
            font-weight: 500;
        }

        /* Teacher Badge */
        .teacher-badge {
            background-color: #f0fdf4;
            color: var(--success-color);
            padding: 0.25rem 0.5rem;
            border-radius: var(--border-radius);
            font-size: 0.75rem;
            font-weight: 500;
        }

        /* Animation */
        .animate-fade-in {
            animation: fadeIn 0.3s ease-out;
        }

        .animate-slide-up {
            animation: slideUp 0.3s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive Design for Modal */
        @media (max-width: 768px) {
            .modal-dialog {
                margin: 0.5rem;
            }
            
            .course-profile-header {
                padding: 1.5rem;
            }
            
            .course-details {
                padding: 1.5rem;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .course-thumbnail-large {
                width: 100px;
                height: 65px;
            }
            
            .course-name {
                font-size: 1.25rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <nav aria-label="breadcrumb" class="animate-fade-in">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href='<%= ResolveUrl("~/AdminDefault.aspx") %>'><i class="fas fa-home me-1"></i>Dashboard</a></li>
            <li class="breadcrumb-item active"><i class="fas fa-book me-1"></i>Course Management</li>
        </ol>
    </nav>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Hidden fields for message handling -->
    <asp:HiddenField ID="hdnMessage" runat="server" />
    <asp:HiddenField ID="hdnMessageType" runat="server" />

    <!-- Page Header -->
    <div class="page-header animate-fade-in">
        <div class="d-flex justify-content-between align-items-center flex-wrap">
            <div>
                <h1 class="page-title">
                    <i class="fas fa-book me-2"></i>Course Management
                </h1>
                <p class="page-subtitle">Manage and organize course catalog efficiently</p>
            </div>
            <div class="d-flex gap-2">
                <button type="button" class="btn-modern btn-outline-modern" onclick="refreshCourseData()">
                    <i class="fas fa-sync-alt"></i>Refresh
                </button>
                <a href="AddCourse.aspx" class="btn-modern btn-primary-modern">
                    <i class="fas fa-plus"></i>Add Course
                </a>
            </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="stats-card total animate-slide-up">
                <i class="fas fa-book stats-icon"></i>
                <div class="stats-number">
                    <asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stats-label">Total Courses</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="stats-card active animate-slide-up" style="animation-delay: 0.1s;">
                <i class="fas fa-check-circle stats-icon"></i>
                <div class="stats-number">
                    <asp:Label ID="lblActiveCourses" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stats-label">Active Courses</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="stats-card inactive animate-slide-up" style="animation-delay: 0.2s;">
                <i class="fas fa-times-circle stats-icon"></i>
                <div class="stats-number">
                    <asp:Label ID="lblInactiveCourses" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stats-label">Inactive Courses</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="stats-card new animate-slide-up" style="animation-delay: 0.3s;">
                <i class="fas fa-star stats-icon"></i>
                <div class="stats-number">
                    <asp:Label ID="lblNewCourses" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stats-label">New This Month</div>
            </div>
        </div>
    </div>

    <!-- Courses Table -->
    <div class="table-container animate-fade-in">
        <div class="table-header">
            <h5><i class="fas fa-table me-2"></i>Course Directory</h5>
            <div class="filter-group">
                <select id="statusFilter" class="form-select filter-select">
                    <option value="">All Status</option>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>
        </div>

        <div class="table-wrapper">
            <!-- No Courses Message -->
            <asp:Panel ID="pnlNoCourses" runat="server" Visible="false">
                <div class="no-data-container">
                    <div class="no-data-icon">
                        <i class="fas fa-book-open"></i>
                    </div>
                    <h4 class="no-data-title">No Courses Found</h4>
                    <p class="no-data-text">Start building your course catalog by adding your first course.</p>
                    <a href="AddCourse.aspx" class="btn-modern btn-primary-modern">
                        <i class="fas fa-plus"></i>Add Your First Course
                    </a>
                </div>
            </asp:Panel>
            
            <asp:GridView ID="gvCourses" runat="server" 
                CssClass="table table-hover display" 
                AutoGenerateColumns="false"
                OnRowCommand="gvCourses_RowCommand"
                DataKeyNames="CourseId">
                <Columns>
                    <asp:TemplateField HeaderText="Thumbnail">
                        <ItemTemplate>
                            <img 
                            src='<%# 
                                Eval("Thumbnail") != DBNull.Value && !string.IsNullOrEmpty(Convert.ToString(Eval("Thumbnail"))) 
                                ? ResolveUrl(Convert.ToString(Eval("Thumbnail"))) 
                                : "https://via.placeholder.com/60x40/2563eb/ffffff?text=Course"
                            %>' 
                            alt="Course" class="course-thumbnail" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Course ID">
                        <ItemTemplate>
                            <div class="fw-semibold text-primary">CRS-<%# Eval("CourseId").ToString().PadLeft(4, '0') %></div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Course Information">
                        <ItemTemplate>
                            <div>
                                <div class="fw-semibold mb-1"><%# Eval("CourseName") %></div>
                                <div class="text-muted small">
                                    <%# !string.IsNullOrEmpty(Eval("Description").ToString()) ? 
                                        (Eval("Description").ToString().Length > 50 ? 
                                            Eval("Description").ToString().Substring(0, 50) + "..." : 
                                            Eval("Description").ToString()) : "No description available" %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Teacher">
                        <ItemTemplate>
                            <div>
                                <span class="teacher-badge">
                                    <i class="fas fa-chalkboard-teacher me-1"></i>
                                    Teacher ID: <%# Eval("TeacherId") %>
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Duration">
                        <ItemTemplate>
                            <div>
                                <%# !string.IsNullOrEmpty(Eval("Duration").ToString()) ? 
                                    $"<span class='duration-badge'><i class='fas fa-clock me-1'></i>{Eval("Duration")}</span>" : 
                                    "<span class='text-muted small'>Not specified</span>" %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='status-badge <%# Convert.ToBoolean(Eval("IsActive")) ? "status-active" : "status-inactive" %>'>
                                <i class='fas <%# Convert.ToBoolean(Eval("IsActive")) ? "fa-check-circle" : "fa-times-circle" %> me-1'></i>
                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Created Date">
                        <ItemTemplate>
                            <div class="fw-medium"><%# Convert.ToDateTime(Eval("CreatedAt")).ToString("MMM dd, yyyy") %></div>
                            <div class="text-muted small"><%# Convert.ToDateTime(Eval("CreatedAt")).ToString("hh:mm tt") %></div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                     <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="action-buttons">
                                <asp:LinkButton ID="btnViewCourse" runat="server" 
                                    CommandName="ViewCourse" 
                                    CommandArgument='<%# Eval("CourseId") %>'
                                    CssClass="action-btn btn-view"
                                    ToolTip="View Details"
                                    OnClientClick='<%# "viewCourseDetails(" + Eval("CourseId") + "); return false;" %>'
                                    data-bs-toggle="tooltip">
                                    <i class="fas fa-eye"></i>
                                </asp:LinkButton>
                                <a href='AddCourse.aspx?id=<%# Eval("CourseId") %>' 
                                   class="action-btn btn-edit" 
                                   title="Edit Course"
                                   data-bs-toggle="tooltip">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <asp:LinkButton ID="btnToggleStatus" runat="server" 
                                    CommandName="ToggleStatus" 
                                    CommandArgument='<%# Eval("CourseId") %>'
                                    CssClass="action-btn btn-toggle"
                                    ToolTip='<%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>'
                                    OnClientClick="return confirmStatusToggle(this);">
                                    <i class='<%# "fas " + (Convert.ToBoolean(Eval("IsActive")) ? "fa-eye-slash" : "fa-eye") %>'></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" 
                                    CommandName="DeleteCourse" 
                                    CommandArgument='<%# Eval("CourseId") %>'
                                    CssClass="action-btn btn-delete"
                                    ToolTip="Delete Course"
                                    OnClientClick="return confirmDelete(this);">
                                    <i class="fas fa-trash"></i>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- Course Details Modal -->
    <div class="modal fade" id="courseDetailsModal" tabindex="-1" aria-labelledby="courseDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="courseDetailsModalLabel">
                        <i class="fas fa-book me-2"></i>Course Details
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Course Profile Header -->
                    <div class="course-profile-header">
                        <img id="modalCourseThumbnail" src="" alt="Course" class="course-thumbnail-large">
                        <h3 id="modalCourseName" class="course-name"></h3>
                        <div id="modalCourseId" class="course-id"></div>
                        <div class="course-status">
                            <span id="modalCourseStatus" class="status-badge"></span>
                        </div>
                    </div>

                    <!-- Course Details -->
                    <div class="course-details">
                        <!-- Basic Information -->
                        <div class="detail-section">
                            <h6 class="section-title">
                                <i class="fas fa-info-circle"></i>Basic Information
                            </h6>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <div class="detail-label">Course Name</div>
                                    <div id="modalCourseNameDetail" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Duration</div>
                                    <div id="modalCourseDuration" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Teacher ID</div>
                                    <div id="modalCourseTeacher" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Status</div>
                                    <div id="modalCourseStatusDetail" class="detail-value"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="detail-section">
                            <h6 class="section-title">
                                <i class="fas fa-align-left"></i>Description
                            </h6>
                            <div class="detail-item">
                                <div id="modalCourseDescription" class="detail-value"></div>
                            </div>
                        </div>

                        <!-- Timestamps -->
                        <div class="detail-section">
                            <h6 class="section-title">
                                <i class="fas fa-clock"></i>Timeline
                            </h6>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <div class="detail-label">Created On</div>
                                    <div id="modalCourseCreated" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Last Updated</div>
                                    <div id="modalCourseUpdated" class="detail-value"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Close
                    </button>
                    <a id="modalEditBtn" href="#" class="btn btn-primary">
                        <i class="fas fa-edit me-1"></i>Edit Course
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for functionality -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/11.7.32/sweetalert2.min.js"></script>

  <script>
      let coursesTable;

      $(document).ready(function () {
          // Initialize DataTable with a small delay
          setTimeout(function () {
              initializeDataTable();
          }, 200);

          // Show message if exists
          showMessage();

          // Initialize view course functionality
          initializeViewCourse();
      });

      function initializeDataTable() {
          const table = $('#<%= gvCourses.ClientID %>');
          if (table.length === 0) return;

          // Destroy existing DataTable if it exists
          if ($.fn.DataTable.isDataTable(table)) {
              table.DataTable().destroy();
          }

          try {
              coursesTable = table.DataTable({
                  responsive: true,
                  pageLength: 10,
                  lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
                  order: [[6, 'desc']], // Sort by created date
                  columnDefs: [
                      { orderable: false, targets: [0, 7] }, // Disable sorting for thumbnail and actions
                      { searchable: false, targets: [0, 7] }  // Disable search for thumbnail and actions
                  ],
                  language: {
                      search: "Search courses:",
                      lengthMenu: "Show _MENU_ courses per page",
                      info: "Showing _START_ to _END_ of _TOTAL_ courses",
                      infoEmpty: "No courses available",
                      infoFiltered: "(filtered from _MAX_ total courses)",
                      paginate: {
                          first: "First",
                          last: "Last",
                          next: "Next",
                          previous: "Previous"
                      }
                  },
                  drawCallback: function () {
                      // Reinitialize view course functionality
                      initializeViewCourse();
                  }
              });

              // Status filter
              $('#statusFilter').on('change', function () {
                  const filterValue = this.value;
                  if (filterValue === '') {
                      coursesTable.column(5).search('').draw();
                  } else {
                      coursesTable.column(5).search(filterValue).draw();
                  }
              });
          } catch (error) {
              console.error('Error initializing DataTable:', error);
          }
      }

      function initializeViewCourse() {
          // Handle view course button clicks
          $(document).off('click', '.btn-view').on('click', '.btn-view', function (e) {
              e.preventDefault();

              const row = $(this).closest('tr');
              const courseData = extractCourseDataFromRow(row);

              if (courseData) {
                  populateCourseModal(courseData);

                  // Initialize Bootstrap modal if not already initialized
                  if (typeof bootstrap !== 'undefined') {
                      const courseModal = new bootstrap.Modal(document.getElementById('courseDetailsModal'));
                      courseModal.show();
                  } else {
                      $('#courseDetailsModal').modal('show');
                  }
              } else {
                  showErrorToast('Unable to load course details');
              }
          });

          // Handle edit button in modal
          $('#modalEditBtn').off('click').on('click', function () {
              const courseId = $(this).data('course-id');
              if (courseId) {
                  window.location.href = `AddCourse.aspx?id=${courseId}`;
              }
          });
      }

      function extractCourseDataFromRow(row) {
          try {
              const cells = row.find('td');

              // Get thumbnail src
              const thumbnail = cells.eq(0).find('img').attr('src') || '';

              // Get course ID from the formatted text (remove CRS- prefix and leading zeros)
              const courseIdText = cells.eq(1).find('.fw-semibold').text().trim();
              const courseId = courseIdText.replace('CRS-', '').replace(/^0+/, '') || '0';

              // Get course name and description
              const nameElement = cells.eq(2).find('.fw-semibold');
              const descElement = cells.eq(2).find('.text-muted');
              const courseName = nameElement.text().trim();
              const description = descElement.text().trim();

              // Get teacher ID
              const teacherElement = cells.eq(3).find('.teacher-badge');
              const teacherId = teacherElement.text().replace('Teacher ID:', '').trim();

              // Get duration
              const durationElement = cells.eq(4).find('.duration-badge');
              let duration = '';
              if (durationElement.length) {
                  duration = durationElement.text().replace('🕒', '').trim();
              }

              // Get status
              const statusElement = cells.eq(5).find('.status-badge');
              const isActive = statusElement.hasClass('status-active');
              const status = isActive ? 'Active' : 'Inactive';

              // Get created date
              const createdDateElement = cells.eq(6).find('.fw-medium');
              const createdTimeElement = cells.eq(6).find('.text-muted');
              const createdDate = createdDateElement.text().trim();
              const createdTime = createdTimeElement.text().trim();

              return {
                  courseId: courseId,
                  thumbnail: thumbnail,
                  courseName: courseName,
                  description: description,
                  teacherId: teacherId,
                  duration: duration,
                  isActive: isActive,
                  status: status,
                  createdDate: createdDate,
                  createdTime: createdTime,
                  formattedId: courseIdText
              };
          } catch (error) {
              console.error('Error extracting course data:', error);
              return null;
          }
      }

      function populateCourseModal(data) {
          try {
              // Basic info
              $('#modalCourseThumbnail').attr('src', data.thumbnail || 'https://via.placeholder.com/120x80/2563eb/ffffff?text=Course');
              $('#modalCourseName').text(data.courseName);
              $('#modalCourseId').text(data.formattedId);

              // Status badge
              const statusClass = data.isActive ? 'status-active' : 'status-inactive';
              const statusIcon = data.isActive ? 'fa-check-circle' : 'fa-times-circle';
              $('#modalCourseStatus').removeClass('status-active status-inactive')
                  .addClass('status-badge ' + statusClass)
                  .html('<i class="fas ' + statusIcon + ' me-1"></i>' + data.status);

              // Detail fields
              $('#modalCourseNameDetail').text(data.courseName);
              $('#modalCourseDuration').text(data.duration || 'Not specified').toggleClass('empty', !data.duration);
              $('#modalCourseTeacher').html('<i class="fas fa-chalkboard-teacher icon"></i>Teacher ID: ' + data.teacherId);
              $('#modalCourseStatusDetail').html('<i class="fas ' + statusIcon + ' icon"></i>' + data.status);
              $('#modalCourseDescription').text(data.description || 'No description available').toggleClass('empty', !data.description);
              $('#modalCourseCreated').html('<i class="fas fa-calendar icon"></i>' + data.createdDate + ' at ' + data.createdTime);
              $('#modalCourseUpdated').html('<i class="fas fa-history icon"></i>Not updated'); // You would need to add this to your data model

              // Set course ID for edit button
              $('#modalEditBtn').attr('href', 'AddCourse.aspx?id=' + data.courseId);

          } catch (error) {
              console.error('Error populating course modal:', error);
              showErrorToast('Error displaying course details');
          }
      }

      function refreshCourseData() {
          showInfoToast('Refreshing course data...');
          setTimeout(function () {
              window.location.reload();
          }, 500);
      }

      function confirmStatusToggle(element) {
          const row = $(element).closest('tr');
          const courseName = row.find('td:eq(2) .fw-semibold').text().trim();
          const isActive = $(element).find('i').hasClass('fa-eye-slash');
          const action = isActive ? 'deactivate' : 'activate';
          const title = isActive ? 'Deactivate Course?' : 'Activate Course?';
          const text = `Are you sure you want to ${action} "${courseName}"?`;

          // Prevent postback first
          event.preventDefault();

          Swal.fire({
              title: title,
              text: text,
              icon: 'question',
              showCancelButton: true,
              confirmButtonColor: isActive ? '#f59e0b' : '#10b981',
              cancelButtonColor: '#6b7280',
              confirmButtonText: `Yes, ${action}!`,
              cancelButtonText: 'Cancel',
              reverseButtons: true
          }).then((result) => {
              if (result.isConfirmed) {
                  // Manually trigger the actual click, bypassing OnClientClick
                  element.onclick = null;
                  element.click();
              }
          });

          return false;
      }

      function confirmDelete(element) {
          const row = $(element).closest('tr');
          const courseName = row.find('td:eq(2) .fw-semibold').text().trim();

          Swal.fire({
              title: 'Delete Course?',
              html: `
                    <div class="text-start">
                        <p class="text-danger mt-3">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            This action cannot be undone. The course will be permanently removed.
                        </p>
                    </div>
                `,
              icon: 'warning',
              showCancelButton: true,
              confirmButtonColor: '#ef4444',
              cancelButtonColor: '#6b7280',
              confirmButtonText: '<i class="fas fa-trash me-2"></i>Yes, delete!',
              cancelButtonText: '<i class="fas fa-times me-2"></i>Cancel',
              reverseButtons: true,
              customClass: {
                  confirmButton: 'btn btn-danger',
                  cancelButton: 'btn btn-secondary'
              }
          }).then((result) => {
              if (result.isConfirmed) {
                  element.onclick = null;
                  element.click();
              }
          });

          return false;
      }

      function showMessage() {
          const message = $('#<%= hdnMessage.ClientID %>').val();
            const messageType = $('#<%= hdnMessageType.ClientID %>').val();

            if (message) {
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
                    default:
                        showInfoToast(message);
                }

                // Clear the message
                $('#<%= hdnMessage.ClientID %>').val('');
                $('#<%= hdnMessageType.ClientID %>').val('');
          }
      }

      // Toast notification functions
      function showSuccessToast(message) {
          Swal.fire({
              toast: true,
              position: 'top-end',
              icon: 'success',
              title: message,
              showConfirmButton: false,
              timer: 3000,
              timerProgressBar: true,
              didOpen: (toast) => {
                  toast.addEventListener('mouseenter', Swal.stopTimer)
                  toast.addEventListener('mouseleave', Swal.resumeTimer)
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
              timer: 4000,
              timerProgressBar: true,
              didOpen: (toast) => {
                  toast.addEventListener('mouseenter', Swal.stopTimer)
                  toast.addEventListener('mouseleave', Swal.resumeTimer)
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
              timer: 3000,
              timerProgressBar: true,
              didOpen: (toast) => {
                  toast.addEventListener('mouseenter', Swal.stopTimer)
                  toast.addEventListener('mouseleave', Swal.resumeTimer)
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
              didOpen: (toast) => {
                  toast.addEventListener('mouseenter', Swal.stopTimer)
                  toast.addEventListener('mouseleave', Swal.resumeTimer)
              }
          });
      }
    </script>
</asp:Content>