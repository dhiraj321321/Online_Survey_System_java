package com.login.onlinesurveysystem.DAO;

import com.login.onlinesurveysystem.model.Survey;
import com.login.onlinesurveysystem.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SurveyDataAccessObject {

    public boolean createSurvey(Survey survey) throws SQLException {
        String sql = "INSERT INTO surveys (user_id, title, description) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, survey.getUserId());
            stmt.setString(2, survey.getTitle());
            stmt.setString(3, survey.getDescription());
            return stmt.executeUpdate() > 0;
        }
    }

    public int createSurveyAndReturnId(Survey survey) throws SQLException {
        String sql = "INSERT INTO surveys (user_id, title, description, created_at) VALUES (?, ?, ?, NOW())";
        int generatedId = -1;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, survey.getUserId());
            stmt.setString(2, survey.getTitle());
            stmt.setString(3, survey.getDescription());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        }
        return generatedId;
    }

    public void insertOption(int questionId, String optionText) throws SQLException {
        String sql = "INSERT INTO options (question_id, option_text, is_correct) VALUES (?, ?, FALSE)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, questionId);
            stmt.setString(2, optionText);
            stmt.executeUpdate();
        }
    }

    // NEW METHOD: Deletes a survey and all its associated data
    public boolean deleteSurvey(int surveyId) throws SQLException {
        Connection conn = null;
        boolean success = false;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Get all question IDs for this survey
            List<Integer> questionIds = new ArrayList<>();
            String getQuestionsSql = "SELECT id FROM questions WHERE survey_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(getQuestionsSql)) {
                stmt.setInt(1, surveyId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        questionIds.add(rs.getInt("id"));
                    }
                }
            }

            // 2. Delete answers linked to responses of this survey's questions
            // This requires getting response IDs first
            List<Integer> responseIds = new ArrayList<>();
            String getResponsesSql = "SELECT id FROM responses WHERE survey_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(getResponsesSql)) {
                stmt.setInt(1, surveyId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        responseIds.add(rs.getInt("id"));
                    }
                }
            }
            if (!responseIds.isEmpty()) {
                // Delete answers associated with these responses
                String deleteAnswersSql = "DELETE FROM answers WHERE response_id = ANY (?)"; // Use ANY for array of IDs
                try (PreparedStatement stmt = conn.prepareStatement(deleteAnswersSql)) {
                    Array responseIdArray = conn.createArrayOf("INTEGER", responseIds.toArray()); // Create SQL array
                    stmt.setArray(1, responseIdArray);
                    stmt.executeUpdate();
                }
            }


            // 3. Delete options for questions of this survey
            if (!questionIds.isEmpty()) {
                String deleteOptionsSql = "DELETE FROM options WHERE question_id = ANY (?)";
                try (PreparedStatement stmt = conn.prepareStatement(deleteOptionsSql)) {
                    Array questionIdArray = conn.createArrayOf("INTEGER", questionIds.toArray());
                    stmt.setArray(1, questionIdArray);
                    stmt.executeUpdate();
                }
            }

            // 4. Delete questions for this survey
            String deleteQuestionsSql = "DELETE FROM questions WHERE survey_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteQuestionsSql)) {
                stmt.setInt(1, surveyId);
                stmt.executeUpdate();
            }

            // 5. Delete responses for this survey
            String deleteResponsesSql = "DELETE FROM responses WHERE survey_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteResponsesSql)) {
                stmt.setInt(1, surveyId);
                stmt.executeUpdate();
            }

            // 6. Finally, delete the survey itself
            String deleteSurveySql = "DELETE FROM surveys WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteSurveySql)) {
                stmt.setInt(1, surveyId);
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    success = true;
                }
            }

            conn.commit(); // Commit transaction
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e; // Re-throw to be caught by servlet
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return success;
    }

    public List<Survey> getAllSurveys() throws SQLException {
        List<Survey> surveys = new ArrayList<>();
        String sql = "SELECT * FROM surveys";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Survey s = new Survey();
                s.setId(rs.getInt("id"));
                s.setUserId(rs.getInt("user_id"));
                s.setTitle(rs.getString("title"));
                s.setDescription(rs.getString("description"));
                surveys.add(s);
            }
        }
        return surveys;
    }
}