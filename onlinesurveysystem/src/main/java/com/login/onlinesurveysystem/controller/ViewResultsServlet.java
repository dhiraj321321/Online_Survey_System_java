package com.login.onlinesurveysystem.controller;

import com.login.onlinesurveysystem.util.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class ViewResultsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("survey_id");

        // Check if survey_id is missing
        if (idParam == null || idParam.isEmpty()) {
            request.setAttribute("errorMessage", "Missing or invalid survey ID for viewing results.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        int surveyId;
        try {
            surveyId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Survey ID must be a valid number for viewing results.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        // Initialize the map with the structure that results.jsp expects:
        // Map<Question_ID, Map<Question_Detail_Key, List_of_Answers>>
        // The inner map will hold {"question_text": [text], "question_type": [type], "answers": [list_of_answers]}
        Map<Integer, Map<String, List<String>>> resultsByQuestionId = new LinkedHashMap<>();

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // SQL to fetch question details and their answers for the given survey
            String sql = "SELECT q.id AS question_id, q.question_text, q.question_type, a.answer_text " +
                         "FROM questions q " +
                         "LEFT JOIN answers a ON q.id = a.question_id " + // Use LEFT JOIN to include questions with no answers yet
                         "LEFT JOIN responses r ON a.response_id = r.id AND r.survey_id = q.survey_id " + // Link responses to answers and surveys
                         "WHERE q.survey_id = ? " +
                         "ORDER BY q.id, r.submitted_at"; // Order to group by question and then by submission time
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, surveyId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int questionId = rs.getInt("question_id");
                String questionText = rs.getString("question_text");
                String questionType = rs.getString("question_type");
                String answerText = rs.getString("answer_text"); // Can be null if no answers yet for this question

                // Get or create the inner map for this question
                resultsByQuestionId.computeIfAbsent(questionId, k -> {
                    Map<String, List<String>> questionDetails = new LinkedHashMap<>();
                    questionDetails.put("question_text", new ArrayList<>(Collections.singletonList(questionText)));
                    questionDetails.put("question_type", new ArrayList<>(Collections.singletonList(questionType)));
                    questionDetails.put("answers", new ArrayList<>()); // Initialize list for answers
                    return questionDetails;
                });

                // Add the answer if it's not null (meaning there's a response)
                if (answerText != null) {
                    resultsByQuestionId.get(questionId).get("answers").add(answerText);
                }
            }

            // Set the attribute with the correct name and structure
            request.setAttribute("resultsByQuestionId", resultsByQuestionId);
            RequestDispatcher dispatcher = request.getRequestDispatcher("results.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(); // Print stack trace for debugging
            request.setAttribute("errorMessage", "An error occurred while retrieving survey results: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}