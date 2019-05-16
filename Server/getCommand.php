<?php 


  $MasterError = 0;

$defaultID = 1;
$defaultserInt = 15; // Intervals of 5 seconds
$defaultmeasInt = 6;
$defaultreboot = 0;


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

  

//$result = $conn->query('SELECT * FROM `Command`');

if ($result = $conn->query("SELECT * 
							FROM ( 
									SELECT * 
									FROM Command 
									ORDER BY 
										ID DESC 
									LIMIT 1 
									) q 
									ORDER BY 
									ID ASC" )) {
  //  printf("Select returned %d rows.\n", $result->num_rows);

    /* free result set */
    //$result->close();
}

if (mysqli_num_rows($result) > 0) {
	//	echo "ID	 	Data		\r";
    $row = mysqli_fetch_assoc($result);
	//	while() {
//		 //  echo $row["ID"] . "	\t\t	" . $row["measInt"] . " <br>";
    $measInt = $row["measInt"];
    $serInt = $row["serverInt"];
        $reboot = $row["reboot"];
//		}
	 }
 else {
	//	echo "0 results";
        $measInt = $defaultmeasInt;
     $serInt = $defaultserInt;
         $reboot = $defaultreboot;
	 }

$datetime = new DateTime();
$timezone = new DateTimeZone('America/Phoenix');
$datetime->setTimezone($timezone);
$now =  $datetime->format('Y-m-d H:i:s');



$sql = "DELETE FROM Command WHERE ID=1";
$conn->query($sql);


$sql = 'INSERT INTO `Command` (`ID`, `measInt`, `serverInt`, `reboot`, `ReadTime`) VALUES  (\'' . $defaultID . '\', \'' . $defaultmeasInt . '\', \'' . $defaultserInt . '\', \'' . $defaultreboot . '\', CURRENT_TIME())';
$conn->query($sql);

// echo "\r";
  //  echo "Status: ";
  //  echo $MasterError;
  //  echo "\r";
echo "Command: " . sprintf('%01X', $measInt). sprintf('%02X', $serInt) . dechex($reboot);
echo ",";


    $conn->close();


?>


