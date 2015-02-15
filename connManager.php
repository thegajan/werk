<?php
class connManager{
    function GetConnection(){
        $dbhost = 'localhost';
        $dbuser = 'readmybl_werk';
        $dbpass = 'D6CpmukGrXQgfj09';
        $dbName = "werk";
        $conn = mysql_connect($dbhost, $dbuser, $dbpass);
        mysql_select_db($dbName) or die('Could not select database' . mysql_error ());
        return $conn;
    }
}


?>