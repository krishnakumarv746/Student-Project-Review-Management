package com.studentreview.controller;

import com.studentreview.dao.ProjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteProject")
public class DeleteProjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProjectDAO projectDAO = new ProjectDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"TRAINER".equals(session.getAttribute("role"))) {
            response.sendRedirect("trainer-login.jsp");
            return;
        }

        int projectId = Integer.parseInt(request.getParameter("id"));

        if (projectDAO.deleteProject(projectId)) {
            response.sendRedirect("trainer-dashboard.jsp?success=Project Deleted");
        } else {
            response.sendRedirect("trainer-dashboard.jsp?error=Delete Operation Failed");
        }
    }
}