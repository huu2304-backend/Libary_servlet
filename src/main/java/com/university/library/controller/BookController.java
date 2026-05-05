package com.university.library.controller;

import com.university.library.dao.BookDAO;
import com.university.library.dao.CategoryDAO;
import com.university.library.model.Book;
import com.university.library.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.List;

import static com.university.library.utils.AppConstants.*;

@WebServlet(name = "bookController", urlPatterns = {URL_HOME, URL_ADMIN_BOOKS})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class BookController extends HttpServlet {
    private final BookDAO bookDAO = new BookDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String path = request.getServletPath();
        HttpSession session = request.getSession();

        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("listCategory", categories);

        if (action != null) {
            try {
                switch (action) {
                    case "delete":
                        int deleteId = Integer.parseInt(request.getParameter("id"));
                        bookDAO.deleteBook(deleteId);
                        session.setAttribute("message", "Đã xóa sách thành công!");
                        session.setAttribute("messageType", "success");
                        response.sendRedirect(request.getContextPath() + URL_ADMIN_BOOKS);
                        return;

                    case "edit":
                        int editId = Integer.parseInt(request.getParameter("id"));
                        Book book = bookDAO.getBookById(editId);
                        request.setAttribute("book", book);
                        request.getRequestDispatcher(VIEW_ADMIN_EDIT).forward(request, response);
                        return;

                    case "add":
                        request.getRequestDispatcher(VIEW_ADMIN_ADD).forward(request, response);
                        return;
                }
            } catch (Exception e) {
                session.setAttribute("message", "Lỗi: " + e.getMessage());
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + URL_ADMIN_BOOKS);
                return;
            }
        }

        request.setAttribute("listBook", bookDAO.getAllBooks());
        if (URL_ADMIN_BOOKS.equals(path)) {
            request.getRequestDispatcher(VIEW_ADMIN_LIST).forward(request, response);
        } else {
            request.getRequestDispatcher(VIEW_HOME).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("add".equals(action)) {
                processAddBook(request, session);
            } else if ("update".equals(action)) {
                processUpdateBook(request, session);
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra log Render để dễ theo dõi
            session.setAttribute("message", "Lỗi: " + e.getMessage());
            session.setAttribute("messageType", "error");
        }
        response.sendRedirect(request.getContextPath() + URL_ADMIN_BOOKS);
    }

    private void processAddBook(HttpServletRequest request, HttpSession session) throws Exception {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String catIdRaw = request.getParameter("categoryId");

        if (catIdRaw == null) throw new Exception("Vui lòng chọn thể loại!");

        Part filePart = request.getPart("image");
        String fileName = "default.jpg";
        if (filePart != null && filePart.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
            saveFile(request, filePart, fileName);
        }

        bookDAO.addBook(new Book(title, author, fileName, Integer.parseInt(catIdRaw)));
        session.setAttribute("message", "Thêm mới thành công!");
        session.setAttribute("messageType", "success");
    }

    private void processUpdateBook(HttpServletRequest request, HttpSession session) throws Exception {
        String idRaw = request.getParameter("id");
        String catIdRaw = request.getParameter("categoryId");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String oldImage = request.getParameter("oldImage");

        if (idRaw == null || catIdRaw == null) {
            throw new Exception("Dữ liệu thiếu (ID hoặc Category null)");
        }

        Part filePart = request.getPart("image");
        String fileName = (filePart != null && filePart.getSize() > 0)
                ? System.currentTimeMillis() + "_" + getFileName(filePart)
                : oldImage;

        if (filePart != null && filePart.getSize() > 0) {
            saveFile(request, filePart, fileName);
        }

        bookDAO.updateBook(new Book(Integer.parseInt(idRaw), title, author, fileName, Integer.parseInt(catIdRaw), null));
        session.setAttribute("message", "Cập nhật thành công!");
        session.setAttribute("messageType", "success");
    }

    private void saveFile(HttpServletRequest request, Part part, String fileName) throws IOException {
        // Lấy đường dẫn thư mục 'uploads' nằm bên trong thư mục triển khai ứng dụng
        String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        // Ghi file
        part.write(uploadPath + File.separator + fileName);
    }

    private String getFileName(Part part) {
        return part.getSubmittedFileName();
    }
}