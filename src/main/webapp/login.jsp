<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Bước 1: Import class hằng số của bạn --%>
<%@ page import="com.university.library.utils.AppConstants" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống | Thư viện</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { width: 350px; padding: 30px; background: white; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); text-align: center; }
        h2 { color: #007bff; margin-bottom: 25px; }
        label { display: block; text-align: left; margin-bottom: 5px; font-weight: 600; color: #555; }
        input { width: 100%; padding: 12px; margin-bottom: 20px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; outline: none; transition: border 0.3s; }
        input:focus { border-color: #007bff; }
        button { width: 100%; padding: 12px; background: #007bff; color: white; border: none; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; transition: background 0.3s; }
        button:hover { background: #0056b3; }
        .error-msg { color: #dc3545; background: #f8d7da; padding: 10px; border-radius: 4px; margin-bottom: 15px; font-size: 14px; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>

<div class="login-box">
    <h2>🔑 Đăng Nhập</h2>

    <%-- Hiển thị thông báo lỗi nếu có --%>
    <c:if test="${not empty error}">
        <div class="error-msg">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}<%= AppConstants.URL_LOGIN %>" method="post">

        <label>Tên đăng nhập:</label>
        <input type="text" name="username" placeholder="Nhập username..." required autofocus>

        <label>Mật khẩu:</label>
        <input type="password" name="password" placeholder="Nhập mật khẩu..." required>

        <button type="submit">Vào hệ thống</button>
    </form>

    <div style="margin-top: 20px; font-size: 13px; color: #888;">
        © 2026 Hệ thống quản lý Thư <viện></viện>
    </div>
</div>

</body>
</html>