<%@ page import="com.studentreview.dao.ProjectDAO, com.studentreview.model.Project, java.util.List" %>
<%
    if (session.getAttribute("username") == null || !"TRAINER".equals(session.getAttribute("role"))) {
        response.sendRedirect("trainer-login.jsp");
        return;
    }
    ProjectDAO dao = new ProjectDAO();
    List<Project> students = dao.getAllStudents();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Assign Project</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container small-card">
        <h2>Assign New Project</h2>

        <% if(request.getParameter("error") != null) { %>
            <p class="error"><%= request.getParameter("error") %></p>
        <% } %>

        <% if(students.isEmpty()) { %>
            <p class="error">No students registered yet.</p>
            <a href="trainer-dashboard.jsp" class="btn secondary" style="display:block; text-align:center; margin-top:15px;">Back</a>
        <% } else { %>
        <form action="project" method="post">
            <label>Project Title</label>
            <input type="text" name="title" required>

            <label>Description</label>
            <textarea name="description" rows="5" required></textarea>

            <label>Assign To Student</label>
            <select name="studentId" required>
                <option value="">-- Select Student --</option>
                <% for(Project s : students) { %>
                    <option value="<%= s.getStudentId() %>">
                        ID: <%= s.getStudentId() %> | <%= s.getStudentName() %>
                    </option>
                <% } %>
            </select>

            <label>Due Date (Optional)</label>
            <input type="date" name="dueDate">

            <button type="submit" class="btn" style="width:100%; margin-top:15px;">Assign Project</button>
            <a href="trainer-dashboard.jsp" class="btn secondary" style="display:block; text-align:center; margin-top:10px;">Back</a>
        </form>
        <% } %>
    </div>
</body>
</html>