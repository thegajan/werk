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
                echo "<div id='moreInfo-main'>
                    <div class='some-header'>
                        <img src='img_fonts/ios7-arrow-left.png' id='back-button' onclick='closeMoreInfo()'>
                        <h1 onclick='closeMoreInfo()' class='moreInfo-h1' id='back'>Back</h1>
                        <h1 id='moreInfo-main-h1' class='moreInfo-h1'>" . $row['task_name'] . "</h1>
                    </div>
                    <div>
                        <h2>Start Time: " . date('l, F jS Y h:i A', strtotime($row['time_start'])) . "\r\n" . "</h2>
                        <h2>End Time: " . date('l, F jS Y h:i A', strtotime($row['time_end'])) . "</h2>
                    </div>
                    <div id='description-post' >
                        <h2>Description: </h2>" . $row['task_description'] . "</div>
                    </div>
                    <div id='time-finished-container'>
                    <h2>Time Finished</h2>
                    <input type='text' id='time-finished-date' class='time-finished-datepicker' name='time-finished-date' placeholder='Time Finished'><br>
                    <div id='time-inputs'>
                    <input type='text' id='time-finished-date-startHour' name='time-finished-date-startHour' placeholder='Hour' class='boxes'>:<input type='text' id='time-finished-date-startMinute' name='time-finished-date-startMinute' placeholder='Minute' class='boxes'>
                    <select name='time-finished-date-startTime' id='time-finished-date-startHour' class='box'>
                        <option></option>
                        <option>AM</option>
                        <option>PM</option>
                    </select>
                    </div>
                    <button id='task-complete' onclick='completeTask(" . $row['id'] . ");'>Complete Task</button>
                    </div>
                    </div>";
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