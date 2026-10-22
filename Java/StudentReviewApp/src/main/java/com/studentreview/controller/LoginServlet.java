package com.studentreview.controller;

import com.studentreview.dao.ProjectDAO;
import com.studentreview.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProjectDAO projectDAO = new ProjectDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");
        String hashedPass = PasswordUtil.hashPassword(pass);

        // ── STUDENT LOGIN (needs ID + username + password) ──
        if ("STUDENT".equals(role)) {
            String idStr = request.getParameter("studentId");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect("student-login.jsp?error=Student ID is required.");
                return;
            }
            int studentId;
            try {
                studentId = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                response.sendRedirect("student-login.jsp?error=Student ID must be a number.");
                return;
            }
            int authenticatedId = projectDAO.authenticateStudent(username, hashedPass, studentId);
            if (authenticatedId > 0) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", "STUDENT");
                session.setAttribute("userId", authenticatedId);
                response.sendRedirect("student-dashboard.jsp");
            } else {
                response.sendRedirect("student-login.jsp?error=Invalid Student ID, username or password.");
            }
            return;
        }

        // ── TRAINER LOGIN (only username + password, no ID) ──
        if ("TRAINER".equals(role)) {
            String authenticatedRole = projectDAO.authenticateUser(username, hashedPass, "TRAINER");
            if (authenticatedRole != null) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", "TRAINER");
                session.setAttribute("userId", projectDAO.getUserId(username));
                response.sendRedirect("trainer-dashboard.jsp");
            } else {
                response.sendRedirect("trainer-login.jsp?error=Invalid username or password.");
            }
            return;
        }

        // ── ADMIN LOGIN ──
        String authenticatedRole = projectDAO.authenticateUser(username, hashedPass, "ADMIN");
        if (authenticatedRole != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", "ADMIN");
            session.setAttribute("userId", projectDAO.getUserId(username));
            response.sendRedirect("admin-dashboard.jsp");
        } else {
            response.sendRedirect("admin-login.jsp?error=Invalid credentials.");
        }
    }
}