<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Project Review Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div style="color:#fff; font-size:20px; font-weight:700;">Student Review Platform</div>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="register.jsp">Register</a>
            <a href="student-login.jsp" class="btn-nav-login">Login</a>
        </div>
    </nav>
    <div class="hero-container">
        <span class="hero-badge">PROJECT REVIEW WORKSPACE</span>
        <h1>Project Review Management System</h1>
        <p>Automate project submissions, assignments tracking, reviews, and grading.</p>
    </div>
    <div class="services-section">
        <h2>Access Online Services</h2>
        <div class="services-grid" style="grid-template-columns: repeat(3, 1fr);">
            <a href="student-login.jsp" class="service-card">
                <div class="service-icon-box">🎓</div>
                <div><strong>Student Portal</strong><p style="font-size:12px; color:#64748b;">Track grades and submit queries</p></div>
            </a>
            <a href="trainer-login.jsp" class="service-card">
                <div class="service-icon-box">👨‍🏫</div>
                <div><strong>Trainer Portal</strong><p style="font-size:12px; color:#64748b;">Assign and grade projects</p></div>
            </a>
            <a href="register.jsp" class="service-card">
                <div class="service-icon-box">📝</div>
                <div><strong>Register</strong><p style="font-size:12px; color:#64748b;">Sign up as student or trainer</p></div>
            </a>
        </div>
    </div>
</body>
</html>