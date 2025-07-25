package com.login.onlinesurveysystem.controller;

import com.login.onlinesurveysystem.util.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime; // For submitted_at timestamp
import java.time.format.DateTimeFormatter;
import java.util.Map;

public class SubmitResponseServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- START DEBUGGING LOGS ---
        System.out.println("--- SubmitResponseServlet: Received Parameters ---");
        request.getParameterMap().forEach((name, values) -> {
            System.out.println("Parameter: " + name + " = " + String.join(", ", values));
        });
        System.out.println("--- End Parameter List ---");
        // --- END DEBUGGING LOGS ---

        int surveyId = -1;
        try {
            surveyId = Integer.parseInt(request.getParameter("survey_id"));
        } catch (NumberFormatException e) {
            System.err.println("Invalid survey_id received: " + request.getParameter("survey_id"));
            request.setAttribute("errorMessage", "Invalid survey ID provided.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email is required to submit the survey.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Insert into responses table and get the generated ID
            String insertResponseSQL = "INSERT INTO responses (survey_id, user_email, submitted_at) VALUES (?, ?, NOW())"; // Added submitted_at
            
            // Use Statement.RETURN_GENERATED_KEYS to retrieve the auto-generated ID
            PreparedStatement responseStmt = conn.prepareStatement(insertResponseSQL, Statement.RETURN_GENERATED_KEYS);
            responseStmt.setInt(1, surveyId);
            responseStmt.setString(2, email);

            int rowsAffected = responseStmt.executeUpdate(); // Use executeUpdate() for INSERT

            int responseId = -1;
            if (rowsAffected > 0) {
                try (ResultSet rs = responseStmt.getGeneratedKeys()) { // Get generated keys
                    if (rs.next()) {
                        responseId = rs.getInt(1); // Retrieve the generated ID
                        System.out.println("Response recorded with ID: " + responseId + " for survey: " + surveyId); // Debugging
                    }
                }
            }
            responseStmt.close(); // Close statement

            if (responseId == -1) {
                conn.rollback();
                request.setAttribute("errorMessage", "Failed to record survey response. Please try again.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            // 2. Save answers
            // Use request.getParameterMap() to iterate through all parameters.
            // Be mindful that request.getParameterMap().keySet() might include parameters
            // other than 'q_X' (like survey_id, email, etc.).
            for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
                String paramName = entry.getKey();
                if (paramName.startsWith("q_")) {
                    int questionId = -1;
                    try {
                        questionId = Integer.parseInt(paramName.substring(2));
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid question ID format for parameter: " + paramName);
                        continue; // Skip this parameter if ID is invalid
                    }
                    
                    String[] answers = entry.getValue(); // Get all values for this parameter

                    // If a question has multiple answers (e.g., checkboxes), this loop handles them.
                    // For radio buttons or text inputs, there will typically be only one answer.
                    for (String answer : answers) {
                        if (answer != null && !answer.trim().isEmpty()) { // Only save non-empty answers
                            String insertAnswerSQL = "INSERT INTO answers (response_id, question_id, answer_text) VALUES (?, ?, ?)";
                            try (PreparedStatement answerStmt = conn.prepareStatement(insertAnswerSQL)) {
                                answerStmt.setInt(1, responseId);
                                answerStmt.setInt(2, questionId);
                                answerStmt.setString(3, answer.trim());
                                answerStmt.executeUpdate();
                                System.out.println("Answer saved for Q_ID: " + questionId + ", Answer: " + answer.trim()); // Debugging
                            }
                        } else {
                            System.out.println("Skipping empty answer for Q_ID: " + questionId); // Debugging
                        }
                    }
                }
            }

            conn.commit(); // Commit transaction
            response.sendRedirect("thankyou.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on SQL error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            request.setAttribute("errorMessage", "Database error during survey submission: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on other errors
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw new ServletException("An unexpected error occurred during survey submission: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close(); // Close connection
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}