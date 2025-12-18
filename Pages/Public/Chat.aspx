<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="Chat.aspx.cs" Inherits="LMS.Pages.Public.Chat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <form id="form1" runat="server" >
    <div class="container py-5">
            <h3 class="mb-4">Chat</h3>

            <asp:Literal ID="ltMessages" runat="server" />
            
            <div class="mt-4">
                <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Type a message..."></asp:TextBox>
                <asp:Button ID="btnSend" runat="server" Text="Send" CssClass="btn btn-primary mt-2" OnClick="btnSend_Click" />
            </div>
        </div>
        </form>
</asp:Content>