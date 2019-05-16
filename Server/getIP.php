<?php 

$dataIn = $_GET["d"];
$config = parse_ini_file('/var/www/db.ini');

if($config['quickPass'] == $dataIn)
{
    
    echo "here";
}

?>