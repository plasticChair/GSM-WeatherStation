<?php 

$hours = $_GET["hours"];
$days = $_GET["days"];
$type = $_GET["type"];


$config = parse_ini_file('/var/www/db.ini');
// Create connection
$conn = new mysqli("localhost",$config['username'],$config['password'], $config['db']);

// Check connection
if ($conn->connect_error) {
    die($conn->connect_error);
} 



//$result = $conn->query("SELECT * FROM mystation ORDER BY ID DESC LIMIT $numData  WHERE DateTime >= '2019-06-02 08:13:03' AND DateTime <= '2019-06-02 010:13:03'" );

 


date_default_timezone_set('America/Phoenix');
$dateNow = date('Y-m-d H:i:s');

//echo $dateNow;
///echo "\r";
$date = (new \DateTime())->modify('-' . $hours .' hours');
$date->modify('-' . $days .' days');
//$date->sub(new DateInterval('P0Y0M'. $days .'DT' . $hours .'H0M0S'));
//echo $date->format('Y-m-d h:i:s') . "\n";
 
$nowStr = $dateNow;
$thenStr = $date->format('Y-m-d H:i:s');



//echo date_format($date,"Y/m/d H:i:s");

//echo "SELECT * FROM mystation WHERE DateTime >= " . $thenStr  . " and DateTime <= " . $nowStr ;

//$result = $conn->query("SELECT * FROM mystation WHERE DateTime >= '2019-04-21 07:05:16' and DateTime <= '2019-04-21 12:05:16'");

$result = $conn->query("SELECT * FROM mystation WHERE DateTime >= '" . $thenStr . "' and DateTime <= '" . $nowStr . "'");


if (mysqli_num_rows($result) == 0){
    
        $result = $conn->query("SELECT * FROM ( SELECT * FROM mystation ORDER BY ID DESC LIMIT 120) q 
									ORDER BY 
									ID ASC" );

}

  
if (mysqli_num_rows($result) > 0) {
  
    if ($type == "windSpd"){
        $data = array("Date,Wind Speed,Gust");
    } elseif ($type == "gust"){
        $data = array("Date, Wind Gust\n");
    } elseif ($type == "windDir"){
        $data = array("Date, Wind direction\n");
    } elseif ($type == "temp"){
        $data = array("Date, Temperature\n");
    } elseif ($type == "press"){
        $data = array("Date, Pressure\n");
    } elseif ($type == "humid"){
        $data = array("Date, Humidity\n");
    } elseif ($type == "batt"){
        $data = array("Date, Battery Percent\n");
    } elseif ($type == "battV"){
        $data = array("Date, Battery Voltage\n");
    } elseif ($type == "rssi"){
         $data = array("Date, RSSI\n");
    } elseif ($type == "lpm"){
        $data = array("Date, Low Power Mode\n");
    }elseif ($type == "reset"){
        $data = array("Date, Number of Resets\n");
    }elseif ($type == "windDirHist"){
        $data = array("Direction, Bins\n");
    }
  


   //echo "ID	 	DateTime		TempOutCur		HumidityCur		PressOutCur		WindOutCur    WindDirOutCur<br>";
    while($row = mysqli_fetch_assoc($result)) {
    //   echo $row["ID"] . "," . $row["DateTime"] . "," . $row["TempOutCur"] . "," . $row["HumOutCur"] ."," . $row["PressOutCur"] ."," . $row["WindOutCur"] ."," . $row["WindDirOutCur"] . " <br>";
        if ($type == "windSpd"){           
            $data[] = implode("",array("*", str_replace("-","/",(string)$row['DateTime']),",", (string)$row['windSpd'],",", (string)$row['gustMax']));
        }elseif ($type == "gust"){
            $data[] = implode("",array("*", str_replace("-","/",(string)$row['DateTime']),",", (string)$row['gustMax'],"\n"));
        }elseif ($type == "windDir"){
            $data[] = implode("",array("*", str_replace("-","/",(string)$row['DateTime']),",", (string)($row['windDir']*22.500),"\n"));
        } elseif ($type == "temp"){
            $data[] = implode("",array("*", str_replace("-","/",(string)$row['DateTime']),",", (string)($row['Tempature']*9/5+32),"\n"));
        } elseif ($type == "press"){
            $data[] = implode("",array("*", str_replace("-","/",(string)$row['DateTime']),",", (string)$row['Pressure'],"\n"));
        } elseif ($type == "humid"){
            $data[] = implode("",array("*", str_replace("-","/",(string)$row['DateTime']),",", (string)$row['Humidity'],"\n"));
        }   elseif ($type == "batt"){
            $data[] = implode("",array("*", str_replace("-","/",(string)$row['DateTime']),",", (string)$row['batteryP'],"\n"));
        }   elseif ($type == "battV"){
            $data[] = implode("",array("*", str_replace("-","/",(string)$row['DateTime']),",", (string)$row['batteryV'],"\n"));
        }   elseif ($type == "rssi"){
            $data[] = implode("",array("*", str_replace("-","/",(string)$row['DateTime']),",", (string)$row['signalRSSI'],"\n"));
        } elseif ($type == "lpm"){
            $data[] = implode("",array("*", str_replace("-","/",(string)$row['DateTime']),",", (string)$row['LowPwrMode'],"\n"));
        } elseif ($type == "reset"){
            $data[] = implode("",array("*", str_replace("-","/",(string)$row['DateTime']),",", (string)$row['info'],"\n"));
        }elseif ($type == "windDirHist"){
            $tempdata[] = (int)$row['windDir'];
        }
    
        //$data['ID'][] = $row["ID"];
        //$data['DateTime'][] = $row["DateTime"];
       // $data['Temp'][] = $row["TempOutCur"];
        //$data['Hum'][] = $row["HumOutCur"];
        //$data['Press'][] = $row["PressOutCur"];
        //$data['Wind'][] = $row["WindOutCur"];
        //$data['WindDir'][] = $row["WindDirOutCur"];
     //  echo "".$row['ID']."," <br>";

    }
 }
$binData = array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
if ($type == "windDirHist"){
       for($ii = 0; $ii <count($tempdata); $ii++){
           $binData[$tempdata[$ii]] =  $binData[$tempdata[$ii]]+1;
    //    data[] = array((string)$ii, "," , (string)$tempdata[$ii], "\n");
       }
    
    
      for($ii = 0; $ii <count($binData); $ii++){

          // $data[] = array("*",$ii ,",", binData[$ii],"\n");
          $data[] = implode("",array("*", (string)$ii,",", (string)$binData[$ii],"\n"));
    //    data[] = array((string)$ii, "," , (string)$tempdata[$ii], "\n");
       }
  //  var_dump($data);

 //   for($ii = 0; $ii <16; $ii++){
    //    data[] = array((string)$ii, "," , (string)$tempdata[$ii], "\n");
 //   }

}

 //echo "<br>";
//$json = json_encode($data);
echo str_replace(",*","\n",implode(",",$data));

//echo $data;

//print_r($data);

$result->close();
$conn->close();

?>