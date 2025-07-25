<%@ page import="java.sql.*, java.util.*, com.login.onlinesurveysystem.util.DBConnection" %>
<%
    String surveyIdParam = request.getParameter("id");
    int surveyId = -1;
    if (surveyIdParam != null && !surveyIdParam.isEmpty()) {
        try {
            surveyId = Integer.parseInt(surveyIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("error.jsp?message=Invalid Survey ID");
            return;
        }
    } else {
        response.sendRedirect("error.jsp?message=Survey ID is missing");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Survey</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-center text-primary">Survey Questions</h2>
    <form action="SubmitResponseServlet" method="post" class="mt-4">
        <input type="hidden" name="survey_id" value="<%= surveyId %>" />
        <div class="mb-3">
            <label for="userEmail" class="form-label">Your Email</label>
            <input type="email" id="userEmail" name="email" class="form-control" placeholder="Enter your email" required />
        </div>

        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rsQuestions = null;
            PreparedStatement stmtOptions = null; // New PreparedStatement for options
            ResultSet rsOptions = null;         // New ResultSet for options

            try {
                conn = DBConnection.getConnection();
                String sqlQuestions = "SELECT id, question_text, question_type FROM questions WHERE survey_id = ? ORDER BY id ASC";
                stmt = conn.prepareStatement(sqlQuestions);
                stmt.setInt(1, surveyId);
                rsQuestions = stmt.executeQuery();
                int qNum = 1;
                boolean hasQuestions = false;
                while (rsQuestions.next()) {
                    hasQuestions = true;
                    int questionId = rsQuestions.getInt("id");
                    String questionText = rsQuestions.getString("question_text");
                    String questionType = rsQuestions.getString("question_type");
        %>
                <div class="card my-3 shadow-sm">
                    <div class="card-header bg-light">
                        <strong>Q<%= qNum %>. <%= questionText %></strong>
                        <span class="badge bg-info float-end"><%= questionType %></span>
                    </div>
                    <div class="card-body">
                        <% if ("Short Answer".equals(questionType)) { %>
                            <textarea name="q_<%= questionId %>" class="form-control" rows="3" placeholder="Your answer here..." required></textarea>
                        <% } else if ("MCQ".equals(questionType)) { %>
                            <%
                                // Fetch options from the 'options' table for this question
                                String sqlOptions = "SELECT id, option_text FROM options WHERE question_id = ?";
                                stmtOptions = conn.prepareStatement(sqlOptions);
                                stmtOptions.setInt(1, questionId);
                                rsOptions = stmtOptions.executeQuery();
                                
                                boolean hasOptions = false;
                                while (rsOptions.next()) {
                                    hasOptions = true;
                                    int optionId = rsOptions.getInt("id");
                                    String optionText = rsOptions.getString("option_text");
                            %>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="q_<%= questionId %>" id="mcq_<%= questionId %>_option_<%= optionId %>" value="<%= optionText %>" required>
                                    <label class="form-check-label" for="mcq_<%= questionId %>_option_<%= optionId %>">
                                        <%= optionText %>
                                    </label>
                                </div>
                            <%
                                }
                                if (!hasOptions) {
                            %>
                                <div class="alert alert-warning mt-2" role="alert">
                                    No options available for this MCQ question.
                                </div>
                            <%
                                }
                            %>
                        <% } else if ("Rating".equals(questionType)) { %>
                            <label for="rating_<%= questionId %>" class="form-label">Rate (1-5)</label>
                            <input type="number" id="rating_<%= questionId %>" name="q_<%= questionId %>" class="form-control" min="1" max="5" placeholder="Enter a rating from 1 to 5" required />
                        <% } else { %>
                            <p class="text-danger">Unsupported question type.</p>
                            <textarea name="q_<%= questionId %>" class="form-control" rows="3" placeholder="Your answer here..." required></textarea>
                        <% } %>
                    </div>
                </div>
        <%
                    qNum++;
                }
                if (!hasQuestions) {
        %>
                    <div class="alert alert-info text-center" role="alert">
                        This survey has no questions yet.
                    </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
                <div class="alert alert-danger text-center" role="alert">
                    Failed to load questions. Please try again.
                </div>
        <%
            } finally {
                // Close all resources in finally blocks
                if (rsOptions != null) try { rsOptions.close(); } catch (SQLException ignore) {}
                if (stmtOptions != null) try { stmtOptions.close(); } catch (SQLException ignore) {}
                if (rsQuestions != null) try { rsQuestions.close(); } catch (SQLException ignore) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        %>
        <div class="d-grid gap-2">
            <button type="submit" class="btn btn-primary btn-lg mt-4"><i class="fas fa-check-circle"></i> Submit Survey</button>
        </div>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>