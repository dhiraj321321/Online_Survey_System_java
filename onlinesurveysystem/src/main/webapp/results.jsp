<%@ page import="java.util.*, java.sql.*, com.login.onlinesurveysystem.util.DBConnection" %>
<%
    Map<Integer, Map<String, List<String>>> resultsByQuestionId = (Map<Integer, Map<String, List<String>>>) request.getAttribute("resultsByQuestionId");
    // Assuming 'resultsByQuestionId' is a Map<Integer (questionId), Map<String (questionText + type), List<String> (answers)>>
    // You would typically fetch questions and their types separately or structure your results map better in the servlet.
    // For this example, I'll fetch question details within JSP for simplicity, but it's better done in the servlet.

    // Get survey_id to fetch questions if it's available in the request
    String surveyIdParam = request.getParameter("survey_id");
    int surveyId = -1;
    if (surveyIdParam != null && !surveyIdParam.isEmpty()) {
        try {
            surveyId = Integer.parseInt(surveyIdParam);
        } catch (NumberFormatException e) {
            // Log or handle error: invalid survey ID
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Survey Results</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-center text-primary"><i class="fas fa-poll me-2"></i> Survey Results</h2>

    <%
        if (resultsByQuestionId != null && !resultsByQuestionId.isEmpty()) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rsQuestionDetails = null;
            try {
                conn = DBConnection.getConnection();
                for (Map.Entry<Integer, Map<String, List<String>>> entry : resultsByQuestionId.entrySet()) {
                    int questionId = entry.getKey();
                    Map<String, List<String>> questionData = entry.getValue();

                    // Fetch question details (text and type)
                    String questionText = "Unknown Question";
                    String questionType = "N/A";

                    String sqlQuestionDetails = "SELECT question_text, question_type FROM questions WHERE id = ?";
                    stmt = conn.prepareStatement(sqlQuestionDetails);
                    stmt.setInt(1, questionId);
                    rsQuestionDetails = stmt.executeQuery();
                    if (rsQuestionDetails.next()) {
                        questionText = rsQuestionDetails.getString("question_text");
                        questionType = rsQuestionDetails.getString("question_type");
                    }
    %>
                <div class="card my-3 shadow-sm">
                    <div class="card-header bg-light d-flex justify-content-between align-items-center">
                        <strong><%= questionText %></strong>
                        <span class="badge bg-info"><%= questionType %></span>
                    </div>
                    <div class="card-body">
                        <%
                            for (Map.Entry<String, List<String>> ansEntry : questionData.entrySet()) {
                                String email = ansEntry.getKey(); // This would be the user_email if results are grouped by user
                                List<String> answers = ansEntry.getValue();
                                if ("MCQ".equals(questionType) || "Short Answer".equals(questionType)) {
                        %>
                                    <h6 class="text-primary mt-3">Responses:</h6>
                                    <ul class="list-group list-group-flush">
                                        <% for (String ans : answers) { %>
                                            <li class="list-group-item">- <%= ans %></li>
                                        <% } %>
                                    </ul>
                        <%
                                } else if ("Rating".equals(questionType)) {
                                    // Calculate average rating or display individual ratings
                                    int sumRatings = 0;
                                    for (String ans : answers) {
                                        try {
                                            sumRatings += Integer.parseInt(ans);
                                        } catch (NumberFormatException e) {
                                            // Ignore invalid ratings
                                        }
                                    }
                                    double averageRating = answers.isEmpty() ? 0 : (double) sumRatings / answers.size();
                        %>
                                    <h6 class="text-primary mt-3">Average Rating: <%= String.format("%.1f", averageRating) %> / 5.0</h6>
                                    <p class="text-muted">Total responses: <%= answers.size() %></p>
                                    <ul class="list-group list-group-flush">
                                        <% for (String ans : answers) { %>
                                            <li class="list-group-item">- Rating: <%= ans %></li>
                                        <% } %>
                                    </ul>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
    <%
                }
            } catch (Exception e) {
                e.printStackTrace();
    %>
            <div class="alert alert-danger text-center" role="alert">
                Failed to load results. Please try again.
            </div>
    <%
            } finally {
                if (rsQuestionDetails != null) try { rsQuestionDetails.close(); } catch (SQLException ignore) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        } else {
    %>
            <div class="alert alert-info text-center py-4 rounded-3 shadow-sm" role="alert">
                <h4 class="alert-heading"><i class="fas fa-info-circle"></i> No Results Available Yet!</h4>
                <p>It looks like no one has responded to this survey yet.</p>
                <hr>
                <p class="mb-0">Share your survey to start collecting responses.</p>
            </div>
    <%
        }
    %>
    <div class="text-center mt-5">
        <a href="SurveyListServlet" class="btn btn-secondary btn-lg"><i class="fas fa-arrow-left me-2"></i> Back to All Surveys</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>