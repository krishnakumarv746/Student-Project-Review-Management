<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="login-wrapper">
        <div class="login-card">
            <div class="login-left">
                <h2 style="color:#d63031;">Admin Terminal</h2>
                <% if(request.getParameter("error") != null) { %><p class="error"><%= request.getParameter("error") %></p><% } %>
                <form action="login" method="post" style="margin-top:20px;">
                    <input type="hidden" name="role" value="ADMIN">
                    <div class="form-group"><label>Admin Username</label><input type="text" name="username" required></div>
                    <div class="form-group"><label>Password</label><input type="password" name="password" required></div>
                    <button type="submit" class="btn-login" style="background:#d63031;">Authorize</button>
                </form>
                <p style="margin-top:20px;"><a href="index.jsp">Return to Home</a></p>
            </div>
        </div>
    </div>
</body>
</html>