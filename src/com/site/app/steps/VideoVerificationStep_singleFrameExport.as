﻿package com.site.app.steps{    //	imports    import com.adobe.images.PNGEncoder;import com.adobe.serialization.json.JSON;import com.davidcaneso.display.drawing.SquareArea;    import com.davidcaneso.events.framework.SiteManagerEvent;import com.davidcaneso.events.loading.ServerLoaderEvent;import com.davidcaneso.events.video.VideoPlaybackEvent;    import com.davidcaneso.singletons.StageReference;    import com.davidcaneso.utils.LiveTrace;    import com.davidcaneso.video.VideoPlayer;    import com.greensock.TweenMax;    import com.greensock.easing.Quad;    import com.greensock.plugins.MotionBlurPlugin;    import com.greensock.plugins.TweenPlugin;    import com.site.AppUser;    import com.site.app.AppConsts;import com.site.app.AppNotificationEvent;import com.site.app.AppNotificationEvent;    import com.site.app.AppStep;    import com.site.app.ui.AppCheckBox;    import flash.display.Bitmap;    import flash.display.BitmapData;import flash.display.DisplayObject;import flash.display.MovieClip;    import flash.display.Sprite;    import flash.events.Event;    import flash.events.HTTPStatusEvent;    import flash.events.IOErrorEvent;    import flash.events.MouseEvent;    import flash.events.ProgressEvent;    import flash.events.SecurityErrorEvent;    import flash.events.TimerEvent;    import flash.net.URLLoaderDataFormat;    import flash.utils.ByteArray;    import flash.utils.Timer;    import ru.inspirit.net.MultipartURLLoader;    TweenPlugin.activate([MotionBlurPlugin]);    public class VideoVerificationStep_singleFrameExport extends AppStep    {        private const VERTICAL:int = -1;        private const SQUARE:int = 0;        private const HORIZONTAL:int = 1;        //	properties        private var _content:MovieClip;        private var _player:VideoPlayer;        private var _playerMasking:SquareArea;        private var _rtmpPlayer:VideoPlayer;        private var _rtmpPlayerMasking:SquareArea;        private var _verificationBox:AppCheckBox;        private var _httpPlayerContainer:Sprite;        private var _rtmpPlayerContainer:Sprite;        private var _exportFrame:int = 0;        private var _totalFrames:int = 1;        private var _exportTimer:Timer;        private var _fileLoader:MultipartURLLoader;        private var _bufferVisual:MovieClip;        //	constructor        public function VideoVerificationStep_singleFrameExport(devMode:Boolean = false):void        {            _content = new videoVerificationStageContent() as MovieClip;            _content.stepHeader.tf.text = "";            addChild(_content);            _exportTimer = new Timer( 1000 );            _exportTimer.addEventListener(TimerEvent.TIMER, _exportRtmpVideoFrame);            _fileLoader = new MultipartURLLoader();            //_fileLoader.dataFormat = URLLoaderDataFormat.VARIABLES;            _fileLoader.addEventListener(Event.COMPLETE, _onUploadImageSequenceComplete);            _fileLoader.addEventListener(ProgressEvent.PROGRESS, _handleFileLoaderEvent);            _fileLoader.addEventListener(IOErrorEvent.IO_ERROR, _handleFileLoaderEvent);            _fileLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, _handleFileLoaderEvent);            _fileLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleFileLoaderEvent);            _httpPlayerContainer = new Sprite();            _rtmpPlayerContainer = new Sprite();            super(devMode);            _player = new VideoPlayer(255, 191, 0);            _player.showTraces();            _playerMasking = new SquareArea(_player.videoDisplay.maxWidth, _player.videoDisplay.maxHeight, 0);            _playerMasking.x = int(318 + ((590 - _playerMasking.width) * .5));            _playerMasking.y = int(0 + ((380 - _playerMasking.height) * .5));            _playerMasking.alpha = .3;            _player.mask = _playerMasking;            _player.addEventListener(VideoPlaybackEvent.METADATA_RECEIVED, _handleVideoPlayerMetaData);            _player.addEventListener(VideoPlaybackEvent.PLAYER_STATE_CHANGE, _handlePlayerStateChange);            _player.addEventListener(VideoPlaybackEvent.PLAYER_TIME_CHANGE, _handlePlayerTimeChange);            _player.addEventListener(VideoPlaybackEvent.INVALID_FORMAT, _handleInvalidFormat);            _player.addEventListener(VideoPlaybackEvent.FILE_NOT_FOUND, _handleFileNotFound);            _httpPlayerContainer.addChild(_player);            _httpPlayerContainer.addChild(_playerMasking);            addChild(_httpPlayerContainer);            _rtmpPlayer = new VideoPlayer(AppConsts.MAX_VIDEO_WIDTH, AppConsts.MAX_VIDEO_HEIGHT, 0, AppConsts.RTMP);            _rtmpPlayer.showTraces();            _rtmpPlayerMasking = new SquareArea(_rtmpPlayer.videoDisplay.maxWidth, _rtmpPlayer.videoDisplay.maxHeight, 0xff0000);            _rtmpPlayerMasking.alpha = .3//            _rtmpPlayerMasking.x = int(318 + ((590 - _rtmpPlayerMasking.width) * .5));//            _rtmpPlayerMasking.y = int(0 + ((380 - _rtmpPlayerMasking.height) * .5));            _rtmpPlayerMasking.alpha = .3;            _rtmpPlayer.mask = _rtmpPlayerMasking;            _rtmpPlayer.addEventListener(VideoPlaybackEvent.METADATA_RECEIVED, _handleRtmpVideoPlaybackEvent);            _rtmpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_STATE_CHANGE, _handleRtmpVideoPlaybackEvent);            _rtmpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_TIME_CHANGE, _handleRtmpVideoPlaybackEvent);            _rtmpPlayer.addEventListener(VideoPlaybackEvent.INVALID_FORMAT, _handleInvalidFormat);            _rtmpPlayer.addEventListener(VideoPlaybackEvent.FILE_NOT_FOUND, _handleFileNotFound);            _rtmpPlayerContainer.x = int(318 + ((590 - _playerMasking.width) * .5));            _rtmpPlayerContainer.y = int(0 + ((380 - _playerMasking.height) * .5));            _rtmpPlayerContainer.scaleX =            _rtmpPlayerContainer.scaleY = .4;            _rtmpPlayerContainer.addChild(_rtmpPlayer);            _rtmpPlayerContainer.addChild(_rtmpPlayerMasking);            _content.addChild(_rtmpPlayerContainer);            _bufferVisual = videoVerificationStageContent(_content).bufferVisual;            _hideBuffer(0);            _content.addChild(_bufferVisual);            _verificationBox = new AppCheckBox(false, true);            _verificationBox.x = _playerMasking.x;            _verificationBox.y = _playerMasking.y + _playerMasking.height + 10;            _content.addChild(_verificationBox);            _content.prevStep.buttonMode = true;            _content.prevStep.mouseChildren = false;            _content.prevStep.addEventListener(MouseEvent.ROLL_OVER, _handlePrevNextInteract);            _content.prevStep.addEventListener(MouseEvent.ROLL_OUT, _handlePrevNextInteract);            _content.prevStep.addEventListener(MouseEvent.CLICK, _handlePrevNextInteract);            _content.nextStep.buttonMode = true;            _content.nextStep.mouseChildren = false;            _content.nextStep.addEventListener(MouseEvent.ROLL_OVER, _handlePrevNextInteract);            _content.nextStep.addEventListener(MouseEvent.ROLL_OUT, _handlePrevNextInteract);            _content.nextStep.addEventListener(MouseEvent.CLICK, _handlePrevNextInteract);            _content.addChild(_content.nextStep);            _content.addChild(_content.prevStep);        }        private function _handleFileLoaderEvent(e:*):void        {            LiveTrace.output('_handleFileLoaderEvent '+e.toString);            switch (e.type)            {                case IOErrorEvent.IO_ERROR:                case SecurityErrorEvent.SECURITY_ERROR:                        var notify:AppNotificationEvent = new AppNotificationEvent(AppNotificationEvent.SHOW_NOTIFICATION);                        notify.notificationType = AppNotificationEvent.WEBCAM_UNAVAILALBE;                        StageReference.instance.stage.dispatchEvent(notify);                        _handlePrevStepClick(null);                        break;            }        }        private function _onUploadImageSequenceComplete(e:Event):void        {//            _rtmpPlayerContainer.visible = true;////            _rtmpPlayerContainer.scaleX =//            _rtmpPlayerContainer.scaleY = 1;            var fileLoaderData:String = _fileLoader.loader.data;            LiveTrace.output('fileLoaderData '+_fileLoader);            var jsonObj:Object = com.adobe.serialization.json.JSON.decode(fileLoaderData);            var status:String = com.adobe.serialization.json.JSON.decode(fileLoaderData).status;            LiveTrace.output("status returned as " + status);            StageReference.instance.stage.dispatchEvent(new AppNotificationEvent(AppNotificationEvent.HIDE_NOTIFICATION));            super._handleNextStepClick(null);        }        private function _handlePrevNextInteract(e:MouseEvent):void        {            var mc:MovieClip = _content.nextStep;            if(e.target == _content.prevStep)                mc = _content.prevStep;            switch(e.type)            {                case MouseEvent.ROLL_OVER:                    TweenMax.to(mc.arrow,.2, {tint:0x000000, ease:Quad.easeOut});                    break;                case MouseEvent.ROLL_OUT:                    TweenMax.to(mc.arrow,.2, {removeTint:true, ease:Quad.easeOut});                    break;                case MouseEvent.CLICK:                    if(mc == _content.nextStep)                        _handleNextStepClick(null);                    else                        _handlePrevStepClick(null);                    break;            }        }        override protected function _handlePrevStepClick(e:Event):void        {            super._handlePrevStepClick(null);        }        override protected function _handleNextStepClick(e:Event):void        {            var notify:AppNotificationEvent = new AppNotificationEvent(AppNotificationEvent.SHOW_NOTIFICATION);            if(_verificationBox.isOn)            {                if(AppUser.dataModel.userOrigin == AppConsts.WEBCAM_ORIGIN)                {                    // create image sequence zip for gif                    //  var totalDuration:int = _rtmpPlayer.videoDuration;                    notify.notificationType = AppNotificationEvent.WEBCAM_SUBMIT_START;                    StageReference.instance.stage.dispatchEvent(notify);                    _exportFrame = 0;                    _rtmpPlayerContainer.visible = false;                    _rtmpPlayerContainer.scaleX =                    _rtmpPlayerContainer.scaleY = 1;                    _exportTimer.reset();                    _exportTimer.start();                }                else                {                    super._handleNextStepClick(null);                }            }            else            {                notify.notificationType = AppNotificationEvent.VIDEO_UNVERIFIED;                StageReference.instance.stage.dispatchEvent(notify);            }        }        private function _handleVideoPlayerMetaData(e:VideoPlaybackEvent):void        {            var contentW:int = e.metaData.width;            var contentH:int = e.metaData.height;            sizeVideo( _player, contentW, contentH );        }        private function _handlePlayerTimeChange(e:VideoPlaybackEvent):void        {            LiveTrace.output('percent played '+ e.percentPlayed);            if(e.percentPlayed > 3)            {                _makeNextStepUIAvailable();            }            //_pausePlayButton.updateProgress(e.percentPlayed);        }        private function _handleInvalidFormat(e:VideoPlaybackEvent):void        {            LiveTrace.output('the video file you uploaded is not formatted correctly and cannot be played');            var notify:AppNotificationEvent = new AppNotificationEvent(AppNotificationEvent.SHOW_NOTIFICATION);                notify.notificationType = AppNotificationEvent.VIDEO_INVALID_FORMAT;            StageReference.instance.stage.dispatchEvent(notify);            _verificationBox.reset();            _verificationBox.visible = false;        }        private function _handleFileNotFound(e:VideoPlaybackEvent):void        {            LiveTrace.output('the video file '+ _player.videoFile+' you tried to play cannot be found');            var notify:AppNotificationEvent = new AppNotificationEvent(AppNotificationEvent.SHOW_NOTIFICATION);                notify.notificationType = AppNotificationEvent.VIDEO_NOT_FOUND;            StageReference.instance.stage.dispatchEvent(notify);            _verificationBox.reset();            _verificationBox.visible = false;        }        private function _handlePlayerStateChange(e:VideoPlaybackEvent):void        {            var curState:String = e.playerState;            LiveTrace.output('player state changed to '+ curState);            //	possible player states are:            //	VIDEO_UNSTARTED_STATE			:	player is idle has been setup but no video has been played            //	VIDEO_START_STATE				:	player has started a video            //	VIDEO_STOP_STATE				:	player has stopped playing a video            //	VIDEO_PLAY_STATE				:	player is currently playing a video            //	VIDEO_PAUSE_STATE				:	player has paused a video            //	VIDEO_COMPLETE_STATE			:	player has completed playing a video            //	VIDEO_SCRUB_STATE				:	player is scrubbing through a video            //	VIDEO_BUFFERING_START_STATE		:	player has started buffering a video            //	VIDEO_BUFFERING_STOP_STATE		:	player has stopped buffering a video            switch(curState){                case VideoPlayer.VIDEO_COMPLETE_STATE:                    //showReplayButton()                    //_animateOutPlayer();                    LiveTrace.output(VideoPlayer.VIDEO_COMPLETE_STATE);                    _hideBuffer();                    break;                case VideoPlayer.VIDEO_PLAY_STATE:                    //_pausePlayButton.updateIcon(_player.isPaused);                    LiveTrace.output(VideoPlayer.VIDEO_PLAY_STATE);                    break;                case VideoPlayer.VIDEO_PAUSE_STATE:                    //_pausePlayButton.updateIcon(_player.isPaused);                    break;                case VideoPlayer.VIDEO_BUFFERING_START_STATE:                    LiveTrace.output(VideoPlayer.VIDEO_BUFFERING_START_STATE);                    _showBuffer(_player);                    break;                case VideoPlayer.VIDEO_BUFFERING_STOP_STATE:                    LiveTrace.output(VideoPlayer.VIDEO_BUFFERING_STOP_STATE);                    _hideBuffer();                    break;            }        }        private function _showBuffer(videoPlayer:VideoPlayer, t:Number = .3):void        {            var mc:MovieClip = _bufferVisual;            mc.gotoAndPlay(1);            var playerMasking:SquareArea = _playerMasking;            if(videoPlayer == _rtmpPlayer)                playerMasking = _rtmpPlayerMasking;            mc.x = 590;//int(318 + ((590 - _playerMasking.width) * .5)  + _playerMasking.width * .5 );            mc.y = 168;//int(0 + ((380 - _playerMasking.height) * .5) + _playerMasking.height * .5 );            TweenMax.to(mc,t, {autoAlpha:1, ease:Quad.easeOut})        }        private function _hideBuffer(t:Number = .3):void        {            var mc:MovieClip = _bufferVisual;            mc.stop();            TweenMax.to(mc,t, {autoAlpha:0, ease:Quad.easeOut})        }        private function playVideo(path:String):void        {//            var baseUrl:String = '../../';////            if(super.devMode)//                baseUrl = '../../';            _httpPlayerContainer.visible = false;            _rtmpPlayerContainer.visible = false;            if(AppUser.dataModel.userOrigin == AppConsts.WEBCAM_ORIGIN)            {                _rtmpPlayerContainer.visible = true;                _rtmpPlayer.startVideo(path);            }            else            {                var videoPath:String = AppConsts.tempVideoPath;                trace('play video ' + videoPath + path);                LiveTrace.output('play video ' + videoPath + path);                _httpPlayerContainer.visible = true;                _player.startVideo(super.apiBaseUrl + videoPath + path);            }        }        private function _handleRtmpVideoPlaybackEvent(e:VideoPlaybackEvent):void        {            switch(e.type)            {                case VideoPlaybackEvent.PLAYER_TIME_CHANGE:                    break;                case VideoPlaybackEvent.METADATA_RECEIVED:                    LiveTrace.output(e.metaData.duration);                    LiveTrace.output('player dur '+_rtmpPlayer.videoDuration);                    var contentW:int = AppConsts.MAX_VIDEO_WIDTH;                    var contentH:int = AppConsts.MAX_VIDEO_HEIGHT;                    sizeVideo( _rtmpPlayer, contentW, contentH );                    break;                case VideoPlaybackEvent.PLAYER_STATE_CHANGE:                    var curState:String = e.playerState;                    //	possible player states are:                    //	VIDEO_UNSTARTED_STATE			:	player is idle has been setup but no video has been played                    //	VIDEO_START_STATE				:	player has started a video                    //	VIDEO_STOP_STATE				:	player has stopped playing a video                    //	VIDEO_PLAY_STATE				:	player is currently playing a video                    //	VIDEO_PAUSE_STATE				:	player has paused a video                    //	VIDEO_COMPLETE_STATE			:	player has completed playing a video                    //	VIDEO_SCRUB_STATE				:	player is scrubbing through a video                    //	VIDEO_BUFFERING_START_STATE		:	player has started buffering a video                    //	VIDEO_BUFFERING_STOP_STATE		:	player has stopped buffering a video                    switch(curState){                        case VideoPlayer.VIDEO_UNSTARTED_STATE:                            break;                        case VideoPlayer.VIDEO_COMPLETE_STATE:                                _hideBuffer();                            break;                        case VideoPlayer.VIDEO_PLAY_STATE:                            _makeNextStepUIAvailable();                            break;                        case VideoPlayer.VIDEO_PAUSE_STATE:                            break;                        case VideoPlayer.VIDEO_BUFFERING_START_STATE://                            trace('show buffer');                                _showBuffer(_rtmpPlayer);                            break;                        case VideoPlayer.VIDEO_BUFFERING_STOP_STATE://                            trace('hide buffer');                                _hideBuffer();                            break;                        case VideoPlayer.VIDEO_STOP_STATE:                                _hideBuffer();                            break;                    }                    break;            }        }        private function _makeNextStepUIAvailable():void        {            if(_verificationBox.visible == false)                _verificationBox.visible = true;            if(_content.nextStep.visible == false)                _content.nextStep.visible = true;        }        private function sizeVideo(player:VideoPlayer, videoWidth:int, videoHeight:int):void        {            //return;            var maxW:int = player.videoDisplay.maxWidth;            var maxH:int = player.videoDisplay.maxHeight;            var contentW:int = videoWidth;            var contentH:int = videoHeight;            player.videoDisplay.width = contentW;            player.videoDisplay.height = contentH;            var contentIsSmallerThanHolder:Boolean = false;            var contentIsLandscape:int = SQUARE;            if((contentH / contentW) < 1)            {                contentIsLandscape = HORIZONTAL;            }            else if((contentH / contentW) > 1)            {                contentIsLandscape = VERTICAL;            }            else            {                //image is square                contentIsLandscape = SQUARE;            }            trace('*************************** /n contentIsLandscape '+contentIsLandscape);            trace('*************************** /n contentIsSmallerThanHolder '+contentIsSmallerThanHolder);            var scaleRatio:Number;            if(contentIsLandscape == HORIZONTAL)            {                // use the vertical scale ratio because that will be the smaller dimension                scaleRatio = (maxH / contentH);                player.videoDisplay.height = maxH;                player.videoDisplay.width = contentW * scaleRatio;            }            else if(contentIsLandscape == VERTICAL)            {                scaleRatio = (maxW / contentW);                player.videoDisplay.width = maxW;                player.videoDisplay.height = contentH * scaleRatio;            }            else            {                // content is square fit to the smaller dimension in this case the height                player.videoDisplay.height = maxH;                player.videoDisplay.width = maxH;            }            trace('*************************** /n scaleRatio '+scaleRatio);//            _player.videoDisplay.x = int(((maxW - _player.videoDisplay.width) * .5));//            _player.videoDisplay.y = int(((maxH - _player.videoDisplay.height) * .5));            var playerMasking:SquareArea = _playerMasking;            if(player == _rtmpPlayer)                playerMasking = _rtmpPlayerMasking;            player.x = playerMasking.x + int(((playerMasking.width - player.videoDisplay.width) * .5));            player.y = playerMasking.y + int(((playerMasking.height - player.videoDisplay.height) * .5));        }        private function _exportRtmpVideoFrame(e:TimerEvent):void        {            LiveTrace.output('exportFrame '+_exportFrame);//            if(_exportFrame >= 100)//            {//                //StageReference.instance.stage.dispatchEvent(new AppNotificationEvent(AppNotificationEvent.HIDE_NOTIFICATION));////                _exportTimer.stop();////                AppUser.imageSequence.compressImagesIntoZip();////                var file:ByteArray = AppUser.imageSequence.zipFileByteArray;//                var scriptUrl:String = apiBaseUrl + AppConsts.uploadImageSequenceScriptUrl;////                LiveTrace.output('let the user know the zip upload has started');//                _fileLoader.clearFiles();//                _fileLoader.clearVariables();////                _fileLoader.addVariable('video_path', AppUser.dataModel.userVideoPath);//                _fileLoader.addFile(file, AppUser.userVideoPath, 'video');//                _fileLoader.load(scriptUrl);////                //super._handleNextStepClick(null);//                //super._handleNextStepClick(null);//                return;//            }            _exportTimer.stop();            _rtmpPlayer.pauseVideo(true);            _rtmpPlayer.scrub(0);            var width:int = AppConsts.MAX_VIDEO_WIDTH;            var height:int = AppConsts.MAX_VIDEO_HEIGHT;            var bmpData:BitmapData = new BitmapData(width, height, false, 0);            var bmp:Bitmap = new Bitmap(bmpData, 'auto', true);                bmpData.draw(_rtmpPlayer.videoDisplay);            var data:ByteArray = PNGEncoder.encode(bmpData);            //AppUser.imageSequence.addFileToSequence(data);            bmp.bitmapData.dispose();            //var file:ByteArray = data;            var scriptUrl:String = apiBaseUrl + AppConsts.uploadImageSequenceScriptUrl;            LiveTrace.output('let the user know the zip upload has started ');            _fileLoader.clearFiles();            _fileLoader.clearVariables();            _fileLoader.addVariable('video_path', AppUser.userVideoPath);            _fileLoader.addFile(data, AppUser.userVideoPath+'.png', 'video');            _fileLoader.load(scriptUrl);            //_exportFrame += int(100 / _totalFrames);        }        override public function animateIn():void        {            _verificationBox.reset();            _verificationBox.visible = false;            _content.nextStep.visible = false;            _rtmpPlayerContainer.scaleX =            _rtmpPlayerContainer.scaleY = .4;            this.alpha = 1;            this.visible = true;            _animateInComplete();            StageReference.instance.stage.addEventListener(SiteManagerEvent.SITE_STATE_UPDATE, handleSiteStateUpdate);        }        override protected function _animateInComplete():void        {            playVideo(AppUser.userVideoPath);            if(AppUser.userOrigin == AppConsts.WEBCAM_ORIGIN)            {                _rtmpPlayerContainer.visible = true;                _showBuffer(_rtmpPlayer, 0);            }            else            {                _showBuffer(_player, 0);            }        }        override protected function _animateOut():void        {//            _player.removeEventListener(VideoPlaybackEvent.METADATA_RECEIVED, _handleVideoPlayerMetaData);//            _player.removeEventListener(VideoPlaybackEvent.PLAYER_STATE_CHANGE, _handlePlayerStateChange);//            _player.removeEventListener(VideoPlaybackEvent.PLAYER_TIME_CHANGE, _handlePlayerTimeChange);//            _player.removeEventListener(VideoPlaybackEvent.INVALID_FORMAT, _handleInvalidFormat);//            _player.removeEventListener(VideoPlaybackEvent.FILE_NOT_FOUND, _handleFileNotFound);            super._animateOut();            _player.pauseVideo(true);            _player.closeStream();            _player.videoDisplay.clearDisplay();            _rtmpPlayer.pauseVideo(true);            _rtmpPlayer.closeStream(true);            _rtmpPlayer.videoDisplay.clearDisplay();            _rtmpPlayer.recconnect();            this.alpha = 0;            this.visible = true;            _animateOutComplete();        }        override protected function _animateOutComplete():void        {            super._animateOutComplete();        }    }}