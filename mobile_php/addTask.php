<?php
header('Content-Type: application/json');
$jsonFromPhone = file_get_contents("php://input");
$taskInfo = json_decode($jsonFromPhone, true);
include_once '../connManager.php';
$endArray = array();
$lastUpdated = $taskInfo['last_updated'];
$creator = ['creator_id'];
$creator = '1';
foreach ($taskInfo as $a) {
    $taskName = $a['taskName'];
    $description = $a['description'];
    $startDate = $a['startDate'];
    $endDate = $a['endDate'];
    $status = $a['status'];
    $oldId = $a['id'];
    if ($status == 'create') {
        $sql = "INSERT INTO task_master (task_name, task_description, time_start, time_end, creator, last_updated) VALUES (\"" . $taskName . "\", \"" . $description . "\", STR_TO_DATE('" . $startDate . "','%c/%e/%Y %r'), STR_TO_DATE('" . $endDate . "','%c/%e/%Y %r'), '" . $creator . "', NOW())";
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
            $tempArray = array('old_id' => $oldId, 'new_id' => $pass);
            array_push($endArray, $tempArray);
        } else {
            echo json_encode($endArray);
            exit;
        }
    } elseif ($status == 'delete') {
        $id = $a['id'];
        $sql = "DELETE FROM task_master WHERE id='" . $id . "'";
        $conn = new connManager();
        $Connection = $conn->GetConnection();
        if (!$Connection) {
            echo "Failed to connect to MySQL: " . mysql_error();
        }
        mysql_query($sql);
        mysql_close($Connection);
        $num = mysql_affected_rows();
        if ($num > 0) {
            $tempArray = array('id' => $id, 'status' => 'deleted');
            array_push($endArray, $tempArray);
        } else {
            echo json_encode($endArray);
            exit;
        }
    } else {
        echo json_encode(array('status' => 'nothing'));
    }
    $sql = "SELECT * FROM task_master WHERE creator='" . $creator . "' AND last_updated >'" . $lastUpdated;
    $conn = new connManager();
    $Connection = $conn->GetConnection();
    if (!$Connection) {
        echo "Failed to connect to MySQL: " . mysql_error();
    }
    $result = mysql_query($sql);
    $resultArray = array();
    while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
        $resultArray = $row;
    }
    mysql_free_result($result);
    mysql_close($Connection);
    $newJson = array_push($endArray, $resultArray);
    $newJson = json_encode($newJson);
    echo $newJson;
}
?>