package com.university.library.service;

import com.university.library.model.Book;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.util.List;

public interface BookService {
    List<Book> getAllBooks();
    Book getBookById(int id);
    void addBook(HttpServletRequest request) throws Exception;
    void updateBook(HttpServletRequest request) throws Exception;
    void deleteBook(int id);
}