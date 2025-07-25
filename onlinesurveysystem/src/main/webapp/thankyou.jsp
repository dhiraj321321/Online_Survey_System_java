<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thank You!</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .thank-you-container {
            min-height: 80vh; /* Make it take most of the viewport height */
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }
        .thank-you-card {
            background-color: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            max-width: 600px;
            width: 100%;
        }
        .thank-you-icon {
            color: #28a745; /* Green checkmark */
            font-size: 5rem;
            margin-bottom: 20px;
            animation: bounceIn 1s ease-out;
        }
        @keyframes bounceIn {
            0% { transform: scale(0.1); opacity: 0; }
            60% { transform: scale(1.2); opacity: 1; }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>
    <div class="container thank-you-container">
        <div class="thank-you-card">
            <div class="thank-you-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h1 class="display-4 text-success mb-3">Thank You!</h1>
            <p class="lead">Your survey response has been successfully submitted.</p>
            <p class="text-muted">We highly appreciate your valuable feedback.</p>
            <hr class="my-4">
            <a href="index.jsp" class="btn btn-primary btn-lg mt-3">
                <i class="fas fa-home me-2"></i> Go to Homepage
            </a>
            </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>