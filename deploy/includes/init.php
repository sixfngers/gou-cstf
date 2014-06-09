<?php
#
# Requires 
# Mobile_Detect.php, util.php
#
require_once 'lib/Mobile_Detect.php';
require_once 'lib/util.php';

// Read the JSON data
// $data = file_get_contents("./assets/data/data.json");
// $json = json_decode($data, true);


$ipad_mini = "Mozilla/5.0 (iPad; CPU OS 7_1 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D167 Safari/9537.53";
//"Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A406 Safari/8536.25";

$ipad_sim = "Mozilla/5.0 (iPad; CPU OS 7_1 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D167 Safari/9537.53";


$detect = new Mobile_Detect;
$ua = $detect->getUserAgent();

// $detect->setUserAgent($ipad_mini);

$base_href = get_base_href();

// Any mobile device (phones or tablets).
$isMobile = $detect->isMobile();

// Any tablet device.
$isTablet = $detect->isTablet();

// Platfrom detections
$isApple = $detect->isiOS(); 
$isAndroid = $detect->isAndroidOS();

// if ( isset($_GET['m']) && $_GET['m'] == '1') {
// 	$isMobile = true;
// }

// Mobile excluding tablets.
$isPhone = ($isMobile && !$isTablet);


// redirect desktop browsers
// if($isMobile && !$isTablet){
//     header('Location: '.$json['redirect']['mobile']);
// }

$className = ( $isPhone ? "mobile" : ( $isTablet ? "tablet" : "desktop" ) );


// $baseHref = get_base_href();
$scraper = is_scraper($_SERVER['HTTP_USER_AGENT']);

// $q = (isset($_GET['escape_frag'])) ? $_GET['escape_frag']: null ;
// $sanitize = filter_var($q, FILTER_SANITIZE_URL);
// $arr = explode("/", $sanitize);

// $og = $json['meta'];

// $og['url'] = $base_href . '' . $sanitize;

// if (in_array("home", $arr)) {
//     $og['title'] .= "";
// }
// if (in_array("photos", $arr)) {
//     $og['title'] .= " | photos";
// }

// if (in_array("about", $arr)) {
//     $og['title'] .= " | about";
// }
// if (in_array("videos", $arr)) {
//     $og['title'] .= " | videos";
// }


#EOF