<?php
$baseurl = 'https://www.cantstopthefunk.com/';
// $baseurl = 'https://bpginteractive.com/dev/getonup/';
$imageurl = $baseurl;

$passedId = $_GET["id"];
//$passedImage = $_GET["img"];
$passedImage = "a2b01b48b3d15a14629e95ad11d1e1cfmov.png";
//$shareImage = $baseurl.'fpo200.png';
$videoShareImage = $baseurl.$passedImage;

$uidParam = '?id='.$passedId;
$shareDeeplinkPath = $baseurl.$uidParam;
$shareSwfPath = $baseurl.'assets/flash/sharePlayerShell102.swf'.$uidParam;
//$shareImage = $passedImage;

echo'
<head prefix="og: http://ogp.me/ns fb: http://ogp.me/ns/fb">
<meta property="fb:app_id"      	content="'.$fbappid.'">
<meta property="og:type"         	content="movie">
<meta property="og:url"          	content="'.$shareDeeplinkPath.'">
<meta property="og:title"        	content="Can&apos;t Stop the Funk!">
<meta property="og:description"  	content="I just danced to Sex Machine along with the one and only James Brown! Visit CAN’T STOP THE FUNK to see my moves. #GetOnUp. In theaters this summer!">
<meta property="og:image"        	content="'.$baseurl.'assets/images/200x200_ShareIcon.jpg">
<meta property="og:video" 			content="'.$shareSwfPath.'" >
<meta property="og:video:width" 	content="470">
<meta property="og:video:height" 	content="345">
<meta property="og:video:type" 		content="application/x-shockwave-flash">
';
?>


