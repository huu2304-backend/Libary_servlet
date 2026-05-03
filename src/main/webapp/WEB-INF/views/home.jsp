<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Bước 1: Import class hằng số --%>
<%@ page import="com.university.library.utils.AppConstants" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Thư viện Sách Trực Tuyến</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; background-color: #f4f7f6; color: #333; }
        .navbar { background-color: #007bff; color: white; padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .navbar h1 { margin: 0; font-size: 24px; }
        .user-info { display: flex; align-items: center; gap: 15px; }
        .container { padding: 30px 50px; }

        .form-add {
            display: none; background: white; padding: 25px; border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08); width: 100%; max-width: 500px; margin-bottom: 40px;
        }
        .form-add h3 { margin-top: 0; color: #007bff; border-bottom: 2px solid #f4f7f6; padding-bottom: 10px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 600; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }

        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        th { background-color: #007bff; color: white; padding: 18px; text-align: left; }
        td { padding: 15px; border-bottom: 1px solid #eee; }
        tr:hover { background-color: #fcfcfc; }

        .btn-save { background: #28a745; color: white; border: none; padding: 10px 25px; cursor: pointer; border-radius: 5px; font-weight: bold; width: 100%; }
        .btn-logout { background: #fff; color: #dc3545; padding: 8px 15px; border-radius: 5px; text-decoration: none; font-weight: bold; font-size: 14px; }
        .badge-admin { background: #ffc107; color: #000; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .btn-toggle-add { background: #28a745; color: white; padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; font-weight: bold; margin-bottom: 20px; }

        .action-links a { text-decoration: none; font-weight: bold; color: #007bff; }
        .action-links a.delete { color: #dc3545; margin-left: 10px; }
        .book-img { width: 60px; height: 80px; object-fit: cover; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

<div class="navbar">
    <h1>📚 Thư viện Sách</h1>
    <div class="user-info">
        <span>Xin chào: <strong>${sessionScope[AppConstants.SESSION_USER].username}</strong></span>
        <c:if test="${sessionScope[AppConstants.SESSION_USER].role == AppConstants.ROLE_ADMIN}">
            <span class="badge-admin">Quản trị viên</span>
        </c:if>
        <a href="${pageContext.request.contextPath}<%= AppConstants.URL_LOGOUT %>" class="btn-logout">Đăng xuất</a>
    </div>
</div>

<div class="container">
    <c:if test="${sessionScope[AppConstants.SESSION_USER].role == AppConstants.ROLE_ADMIN}">
        <button type="button" class="btn-toggle-add" onclick="toggleForm()">➕ Thêm sách mới</button>

        <div class="form-add" id="addBookForm">
            <h3>🆕 Nhập thông tin sách</h3>
            <form action="${pageContext.request.contextPath}<%= AppConstants.URL_ADMIN_BOOKS %>" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <label>Tên sách:</label>
                    <input type="text" name="title" placeholder="Nhập tiêu đề sách..." required>
                </div>
                <div class="form-group">
                    <label>Tác giả:</label>
                    <input type="text" name="author" placeholder="Tên tác giả..." required>
                </div>
                <div class="form-group">
                    <label>Ảnh bìa:</label>
                    <input type="file" name="image" accept="image/*" required>
                </div>
                <button type="submit" class="btn-save">Lưu vào kho</button>
                <button type="button" onclick="toggleForm()" style="background: #6c757d; color: white; border: none; padding: 10px; width: 100%; border-radius: 5px; margin-top: 10px; cursor: pointer;">Hủy bỏ</button>
            </form>
        </div>
    </c:if>

    <h2>📋 Danh mục sách hiện có</h2>
    <table>
        <thead>
        <tr>
            <th width="50">ID</th>
            <th width="100">Ảnh bìa</th>
            <th>Tiêu đề sách</th>
            <th>Tác giả</th>
            <c:if test="${sessionScope[AppConstants.SESSION_USER].role == AppConstants.ROLE_ADMIN}">
                <th width="150">Hành động</th>
            </c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="book" items="${listBook}">
            <tr>
                <td>#${book.id}</td>
                <td>
                    <img src="${pageContext.request.contextPath}/uploads/${book.imagePath}" class="book-img">
                </td>
                <td><strong>${book.title}</strong></td>
                <td>${book.author}</td>

                <c:if test="${sessionScope[AppConstants.SESSION_USER].role == AppConstants.ROLE_ADMIN}">
                    <td class="action-links">
                        <a href="${pageContext.request.contextPath}<%= AppConstants.URL_ADMIN_BOOKS %>?action=edit&id=${book.id}">Sửa</a>
                        <a href="${pageContext.request.contextPath}<%= AppConstants.URL_ADMIN_BOOKS %>?action=delete&id=${book.id}"
                           class="delete" onclick="return confirm('Xác nhận xóa?')">Xoá</a>
                    </td>
                </c:if>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<script>
    function toggleForm() {
        var form = document.getElementById("addBookForm");
        if (form.style.display === "none" || form.style.display === "") {
            form.style.display = "block";
        } else {
            form.style.display = "none";
        }
    }
</script>

</body>
</html>