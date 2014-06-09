function ImageRotation(){
	this.isLoading = false;
	this.allDataLoaded = false;
	this.offset = 0;
	this.totalImagesInDb = 0;
	this.imagesPerLoad = 30;
	this.loadGifsApiUrl ='get_gif/'+this.imagesPerLoad+'/';
	this.unusedImages = null;
	this.usedImages = new Array();
	this.nextImage = null;
	this.overlay = null;

	this.imageContainers = {
		image1: {
			container: null
			,idDiv: null
			,nameDiv: null
			,foreground: null
		},
		image2: {
			container: null
			,idDiv: null
			,nameDiv: null
			,foreground: null
		},
		image3: {
			container: null
			,idDiv: null
			,nameDiv: null
			,foreground: null
		},
		image4: {
			container: null
			,idDiv: null
			,nameDiv: null
			,foreground: null
		},
		image5: {
			container: null
			,idDiv: null
			,nameDiv: null
			,foreground: null
		}
	};

	this.current_image = null;
	this.next_image	= null;

	this.baseURL = null;
	this.uploadsPath = null;
	this.gifPath = null;
	this.margin = 0;
	this.fadeDuration = 1000;

	var $el = $('body');
	this.container = {
    $el: $el,
    w: $el.outerWidth(),
    h: $el.outerHeight(),
    x: $el.offset().left,
    y: $el.offset().top
  };
}


ImageRotation.prototype.init = function(submissionReturn) {
	var that = this;

	this.getImageObjs();

	this.setSize(this.container.w, this.container.h);

	if(submissionReturn != '')
	{
		var obj = jQuery.parseJSON(submissionReturn);
		console.log(obj);
		console.log('put submissionReturn into unused images at front '+obj.data);
		images.unusedImages.unshift(obj.data);
	}
	else
	{
		console.log('nothing to inject');
	}

	$.each( this.imageContainers, function( key, value ) {
		that.getNextImage();
		that.setImage(value.foreground, that.nextImage);
		that.setParam(value.idDiv, that.nextImage.id);
		that.setParam(value.nameDiv, that.nextImage.name);
		//that.setImage(value.background, that.nextImage);
		// value.container.click(function(e){
		// 	console.log(that.current_image.find('.idContainer').text());
		// 	if(that.overlay.paused) {
		// 		that.changeImages();
		// 	}
		// });
	});

	$(window).on('resize', function(){
		that.container.w = that.container.$el.outerWidth();
    	that.container.h = that.container.$el.outerHeight();
		that.setSize(that.container.w, that.container.h);
	});

	$('.overlay').click(function(e){
		console.log('current image id = ' + $('.currentimage .idContainer').text());
	});

};

ImageRotation.prototype.setSize = function(width, height) {
	var that = this
	$.each( this.imageContainers, function( key, value ) {
		// value.container.css({'width': width, 'height': height, 'margin': 'auto'});
		
		// if (width < 700) {
		// 	value.foreground.css({'width': width, 'height': height, 'margin': 'auto'});
		// }
		//  else {
		// 	value.foreground.css({'width': width - (that.margin * 2), 'height': height - (that.margin * 2), 'margin': that.margin});
		// }

		// value.background.css({'width': width, 'height': height});
	});
}

