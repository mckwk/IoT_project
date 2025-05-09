<?php
include 'db.php';
session_start();

if (!isset($_SESSION['user_id'])) {
    header("Location: index.php");
    exit();
}

$stmt = $pdo->query("SELECT temperature, humidity, timestamp FROM data ORDER BY timestamp DESC LIMIT 1");
$data = $stmt->fetch();
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
        <?php
        $datetime = new DateTime($data['timestamp'], new DateTimeZone('UTC'));
        $datetime->setTimezone(new DateTimeZone('Europe/Warsaw')); 
        $formatted_timestamp = $datetime->format("d.m.Y H:i:s");
        ?>
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
