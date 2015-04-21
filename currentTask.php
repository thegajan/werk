<?php
session_start();
$resultArray = array();
if ($_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest') {

    if (@isset($_SERVER['HTTP_REFERER']) && $_SERVER['HTTP_REFERER'] == "https://www.readmybluebutton.com/werk/main.php") {
        //HTTP_REFERER verification
        if ($_POST['token'] == $_SESSION['token']) {
            $currDate = $_POST['currDate'];
            $creator = $_POST['creator'];
            $creator = 1;
            $timeZone = $_POST['timeZone'];
            $timeZone = new DateTimeZone($timeZone);
            include_once 'connManager.php';
//            $sql = "SELECT * FROM task_master WHERE creator='" . $creator . "'";
            $sql = "SELECT * FROM task_master WHERE creator='" . $creator . "' AND time_start < '" . $currDate . "' AND time_end > '" . $currDate . "' AND success='not over' ORDER BY time_end";
            $conn = new connManager();
            $Connection = $conn->GetConnection();
            if (!$Connection) {
                echo "Failed to connect to MySQL: " . mysql_error();
            }
            $result = mysql_query($sql);
            while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
                array_push($resultArray, $row);
            }
            mysql_close($Connection);
            if (count($resultArray) > 0){
                foreach ($resultArray as $a => $b){
                    echo("<tr>
                        <td>
                            <div class='task-content-div' id='" . $b['id'] . "'><input type='checkbox' class='task-left'>

                                <h1 class='task-left heads'>" . $b['task_name'] . " - </h1>

                                <h1 class='timer heads' id='countdown-holder" . $b['id'] . "'></h1>

                                <h1 class='heads clicks' id='click' onclick='moreInfo(" . $b['id'] . ")>(More Info)</h1>
                            </div>
                            <script>
                            slidDown(" . "#" . $b['id'] . ", " . "#description" .  $b['id'] . ");
                            countdownDate('countdown-holder" . $b['id'] . "', '" . date('Y/m/d H:i:s',strtotime($b['time_end'])) . "');
                            </script>
                            <div class='task-content-div icon-menu'>
                                <div data-icon='ei-chevron-down'></div>
                            </div>
                            <div class='task-description' id='" . "description" .  $b['id'] . "'>
                                <h3>Task Description:</h3>
                                <h4>" . $b['task_description'] . "</h4>
                            </div>
                        </td>
                    </tr>");

                }
            } else{
                echo "error";
            }
        } else {
            header('Location: index.php');
        }
    } else {
        header('Location: index.php');
    }
} else {
    header('Location: index.php');
}
?>