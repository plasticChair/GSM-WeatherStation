<?php 
include 'init.php';



$config = parse_ini_file('/var/www/db.ini');
// Create connection
$conn = new mysqli("localhost",$config['username'],$config['password'], $config['db']);

// Check connection
if ($conn->connect_error) {
    die($conn->connect_error);
} 


/* -----------   Get 30 min data -----------*/    
$nowStr = nowTime();
$thenStr = thenTime(0, 0, 30);

$result = $conn->query("SELECT * FROM mystation WHERE DateTime >= '" . $thenStr . "' and DateTime <= '" . $nowStr . "'");

if (mysqli_num_rows($result) > 0) {
    while($row = mysqli_fetch_assoc($result)) {

        $tempature[] = $row['Tempature']*9/5 +32;
        $windSpd[] = $row['windSpd'];
        $gust[] = $row['gustMax']; //gustMax
        $windDir[] = $row['windDir'] + 15;
        $humidity[] = $row['Humidity'];
        $pressure[] = $row['Pressure'];
    }
 }

// Wind Stats
$windNow = number_format((float)$windSpd[count($windSpd)-1] , 1, '.', '');
$avgHum = array_sum($humidity) / count($humidity);


$maxWind = number_format((float)(max($windSpd)), 1, '.', '');
$minWind = number_format((float)(min($windSpd)), 1, '.', '');
$avgWind = array_sum($windSpd) / count($windSpd);

$maxGust = max($gust);
$minGust = min($gust);

$gustStd = standard_deviation($gust );
if ($gustStd < 3){
    $gustTend = "Calm";
}else if($gustStd < 8){
    $gustTend = "Windy";
}else if($gustStd < 12){
    $gustTend = "Rough";
}else if($gustStd < 20){
    $gustTend = "No fly!";
}


// Find wind Stability

$windDirDeg = stringArray2Num($windDir);
$scaleFactTemp = (22.5*M_PI/180);

$windDirRad = arrayMultiply($windDirDeg, $scaleFactTemp);
$ua_east    = arraySin($windDirRad);
$ua_north   = arrayCos($windDirRad);

$unit_WDa   = arrayAtan2($ua_east, $ua_north);
$unit_WDa   = arrayMultiply($unit_WDa, 180/M_PI);

//$unit_WDa   = arrayAdd($unit_WDa, 360);
//$unit_WDa   = arrayMod($unit_WDa, 360);
$windDirStd = standard_deviation($unit_WDa);
//var_dump($unit_WDa);
if ($windDirStd > 90){
    $windDirTend = "Crazy winds";
}else if($windDirStd > 65){
    $windDirTend = "Sporadic";
}else if($windDirStd > 30){
    $windDirTend = "Stable";
}else if($windDirStd > 0){
    $windDirTend = "Very Stable";
}

//Calculate average wind direction
$windDirLast = $windDir[count($windDir)-1];
$windDirLast = windDeg2Dir($windDirLast*22.5);

$avgwindDir = windDeg2Dir(array_sum($windDir)*22.5 / count($windDir));

$windDirDeg = stringArray2Num($windDir);
$scaleFactTemp = (22.5*M_PI/180);
$windDirRad = arrayMultiply($windDirDeg, $scaleFactTemp);
// average wind direction
$u_east = array_sum(arraySin($windDirRad))/count($windDirDeg);
$u_north = array_sum(arrayCos($windDirRad))/count($windDirDeg);
$unit_WD = atan2($u_east, $u_north) * 180/M_PI;
$unit_WD = (360 + $unit_WD) % 360;
$unit_WD = windDeg2Dir($unit_WD);


// Temperature
$avgTemp = number_format((float)(array_sum($tempature) / count($tempature)), 1, '.', '');


$avgPress = array_sum($pressure) / count($pressure);
$avgPress = number_format((float)($avgPress), 1, '.', '');



/* -----------   Get 24 hour data -----------*/    
$nowStr = nowTime();
$thenStr = thenTime(0, 24, 0);

$result = $conn->query("SELECT * FROM mystation WHERE DateTime >= '" . $thenStr . "' and DateTime <= '" . $nowStr . "'");
 
if (mysqli_num_rows($result) > 0) {
    while($row = mysqli_fetch_assoc($result)) {
        $tempature[] = $row['Tempature']*9/5 +32;
    }
 }

