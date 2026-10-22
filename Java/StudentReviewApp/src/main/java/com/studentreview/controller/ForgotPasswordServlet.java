package com.studentreview.controller;

import com.studentreview.dao.ProjectDAO;
import com.studentreview.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProjectDAO projectDAO = new ProjectDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("forgot-password.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        String idStr = request.getParameter("studentId");
        String username = request.getParameter("username");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String backUrl = "forgot-password.jsp?role=" + (role != null ? role : "STUDENT");

        if (role == null || (!"STUDENT".equals(role) && !"TRAINER".equals(role))) {
            response.sendRedirect(backUrl + "&error=Invalid role.");
            return;
        }

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            response.sendRedirect(backUrl + "&error=Passwords do not match.");
            return;
        }

        if (newPassword.length() < 4) {
            response.sendRedirect(backUrl + "&error=Password must be at least 4 characters.");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(backUrl + "&error=ID must be a number.");
            return;
        }

        String existingUsername = projectDAO.getUsernameById(userId);
        String existingRole = projectDAO.getRoleById(userId);

        if (existingUsername == null
                || !existingUsername.equals(username)
                || !role.equals(existingRole)) {
            response.sendRedirect(backUrl + "&error=ID, Username and Role do not match.");
            return;
        }

        String hashed = PasswordUtil.hashPassword(newPassword);
        if (projectDAO.resetPasswordByRole(userId, username, role, hashed)) {
            String loginPage = "TRAINER".equals(role) ? "trainer-login.jsp" : "student-login.jsp";
            response.sendRedirect(loginPage + "?success=Password reset successful! Please log in.");
        } else {
            response.sendRedirect(backUrl + "&error=Password reset failed. Try again.");
        }
    }
}