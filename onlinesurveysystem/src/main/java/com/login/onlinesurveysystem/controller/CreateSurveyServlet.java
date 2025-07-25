package com.login.onlinesurveysystem.controller;

import com.login.onlinesurveysystem.DAO.SurveyDataAccessObject;
import com.login.onlinesurveysystem.model.Survey;
import com.login.onlinesurveysystem.model.User;
import com.login.onlinesurveysystem.util.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.Enumeration;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CreateSurveyServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- START DEBUGGING LOGS ---
        System.out.println("--- CreateSurveyServlet: Received Parameters ---");
        request.getParameterMap().forEach((name, values) -> {
            System.out.println("Parameter: " + name + " = " + String.join(", ", values));
        });
        System.out.println("--- End Parameter List ---");
        // --- END DEBUGGING LOGS ---

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Survey survey = new Survey();
        survey.setUserId(user.getId());
        survey.setTitle(request.getParameter("title"));
        survey.setDescription(request.getParameter("description"));

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            SurveyDataAccessObject dao = new SurveyDataAccessObject();
            int surveyId = dao.createSurveyAndReturnId(survey);

            System.out.println("Survey created with ID: " + surveyId);

            if (surveyId > 0) {
                String[] questionTexts = request.getParameterValues("questionTexts");
                String[] questionTypes = request.getParameterValues("questionTypes");
                String[] scores = request.getParameterValues("scores");

                if (questionTexts != null && questionTexts.length > 0) {
                    String insertQuestionSQL = "INSERT INTO questions (survey_id, question_text, question_type, score) VALUES (?, ?, ?, ?)";
                    PreparedStatement stmtQuestions = conn.prepareStatement(insertQuestionSQL, Statement.RETURN_GENERATED_KEYS);

                    int[] generatedQuestionIds = new int[questionTexts.length];

                    for (int i = 0; i < questionTexts.length; i++) {
                        stmtQuestions.setInt(1, surveyId);
                        stmtQuestions.setString(2, questionTexts[i]);
                        stmtQuestions.setString(3, questionTypes[i]);
                        
                        int questionScore = 0;
                        try {
                            questionScore = Integer.parseInt(scores[i]);
                        } catch (NumberFormatException e) {
                            System.err.println("Invalid score format for question: " + questionTexts[i] + ". Defaulting to 0.");
                        }
                        stmtQuestions.setInt(4, questionScore);
                        stmtQuestions.executeUpdate();

                        try (ResultSet rs = stmtQuestions.getGeneratedKeys()) {
                            if (rs.next()) {
                                generatedQuestionIds[i] = rs.getInt(1);
                                System.out.println("Question " + (i+1) + " (Text: " + questionTexts[i] + ", Type: " + questionTypes[i] + ") saved with DB ID: " + generatedQuestionIds[i]);
                            }
                        }
                    }
                    stmtQuestions.close();

                    // Process MCQ options
                    // Since the browser is sending 'options[][]', we will retrieve all options this way.
                    // IMPORTANT: This assumes ALL options belong to MCQ questions AND that they are sent
                    // in the correct order corresponding to the MCQ questions that were defined.
                    // This approach is less robust if you have multiple MCQ questions and options
                    // can be added/removed out of order, but it matches the current observed behavior.
                    String[] allSubmittedOptions = request.getParameterValues("options[][]"); // THIS IS THE KEY CHANGE

                    int optionIndex = 0;
                    for (int i = 0; i < questionTexts.length; i++) {
                        if ("MCQ".equals(questionTypes[i])) {
                            // Instead of trying to find specific options[X][], use the global options[][] array
                            // and consume options from it for each MCQ question.
                            // This assumes options are sent consecutively for each MCQ question.

                            System.out.println("Processing options for MCQ question DB ID: " + generatedQuestionIds[i]);
                            String insertOptionSQL = "INSERT INTO options (question_id, option_text, is_correct) VALUES (?, ?, FALSE)";
                            PreparedStatement stmtOptions = conn.prepareStatement(insertOptionSQL);

                            // We need a way to know how many options belong to this specific MCQ question.
                            // The current HTML/JS doesn't clearly delineate this on submission with options[][].
                            // For a simple single-MCQ-question scenario or fixed number of options, this might work.
                            // For now, let's assume `allSubmittedOptions` contains all options consecutively for MCQ questions.
                            // This part might need further refinement if you have multiple MCQ questions and variable options per question.

                            // Temporary simplified approach:
                            // This will iterate through all `options[][]` for every MCQ question.
                            // This is *incorrect* if you have multiple MCQ questions or non-MCQ questions mixed in.
                            // A more robust solution would require re-evaluating the JSP's naming
                            // or structuring the received options differently.
                            
                            // Given the log 'options[][] = sgsg, efsfsef', it implies all options are lumped together.
                            // This requires a different parsing strategy.
                            // We need to associate received 'options[][]' with their parent questions.
                            // The current JS creates a single 'options[][]' param for ALL options.
                            // The only way to link them back to specific questions if they are all lumped under options[][]
                            // is if the number of options is fixed or can be inferred, which is not the case here.

                            // Reverting strategy: The direct fix for 'options[][]' is to iterate through ALL received options
                            // and save them if there's *any* MCQ question. This is a hack and won't work for multiple MCQs.

                            // Corrected approach for `options[][]` parameter:
                            // If JSP is sending 'options[][]' for all options, then we can only insert them
                            // for the *first* MCQ question, or we need a different JS strategy.

                            // LET'S ASSUME FOR NOW: there is only one MCQ question, or all options belong to the first MCQ.
                            // This is a temporary workaround to get data saving.
                            // If `allSubmittedOptions` is not null, try to save them to the current MCQ question.
                            if (allSubmittedOptions != null && generatedQuestionIds[i] > 0) { // Ensure question ID is valid
                                for (String optionText : allSubmittedOptions) { // Use the 'allSubmittedOptions'
                                    if (optionText != null && !optionText.trim().isEmpty()) {
                                        stmtOptions.setInt(1, generatedQuestionIds[i]); // Associate with current MCQ question
                                        stmtOptions.setString(2, optionText.trim());
                                        stmtOptions.addBatch();
                                        System.out.println("Adding option to batch: " + optionText.trim() + " for Q_ID: " + generatedQuestionIds[i]);
                                    }
                                }
                                stmtOptions.executeBatch();
                                stmtOptions.close();
                                System.out.println("Options batch executed for Q_ID: " + generatedQuestionIds[i]);

                                // IMPORTANT: Break after the first MCQ if you assume all options go to one MCQ,
                                // or rethink the JS/HTML naming for options if multiple MCQs are intended.
                                // For the user's specific scenario where options[][] comes, this is a direct response.
                                break; // Only process options for the first MCQ question found.
                            } else {
                                System.out.println("No options submitted for this MCQ question or allSubmittedOptions is null.");
                            }
                        }
                    }
                } else {
                    System.out.println("No questions submitted for survey ID: " + surveyId);
                }

                conn.commit();
                response.sendRedirect("dashboard.jsp");
            } else {
                conn.rollback();
                request.setAttribute("errorMessage", "Failed to create survey. Please try again.");
                request.getRequestDispatcher("createSurvey.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            request.setAttribute("errorMessage", "Database error during survey creation: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw new ServletException("An unexpected error occurred during survey creation: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}