$maxTemp = number_format((float)(max($tempature)), 1, '.', '');
$minTemp = number_format((float)(min($tempature)), 1, '.', '');

$result->close();
$conn->close();

 echo "<style type=\"text/css\">  .tg2  {border-collapse:collapse;border-spacing:0;}
            .tg2 td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:black;}           .tg2 th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:black;}           .tg2 .tg2-0lax{text-align:left;vertical-align:top}            .tg2 .tg2-0lay{text-align:left;vertical-align:top;font-family:Arial, sans-serif;font-size:24px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:black;background-color:#656565;color:#ffffff;}       </style>";

            
  echo "<style type=\"text/css\">           .tg  {border-collapse:collapse;border-spacing:0;}
            .tg td{font-family:Arial, sans-serif;font-size:14px;padding:4px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:black;}            .tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:4px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:black;}            .tg .tg-1wig{font-weight:bold;text-align:left;vertical-align:top}            .tg .tg-baqh{text-align:center;vertical-align:top}            .tg .tg-c8dp{background-color:#656565;color:#ffffff;text-align:center;vertical-align:top}            .tg .tg-0lax{text-align:center;vertical-align:top}        </style>";



  echo   "<table class=\"tg\" style=\"undefined;table-layout: fixed; width: 263px;background-color: white;\">";
  echo   "<colgroup>   ";                                          
  echo   "<col style=\"width: 41px\">";
  echo   "<col style=\"width: 45px\">";
  echo   "<col style=\"width: 66px\">";
  echo   "<col style=\"width: 84px\">";
  echo   "<col style=\"width: 53px\">";
  echo   "<col style=\"width: 23px\">";
  echo   "</colgroup>";
  echo   "<tr>";
  echo   "<th class=\"tg-c8dp\" colspan=\"3\">Wind Now</th>";
  echo   "<th class=\"tg-c8dp\" colspan=\"3\">Wind Tendancy</th>";
  echo   "</tr>";
  echo   "<tr>";
  echo   "<td class=\"tg-0lax\"> " .$windNow . "</td>";
  echo   "<td class=\"tg-1wig\">mph</td>";
  echo   "<td class=\"tg-0lax\">".$windDirLast."</td>";
  echo   "<td class=\"tg-0lax\">" . $gustTend. "</td>";
  echo   "<td class=\"tg-0lax\">" .$unit_WD . "</td>";
  echo   "<td class=\"tg-0lax\"></td>";
  echo   "</tr>";
  echo   "<tr>";
  echo   "<td class=\"tg-c8dp\" colspan=\"3\">Temperature</td>";
  echo   "<td class=\"tg-0lax\" colspan=\"3\">" . $windDirTend . "</td>";
  echo   "</tr>";
  echo   "<tr>";
 // echo   "<td class=\"tg-baqh\" rowspan=\"3\"><br><br></td>";
  echo   "<td class=\"tg-0lax\" colspan=\"2\">".$avgTemp."F</td>";
  echo   "<td class=\"tg-1wig\">Average</td>";
  echo   "<td class=\"tg-c8dp\" colspan=\"3\">Wind Avg</td>";
  echo   "<td class=\"tg-1wig\"></td>";
  echo   "<td class=\"tg-0lax\"></td>";
  echo   "</tr>";
  echo   "<tr>";
  echo   "<td class=\"tg-0lax\" colspan=\"2\">".$maxTemp."F </td>";
  echo   "<td class=\"tg-1wig\">High</td>";
  echo   "<td class=\"tg-0lax\">" .$minWind. " - " .$maxWind ."</td>";
  echo   "<td class=\"tg-0lax\">mph</td>";
  echo   "<td class=\"tg-0lax\"></td>";
  echo   "</tr>";
  echo   "<tr>";
  echo   "<td class=\"tg-0lax\" colspan=\"2\">".$minTemp."F </td>";
  echo   "<td class=\"tg-1wig\">Low</td>";
  echo   "<td class=\"tg-0lax\">".$avgPress."</td>";
  echo   "<td class=\"tg-1wig\">hPa</td>";
  echo   "<td class=\"tg-0lax\"></td>";
  echo   "</tr>";
  echo   "</table>";
      


?>
