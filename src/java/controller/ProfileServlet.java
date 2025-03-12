package controller;

import dao.OrderDAO;
import model.Order;
import model.User;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = SessionUtil.getUser(request.getSession());
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get recent orders for the user
        List<Order> recentOrders = orderDAO.findRecentByUserId(user.getId(), 5);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("user", user);
        
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
