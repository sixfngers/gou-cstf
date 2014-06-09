$(function(){
images = new ImageRotation();
overlay = new Overlay();

overlay.imageRotator = images;
images.overlay = overlay;
images.uploadsPath = 'api/uploads/final/';
images.gifPath = 'gif/';
images.margin = 100;

images.baseURL = "http://cantstopthefunk.com";

if (window.location.href.indexOf('localhost') > -1) 
{
  images.baseURL = "http://localhost:8888/getonup/build/flash/deploy/";
}
else if(window.location.href.indexOf('handheldpress') > -1)
{
  images.baseURL = "http://handheldpress.net/";
}
else if (window.location.href.indexOf('upqa') > -1) 
{
  images.baseURL = "http://eternaljamesbrown.upqa.com/";
};




function hideStatusPanel()
{
  $('.form-header .process').addClass('force-hide');
  $('.form-header .success').addClass('force-hide');
  $('.form-header .fail').addClass('force-hide');
  $('.status-reason').text('');
  $('.status').addClass('force-hide');
  $('.status-back').addClass('force-hide');
};

function share(type)
{
  var id = $('.currentimage .idContainer').text();
  var usersGifUrl = $('.currentimage .image').css('background-image');
      usersGifUrl = usersGifUrl.replace('url(','').replace(')','');
      usersGifUrl = usersGifUrl.replace('https://bannerassets.universalstudios.com/up/cantstopthefunk/final/gif/','https://bannerassets.universalstudios.com/up/cantstopthefunk/final/gif/share_');

  var baseUrl = 'https://cantstopthefunk.com/';
  if(window.location.href.indexOf('localhost') > -1 || window.location.href.indexOf('handheldpress') > -1 || window.location.href.indexOf('upqa') > -1)
  {
    baseUrl = 'https://bpginteractive.com/dev/getonup/';
    
    if(window.location.href.indexOf('upqa') > -1)
    {
      usersGifUrl = usersGifUrl.replace('https://bannerassets.universalstudios.com/up/cantstopthefunk/QA/gif/','https://bannerassets.universalstudios.com/up/cantstopthefunk/QA/gif/share_');
    }
    else
    {
      usersGifUrl = 'https://bannerassets.universalstudios.com/up/cantstopthefunk/QA/gif/dc0d3d84ca0bd13ddd42c84b585a731cmp4.gif'  
    }
  }

  var deeplinkUrl = baseUrl + '?id='+id;
  var href = '';

  if(type == 'facebook')
  {
    href='https://www.facebook.com/sharer.php?u='+deeplinkUrl;
  }

  if(type == 'twitter')
  {
    var twitterShareUrl = 'https://twitter.com/intent/tweet?text=';
    var prefix = "Can't Stop the Funk! I just danced with James Brown at ";
    var suffix = "! Join the celebration.";
    href = twitterShareUrl + prefix + deeplinkUrl + suffix;
  }

  if(type == 'pintrest')
  {
    var pinShareUrl = 'http://www.pinterest.com/pin/create/button/?';
    var pinimageParam = 'media=';
    var pinUrlParam = '&url=';
    var pinDescriptionParam = '&description=';
    var pinDescription = "I just added my video to CAN'T STOP THE FUNK!, dancing along with the one and only James Brown! Join in the celebration!";
    href = pinShareUrl + pinimageParam + usersGifUrl + pinUrlParam + deeplinkUrl + pinDescriptionParam + pinDescription;
  }

  if(type == 'tumblr')
  {
    var tumblrShareUrl = "http://www.tumblr.com/share/photo?";
    var sourceParam = 'source=';
    var captionParam = '&caption=';
    var linkParam = '&click_thru=';
    var caption = "I just added my video to CAN'T STOP THE FUNK!, dancing along with the one and only James Brown! Join in the celebration!";
    

    href = tumblrShareUrl + sourceParam + encodeURIComponent(usersGifUrl) + captionParam + caption + linkParam + encodeURIComponent(deeplinkUrl);
  }

  if(type == 'google')
  {
    var googleShareUrl = "https://plus.google.com/share?";
    var googleLinkParam = 'url=';

    href = googleShareUrl + googleLinkParam + deeplinkUrl;
  }

  //console.log('share ' + href);
  window.open(href, '_blank');
}

images.isLoading = true;

console.log('injectObj: '+injectObj);

$.get( images.loadGifsApiUrl + images.offset, function( data )
//$.get( "../../../api/index.php/entries/get_gif/30/", function( data )
{
    images.isLoading = false;
    images.offset += images.imagesPerLoad;
    images.unusedImages = data.data.entries;

    images.totalImagesInDb = data.data.total;

    overlay.init();
    images.init(injectObj);
}, "json" )
    .error(function(){
        images.isLoading = false;
        images.allDataLoaded = true;

        console.log('using hard coded list');
        // localhost hard coded images
        images.unusedImages = [{"id":"9","timestamp":"2014-05-02 18:08:50","name":"ilsa","base_path":"","image_path":"200324f9ce6ed1448527586b8b45053aflv.png","gif_path":"ebd59227e54b03a2bb6cfe8e1984020dflv.gif","video_path":"200324f9ce6ed1448527586b8b45053a.flv","origin":"0"},{"id":"8","timestamp":"2014-05-02 18:07:37","name":"bones","base_path":"","image_path":"200324f9ce6ed1448527586b8b45053aflv.png","gif_path":"e7a564049576a4fa6e7af5c6d2c5fb9bflv.gif","video_path":"200324f9ce6ed1448527586b8b45053a.flv","origin":"0"},{"id":"7","timestamp":"2014-05-02 18:06:15","name":"bonner","base_path":"","image_path":"200324f9ce6ed1448527586b8b45053aflv.png","gif_path":"cca184436ac174f2ce7520ff79239fa9flv.gif","video_path":"200324f9ce6ed1448527586b8b45053a.flv","origin":"0"},{"id":"6","timestamp":"2014-05-02 18:05:31","name":"stephania","base_path":"","image_path":"200324f9ce6ed1448527586b8b45053aflv.png","gif_path":"908856e07c6fa01e23732ace70485ceaflv.gif","video_path":"200324f9ce6ed1448527586b8b45053a.flv","origin":""},{"id":"5","timestamp":"2014-05-02 18:03:03","name":"natasha","base_path":"","image_path":"4702111234609201519flv.png","gif_path":"200324f9sdasdce6448527586b8b45053aflv.gif","video_path":"4702111234609201519.flv","origin":""},{"id":"4","timestamp":"2014-05-02 17:56:30","name":"nick","base_path":"","image_path":"4702111234609201519flv.png","gif_path":"7872ffb182a835f8f4a47471a10baeeemov.gif","video_path":"4702111234609201519.flv","origin":""},{"id":"3","timestamp":"2014-04-30 15:53:58","name":"josh","base_path":"","image_path":"ed8979f9af36fc424112299865f76745flv.png","gif_path":"1976cbac89e1e8b0661d1eed7a159134flv.gif","video_path":"ed8979f9af36fc424112299865f76745.flv","origin":""},{"id":"2","timestamp":"2014-04-30 15:52:52","name":"mandy","base_path":"","image_path":"ed8979f9af36fc424112299865f76745flv.png","gif_path":"ed8979f9af36fc424112299865f76745flv.gif","video_path":"ed8979f9af36fc424112299865f76745.flv","origin":""}];
        
        // handheld hard coded images
        //images.unusedImages = [{"id":"120","timestamp":"2014-05-16 17:41:10","name":"Charisse Mannolini","base_path":"","image_path":"19a6aa75260c25cb0ed5510203725980flv.png","gif_path":"19a6aa75260c25cb0ed5510203725980flv.gif","video_path":"19a6aa75260c25cb0ed5510203725980.flv","origin":""},{"id":"119","timestamp":"2014-05-16 17:40:13","name":"Sean Leu","base_path":"","image_path":"228561eb0f1691c2983cfc434c85f4dcflv.png","gif_path":"228561eb0f1691c2983cfc434c85f4dcflv.gif","video_path":"228561eb0f1691c2983cfc434c85f4dc.flv","origin":""},{"id":"113","timestamp":"2014-05-15 17:39:45","name":"jason chan","base_path":"","image_path":"c7d766f012f2a7007739b68d679384e3flv.png","gif_path":"c7d766f012f2a7007739b68d679384e3flv.gif","video_path":"c7d766f012f2a7007739b68d679384e3.flv","origin":""},{"id":"107","timestamp":"2014-05-15 12:11:35","name":"CBones2009","base_path":"","image_path":"5b2f4ffced80f5f525e3a658e88c0f9fmov.png","gif_path":"5b2f4ffced80f5f525e3a658e88c0f9fmov.gif","video_path":"5b2f4ffced80f5f525e3a658e88c0f9f.mov","origin":""},{"id":"101","timestamp":"2014-05-14 10:52:41","name":"Tester JB","base_path":"","image_path":"01e65b7b5ab93f6b8e022e759fadbad3mov.png","gif_path":"01e65b7b5ab93f6b8e022e759fadbad3mov.gif","video_path":"01e65b7b5ab93f6b8e022e759fadbad3.mov","origin":""},{"id":"99","timestamp":"2014-05-13 18:32:45","name":"costumed","base_path":"","image_path":"550fcf6359b0c0eb84ec71c237df709amov.png","gif_path":"550fcf6359b0c0eb84ec71c237df709amov.gif","video_path":"550fcf6359b0c0eb84ec71c237df709a.mov","origin":""},{"id":"98","timestamp":"2014-05-13 18:29:20","name":"lineup","base_path":"","image_path":"3ed0f6937e2f3ac012328a2214e56c02mov.png","gif_path":"3ed0f6937e2f3ac012328a2214e56c02mov.gif","video_path":"3ed0f6937e2f3ac012328a2214e56c02.mov","origin":""},{"id":"97","timestamp":"2014-05-13 18:27:20","name":"funkychicken","base_path":"","image_path":"856f3a5d8a32ea011e17aa575637b66emov.png","gif_path":"856f3a5d8a32ea011e17aa575637b66emov.gif","video_path":"856f3a5d8a32ea011e17aa575637b66e.mov","origin":""},{"id":"96","timestamp":"2014-05-13 18:24:17","name":"kollab","base_path":"","image_path":"cf2b4565cae56edac86d22bfa1648dbdmov.png","gif_path":"cf2b4565cae56edac86d22bfa1648dbdmov.gif","video_path":"cf2b4565cae56edac86d22bfa1648dbd.mov","origin":""},{"id":"95","timestamp":"2014-05-13 18:22:39","name":"al mins","base_path":"","image_path":"0e02aee4939baf83c5ba0e0b7a49486emov.png","gif_path":"0e02aee4939baf83c5ba0e0b7a49486emov.gif","video_path":"0e02aee4939baf83c5ba0e0b7a49486e.mov","origin":""},{"id":"93","timestamp":"2014-05-13 18:16:48","name":"TwistPony","base_path":"","image_path":"f55a14008e55214dc893adbe9b1f3968mov.png","gif_path":"f55a14008e55214dc893adbe9b1f3968mov.gif","video_path":"f55a14008e55214dc893adbe9b1f3968.mov","origin":""}];
        
        overlay.init();
        images.init(injectObj);
    });


  var salt = 'chadbos|jambro'
  var genhash = function(context) {
    var f = context.attr('id');
    var s = '';
    if (f === 'submit') {
      s += $('input[name=name]',context).val();
      s += $('input[name=video_path]',context).val();
    }
    s += salt;

    s = s.replace(/[^$a-z0-9_]/gi, '');
    s = calcMD5(s);
    s = s.substring(5,15);
    return s;
  };

  var recalculateHash = function(context) {
    $('input[name=s]',context).val(genhash(context));
  };

  $('form').each(function(){
    var $form = $(this);
    $('input[name!=s]',$form).on('change keyup', function(){recalculateHash($form)});
    recalculateHash($form);
  });

$('.submit-dance').click(function (event) {
  event.preventDefault();
  $('.upload-form').removeClass('force-hide');
  $('.share-container').addClass('force-hide');
  $('.share-overlay-content').addClass('force-hide');
  overlay.forcePause();
});

$('.status-back').click(function (event) {
  event.preventDefault();
  hideStatusPanel();
  //$('.share-container').removeClass('force-hide');
  //overlay.forcePlay();
});

$('.status-home').click(function (event) {
  event.preventDefault();
  hideStatusPanel();
  $('.share-container').removeClass('force-hide');
  overlay.forcePlay();
});

$('.image-content .form-close').click(function (event) {
  event.preventDefault();
  $('.upload-form').addClass('force-hide');
  $('.name-form').addClass('force-hide');
  $('.share-container').removeClass('force-hide');
  hideStatusPanel();
  overlay.forcePlay();
});


// share button functionality

$('.facebook').click(function (event) {
  event.preventDefault();
  share("facebook")
});

$('.twitter').click(function (event) {
  event.preventDefault();
  share('twitter');
});

$('.pintrest').click(function (event) {
  event.preventDefault();
  share('pintrest')
});

$('.tumblr').click(function (event) {
  event.preventDefault();
  share('tumblr');
});

$('.google').click(function (event) {
  event.preventDefault();
  share('google');
});

$('.share-open').click(function (event) {
  console.log('share open click');
  event.preventDefault();
  $('.share-overlay-content').removeClass('force-hide');
  overlay.forcePause();
});

$('.share-overlay-close').click(function (event) {
  event.preventDefault();
  $('.share-overlay-content').addClass('force-hide');
  overlay.forcePlay();
});



// end share button functionality


$(".upload-form form").submit(function (event) {
    //disable the default form submission
    var fileName = $( "input:file" ).val();
    var fileSize = -1;
    
    if (window.FileReader)
    {
        var file = $('input:file')[0].files[0];
        fileSize = file.size;
    }

    console.log('fileName: '+fileName+' fileSize:'+fileSize);
    console.log('attached file ' + $('input:file')[0].files[0]);

    var maxFileSize = 8 * (1024 * 1000);
    var validFileSize = true;

    if(fileSize >= maxFileSize)
    {
      console.log(fileSize+' > '+maxFileSize);
      validFileSize = false;
    }
    //return;

    if(fileName.length > 0 && validFileSize)
    {
      // show processing status panel
      $('.form-header .process').removeClass('force-hide');
      $('.status-reason').text('Be patient while we upload your video.');
      $('.status').removeClass('force-hide');

      // //grab all form data  
      // var formData = new FormData();
      //   //jQuery.each($('input:file')[0].files, function(i, file) {
      //       formData.append('file', $('input:file')[0].files[0]);
      //   //});

      // console.log('formData '+formData);
      
      // $.ajax({
      //     url: 'upload/',
      //     type: 'POST',
      //     data: formData,
      //     cache: false,
      //     contentType: false,
      //     processData: false,
      //     success: function(data){
      //         console.log(data);
      //     }
      // });
    }
    else
    {
      event.preventDefault();
      $('.form-header .fail').removeClass('force-hide');
      if(!validFileSize)
      {
        $('.status-reason').text('The video you selected is too large. Try uploading a file that is less than 8Mb.');
      }
      else
      {
        $('.status-reason').text('You have to select a video file or record one by clicking the chose file button.');
      }

      $('.status').removeClass('force-hide');
      $('.status-back').removeClass('force-hide');
      //console.log("empty file name");
      return;
    }
});
  
  $(".name-form form").submit(function (event) {
      //disable the default form submission
      
      var fileName = $('input[name=name]').val();
      //var fileName = $( "input:name" ).val();
      console.log('attempting to name the file ' + fileName);

      if(fileName.length > 0)
      {
        // show processing status panel
        $('.form-header .process').removeClass('force-hide');
        $('.status-reason').text('Be patient while we process your video.');
        $('.status').removeClass('force-hide');

        //grab all form data  
        // var formData = new FormData();
        //   //jQuery.each($('input:file')[0].files, function(i, file) {
        //       formData.append('file', $('input:file')[0].files[0]);
        //   //});

        // //console.log('formData '+formData);
        
        // $.ajax({
        //     url: 'http://localhost:8888/getonup/build/flash/deploy/api/index.php/entries/upload/',
        //     type: 'POST',
        //     data: formData,
        //     cache: false,
        //     contentType: false,
        //     processData: false,
        //     success: function(data){
        //         console.log(data);
        //     }
        // });
      }
      else
      {
        event.preventDefault();
        $('.form-header .fail').removeClass('force-hide');
        $('.status-reason').text('You have to name your video.');
        $('.status').removeClass('force-hide');
        $('.status-back').removeClass('force-hide');
        //console.log("empty file name");
        return;
      }
  });

});
