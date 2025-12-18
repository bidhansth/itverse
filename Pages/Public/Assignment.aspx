<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="Assignment.aspx.cs" Inherits="LMS.Pages.Public.Assignment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <style>
    .assignment-page * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    .assignment-page {
      font-family: 'Inter', sans-serif;
      background: linear-gradient(135deg, #667eea, #764ba2);
      min-height: 100vh;
      color: #333;
      line-height: 1.5;
      position: relative;
    }

    .assignment-page .asg-container {
      max-width: 700px;
      margin: 0 auto;
      padding: 2rem 2rem;
      animation: fadeInUp 0.6s ease-out;
    }

    .assignment-page .asg-header {
      text-align: center;
      margin-bottom: 2rem;
      animation: fadeInDown 0.6s ease-out;
    }

    .assignment-page .asg-header h1 {
      color: #fff;
      font-size: 2rem;
      font-weight: 700;
      text-shadow: 0 1px 3px rgba(0,0,0,0.3);
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.75rem;
    }

    .assignment-page .asg-header h1::before {
      content: '\f15b';
      font-family: 'Font Awesome 6 Free';
      font-weight: 900;
      font-size: 1.5rem;
    }

    .assignment-page .asg-header p {
      color: #fefefe;
      font-size: 0.95rem;
      font-weight: 300;
    }

    .assignment-page .asg-header::after {
      content: '';
      width: 80px;
      height: 3px;
      background: linear-gradient(90deg, #ff6b6b, #ffd93d);
      margin: 1rem auto;
      border-radius: 1.5px;
      display: block;
    }

    .assignment-page .asg-form-card {
      background: white;
      border-radius: 14px;
      padding: 2rem 1.5rem;
      box-shadow: 0 10px 30px rgba(0,0,0,0.1);
      position: relative;
      overflow: hidden;
      border: 1px solid rgba(255,255,255,0.2);
    }

    .assignment-page .asg-form-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, #667eea, #764ba2, #667eea);
      animation: gradientMove 3s infinite;
    }

    .assignment-page .asg-message-container {
      margin-bottom: 1.5rem;
      min-height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .assignment-page .success-message,
    .assignment-page .error-message {
      padding: 0.8rem 1.2rem;
      border-radius: 10px;
      font-size: 0.95rem;
      font-weight: 500;
      display: flex;
      align-items: center;
      gap: 0.5rem;
      animation: slideInScale 0.4s ease-out;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .assignment-page .success-message {
      background: linear-gradient(135deg, #dcfce7, #bbf7d0);
      color: #166534;
      border: 1px solid #86efac;
    }

    .assignment-page .error-message {
      background: linear-gradient(135deg, #fef2f2, #fecaca);
      color: #dc2626;
      border: 1px solid #f87171;
    }

    .assignment-page .asg-form-group {
      margin-bottom: 1.5rem;
    }

    .assignment-page .asg-form-group label {
      font-weight: 600;
      font-size: 0.95rem;
      color: #374151;
      margin-bottom: 0.5rem;
      display: flex;
      gap: 0.4rem;
      align-items: center;
    }

    .assignment-page .asg-form-group label i {
      color: #667eea;
    }

    .assignment-page .asg-form-control {
      width: 100%;
      padding: 0.75rem 1rem;
      border: 2px solid #e5e7eb;
      border-radius: 10px;
      font-size: 0.95rem;
      background: #f9fafb;
      transition: 0.3s ease;
    }

    .assignment-page .asg-form-control:focus {
      outline: none;
      border-color: #667eea;
      background: white;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .assignment-page .asg-form-control[type="date"]::-webkit-calendar-picker-indicator {
      opacity: 0.7;
      cursor: pointer;
    }

    .assignment-page textarea.asg-form-control {
      resize: vertical;
      min-height: 100px;
    }

    .assignment-page select.asg-form-control {
      appearance: none;
      padding-right: 2.5rem;
      background-image: url("data:image/svg+xml,%3csvg fill='none' stroke='gray' stroke-width='2' viewBox='0 0 24 24'%3e%3cpath d='M6 9l6 6 6-6'/%3e%3c/svg%3e");
      background-repeat: no-repeat;
      background-position: right 1rem center;
      background-size: 1rem;
    }

    .assignment-page .asg-btn-container {
      text-align: center;
      margin-top: 2rem;
    }

    .assignment-page .asg-btn-primary {
      background: linear-gradient(135deg, #667eea, #764ba2);
      color: white;
      padding: 0.75rem 2rem;
      border: none;
      border-radius: 10px;
      font-size: 0.95rem;
      font-weight: 600;
      cursor: pointer;
      box-shadow: 0 6px 18px rgba(102,126,234,0.2);
      transition: 0.3s ease;
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      letter-spacing: 0.3px;
    }

    .assignment-page .asg-btn-primary::before {
      content: '\f067';
      font-family: 'Font Awesome 6 Free';
      font-weight: 900;
    }

    .assignment-page .asg-btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
    }

    .assignment-page .asg-back-button {
      position: fixed;
      top: 1rem;
      left: 1rem;
      background: rgba(255,255,255,0.15);
      color: white;
      border: none;
      padding: 0.6rem 0.9rem;
      border-radius: 8px;
      cursor: pointer;
      backdrop-filter: blur(8px);
      font-size: 0.9rem;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 0.4rem;
      z-index: 1000;
      transition: 0.3s ease;
    }

    .assignment-page .asg-back-button:hover {
      background: rgba(255,255,255,0.25);
    }

    .assignment-page .asg-floating-elements {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      pointer-events: none;
      z-index: -1;
      overflow: hidden;
    }

    .assignment-page .asg-floating-element {
      position: absolute;
      background: rgba(255,255,255,0.08);
      border-radius: 50%;
      animation: float 16s infinite linear;
    }

    .assignment-page .asg-floating-element:nth-child(1) { width: 60px; height: 60px; top: 20%; left: 10%; }
    .assignment-page .asg-floating-element:nth-child(2) { width: 100px; height: 100px; top: 60%; right: 10%; }
    .assignment-page .asg-floating-element:nth-child(3) { width: 50px; height: 50px; top: 80%; left: 25%; }
    .assignment-page .asg-floating-element:nth-child(4) { width: 90px; height: 90px; top: 10%; right: 25%; }

    @keyframes gradientMove {
      0%, 100% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
    }

    @keyframes float {
      0% { transform: translateY(0) rotate(0); opacity: 1; }
      50% { transform: translateY(-15px) rotate(180deg); opacity: 0.5; }
      100% { transform: translateY(0) rotate(360deg); opacity: 1; }
    }

    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes fadeInDown {
      from { opacity: 0; transform: translateY(-20px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes slideInScale {
      from { opacity: 0; transform: scale(0.95) translateY(-8px); }
      to { opacity: 1; transform: scale(1) translateY(0); }
    }

    .assignment-page textarea::-webkit-scrollbar {
      width: 6px;
    }
    .assignment-page textarea::-webkit-scrollbar-track {
      background: #f1f5f9;
    }
    .assignment-page textarea::-webkit-scrollbar-thumb {
      background: #cbd5e1;
      border-radius: 3px;
    }
    .assignment-page textarea::-webkit-scrollbar-thumb:hover {
      background: #94a3b8;
    }

    .assignment-page ::placeholder {
      color: #9ca3af;
      opacity: 1;
    }

    @media (max-width: 768px) {
      .assignment-page .asg-container { padding: 1.5rem 1rem; }
      .assignment-page .asg-form-card { padding: 1.5rem; }
      .assignment-page .asg-header h1 { font-size: 1.5rem; flex-direction: column; }
      .assignment-page .asg-btn-primary { padding: 0.75rem 1.5rem; font-size: 0.9rem; }
      .assignment-page .asg-back-button { position: static; margin-bottom: 1rem; }
    }
  </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="assignment-page">
    <div class="asg-floating-elements">
      <div class="asg-floating-element"></div>
      <div class="asg-floating-element"></div>
      <div class="asg-floating-element"></div>
      <div class="asg-floating-element"></div>
    </div>

    <form id="form2" runat="server">
      <div class="asg-container">
        <a href="javascript:history.back()" class="asg-back-button">
          <i class="fas fa-arrow-left"></i>
          Back
        </a>

        <div class="asg-header">
          <h1>Create New Assignment</h1>
          <p>Design and schedule assignments for your courses</p>
        </div>

        <div class="asg-form-card">
          <div class="asg-message-container">
            <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>
          </div>

          <div class="asg-form-group">
            <label for="txtTitle">
              <i class="fas fa-heading"></i>
              Assignment Title
            </label>
            <asp:TextBox ID="txtTitle" runat="server"
                         Placeholder="Enter assignment title..."
                         CssClass="asg-form-control"
                         MaxLength="200" />
          </div>

          <div class="asg-form-group">
            <label for="txtDescription">
              <i class="fas fa-align-left"></i>
              Description
            </label>
            <asp:TextBox ID="txtDescription" runat="server"
                         TextMode="MultiLine"
                         Rows="5"
                         Placeholder="Provide detailed instructions and requirements for this assignment..."
                         CssClass="asg-form-control" />
          </div>

          <div class="asg-form-group">
            <label for="txtDeadline">
              <i class="fas fa-calendar-alt"></i>
              Deadline
            </label>
            <asp:TextBox ID="txtDeadline" runat="server"
                         TextMode="Date"
                         CssClass="asg-form-control" />
          </div>

          <div class="asg-form-group">
            <label for="ddlCourse">
              <i class="fas fa-book"></i>
              Select Course
            </label>
            <asp:DropDownList ID="ddlCourse" runat="server" CssClass="asg-form-control" />
          </div>

          <div class="asg-btn-container">
            <asp:Button ID="btnInsert" runat="server"
                        Text="Create Assignment"
                        OnClick="btnInsert_Click"
                        CssClass="asg-btn-primary" />
          </div>
        </div>
      </div>
    </form>
  </div>

  <script>
      function styleMessage() {
          var messageLabel = document.querySelector('[id$="lblMessage"]');
          if (messageLabel && messageLabel.innerText.trim() !== '') {
              var messageText = messageLabel.innerText.toLowerCase();
              if (messageText.includes('success') || messageText.includes('inserted')) {
                  messageLabel.className = 'success-message';
                  messageLabel.innerHTML = '<i class="fas fa-check-circle"></i> ' + messageLabel.innerText;
              } else if (messageText.includes('failed') || messageText.includes('error')) {
                  messageLabel.className = 'error-message';
                  messageLabel.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + messageLabel.innerText;
              }
          }
      }

      window.onload = function () {
          styleMessage();

          var deadlineInput = document.querySelector('input[type="date"]');
          if (deadlineInput) {
              var today = new Date().toISOString().split('T')[0];
              deadlineInput.min = today;
          }
      };

      var prm = Sys.WebForms.PageRequestManager.getInstance();
      if (prm) {
          prm.add_endRequest(function () {
              styleMessage();
          });
      }
  </script>
</asp:Content>
