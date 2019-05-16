<?php header("Content-type: text/css"); ?>
body,
html {

   }

body {
 }


<?php
include 'init.php';
$config = parse_ini_file('/var/www/db.ini');
// Create connection
$conn = new mysqli("localhost",$config['username'],$config['password'], $config['db']);

// Check connection
if ($conn->connect_error) {
    die($conn->connect_error);
} 

$nowStr = nowTime();
$thenStr = thenTime(0, 0, 5);

$result = $conn->query("SELECT * FROM mystation WHERE DateTime >= '" . $thenStr . "' and DateTime <= '" . $nowStr . "'");
 
if (mysqli_num_rows($result) > 0) {
    while($row = mysqli_fetch_assoc($result)) {
        $windSpd[] = $row['windSpd'];       
    }
 }
$windSF = 2000;  //slow speed 5000ms, fast: 200ms.  max MPH: 35.  SF = (5000-200)/35
if (count($windSpd) >= 1){
    $AvgWindSpd = arrayAvg($windSpd);
}else{
    $AvgWindSpd = 0;
}
if ($AvgWindSpd <1.5){
    $windNow = 15000;
}else{
    $windNow = 4261*exp(-0.109*$AvgWindSpd); //number_format((float)$windSpd[count($windSpd)-1] , 1, '.', '');
}

?>


.caixa {
  position: absolute;
  top: 5%;
  left: 75%;
  height: 150px;
  width: 150px;
  margin-top: -25px;
  margin-left: -125px;
  -webkit-animation-name: cataVento;
  animation-name: cataVento;
  -webkit-animation-iteration-count: infinite;
  animation-iteration-count: infinite;
  -webkit-animation-duration: <?php echo $windNow; ?>ms;
  animation-duration: <?php echo $windNow; ?>ms;
  -webkit-animation-timing-function: linear;
  animation-timing-function: linear;
  animation-direction: reverse;
  background: url("http://www.cataventofotografia.com.br/wp-content/uploads/2015/11/logo-g.png") center center no-repeat;
  background-size: 100%;
  z-index: 500;
  position: relative; }

i {
  z-index: 1;
  background: brown;
  content: "";
  -webkit-animation-name: none;
  animation-name: none;
  position: relative;
    left: 30px;
	bottom: 50px;
position: relative;
  bottom: 40;
  top: 50%;
  left: 50%;
  width: 10px;
  height: 70px;
  display: block; }
  
  .nuvem {
  width: 2000px;
  height: 60px;
  background: #fff;
  border-radius: 200px;
  position: absolute;
}


#background-wrap {
    bottom: 0;
	left: 0;
	padding-top: 50px;
	position: fixed;
	right: 0;
	top: 0;
	z-index: -1;
}

@-webkit-keyframes cataVento {
  from {
    -webkit-transform: rotateZ(0deg);
    transform: rotateZ(0deg); }
  to {
    -webkit-transform: rotateZ(-360deg);
    transform: rotateZ(-360deg); } }
@keyframes cataVento {
  from {
    -webkit-transform: rotateZ(0deg);
    transform: rotateZ(0deg); }
  to {
    -webkit-transform: rotateZ(-360deg);
    transform: rotateZ(-360deg); } }

	@-webkit-keyframes move-nuvem {
  from {
    margin-left: 1400px;
  }
  to {
    margin-left: -1400px;
  }
/* KEYFRAMES */

@-webkit-keyframes animateCloud {
    0% {
        margin-left: -1000px;
    }
    100% {
        margin-left: 100%;
    }
}

@-moz-keyframes animateCloud {
    0% {
        margin-left: -1000px;
    }
    100% {
        margin-left: 100%;
    }
}

@keyframes animateCloud {
    0% {
        margin-left: -1000px;
    }
    100% {
        margin-left: 100%;
    }
}

/* ANIMATIONS */

.x1 {
	-webkit-animation: animateCloud 35s linear infinite;
	-moz-animation: animateCloud 35s linear infinite;
	animation: animateCloud 35s linear infinite;
	
	-webkit-transform: scale(0.65);
	-moz-transform: scale(0.65);
	transform: scale(0.65);
}

.x2 {
	-webkit-animation: animateCloud 20s linear infinite;
	-moz-animation: animateCloud 20s linear infinite;
	animation: animateCloud 20s linear infinite;
	
	-webkit-transform: scale(0.3);
	-moz-transform: scale(0.3);
	transform: scale(0.3);
}

.x3 {
	-webkit-animation: animateCloud 30s linear infinite;
	-moz-animation: animateCloud 30s linear infinite;
	animation: animateCloud 30s linear infinite;
	
	-webkit-transform: scale(0.5);
	-moz-transform: scale(0.5);
	transform: scale(0.5);
}

.x4 {
	-webkit-animation: animateCloud 18s linear infinite;
	-moz-animation: animateCloud 18s linear infinite;
	animation: animateCloud 18s linear infinite;
	
	-webkit-transform: scale(0.4);
	-moz-transform: scale(0.4);
	transform: scale(0.4);
}

.x5 {
	-webkit-animation: animateCloud 25s linear infinite;
	-moz-animation: animateCloud 25s linear infinite;
	animation: animateCloud 25s linear infinite;
	
	-webkit-transform: scale(0.55);
	-moz-transform: scale(0.55);
	transform: scale(0.55);
}

/* OBJECTS */

.cloud {
    height: 120px;
	position: relative;
	width: 350px;
	background: #fff;
	background: -moz-linear-gradient(top,  #fff 5%, #f1f1f1 100%);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(5%,#fff), color-stop(100%,#f1f1f1));
	background: -webkit-linear-gradient(top,  #fff 5%,#f1f1f1 100%);
	background: -o-linear-gradient(top,  #fff 5%,#f1f1f1 100%);
	background: -ms-linear-gradient(top,  #fff 5%,#f1f1f1 100%);
	background: linear-gradient(top,  #fff 5%,#f1f1f1 100%);
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fff', endColorstr='#f1f1f1',GradientType=0 );
	
	-webkit-border-radius: 100px;
	-moz-border-radius: 100px;
	border-radius: 100px;
	
	-webkit-box-shadow: 0 8px 5px rgba(0, 0, 0, 0.1);
	-moz-box-shadow: 0 8px 5px rgba(0, 0, 0, 0.1);
	box-shadow: 0 8px 5px rgba(0, 0, 0, 0.1);


}

.cloud:after, .cloud:before {
    background: #fff;
	content: '';
	position: absolute;
	z-indeX: -1;
}

.cloud:after {
    	height: 100px;
	left: 50px;
	top: -50px;
	width: 100px;
    	border-radius: 100px;
	-webkit-border-radius: 100px;
	-moz-border-radius: 100px;



}

.cloud:before {
    	width: 180px;
	height: 180px;
	right: 50px;
	top: -90px;
    	border-radius: 200px;


	-webkit-border-radius: 200px;
	-moz-border-radius: 200px;

}



/*# sourceMappingURL=test.css.map */
