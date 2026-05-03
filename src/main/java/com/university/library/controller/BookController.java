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
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class BookController extends HttpServlet {
    private final BookDAO bookDAO = new BookDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private static final String UPLOAD_DIR = "C:" + File.separator + "image" + File.separator + "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        String action = request.getParameter("action");
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
            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            saveFile(filePart, fileName);
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
            throw new Exception("Dữ liệu gửi lên bị thiếu (ID hoặc Category null)");
        }

        int id = Integer.parseInt(idRaw);
        int categoryId = Integer.parseInt(catIdRaw);

        Part filePart = request.getPart("image");
        String fileName = (filePart != null && filePart.getSize() > 0)
                ? System.currentTimeMillis() + "_" + filePart.getSubmittedFileName()
                : oldImage;

        if (filePart != null && filePart.getSize() > 0) saveFile(filePart, fileName);

        bookDAO.updateBook(new Book(id, title, author, fileName, categoryId, null));
        session.setAttribute("message", "Cập nhật thành công!");
        session.setAttribute("messageType", "success");
    }

    private void saveFile(Part part, String fileName) throws IOException {
        File fileSaveDir = new File(UPLOAD_DIR);
        if (!fileSaveDir.exists()) fileSaveDir.mkdirs();
        part.write(UPLOAD_DIR + File.separator + fileName);
    }
}