<?php

$dataStructure = array(
    
          array("year"      ,4 ,  1          ,    0,    5     ),
          array("month"     ,4 ,  1          ,    0,    2     ),
          array("day"       ,6 ,  1          ,    0,    3     ),
          array("hour"      ,6 ,  1          ,    0,    10    ),
          array("minute"    ,6 ,  1          ,    0,    37    ),
          array("second"    ,6 ,  1          ,    0,    54    ),
          array("windDir"   ,4 ,  1          ,    0,    10    ),
          array("windSpd"   ,12, 35.9211    ,    0,    35.8  ),
          array("gustMax"   ,12, 38786.34839,    0,    100   ),
          array("accessCode",4 , 1           ,    0,    1   ),
          array("Tempature" ,10, 10.7684    ,  -30,    23.5  ),
          array("Pressure"  ,12, 20.475      ,  900,    1002.2),
          array("Humidity"  ,10, 10.23      ,    0,    56.2  ),
          array("batteryV"  ,8 ,  212.5      ,    3,    3.87  ),
          array("batteryP"  ,10,  10.23      ,    0,    68.4  ),
          array("signalRSSI",5 ,  1          ,    0,    28  ),
          array("LowPwrMode",1 ,  1          ,    0,    0  ),
          array("info"      ,4 ,  1          ,    0,    5  ),
          array("station_id",4 ,  1          ,    0,    2     )
        );

$dateSrc = '2007-04-19 12:50'; 
$dataDataTime = DateTime::createFromFormat('j-M-Y', '15-Feb-2009');//new DateTime($dateSrc); 

    
function parseWxData($dataIn, &$dataStructureIn, &$dataTime)
{

    $sumBytes = 0;
    $remBits = 0;
    $shiftCount = 9; //1 byte after starting 32 bits

    //Init working 32bits
    //$working8Bytes = hexdec(substr($dataIn, strlen($dataIn)-8 ,8));  // 8bytes
    $working8Bytes = hexdec(substr($dataIn, -8));  // 8bytes

  //  echo dechex($working8Bytes);
  //  echo "<br>";
        
    for ($x = 0; $x < sizeof($dataStructureIn); $x++){
        // Capture size and names
        $varName  = $dataStructureIn[$x][0];
        $bitSize  = $dataStructureIn[$x][1];
       
        //Accumulate bits
        $sumBytes = $sumBytes + $bitSize;
    
        //Send data out and shift
        $dataInt  = $working8Bytes &  (2**$bitSize -1);
        $working8Bytes = ($working8Bytes >> $bitSize) & (2**(32-$bitSize) -1);
        
        // Used to calculate when to shift data into workingbytes.  
        $remBits = $remBits + $bitSize;
        
        // Shift every 5 bits or 1 byte
        if ($remBits >= 4){
            // check how many bytes to shift
            for($ii = 0; $ii < floor($remBits/4); $ii++){
                if ($shiftCount <= strlen($dataIn)){
                    //Bring shifted data in
                    $working8Bytes = $working8Bytes | (hexdec(substr($dataIn,strlen($dataIn)-$shiftCount,1)) << (32-$remBits));
                    $shiftCount++;
                    $remBits = $remBits - 4;

                }
                else{
                    $working8Bytes = $working8Bytes;
                }
            }
        }
    
        if ($dataStructureIn[$x][0] == "gustMax"){
            $dataOut[$x] = (1/(($dataInt & (2**$bitSize-1))*7.3242))*($dataStructureIn[$x][2]) + $dataStructureIn[$x][3];
            if(is_infinite($dataOut[$x])){
                $dataOut[$x] = 0;
            }
            
        }
        else{
            $dataOut[$x] = (($dataInt & (2**$bitSize-1))*(1.0/$dataStructureIn[$x][2]) + $dataStructureIn[$x][3]);
        }
       // echo $dataInt ." <br>";
    } 
   
    //Create datetime
    $stringTime = $dataOut[0]+2018 . "-" . sprintf("%02d", $dataOut[1]) . "-" . sprintf("%02d", $dataOut[2]) . " " . sprintf("%02d", $dataOut[3]) . ":" . sprintf("%02d", $dataOut[4]) . ":" . sprintf("%02d", $dataOut[5]);
    
   //echo "<br>";
   //  echo $stringTime;
    // echo "<br>";
    //echo "DT check";
    $dataTime = DateTime::createFromFormat('Y-m-d H:i:s', $stringTime);

     //echo "done" . "<br>";    
    return $dataOut;
}