ImageRotation.prototype.repopulateData = function()
{
	
	isLoading = true;
	console.log('loadGifsApiUrl: ' + this.loadGifsApiUrl + this.offset);
	$.get( this.loadGifsApiUrl + this.offset, function( data )
	{
		isLoading = false;
		images.offset += images.imagesPerLoad;
		if(data.data.entries.length == 0)
		{
			
			this.allDataLoaded = true;
		}
		
		//console.log(data.data.entries + ' ' + this.allDataLoaded);
		//console.log(data.data.entries.length);
		images.unusedImages = data.data.entries;
	}, "json" )
	.error(function(){
		isLoading = false;
	    console.log('using hard coded list');
	    // localhost hard coded images
	    images.unusedImages = [{"id":"9","timestamp":"2014-05-02 18:08:50","name":"ilsa","base_path":"","image_path":"200324f9ce6ed1448527586b8b45053aflv.png","gif_path":"ebd59227e54b03a2bb6cfe8e1984020dflv.gif","video_path":"200324f9ce6ed1448527586b8b45053a.flv","origin":"0"},{"id":"8","timestamp":"2014-05-02 18:07:37","name":"bones","base_path":"","image_path":"200324f9ce6ed1448527586b8b45053aflv.png","gif_path":"e7a564049576a4fa6e7af5c6d2c5fb9bflv.gif","video_path":"200324f9ce6ed1448527586b8b45053a.flv","origin":"0"},{"id":"7","timestamp":"2014-05-02 18:06:15","name":"bonner","base_path":"","image_path":"200324f9ce6ed1448527586b8b45053aflv.png","gif_path":"cca184436ac174f2ce7520ff79239fa9flv.gif","video_path":"200324f9ce6ed1448527586b8b45053a.flv","origin":"0"},{"id":"6","timestamp":"2014-05-02 18:05:31","name":"stephania","base_path":"","image_path":"200324f9ce6ed1448527586b8b45053aflv.png","gif_path":"908856e07c6fa01e23732ace70485ceaflv.gif","video_path":"200324f9ce6ed1448527586b8b45053a.flv","origin":""},{"id":"5","timestamp":"2014-05-02 18:03:03","name":"natasha","base_path":"","image_path":"4702111234609201519flv.png","gif_path":"200324f9sdasdce6448527586b8b45053aflv.gif","video_path":"4702111234609201519.flv","origin":""},{"id":"4","timestamp":"2014-05-02 17:56:30","name":"nick","base_path":"","image_path":"4702111234609201519flv.png","gif_path":"7872ffb182a835f8f4a47471a10baeeemov.gif","video_path":"4702111234609201519.flv","origin":""},{"id":"3","timestamp":"2014-04-30 15:53:58","name":"josh","base_path":"","image_path":"ed8979f9af36fc424112299865f76745flv.png","gif_path":"1976cbac89e1e8b0661d1eed7a159134flv.gif","video_path":"ed8979f9af36fc424112299865f76745.flv","origin":""},{"id":"2","timestamp":"2014-04-30 15:52:52","name":"mandy","base_path":"","image_path":"ed8979f9af36fc424112299865f76745flv.png","gif_path":"ed8979f9af36fc424112299865f76745flv.gif","video_path":"ed8979f9af36fc424112299865f76745.flv","origin":""}];
	    
	    // handheld hard coded images
	    //images.unusedImages = [{"id":"120","timestamp":"2014-05-16 17:41:10","name":"Charisse Mannolini","base_path":"","image_path":"19a6aa75260c25cb0ed5510203725980flv.png","gif_path":"19a6aa75260c25cb0ed5510203725980flv.gif","video_path":"19a6aa75260c25cb0ed5510203725980.flv","origin":""},{"id":"119","timestamp":"2014-05-16 17:40:13","name":"Sean Leu","base_path":"","image_path":"228561eb0f1691c2983cfc434c85f4dcflv.png","gif_path":"228561eb0f1691c2983cfc434c85f4dcflv.gif","video_path":"228561eb0f1691c2983cfc434c85f4dc.flv","origin":""},{"id":"113","timestamp":"2014-05-15 17:39:45","name":"jason chan","base_path":"","image_path":"c7d766f012f2a7007739b68d679384e3flv.png","gif_path":"c7d766f012f2a7007739b68d679384e3flv.gif","video_path":"c7d766f012f2a7007739b68d679384e3.flv","origin":""},{"id":"107","timestamp":"2014-05-15 12:11:35","name":"CBones2009","base_path":"","image_path":"5b2f4ffced80f5f525e3a658e88c0f9fmov.png","gif_path":"5b2f4ffced80f5f525e3a658e88c0f9fmov.gif","video_path":"5b2f4ffced80f5f525e3a658e88c0f9f.mov","origin":""},{"id":"101","timestamp":"2014-05-14 10:52:41","name":"Tester JB","base_path":"","image_path":"01e65b7b5ab93f6b8e022e759fadbad3mov.png","gif_path":"01e65b7b5ab93f6b8e022e759fadbad3mov.gif","video_path":"01e65b7b5ab93f6b8e022e759fadbad3.mov","origin":""},{"id":"99","timestamp":"2014-05-13 18:32:45","name":"costumed","base_path":"","image_path":"550fcf6359b0c0eb84ec71c237df709amov.png","gif_path":"550fcf6359b0c0eb84ec71c237df709amov.gif","video_path":"550fcf6359b0c0eb84ec71c237df709a.mov","origin":""},{"id":"98","timestamp":"2014-05-13 18:29:20","name":"lineup","base_path":"","image_path":"3ed0f6937e2f3ac012328a2214e56c02mov.png","gif_path":"3ed0f6937e2f3ac012328a2214e56c02mov.gif","video_path":"3ed0f6937e2f3ac012328a2214e56c02.mov","origin":""},{"id":"97","timestamp":"2014-05-13 18:27:20","name":"funkychicken","base_path":"","image_path":"856f3a5d8a32ea011e17aa575637b66emov.png","gif_path":"856f3a5d8a32ea011e17aa575637b66emov.gif","video_path":"856f3a5d8a32ea011e17aa575637b66e.mov","origin":""},{"id":"96","timestamp":"2014-05-13 18:24:17","name":"kollab","base_path":"","image_path":"cf2b4565cae56edac86d22bfa1648dbdmov.png","gif_path":"cf2b4565cae56edac86d22bfa1648dbdmov.gif","video_path":"cf2b4565cae56edac86d22bfa1648dbd.mov","origin":""},{"id":"95","timestamp":"2014-05-13 18:22:39","name":"al mins","base_path":"","image_path":"0e02aee4939baf83c5ba0e0b7a49486emov.png","gif_path":"0e02aee4939baf83c5ba0e0b7a49486emov.gif","video_path":"0e02aee4939baf83c5ba0e0b7a49486e.mov","origin":""},{"id":"93","timestamp":"2014-05-13 18:16:48","name":"TwistPony","base_path":"","image_path":"f55a14008e55214dc893adbe9b1f3968mov.png","gif_path":"f55a14008e55214dc893adbe9b1f3968mov.gif","video_path":"f55a14008e55214dc893adbe9b1f3968.mov","origin":""}];

	});
}

