package com.studentreview.controller;

import com.studentreview.dao.ProjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProjectDAO projectDAO = new ProjectDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("student-login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        projectDAO.markAllNotificationsRead(userId);
        response.sendRedirect("notifications.jsp");
    }
}