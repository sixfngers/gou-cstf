<?php
echo'
<!-- BEGIN FACEBOOK EMBED -->
<div id="fb-root"></div>
<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>
<script type="text/javascript">
  FB.init({
	   /********************************************************
	   *Each country has its own key, if localizing Facebook. */
	   appId  : '.$fbappid.',
	   status : true,
	   cookie : true,
	   oauth  : true
  });
</script>
';
?>
