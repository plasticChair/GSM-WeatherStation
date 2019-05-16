<html>
<head>
</head>
<body>

<?php 

if(isset($_POST['update']))
{
	
$rowNums = $_POST["rowNum"];
	
echo $rowNums;
$config = parse_ini_file('/var/www/db.ini');
// Create connection
$conn = new mysqli("localhost",$config['username'],$config['password']);


// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
echo "Connected successfully";
echo "\r";


$sql = "USE " . $config['db'];
if ($conn->query($sql) === TRUE) {
    echo "Selected database";
	
} else {
    echo "Database not selected or error: " . $conn->error;
}
echo "\r";


if ($result = $conn->query("SELECT * 
							FROM ( 
									SELECT * 
									FROM mystation 
									ORDER BY 
										ID DESC 
									LIMIT $rowNums 
									) q 
									ORDER BY 
									ID ASC" )) {
    printf("Select returned %d rows.\n", $result->num_rows);

    /* free result set */
    //$result->close();
}

echo "<br>";
if (mysqli_num_rows($result) > 0) {
		echo "ID	 	DateTime		TempOutCur		TempOutCur		PressOutCur		WindOutCur <br>";
		while($row = mysqli_fetch_assoc($result)) {
		   echo $row["ID"] . "	\t\t\t\t\t	" . $row["DateTime"] . "	\t\t\t\t\t\t	" . $row["TempOutCur"] . "	\t\t	" . $row["TempOutCur"] ."	\t\t	" . $row["PressOutCur"] ."	\t\t	" . $row["WindOutCur"] ." <br>";
		}
	 }
 else {
		echo "0 results";
	 }
$result->close();


$conn->close();
}


?>


  
  <form action="<?php $_PHP_SELF ?>" method="post">
  Num Rows: <input type="text" name="rowNum"><br>
  <input type="submit" name = "update" value="Update">
</form>



<font face="century gothic" size="20px"?
	<center>Hello data</center>
</font>

</body>
</html>
