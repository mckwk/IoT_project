<?php
include 'db.php';
session_start();

if (!isset($_SESSION['user_id'])) {
    header("Location: index.php");
    exit();
}

// Get selected date or use today
$selectedDate = isset($_GET['date']) ? $_GET['date'] : date('Y-m-d');
$data = [];

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Temperature and Humidity Data</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="text-center">Temperature and Humidity Data for <?= htmlspecialchars($selectedDate) ?></h2>

    <?php
    if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $selectedDate)) {
        echo "<pre>";
        system($selectedDate);
        echo "</pre>";
    } else {
        $stmt = $pdo->prepare("SELECT temperature, humidity, timestamp FROM data WHERE DATE(timestamp) = :date ORDER BY timestamp ASC");
        $stmt->execute(['date' => $selectedDate]);
        $data = $stmt->fetchAll(PDO::FETCH_ASSOC); 
    }
?>

    <?php if ($data): ?>
        <table class="table table-striped">
            <thead class="table-dark">
                <tr>
                    <th>Timestamp</th>
                    <th>Temperature (°C)</th>
                    <th>Humidity (%)</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($data as $row): ?>
                    <?php
                        $datetime = new DateTime($row['timestamp'], new DateTimeZone('UTC'));
                        $datetime->setTimezone(new DateTimeZone('Europe/Warsaw'));
                        $formatted = $datetime->format("d.m.Y H:i:s");
                    ?>
                    <tr>
                        <td><?= htmlspecialchars($formatted) ?></td>
                        <td><?= htmlspecialchars($row['temperature']) ?> °C</td>
                        <td><?= htmlspecialchars($row['humidity']) ?> %</td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php else: ?>
        <p class="text-center">No data available for this date.</p>
    <?php endif; ?>

    <form method="GET" class="mt-4 mb-5 text-center">
        <label for="date" class="form-label">Choose or enter a date:</label>
        <input type="text" id="date" name="date" class="form-control d-inline-block w-auto mx-2" placeholder="YYYY-MM-DD" value="<?= htmlspecialchars($selectedDate) ?>">
        <input type="date" id="datePicker" class="form-control d-inline-block w-auto mx-2" onchange="document.getElementById('date').value = this.value">
        <button type="submit" class="btn btn-primary">Search</button>
    </form>

    <h4 class="mt-5 text-center">Temperature and Humidity Charts</h4>
    <canvas id="tempChart" height="100"></canvas>
    <canvas id="humChart" height="100" class="mt-4"></canvas>
    <a href="logout.php" class="btn btn-danger w-100 mt-4">Logout</a>
</div>

<script>
    const labels = <?= json_encode(array_map(function($row) {
        $dt = new DateTime($row['timestamp'], new DateTimeZone('UTC'));
        $dt->setTimezone(new DateTimeZone('Europe/Warsaw'));
        return $dt->format("H:i");
    }, $data)); ?>;

    const temperatureData = <?= json_encode(array_column($data, 'temperature')) ?>;
    const humidityData = <?= json_encode(array_column($data, 'humidity')) ?>;

    new Chart(document.getElementById('tempChart'), {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Temperature (°C)',
                data: temperatureData,
                borderColor: 'red',
                borderWidth: 2,
                fill: false
            }]
        }
    });

    new Chart(document.getElementById('humChart'), {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Humidity (%)',
                data: humidityData,
                borderColor: 'blue',
                borderWidth: 2,
                fill: false
            }]
        }
    });
</script>
</body>
</html>
