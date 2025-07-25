<%@ page import="com.login.onlinesurveysystem.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return; // Important to stop further execution
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="dashboard.jsp"><i class="fas fa-chart-line"></i> Dashboard</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="dashboard.jsp"><i class="fas fa-home"></i> Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="createSurvey.jsp"><i class="fas fa-plus-circle"></i> Create Survey</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="SurveyListServlet"><i class="fas fa-list-alt"></i> View All Surveys</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-5">
    <div class="p-5 mb-4 bg-light rounded-3 shadow-sm">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">Welcome, <%= user.getName() %>!</h1>
            <p class="col-md-8 fs-4">Manage your surveys and view results with ease.</p>
            <div class="d-grid gap-2 d-md-flex justify-content-md-start">
                <a href="createSurvey.jsp" class="btn btn-primary btn-lg"><i class="fas fa-plus-square"></i> Create New Survey</a>
                <a href="SurveyListServlet" class="btn btn-outline-info btn-lg"><i class="fas fa-search"></i> Explore Surveys</a>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>