ImageRotation.prototype.getNextImage = function() {
	if (this.unusedImages.length === 0)
	{
		if(this.isLoading == false)
		{
			if(this.offset < this.totalImagesInDb)
			{
				// make a call to repopulate the array;
				console.log('repopulate data');
				this.repopulateData();
			}
		}
			
		// pick a single image from the used array to hold us over
		var firstUsedObject = this.usedImages[0];
		this.usedImages.splice(0, 1);

		this.unusedImages.push(firstUsedObject);
		// old way just dump the full array of used images into the unused images array
		//this.unusedImages = this.usedImages; this.usedImages = [];
	}
	
	//console.log('this.unusedImages.length: '+this.unusedImages.length);
	//console.log('this.unusedImages: '+this.unusedImages);
	var length = this.unusedImages.length;
	var pick = 0//Math.floor(Math.random() * (length));
	var nextObject = this.unusedImages[pick];
	
	this.unusedImages.splice(pick, 1);
	this.usedImages.push(nextObject);

	this.nextImage = nextObject;
}

ImageRotation.prototype.setImage = function(obj, nextImage)
{
	var definedBaseUrl = this.baseURL + this.uploadsPath + this.gifPath;
	//console.log('base_path: '+nextImage.base_path)
	
	if(nextImage.base_path.length > 0)
	{
		definedBaseUrl = nextImage.base_path + this.gifPath;
	}

	//console.log('set image url("' + definedBaseUrl + nextImage.gif_path + '")');
	obj.css({'background-image': 'url("' + definedBaseUrl + nextImage.gif_path + '")'});
}

ImageRotation.prototype.setParam = function(obj, param)
{
	obj.text(param);
}

ImageRotation.prototype.changeImages = function()
{
	console.log('change images');
	if (!this.container.$el.hasClass('animating')){
		this.container.$el.addClass('animating');
		this.getImageObjs();
		var that = this
		$('.currentimage').fadeOut(this.fadeDuration,function(){
			$('.currentimage').removeClass('currentimage').addClass('previmage');
			var next = $('.nextimage');
			var nextSibling = (next.next().length) ? next.next() : next.prevAll().last();
			$('.nextimage').addClass('currentimage').removeClass('nextimage');
			nextSibling.addClass('nextimage');
			$('.previmage').show();
			$('.previmage').removeClass('previmage');
			$.each( that.imageContainers, function( key, value ) {
				var order = value.container.data('order');
				order = order - 1;
				value.container.data('order', value);
			});
			that.getNextImage();

			that.setParam(that.current_image.find('.idContainer'), that.nextImage.id);
			that.setParam(that.current_image.find('.nameContainer'), that.nextImage.name);
			that.setImage(that.current_image.find('.image'), that.nextImage);
			//that.setImage(that.current_image.find('.bg'), that.nextImage);
			
			that.container.$el.removeClass('animating');
		});
	}
}

ImageRotation.prototype.getImageObjs = function() {
	var that = this;
	$.each( this.imageContainers, function( key, value ) {
  	value.container = $("." + key);
  	value.foreground = value.container.find(".image");
  	value.idDiv = value.container.find(".idContainer");
  	value.nameDiv = value.container.find(".nameContainer");
  	//value.background = value.container.find(".bg");
	});
	this.current_image = $('.currentimage');
	this.next_image = $('.nextimage');
	
}