<?php
session_start();
require_once 'api.php';

if (!isset($_SESSION['email'])) {
    header("Location: index.php");
    exit();
}

$data = api_get('/data');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Latest Temperature Data</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        setTimeout(function() {
            location.reload();
        }, 60000); // Refresh every 1 minute
    </script>
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="text-center">Latest Temperature Reading</h2>
    <?php if ($data): ?>
        <?php $formatted_timestamp = date("d.m.Y H:i:s", strtotime($data['timestamp'])); ?>
        <table class="table table-striped">
            <thead class="table-dark">
                <tr>
                    <th>Timestamp</th>
                    <th>Temperature (°C)</th>
                    <th>Humidity (%)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><?= htmlspecialchars($formatted_timestamp) ?></td>
                    <td><?= htmlspecialchars($data['temperature']) ?> °C</td>
                    <td><?= htmlspecialchars($data['humidity']) ?> %</td>
                </tr>
            </tbody>
        </table>
    <?php else: ?>
        <p class="text-center">No data available</p>
    <?php endif; ?>
    <a href="logout.php" class="btn btn-danger w-100">Logout</a>
</div>
</body>
</html>
