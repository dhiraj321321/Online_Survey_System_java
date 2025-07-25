/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.login.onlinesurveysystem.controller;


import com.login.onlinesurveysystem.DAO.SurveyDataAccessObject;
import com.login.onlinesurveysystem.model.Survey;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/SurveyListServlet")
public class SurveyListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SurveyDataAccessObject dao = new SurveyDataAccessObject();
        try {
            List<Survey> surveys = dao.getAllSurveys();
            request.setAttribute("surveys", surveys);
            RequestDispatcher dispatcher = request.getRequestDispatcher("allSurveys.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}