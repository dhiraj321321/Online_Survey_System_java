<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .register-card {
            margin-top: 50px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow rounded register-card">
                <div class="card-header bg-success text-white text-center fs-4">
                    <i class="fas fa-user-plus me-2"></i> Register New Account
                </div>
                <div class="card-body p-4">
                    <% String message = (String) request.getAttribute("message");
                       if (message != null) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <%= message %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>
                    <% String regError = (String) request.getAttribute("registrationError");
                       if (regError != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <%= regError %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>
                    <form action="RegisterServlet" method="post">
                        <div class="mb-3">
                            <label for="name" class="form-label"><i class="fas fa-user me-2"></i> Name</label>
                            <input type="text" id="name" name="name" class="form-control" placeholder="Enter your full name" required/>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label"><i class="fas fa-envelope me-2"></i> Email</label>
                            <input type="email" id="email" name="email" class="form-control" placeholder="name@example.com" required/>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label"><i class="fas fa-lock me-2"></i> Password</label>
                            <input type="password" id="password" name="password" class="form-control" placeholder="Create a password" required/>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-success btn-lg"><i class="fas fa-user-plus me-2"></i> Register</button>
                        </div>
                    </form>
                    <div class="mt-4 text-center">
                        <small>Already have an account? <a href="login.jsp" class="text-decoration-none fw-bold">Login here</a></small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>