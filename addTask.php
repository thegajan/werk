<?php
session_start(); //most of people forget this while copy pasting code ;)
if($_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest') {
    //Request identified as ajax request

    if(@isset($_SERVER['HTTP_REFERER']) && $_SERVER['HTTP_REFERER']=="https://www.readmybluebutton.com/werk/main.php")
    {
        //HTTP_REFERER verification
        if($_POST['token'] == $_SESSION['token']) {
        echo "ya";
        }
        else {
            header('Location: index.php');
        }
    }
    else {
        header('Location: index.php');
    }
}
else {
    header('Location: index.php');
}
?>