package com.studentreview.controller;

import com.studentreview.dao.ProjectDAO;
import com.studentreview.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProjectDAO projectDAO = new ProjectDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        String hashedPassword = PasswordUtil.hashPassword(password);

        if (projectDAO.registerUser(username, hashedPassword, role)) {
            String redirectTarget = role.toLowerCase().trim() + "-login.jsp?success=Registration successful!";
            response.sendRedirect(redirectTarget);
        } else {
            response.sendRedirect("register.jsp?error=Username already exists.");
        }
    }
}