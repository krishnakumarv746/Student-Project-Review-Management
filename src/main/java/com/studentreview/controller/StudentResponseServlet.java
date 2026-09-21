package com.studentreview.controller;

import com.studentreview.dao.ProjectDAO;
import com.studentreview.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/studentResponse")
public class StudentResponseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProjectDAO projectDAO = new ProjectDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect("student-login.jsp");
            return;
        }

        int projectId = Integer.parseInt(request.getParameter("projectId"));
        String studentReply = request.getParameter("studentReply");

        if (projectDAO.updateStudentReply(projectId, studentReply)) {
            Project p = projectDAO.getProjectById(projectId);
            if (p != null) {
                String studentName = (String) session.getAttribute("username");
                projectDAO.addNotification(
                    p.getTrainerId(),
                    "New Reply from " + studentName,
                    studentName + " replied on: " + p.getTitle()
                );
            }
            response.sendRedirect("student-dashboard.jsp?success=Response saved.");
        } else {
            response.sendRedirect("feedback.jsp?id=" + projectId + "&error=Submission failed.");
        }
    }
}