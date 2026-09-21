<%@ page import="com.studentreview.dao.ProjectDAO, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("student-login.jsp");
        return;
    }
    String role = (String) session.getAttribute("role");
    int userId = (Integer) session.getAttribute("userId");
    ProjectDAO dao = new ProjectDAO();
    List<Map<String, Object>> list = dao.getNotifications(userId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Notifications</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>🔔 Notifications</h2>
            <% String backDash = "STUDENT".equals(role) ? "student-dashboard.jsp" : "trainer-dashboard.jsp"; %>
            <a href="<%= backDash %>" class="btn secondary">Back to Dashboard</a>
        </div>

        <% if(list.isEmpty()) { %>
            <p style="text-align:center; color:#888; padding:30px;">
                No notifications yet.
            </p>
        <% } else { %>
            <% for(Map<String, Object> n : list) { %>
                <div style="background:<%= (Boolean)n.get("isRead") ? "#f8fafc" : "#eff6ff" %>;
                            padding:15px; border-radius:8px; margin-bottom:10px;
                            border-left:4px solid <%= (Boolean)n.get("isRead") ? "#cbd5e1" : "#3b82f6" %>;">
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                        <strong style="color:#0f172a;"><%= n.get("title") %></strong>
                        <span style="font-size:11px; color:#94a3b8;"><%= n.get("createdAt") %></span>
                    </div>
                    <p style="margin-top:5px; color:#475569; font-size:14px;"><%= n.get("message") %></p>
                </div>
            <% } %>
        <% } %>
    </div>
</body>
</html>