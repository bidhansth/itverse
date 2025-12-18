using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Pages.Public
{
    public partial class Chat : System.Web.UI.Page
    {
        private int userId;
        private int teacherId;
        private int chatId
        {
            get
            {
                return ViewState["chatId"] != null ? (int)ViewState["chatId"] : 0;
            }
            set
            {
                ViewState["chatId"] = value;
            }
        }
        private string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        private int senderId;
        private string senderType;
        private int receiverId;
        private string receiverType;

        protected void Page_Load(object sender, EventArgs e)
        {
            //set session id for testing purposes
            Session["student_id"] = 1;

            if (Session["student_id"] == null && Session["teacher_id"] == null)
            {
                Response.Redirect("Error.aspx"); // No login
                return;
            }

            bool isUser = Session["student_id"] != null;
            senderId = isUser ? Convert.ToInt32(Session["student_id"]) : Convert.ToInt32(Session["teacher_id"]);
            senderType = isUser ? "student" : "teacher";

            // Determine receiver
            if (isUser && Request.QueryString["id"] != null)
            {
                receiverId = Convert.ToInt32(Request.QueryString["id"]);
                receiverType = "teacher";
            }
            else if (!isUser && Request.QueryString["id"] != null)
            {
                receiverId = Convert.ToInt32(Request.QueryString["id"]);
                receiverType = "student";
            }
            else
            {
                Response.Redirect("Error.aspx");
                return;
            }

            if (!IsPostBack)
            {
                EnsureChatExists();
                LoadMessages();
            }


        }
        private void EnsureChatExists()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string selectQuery = @"
                SELECT id FROM chats 
                WHERE student_id = @uid AND teacher_id = @tid";

                SqlCommand selectCmd = new SqlCommand(selectQuery, conn);
                selectCmd.Parameters.AddWithValue("@uid", senderType == "student" ? senderId : receiverId);
                selectCmd.Parameters.AddWithValue("@tid", senderType == "teacher" ? senderId : receiverId);

                var result = selectCmd.ExecuteScalar();
                if (result != null)
                {
                    chatId = Convert.ToInt32(result);
                }
                else
                {
                    string insertQuery = @"
                INSERT INTO chats (student_id, teacher_id) 
                OUTPUT INSERTED.id 
                VALUES (@uid, @tid)";

                    SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                    insertCmd.Parameters.AddWithValue("@uid", senderType == "student" ? senderId : receiverId);
                    insertCmd.Parameters.AddWithValue("@tid", senderType == "teacher" ? senderId : receiverId);
                    chatId = Convert.ToInt32(insertCmd.ExecuteScalar());
                }
            }
        }

        private void LoadMessages()
        {
            StringBuilder sb = new StringBuilder();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                                SELECT 
                                    m.text,
                                    m.sender_type,
                                    m.sender_id,
                                    m.created_on,
                                    u.firstname AS user_name,
                                    t.firstname AS teacher_name
                                FROM messages m
                                LEFT JOIN students u ON m.sender_type = 'student' AND m.sender_id = u.studentid
                                LEFT JOIN teachers t ON m.sender_type = 'teacher' AND m.sender_id = t.teacherid
                                WHERE m.chat_id = @chatId
                                ORDER BY m.created_on ASC";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@chatId", chatId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string text = reader["text"].ToString();
                    string type = reader["sender_type"].ToString();
                    int sid = Convert.ToInt32(reader["sender_id"]);

                    bool isCurrentUser = (type == senderType && sid == senderId);

                    string senderName;
                    if (isCurrentUser)
                    {
                        senderName = "You";
                    }
                    else if (type == "student")
                    {
                        senderName = reader["user_name"].ToString();
                    }
                    else
                    {
                        senderName = reader["teacher_name"].ToString();
                    }

                    string time = Convert.ToDateTime(reader["created_on"]).ToString("g");

                    string cardClass = isCurrentUser ? "bg-primary text-white ms-auto" : "bg-light";
                    string textAlign = isCurrentUser ? "text-end" : "text-start";
                    string alignWrapper = isCurrentUser ? "d-flex justify-content-end" : "d-flex justify-content-start";
                    sb.Append($@"
                                <div class='{alignWrapper} mb-2'>
                                    <div class='card {cardClass}' style='max-width: 75%;'>
                                        <div class='card-body {textAlign}'>
                                            <h6 class='card-subtitle mb-1 small'>{senderName} <small class='float-end'>{time}</small></h6>
                                            <p class='card-text mb-0'>{Server.HtmlEncode(text)}</p>
                                        </div>
                                    </div>
                                </div>");
                }
            }

            ltMessages.Text = sb.ToString();

        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            string msg = txtMessage.Text.Trim();
            if (string.IsNullOrEmpty(msg)) return;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO messages (text, sender_id, sender_type, chat_id) VALUES (@text, @sid, @stype, @cid)";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@text", msg);
                cmd.Parameters.AddWithValue("@sid", senderId);
                cmd.Parameters.AddWithValue("@stype", senderType);
                cmd.Parameters.AddWithValue("@cid", chatId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            txtMessage.Text = "";
            LoadMessages();
        }
    }
}
