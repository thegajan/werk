<?php
class connManager{
    function GetConnection(){
        $dbhost = 'localhost';
        $dbuser = 'readmybl_werk';
        $dbpass = '0J6CN24SPhVRQ5jM';
        $dbName = "readmybl_werk";
        $conn = mysql_connect($dbhost, $dbuser, $dbpass);
        mysql_select_db($dbName) or die('Could not select database' . mysql_error ());
        return $conn;
    }
}


?>