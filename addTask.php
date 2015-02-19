<?php
session_start();
if ($_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest') {


    if (@isset($_SERVER['HTTP_REFERER']) && $_SERVER['HTTP_REFERER'] == "https://www.readmybluebutton.com/werk/main.php") {
        //HTTP_REFERER verification
        if ($_POST['token'] == $_SESSION['token']) {
            $taskName = $_POST['taskName'];
            $description = $_POST['description'];
            $startDate = $_POST['sur'];
            $startHour = $_POST['startHour'];
            $startMinute = $_POST['startMinute'];
            $startTOD = $_POST['startTOD'];
            $endDate = $_POST['sur1'];
            $endHour = $_POST['endHour'];
            $endMinute = $_POST['endMinute'];
            $endTOD = $_POST['endTOD'];
            $creator = "1";
//            echo $taskName . " " . $description;
            $startTime = $startDate . " " . $startHour . ":" . $startMinute . ":00" . " " . $startTOD;
            $endTime = $endDate . " " . $endHour . ":" . $endMinute . ":00" . " " . $endTOD;
//            echo $startTime . " " . $endTime;
            date_default_timezone_set ('UTC');
            $currentDate = date('m/d/Y h:i:s A');
            function validateDate($date)
            {
                $d = DateTime::createFromFormat('m/d/Y', $date);
                return $d && $d->format('m/d/Y') == $date;
            }
//            echo $startDate . "sadas " . $endDate . "asds " . var_dump(validateDate($startDate)) . " " . var_dump(validateDate($endDate));
            if (strlen($taskName) == 0 || validateDate($startDate) == false || validateDate($endDate) == false || $startHour > 12 || $startHour < 1 || $startMinute < 0 || $startMinute > 59 || $endHour > 12 || $endHour < 1 || $endMinute < 0 || $endMinute > 59 || $startTime > $endTime || $startTime < $currentDate || $endTime < $currentDate) {
                echo "form not complete";
            } else{
                include_once 'connManager.php';
                $sql = "INSERT INTO task_master (task_name, task_description, time_start, time_end, creator, last_updated) VALUES (\"" . $taskName . "\", \"" . $description . "\", STR_TO_DATE('" . $startTime . "','%c/%e/%Y %r'), STR_TO_DATE('" . $endTime . "','%c/%e/%Y %r'), '" . $creator . "', NOW())";
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
                    echo "error";
                }
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