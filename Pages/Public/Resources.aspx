<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/Public.Master" CodeBehind="Resources.aspx.cs" Inherits="LMS.Pages.Public.Resources" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
    .custom-gridview-title-header {
        font-size: 1.5em;
        font-weight: bold;
    }
    .resource-title {
        font-size: 1.3em;
        font-weight: bold;
        padding: 12px;
        margin: 8px 0;
    }
    .resource-gridview{
        padding: 12px;
        margin: 8px 0;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <form id="form1" runat="server" >
    <header class="bg-dark py-5">
        <div class="container px-4 px-lg-5 my-5">
            <div class="text-center text-white">
                <h1 class="display-4 fw-bolder" id="courseTitle" runat="server">Resources</h1>
            </div>
        </div>
    </header>
    <div class="container mt-5">
        <div class="row">
            <div class="col" id="resources" runat="server">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnRowCommand="GridView1_RowCommand" CssClass="resource-gridview" ShowHeader="false">
                    <Columns>
                        <asp:BoundField DataField="id" />
                        <asp:BoundField DataField="title" ItemStyle-CssClass="resource-title"/>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:Button 
                                    ID="btnDownload" 
                                    runat="server" 
                                    Text="Download"
                                    CommandName="DownloadFile"
                                    CommandArgument='<%# Container.DataItemIndex %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div class="row">
            <div class="col" id="assignments" runat="server">

            </div>
        </div>
        <div class="row">
            <div class="col" id="forum" runat="server">

            </div>
        </div>
    </div>
    </form>
</asp:Content>
