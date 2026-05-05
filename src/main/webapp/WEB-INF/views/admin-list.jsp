<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.university.library.utils.AppConstants" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lí Thư viện</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 20px; background-color: #f8f9fa; }
        .header-admin { display: flex; justify-content: space-between; align-items: center; background: #343a40; color: white; padding: 15px 25px; border-radius: 8px; margin-bottom: 20px; }

        /* Toast Alert cực đẹp */
        .flash-alert { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 10000; min-width: 350px; padding: 15px; border-radius: 8px; color: white; text-align: center; font-weight: bold; box-shadow: 0 4px 15px rgba(0,0,0,0.2); transition: all 0.5s ease; }
        .bg-success { background-color: #28a745; }
        .bg-danger { background-color: #dc3545; }

        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
        th { background-color: #f1f3f5; }
        .btn-delete { color: #dc3545; text-decoration: none; font-weight: bold; }
        .btn-edit { color: #007bff; text-decoration: none; font-weight: bold; }
        .book-img { width: 50px; height: 70px; object-fit: cover; border-radius: 4px; }
        .btn-add { padding: 10px 20px; background: #28a745; color: white; border-radius: 6px; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

<c:if test="${not empty sessionScope.message}">
    <div id="toast" class="flash-alert ${sessionScope.messageType == 'error' ? 'bg-danger' : 'bg-success'}">
            ${sessionScope.messageType == 'error' ? '❌' : '✅'} ${sessionScope.message}
    </div>
    <c:remove var="message" scope="session" />
    <c:remove var="messageType" scope="session" />
</c:if>

<div class="header-admin">
    <h2>📚 Quản trị Thư viện</h2>
    <div>
        <span>Chào, <strong>${sessionScope[AppConstants.SESSION_USER].username}</strong></span> |
        <a href="${pageContext.request.contextPath}<%= AppConstants.URL_LOGOUT %>" style="color: #ffbaba; text-decoration: none;">Đăng xuất</a>
    </div>
</div>

<div style="margin-bottom: 20px; display: flex; justify-content: space-between;">
    <h3>📋 Danh mục sách</h3>
    <a href="${pageContext.request.contextPath}<%= AppConstants.URL_ADMIN_BOOKS %>?action=add" class="btn-add">➕ Thêm sách</a>
</div>

<table>
    <thead>
    <tr><th>ID</th><th>Ảnh</th><th>Tiêu đề</th><th>Tác giả</th><th>Thể loại</th><th style="text-align:center">Hành động</th></tr>
    </thead>
    <tbody>
    <c:forEach var="book" items="${listBook}">
        <tr>
            <td>#${book.id}</td>
            <td><img src="${pageContext.request.contextPath}/uploads/${book.imagePath}" class="book-img" onerror="this.src='https://via.placeholder.com/50x70'"></td>
            <td><strong>${book.title}</strong></td>
            <td>${book.author}</td>
            <td><span style="background:#e9ecef; padding:3px 8px; border-radius:4px;">${book.categoryName}</span></td>
            <td style="text-align: center;">
                <a href="${pageContext.request.contextPath}<%= AppConstants.URL_ADMIN_BOOKS %>?action=edit&id=${book.id}" class="btn-edit">Sửa</a> |
                <a href="${pageContext.request.contextPath}<%= AppConstants.URL_ADMIN_BOOKS %>?action=delete&id=${book.id}" class="btn-delete" onclick="return confirm('Xóa sách này?')">Xoá</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<script>
    window.onload = function() {
        const toast = document.getElementById('toast');
        if (toast) {
            setTimeout(() => {
                toast.style.opacity = '0';
                toast.style.top = '0px';
                setTimeout(() => toast.remove(), 500);
            }, 3000);
        }
    };
</script>
</body>
</html>