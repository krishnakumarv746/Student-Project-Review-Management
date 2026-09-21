<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String preselectedRole = request.getParameter("role");
    if (preselectedRole == null) preselectedRole = "STUDENT";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div style="color:#fff; font-size:20px; font-weight:700;">Student Review Platform</div>
        <div class="nav-links"><a href="index.jsp">Home</a></div>
    </nav>
    <div class="login-wrapper">
        <div class="login-card">
            <div class="login-left">
                <h2>Reset Your Password</h2>
                <p style="color:#64748b; font-size:13px; margin-bottom:15px;">
                    Select role, provide ID and username, then set a new password.
                </p>

                <% if(request.getParameter("error") != null) { %>
                    <p class="error"><%= request.getParameter("error") %></p>
                <% } %>
                <% if(request.getParameter("success") != null) { %>
                    <p class="success"><%= request.getParameter("success") %></p>
                <% } %>

                <form action="forgotPassword" method="post" style="margin-top:15px;">
                    <div class="form-group">
                        <label>Role</label>
                        <select name="role" required>
                            <option value="STUDENT" <%= "STUDENT".equals(preselectedRole) ? "selected" : "" %>>STUDENT</option>
                            <option value="TRAINER" <%= "TRAINER".equals(preselectedRole) ? "selected" : "" %>>TRAINER</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Your ID</label>
                        <input type="number" name="studentId" required>
                    </div>

                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="username" required autocomplete="off">
                    </div>

                    <div class="form-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" required minlength="4">
                    </div>

                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPassword" required minlength="4">
                    </div>

                    <button type="submit" class="btn-login">Reset Password</button>

                    <p style="margin-top:15px; text-align:center; font-size:13px;">
                        <a href="student-login.jsp" style="color:#3b82f6;">Student Login</a> &nbsp;|&nbsp;
                        <a href="trainer-login.jsp" style="color:#3b82f6;">Trainer Login</a>
                    </p>
                </form>
            </div>
            <div class="login-right">
                <h1>RESET PASSWORD</h1>
                <p>Provide your ID and Username to verify your identity, then set a new password.</p>
            </div>
        </div>
    </div>
</body>
</html>