<%@ page import="com.studentreview.dao.ProjectDAO, com.studentreview.model.Project" %>
<%
    if (session.getAttribute("username") == null || !"TRAINER".equals(session.getAttribute("role"))) {
        response.sendRedirect("trainer-login.jsp");
        return;
    }
    int projectId = Integer.parseInt(request.getParameter("id"));
    Project p = new ProjectDAO().getProjectById(projectId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Review Project</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container small-card">
        <h2>Reviewing: <%= p.getTitle() %></h2>
        <p><strong>Student:</strong> <%= p.getStudentName() %></p>
        <p><strong>Due Date:</strong> <%= p.getDueDate() == null ? "Not set" : p.getDueDate().toString() %>
            <% if(p.isOverdue()) { %><span style="color:#ef4444; font-weight:700;"> OVERDUE</span><% } %>
        </p>

        <% if(p.getProjectFile() != null && !p.getProjectFile().isEmpty()) { %>
            <p><strong>Project File:</strong>
                <a href="<%= p.getProjectFile() %>" target="_blank" class="btn text-btn" style="background:#16a34a;">📄 Download</a>
            </p>
        <% } %>

        <hr style="margin:15px 0;">

        <h3>Student Reply</h3>
        <% if (p.getStudentReply() == null || p.getStudentReply().trim().isEmpty()) { %>
            <p style="color:#888; font-style:italic;">Not yet.</p>
        <% } else { %>
            <div style="background:#f8fafc; padding:15px; border-left:4px solid #3b82f6; border-radius:6px;">
                <p><%= p.getStudentReply() %></p>
            </div>
        <% } %>

        <hr style="margin:15px 0;">

        <h3>Submit Review</h3>
        <form action="review" method="post">
            <input type="hidden" name="projectId" value="<%= p.getId() %>">

            <label>Status</label>
            <select name="status">
                <option value="UNDER_REVIEW" <%= "UNDER_REVIEW".equals(p.getStatus())?"selected":"" %>>Under Review</option>
                <option value="COMPLETED" <%= "COMPLETED".equals(p.getStatus())?"selected":"" %>>Completed</option>
                <option value="REJECTED" <%= "REJECTED".equals(p.getStatus())?"selected":"" %>>Rejected</option>
            </select>

            <label>Grade</label>
            <input type="text" name="grade" value="<%= p.getGrade() != null ? p.getGrade() : "" %>" placeholder="A+, B...">

            <label>Feedback</label>
            <textarea name="feedback" rows="4" required><%= p.getFeedback() != null ? p.getFeedback() : "" %></textarea>

            <button type="submit" class="btn" style="width:100%; margin-top:15px;">Save Review</button>
            <a href="trainer-dashboard.jsp" class="btn secondary" style="display:block; text-align:center; margin-top:10px;">Cancel</a>
        </form>
    </div>
</body>
</html>