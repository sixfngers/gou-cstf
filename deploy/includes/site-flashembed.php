<?php
echo'
<script type="text/javascript">
		var flashvars = {};
		'.$deeplinkvalue.'
		'.$configfile.'
		
		var	params = {};
		params.play = "true";
		params.menu = "false";
		params.quality = "best";
		params.scale = "noScale";
		params.salign = "TL";
		params.wmode = "opaque";
		params.devicefont = "false";
		params.allowfullscreen = "true";
		params.allowscriptaccess = "always";
		params.allownetworking = "all";
		
		
		var attributes = {};
		attributes.id = "epk";
		attributes.align = "TL";
		attributes.bgColor = "#ffffff";
		
		swfobject.embedSWF("'.$swffile.'", "epk", "100%", "100%", "11.3.0", "expressInstall.swf", flashvars, params, attributes);
		swffit.fit("epk", 1024, 768);
</script>';
?>