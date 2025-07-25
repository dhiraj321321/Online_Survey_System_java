<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Online Survey System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://via.placeholder.com/1500x800?text=Survey+Background') no-repeat center center; /* Replace with your actual background image */
            background-size: cover;
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        .hero-section h1 {
            font-size: 3.5rem;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .hero-section p {
            font-size: 1.5rem;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="index.jsp"><i class="fas fa-poll-h"></i> Survey System</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item">
          <a class="nav-link" href="login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="register.jsp"><i class="fas fa-user-plus"></i> Register</a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<div class="hero-section">
    <div class="container">
        <h1>Welcome to the Online Survey System</h1>
        <p class="lead">Create, participate in, and analyze surveys effortlessly.</p>
        <a href="login.jsp" class="btn btn-primary btn-lg me-3"><i class="fas fa-sign-in-alt"></i> Get Started - Login</a>
        <a href="register.jsp" class="btn btn-outline-light btn-lg"><i class="fas fa-user-plus"></i> Register Now</a>
    </div>
</div>

<div class="container py-5 text-center">
    <h2 class="mb-4 text-primary">Key Features</h2>
    <div class="row row-cols-1 row-cols-md-3 g-4">
        <div class="col">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <i class="fas fa-edit fa-3x text-success mb-3"></i>
                    <h5 class="card-title">Easy Survey Creation</h5>
                    <p class="card-text">Design and customize surveys with various question types.</p>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <i class="fas fa-chart-bar fa-3x text-info mb-3"></i>
                    <h5 class="card-title">Insightful Results</h5>
                    <p class="card-text">View and analyze survey responses with clear visualizations.</p>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <i class="fas fa-users fa-3x text-warning mb-3"></i>
                    <h5 class="card-title">Simple Participation</h5>
                    <p class="card-text">Invite participants easily and collect responses efficiently.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>