<?php 


$serverInterval = $_GET["serverInterval"];
$measureInterval = $_GET["measureInterval"];

// Setup defaults
$serverFlag = 0;
$measFlag = 0;
$defaultmeasInt = 6; // Intervals of 5 seconds
$defaultserInt = 15;
$defaultID = 1;
$defaultreboot = 0;

if ($serverInterval != 0){
    $serverFlag = 1;
    $defaultserInt = $serverInterval;
}

if ($measureInterval != 0){
    $measFlag = 1;
    $defaultmeasInt = $measureInterval;
}


$datetime = new DateTime();
$timezone = new DateTimeZone('America/Phoenix');
$datetime->setTimezone($timezone);
$now =  $datetime->format('Y-m-d H:i:s');


    $config = parse_ini_file('/var/www/db.ini');
    // Create connection
    $conn = new mysqli("localhost",$config['username'],$config['password']);


    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    } 


   
    $sql = "USE UserCmd";
    if ($conn->query($sql) === TRUE) {
   //     echo "Selected database";

    } else {
        echo "Database not selected or error: " . $conn->error;
    //    $MasterError = 1;
    }
   // echo "\r";

  //  echo "------";


if ($result = $conn->query("SELECT * FROM (SELECT * 
									FROM Command 
									ORDER BY ID DESC LIMIT 1 ) q 
									ORDER BY 
									ID ASC" )) {

}

if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    $reboot = $row["reboot"];
    
    if($serverFlag){
        $defaultmeasInt = $row["measInt"];
    }
    
    if ($measFlag){
         $defaultserInt = $row["serverInt"];
    }
}






$sql = "DELETE FROM Command WHERE ID=1";
$conn->query($sql);


$sql = 'INSERT INTO `Command` (`ID`, `measInt`, `serverInt`, `reboot`, `ReadTime`) VALUES  (\'' . $defaultID . '\', \'' . $defaultmeasInt . '\', \'' . $defaultserInt . '\', \'' . $defaultreboot . '\', \'' . $readtime . '\')';
$conn->query($sql);


   
if($serverFlag){
    
    echo "Changed Server Interval To: " . $defaultserInt . " mins" ;
}

if ($measFlag){
     echo "Changed Measurement Interval To: " . $defaultmeasInt*5 . " secs\n" ;
}


    $conn->close();


?>


