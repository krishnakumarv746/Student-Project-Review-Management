package com.studentreview.controller;

import com.studentreview.dao.ProjectDAO;
import com.studentreview.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/project")
public class ProjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProjectDAO projectDAO = new ProjectDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"TRAINER".equals(session.getAttribute("role"))) {
            response.sendRedirect("trainer-login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String studentIdStr = request.getParameter("studentId");
        String dueDate = request.getParameter("dueDate");

        if (title == null || title.trim().isEmpty()) {
            response.sendRedirect("assign-project.jsp?error=Title is required.");
            return;
        }
        if (studentIdStr == null || studentIdStr.trim().isEmpty()) {
            response.sendRedirect("assign-project.jsp?error=Please select a student.");
            return;
        }

        int studentId;
        try {
            studentId = Integer.parseInt(studentIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("assign-project.jsp?error=Invalid student.");
            return;
        }

        int trainerId = (Integer) session.getAttribute("userId");
        String trainerName = (String) session.getAttribute("username");

        Project project = new Project();
        project.setTitle(title);
        project.setDescription(description);
        project.setStudentId(studentId);
        project.setTrainerId(trainerId);

        if (projectDAO.assignProjectWithDeadline(project, dueDate)) {
            projectDAO.addNotification(
                studentId,
                "New Project Assigned",
                "Trainer " + trainerName + " assigned you: " + title
            );
            response.sendRedirect("trainer-dashboard.jsp?success=Project assigned successfully.");
        } else {
            response.sendRedirect("assign-project.jsp?error=Assignment failed.");
        }
    }
}