function windDeg2Dir($windDirIN)
{
    

    if ($windDirIN <= 22.5){
        $windDirOut = "N";
    }else if($windDirIN <= 45){
        $windDirOut = "NNE";
    }else if($windDirIN <= 67.5){
        $windDirOut = "NE";
    }else if($windDirIN <= 90){
        $windDirOut = "ENE";
    }else if($windDirIN <= 112.5){
        $windDirOut = "E";
    }else if($windDirIN <= 135){
        $windDirOut = "ESE";
    }else if($windDirIN <= 157.5){
        $windDirOut = "SE";
    }else if($windDirIN <= 180){
        $windDirOut = "SSE";
    }else if($windDirIN <= 202.5){
        $windDirOut = "S";
    }else if($windDirIN <= 225){
        $windDirOut = "SSW";
    }else if($windDirIN <= 247.5){
        $windDirOut = "WSW";
    }else if($windDirIN <= 270){
        $windDirOut = "W";
    }else if($windDirIN <= 292.5){
        $windDirOut = "WNW";
    }else if($windDirIN <= 315){
        $windDirOut = "NW";
    }else if($windDirIN <= 337.5){
        $windDirOut = "NNW";
    }else if($windDirIN <= 360){
        $windDirOut = "N";
    }

    return $windDirOut;
}


function standard_deviation($aValues, $bSample = false)
{
    $fMean = array_sum($aValues) / count($aValues);
    $fVariance = 0.0;
    foreach ($aValues as $i)
    {
        $fVariance += pow($i - $fMean, 2);
    }
    $fVariance /= ( $bSample ? count($aValues) - 1 : count($aValues) );
    return (float) sqrt($fVariance);
}


function arraySin($valIn)
{
    
     for( $i = 0; $i<count($valIn); $i++ ) {
           $out[] = sin($valIn[$i]);
         }
    
    return $out;
}
function arrayCos($valIn)
{
    
     for( $i = 0; $i<count($valIn); $i++ ) {
           $out[] = cos($valIn[$i]);
         }
    
    return $out;
}

function arrayAtan2($sinIn, $cosIn)
{
    if (count($sinIn) == count($cosIn)){
         for( $i = 0; $i<count($sinIn); $i++ ) {
             if(($sinIn > 0) && ($cosIn > 0))  
                 $out[] = atan2($sinIn[$i],$cosIn[$i]);
             else if(($cosIn < 0))
                 $out[] = atan2($sinIn[$i],$cosIn[$i]) + M_PI;
            else if(($sinIn < 0) && ($cosIn > 0))
                $out[] = atan2($sinIn[$i],$cosIn[$i]) + M_PI*2;
             }

        return $out;
    }
    return 0;
}

function stringArray2Num($arrayIN)
{
    
    foreach ($arrayIN as $each_number) {
      $result_array[] = (int) $each_number;
  }
    return $result_array;
}

function arrayMultiply($arrayIN, $scaleFactor)
{
    foreach ($arrayIN as $value) {
        $new_times[] = $value * $scaleFactor;
    }
    return $new_times;
}

function arrayAdd($arrayIN, $offset)
{
    foreach ($arrayIN as $value) {
        $new_times[] = $value + $offset;
    }
    return $new_times;
}

function arrayMod($arrayIN, $val)
{
    foreach ($arrayIN as $value) {
        $new_times[] = $value % $val;
    }
    return $new_times;
}

function nowTime()
{
    date_default_timezone_set('America/Phoenix');
    $dateNow = date('Y-m-d H:i:s');
    return $dateNow;
}

function thenTime($days, $hours, $mins)
{
    date_default_timezone_set('America/Phoenix');
    $dateNow = date('Y-m-d H:i:s');
    $date = (new \DateTime())->modify('-' . $hours .' hours');
    $date->modify('-' . $days .' days');
    $date->modify('-' . $mins .' minutes');
    
    $outTime =  $date->format('Y-m-d H:i:s');
    
    return $outTime;
    
}

function arrayAvg($dataIN)
{
    $dataOUT = array_sum($dataIN) / count($dataIN);
    return $dataOUT;
}

?>

