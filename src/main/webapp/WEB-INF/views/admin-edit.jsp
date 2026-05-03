<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.university.library.utils.AppConstants" %>

<html>
<head>
  <meta charset="UTF-8">
  <title>${not empty book ? "Chỉnh sửa sách" : "Thêm sách mới"}</title>
  <style>
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; padding: 50px 0; }
    .form-container { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); width: 450px; }
    h2 { color: #007bff; text-align: center; margin-top: 0; }
    label { display: block; margin: 15px 0 5px; font-weight: bold; color: #333; }

    input[type="text"],
    input[type="file"],
    select {
      width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-size: 14px;
    }

    select { background-color: #fff; cursor: pointer; }

    .current-img { display: block; margin: 10px 0; border-radius: 8px; border: 1px solid #eee; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .btn-group { margin-top: 25px; display: flex; gap: 10px; }
    .btn-submit { flex: 2; padding: 12px; background: #28a745; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; font-size: 16px; transition: 0.3s; }
    .btn-submit:hover { background: #218838; }
    .btn-cancel { flex: 1; padding: 12px; background: #6c757d; color: white; text-align: center; text-decoration: none; border-radius: 6px; font-weight: bold; line-height: 1.2; display: flex; align-items: center; justify-content: center; }
    .btn-cancel:hover { background: #5a6268; }
    .info-text { font-size: 12px; color: #666; font-style: italic; margin-top: 5px; }
  </style>
</head>
<body>

<div class="form-container">
  <h2>${not empty book ? "✏️ Chỉnh sửa sách" : "🆕 Thêm sách mới"}</h2>

  <%-- Cực kỳ quan trọng: enctype="multipart/form-data" --%>
  <form action="${pageContext.request.contextPath}<%= AppConstants.URL_ADMIN_BOOKS %>" method="post" enctype="multipart/form-data">

    <%-- Hành động: update hoặc add --%>
    <input type="hidden" name="action" value="${not empty book ? 'update' : 'add'}">

    <%-- Nếu là update, BẮT BUỘC phải có ID để không bị lỗi null string --%>
    <c:if test="${not empty book}">
      <input type="hidden" name="id" value="${book.id}">
    </c:if>

    <label>Tên sách:</label>
    <input type="text" name="title" value="${book.title}" placeholder="Nhập tiêu đề sách..." required>

    <label>Tác giả:</label>
    <input type="text" name="author" value="${book.author}" placeholder="Nhập tên tác giả..." required>

    <label>Thể loại:</label>
    <select name="categoryId" required>
      <option value="">-- Chọn thể loại --</option>
      <c:forEach var="cat" items="${listCategory}">
        <option value="${cat.id}" ${book.categoryId == cat.id ? 'selected' : ''}>
            ${cat.name}
        </option>
      </c:forEach>
    </select>

    <c:if test="${not empty book}">
      <label>Ảnh bìa hiện tại:</label>
      <c:choose>
        <c:when test="${not empty book.imagePath}">
          <img src="${pageContext.request.contextPath}/uploads/${book.imagePath}" width="120" class="current-img">
          <%-- Lưu lại tên ảnh cũ để nếu không chọn ảnh mới thì vẫn giữ ảnh này --%>
          <input type="hidden" name="oldImage" value="${book.imagePath}">
        </c:when>
        <c:otherwise>
          <p class="info-text">Chưa có ảnh đại diện.</p>
        </c:otherwise>
      </c:choose>
    </c:if>

    <label>${not empty book ? "Thay đổi ảnh mới:" : "Chọn ảnh bìa:"}</label>
    <input type="file" name="image" accept="image/*" ${empty book ? 'required' : ''}>
    <p class="info-text">Hỗ trợ: JPG, PNG. Để trống nếu giữ ảnh cũ.</p>

    <div class="btn-group">
      <button type="submit" class="btn-submit">
        ${not empty book ? "Lưu thay đổi" : "Thêm vào kho"}
      </button>
      <a href="${pageContext.request.contextPath}<%= AppConstants.URL_ADMIN_BOOKS %>" class="btn-cancel">Hủy bỏ</a>
    </div>
  </form>
</div>

</body>
</html>