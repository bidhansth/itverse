<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="AssignmentPerSubject.aspx.cs" Inherits="LMS.Pages.Public.AssignmentPerSubject" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .aps-page * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        .aps-page {
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #1f2937;
            padding: 2rem 1.5in;
            align-items: flex-start;
            position: relative;
        }

        .aps-page .aps-container {
            max-width: 1200px;
            margin: auto;
            padding: 2rem 1rem;
        }

        .aps-back-button {
            position: fixed;
            top: 2rem;
            left: 2rem;
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            padding: 0.75rem 1rem;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            font-size: 1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            z-index: 1000;
        }

        .aps-back-button:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .aps-header {
            text-align: center;
            margin: 4rem 0 3rem;
            color: white;
            width: 100%;
        }

        .aps-header h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            animation: fadeInDown 0.6s ease-out;
        }

        .aps-header p {
            font-size: 1.1rem;
            opacity: 0.9;
            font-weight: 300;
            animation: fadeInDown 0.6s ease-out 0.2s both;
        }

        .aps-assignments-grid {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            width: 100%;
            align-items: center;
        }

        .aps-assignment {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 6px;
            padding: 0.75rem;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
            width: 100%;
            margin-bottom: 0.3in;
        }

        .aps-assignment::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 6px 6px 0 0;
        }

        .aps-assignment:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
            background: rgba(255, 255, 255, 1);
        }

        .aps-assignment h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .aps-deadline-container {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            padding: 0.4rem 0.6rem;
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            border-radius: 4px;
            border-left: 3px solid #667eea;
            font-size: 0.8rem;
        }

        .aps-deadline-container i {
            color: #667eea;
            font-size: 1rem;
        }

        .aps-deadline-label {
            font-weight: 600;
            color: #374151;
        }

        .aps-deadline-value {
            color: #6b7280;
            font-weight: 500;
        }

        .aps-description {
            display: flex;
            align-items: flex-start;
            gap: 0.4rem;
            margin-bottom: 0.5rem;
            padding: 0.5rem;
            background: rgba(102, 126, 234, 0.05);
            border-radius: 4px;
            border: 1px solid rgba(102, 126, 234, 0.1);
            line-height: 1.4;
            color: #4b5563;
            font-size: 0.85rem;
        }

        .aps-description i {
            color: #667eea;
            margin-top: 0.25rem;
            flex-shrink: 0;
        }

        .aps-submission-section {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            border: 1px dashed #cbd5e1;
            padding: 0.75rem;
            border-radius: 6px;
            margin-top: 0.5rem;
            transition: all 0.3s ease;
        }

        .aps-submission-section:hover {
            border-color: #667eea;
            background: linear-gradient(135deg, #f8fafc, #f3f4f6);
        }

        .aps-submission-title {
            color: #0c4a6e;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .aps-submission-title i {
            color: #667eea;
            font-size: 1rem;
        }

        .aps-file-upload-container {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .aps-file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 0.4rem 1.2rem;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            border: none;
            font-weight: 600;
            font-size: 0.85rem;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
            align-self: flex-start;
        }

        .aps-file-input-wrapper:hover {
            background: linear-gradient(135deg, #5a67d8, #6b46c1);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .aps-file-input-wrapper input[type=file] {
            position: absolute;
            left: -9999px;
            opacity: 0;
        }

        .aps-file-input-wrapper i {
            margin-right: 0.5rem;
        }

        .aps-file-info {
            padding: 0.6rem;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 4px;
            font-size: 0.8rem;
            color: #4b5563;
            border: 1px solid #d1d5db;
            transition: all 0.3s ease;
        }

        .aps-file-selected {
            color: #065f46;
            font-weight: 500;
            background: rgba(16, 185, 129, 0.1);
            border-color: #10b981;
            box-shadow: 0 2px 10px rgba(16, 185, 129, 0.1);
        }

        .aps-submit-btn {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.85rem;
            align-self: flex-start;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.3);
        }

        .aps-submit-btn:hover {
            background: linear-gradient(135deg, #059669, #047857);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
        }

        .aps-submit-btn:disabled {
            background: #9ca3af;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
            opacity: 0.6;
        }

        .aps-status-message {
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
            font-weight: 500;
            border: 1px solid;
        }

        .aps-status-success {
            background: rgba(16, 185, 129, 0.1);
            color: #065f46;
            border-color: #10b981;
            box-shadow: 0 2px 10px rgba(16, 185, 129, 0.1);
        }

        .aps-status-error {
            background: rgba(239, 68, 68, 0.1);
            color: #991b1b;
            border-color: #ef4444;
            box-shadow: 0 2px 10px rgba(239, 68, 68, 0.1);
        }

        .aps-submission-status {
            margin-top: 1rem;
            padding: 0.75rem;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .aps-submitted {
            background: rgba(16, 185, 129, 0.1);
            color: #065f46;
            border: 1px solid #10b981;
        }

        .aps-not-submitted {
            background: rgba(251, 191, 36, 0.1);
            color: #92400e;
            border: 1px solid #fbbf24;
        }

        .aps-no-assignments {
            text-align: center;
            padding: 4rem 2rem;
            color: white;
            font-size: 1.3rem;
            font-weight: 300;
        }

        .aps-no-assignments i {
            font-size: 5rem;
            margin-bottom: 1.5rem;
            opacity: 0.7;
        }

        .aps-loading {
            text-align: center;
            color: white;
            font-size: 1.3rem;
            padding: 4rem;
            font-weight: 300;
        }

        .aps-loading i {
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            animation: spin 1s linear infinite;
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        @media (max-width: 1024px) {
            .aps-container {
                max-width: 720px;
            }

            .aps-assignments-grid {
                max-width: 650px;
            }
        }

        @media (max-width: 768px) {
            .aps-page {
                padding: 1rem;
            }

            .aps-container {
                padding: 0 1rem;
                max-width: 90%;
            }

            .aps-assignments-grid {
                max-width: 100%;
                gap: 1rem;
            }

            .aps-assignment {
                padding: 1.25rem;
                border-radius: 10px;
            }

            .aps-assignment h3 {
                font-size: 1.1rem;
            }

            .aps-header {
                margin: 2rem 0;
            }

            .aps-header h2 {
                font-size: 2rem;
            }

            .aps-back-button {
                position: static;
                margin-bottom: 1rem;
                align-self: flex-start;
            }

            .aps-file-input-wrapper {
                padding: 0.875rem 1.5rem;
                font-size: 0.95rem;
            }

            .aps-submit-btn {
                padding: 0.875rem 2rem;
                font-size: 0.95rem;
            }
        }

        @media (max-width: 480px) {
            .aps-container {
                max-width: 95%;
            }

            .aps-assignment {
                padding: 1rem;
            }

            .aps-assignment h3 {
                font-size: 1.05rem;
            }

            .aps-submission-section {
                padding: 1rem;
            }

            .aps-deadline-container {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .aps-file-input-wrapper,
            .aps-submit-btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="aps-page">
        <form id="form1" runat="server" enctype="multipart/form-data">
            <div class="aps-container">
                <a href="javascript:history.back()" class="aps-back-button">
                    <i class="fas fa-arrow-left"></i>
                    Back to Courses
                </a>

                <div class="aps-header">
                    <asp:Literal ID="litCourseTitle" runat="server" />
                </div>

                <div class="aps-assignments-grid">
                    <asp:Repeater ID="rptAssignments" runat="server" OnItemDataBound="rptAssignments_ItemDataBound">
                        <ItemTemplate>
                            <div class="aps-assignment">
                                <h3><%# ((System.Data.DataRowView)Container.DataItem)["title"] %></h3>

                                <div class="aps-deadline-container">
                                    <i class="fas fa-calendar-alt"></i>
                                    <span class="aps-deadline-label">Due Date:</span>
                                    <span class="aps-deadline-value">
                                        <%# ((System.Data.DataRowView)Container.DataItem)["deadline"] != DBNull.Value ?
                                            ((DateTime)((System.Data.DataRowView)Container.DataItem)["deadline"]).ToString("MMMM dd, yyyy") :
                                            "No deadline specified" %>
                                    </span>
                                </div>

                                <div class="aps-description">
                                    <i class="fas fa-info-circle" style="color: #667eea; margin-right: 0.5rem;"></i>
                                    <%# ((System.Data.DataRowView)Container.DataItem)["description"] %>
                                </div>

                                <!-- File Submission Section -->
                                <div class="aps-submission-section">
                                    <div class="aps-submission-title">
                                        <i class="fas fa-upload"></i>
                                        Submit Assignment
                                    </div>

                                    <div class="aps-file-upload-container">
                                        <label class="aps-file-input-wrapper">
                                            <i class="fas fa-file-upload"></i> Choose File
                                            <asp:FileUpload ID="fileUpload" runat="server" />
                                        </label>

                                        <div class="aps-file-info" id="fileInfo_<%# Container.ItemIndex %>">
                                            <i class="fas fa-info-circle"></i>
                                            Supported formats: PDF, DOC, DOCX, TXT, ZIP (Max: 10MB)
                                        </div>

                                        <asp:Button ID="btnSubmit" runat="server"
                                            Text="Submit Assignment"
                                            CssClass="aps-submit-btn"
                                            CommandArgument='<%# ((System.Data.DataRowView)Container.DataItem)["id"] %>'
                                            OnCommand="btnSubmit_Command" />
                                    </div>

                                    <!-- Submission Status -->
                                    <asp:Literal ID="litSubmissionStatus" runat="server" />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </form>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const fileUploads = document.querySelectorAll('input[type="file"]');

                fileUploads.forEach(function (upload, index) {
                    upload.addEventListener('change', function (e) {
                        const fileInfo = document.getElementById('fileInfo_' + index);
                        const file = e.target.files[0];

                        if (file) {
                            const fileSize = (file.size / 1024 / 1024).toFixed(2);
                            fileInfo.innerHTML = `
                                <i class="fas fa-file"></i>
                                <strong>Selected:</strong> ${file.name} (${fileSize} MB)
                            `;
                            fileInfo.classList.add('aps-file-selected');
                            fileInfo.style.color = '';

                            if (file.size > 10 * 1024 * 1024) {
                                fileInfo.innerHTML = `
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <strong>Error:</strong> File size exceeds 10MB limit
                                `;
                                fileInfo.classList.remove('aps-file-selected');
                                fileInfo.style.color = '#dc2626';
                            }
                        } else {
                            fileInfo.innerHTML = `
                                <i class="fas fa-info-circle"></i>
                                Supported formats: PDF, DOC, DOCX, TXT, ZIP (Max: 10MB)
                            `;
                            fileInfo.classList.remove('aps-file-selected');
                            fileInfo.style.color = '';
                        }
                    });
                });
            });
        </script>
    </div>
</asp:Content>
