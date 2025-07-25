package com.login.onlinesurveysystem.controller;

import com.login.onlinesurveysystem.DAO.SurveyDataAccessObject;
import com.login.onlinesurveysystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class DeleteSurveyServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        // Ensure user is logged in
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String surveyIdParam = request.getParameter("id");
        if (surveyIdParam == null || surveyIdParam.isEmpty()) {
            response.sendRedirect("error.jsp?message=Survey ID is missing for deletion.");
            return;
        }

        int surveyId = -1;
        try {
            surveyId = Integer.parseInt(surveyIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("error.jsp?message=Invalid Survey ID format for deletion.");
            return;
        }

        SurveyDataAccessObject surveyDao = new SurveyDataAccessObject();
        try {
            boolean deleted = surveyDao.deleteSurvey(surveyId);
            if (deleted) {
                response.sendRedirect("SurveyListServlet?status=deleted"); // Redirect with success status
            } else {
                response.sendRedirect("SurveyListServlet?status=deleteFailed"); // Redirect with failure status
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Redirect to error page with a message
            response.sendRedirect("error.jsp?message=Database error during survey deletion: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=An unexpected error occurred during survey deletion.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Typically, deletion via a button is a GET request, but you can add POST handling if needed.
        doGet(request, response);
    }
}