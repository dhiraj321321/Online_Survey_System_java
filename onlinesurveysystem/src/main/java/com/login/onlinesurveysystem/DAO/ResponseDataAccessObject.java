/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.login.onlinesurveysystem.DAO;

import com.login.onlinesurveysystem.model.Response;
import com.login.onlinesurveysystem.util.DBConnection;

import java.sql.*;

public class ResponseDataAccessObject {

    public boolean submitResponse(Response response) throws SQLException {
        String sql = "INSERT INTO responses (survey_id, user_email) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, response.getSurveyId());
            stmt.setString(2, response.getUserEmail());
            return stmt.executeUpdate() > 0;
        }
    }
}
