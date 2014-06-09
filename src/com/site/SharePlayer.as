/**
 * Created by ifreelance3 on 5/14/14.
 */
package com.site
{
    import com.adobe.serialization.json.JSON;
    import com.davidcaneso.display.drawing.SquareArea;
    import com.davidcaneso.events.video.VideoPlaybackEvent;
    import com.davidcaneso.framework.SimpleLink;
    import com.davidcaneso.singletons.StageReference;
    import com.davidcaneso.utils.LiveTrace;
    import com.davidcaneso.video.VideoPlayer;
    import com.greensock.TweenMax;
    import com.greensock.easing.Quad;
    import com.site.app.AppConsts;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    [SWF(backgroundColor=0x000000, frameRate=30, width=470, height=345)]
    public class SharePlayer extends MovieClip
    {

        private var _linkUrl:String;
        private var _content:MovieClip;
        private var _videoPlayer:VideoPlayer;
        private var _userModel:AppUserDataModel;
        private var _but:SquareArea;


        public function SharePlayer()
        {
            _content = new sharePlayerStageContent();
            addChild(_content);

//            this.alpha = 0;
//            this.visible = false;
        }

        public function setup(data:String, timeline:String):void
        {
            _linkUrl = timeline;
            _parseLoadedData(data);

            var server:String = '';
            if(_userModel.userOrigin == AppConsts.WEBCAM_ORIGIN)
                server = AppConsts.RTMP;

            _videoPlayer = new VideoPlayer(AppConsts.MAX_VIDEO_WIDTH, AppConsts.MAX_VIDEO_HEIGHT, 0, server);
            _videoPlayer.addEventListener(VideoPlaybackEvent.METADATA_RECEIVED, _handleVideoPlaybackEvent);
            _videoPlayer.addEventListener(VideoPlaybackEvent.PLAYER_STATE_CHANGE, _handleVideoPlaybackEvent);
            _videoPlayer.showTraces();
            addChild(_videoPlayer);

            addChild(_content);

            _but = new SquareArea(100, 100, 0, false);
            _but.alpha = 0;
            _but.buttonMode = true;
            _but.tabEnabled = false;
            _but.mouseChildren = false;
            _but.addEventListener(MouseEvent.CLICK, _handleButInteract);
            addChild(_but);

            _animateIn();
        }

        private function _handleButInteract(e:MouseEvent):void
        {
            SimpleLink.linkOut(_linkUrl + AppConsts.DL_PARAM + _userModel.id);
        }

        private function _handleVideoPlaybackEvent(e:VideoPlaybackEvent):void
        {
            switch(e.type)
            {
                case VideoPlaybackEvent.PLAYER_TIME_CHANGE:
                    var currentTime:int = Math.floor(_videoPlayer.ns.time);
//                    trace(_httpPlayer.percentagePlayed+' of '+_httpPlayer.videoDuration);
//                    trace('current time '+currentTime);
//                    trace('playerState '+_httpPlayer.playerState);

                    if(_videoPlayer.videoDuration >= AppConsts.MAX_VIDEO_DURATION && currentTime > AppConsts.VIDEO_CUTOFF_TIME)
                    {
                        _restartVideo();
                    }
                    break;

                case VideoPlaybackEvent.METADATA_RECEIVED:
                    _centerVideo(_videoPlayer, e.metaData.width, e.metaData.height);
//                    _httpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_STATE_CHANGE, _handleHttpVideoPlaybackEvent);
//                    _httpPlayer.addEventListener(VideoPlaybackEvent.INVALID_FORMAT, _handleHttpVideoPlaybackEvent);
//                    _httpPlayer.addEventListener(VideoPlaybackEvent.FILE_NOT_FOUND, _handleHttpVideoPlaybackEvent);
//                    _httpPlayer.addEventListener(VideoPlaybackEvent.PLAYER_TIME_CHANGE, _handleHttpVideoPlaybackEvent);
                    break;

                case VideoPlaybackEvent.PLAYER_STATE_CHANGE:
                    var curState:String = e.playerState;

                    LiveTrace.output('new player state '+curState);
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
                            _restartVideo();
                            break;

                        case VideoPlayer.VIDEO_PLAY_STATE:
                            break;

                        case VideoPlayer.VIDEO_PAUSE_STATE:
                            break;

                        case VideoPlayer.VIDEO_BUFFERING_START_STATE:
                            LiveTrace.output('show buffer');
                            _startBuffer();
                            break;

                        case VideoPlayer.VIDEO_BUFFERING_STOP_STATE:
                              LiveTrace.output('hide buffer');
                            _stopBuffer();
                            break;
                    }
                    break;


            }
        }

        private function _startBuffer():void
        {
            var mc:MovieClip = sharePlayerStageContent(_content).bufferVisual;
            mc.gotoAndPlay(1);
            TweenMax.to(mc,.3, {autoAlpha:1, ease:Quad.easeOut})
        }

        private function _stopBuffer():void
        {
            var mc:MovieClip = sharePlayerStageContent(_content).bufferVisual;
            mc.stop();
            TweenMax.to(mc,.3, {autoAlpha:0, ease:Quad.easeOut})
        }

        private function _restartVideo():void
        {
            _videoPlayer.scrub(0);
        }

        private function _centerVideo(player:VideoPlayer, videoWidth:int, videoHeight:int):void
        {
            var maxW:int = StageReference.instance.stage.stageWidth;
            var maxH:int = StageReference.instance.stage.stageHeight;

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


            player.x = int(((maxW - player.width) * .5));
            player.y = int(((maxH - player.height) * .5));
        }

        private function _parseLoadedData(loadedData:String):void
        {
            var jsonData:Object = com.adobe.serialization.json.JSON.decode(loadedData);

            var entry:Object = jsonData.data;
            _userModel = new AppUserDataModel();
            _userModel.id            = entry.id;
            _userModel.userName      = entry.name;
            _userModel.basePath      = entry.base_path;
            _userModel.userImagePath = entry.image_path;
            _userModel.userGifPath   = entry.gif_path;
            _userModel.userVideoPath = entry.video_path;
            _userModel.userOrigin    = entry.origin;

        }


        private function _animateIn():void
        {
            _handleResize();
            TweenMax.to(this,.3, {autoAlpha:1, ease:Quad.easeOut, onComplete:_startVideo});
        }

        private function _startVideo():void
        {
            var videoPath:String = SharePlayerShell(StageReference.instance.stage.getChildAt(0)).mainUrl + AppConsts.finalVideoPath;
            if(_userModel.basePath.length > 0)
            {
                videoPath = _userModel.basePath + AppConsts.VIDEO_DIR;
            }

            if(_userModel.userOrigin == AppConsts.WEBCAM_ORIGIN)
            {
                _videoPlayer.startVideo(_userModel.userVideoPath);
            }
            else
            {
                _videoPlayer.startVideo(videoPath + _userModel.userVideoPath);
            }


        }

        private function _handleResize():void
        {
            var w:int = StageReference.instance.stage.stageWidth;
            var h:int = StageReference.instance.stage.stageHeight;

            _videoPlayer.width = w;
            _videoPlayer.scaleY = _videoPlayer.scaleX;

            sharePlayerStageContent(_content).lowerRight.x = w;
            sharePlayerStageContent(_content).lowerRight.y = h;

            _but.width = w;
            _but.height = h;

        }
    }
}
