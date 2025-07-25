package com.login.onlinesurveysystem.controller;

import javax.servlet.annotation.WebServlet; // Make sure this import exists
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; // You'll likely need this for logout logic
import java.io.IOException;

@WebServlet("/LogoutServlet") // Add this annotation
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Do not create if doesn't exist
        if (session != null) {
            session.invalidate(); // Invalidate the session
        }
        response.sendRedirect("index.jsp"); // Redirect to home page or login page
    }

    // You might also handle POST if your logout button uses form submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Often, POST just calls GET for logout
    }
}