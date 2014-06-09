<?php 
	require_once 'includes/init.php';

	if($isMobile || $isTablet)
	{
		header("Location: ../../api/index.php/entries/mobile");
	    exit;
	}

	require('./includes/site-doctype.php');
	
	$fbappid 		= "437963243005953";
	if(isset($_GET['id']))
	{
		require('./includes/site-fbpost-video.php');
	}
	else
	{
		require('./includes/site-fbpost.php');
	}
	
?>
		<title>GET ON UP - CAN'T STOP THE FUNK</title>
		<meta name="description" content="" />
		<meta name="keywords" content="" />
		<!--
		<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
		<link rel="canonical" href="" />
		-->
		
		<?php
			//	domain setup for project
			$domain 		= $_SERVER['HTTP_HOST'];
			$deeplinkvalue 	= "flashvars.dl = swfobject.getQueryParamValue('id');";
			$configfile 	= "flashvars.configxml = 'assets/data/siteConfig.xml';";
			$swffile 		= 'assets/flash/shell-100.swf';
			
			if (strrpos($domain, "localhost") > -1)
				$configfile = "flashvars.configxml = 'assets/data/siteConfig-handheld.xml';";
			else if (strrpos($domain, "handheld") > -1)
				$configfile = "flashvars.configxml = 'assets/data/siteConfig-handheld.xml';";
			else if (strrpos($domain, "upqa") > -1)
				$configfile = "flashvars.configxml = 'assets/data/siteConfig-upqa.xml';";
			
			require('./includes/site-css.php');
			require('./includes/jsfiles.php');
			require('./includes/site-flashembed.php');
		?> 			
	</head>
	<body>
		<div id="epk">
		<?php
			require('./includes/site-flashwarning.php');
			require('./includes/seo/site-index-altcontent.php');
		?>
		</div>		
	</body>
</html>
