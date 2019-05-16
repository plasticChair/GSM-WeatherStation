<?php 

$DateTime = $_GET["DateTime"];
$Temp = $_GET["Temp"];
$Humidity = $_GET["Humidity"];
$Pressure = $_GET["Pressure"];
$Wind = $_GET["Wind"];

$servername = "127.0.0.1:3306";

echo $Temp;
echo "\r";
echo $Humidity;
echo "\r";
echo $Pressure;
echo "\r";
echo $Wind;
echo "\r";

$config = parse_ini_file('/var/www/db.ini');
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
  `DateTime` datetime NOT NULL COMMENT 'Date and Time of Readings',
  `TempOutCur` decimal(6,1) NOT NULL COMMENT 'Current Outdoor Temperature',
  `HumOutCur` decimal(4,1) NOT NULL COMMENT 'Current Outdoor Humidity',
  `PressOutCur` decimal(6,1) NOT NULL COMMENT 'Current Outdoor Pressure',
  `WindOutCur` decimal(4,1) NOT NULL COMMENT 'Current Outdoor Wind',
   PRIMARY KEY (ID));";
  
if ($conn->query($sql) === TRUE) {
    echo "created Table";
	
} else {
    echo "table exists or error: " . $conn->error;
}
echo "\r";
echo "\r\n";
echo "------";

$sql = "INSERT INTO `mystation` (`DateTime`, `TempOutCur`, `HumOutCur`, `PressOutCur`, `WindOutCur`) VALUES
('$DateTime', $Temp, $Humidity, $Pressure, $Wind);";

if ($conn->query($sql) === TRUE) {
    echo "Inserted Data";
	
} else {
    echo "Added data error: " . $conn->error;
}

echo "\r";





echo $temperature;
echo "\r";
echo $wind;
echo "\r";
echo $time;
echo "\r";


$conn->close();




?>


<font face="century gothic" size="20px"?
	<center>Hello World</center>
</font>