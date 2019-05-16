<?php 
echo $HTTP_RAW_POST_DATA;
//$data = $_POST["data"];
$data = file_get_contents('php://input');
//var_dump($data);
$var = json_decode($data, true);
echo $var[0];
echo "\r";
echo $var[1];
echo "\r";
$servername = "127.0.0.1:3306";


$config = parse_ini_file('/var/www/db_arduino.ini');
// Create connection
$conn = new mysqli("localhost",$config['username'],$config['password']);


// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
echo "Connected successfully";
echo "\r";

// Create database
$sql = "CREATE DATABASE " . $config['db'];

//$sql = "CREATE DATABASE Test_1128";
if ($conn->query($sql) === TRUE) {
    echo "Database created successfully";
	
} else {
    echo "Error creating database: " . $conn->error;
}
echo "\r";

$sql = "USE " . $config['db'];
if ($conn->query($sql) === TRUE) {
    echo "Selected database";
	
} else {
    echo "Database not selected or error: " . $conn->error;
}
echo "\r";

echo "------";

$sql = "CREATE TABLE IF NOT EXISTS `mystation` (`ID` int(11) NOT NULL AUTO_INCREMENT, 
  `data` char(28) NOT NULL COMMENT 'Raw Data',

   PRIMARY KEY (ID));";
  
if ($conn->query($sql) === TRUE) {
    echo "created Table";
	
} else {
    echo "table exists or error: " . $conn->error;
}
echo "\r";
echo "\r\n";
echo "------";

$sql = "INSERT INTO `mystation` (`data`) VALUES
('$data');";

if ($conn->query($sql) === TRUE) {
    echo "Inserted Data";
	
} else {
    echo "Added data error: " . $conn->error;
}

echo "\r";





echo $data;
echo "\r";



$conn->close();




?>


<font face="century gothic" size="20px"?
	<center>Hello World</center>
</font>