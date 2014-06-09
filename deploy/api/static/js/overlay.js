function Overlay(){
	this.overlayContainer = null;
	this.overlayBar = null;
	this.autoplayCheckbox;
	this.imageRotator = null;
	this.interval = null;
	this.autoplayTimer = 8000;
	this.paused = true;
	this.credits = null;
	this.creditsButton = null;

	var $el = $('body');
	this.container = {
    $el: $el,
    w: $el.outerWidth(),
    h: $el.outerHeight(),
    x: $el.offset().left,
    y: $el.offset().top
  };
}

Overlay.prototype.init = function() {
	var that = this;

	this.getOverlayObjs();

	//this.setSize(this.container.w, this.container.h);
	this.setSize(640, 410);

	// $(window).on('resize', function(){
	// 	that.container.w = that.container.$el.outerWidth();
 //    that.container.h = that.container.$el.outerHeight();
	// 	that.setSize(that.container.w, that.container.h);
	// });

	this.checkBox();

	// this.autoplayCheckbox.click(function(){
	// 	that.checkBox();
	// });
	// this.creditsButton.click(function(){
	// 	that.credits.toggleClass('show');
	// });
};

Overlay.prototype.setSize = function(width, height) {
	this.overlayContainer.css({'width': width, 'height': height});
	//this.overlayBar.css({'margin-top': (height / 2)})
}

Overlay.prototype.getOverlayObjs = function() {
	this.overlayContainer = $(".overlay");
	//this.overlayBar = this.overlayContainer.find(".bar");
	//this.autoplayCheckbox = $(".autoplay");
	//this.credits = $(".credits");
	//this.creditsButton = $(".credits .button");
}

Overlay.prototype.forcePlay = function()
{
	console.log('start rotation');
	this.interval = setInterval(function(){
		images.changeImages();
	},this.autoplayTimer);
	this.paused = false;
}

Overlay.prototype.forcePause = function()
{
	console.log('stop rotation');
	clearInterval(this.interval);
	this.interval = null;
	this.paused = true;
}

Overlay.prototype.checkBox = function(){
	var status = this.paused;
	//var status = this.autoplayCheckbox.hasClass("paused");
	if (status)
	{
		this.forcePlay();
		// this.interval = setInterval(function(){
		// 	images.changeImages();
		// },this.autoplayTimer);
		// //this.autoplayCheckbox.removeClass("paused");
		// this.paused = false;
	}
	else
	{
		this.forcePause();
		// console.log('stop rotation');
		// clearInterval(this.interval);
		// //this.autoplayCheckbox.addClass("paused");
		// this.paused = true;
	}
}