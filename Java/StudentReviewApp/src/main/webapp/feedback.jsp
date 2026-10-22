<%@ page import="com.studentreview.dao.ProjectDAO, com.studentreview.model.Project" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("student-login.jsp");
        return;
    }
    String role = (String) session.getAttribute("role");
    int projectId = Integer.parseInt(request.getParameter("id"));
    Project p = new ProjectDAO().getProjectById(projectId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Project Details</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container small-card">
        <h2><%= p.getTitle() %></h2>
        <p><strong>Student:</strong> <%= p.getStudentName() %></p>
        <p><strong>Status:</strong> <span class="status-badge"><%= p.getStatus() %></span></p>
        <p><strong>Due Date:</strong> <%= p.getDueDate() == null ? "Not set" : p.getDueDate().toString() %></p>

        <% if(p.isOverdue()) { %>
            <p class="error">⚠ This project is overdue!</p>
        <% } %>

        <% if(request.getParameter("success") != null) { %>
            <p class="success"><%= request.getParameter("success") %></p>
        <% } %>
        <% if(request.getParameter("error") != null) { %>
            <p class="error"><%= request.getParameter("error") %></p>
        <% } %>

        <p style="margin-top:10px;"><strong>Description:</strong><br><%= p.getDescription() %></p>

        <hr style="margin:20px 0;">

        <h3>Trainer Feedback</h3>
        <p><strong>Grade:</strong> <%= p.getGrade() == null ? "Pending" : p.getGrade() %></p>
        <p><strong>Comments:</strong><br><%= p.getFeedback() == null ? "No feedback yet." : p.getFeedback() %></p>

        <hr style="margin:20px 0;">

        <h3>Project File</h3>
        <% if(p.getProjectFile() != null && !p.getProjectFile().isEmpty()) { %>
            <p><a href="<%= p.getProjectFile() %>" target="_blank" class="btn" style="background:#16a34a;">📄 Download Current File</a></p>
        <% } else { %>
            <p style="color:#888; font-style:italic;">No file uploaded yet.</p>
        <% } %>

        <% if ("STUDENT".equals(role)) { %>
            <form action="uploadFile" method="post" enctype="multipart/form-data" style="margin-top:15px;">
                <input type="hidden" name="projectId" value="<%= p.getId() %>">
                <label>Upload File (PDF, ZIP, DOC, DOCX, TXT)</label>
                <input type="file" name="projectFile" required accept=".pdf,.zip,.doc,.docx,.txt">
                <button type="submit" class="btn" style="margin-top:10px; width:100%;">Upload</button>
            </form>
        <% } %>

        <hr style="margin:20px 0;">

        <h3>Student Response</h3>
        <% if ("STUDENT".equals(role)) { %>
            <form action="studentResponse" method="post">
                <input type="hidden" name="projectId" value="<%= p.getId() %>">
                <textarea name="studentReply" rows="4" required><%= p.getStudentReply() != null ? p.getStudentReply() : "" %></textarea>
                <button type="submit" class="btn" style="margin-top:10px; width:100%;">Submit Reply</button>
            </form>
        <% } else { %>
            <% if (p.getStudentReply() == null || p.getStudentReply().trim().isEmpty()) { %>
                <p style="color:#888; font-style:italic;">No reply yet.</p>
            <% } else { %>
                <div style="background:#f8fafc; padding:15px; border-left:4px solid #3b82f6; border-radius:6px;">
                    <p><%= p.getStudentReply() %></p>
                </div>
            <% } %>
        <% } %>

        <% String backDash = "STUDENT".equals(role) ? "student-dashboard.jsp" : "trainer-dashboard.jsp"; %>
        <a href="<%= backDash %>" class="btn secondary" style="display:block; text-align:center; margin-top:20px;">Back</a>
    </div>
</body>
</html>