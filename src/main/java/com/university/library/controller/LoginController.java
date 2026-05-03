package com.university.library.controller;
import com.university.library.dao.UserDAO;
import com.university.library.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import static com.university.library.utils.AppConstants.*;
@WebServlet(name = "loginController", urlPatterns = {URL_LOGIN ,URL_LOGOUT})
public class LoginController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if (URL_LOGOUT.equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + URL_LOGIN);
            return;
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userParam = request.getParameter("username");
        String passParam = request.getParameter("password");
        User user = userDAO.checkLogin(userParam, passParam);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + URL_ADMIN_BOOKS);
            } else {
                response.sendRedirect(request.getContextPath() + URL_HOME);
            }
        }else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}