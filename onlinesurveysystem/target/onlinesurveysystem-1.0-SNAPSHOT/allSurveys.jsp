<%@ page import="java.util.*, com.login.onlinesurveysystem.model.Survey" %>
<%
    List<Survey> surveys = (List<Survey>) request.getAttribute("surveys");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Surveys</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background: #f8f9fa;
        }
        .survey-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        .survey-card:hover {
            transform: translateY(-5px); /* Slightly lift card on hover */
            box-shadow: 0 6px 12px rgba(0,0,0,0.15); /* More prominent shadow on hover */
        }
        .survey-title {
            font-size: 1.5rem; /* Slightly larger title */
            font-weight: bold;
            color: #007bff; /* Primary color for titles */
            margin-bottom: 10px;
        }
        .survey-desc {
            font-size: 1rem;
            color: #6c757d;
            margin-bottom: 15px;
        }
        .btn-sm-custom { /* Custom class for slightly larger small buttons */
            padding: .375rem .75rem;
            font-size: .9rem;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="dashboard.jsp">Survey Dashboard</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item">
          <a class="nav-link" href="createSurvey.jsp"><i class="fas fa-plus-circle"></i> Create Survey</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="SurveyListServlet"><i class="fas fa-list-alt"></i> All Surveys</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<div class="container py-5">
    <h2 class="mb-5 text-center text-primary">Available Surveys</h2>
    <div class="row justify-content-center">
        <% if (surveys != null && !surveys.isEmpty()) {
            for (Survey s : surveys) { %>
                <div class="col-md-6 col-lg-4 d-flex align-items-stretch">
                    <div class="survey-card w-100">
                        <div class="survey-title"><%= s.getTitle() %></div>
                        <p class="survey-desc"><%= s.getDescription() %></p>
                        <div class="d-flex justify-content-between mt-4">
                            <a href="viewSurvey.jsp?id=<%= s.getId() %>" class="btn btn-outline-primary btn-sm-custom"><i class="fas fa-eye"></i> View Survey</a>
                            <a href="ViewResultsServlet?survey_id=<%= s.getId() %>" class="btn btn-outline-success btn-sm-custom"><i class="fas fa-poll"></i> View Results</a>
                            <a href="DeleteSurveyServlet?id=<%= s.getId() %>" 
                               class="btn btn-outline-danger btn-sm-custom" 
                               onclick="return confirm('Are you sure you want to delete this survey and all its associated data (questions, options, responses)?');">
                                <i class="fas fa-trash-alt"></i> Delete
                            </a>
                        </div>
                    </div>
                </div>
        <%  } } else { %>
            <div class="col-12">
                <div class="alert alert-info text-center py-4 rounded-3 shadow-sm" role="alert">
                    <h4 class="alert-heading"><i class="fas fa-info-circle"></i> No Surveys Available!</h4>
                    <p>It looks like there are no surveys created yet.</p>
                    <hr>
                    <p class="mb-0">Why not <a href="createSurvey.jsp" class="alert-link">create a new one</a> now?</p>
                </div>
            </div>
        <% } %>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>