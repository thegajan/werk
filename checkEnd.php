<?php
if ($_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest') {
    header('Location: https://www.readmybluebutton.com/index.php');
} else {
    include_once 'connManager.php';
    $sql = "UPDATE task_master SET success='no' WHERE time_end < NOW() AND time_start < NOW()";
    $conn = new connManager();
    $Connection = $conn->GetConnection();
    if (!$Connection) {
        echo "Failed to connect to MySQL: " . mysql_error();
    }
    mysql_query($sql);
    $pass = mysql_affected_rows();
    mysql_close($Connection);
    echo mysql_error();
    if ($pass > 0) {

    } else {
        mail("thegajannagaraj@gmail.com", "FAIL", "FAIL");
    }
}

?>