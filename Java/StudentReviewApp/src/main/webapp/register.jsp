<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div style="color:#fff; font-size:20px; font-weight:700;">Student Review Platform</div>
        <div class="nav-links"><a href="index.jsp">Home</a><a href="student-login.jsp">Login</a></div>
    </nav>
    <div class="login-wrapper">
        <div class="login-card">
            <div class="login-left">
                <h2>Portal Registration</h2>
                <% if(request.getParameter("error") != null) { %>
                    <p class="error"><%= request.getParameter("error") %></p>
                <% } %>
                <form action="register" method="post" style="margin-top:20px;">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="username" required>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" required>
                    </div>
                    <div class="form-group">
                        <label>Role</label>
                        <select name="role" required>
                            <option value="STUDENT">STUDENT</option>
                            <option value="TRAINER">TRAINER</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-login">Create Account</button>
                </form>
            </div>
            <div class="login-right">
                <h1>JOIN THE NETWORK</h1>
                <p>Register a fresh student tracking profile or instructor workspace account.</p>
            </div>
        </div>
    </div>
</body>
</html>