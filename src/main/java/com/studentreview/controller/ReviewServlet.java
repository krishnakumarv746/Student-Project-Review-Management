package com.studentreview.controller;

import com.studentreview.dao.ProjectDAO;
import com.studentreview.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProjectDAO projectDAO = new ProjectDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"TRAINER".equals(session.getAttribute("role"))) {
            response.sendRedirect("trainer-login.jsp");
            return;
        }

        int projectId = Integer.parseInt(request.getParameter("projectId"));
        String feedback = request.getParameter("feedback");
        String grade = request.getParameter("grade");
        String status = request.getParameter("status");

        if (projectDAO.updateReview(projectId, feedback, grade, status)) {
            Project p = projectDAO.getProjectById(projectId);
            if (p != null) {
                projectDAO.addNotification(
                    p.getStudentId(),
                    "Project Reviewed: " + p.getTitle(),
                    "Grade: " + (grade == null ? "N/A" : grade) + " | Status: " + status
                );
            }
            response.sendRedirect("trainer-dashboard.jsp?success=Review submitted.");
        } else {
            response.sendRedirect("review-project.jsp?id=" + projectId + "&error=Update failed.");
        }
    }
}