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
                foreach ($row as $a) {
                    print_r($a);
                }
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