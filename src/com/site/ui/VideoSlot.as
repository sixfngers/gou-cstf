/**
 * Created by ifreelance3 on 5/5/14.
 */
package com.site.ui
{
import com.adobe.utils.StringUtil;
import com.davidcaneso.display.drawing.SquareArea;
    import com.davidcaneso.events.loading.PreloaderEvent;
    import com.davidcaneso.events.video.VideoPlaybackEvent;
    import com.davidcaneso.framework.SimpleLink;
import com.davidcaneso.framework.SiteManager;
import com.davidcaneso.loading.Preloader;
    import com.davidcaneso.singletons.StageReference;
    import com.davidcaneso.singletons.Styling;
    import com.davidcaneso.singletons.XMLData;
    import com.davidcaneso.text.DynamicTextField;
    import com.davidcaneso.utils.LiveTrace;
import com.davidcaneso.utils.StringUtils;
import com.davidcaneso.utils.StringUtils;
import com.davidcaneso.video.VideoPlayer;
    import com.greensock.TweenMax;
    import com.greensock.easing.Quad;
    import com.site.AppUserDataModel;
import com.site.app.AppConsts;
import com.site.app.AppConsts;
    import com.site.app.AppStepEvent;

import flash.display.Loader;

import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.media.SoundTransform;
import flash.net.URLVariables;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.Security;

public class VideoSlot extends Sprite
    {
        private var _masking:SquareArea;
        private var _content:Sprite;

        private var _imageLoader:Preloader;
        private var _imageHolder:Sprite;
        private var _nameButton:SquareAppTextButton;

        private var _httpPlayer:VideoPlayer;
        private var _rtmpPlayer:VideoPlayer;

        private var _bg:SquareArea;
        private var _slotPosition:int;
        private var _FPOStep:DynamicTextField;
        private var _FPOData:DynamicTextField;

        private var _userDataModel:AppUserDataModel;
        private var _isJamesBrownVideo:Boolean = false;
        private var _active:Boolean = false;

        private var  _shareUi:MovieClip;

        private var _facebook:MovieClip;
        private var _twitter:MovieClip;
        private var _pintrest:MovieClip;
        private var _tumblr:MovieClip;
        private var _google:MovieClip;
        private var _initVideo:MovieClip;
        private var _skipVideoUntilRtmpConnection:Boolean = false;

        public function VideoSlot()
        {
            Security.allowDomain('https://bannerassets.universalstudios.com/');

            _masking = new SquareArea(AppConsts.MAX_VIDEO_WIDTH, AppConsts.MAX_VIDEO_HEIGHT, 0);
            _content = new Sprite();
            _content.mask = _masking;

            _imageHolder = new Sprite();
            _nameButton = new SquareAppTextButton('', Styling.instance.findFormat('userVideoName'), 'red', false);

            _imageLoader = new Preloader();
            _imageLoader.loaderContext = new LoaderContext(true);
            _imageLoader.addEventListener(PreloaderEvent.START, _handlePreloaderEvent);
            _imageLoader.addEventListener(PreloaderEvent.UPDATE, _handlePreloaderEvent);
            _imageLoader.addEventListener(PreloaderEvent.COMPLETE, _handlePreloaderEvent);
            _imageLoader.addEventListener(PreloaderEvent.ERROR, _handlePreloaderEvent);
            _imageLoader.addEventListener(PreloaderEvent.FILE_CHANGE, _handlePreloaderEvent);

            _bg = new SquareArea(AppConsts.MAX_VIDEO_WIDTH, AppConsts.MAX_VIDEO_HEIGHT, 0x000000, false);


            _httpPlayer = new VideoPlayer(AppConsts.MAX_VIDEO_WIDTH, AppConsts.MAX_VIDEO_HEIGHT, 0);
            //_httpPlayer.showTraces()
            _httpPlayer.visible = false;
            _httpPlayer.addEventListener(VideoPlaybackEvent.METADATA_RECEIVED, _handleHttpVideoPlaybackEvent);
            _httpPlayer.videoDisplay.bg.visible = false;

            _rtmpPlayer = new VideoPlayer(AppConsts.MAX_VIDEO_WIDTH, AppConsts.MAX_VIDEO_HEIGHT, 0, AppConsts.RTMP);
            //_rtmpPlayer.showTraces();
            _rtmpPlayer.visible = false;
            _rtmpPlayer.addEventListener(VideoPlaybackEvent.METADATA_RECEIVED, _handleRtmpVideoPlaybackEvent);
            _rtmpPlayer.videoDisplay.bg.visible = false;


            _shareUi = new videoShareOverlayUi();
            _shareUi.tabChildren = false;
            _shareUi.alpha = 0;
            _shareUi.visible = false;

            _shareUi.addEventListener(MouseEvent.ROLL_OVER, _handleShareInteract);
            _shareUi.addEventListener(MouseEvent.ROLL_OUT, _handleShareInteract);

            _facebook = _shareUi.facebook;
            _twitter = _shareUi.twitter;
            _pintrest = _shareUi.pintrest;
            _tumblr = _shareUi.tumblr;
            _google = _shareUi.google;


            var shareButtons:Array = [_facebook, _twitter, _pintrest, _tumblr, _google];

            for each(var button:MovieClip in shareButtons)
            {
                button.buttonMode = true;
                button.mouseChildren = false;
                button.addEventListener(MouseEvent.ROLL_OVER, _handleShareButtonInteract);
                button.addEventListener(MouseEvent.ROLL_OUT, _handleShareButtonInteract);
                button.addEventListener(MouseEvent.CLICK, _handleShareButtonInteract);
            }

            _content.addChild(_bg);
            _content.addChild(_imageHolder);
            _content.addChild(_httpPlayer);
            _content.addChild(_rtmpPlayer);
            _content.addChild(_shareUi);


            addChild(_content);
            addChild(_masking);

            _FPOStep= new DynamicTextField(AppConsts.MAX_VIDEO_WIDTH, 20);
            //_content.addChild(_FPOStep);
            _FPOData = new DynamicTextField(AppConsts.MAX_VIDEO_WIDTH, 0);
            TweenMax.to(_FPOData, 0, {tint:0xffffff});
            _FPOData.y = 20;
            //_content.addChild(_FPOData);

        }

        private function _handleShareInteract(e:MouseEvent):void
        {


            switch(e.type)
            {
                case MouseEvent.ROLL_OVER:
                    _showShareUi();
                    //TweenMax.to(_shareUi, .3, {alpha:1, ease:Quad.easeOut} );
                    break;

                case MouseEvent.ROLL_OUT:
                     if(StageReference.instance.stage.getChildAt(0) is SiteManager)
                     {
                         trace('currentState '+SiteManager(StageReference.instance.stage.getChildAt(0)).siteState);
                         if(SiteManager(StageReference.instance.stage.getChildAt(0)).siteState != SiteManager.SLEEP_STATE)
                         {
                             _hideShareUi();
                         }
                     }



                    //TweenMax.to(_shareUi, .3, {alpha:0, ease:Quad.easeOut} );
                    break;

            }

        }

        private function _showShareUi():void
        {
            TweenMax.to(_shareUi, .3, {alpha:1, ease:Quad.easeOut} );
            if(_userDataModel.userOrigin == AppConsts.WEBCAM_ORIGIN)
            {
                _rtmpPlayer.pauseVideo(true);
            }
            else
            {
                _httpPlayer.pauseVideo(true);
            }
        }

        private function _hideShareUi():void
        {
            TweenMax.to(_shareUi, .3, {alpha:0, ease:Quad.easeOut} );
            if(_userDataModel.userOrigin == AppConsts.WEBCAM_ORIGIN)
            {
                _rtmpPlayer.pauseVideo(false);
            }
            else
            {
                _httpPlayer.pauseVideo(false);
            }
        }

        private function _handleShareButtonInteract(e:MouseEvent):void
        {
            var mc:MovieClip = e.target as MovieClip;
            switch(e.type)
            {
                case MouseEvent.ROLL_OVER:
                    TweenMax.to(mc, .3, {tint:Styling.instance.findColor('black'), ease:Quad.easeOut} );
                    break;

                case MouseEvent.ROLL_OUT:
                    TweenMax.to(mc, .3, {removeTint:true, ease:Quad.easeOut} );
                    break;

                case MouseEvent.CLICK:
                    var urlstr:String;
                    var apibaseurl:String = XMLData.instance.config.@apibaseurl;
                    var deeplinkUrl:String = apibaseurl + AppConsts.DL_PARAM + _userDataModel.id;
                    var usersGifUrl:String = apibaseurl + AppConsts.gifPath + _userDataModel.userShareGifPath;
                    var usersShareGifUrl:String = apibaseurl + AppConsts.gifPath + _userDataModel.userShareGifPath;

                    if(_userDataModel.basePath.length > 0)
                    {
                        usersGifUrl = _userDataModel.basePath + AppConsts.GIF_DIR + _userDataModel.userShareGifPath;
                        usersShareGifUrl = _userDataModel.basePath + AppConsts.GIF_DIR + _userDataModel.userShareGifPath;
                    }

                    LiveTrace.output('share id '+_userDataModel.id);
                    switch(mc)
                    {
                        case _facebook:
                            LiveTrace.output('facebook');
                            SimpleLink.linkOut('https://www.facebook.com/sharer.php?u='+deeplinkUrl);
                            break;

                        case _twitter:
                            LiveTrace.output('twitter');
                            var twitterShareUrl:String = 'https://twitter.com/intent/tweet?text=';
                            var prefix:String = XMLData.instance.config.socialtext.twitter.prefix;
                            var suffix:String = XMLData.instance.config.socialtext.twitter.suffix;
                            urlstr = twitterShareUrl + StringUtils.escapeHashesAndSlashes(prefix + deeplinkUrl + suffix);
                            //SimpleLink.linkOut(twtiterShareUrl+"Can%27t Stop the Funk! I just danced with James Brown at " + deeplinkUrl + "! Join the celebration.");
                            SimpleLink.linkOut(urlstr);
                            break;

                        case _pintrest:
                            LiveTrace.output('pintrest');
                            var pinShareUrl:String = 'http://www.pinterest.com/pin/create/button/?';
                            var pinimageParam:String = 'media=';
                            var pinUrlParam:String = '&url=';
                            var pinDescriptionParam:String = '&description=';

                            //var pinDescription:String = "I just added my video to CAN'T STOP THE FUNK!, dancing along with the one and only James Brown! Join in the celebration!";
                            var pinDescription:String = XMLData.instance.config.socialtext.pintrest;
                            urlstr = pinShareUrl + pinimageParam + StringUtils.escapeHashesAndSlashes(escape(usersShareGifUrl)) + pinUrlParam + StringUtils.escapeHashesAndSlashes(escape(deeplinkUrl)) + pinDescriptionParam + StringUtils.escapeHashesAndSlashes(escape(pinDescription));

//                            http://www.pinterest.com/pin/create/button/?
//                            media=http%3A%2F%2Fhandheldpress.net%2Fapi%2Fuploads%2Ffinal%2Fgif%2F3ed0f6937e2f3ac012328a2214e56c02mov.gif
//                            &url=dev.bpginteractive.com%2Funiversal%2Fgetonup%3Fid%3D99
//                            &description=test%20-%20description

                            SimpleLink.linkOut(urlstr);
                            break;

                        case _tumblr:
                            var tumblrShareUrl:String = "http://www.tumblr.com/share/photo?";
                            var sourceParam:String = 'source=';
                            var captionParam:String = '&caption=';
                            var linkParam:String = '&click_thru=';

                            //var caption:String = "I just added my video to CAN'T STOP THE FUNK!, dancing along with the one and only James Brown! Join in the celebration!";
                            var caption:String = XMLData.instance.config.socialtext.tumblr;
                            urlstr = tumblrShareUrl + sourceParam + StringUtils.escapeHashesAndSlashes(escape(usersShareGifUrl)) + captionParam + StringUtils.escapeHashesAndSlashes(escape(caption)) + linkParam + StringUtils.escapeHashesAndSlashes(escape(deeplinkUrl));
                            trace(urlstr);

                            //var encodedVal:String = encodeURI(usersGifUrl + '&caption='+"Can\'t Stop the Funk! I just added my video to CAN’T STOP THE FUNK!, dancing along with the one and only James Brown " + deeplinkUrl + "! Visit to join the celebration!")
                            LiveTrace.output('tumblr');
                            SimpleLink.linkOut(urlstr);
                            break;

                        case _google:
                            LiveTrace.output('google');
                            var googleShareUrl:String = "https://plus.google.com/share?";
                            var googleLinkParam:String = 'url=';

                            urlstr = googleShareUrl + googleLinkParam + StringUtils.escapeHashesAndSlashes(escape(deeplinkUrl));
                            trace(urlstr);
                            SimpleLink.linkOut(urlstr);
                            break;
                    }
                    break;
            }
        }


        private function _handlePreloaderEvent(e:PreloaderEvent):void
        {
            switch(e.type)
            {
                case PreloaderEvent.START:
                    break;

                case PreloaderEvent.UPDATE:
                    break;

                case PreloaderEvent.COMPLETE:
                    _scaleAndPositionImage();
                    break;

                case PreloaderEvent.ERROR:
                    break;

                case PreloaderEvent.FILE_CHANGE:
                    break;
            }
        }

        private function _scaleAndPositionImage():void
        {
            var maxW:int = _masking.width;
            var maxH:int = _masking.height;

            var contentW:int = _imageHolder.width;
            var contentH:int = _imageHolder.height;

//            var scale:Number = ((maxH/maxW) > (contentH/contentW)) ? (maxH/contentW) : (maxH/contentH);
//            _imageHolder.scaleX = scale;
//            _imageHolder.scaleY = scale;

            var scaleRatio:Number;

            if((contentH / contentW) < 1)
            {
                // use the vertical scale ratio because that will be the smaller dimension
                scaleRatio = (maxH / contentH);
                _imageHolder.height = maxH;
                _imageHolder.width = contentW * scaleRatio;

                if(_imageHolder.width < maxW)
                {
                    _imageHolder.width = maxW;
                    _imageHolder.scaleY = _imageHolder.scaleX;
                }
            }
            else if((contentH / contentW) > 1)
            {
                scaleRatio = (maxW / contentW);
                _imageHolder.width = maxW;
                _imageHolder.height = contentH * scaleRatio;

                if(_imageHolder.height < maxH)
                {
                    _imageHolder.height = maxH;
                    _imageHolder.scaleX = _imageHolder.scaleY;
                }
            }
            else
            {
                //image is square
                _imageHolder.width = maxW;
                _imageHolder.scaleY = _imageHolder.scaleX;
            }


            _imageHolder.x = _masking.x + int(((maxW - _imageHolder.width) * .5));
            _imageHolder.y = _masking.y + int(((maxH - _imageHolder.height) * .5));
        }

        private function _handleHttpVideoPlaybackEvent(e:VideoPlaybackEvent):void
        {
            switch(e.type)
            {
                case VideoPlaybackEvent.PLAYER_TIME_CHANGE:
                    var currentTime:int = Math.floor(_httpPlayer.ns.time);
//                    trace(_httpPlayer.percentagePlayed+' of '+_httpPlayer.videoDuration);
//                    trace('current time '+currentTime);
//                    trace('playerState '+_httpPlayer.playerState);


                    if(_httpPlayer.videoDuration >= AppConsts.MAX_VIDEO_DURATION && currentTime > AppConsts.VIDEO_CUTOFF_TIME)
                    {

                        _httpPlayer.pauseVideo(true);
                        _httpPlayer.closeStream();

                        _changeVideo();
                    }

                    break;

                case VideoPlaybackEvent.METADATA_RECEIVED:
                    _centerVideo(_httpPlayer, e.metaData.width, e.metaData.height);
//                    _httpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_STATE_CHANGE, _handleHttpVideoPlaybackEvent);
//                    _httpPlayer.addEventListener(VideoPlaybackEvent.INVALID_FORMAT, _handleHttpVideoPlaybackEvent);
//                    _httpPlayer.addEventListener(VideoPlaybackEvent.FILE_NOT_FOUND, _handleHttpVideoPlaybackEvent);
//                    _httpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_TIME_CHANGE, _handleHttpVideoPlaybackEvent);
                    break;

                case VideoPlaybackEvent.PLAYER_STATE_CHANGE:
                    var curState:String = e.playerState;

                    //	possible player states are:
                    //	VIDEO_UNSTARTED_STATE			:	player is idle has been setup but no video has been played
                    //	VIDEO_START_STATE				:	player has started a video
                    //	VIDEO_STOP_STATE				:	player has stopped playing a video
                    //	VIDEO_PLAY_STATE				:	player is currently playing a video
                    //	VIDEO_PAUSE_STATE				:	player has paused a video
                    //	VIDEO_COMPLETE_STATE			:	player has completed playing a video
                    //	VIDEO_SCRUB_STATE				:	player is scrubbing through a video
                    //	VIDEO_BUFFERING_START_STATE		:	player has started buffering a video
                    //	VIDEO_BUFFERING_STOP_STATE		:	player has stopped buffering a video
                    switch(curState){
                        case VideoPlayer.VIDEO_UNSTARTED_STATE:
                            break;

                        case VideoPlayer.VIDEO_COMPLETE_STATE:
                            _changeVideo();
                            break;

                        case VideoPlayer.VIDEO_PLAY_STATE:
                            break;

                        case VideoPlayer.VIDEO_PAUSE_STATE:
                            break;

                        case VideoPlayer.VIDEO_BUFFERING_START_STATE:
                            //trace('show buffer');
                            break;

                        case VideoPlayer.VIDEO_BUFFERING_STOP_STATE:
//                            trace('hide buffer');
                            break;
                    }
                    break;


            }


        }

        private function _handleInitialVideoComplete(e:Event):void
        {
            StageReference.instance.stage.dispatchEvent(new AppStepEvent(AppStepEvent.INITIAL_VIDEO_COMPLETE));
            StageReference.instance.stage.dispatchEvent(new AppStepEvent(AppStepEvent.SHOW_SEARCH));
            if(_initVideo)
            {
                _content.removeChild(_initVideo);
                _initVideo = null;
            }
            //_changeVideo();
        }

        private function _changeVideo():void
        {
            if(_initVideo)
            {
                _initVideo.stop();
            }

            _skipVideoUntilRtmpConnection = false;
            deactivate();
            //_active = false;
            _rtmpPlayer.removeEventListener(VideoPlaybackEvent.PLAYER_STATE_CHANGE, _handleRtmpVideoPlaybackEvent);
            _rtmpPlayer.removeEventListener(VideoPlaybackEvent.INVALID_FORMAT, _handleRtmpVideoPlaybackEvent);
            _rtmpPlayer.removeEventListener(VideoPlaybackEvent.FILE_NOT_FOUND, _handleRtmpVideoPlaybackEvent);
            _rtmpPlayer.removeEventListener(VideoPlaybackEvent.PLAYER_TIME_CHANGE, _handleRtmpVideoPlaybackEvent);
            _rtmpPlayer.pauseVideo(true);

            _httpPlayer.removeEventListener(VideoPlaybackEvent.PLAYER_STATE_CHANGE, _handleHttpVideoPlaybackEvent);
            _httpPlayer.removeEventListener(VideoPlaybackEvent.INVALID_FORMAT, _handleHttpVideoPlaybackEvent);
            _httpPlayer.removeEventListener(VideoPlaybackEvent.FILE_NOT_FOUND, _handleHttpVideoPlaybackEvent);
            _httpPlayer.removeEventListener(VideoPlaybackEvent.PLAYER_TIME_CHANGE, _handleHttpVideoPlaybackEvent);
            _httpPlayer.pauseVideo(true);

            dispatchEvent(new Event(Event.CHANGE));
        }

        private function _centerVideo(player:VideoPlayer, videoWidth:int, videoHeight:int):void
        {
            var maxW:int = _masking.width;
            var maxH:int = _masking.height;

            var contentW:int = videoWidth;
            var contentH:int = videoHeight;

            var scaleRatio:Number;

            if((contentH / contentW) < 1)
            {
                // use the vertical scale ratio because that will be the smaller dimension
                scaleRatio = (maxH / contentH);
                player.height = maxH;
                player.width = contentW * scaleRatio;

                if(player.width < maxW)
                {
                    player.width = maxW;
                    player.scaleY = player.scaleX;
                }
            }
            else if((contentH / contentW) > 1)
            {
                scaleRatio = (maxW / contentW);
                player.width = maxW;
                player.height = contentH * scaleRatio;

                if(player.height < maxH)
                {
                    player.height = maxH;
                    player.scaleX = player.scaleY;
                }
            }
            else
            {
                //image is square
                player.width = maxW;
                player.scaleY = player.scaleX;
            }


            player.x = _masking.x + int(((maxW - player.width) * .5));
            player.y = _masking.y + int(((maxH - player.height) * .5));
            dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.METADATA_RECEIVED, '', 0));
        }


        private function _handleRtmpVideoPlaybackEvent(e:VideoPlaybackEvent):void
        {
            switch(e.type)
            {
                case VideoPlaybackEvent.PLAYER_TIME_CHANGE:
                    var currentTime:int = Math.floor(_rtmpPlayer.ns.time);
                    trace(_rtmpPlayer.percentagePlayed+' of '+_rtmpPlayer.videoDuration);
                    trace('current time '+currentTime);
                    trace('playerState '+_rtmpPlayer.playerState);


                    if(_rtmpPlayer.videoDuration >= AppConsts.MAX_VIDEO_DURATION && currentTime > AppConsts.VIDEO_CUTOFF_TIME)
                    {
                        if(!_rtmpPlayer.isPaused)
                            _rtmpPlayer.pauseVideo(true);
                        //_rtmpPlayer.closeStream();

                        _changeVideo();
                    }

                    break;

                case VideoPlaybackEvent.METADATA_RECEIVED:
                    //_rtmpPlayer.pauseVideo(true);
                    trace('_rtmpPlayer.playerState '+_rtmpPlayer.playerState);
                    _centerVideo(_rtmpPlayer, e.metaData.width, e.metaData.height);

//                    if(         _rtmpPlayer.playerState == VideoPlayer.VIDEO_UNSTARTED_STATE
//                            || _rtmpPlayer.playerState == VideoPlayer.VIDEO_PAUSE_STATE
//                            || _rtmpPlayer.playerState == VideoPlayer.VIDEO_BUFFERING_STOP_STATE
//                    ){
                    //_rtmpPlayer.pauseVideo(false);
//                    }

//                    _rtmpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_STATE_CHANGE, _handleRtmpVideoPlaybackEvent);
//                    _rtmpPlayer.addEventListener(VideoPlaybackEvent.INVALID_FORMAT, _handleRtmpVideoPlaybackEvent);
//                    _rtmpPlayer.addEventListener(VideoPlaybackEvent.FILE_NOT_FOUND, _handleRtmpVideoPlaybackEvent);
//                    _rtmpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_TIME_CHANGE, _handleRtmpVideoPlaybackEvent);
                    break;

                case VideoPlaybackEvent.PLAYER_STATE_CHANGE:
                    var curState:String = e.playerState;

                    //	possible player states are:
                    //	VIDEO_UNSTARTED_STATE			:	player is idle has been setup but no video has been played
                    //	VIDEO_START_STATE				:	player has started a video
                    //	VIDEO_STOP_STATE				:	player has stopped playing a video
                    //	VIDEO_PLAY_STATE				:	player is currently playing a video
                    //	VIDEO_PAUSE_STATE				:	player has paused a video
                    //	VIDEO_COMPLETE_STATE			:	player has completed playing a video
                    //	VIDEO_SCRUB_STATE				:	player is scrubbing through a video
                    //	VIDEO_BUFFERING_START_STATE		:	player has started buffering a video
                    //	VIDEO_BUFFERING_STOP_STATE		:	player has stopped buffering a video
                    switch(curState){
                        case VideoPlayer.VIDEO_UNSTARTED_STATE:
                            break;

                        case VideoPlayer.VIDEO_COMPLETE_STATE:
                            //_changeVideo();
                            break;

                        case VideoPlayer.VIDEO_PLAY_STATE:
                            break;

                        case VideoPlayer.VIDEO_PAUSE_STATE:
                            break;

                        case VideoPlayer.VIDEO_BUFFERING_START_STATE:
//                            trace('show buffer');
                            break;

                        case VideoPlayer.VIDEO_BUFFERING_STOP_STATE:
                            trace('hide buffer');
                                trace(_rtmpPlayer.ns.time  +' ' + _rtmpPlayer.videoDuration)
                            if(_rtmpPlayer.ns.time >= _rtmpPlayer.videoDuration)
                            {
                                _changeVideo();
                            }
//                            _rtmpPlayer.pauseVideo();
                            break;

                        case VideoPlayer.VIDEO_STOP_STATE:
                            _changeVideo();
                            break;
                    }
                    break;
            }
        }

        public function setupSlot(dataModel:AppUserDataModel, isJamesBrownVideo:Boolean = false, isInitialSlot:Boolean = false):void
        {

//            if(_userDataModel)
//                _userDataModel.reset();

            _imageHolder.visible = true;

            _httpPlayer.visible = false;
            _httpPlayer.videoDisplay.clearDisplay();
            _httpPlayer.closeStream();


            _rtmpPlayer.visible = false;
            _rtmpPlayer.videoDisplay.clearDisplay();

            _isJamesBrownVideo = isJamesBrownVideo;

            while(_imageHolder.numChildren > 0)
            {
                _imageHolder.removeChildAt(0);
            }

            _userDataModel = dataModel;

            //_FPOData.text = _userDataModel.toString();

            LiveTrace.output('image path '+ _userDataModel.userImagePath);
            LiveTrace.output('video path '+ _userDataModel.userVideoPath);

            var fullImagePath:String = XMLData.instance.config.@apibaseurl + AppConsts.imagePath + _userDataModel.userImagePath;
            if(_userDataModel.basePath.length > 0)
            {
                fullImagePath = _userDataModel.basePath + AppConsts.IMAGE_DIR + _userDataModel.userImagePath;
            }

            if(_userDataModel.userImagePath != null && _userDataModel.userImagePath.length > 0)
            {
                _imageLoader.addToLoadStack(fullImagePath, _imageHolder);
                _imageLoader.startLoad();
            }


            LiveTrace.output('image path '+ fullImagePath);

            if(isInitialSlot)
            {
                _active = true;
                _initVideo = new initialJbVideo();
                _initVideo.addEventListener('initialVideoComplete', _handleInitialVideoComplete);
                _content.addChild(_initVideo);
                _content.addChild(_imageHolder);
                _content.addChild(_httpPlayer);
                _content.addChild(_rtmpPlayer);
                _content.addChild(_shareUi);

                _initVideo.soundTransform = new SoundTransform(0, 0);
                _initVideo.gotoAndPlay(2);
            }
            else
            {
                if(_userDataModel.userOrigin == AppConsts.WEBCAM_ORIGIN)
                {
                    if(!_rtmpPlayer.nc.connected)
                    {
                        LiveTrace.output('rtmp player not connected');
                        _skipVideoUntilRtmpConnection = true;
                    }
                    else
                    {
                        _rtmpPlayer.alpha = 1;
                        _rtmpPlayer.visible = true;
                        _rtmpPlayer.startVideo(dataModel.userVideoPath);
                        _rtmpPlayer.pauseVideo(true);
                    }

                }
                else
                {
                    var videoUrl:String = XMLData.instance.config.@apibaseurl + AppConsts.finalVideoPath + dataModel.userVideoPath;

                    if(dataModel.basePath.length > 0)
                    {
                        videoUrl = dataModel.basePath + AppConsts.VIDEO_DIR + dataModel.userVideoPath;
                    }

                    _httpPlayer.visible = true;
                    _httpPlayer.startVideo(videoUrl);
                    _httpPlayer.pauseVideo(true);
                }
            }
        }

        public function startVideo():void
        {
            _shareUi.visible = true;
            _active = true;
            //_imageHolder.visible = false;
            //_imageHolder.alpha = .5;

            if(_userDataModel.userOrigin == AppConsts.WEBCAM_ORIGIN)
            {
                if(_skipVideoUntilRtmpConnection)
                {
                    LiveTrace.output('video skipped because rtmp was not connected');
                    _changeVideo();
                    return;
                }
                _rtmpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_STATE_CHANGE, _handleRtmpVideoPlaybackEvent);
                _rtmpPlayer.addEventListener(VideoPlaybackEvent.INVALID_FORMAT, _handleRtmpVideoPlaybackEvent);
                _rtmpPlayer.addEventListener(VideoPlaybackEvent.FILE_NOT_FOUND, _handleRtmpVideoPlaybackEvent);
                _rtmpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_TIME_CHANGE, _handleRtmpVideoPlaybackEvent);

                _rtmpPlayer.changeVolume(0);
                _rtmpPlayer.visible = true;
                _rtmpPlayer.alpha = 1;
                _rtmpPlayer.pauseVideo(false);
            }
            else
            {
                _httpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_STATE_CHANGE, _handleHttpVideoPlaybackEvent);
                _httpPlayer.addEventListener(VideoPlaybackEvent.INVALID_FORMAT, _handleHttpVideoPlaybackEvent);
                _httpPlayer.addEventListener(VideoPlaybackEvent.FILE_NOT_FOUND, _handleHttpVideoPlaybackEvent);
                _httpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_TIME_CHANGE, _handleHttpVideoPlaybackEvent);

                _httpPlayer.changeVolume(0);
                _httpPlayer.visible = true;
                _httpPlayer.pauseVideo(false);
            }
        }

        public function pauseVideo():void
        {
            if(_initVideo)
            {
                _initVideo.removeEventListener('initialVideoComplete', _handleInitialVideoComplete);
                _initVideo.stop();
            }

            if(_userDataModel.userOrigin == AppConsts.WEBCAM_ORIGIN)
            {
                _rtmpPlayer.pauseVideo(true);
            }
            else
            {
                _httpPlayer.pauseVideo(true);
            }
        }

        public function unpauseVideo():void
        {
            if(_initVideo)
            {
                _initVideo.play();
            }

            if(_userDataModel.userOrigin == AppConsts.WEBCAM_ORIGIN)
            {
                _rtmpPlayer.pauseVideo(false);
            }
            else
            {
                _httpPlayer.pauseVideo(false);
            }
        }

        public function set slotPosition(value:int):void
        {
            _slotPosition = value;
            _FPOStep.text = 'sp '+value;
        }

        public function get slotPosition():int
        {
            return _slotPosition;
        }

        public function get userDataModel():AppUserDataModel
        {
            return _userDataModel;
        }

        public function get isJamesBrownVideo():Boolean
        {
            return _isJamesBrownVideo;
        }

        public function get rtmpPlayer():VideoPlayer
        {
            return _rtmpPlayer;
        }

        public function get httpPlayer():VideoPlayer
        {
            return _httpPlayer;
        }

        public function get active():Boolean
        {
            return _active;
        }

        public function deactivate():void
        {
            _shareUi.visible = false;

            if(_initVideo)
            {
                _content.removeChild(_initVideo);
                _initVideo.stop();
                _initVideo = null;
                StageReference.instance.stage.dispatchEvent(new AppStepEvent(AppStepEvent.SHOW_SEARCH));
            }


            if(_active)
            {
                if(_userDataModel)
                {
                    if(_userDataModel.userOrigin == AppConsts.WEBCAM_ORIGIN)
                    {
                        if(!_rtmpPlayer.isPaused)
                            _rtmpPlayer.pauseVideo(true);
                    }
                    else
                    {
                        if(!_httpPlayer.isPaused)
                            _httpPlayer.pauseVideo(true);
                    }
                }
            }

            _active = false;
        }

    }
}
