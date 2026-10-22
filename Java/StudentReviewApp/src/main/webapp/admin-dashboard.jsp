<%@ page import="java.sql.*, com.studentreview.dao.DBConnection" %>
<%
    if (session.getAttribute("username") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Console</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Admin Console: Welcome, <%= session.getAttribute("username") %></h2>
            <a href="admin-login.jsp" class="btn error">Logout</a>
        </div>
        <% if(request.getParameter("success") != null) { %>
            <p style="color:#2ed573; font-weight:bold; margin-bottom:15px;"><%= request.getParameter("success") %></p>
        <% } %>
        <% if(request.getParameter("error") != null) { %>
            <p class="error"><%= request.getParameter("error") %></p>
        <% } %>
        <h3>Registered Users</h3>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String query = "SELECT id, username, role FROM users WHERE role != 'ADMIN'";
                    try (Connection conn = DBConnection.getConnection();
                         PreparedStatement ps = conn.prepareStatement(query);
                         ResultSet rs = ps.executeQuery()) {
                        while(rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><strong><%= rs.getString("username") %></strong></td>
                    <td><span class="status-badge"><%= rs.getString("role") %></span></td>
                    <td>
                        <a href="deleteUser?id=<%= rs.getInt("id") %>" class="btn error text-btn"
                           onclick="return confirm('Delete this user?')">Delete</a>
                    </td>
                </tr>
                <%      }
                    } catch(Exception e) { e.printStackTrace(); }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>