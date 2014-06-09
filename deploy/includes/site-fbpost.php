<?php
$baseurl = 'https://www.cantstopthefunk.com/';
// $baseurl = 'https://bpginteractive.com/dev/getonup/';
$shareImage = $baseurl.'assets/images/200x200_ShareIcon.jpg';

echo'
<head prefix="og: http://ogp.me/ns fb: http://ogp.me/ns/fb">
<meta property="og:type"         	content="movie">
<meta property="og:url"          	content="'.$baseurl.'">
<meta property="og:title"        	content="title">
<meta property="og:description"  	content="share the site">
<meta property="og:image"        	content="'.$shareImage.'">
';

?>


