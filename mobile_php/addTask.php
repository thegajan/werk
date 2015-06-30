<?php
header('Content-Type: application/json');
$jsonFromPhone = file_get_contents("php://input");
$taskInfo = json_decode($jsonFromPhone, true);
include_once '../connManager.php';
$endArray = array();
$lastUpdated = $taskInfo['last_updated'];
//$creator = ['creator_id'];
$creator = 1;
$resultArray = array();
$tempArray = array();
$newJson = array();
$otherArray = array();
$sql = "SELECT * FROM task_master WHERE creator='" . $creator . "' AND last_updated > STR_TO_DATE('" . $lastUpdated . "','%Y/%c/%e %T')";
$conn = new connManager();
$Connection = $conn->GetConnection();
if (!$Connection) {
    echo "Failed to connect to MySQL: " . mysql_error();
}
$result = mysql_query($sql);
//    mysql_free_result($result);
while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
    $resultArray = $row;
    array_push($otherArray, $resultArray);
}
mysql_close($Connection);
foreach ($taskInfo['info'] as $a) {
    if (count($a) == 1) {
        continue;
    }
    $taskName = $a['taskName'];
    $description = $a['description'];
    $startDate = $a['startDate'];
    $endDate = $a['endDate'];
    $completeTime = $a['completeTime'];
    $status = $a['status'];
    $oldId = $a['id'];
    if ($status == 'create') {
        $sql = "INSERT INTO task_master (task_name, task_description, time_start, time_end, creator, last_updated) VALUES (\"" . $taskName . "\", \"" . $description . "\", '" . $startDate . "', '" . $endDate . "', '" . $creator . "', NOW())";
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
    } elseif ($status == 'complete') {
        $id = $a['id'];
        $sql = "UPDATE task_master WHERE id='" . $id . "' SET time_complete = '" . $completeTime . "'";
        $conn = new connManager();
        $Connection = $conn->GetConnection();
        if (!$Connection) {
            echo "Failed to connect to MySQL: " . mysql_error();
        }
        mysql_query($sql);
        mysql_close($Connection);
        $num = mysql_affected_rows();
        if ($num > 0) {
            $tempArray = array('id' => $id, 'status' => 'complete');
            array_push($endArray, $tempArray);
        } else {
            echo json_encode($endArray);
            exit;
        }
    } else {
        echo json_encode(array('status' => 'nothing'));
    }
}

//if (count($endArray) == 0) {
//    $newJson = $otherArray;
//    echo "[" . json_encode($newJson) . "]";
//
//} elseif(count($endArray) == 0 and count($otherArray)==0){
//    echo '[]';
//}
//else {
$newJson = array_merge($endArray, $otherArray);
echo json_encode($newJson);
//}
//echo json_encode($resultArray);
//$newJson = json_encode($newJson);
//$newJson = $endArray;
//echo 'dick bag';
//echo $lastUpdated;
?>