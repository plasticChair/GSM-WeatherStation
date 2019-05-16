<?php 

include 'init.php';
//print_r(json_decode(file_get_contents("php://input"), true));
$data = file_get_contents('php://input');
$jsonIterator = json_decode($data, TRUE);

$MasterError =  0;
//echo $data;

//if(isset($_GET["data"]))
//{
   // $dataRaw = $_GET["data"];

    //$dataRaw = $_POST["data"];
   // $servername = "127.0.0.1:3306";

   // $dataRaw = "0115d711f41520064506b6954321";


    
    //var_dump($sqlName);

    $config = parse_ini_file('/var/www/db.ini');
    // Create connection
    $conn = new mysqli("localhost",$config['username'],$config['password']);


    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    } 
    //echo "Connected successfully";
   /// echo "\r";

    // Create database
    $sql = "CREATE DATABASE " . $config['db'];

    //$sql = "CREATE DATABASE Test_1128";
    if ($conn->query($sql) === TRUE) {
      //  echo "Database created successfully";

    } else {
      //  echo "Error creating database: " . $conn->error;
    }
 //   echo "\r";


    $sql = "USE " . $config['db'];
    if ($conn->query($sql) === TRUE) {
    //    echo "Selected database";

    } else {
     //   echo "Database not selected or error: " . $conn->error;
        $MasterError = 2;
    }
   // echo "\r";

  //  echo "------";

    $sql = "CREATE TABLE IF NOT EXISTS `mystation` (`ID` int(11) NOT NULL AUTO_INCREMENT, 
      `ServerTime` DATETIME NOT NULL COMMENT 'Sever In',
      `DateTime` DATETIME NOT NULL COMMENT 'Date and Time of Readings',
      `windDir` decimal(12,1) NOT NULL COMMENT 'Wind Direction',
      `windSpd` decimal(12,4) NOT NULL COMMENT '(MPH)',
      `gustMax` decimal(12,4) NOT NULL COMMENT '(MPH)',
      `accesscode` decimal(4,0) NOT NULL COMMENT 'General Info',
      `Tempature` decimal(12,4) NOT NULL COMMENT '(F)',
      `Pressure` decimal(12,4) NOT NULL COMMENT '(hPA)',
      `Humidity` decimal(12,4) NOT NULL COMMENT '(%)',
      `batteryV` decimal(12,4) NOT NULL COMMENT '(V)',
      `batteryP` decimal(12,4) NOT NULL COMMENT '(%)',
      `signalRSSI` decimal(5,0) NOT NULL COMMENT '[0-31]',
      `LowPwrMode` decimal(1,0) NOT NULL COMMENT '[0-1]',
      `info` decimal(4,0) NOT NULL COMMENT 'General Info',
      `station_id` decimal(4,0) NOT NULL COMMENT 'Station ID',
      `RawData` char(32) NOT NULL COMMENT 'Raw Data',
       PRIMARY KEY (ID));";

    if ($conn->query($sql) === TRUE) {
    //   echo "created Table";
//
    } else {
   //     echo "table exists or error: " . $conn->error;
    }



foreach ($jsonIterator as $key => $val) {
        //----------------------------------------------
    $dataTimeStr = $dataDataTime->format('Y-m-d H:i:s');
    //echo $dataTimeStr. "<br>";
    
    // Flip string for parsing
    $dataRaw = strrev($val);
    //$dataRaw = '0'.$val;

    
    $dataOut = parseWxData($dataRaw, $dataStructure, $dataDataTime);
  //  echo $dataDataTime->format('Y-m-d H:i:s') . "<br>";
//print_r($dataStructure);
    //----------------------------------------------
    $sqlName[0] = '`DateTime`';
    $sqlData[0] = '\''.$dataDataTime->format('Y-m-d H:i:s').'\'';
    
    
    //echo  $sqlData[0];
    for ($ii = 6; $ii < sizeof($dataStructure); $ii++){
        $sqlName[$ii-5] = '`'.$dataStructure[$ii][0] . '`';
        $sqlData[$ii-5] = $dataOut[$ii] ;
        
     //  echo $sqlName[$ii-5] . ' = ' . $sqlData[$ii-5]; 
     //  echo "<br>";
     //   echo $dataStructure[$ii][0] . " = " . $dataOut[$ii];
     //   echo "<br>";
    }
    $sqlName[sizeof($dataStructure)-5] = '`RawData`';
    $sqlData[sizeof($dataStructure)-5] = '\''.$dataRaw.'\'';
    
    
    
  //   echo "<br>";
//    echo "<br>";
 // echo implode(', ', $sqlName);
  //  echo "<br>";
 //   echo implode(', ', $sqlData);
  //  echo "<br>";
  //  echo $dataStructure[14][4];
  //  echo "<br>";
    
    $sql = 'INSERT INTO `mystation` (`ServerTime`,' . implode(', ', $sqlName) . ') VALUES  (CURRENT_TIME(),' . implode(', ', $sqlData) . ')';

    
    //echo $sql;
    //echo "<br>";
   // echo "<br>";
    
    if ($conn->query($sql) === TRUE) {
   //     echo "Inserted Data";
        $MasterError =  84;

    } else {
   // echo "Added data error: " . $conn->error;
        $MasterError = 3;
    }

    
}
   
 echo "Status: ";
    echo $MasterError;
    echo ",\r";
    $conn->close();
    include 'getCommand.php';
    
    
//}
?>

