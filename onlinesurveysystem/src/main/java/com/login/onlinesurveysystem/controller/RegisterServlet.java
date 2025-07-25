/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.login.onlinesurveysystem.controller;

import com.login.onlinesurveysystem.DAO.UserDataAccessObject;
import com.login.onlinesurveysystem.model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = new User();
        user.setName(request.getParameter("name"));
        user.setEmail(request.getParameter("email"));
        user.setPassword(request.getParameter("password"));

        try {
            UserDataAccessObject dao = new UserDataAccessObject();
            if (dao.registerUser(user)) {
                response.sendRedirect("login.jsp");
            } else {
                request.setAttribute("error", "Registration failed.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
