<?php
session_start();
$resultArray = array();
if ($_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest') {

    if (@isset($_SERVER['HTTP_REFERER']) && $_SERVER['HTTP_REFERER'] == "https://www.readmybluebutton.com/werk/main.php") {
        if ($_POST['token'] == $_SESSION['token']) {
            $id = $_POST['id'];
            include_once 'connManager.php';
            $sql = "SELECT * FROM task_master WHERE id='" . $id . "'";
            $conn = new connManager();
            $Connection = $conn->GetConnection();
            if (!$Connection) {
                echo "Failed to connect to MySQL: " . mysql_error();
            }
            $result = mysql_query($sql);
            $row = mysql_fetch_array($result, MYSQL_ASSOC);
            mysql_close($Connection);
            if (count($row) > 0) {
//                print_r($row);
                echo "<div id='moreInfo-main'></div><div id='header-stuff'><h1 onclick='closeMoreInfo()' class='moreInfo-h1'>Back</h1><h1 id='moreInfo-main-h1' class='moreInfo-h1'>" . $row['task_name'] . "</h1></div><div><h2>Start Time: " . date('l, F jS Y h:i A', strtotime($row['time_start'])) . "\r\n" . "</h2><h2>End Time: " . date('l, F jS Y h:i A', strtotime($row['time_end'])) . "</h2></div><div><h2>Description: </h2>" . $row['task_description'] . "</div></div>";
            } else {
                header('Location: index.php');
            }
        } else {
            header('Location: index.php');
        }
    }
} else {
    header('Location: index.php');
}
?>