package com.university.library.dao;
import com.university.library.model.User;
import com.university.library.utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
    private DBContext dbContext = new DBContext();

    public User checkLogin(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection connection = dbContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)
        ) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("id");
                String role = rs.getString("role");
                return new User(id, username, password, role);
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }
}
