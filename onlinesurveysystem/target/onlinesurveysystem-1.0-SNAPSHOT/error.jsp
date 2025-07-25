<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body>
<div class="container error-container">
    <div class="alert alert-danger text-center p-5 rounded-3 shadow-lg" role="alert">
        <i class="fas fa-exclamation-triangle fa-5x mb-3"></i>
        <h4 class="alert-heading display-4">Oops! Something went wrong...</h4>
        <p class="lead">We apologize for the inconvenience. An unexpected error occurred.</p>
        <hr>
        <p>Please try again later. If the problem persists, contact support.</p>
        <a href="index.jsp" class="btn btn-danger btn-lg mt-3"><i class="fas fa-home"></i> Go to Home Page</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>