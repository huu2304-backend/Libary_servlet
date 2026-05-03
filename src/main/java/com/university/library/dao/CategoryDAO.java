package com.university.library.dao;

import com.university.library.model.Category;
import com.university.library.utils.DBContext;
import java.sql.*;
import java.util.*;

public class CategoryDAO {
    DBContext dbContext = new DBContext();

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Category(rs.getInt("id"), rs.getString("name")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}