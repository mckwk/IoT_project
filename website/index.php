<?php
include 'db.php';
session_start();

// Prevent caching to protect the session
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Pragma: no-cache");
header("Expires: 0");

// Secure against session theft by forcing HTTPS
header("Strict-Transport-Security: max-age=31536000; includeSubDomains");

//Avoid clickjacking
header("X-Frame-Options: DENY");

// Protect against MIME sniffing
header("X-Content-Type-Options: nosniff");

// Control the referer transmission
header("Referrer-Policy: no-referrer");


// create a CSRF token
if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = filter_var($_POST['email'], FILTER_VALIDATE_EMAIL);
    $password = $_POST['password'];

    if (!$email) {
        $error = "Invalid email format.";
    } else {
        if (!isset($_SESSION['login_attempts'])) {
            $_SESSION['login_attempts'] = 0;
        }

        if ($_SESSION['login_attempts'] >= 5) {
            $error = "Too many failed login attempts. Please try again later.";
        } else {
            $stmt = $pdo->prepare("SELECT * FROM users WHERE email = :email");
            $stmt->execute(['email' => $email]);
            $user = $stmt->fetch();

            if ($user && password_verify($password, $user['password'])) {
                session_regenerate_id(true);
                $_SESSION['user_id'] = $user['id'];
                $_SESSION['login_attempts'] = 0;
                header("Location: dashboard.php");
                exit();
            } else {
                $_SESSION['login_attempts']++;
                $error = "Invalid login credentials.";
            }
        }
    }
}


?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>

<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <img src="logo.png" class="logo" alt="logo">
                <div class="card">
                    <div class="card-header text-center">Login</div>
                    <div class="card-body">
                        <?php if (isset($error))
                            echo "<div class='alert alert-danger'>" . htmlspecialchars($error) . "</div>"; ?>
                        <form method="POST">
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Login</button>
                        </form>
                    </div>
            </div>
        </div>
    </div>
            <p class="mt-3 text-center">
                <a href="register.php" class="fancy-link">Don't have an account? <strong>Register</strong></a>
            </p>
        </div>
    </div>
</div>

<script>
document.querySelector("form").addEventListener("submit", function (e) {
    const email = document.getElementById("email");
    const error = document.getElementById("email-error");
    const valid = /^[^@]+@[^@]+\.[^@]+$/.test(email.value);

    if (!valid) {
        e.preventDefault();
        error.classList.remove("d-none");
        email.classList.add("is-invalid");
    } else {
        error.classList.add("d-none");
        email.classList.remove("is-invalid");
    }
});
</script>
</body>

</html>