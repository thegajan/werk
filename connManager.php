<?php
class connManager{
    function GetConnection(){
//        $dbhost = 'localhost';
//        $dbuser = 'adminC7Gaxb2';
//        $dbpass = 'U3crin9J3GXq';
//        $dbName = "werk";
        $conn = mysql_connect($dbhost, $dbuser, $dbpass);
        mysql_select_db($dbName) or die('Could not select database' . mysql_error ());
        return $conn;
    }
}


?>