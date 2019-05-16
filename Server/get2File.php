<?php 

//Working!

$my_file = 'file.txt';
$handle = fopen($my_file, 'a') or die('Cannot open file:  '.$my_file); //implicitly creates file



$temperature = $_GET["temperature"];
$wind = $_GET["wind"];
$time = $_GET["time"];

echo $temperature;
echo "<br>";
echo $wind;
echo "<br>";
echo $time;
echo "<br>";


fwrite($handle, "$temperature, $wind, $time\n");


fclose($handle);

?>


<font face="century gothic" size="20px"?
	<center>Hello World</center>
</font>