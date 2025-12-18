<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="Ask.aspx.cs" Inherits="LMS.Pages.Public.Ask" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5">
        <div class="row">
            <div class="col-sm-6">
                <h3>Ask a Question</h3>
                <div class="mb-3">
                    <asp:TextBox ID="txtQuestion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Enter your question..."></asp:TextBox>
                </div>
                <asp:Button ID="btnSubmit" runat="server" Text="Submit Question" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
                <br />
                <br />
                <asp:Label ID="lblStatus" runat="server" ForeColor="Red"></asp:Label>
            </div>
        </div>
    </div>
</asp:Content>
