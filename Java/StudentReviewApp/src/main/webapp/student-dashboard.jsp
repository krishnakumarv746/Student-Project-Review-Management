<%@ page import="com.studentreview.dao.ProjectDAO, com.studentreview.model.Project, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("username") == null || !"STUDENT".equals(session.getAttribute("role"))) {
        response.sendRedirect("student-login.jsp");
        return;
    }
    int studentId = (Integer) session.getAttribute("userId");
    ProjectDAO dao = new ProjectDAO();

    String keyword = request.getParameter("keyword");
    String statusFilter = request.getParameter("status");

    List<Project> projects;
    if ((keyword != null && !keyword.trim().isEmpty())
            || (statusFilter != null && !statusFilter.trim().isEmpty())) {
        projects = dao.searchProjects(studentId, "STUDENT", keyword, statusFilter);
    } else {
        projects = dao.getProjectsByStudent(studentId);
    }

    Map<String, Integer> stats = dao.getStats(studentId, "STUDENT");
    int unread = dao.getUnreadCount(studentId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Welcome, <%= session.getAttribute("username") %>
                <span style="font-size:14px; color:#64748b; font-weight:400;">(ID: <%= studentId %>)</span>
            </h2>
            <div style="display:flex; gap:10px; align-items:center;">
                <a href="notifications" class="btn" style="position:relative;">
                    🔔 Notifications
                    <% if(unread > 0) { %>
                        <span style="background:#ef4444; color:#fff; font-size:10px; padding:2px 6px; border-radius:10px; margin-left:5px;"><%= unread %></span>
                    <% } %>
                </a>
                <a href="student-login.jsp" class="btn error">Logout</a>
            </div>
        </div>

        <div style="display:grid; grid-template-columns:repeat(4, 1fr); gap:15px; margin-bottom:25px;">
            <div style="background:#eff6ff; padding:15px; border-radius:8px; border-left:4px solid #3b82f6;">
                <div style="font-size:12px; color:#64748b;">TOTAL</div>
                <div style="font-size:24px; font-weight:700; color:#1e40af;"><%= stats.get("total") %></div>
            </div>
            <div style="background:#fef3c7; padding:15px; border-radius:8px; border-left:4px solid #f59e0b;">
                <div style="font-size:12px; color:#64748b;">PENDING</div>
                <div style="font-size:24px; font-weight:700; color:#92400e;"><%= stats.get("assigned") + stats.get("underReview") %></div>
            </div>
            <div style="background:#dcfce7; padding:15px; border-radius:8px; border-left:4px solid #16a34a;">
                <div style="font-size:12px; color:#64748b;">COMPLETED</div>
                <div style="font-size:24px; font-weight:700; color:#166534;"><%= stats.get("completed") %></div>
            </div>
            <div style="background:#fee2e2; padding:15px; border-radius:8px; border-left:4px solid #ef4444;">
                <div style="font-size:12px; color:#64748b;">REJECTED</div>
                <div style="font-size:24px; font-weight:700; color:#991b1b;"><%= stats.get("rejected") %></div>
            </div>
        </div>

        <% if(request.getParameter("success") != null) { %>
            <p class="success"><%= request.getParameter("success") %></p>
        <% } %>

        <form method="get" style="display:flex; gap:10px; margin-bottom:20px;">
            <input type="text" name="keyword" placeholder="Search..."
                   value="<%= keyword != null ? keyword : "" %>" style="flex:2; padding:8px;">
            <select name="status" style="flex:1; padding:8px;">
                <option value="">All Status</option>
                <option value="ASSIGNED" <%= "ASSIGNED".equals(statusFilter)?"selected":"" %>>Assigned</option>
                <option value="UNDER_REVIEW" <%= "UNDER_REVIEW".equals(statusFilter)?"selected":"" %>>Under Review</option>
                <option value="COMPLETED" <%= "COMPLETED".equals(statusFilter)?"selected":"" %>>Completed</option>
                <option value="REJECTED" <%= "REJECTED".equals(statusFilter)?"selected":"" %>>Rejected</option>
            </select>
            <button type="submit" class="btn">Search</button>
            <a href="student-dashboard.jsp" class="btn secondary">Clear</a>
        </form>

        <h3>Your Projects (<%= projects.size() %>)</h3>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Status</th>
                    <th>Grade</th>
                    <th>Due Date</th>
                    <th>File</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if(projects.isEmpty()) { %>
                    <tr><td colspan="7" style="text-align:center; color:#888;">No projects found.</td></tr>
                <% } %>
                <% for(Project p : projects) { %>
                <tr>
                    <td><%= p.getId() %></td>
                    <td><strong><%= p.getTitle() %></strong></td>
                    <td><span class="status-badge"><%= p.getStatus() %></span></td>
                    <td><%= p.getGrade() == null ? "Pending" : p.getGrade() %></td>
                    <td>
                        <%= p.getDueDate() == null ? "-" : p.getDueDate().toString() %>
                        <% if(p.isOverdue()) { %>
                            <span style="color:#ef4444; font-size:11px; font-weight:700;">OVERDUE</span>
                        <% } %>
                    </td>
                    <td>
                        <% if(p.getProjectFile() != null && !p.getProjectFile().isEmpty()) { %>
                            <a href="<%= p.getProjectFile() %>" target="_blank" class="btn text-btn" style="background:#16a34a;">View</a>
                        <% } else { %>
                            <span style="color:#94a3b8; font-size:12px;">None</span>
                        <% } %>
                    </td>
                    <td><a href="feedback.jsp?id=<%= p.getId() %>" class="btn text-btn">Details</a></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>