<?php
if ($_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest') {
    header('Location: https://www.readmybluebutton.com/index.php');
} else {
    include_once 'connManager.php';
    $sql="UPDATE task_master SET success='no' WHERE time_end < NOW() ";
}

?>