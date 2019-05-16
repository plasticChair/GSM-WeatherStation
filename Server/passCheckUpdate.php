<?php 
$config = parse_ini_file('/var/www/db.ini');
$passIn = $_GET["userPassword"];


$result = $passIn == $config['userPass'];
if ($passIn == $config['userPass'])
{
    echo "1";
}

//echo "var password = prompt(\"Enter Password\");";
//echo "if (password == " . $config['userPass'] . ");";
//echo "{var status = 1;}";
//echo "else"
//echo "{var status = 0;}";
?>