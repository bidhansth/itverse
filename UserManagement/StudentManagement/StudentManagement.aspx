
<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/AdminDashboard.Master" AutoEventWireup="true" CodeBehind="StudentManagement.aspx.cs" Inherits="LMS.UserManagement.StudentMangement.StudentManagement" %>

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
            background-color: #b91c1c;
            border-color: #b91c1c;
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

        /* Avatar */
        .student-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
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

        /* Student Details Modal Styles */
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

        /* Student Profile Header */
        .student-profile-header {
            background: var(--gray-50);
            padding: 2rem;
            text-align: center;
            border-bottom: 1px solid var(--gray-200);
        }

        .profile-avatar-large {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: var(--shadow-md);
            margin-bottom: 1rem;
        }

        .profile-name {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }

        .profile-id {
            font-size: 1rem;
            color: var(--gray-500);
            font-weight: 500;
        }

        .profile-status {
            margin-top: 1rem;
        }

        /* Student Details Grid */
        .student-details {
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

        /* Responsive Design for Modal */
        @media (max-width: 768px) {
            .modal-dialog {
                margin: 0.5rem;
            }
            
            .student-profile-header {
                padding: 1.5rem;
            }
            
            .student-details {
                padding: 1.5rem;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .profile-avatar-large {
                width: 80px;
                height: 80px;
            }
            
            .profile-name {
                font-size: 1.25rem;
            }
        }

        /* Animation for modal */
        .modal.fade .modal-dialog {
            transition: transform 0.3s ease-out;
            transform: translate(0, -50px);
        }

        .modal.show .modal-dialog {
            transform: none;
        }

        /* DataTables customization - keeping existing styles */
        .dataTables_wrapper {
            padding: 1.5rem;
        }

        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid var(--gray-300) !important;
            border-radius: var(--border-radius) !important;
            padding: 0.5rem 0.75rem !important;
            background: white !important;
            font-size: 0.875rem !important;
            color: var(--gray-700) !important;
        }

        .dataTables_wrapper .dataTables_filter input:focus {
            border-color: var(--primary-color) !important;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1) !important;
            outline: none !important;
        }

        /* Export Buttons */
        .dt-buttons .dt-button {
            background-color: white !important;
            border: 1px solid var(--gray-300) !important;
            color: var(--gray-700) !important;
            border-radius: var(--border-radius) !important;
            padding: 0.5rem 0.75rem !important;
            font-size: 0.875rem !important;
            font-weight: 500 !important;
            margin-right: 0.5rem !important;
            transition: all 0.15s ease-in-out !important;
        }

        .dt-buttons .dt-button:hover {
            background-color: var(--gray-50) !important;
            border-color: var(--gray-400) !important;
            transform: translateY(-1px) !important;
            box-shadow: var(--shadow) !important;
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

        /* Pagination */
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            border: 1px solid var(--gray-300) !important;
            color: var(--gray-700) !important;
            background: white !important;
            margin: 0 2px !important;
            border-radius: var(--border-radius) !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: var(--gray-50) !important;
            border-color: var(--gray-400) !important;
            color: var(--gray-700) !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: var(--primary-color) !important;
            border-color: var(--primary-color) !important;
            color: white !important;
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <nav aria-label="breadcrumb" class="animate-fade-in">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href='<%= ResolveUrl("~/AdminDefault.aspx") %>'><i class="fas fa-home me-1"></i>Dashboard</a></li>
            <li class="breadcrumb-item active"><i class="fas fa-users me-1"></i>Student Management</li>
        </ol>
    </nav>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header -->
    <div class="page-header animate-fade-in">
        <div class="d-flex justify-content-between align-items-center flex-wrap">
            <div>
                <h1 class="page-title">
                    <i class="fas fa-graduation-cap me-2"></i>Student Management
                </h1>
                <p class="page-subtitle">Manage and organize student records efficiently</p>
            </div>
            <div class="d-flex gap-2">
                <button type="button" class="btn-modern btn-outline-modern" onclick="refreshStudentData()">
                    <i class="fas fa-sync-alt"></i>Refresh
                </button>
                <a href="AddStudent.aspx" class="btn-modern btn-primary-modern">
                    <i class="fas fa-plus"></i>Add Student
                </a>
            </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="stats-card total animate-slide-up">
                <i class="fas fa-users stats-icon"></i>
                <div class="stats-number">
                    <asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stats-label">Total Students</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="stats-card active animate-slide-up" style="animation-delay: 0.1s;">
                <i class="fas fa-user-check stats-icon"></i>
                <div class="stats-number">
                    <asp:Label ID="lblActiveStudents" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stats-label">Active Students</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="stats-card inactive animate-slide-up" style="animation-delay: 0.2s;">
                <i class="fas fa-user-times stats-icon"></i>
                <div class="stats-number">
                    <asp:Label ID="lblInactiveStudents" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stats-label">Inactive Students</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="stats-card new animate-slide-up" style="animation-delay: 0.3s;">
                <i class="fas fa-star stats-icon"></i>
                <div class="stats-number">
                    <asp:Label ID="lblNewStudents" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stats-label">New This Month</div>
            </div>
        </div>
    </div>

    <!-- Students Table -->
    <div class="table-container animate-fade-in">
        <div class="table-header">
            <h5><i class="fas fa-table me-2"></i>Student Directory</h5>
            <div class="filter-group">
                <select id="genderFilter" class="form-select filter-select">
                    <option value="">All Genders</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
                <select id="statusFilter" class="form-select filter-select">
                    <option value="">All Status</option>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>
        </div>

        <div class="table-wrapper">
            <!-- No Students Message -->
            <asp:Panel ID="pnlNoStudents" runat="server" Visible="false">
                <div class="no-data-container">
                    <div class="no-data-icon">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <h4 class="no-data-title">No Students Found</h4>
                    <p class="no-data-text">Start building your student community by adding your first student.</p>
                    <a href="AddStudent.aspx" class="btn-modern btn-primary-modern">
                        <i class="fas fa-plus"></i>Add Your First Student
                    </a>
                </div>
            </asp:Panel>
            
            <asp:GridView ID="gvStudents" runat="server" 
                CssClass="table table-hover display" 
                AutoGenerateColumns="false"
                OnRowCommand="gvStudents_RowCommand"
                DataKeyNames="StudentId">
                <Columns>
                    <asp:TemplateField HeaderText="Profile">
                        <ItemTemplate>
                            <img 
                            src='<%# 
                                Eval("ProfilePicture") != DBNull.Value && !string.IsNullOrEmpty(Convert.ToString(Eval("ProfilePicture"))) 
                                ? ResolveUrl(Convert.ToString(Eval("ProfilePicture"))) 
                                : "https://ui-avatars.com/api/?name=" + 
                                  Server.UrlEncode(Convert.ToString(Eval("FirstName"))) + 
                                  "&background=2563eb&color=ffffff&size=40"
                            %>' 
                            alt="Profile" class="student-avatar" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Student ID">
                        <ItemTemplate>
                            <div class="fw-semibold text-primary">STU-<%# Eval("StudentId").ToString().PadLeft(4, '0') %></div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Student Information">
                        <ItemTemplate>
                            <div>
                                <div class="fw-semibold mb-1"><%# Eval("FullName") %></div>
                                <div class="text-muted small">
                                    <i class="fas fa-envelope me-1"></i><%# Eval("Email") %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Contact Details">
                        <ItemTemplate>
                            <div>
                                <div class="fw-medium">
                                    <i class="fas fa-phone me-1"></i>
                                    <%# !string.IsNullOrEmpty(Eval("ContactNumber").ToString()) ? Eval("ContactNumber") : "N/A" %>
                                </div>
                                <div class="text-muted small">
                                    <i class="fas fa-birthday-cake me-1"></i>Age: <%# Eval("Age") %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Gender">
                        <ItemTemplate>
                            <div class="fw-medium">
                                <i class='fas <%# Eval("Gender").ToString() == "Male" ? "fa-mars text-primary" : 
                                                  Eval("Gender").ToString() == "Female" ? "fa-venus text-danger" : "fa-genderless text-info" %> me-1'></i>
                                <%# Eval("Gender") %>
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
                    
                    <asp:TemplateField HeaderText="Joined Date">
                        <ItemTemplate>
                            <div class="fw-medium"><%# Convert.ToDateTime(Eval("CreatedAt")).ToString("MMM dd, yyyy") %></div>
                            <div class="text-muted small"><%# Convert.ToDateTime(Eval("CreatedAt")).ToString("hh:mm tt") %></div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="action-buttons">
                                <asp:LinkButton ID="btnViewStudent" runat="server" 
                                    CommandName="ViewStudent" 
                                    CommandArgument='<%# Eval("StudentId") %>'
                                    CssClass="action-btn btn-view"
                                    ToolTip="View Details"
                                    OnClientClick="return false;"
                                    data-bs-toggle="tooltip">
                                    <i class="fas fa-eye"></i>
                                </asp:LinkButton>
                                <a href='AddStudent.aspx?id=<%# Eval("StudentId") %>' 
                                   class="action-btn btn-edit" 
                                   title="Edit Student"
                                   data-bs-toggle="tooltip">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <asp:LinkButton ID="btnToggleStatus" runat="server" 
                                    CommandName="ToggleStatus" 
                                    CommandArgument='<%# Eval("StudentId") %>'
                                    CssClass="action-btn btn-toggle"
                                    ToolTip='<%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>'
                                    OnClientClick="return confirmStatusToggle(this);">
                                    <i class='<%# "fas " + (Convert.ToBoolean(Eval("IsActive")) ? "fa-eye-slash" : "fa-eye") %>'></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" 
                                    CommandName="DeleteStudent" 
                                    CommandArgument='<%# Eval("StudentId") %>'
                                    CssClass="action-btn btn-delete"
                                    ToolTip="Delete Student"
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

    <!-- Student Details Modal -->
    <div class="modal fade" id="studentDetailsModal" tabindex="-1" aria-labelledby="studentDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="studentDetailsModalLabel">
                        <i class="fas fa-user-graduate me-2"></i>Student Details
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Student Profile Header -->
                    <div class="student-profile-header">
                        <img id="modalProfileImage" src="" alt="Profile" class="profile-avatar-large">
                        <h3 id="modalStudentName" class="profile-name"></h3>
                        <p id="modalStudentId" class="profile-id"></p>
                        <div class="profile-status">
                            <span id="modalStudentStatus" class="status-badge"></span>
                        </div>
                    </div>

                    <!-- Student Details -->
                    <div class="student-details">
                        <!-- Personal Information -->
                        <div class="detail-section">
                            <h6 class="section-title">
                                <i class="fas fa-user"></i>Personal Information
                            </h6>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <div class="detail-label">First Name</div>
                                    <div id="modalFirstName" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Last Name</div>
                                    <div id="modalLastName" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Date of Birth</div>
                                    <div id="modalDateOfBirth" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Age</div>
                                    <div id="modalAge" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Gender</div>
                                    <div id="modalGender" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Blood Group</div>
                                    <div id="modalBloodGroup" class="detail-value"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Contact Information -->
                        <div class="detail-section">
                            <h6 class="section-title">
                                <i class="fas fa-address-book"></i>Contact Information
                            </h6>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <div class="detail-label">Email Address</div>
                                    <div id="modalEmail" class="detail-value">
                                        <i class="fas fa-envelope icon"></i><span></span>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Phone Number</div>
                                    <div id="modalPhone" class="detail-value">
                                        <i class="fas fa-phone icon"></i><span></span>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Emergency Contact</div>
                                    <div id="modalEmergencyContact" class="detail-value">
                                        <i class="fas fa-phone icon"></i><span></span>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Address</div>
                                    <div id="modalAddress" class="detail-value">
                                        <i class="fas fa-map-marker-alt icon"></i><span></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Academic Information -->
                        <div class="detail-section">
                            <h6 class="section-title">
                                <i class="fas fa-graduation-cap"></i>Academic Information
                            </h6>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <div class="detail-label">Registration Date</div>
                                    <div id="modalRegistrationDate" class="detail-value">
                                        <i class="fas fa-calendar icon"></i><span></span>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Last Updated</div>
                                    <div id="modalLastUpdated" class="detail-value">
                                        <i class="fas fa-clock icon"></i><span></span>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Account Status</div>
                                    <div id="modalAccountStatus" class="detail-value"></div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Student ID</div>
                                    <div id="modalFormattedId" class="detail-value">
                                        <i class="fas fa-id-card icon"></i><span></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Close
                        </button>
                        <button type="button" id="btnEditFromModal" class="btn btn-primary">
                            <i class="fas fa-edit me-1"></i>Edit Student
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden fields for messages -->
    <asp:HiddenField ID="hdnMessage" runat="server" />
    <asp:HiddenField ID="hdnMessageType" runat="server" />
    
    <!-- Hidden field to store student data for modal -->
    <asp:HiddenField ID="hdnStudentData" runat="server" />
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <!-- DataTables JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/datatables/1.10.21/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>
    
    <!-- SweetAlert2 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/11.7.32/sweetalert2.all.min.js"></script>

    <script>
        let studentsTable;

        $(document).ready(function () {
            // Add a small delay to ensure GridView is fully rendered
            setTimeout(function () {
                initializeDataTable();
            }, 200);

            // Set active menu item
            setActiveMenuItem('StudentManagement.aspx');

            // Show message if exists
            showMessage();

            // Initialize filters
            initializeFilters();

            // Initialize tooltips
            initializeTooltips();

            // Initialize view student functionality
            initializeViewStudent();
        });

        function initializeDataTable() {
            // Check if table exists and has rows
            const table = $('#<%= gvStudents.ClientID %>');
            if (table.length === 0) {
                console.log('Table not found');
                return;
            }

            // Destroy existing DataTable if it exists
            if ($.fn.DataTable.isDataTable(table)) {
                table.DataTable().destroy();
            }

            try {
                studentsTable = table.DataTable({
                    "responsive": true,
                    "pageLength": 25,
                    "lengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "dom": '<"row"<"col-md-6"l><"col-md-6"f>>rt<"row"<"col-md-6"i><"col-md-6"p>>B',
                    "buttons": [
                        {
                            extend: 'excel',
                            text: '<i class="fas fa-file-excel me-1"></i>Excel',
                            className: 'btn btn-success btn-sm me-2',
                            exportOptions: {
                                columns: [1, 2, 3, 4, 5, 6]
                            }
                        },
                        {
                            extend: 'pdf',
                            text: '<i class="fas fa-file-pdf me-1"></i>PDF',
                            className: 'btn btn-danger btn-sm me-2',
                            exportOptions: {
                                columns: [1, 2, 3, 4, 5, 6]
                            }
                        },
                        {
                            extend: 'print',
                            text: '<i class="fas fa-print me-1"></i>Print',
                            className: 'btn btn-info btn-sm me-2',
                            exportOptions: {
                                columns: [1, 2, 3, 4, 5, 6]
                            }
                        }
                    ],
                    "order": [[6, "desc"]],
                    "columnDefs": [
                        { "orderable": false, "targets": [0, 7] },
                        { "searchable": false, "targets": [0, 7] },
                        { "className": "text-center", "targets": [0, 7] }
                    ],
                    "language": {
                        "search": "Search students:",
                        "lengthMenu": "Show _MENU_ Students Per Page",
                        "info": "Showing _START_ to _END_ of _TOTAL_ students",
                        "infoEmpty": "No students found",
                        "infoFiltered": "(filtered from _MAX_ total students)",
                        "zeroRecords": "No students found matching your search criteria",
                        "emptyTable": "No students are currently registered in the system",
                        "paginate": {
                            "first": "First",
                            "last": "Last",
                            "next": "Next",
                            "previous": "Previous"
                        }
                    },
                    "drawCallback": function(settings) {
                        // Reinitialize tooltips after table redraw
                        initializeTooltips();
                        
                        // Reinitialize view student functionality
                        initializeViewStudent();
                        
                        // Add hover effects
                        $('.action-btn').hover(
                            function() {
                                $(this).addClass('shadow-sm');
                            },
                            function() {
                                $(this).removeClass('shadow-sm');
                            }
                        );
                    }
                });

                // Move buttons to custom location
                studentsTable.buttons().container()
                    .appendTo($('.table-header'));

            } catch (error) {
                console.error('Error initializing DataTable:', error);
            }
        }

        function initializeFilters() {
            if (!studentsTable) return;

            // Gender filter
            $('#genderFilter').on('change', function () {
                const value = $(this).val();
                studentsTable.column(4).search(value).draw();
            });

            // Status filter
            $('#statusFilter').on('change', function () {
                const value = $(this).val();
                studentsTable.column(5).search(value).draw();
            });
        }

        function initializeTooltips() {
            // Initialize Bootstrap tooltips
            if (typeof bootstrap !== 'undefined') {
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            }
        }

        function initializeViewStudent() {
            // Handle view student button clicks
            $(document).off('click', '.btn-view').on('click', '.btn-view', function(e) {
                e.preventDefault();
                
                const row = $(this).closest('tr');
                const studentData = extractStudentDataFromRow(row);
                
                if (studentData) {
                    populateStudentModal(studentData);
                    $('#studentDetailsModal').modal('show');
                } else {
                    showErrorToast('Unable to load student details');
                }
            });

            // Handle edit button in modal
            $('#btnEditFromModal').off('click').on('click', function() {
                const studentId = $(this).data('student-id');
                if (studentId) {
                    window.location.href = `AddStudent.aspx?id=${studentId}`;
                }
            });
        }

        function extractStudentDataFromRow(row) {
            try {
                const cells = row.find('td');
                
                // Get profile image src
                const profileImg = cells.eq(0).find('img').attr('src') || '';
                
                // Get student ID from the formatted text (remove STU- prefix and leading zeros)
                const studentIdText = cells.eq(1).find('.fw-semibold').text().trim();
                const studentId = studentIdText.replace('STU-', '').replace(/^0+/, '') || '0';
                
                // Get name and email
                const nameElement = cells.eq(2).find('.fw-semibold');
                const emailElement = cells.eq(2).find('.text-muted');
                const fullName = nameElement.text().trim();
                const email = emailElement.text().replace('✉', '').trim();
                
                // Split full name (assuming "FirstName LastName" format)
                const nameParts = fullName.split(' ');
                const firstName = nameParts[0] || '';
                const lastName = nameParts.slice(1).join(' ') || '';
                
                // Get contact details
                const contactElement = cells.eq(3).find('.fw-medium');
                const ageElement = cells.eq(3).find('.text-muted');
                const contactNumber = contactElement.text().replace('📞', '').trim();
                const ageText = ageElement.text().replace('🎂Age: ', '').trim();
                
                // Get gender
                const gender = cells.eq(4).find('.fw-medium').text().trim();
                
                // Get status
                const statusElement = cells.eq(5).find('.status-badge');
                const isActive = statusElement.hasClass('status-active');
                const status = isActive ? 'Active' : 'Inactive';
                
                // Get joined date
                const joinedDateElement = cells.eq(6).find('.fw-medium');
                const joinedTimeElement = cells.eq(6).find('.text-muted');
                const joinedDate = joinedDateElement.text().trim();
                const joinedTime = joinedTimeElement.text().trim();
                
                return {
                    studentId: studentId,
                    profileImage: profileImg,
                    firstName: firstName,
                    lastName: lastName,
                    fullName: fullName,
                    email: email,
                    contactNumber: contactNumber === 'N/A' ? '' : contactNumber,
                    age: ageText,
                    gender: gender,
                    isActive: isActive,
                    status: status,
                    joinedDate: joinedDate,
                    joinedTime: joinedTime,
                    formattedId: studentIdText
                };
            } catch (error) {
                console.error('Error extracting student data:', error);
                return null;
            }
        }

        function populateStudentModal(data) {
            try {
                // Profile header
                $('#modalProfileImage').attr('src', data.profileImage);
                $('#modalStudentName').text(data.fullName);
                $('#modalStudentId').text(data.formattedId);
                
                // Status badge
                const statusBadge = $('#modalStudentStatus');
                statusBadge.removeClass('status-active status-inactive');
                statusBadge.addClass(data.isActive ? 'status-active' : 'status-inactive');
                statusBadge.html(`<i class="fas ${data.isActive ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>${data.status}`);
                
                // Personal Information
                $('#modalFirstName').text(data.firstName || 'Not provided');
                $('#modalLastName').text(data.lastName || 'Not provided');
                $('#modalDateOfBirth').text('Not provided'); // This would need to be added to your data model
                $('#modalAge').text(data.age || 'Not provided');
                $('#modalGender').html(`<i class="fas ${getGenderIcon(data.gender)} me-1"></i>${data.gender || 'Not provided'}`);
                $('#modalBloodGroup').text('Not provided'); // This would need to be added to your data model
                
                // Contact Information
                $('#modalEmail span').text(data.email || 'Not provided');
                $('#modalPhone span').text(data.contactNumber || 'Not provided');
                $('#modalEmergencyContact span').text('Not provided'); // This would need to be added to your data model
                $('#modalAddress span').text('Not provided'); // This would need to be added to your data model
                
                // Academic Information
                $('#modalRegistrationDate span').text(`${data.joinedDate} at ${data.joinedTime}`);
                $('#modalLastUpdated span').text('Not available'); // This would need to be added to your data model
                $('#modalAccountStatus').html(`<span class="status-badge ${data.isActive ? 'status-active' : 'status-inactive'}">${data.status}</span>`);
                $('#modalFormattedId span').text(data.formattedId);
                
                // Set student ID for edit button
                $('#btnEditFromModal').data('student-id', data.studentId);
                
                // Handle empty values
                $('.detail-value').each(function() {
                    const $this = $(this);
                    const text = $this.find('span').length ? $this.find('span').text() : $this.text();
                    
                    if (!text || text.trim() === 'Not provided' || text.trim() === 'Not available') {
                        $this.addClass('empty');
                        if ($this.find('span').length) {
                            $this.find('span').text('Not provided');
                        } else if (!$this.hasClass('status-badge')) {
                            $this.text('Not provided');
                        }
                    } else {
                        $this.removeClass('empty');
                    }
                });
                
            } catch (error) {
                console.error('Error populating modal:', error);
                showErrorToast('Error displaying student details');
            }
        }

        function getGenderIcon(gender) {
            switch(gender?.toLowerCase()) {
                case 'male': return 'fa-mars text-primary';
                case 'female': return 'fa-venus text-danger';
                default: return 'fa-genderless text-info';
            }
        }

        function refreshStudentData() {
            showInfoToast('Refreshing student data...');
            setTimeout(function() {
                window.location.reload();
            }, 500);
        }

        function confirmStatusToggle(element) {
            const row = $(element).closest('tr');
            const studentName = row.find('td:eq(2) .fw-semibold').text().trim();
            const isActive = $(element).find('i').hasClass('fa-eye-slash');
            const action = isActive ? 'deactivate' : 'activate';
            const title = isActive ? 'Deactivate Student?' : 'Activate Student?';
            const text = `Are you sure you want to ${action} ${studentName}?`;

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
            const studentName = row.find('td:eq(2) .fw-semibold').text().trim();

            Swal.fire({
                title: 'Delete Student?',
                html: `
                    <div class="text-start">
                        <p class="text-danger mt-3">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            This action cannot be undone. The student record will be permanently removed.
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

        // Helper function to set active menu item (if you have a sidebar)
        function setActiveMenuItem(pageName) {
            try {
                $('.nav-link').removeClass('active');
                $(`.nav-link[href*="${pageName}"]`).addClass('active');
            } catch (error) {
                console.log('Menu activation error:', error);
            }
        }

        // Add smooth scrolling for better UX
        $(document).ready(function () {
            $('html').css('scroll-behavior', 'smooth');
        });

        // Handle responsive table on window resize
        $(window).resize(function () {
            if (studentsTable) {
                studentsTable.responsive.recalc();
            }
        });
    </script>
</asp:Content>