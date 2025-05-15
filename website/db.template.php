<?php
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

session_set_cookie_params([
    'lifetime' => 0,
    'path' => '/',
    'secure' => true,
    'httponly' => true,
    'samesite' => 'Lax'
]);

$host = "host";
$port = "port";
$dbname = "db";
$user = "user";
$password = "pwd";

try {
    $pdo = new PDO("pgsql:host=$host;port=$port;dbname=$dbname;sslmode=require", $user, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_EMULATE_PREPARES => false
    ]);
} catch (PDOException $e) {
    die("Database connection error: " . $e->getMessage());
}
?>