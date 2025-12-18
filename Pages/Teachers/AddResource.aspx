<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="AddResource.aspx.cs" Inherits="LMS.Pages.Teachers.AddResource" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <form id="form1" runat="server" >
    <div class="container mt-5">
        <div class="row">
            <div class="col-sm-5">

                <div class="mb-3">
                    <asp:Label runat="server" AssociatedControlID="txtTitle" CssClass="form-label">Title</asp:Label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" required="true"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <asp:Label runat="server" AssociatedControlID="fileUpload" CssClass="form-label">Upload File</asp:Label>
                    <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" required ="true"/>
                </div>
                <asp:Button ID="btnUpload" runat="server" Text="Upload" CssClass="btn btn-primary" OnClick="btnUpload_Click" />
                <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block text-success"></asp:Label>
            </div>
        </div>
    </div>
</form>
  
</asp:Content>
