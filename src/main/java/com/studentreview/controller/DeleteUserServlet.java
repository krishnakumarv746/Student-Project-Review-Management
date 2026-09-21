package com.studentreview.controller;

import com.studentreview.dao.ProjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProjectDAO projectDAO = new ProjectDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("id"));

        if (projectDAO.deleteUser(userId)) {
            response.sendRedirect("admin-dashboard.jsp?success=User Erased");
        } else {
            response.sendRedirect("admin-dashboard.jsp?error=Operation Failed");
        }
    }
}