<?php
header('Content-Type: application/json');
$jsonFromPhone = file_get_contents("php://input");
$taskInfo = json_decode($jsonFromPhone, true);
include_once '../connManager.php';
$taskName = $taskInfo['taskName'];
$description = $taskInfo['description'];
$startDate = $taskInfo['startDate'];
$endDate = $_POST['endDate'];
$creator = "1";
$sql = "INSERT INTO task_master (task_name, task_description, time_start, time_end, creator) VALUES (\"" . $taskName . "\", \"" . $description . "\", STR_TO_DATE('" . $startDate . "','%c/%e/%Y %r'), STR_TO_DATE('" . $endDate . "','%c/%e/%Y %r'), '" . $creator . "')";
$conn = new connManager();
$Connection = $conn->GetConnection();
if (!$Connection) {
    echo "Failed to connect to MySQL: " . mysql_error();
}
mysql_query($sql);
$pass = mysql_insert_id();
mysql_close($Connection);
echo mysql_error();
if ($pass > 0) {
    echo "success";
} else {
    echo error_reporting(E_ALL);
}
?>