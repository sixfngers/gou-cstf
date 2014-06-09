<?php

$prefix 		= '';
//	releaseMonth is calendar based
//	1=jan, 2=feb, 12=december etc...
$releaseMonth 	= 4;
$releaseDay 	= 13;
$releaseYear 	= 2012;


echo('
<script language="javascript" type="text/javascript">
	var releaseDateMonth 	= '.($releaseMonth - 1).';
	var releaseDateDay 		= '.($releaseDay).';
	var releaseDateYear 	= '.($releaseYear).';

	var releaseDay = new Date(releaseDateYear,releaseDateMonth,releaseDateDay);
	var dayBefore = new Date(releaseDateYear,releaseDateMonth,27);
	var weekOf = new Date(releaseDateYear,releaseDateMonth,24);
	var current = new Date();

	if(current >= releaseDay){
		document.title = "'.$prefix.' | Now Playing";
	}else{
		document.title = "'.$prefix.' | In Theaters April 13, 2012";
	}
	</script>

');
?>