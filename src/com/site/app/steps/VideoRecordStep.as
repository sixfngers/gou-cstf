package com.site.app.steps
{
    //	imports
import com.davidcaneso.camera.CameraSelector;
import com.davidcaneso.display.drawing.SquareArea;
import com.davidcaneso.events.camera.CameraEvent;
import com.davidcaneso.events.framework.SiteManagerEvent;
    import com.davidcaneso.singletons.StageReference;
import com.davidcaneso.singletons.Styling;
import com.davidcaneso.utils.LiveTrace;
    import com.davidcaneso.video.VideoDisplay;
    import com.greensock.TweenMax;
    import com.greensock.easing.Quad;
    import com.greensock.plugins.MotionBlurPlugin;
    import com.greensock.plugins.TweenPlugin;
    import com.site.AppUser;
import com.site.app.AppConsts;
import com.site.app.AppConsts;
    import com.site.app.AppNotificationEvent;
    import com.site.app.AppStep;
    import com.site.app.VideoFileUploaderEvent;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.NetStatusEvent;
    import flash.events.ProgressEvent;
    import flash.events.TimerEvent;
    import flash.media.Camera;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.net.Responder;
    import flash.net.URLStream;
    import flash.system.Security;
    import flash.utils.ByteArray;
    import flash.utils.Timer;

    TweenPlugin.activate([MotionBlurPlugin]);

    public class VideoRecordStep extends AppStep
    {

        //	properties
        private var _content:MovieClip;
        private var clientID:String;
        private var video_stream:URLStream;
        private var video_byteArray:ByteArray;

        private var _nc:NetConnection;
        private var _ns:NetStream;
        private var _cam:Camera;
        private var _res:Responder;

        private var t:Timer;

        private var _vidDisplay:VideoDisplay;
        //private var _fileUploader:VideoFileUploader;

        private var _recordToggleButton:MovieClip;
        private var _isRecording:Boolean = false;
        private var _recordStartTimer:Timer;
        private var _durationBar:SquareArea;
        private var _countdownGraphics:MovieClip;
        private var _camSelector:CameraSelector;

        //	constructor
        public function VideoRecordStep(devMode:Boolean = false):void
        {
            Security.allowDomain(AppConsts.RTMP);
            Security.allowInsecureDomain(AppConsts.RTMP);

            _content = new webcamRecordStageContent() as MovieClip;
            addChild(_content);

            super(devMode);

            _vidDisplay = new VideoDisplay(400, 300, 0x000000);
            _vidDisplay.x = 420;
            _vidDisplay.y = 30;

            _vidDisplay.video.smoothing = true;
            _content.addChild(_vidDisplay);

            _countdownGraphics = webcamRecordStageContent(_content).countdownGraphics;
            _countdownGraphics.alpha = 0;
            _countdownGraphics.visible = false;
            _countdownGraphics.x = _vidDisplay.x;
            _countdownGraphics.y = _vidDisplay.y;
            _content.addChild(_countdownGraphics);


            _durationBar = new SquareArea(_vidDisplay.width, 9, Styling.instance.findColor('yellow'), false);
            _durationBar.x = _vidDisplay.x;
            _durationBar.y = _vidDisplay.y + _vidDisplay.height;
            _content.addChild(_durationBar);

            t = new Timer(100);
            t.addEventListener(TimerEvent.TIMER, timerHandler);

            _nc = new NetConnection();
            _nc.client=this;
            _nc.addEventListener(NetStatusEvent.NET_STATUS,netConnectionHandler);

            _camSelector = new CameraSelector(AppConsts.MAX_VIDEO_WIDTH, AppConsts.MAX_VIDEO_HEIGHT);
            _camSelector.addEventListener(CameraEvent.ALLOW, _handleCameraEvent);
            _camSelector.addEventListener(CameraEvent.DENY, _handleCameraEvent);
            _camSelector.addEventListener(CameraEvent.UNAVAILABLE, _handleCameraEvent);

            //_camSelector.x = 420;

            _res = new Responder(connectedHandler,errorHandler);

//            _cam = Camera.getCamera();
//            if(_cam)
//            {
//                _cam.setMode( AppConsts.MAX_VIDEO_WIDTH, AppConsts.MAX_VIDEO_HEIGHT, 30 );
//                _cam.setQuality(0, 80);
//            }


            _recordStartTimer = new Timer(1000, 5);
            _recordStartTimer.addEventListener(TimerEvent.TIMER, _handleRecordStartTimerEvent);
            _recordStartTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _handleRecordStartTimerEvent);

            _recordToggleButton = webcamRecordStageContent(_content).toggleRecording;
            _recordToggleButton.visible = false;
            _recordToggleButton.x = _vidDisplay.x + ((400 - _recordToggleButton.width) * .5);
            _recordToggleButton.y = _vidDisplay.y + 300 - _recordToggleButton.height - 15;
            _recordToggleButton.buttonMode = true;
            _recordToggleButton.mouseChildren = false;
            _recordToggleButton.addEventListener(MouseEvent.ROLL_OVER, _handleRecordToggleInteract);
            _recordToggleButton.addEventListener(MouseEvent.ROLL_OUT, _handleRecordToggleInteract);
            _recordToggleButton.addEventListener(MouseEvent.CLICK, _handleRecordToggleInteract);
            //_recordToggleButton.tf.text = 'START';
            _content.addChild(_recordToggleButton);

            _content.record_btn.visible = false;
//            _content.record_btn.addEventListener( MouseEvent.CLICK, onRecord );
            _content.play_btn.visible = false;
//            _content.play_btn.addEventListener( MouseEvent.CLICK, onPlayback );
            _content.submit_btn.visible = false;
//            _content.submit_btn.addEventListener( MouseEvent.CLICK, onSubmit );

//            _fileUploader = new VideoFileUploader(apiBaseUrl + AppConsts.uploadScriptUrl, devMode, 'e5c93c51325de1f19d7bbd8177b763f2.flv');
//            _fileUploader.showTraces = true;
//            _fileUploader.addEventListener(VideoFileUploaderEvent.START, _handleFileUploaderEvent);
//            _fileUploader.addEventListener(VideoFileUploaderEvent.BROWSE_CANCEL, _handleFileUploaderEvent);
//            _fileUploader.addEventListener(VideoFileUploaderEvent.COMPLETE, _handleFileUploaderEvent);
//            _fileUploader.addEventListener(VideoFileUploaderEvent.ERROR, _handleFileUploaderEvent);
//            _fileUploader.addEventListener(VideoFileUploaderEvent.UPDATE, _handleFileUploaderEvent);

            _content.stepHeader.visible = false;

            _content.prevStep.x = _vidDisplay.x;
            _content.prevStep.buttonMode = true;
            _content.prevStep.mouseChildren = false;
            _content.prevStep.addEventListener(MouseEvent.ROLL_OVER, _handlePrevNextInteract);
            _content.prevStep.addEventListener(MouseEvent.ROLL_OUT, _handlePrevNextInteract);
            _content.prevStep.addEventListener(MouseEvent.CLICK, _handlePrevNextInteract);

            _content.nextStep.x = _vidDisplay.x + _vidDisplay.width - _content.nextStep.width;
            _content.nextStep.visible = false;
            _content.nextStep.buttonMode = true;
            _content.nextStep.mouseChildren = false;
            _content.nextStep.addEventListener(MouseEvent.ROLL_OVER, _handlePrevNextInteract);
            _content.nextStep.addEventListener(MouseEvent.ROLL_OUT, _handlePrevNextInteract);
            _content.nextStep.addEventListener(MouseEvent.CLICK, _handlePrevNextInteract);
        }

        private function _handleCameraEvent(e:CameraEvent):void
        {
            switch(e.type)
            {
                case CameraEvent.ALLOW:
                    LiveTrace.output('camera allow')
                    connect();
                    StageReference.instance.stage.dispatchEvent(new AppNotificationEvent(AppNotificationEvent.HIDE_NOTIFICATION));
                    break;

                case CameraEvent.DENY:
                    LiveTrace.output('camera deny');
                    TweenMax.killTweensOf(_recordToggleButton);
                    _recordToggleButton.visible = false;
                    showWebCamUnavailableNotification();
                    break;

                case CameraEvent.UNAVAILABLE:
                    LiveTrace.output('camera unavaliable');
                    break;
            }
        }


        private function _handleRecordStartTimerEvent(e:TimerEvent):void
        {
            if(e.type == TimerEvent.TIMER_COMPLETE)
            {
                _countdownGraphics.numbers.gotoAndStop(1);
                TweenMax.to(_countdownGraphics,0, {autoAlpha:0, ease:Quad.easeOut});

                LiveTrace.output('countdown completed');
                record();

                TweenMax.to(_durationBar, AppConsts.VIDEO_CUTOFF_TIME + 1, {scaleX:1, onComplete:_recordingStopped});
            }
            else
            {
                //LiveTrace.output('countdown tick '+_recordStartTimer.repeatCount);
                _countdownGraphics.numbers.nextFrame();
            }
        }

        private function _handleRecordToggleInteract(e:MouseEvent):void
        {
            switch(e.type)
            {
                case MouseEvent.ROLL_OVER:
                    TweenMax.to(_recordToggleButton.tf,.2, {tint:0x000000, ease:Quad.easeOut});
                    break;

                case MouseEvent.ROLL_OUT:
                    TweenMax.to(_recordToggleButton.tf,.2, {removeTint:true, ease:Quad.easeOut});
                    break;

                case MouseEvent.CLICK:
                    if(!_isRecording)
                    {
                        _isRecording = true;
                        // show a timer to count down
                        _recordStartTimer.reset();
                        _recordStartTimer.start();
                        _countdownGraphics.numbers.gotoAndStop(2);
                        TweenMax.to(_countdownGraphics,.3, {autoAlpha:1, ease:Quad.easeOut});


                        // call record when the timer is done
                        //record();


                        // show a timer that tells the user how long they have to record
                        // max recording time is AppConsts.MAX_VIDEO_DURATION
                        _recordingInitiated();
                    }
                    else
                    {
                        _recordingStopped();
                    }
                    break;

            }
        }

        private function _recordingInitiated():void
        {
            _recordToggleButton.visible = false;
            _content.nextStep.visible = false;
            //_recordToggleButton.tf.text = 'DONE';
        }

        private function _recordingStopped():void
        {
            LiveTrace.output('recording completed');
            _isRecording = false;
            stop();
            _content.nextStep.visible = true;
            //_recordToggleButton.visible = true;
            //_recordToggleButton.tf.text = 'RECORD';
        }

        private function _handlePrevNextInteract(e:MouseEvent):void
        {
            var mc:MovieClip = _content.nextStep;
            if(e.target == _content.prevStep)
                mc = _content.prevStep;

            switch(e.type)
            {
                case MouseEvent.ROLL_OVER:
                    TweenMax.to(mc.arrow,.2, {tint:0x000000, ease:Quad.easeOut});
                    break;

                case MouseEvent.ROLL_OUT:
                    TweenMax.to(mc.arrow,.2, {removeTint:true, ease:Quad.easeOut});
                    break;

                case MouseEvent.CLICK:
                    if(mc == _content.nextStep)
                    {
                        uploadScreenGrab();
                        //_handleNextStepClick(null);
                    }
                    else
                    {
                        _handlePrevStepClick(null);
                    }

                    break;

            }
        }

        override public function animateIn():void
        {
            _content.nextStep.visible = false;
            _isRecording = false;

            TweenMax.to(_recordToggleButton, 0, {autoAlpha:0, ease:Quad.easeOut});
            _durationBar.scaleX = 0;

            this.alpha = 1;
            this.visible = true;

            StageReference.instance.stage.addEventListener(SiteManagerEvent.SITE_STATE_UPDATE, handleSiteStateUpdate);

            _animateInComplete();
        }

        override protected function _animateInComplete():void
        {

            _camSelector.startCamera();
            if(_camSelector.camera)
            {
                connect();
            }
            else
            {
                LiveTrace.output('_animateInComplete camera is null show unavailable');
                showWebCamUnavailableNotification();
            }


//            if(!_nc.connected)


//            if (_cam!=null) {
//                connect();
//            } else {
//                LiveTrace.output("You need a camera.");
//            }
        }


        override protected function _animateOut():void
        {
            _content.nextStep.visible = false;
            TweenMax.killTweensOf(_durationBar);
            _isRecording = false;

            stop(true);
            _camSelector.stopCamera();

            _vidDisplay.video.attachCamera(null);
            _vidDisplay.video.clear();

            this.alpha = 0;
            this.visible = false;

            StageReference.instance.stage.removeEventListener(SiteManagerEvent.SITE_STATE_UPDATE, handleSiteStateUpdate);

            _animateOutComplete();
        }

        override protected function _animateOutComplete():void
        {
            super._animateOutComplete();
        }

        //private function

        private function _handleFileUploaderEvent(e:VideoFileUploaderEvent):void
        {
            switch (e.type)
            {
                case VideoFileUploaderEvent.START:
                    break;

                case VideoFileUploaderEvent.BROWSE_CANCEL:
                    break;

                case VideoFileUploaderEvent.COMPLETE:
                    LiveTrace.output('userVideoPath: ' + AppUser.userVideoPath);
                    //_handleNextStepClick(null);
                    break;

                case VideoFileUploaderEvent.ERROR:
                    break;

                case VideoFileUploaderEvent.UPDATE:
                    break;

            }
        }


        protected function connect():void
        {
            if(!_nc.connected)
            {
                _nc.connect(AppConsts.RTMP);
            }
            else
            {
                trace('already connected show record button')
                TweenMax.killTweensOf(_recordToggleButton);
                TweenMax.to(_recordToggleButton,.2, {autoAlpha:1, ease:Quad.easeOut});
            }

            attachCamera();
        }
        protected function createStream():void
        {
            _ns=new NetStream(_nc);
            _ns.client=this;
            _ns.addEventListener(NetStatusEvent.NET_STATUS,netStreamHandler);
            TweenMax.killTweensOf(_recordToggleButton);
            TweenMax.to(_recordToggleButton,.2, {autoAlpha:1, ease:Quad.easeOut});
        }
        protected function attachCamera():void
        {

//          if(!_cam) return;
//
//          _vidDisplay.video.attachCamera(_cam);

            //_recordToggleButton.visible = true;
            //vid.attachCamera(_cam);


//            if (_ns!=null)
//            {
//                _ns.attachCamera(_cam);
//            }

            _vidDisplay.video.attachCamera(_camSelector.camera);

            if (_ns!=null)
            {
                _ns.attachCamera(_camSelector.camera);
            }
        }
//        protected function attachVideo():void
//        {
//            _vidDisplay.video.attachNetStream(_ns);
//            //vid.attachNetStream(_ns);
//        }
        protected function record():void
        {
            attachCamera();
            _ns.publish(clientID, "record");
            _content.record_btn.label="Stop";
        }
//        protected function playback():void
//        {
//            attachVideo();
//            _ns.play(clientID, 0, -1);
//            //_ns.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
//
////            video_stream = new URLStream();
////            video_stream.addEventListener(ProgressEvent.PROGRESS, videoStream_progressHandler);
////
////            video_byteArray = new ByteArray();
////            video_stream.load(new URLRequest(AppConsts.RTMP+clientID));
//
//            _content.play_btn.label="Stop";
//        }
        protected function stop(full:Boolean = false):void
        {
            TweenMax.killTweensOf(_durationBar);
            _recordStartTimer.stop();

            // close this on finish recording
            if(_ns)
                _ns.close();

            // full only happens when we change steps
            if(full)
            {
                if(_nc)
                    _nc.close();
            }

            _content.record_btn.label="Record";
            _content.play_btn.label="Play";
        }

        protected function uploadScreenGrab():void
        {
            stop();
            _nc.call("submit", null, true);

            var appNotificationEvent:AppNotificationEvent = new AppNotificationEvent(AppNotificationEvent.SHOW_NOTIFICATION);
                appNotificationEvent.notificationType = AppNotificationEvent.WEBCAM_SUBMIT_START;
            StageReference.instance.stage.dispatchEvent(appNotificationEvent);
        }

        public function submitted(p_b:Boolean):void
        {
            LiveTrace.output("submitted "+p_b);

            var appNotificationEvent:AppNotificationEvent = new AppNotificationEvent(AppNotificationEvent.SHOW_NOTIFICATION, true);

            if (p_b==true)
            {
                appNotificationEvent.notificationType = AppNotificationEvent.WEBCAM_SUBMIT_SUCCESS;
                StageReference.instance.stage.addEventListener(AppNotificationEvent.NOTIFICATION_RESPONSE, _handleTrueResponseToMoveToTheNextStep);
                //_handleNextStepClick(null);
            }
            else if (p_b == false)
            {
                appNotificationEvent.notificationType = AppNotificationEvent.WEBCAM_SUBMIT_FAIL;
                StageReference.instance.stage.addEventListener(AppNotificationEvent.NOTIFICATION_RESPONSE, _handleTrueResponseFromFail);
            }

            StageReference.instance.stage.dispatchEvent(appNotificationEvent);

            //_fileUploader.uploadVideoRecording(video_byteArray, clientID);
        }

        private function _handleTrueResponseFromFail(e:AppNotificationEvent):void
        {
            StageReference.instance.stage.removeEventListener(AppNotificationEvent.NOTIFICATION_RESPONSE, _handleTrueResponseFromFail);
            _handlePrevStepClick(null);
        }

        private function _handleTrueResponseToMoveToTheNextStep(e:AppNotificationEvent):void
        {
            AppUser.dataModel.userOrigin = AppConsts.WEBCAM_ORIGIN;
            AppUser.dataModel.userVideoPath = clientID;
            StageReference.instance.stage.removeEventListener(AppNotificationEvent.NOTIFICATION_RESPONSE, _handleTrueResponseToMoveToTheNextStep);
            _handleNextStepClick(null);
        }

        //Event Handlers
        protected function netConnectionHandler(evt:NetStatusEvent):void {
            LiveTrace.output("netConnectionHandler "+evt.info.code);
            switch (evt.info.code) {
                case "NetConnection.Connect.Success" :
                    _nc.call("connected", _res);
                    createStream();
                    break;

                case "NetConnection.Call.Failed":
                    for (var i:String in evt.info)
                    {
                        trace('failure '+i + ": " + evt.info[i]);
                    }

                    showWebCamUnavailableNotification();
                    break;


                default :
                    LiveTrace.output("Not Connected");
            }
        }

        private function showWebCamUnavailableNotification():void
        {
            var notify:AppNotificationEvent = new AppNotificationEvent(AppNotificationEvent.SHOW_NOTIFICATION);
            notify.notificationType = AppNotificationEvent.WEBCAM_UNAVAILALBE;
            StageReference.instance.stage.dispatchEvent(notify);
            //_handlePrevStepClick(null);
        }

        public function onTimeCoordInfo(obj:Object):void
        {
            for (var i:String in obj)
            {
                trace('TimeCoordInfo '+i + ": " + obj[i]);
            }
        }
        protected function netStreamHandler(evt:NetStatusEvent):void {
            LiveTrace.output("netStreamHandler "+evt.info.code);
        }
        public function onMetaData(p_o:Object):void {
            LiveTrace.output('onMetaData '+p_o.code);
        }
        public function onPlayStatus(p_o:Object):void {
            LiveTrace.output('onPlayStatus '+p_o.code);
            if (p_o.code=="NetStream.Play.Complete") {
                stop();
            }
        }

        public function connectedHandler(p_o:String):void {
            LiveTrace.output("connected* "+p_o);
            clientID=p_o;
            //TweenMax.to(_recordToggleButton, .5, {autoAlpha:1, ease:Quad.easeOut});
        }
        public function errorHandler(p_o:Object):void
        {
            LiveTrace.output("errorHandler* "+p_o);

            showWebCamUnavailableNotification();
        }
        protected function onRecord(evt:MouseEvent):void {
            LiveTrace.output("onRecord");
            if (evt.target.label=="Record") {
                record();
            } else {
                stop();
                evt.target.label="Record";
            }
        }
//        protected function onPlayback(evt:MouseEvent):void {
//            LiveTrace.output("onPlayback");
//            if (evt.target.label=="Play") {
//                playback();
//            } else {
//                stop();
//                evt.target.label="Play";
//            }
//        }
        protected function onSubmit(evt:MouseEvent):void {
            LiveTrace.output("onSubmit");
            if (evt.target.label=="Submit") {
                uploadScreenGrab();
            } else {
                //prompt????
            }
        }

        protected function timerHandler(event:TimerEvent):void
        {
            //LiveTrace.output("quality: " + _cam.quality + "\n");
        }








        private function videoStream_progressHandler(event:ProgressEvent):void
        {
            //video_stream.readBytes(video_byteArray);
        }


    }

}






