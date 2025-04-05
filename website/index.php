<?php
include 'db.php';
session_start();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);
    $password = $_POST['password'];

    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = :email");
    $stmt->execute(['email' => $email]);
    $user = $stmt->fetch();

    if ($user && password_verify($password, $user['password'])) {
        $_SESSION['user_id'] = $user['id'];
        header("Location: dashboard.php");
        exit();
    } else {
        $error = "Invalid login credentials.";
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
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <img src="logo.png" class="logo" alt="logo">
            <div class="card">
                <div class="card-header text-center">Login</div>
                <div class="card-body">
                    <?php if (isset($error)) echo "<div class='alert alert-danger'>$error</div>"; ?>
                    <form method="POST" novalidate>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="text" name="email" id="email" class="form-control">
                            <small id="email-error" class="error-text d-none">Please enter a valid email address.</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" name="password" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Login</button>
                    </form>
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
