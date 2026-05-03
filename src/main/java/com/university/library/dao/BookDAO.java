package com.university.library.dao;

import com.university.library.model.Book;
import com.university.library.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    DBContext dbContext = new DBContext();

    public List<Book> getAllBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS category_name FROM books b " +
                "LEFT JOIN categories c ON b.category_id = c.id";

        try (Connection connection = dbContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String author = rs.getString("author");
                String imagePath = rs.getString("image_path");
                int categoryId = rs.getInt("category_id");
                String categoryName = rs.getString("category_name");
                Book book = new Book(id, title, author, imagePath, categoryId, categoryName);
                list.add(book);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addBook(Book book) {
        String sql = "INSERT INTO books (title, author, image_path, category_id) VALUES (?, ?, ?, ?)";
        try (Connection connection = dbContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setString(3, book.getImagePath());
            ps.setInt(4, book.getCategoryId());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void deleteBook(int id) {
        String sql = "DELETE FROM books WHERE id = ?";
        try (Connection connection = dbContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Book getBookById(int id) {
        String sql = "SELECT * FROM books WHERE id = ?";
        try (Connection connection = dbContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String title = rs.getString("title");
                    String author = rs.getString("author");
                    String imagePath = rs.getString("image_path");
                    int categoryId = rs.getInt("category_id");
                    return new Book(id, title, author, imagePath, categoryId, null);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public void updateBook(Book book) {
        String sql = "UPDATE books SET title = ?, author = ?, image_path = ?, category_id = ? WHERE id = ?";
        try (Connection connection = dbContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setString(3, book.getImagePath());
            ps.setInt(4, book.getCategoryId());
            ps.setInt(5, book.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}