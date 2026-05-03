package com.university.library.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {
    // Lấy thông tin từ Biến môi trường (Environment Variables)
    // Nếu không tìm thấy biến môi trường, nó sẽ dùng giá trị mặc định (localhost) để bạn vẫn code được ở máy
    private static final String DB_URL = System.getenv("DB_URL") != null
            ? System.getenv("DB_URL")
            : "jdbc:mysql://localhost:3306/librray_manage";

    private static final String DB_USER = System.getenv("DB_USER") != null
            ? System.getenv("DB_USER")
            : "root";

    private static final String DB_PASSWORD = System.getenv("DB_PASSWORD") != null
            ? System.getenv("DB_PASSWORD")
            : "23042003";

    public Connection getConnection() throws Exception {
        // Khai báo Driver cho MySQL
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}