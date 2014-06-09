<?php

$pref = '';
if (strrpos($domain, "handheld") > -1)
	$pref = "../";

echo '<script type="text/javascript" src="'.$pref.'api/static/js/vendor/swfobject/swfobject.js"></script>';
echo '<script type="text/javascript" src="'.$pref.'api/static/js/vendor/swffit/swffit.js"></script>';
echo '<script type="text/javascript" src="'.$pref.'api/static/js/vendor/swfaddress/swfaddress.js"></script>';

?>