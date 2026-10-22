<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Login</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div style="color:#fff; font-size:20px; font-weight:700;">Student Review Platform</div>
        <div class="nav-links"><a href="index.jsp">Home</a><a href="register.jsp">Register</a></div>
    </nav>
    <div class="login-wrapper">
        <div class="login-card">
            <div class="login-left">
                <h2>Student Login</h2>
                <% if(request.getParameter("success") != null) { %>
                    <p class="success"><%= request.getParameter("success") %></p>
                <% } %>
                <% if(request.getParameter("error") != null) { %>
                    <p class="error"><%= request.getParameter("error") %></p>
                <% } %>

                <form action="login" method="post" style="margin-top:20px;">
                    <input type="hidden" name="role" value="STUDENT">

                    <div class="form-group">
                        <label>Student ID</label>
                        <input type="number" name="studentId" required>
                    </div>

                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="username" required autocomplete="off">
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" required>
                    </div>

                    <a href="forgot-password.jsp?role=STUDENT" class="forgot-link">Forgot Password?</a>

                    <button type="submit" class="btn-login">Sign In</button>
                </form>
            </div>
            <div class="login-right">
                <h1>STUDENT GATE</h1>
                <p>Track project statuses, view scorecards, and respond to feedback.</p>
            </div>
        </div>
    </div>
</body>
</html>