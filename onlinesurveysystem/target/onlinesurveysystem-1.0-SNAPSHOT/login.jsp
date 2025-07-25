<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-card {
            margin-top: 50px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow rounded login-card">
                <div class="card-header bg-primary text-white text-center fs-4">
                    <i class="fas fa-user-circle me-2"></i> User Login
                </div>
                <div class="card-body p-4">
                    <% String errorMessage = (String) request.getAttribute("errorMessage");
                       if (errorMessage != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <%= errorMessage %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>
                    <form action="LoginServlet" method="post">
                        <div class="mb-3">
                            <label for="email" class="form-label"><i class="fas fa-envelope me-2"></i> Email address</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label"><i class="fas fa-lock me-2"></i> Password</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg"><i class="fas fa-sign-in-alt me-2"></i> Login</button>
                        </div>
                    </form>
                    <div class="mt-4 text-center">
                        <small>Don't have an account? <a href="register.jsp" class="text-decoration-none fw-bold">Register here</a></small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>