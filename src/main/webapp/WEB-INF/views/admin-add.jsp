<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.university.library.utils.AppConstants" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Sách Mới</title>
    <style>
        :root {
            --primary-color: #28a745;
            --primary-hover: #218838;
            --bg-color: #f4f7f6;
            --text-color: #333;
            --danger-color: #dc3545;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .container {
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
            width: 100%;
            max-width: 500px;
        }

        h2 {
            margin-top: 0;
            color: var(--text-color);
            font-size: 24px;
            text-align: center;
            margin-bottom: 30px;
            position: relative;
        }

        h2::after {
            content: '';
            display: block;
            width: 50px;
            height: 4px;
            background: var(--primary-color);
            margin: 8px auto;
            border-radius: 2px;
        }

        label {
            font-weight: 600;
            font-size: 14px;
            color: #555;
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"], select {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 20px;
            border: 1px solid #e1e1e1;
            border-radius: 8px;
            box-sizing: border-box;
            transition: border-color 0.3s, box-shadow 0.3s;
            outline: none;
        }

        input:focus, select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
        }

        /* Khu vực chọn ảnh */
        .image-upload-wrapper {
            position: relative;
            border: 2px dashed #d1d1d1;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            background: #fafafa;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 25px;
            min-height: 180px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .image-upload-wrapper:hover {
            border-color: var(--primary-color);
            background: #f0fff4;
        }

        #image-preview {
            display: none;
            max-width: 100%;
            max-height: 250px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            object-fit: contain;
        }

        .upload-hint {
            color: #888;
            font-size: 14px;
            pointer-events: none; /* Tránh cản trở click */
        }

        .upload-hint i {
            display: block;
            font-size: 35px;
            margin-bottom: 10px;
            font-style: normal;
        }

        /* Nút xóa ảnh */
        #remove-img-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: var(--danger-color);
            color: white;
            border: none;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            cursor: pointer;
            display: none; /* Mặc định ẩn */
            z-index: 10;
            font-size: 20px;
            font-weight: bold;
            line-height: 1;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            transition: transform 0.2s, background 0.2s;
        }

        #remove-img-btn:hover {
            background: #bd2130;
            transform: scale(1.1);
        }

        .btn-submit {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 14px;
            width: 100%;
            border-radius: 8px;
            font-weight: bold;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-submit:hover {
            background: var(--primary-hover);
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            text-decoration: none;
            color: #888;
            font-size: 14px;
            transition: color 0.3s;
        }

        .back-link:hover {
            color: #333;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Nhập Thông Tin Sách</h2>

    <form action="${pageContext.request.contextPath}<%= AppConstants.URL_ADMIN_BOOKS %>" method="post"
          enctype="multipart/form-data">
        <input type="hidden" name="action" value="add">

        <label>Tên sách</label>
        <input type="text" name="title" placeholder="Ví dụ: Đắc Nhân Tâm" required>

        <label>Tác giả</label>
        <input type="text" name="author" id="author-input" placeholder="Tên tác giả..." required>
        <span id="author-error"
              style="color: var(--danger-color); font-size: 12px; display: none; margin-top: -15px; margin-bottom: 15px;">
    Tên tác giả không hợp lệ (không bao gồm số và ký tự đặc biệt)
        </span>

        <label>Thể loại</label>
        <select name="categoryId" required>
            <option value="" disabled selected>-- Chọn thể loại --</option>
            <c:forEach var="cat" items="${listCategory}">
                <option value="${cat.id}">${cat.name}</option>
            </c:forEach>
        </select>

        <label>Ảnh bìa sách</label>
        <div class="image-upload-wrapper" id="drop-area" onclick="document.getElementById('image-input').click()">
            <button type="button" id="remove-img-btn" title="Xóa ảnh này">&times;</button>

            <div id="upload-content">
                <span class="upload-hint">
                    <i>📷</i>
                    Nhấp để chọn ảnh bìa
                </span>
            </div>

            <img id="image-preview" src="" alt="Preview">

            <input type="file" name="image" id="image-input" accept="image/*" required style="display: none;">
        </div>

        <button type="submit" class="btn-submit">Lưu vào hệ thống</button>

        <a href="${pageContext.request.contextPath}<%= AppConstants.URL_ADMIN_BOOKS %>" class="back-link">
            ← Quay lại danh sách
        </a>
    </form>
</div>
<script>
    const imageInput = document.getElementById('image-input');
    const imagePreview = document.getElementById('image-preview');
    const uploadContent = document.getElementById('upload-content');
    const removeBtn = document.getElementById('remove-img-btn');

    function clearImage() {
        imageInput.value = "";
        imagePreview.src = "";
        imagePreview.style.display = 'none';
        uploadContent.style.display = 'block';
        removeBtn.style.display = 'none';
    }

    imageInput.addEventListener('change', function () {
        const file = this.files[0];

        if (file) {
            if (!file.type.startsWith('image/')) {
                alert("Vui lòng chọn một file hình ảnh (jpg, png, webp...)");
                clearImage();
                return;
            }

            const reader = new FileReader();
            reader.onload = function (e) {
                imagePreview.src = e.target.result;
                imagePreview.style.display = 'block';
                uploadContent.style.display = 'none';
                removeBtn.style.display = 'block';
            }
            reader.readAsDataURL(file);
        }
    });

    removeBtn.addEventListener('click', function (e) {
        e.stopPropagation();
        clearImage();
    });
    const authorInput = document.getElementById('author-input');
    const authorError = document.getElementById('author-error');
    const form = document.querySelector('form');
    function validateAuthor(name) {
        const regex = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s|_]+$/;

        if (name.length < 2) return "Tên tác giả phải có ít nhất 2 ký tự";
        if (!regex.test(name)) return "Tên tác giả không được chứa số hoặc ký tự đặc biệt";
        return "";
    }
    authorInput.addEventListener('input', function() {
        const errorMsg = validateAuthor(this.value);
        if (errorMsg) {
            authorError.textContent = errorMsg;
            authorError.style.display = 'block';
            this.style.borderColor = 'var(--danger-color)';
        } else {
            authorError.style.display = 'none';
            this.style.borderColor = 'var(--primary-color)';
        }
    });

    form.addEventListener('submit', function(e) {
        const errorMsg = validateAuthor(authorInput.value);
        if (errorMsg) {
            e.preventDefault();
            authorInput.focus();
            authorError.textContent = errorMsg;
            authorError.style.display = 'block';
            alert("Vui lòng kiểm tra lại thông tin tác giả!");
        }
    });
</script>

</body>
</html>