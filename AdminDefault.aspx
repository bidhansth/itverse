<%@ Page Title="Dashboard Overview" Language="C#" MasterPageFile="~/MasterPages/AdminDashboard.Master" AutoEventWireup="true" CodeBehind="AdminDefault.aspx.cs" Inherits="LMS.AdminDefault" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <!-- Chart.js for Dashboard Charts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/chart.js/3.9.1/chart.min.js"></script>
    
    <!-- Additional CSS for Dashboard -->
    <style>
        .quick-action-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            transition: all 0.2s ease;
            cursor: pointer;
            text-align: center;
        }

        .quick-action-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .quick-action-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: white;
            margin: 0 auto 1rem;
        }

        .chart-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            height: 100%;
        }

        .chart-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 1rem;
        }

        .recent-activity-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid #f1f5f9;
            transition: all 0.2s ease;
        }

        .recent-activity-item:hover {
            background: #f8fafc;
        }

        .recent-activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            color: white;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .activity-content h6 {
            margin: 0;
            font-size: 0.9rem;
            color: #1e293b;
            font-weight: 600;
        }

        .activity-content p {
            margin: 0;
            font-size: 0.8rem;
            color: #64748b;
        }

        .activity-time {
            margin-left: auto;
            font-size: 0.8rem;
            color: #94a3b8;
            flex-shrink: 0;
        }

        .performance-metric {
            text-align: center;
            padding: 1rem;
        }

        .metric-value {
            font-size: 2rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 0.25rem;
        }

        .metric-label {
            font-size: 0.9rem;
            color: #64748b;
            margin-bottom: 0.5rem;
        }

        .metric-change {
            font-size: 0.8rem;
            font-weight: 600;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
        }

        .metric-change.positive {
            color: #059669;
            background: #d1fae5;
        }

        .metric-change.negative {
            color: #dc2626;
            background: #fee2e2;
        }

        .top-courses-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid #f1f5f9;
        }

        .top-courses-item:last-child {
            border-bottom: none;
        }

        .course-thumbnail {
            width: 50px;
            height: 40px;
            border-radius: 8px;
            object-fit: cover;
            margin-right: 1rem;
        }

        .course-info h6 {
            margin: 0;
            font-size: 0.9rem;
            color: #1e293b;
            font-weight: 600;
        }

        .course-info p {
            margin: 0;
            font-size: 0.8rem;
            color: #64748b;
        }

        .course-stats {
            margin-left: auto;
            text-align: right;
        }

        .course-revenue {
            font-size: 0.9rem;
            font-weight: 600;
            color: #059669;
        }

        .course-enrollments {
            font-size: 0.8rem;
            color: #64748b;
        }

        @media (max-width: 768px) {
            .chart-card {
                margin-bottom: 1rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    Dashboard Overview
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Dashboard Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="page-title">Dashboard Overview</h1>
            <p class="page-subtitle">Welcome back! Here's what's happening in your LMS today.</p>
        </div>
        <div class="d-flex gap-2"> 
            <div class="dropdown">
              <button class="btn btn-primary dropdown-toggle me-2" type="button" data-bs-toggle="dropdown">
                <i class="fas fa-plus me-2"></i>Add New
            </button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href='<%= ResolveUrl("~/UserManagement/StudentManagement/AddStudent.aspx") %>'>Student</a></li>
                    <li><a class="dropdown-item" href='<%= ResolveUrl("~/UserManagement/TeacherManagement/AddTeacher.aspx") %>'>Teacher</a></li>
                    <li><a class="dropdown-item" href='<%= ResolveUrl("~/UserManagement/AdminManagement/AddAdmin.aspx") %>'>Admin</a></li>
                    <li><a class="dropdown-item" href='<%= ResolveUrl("~/CourseManagement/AddCourse.aspx") %>'>Course</a></li>
                </ul>
            </div>
             <button type="button" class="btn btn-secondary me-2" onclick="refreshDashboard()">
                    <i class="fas fa-sync-alt"></i>Refresh
             </button>
        </div>
    </div>
    
    <!-- Stats Cards -->
    <div class="row g-4 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="stats-card">
                <div class="stats-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stats-number">
                    <asp:Label ID="lblTotalStudents" runat="server" Text="2,847"></asp:Label>
                </div>
                <div class="stats-label">Total Students</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stats-card">
                <div class="stats-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <div class="stats-number">
                    <asp:Label ID="lblActiveTeachers" runat="server" Text="142"></asp:Label>
                </div>
                <div class="stats-label">Active Teachers</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stats-card">
                <div class="stats-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                    <i class="fas fa-book-open"></i>
                </div>
                <div class="stats-number">
                    <asp:Label ID="lblActiveCourses" runat="server" Text="89"></asp:Label>
                </div>
                <div class="stats-label">Active Courses</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stats-card">
                <div class="stats-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                    <i class="fas fa-user-plus"></i>
                </div>
                <div class="stats-number">
                    <asp:Label ID="lblMonthlyRevenue" runat="server" Text="$24,891"></asp:Label>
                </div>
                <div class="stats-label">Total Enrollments</div>
            </div>
        </div>
    </div>

    <!-- Quick Actions & Activity -->
    <div class="row g-4 mb-4">
        <div class="col-xl-4">
            <div class="chart-card">
                <h5 class="chart-title mb-3">Quick Actions</h5>
                <div class="row g-3">
                    <div class="col-6">
                        <div class="quick-action-card" onclick="location.href='<%= ResolveUrl("~/UserManagement/StudentManagement/AddStudent.aspx") %>'">
                            <div class="quick-action-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <h6>Add Student</h6>
                            <p class="text-muted mb-0">Register new student</p>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="quick-action-card" onclick="location.href='<%= ResolveUrl("~/UserManagement/TeacherManagement/AddTeacher.aspx") %>'">
                            <div class="quick-action-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                                <i class="fas fa-chalkboard-teacher"></i>
                            </div>
                            <h6>Add Teacher</h6>
                            <p class="text-muted mb-0">Register new teacher</p>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="quick-action-card" onclick="location.href='<%= ResolveUrl("~/UserManagement/AdminManagement/AddAdmin.aspx") %>'">
                            <div class="quick-action-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                                <i class="fas fa-user-shield"></i>
                            </div>
                            <h6>Add Admin</h6>
                            <p class="text-muted mb-0">Register new admin</p>
                        </div>
                    </div>
                   <div class="col-6">
                        <div class="quick-action-card" onclick="location.href='<%= ResolveUrl("~/CourseManagement/AddCourse.aspx") %>'">
                            <div class="quick-action-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                                <i class="fas fa-book"></i>
                            </div>
                            <h6>Add Course</h6>
                            <p class="text-muted mb-0">Create new course</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-8">
            <div class="chart-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="chart-title"> Recent Courses</h5>
                    <a href="Courses.aspx" class="btn btn-sm btn-outline-primary">View All</a>
                </div>
                <div class="top-courses">
                    <div class="top-courses-item">
                        <img src="https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=100&h=80&fit=crop&auto=format&q=80" 
                             alt="Course" class="course-thumbnail">
                        <div class="course-info">
                            <h6>Advanced Web Development</h6>
                            <p>JavaScript, React, Node.js</p>
                        </div>
                        <div class="course-stats">
                            <div class="course-revenue">$4,299</div>
                            <div class="course-enrollments">143 students</div>
                        </div>
                    </div>
                    <div class="top-courses-item">
                        <img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=100&h=80&fit=crop&auto=format&q=80" 
                             alt="Course" class="course-thumbnail">
                        <div class="course-info">
                            <h6>Data Science Fundamentals</h6>
                            <p>Python, Machine Learning</p>
                        </div>
                        <div class="course-stats">
                            <div class="course-revenue">$3,890</div>
                            <div class="course-enrollments">98 students</div>
                        </div>
                    </div>
                    <div class="top-courses-item">
                        <img src="https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=100&h=80&fit=crop&auto=format&q=80" 
                             alt="Course" class="course-thumbnail">
                        <div class="course-info">
                            <h6>Mobile App Development</h6>
                            <p>React Native, Flutter</p>
                        </div>
                        <div class="course-stats">
                            <div class="course-revenue">$3,245</div>
                            <div class="course-enrollments">87 students</div>
                        </div>
                    </div>
                    <div class="top-courses-item">
                        <img src="https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=100&h=80&fit=crop&auto=format&q=80" 
                             alt="Course" class="course-thumbnail">
                        <div class="course-info">
                            <h6>Digital Marketing Mastery</h6>
                            <p>SEO, Social Media, Analytics</p>
                        </div>
                        <div class="course-stats">
                            <div class="course-revenue">$2,890</div>
                            <div class="course-enrollments">156 students</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        // Refresh dashboard data
        function refreshDashboard() {
            showInfoToast('Refreshing dashboard data...');
            setTimeout(function () {
                window.location.reload();
            }, 500);
        }
    </script>
</asp:Content>