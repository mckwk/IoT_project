<?php
include 'db.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);
    $password = password_hash($_POST['password'], PASSWORD_BCRYPT);

    try {
        $stmt = $pdo->prepare("INSERT INTO users (email, password) VALUES (:email, :password)");
        $stmt->execute(['email' => $email, 'password' => $password]);
    } catch (PDOException $e) {
        echo 'Error';
    }

    header("Location: index.php");
    exit();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <img src="logo.png" class="logo" alt="logo">
            <div class="card">
                <div class="card-header text-center">Register</div>
                <div class="card-body">
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
                        <button type="submit" class="btn btn-primary w-100">Register</button>
                    </form>
                </div>
            </div>
            <p class="mt-3 text-center">
                <a href="index.php" class="fancy-link">Already have an account? <strong>Login</strong></a>
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
