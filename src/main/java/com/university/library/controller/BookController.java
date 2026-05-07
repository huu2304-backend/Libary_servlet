package com.university.library.controller;

import com.university.library.dao.CategoryDAO;
import com.university.library.model.Book;
import com.university.library.service.BookService;
import com.university.library.service.BookServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import static com.university.library.utils.AppConstants.*;

@WebServlet(name = "bookController", urlPatterns = {URL_HOME, URL_ADMIN_BOOKS})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class BookController extends HttpServlet {

    private final BookService bookService = new BookServiceImpl();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String path = request.getServletPath();
        HttpSession session = request.getSession();

        request.setAttribute("listCategory", categoryDAO.getAllCategories());

        try {
            if (action != null) {
                switch (action) {
                    case "delete":
                        int deleteId = Integer.parseInt(request.getParameter("id"));
                        bookService.deleteBook(deleteId);
                        setNotify(session, "Đã xóa sách thành công!", "success");
                        response.sendRedirect(request.getContextPath() + URL_ADMIN_BOOKS);
                        return;

                    case "edit":
                        int editId = Integer.parseInt(request.getParameter("id"));
                        Book book = bookService.getBookById(editId);
                        request.setAttribute("book", book);
                        request.getRequestDispatcher(VIEW_ADMIN_EDIT).forward(request, response);
                        return;

                    case "add":
                        request.getRequestDispatcher(VIEW_ADMIN_ADD).forward(request, response);
                        return;
                }
            }

            request.setAttribute("listBook", bookService.getAllBooks());
            String targetView = URL_ADMIN_BOOKS.equals(path) ? VIEW_ADMIN_LIST : VIEW_HOME;
            request.getRequestDispatcher(targetView).forward(request, response);

        } catch (Exception e) {
            sendError(session, response, request, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("add".equals(action)) {
                bookService.addBook(request);
                setNotify(session, "Thêm mới thành công!", "success");
            } else if ("update".equals(action)) {
                bookService.updateBook(request);
                setNotify(session, "Cập nhật thành công!", "success");
            }
        } catch (Exception e) {
            setNotify(session, "Lỗi: " + e.getMessage(), "error");
        }

        response.sendRedirect(request.getContextPath() + URL_ADMIN_BOOKS);
    }


    private void setNotify(HttpSession session, String message, String type) {
        session.setAttribute("message", message);
        session.setAttribute("messageType", type);
    }

    private void sendError(HttpSession session, HttpServletResponse response, HttpServletRequest request, String errorMsg)
            throws IOException {
        setNotify(session, errorMsg, "error");
        response.sendRedirect(request.getContextPath() + URL_ADMIN_BOOKS);
    }
}