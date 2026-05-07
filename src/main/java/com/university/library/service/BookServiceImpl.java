package com.university.library.service;

import com.university.library.dao.BookDAO;
import com.university.library.model.Book;
import com.university.library.service.BookService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.List;

public class BookServiceImpl implements BookService {
    private final BookDAO bookDAO = new BookDAO();

    @Override
    public List<Book> getAllBooks() {
        return bookDAO.getAllBooks();
    }

    @Override
    public Book getBookById(int id) {
        return bookDAO.getBookById(id);
    }

    @Override
    public void deleteBook(int id) {
        bookDAO.deleteBook(id);
    }

    @Override
    public void addBook(HttpServletRequest request) throws Exception {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String catIdRaw = request.getParameter("categoryId");

        if (catIdRaw == null) throw new Exception("Vui lòng chọn thể loại!");

        Part filePart = request.getPart("image");
        String fileName = "default.jpg";
        if (filePart != null && filePart.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            saveFile(request, filePart, fileName);
        }

        bookDAO.addBook(new Book(title, author, fileName, Integer.parseInt(catIdRaw)));
    }

    @Override
    public void updateBook(HttpServletRequest request) throws Exception {
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
                ? System.currentTimeMillis() + "_" + filePart.getSubmittedFileName()
                : oldImage;

        if (filePart != null && filePart.getSize() > 0) {
            saveFile(request, filePart, fileName);
        }

        bookDAO.updateBook(new Book(Integer.parseInt(idRaw), title, author, fileName, Integer.parseInt(catIdRaw), null));
    }

    private void saveFile(HttpServletRequest request, Part part, String fileName) throws IOException {
        String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();
        part.write(uploadPath + File.separator + fileName);
    }
}