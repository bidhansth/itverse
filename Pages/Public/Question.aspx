<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="Question.aspx.cs" Inherits="LMS.Pages.Public.Question" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <form id="form1" runat="server" >
    <div class="container mt-4">

    <!-- Question Box -->
    <div class="card mb-4">
        <div class="card-body">
            <h5 class="card-title" id="lblQuestionText" runat="server"></h5>
            <p class="card-subtitle text-muted">
                Asked by <span id="lblAskerName" runat="server"></span> on 
                <span id="lblDate" runat="server"></span>
            </p>
        </div>
    </div>

    <!-- Comment Section -->
    <h5>Comments</h5>
    <asp:Repeater ID="rptComments" runat="server">
        <ItemTemplate>
            <div class="card mb-2">
                <div class="card-body">
                    <p class="mb-1"><%# Eval("text") %></p>
                    <small class="text-muted">By <%# Eval("username")%> <%# Eval("lastname") %> on <%# Eval("created_on", "{0:yyyy-MM-dd HH:mm}") %></small>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <!-- Add Comment -->
    <div class="mt-4">
        <asp:TextBox ID="txtComment" runat="server" CssClass="form-control mb-2" TextMode="MultiLine" Rows="3" placeholder="Write a comment..."></asp:TextBox>
        <asp:Button ID="btnSubmitComment" runat="server" CssClass="btn btn-primary" Text="Post Comment" OnClick="btnSubmitComment_Click" />
    </div>

</div>
</form>
</asp:Content>

