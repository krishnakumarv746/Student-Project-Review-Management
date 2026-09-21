<%@ page import="com.studentreview.dao.ProjectDAO, com.studentreview.model.Project, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("username") == null || !"TRAINER".equals(session.getAttribute("role"))) {
        response.sendRedirect("trainer-login.jsp");
        return;
    }
    int trainerId = (Integer) session.getAttribute("userId");
    ProjectDAO dao = new ProjectDAO();

    String keyword = request.getParameter("keyword");
    String statusFilter = request.getParameter("status");

    List<Project> projects;
    if ((keyword != null && !keyword.trim().isEmpty())
            || (statusFilter != null && !statusFilter.trim().isEmpty())) {
        projects = dao.searchProjects(trainerId, "TRAINER", keyword, statusFilter);
    } else {
        projects = dao.getProjectsByTrainer(trainerId);
    }

    Map<String, Integer> stats = dao.getStats(trainerId, "TRAINER");
    int unread = dao.getUnreadCount(trainerId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Trainer Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Welcome, <%= session.getAttribute("username") %></h2>
            <div style="display:flex; gap:10px; align-items:center;">
                <a href="notifications" class="btn" style="position:relative;">
                    🔔 Notifications
                    <% if(unread > 0) { %>
                        <span style="background:#ef4444; color:#fff; font-size:10px; padding:2px 6px; border-radius:10px; margin-left:5px;"><%= unread %></span>
                    <% } %>
                </a>
                <a href="trainer-login.jsp" class="btn error">Logout</a>
            </div>
        </div>

        <div style="margin-bottom:25px;">
            <a href="assign-project.jsp" class="btn">+ Assign New Project</a>
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
        <% if(request.getParameter("error") != null) { %>
            <p class="error"><%= request.getParameter("error") %></p>
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
            <a href="trainer-dashboard.jsp" class="btn secondary">Clear</a>
        </form>

        <h3>Assigned Projects (<%= projects.size() %>)</h3>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Student</th>
                    <th>Status</th>
                    <th>Due</th>
                    <th>Reply</th>
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
                    <td><%= p.getStudentName() %></td>
                    <td><span class="status-badge"><%= p.getStatus() %></span></td>
                    <td>
                        <%= p.getDueDate() == null ? "-" : p.getDueDate().toString() %>
                        <% if(p.isOverdue()) { %>
                            <span style="color:#ef4444; font-size:11px; font-weight:700;">OVERDUE</span>
                        <% } %>
                    </td>
                    <td>
                        <% if (p.getStudentReply() == null || p.getStudentReply().trim().isEmpty()) { %>
                            <span style="color:#94a3b8; font-size:12px;">No</span>
                        <% } else { %>
                            <span style="color:#16a34a; font-size:12px;">✓ Yes</span>
                        <% } %>
                    </td>
                    <td>
                        <a href="review-project.jsp?id=<%= p.getId() %>" class="btn text-btn">Review</a>
                        <a href="feedback.jsp?id=<%= p.getId() %>" class="btn text-btn" style="background:#8b5cf6;">View</a>
                        <a href="deleteProject?id=<%= p.getId() %>" class="btn error text-btn"
                           onclick="return confirm('Delete?')">X</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>