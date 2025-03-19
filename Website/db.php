<?php
$host = "host";
$port = "port";
$dbname = "db";
$user = "user";
$password = "pwd";

try {
    $pdo = new PDO("pgsql:host=$host;port=$port;dbname=$dbname;sslmode=require", $user, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
} catch (PDOException $e) {
    die("Database connection error: " . $e->getMessage());
}
?>
