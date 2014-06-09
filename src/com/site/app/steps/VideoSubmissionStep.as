package com.site.app.steps
{
    //	imports
    import com.adobe.crypto.MD5;
    import com.adobe.serialization.json.JSON;
    import com.davidcaneso.events.framework.SiteManagerEvent;
    import com.davidcaneso.events.loading.ServerLoaderEvent;
    import com.davidcaneso.loading.ServerLoader;
    import com.davidcaneso.singletons.StageReference;
    import com.davidcaneso.singletons.Styling;
    import com.davidcaneso.text.DynamicTextField;
    import com.davidcaneso.text.UserInputField;
    import com.davidcaneso.utils.LiveTrace;
    import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.MotionBlurPlugin;
    import com.greensock.plugins.TweenPlugin;
    import com.site.AppUser;
    import com.site.app.AppConsts;
    import com.site.app.AppNotificationEvent;
    import com.site.app.AppStep;
import com.site.app.AppStepEvent;
import com.site.ui.SquareAppTextButton;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.external.ExternalInterface;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLVariables;
    import flash.text.TextFieldAutoSize;

    TweenPlugin.activate([MotionBlurPlugin]);

    public class VideoSubmissionStep extends AppStep
    {
//      properties
        private var _content:MovieClip;
        private var _nameField:UserInputField;
        private var _submitButton:SquareAppTextButton;

        private var _serverLoader:ServerLoader;
        private var _header:DynamicTextField;
        private var _formContainer:Sprite;

        //	constructor
        public function VideoSubmissionStep(devMode:Boolean = false):void
        {
            _content = new videoSubmissionStageContent() as MovieClip;
            _content.stepHeader.tf.autoSize = TextFieldAutoSize.LEFT;
            _content.stepHeader.tf.text = "Add Name";
            addChild(_content);

            super(devMode);
            _content.prevStep.buttonMode = true;
            _content.prevStep.mouseChildren = false;
            _content.prevStep.addEventListener(MouseEvent.ROLL_OVER, _handlePrevNextInteract);
            _content.prevStep.addEventListener(MouseEvent.ROLL_OUT, _handlePrevNextInteract);
            _content.prevStep.addEventListener(MouseEvent.CLICK, _handlePrevNextInteract);

            _content.nextStep.visible = true;
            _content.nextStep.buttonMode = true;
            _content.nextStep.mouseChildren = false;
            _content.nextStep.addEventListener(MouseEvent.ROLL_OVER, _handlePrevNextInteract);
            _content.nextStep.addEventListener(MouseEvent.ROLL_OUT, _handlePrevNextInteract);
            _content.nextStep.addEventListener(MouseEvent.CLICK, _handlePrevNextInteract);

            _formContainer = new Sprite();

            _header = new DynamicTextField(0, 0, Styling.instance.findFormat('nameHeader'),TextFieldAutoSize.RIGHT);
            _header.text = 'Create Username:';

            _nameField = new UserInputField(304, 40, Styling.instance.findFormat('nameField'));
            _nameField.multiline = false;
            _nameField.background = true;
            _nameField.backgroundColor = Styling.instance.findColor('white');
            _nameField.defaultText = '';
            _nameField.maxChars = 15;
            _nameField.changeFieldValue(_nameField.defaultText);
            _nameField.activateField();
            _nameField.x = _header.x + _header.width + 10;
            _nameField.y = _header.y + 5;

            _formContainer.addChild(_header);
            _formContainer.addChild(_nameField);

//            _submitButton = new SquareAppTextButton('NEXT', Styling.instance.findFormat('basicTextButton'), 'yellow');
//            _submitButton.x = 730;
//            _submitButton.y = 346;
//            _submitButton.addEventListener(Event.SELECT, _handleFormSubmit);

            _serverLoader = new ServerLoader(devMode, true);
            _serverLoader.addEventListener(ServerLoaderEvent.START, _handleServerLoaderEvent);
            _serverLoader.addEventListener(ServerLoaderEvent.ERROR, _handleServerLoaderEvent);
            _serverLoader.addEventListener(ServerLoaderEvent.COMPLETE, _handleServerLoaderEvent);

            _formContainer.x = int((1024 - _formContainer.width) * .5) + 150;
            _formContainer.y = 160;

            _content.addChild(_formContainer);
            //_content.addChild(_submitButton);

        }

        private function _handleServerLoaderEvent(e:ServerLoaderEvent):void
        {
            switch(e.type)
            {
                case ServerLoaderEvent.START:
                    //_submitButton.visible = false;
                    break;

                case ServerLoaderEvent.COMPLETE:
                    //_submitButton.visible = true;
                    LiveTrace.output("server loader event complete");

                    var returnedData:Object = com.adobe.serialization.json.JSON.decode(e.loadedData);
                    LiveTrace.outputObject(returnedData, 'api data');

                    if(returnedData.status == 'success')
                    {
                        LiveTrace.output("success");

                        AppUser.dataModel.id = returnedData.data.id;
                        AppUser.dataModel.basePath = returnedData.data.base_path;
                        var buildUserGifPath:String = AppUser.dataModel.userVideoPath;
                        var buildUserImagePath:String = AppUser.dataModel.userVideoPath;

                        buildUserGifPath = buildUserGifPath.replace(/\./gi, "");
                        buildUserGifPath += '.gif';

                        buildUserImagePath = buildUserImagePath.replace(/\./gi, "");
                        buildUserImagePath += '.png';

                        AppUser.dataModel.userGifPath = buildUserGifPath;
                        AppUser.dataModel.userImagePath = buildUserImagePath;

                        var notification:AppNotificationEvent = new AppNotificationEvent(AppNotificationEvent.SHOW_NOTIFICATION, true);
                            notification.notificationType = AppNotificationEvent.SUBMIT_SUCCESS;
                        StageReference.instance.stage.dispatchEvent(notification);

                        StageReference.instance.stage.addEventListener(AppNotificationEvent.NOTIFICATION_RESPONSE, _handleTrueResponseFromSubmitSuccess);

                        _nameField.clearField();

                        //_showThanks();
                        //StageReference.instance.stage.dispatchEvent(new VideoSubmissionEvent(VideoSubmissionEvent.SUCCESS, _lastSubmitted))
                    }
                    else
                    {
                        _content.nextStep.visible = true;
                        //_submitButton.visible = false;
                        _content.prevStep.visible = true;
//                        _submitButton.visible = false;
//                        _content.prevStep.visible = false;

                        LiveTrace.output(returnedData.data.toString());
                        //if(returnedData.data.toString().indexOf('exists') > -1)	_showError(FORM_NOTIFICATION_VIDEO_EXISTS)
                        //else if(returnedData.data.toString().indexOf('email') > -1)	_showError(FORM_NOTIFICATION_INVALID_EMAIL)
                        //else													_showError(FORM_NOTIFICATION_API_FAIL)
                    }
                    break;

                case ServerLoaderEvent.ERROR:
                    //ExternalInterface.call('console.log', 'error communicating with script');
                    _content.nextStep.visible = true;
                    _content.prevStep.visible = true;
                    //_submitButton.visible = false;
                    _content.prevStep.visible = false;
                    break;
            }
        }

        private function _handleTrueResponseFromSubmitSuccess(e:AppNotificationEvent):void
        {
            StageReference.instance.stage.removeEventListener(AppNotificationEvent.NOTIFICATION_RESPONSE, _handleTrueResponseFromSubmitSuccess);
            if(e.notificationType == AppNotificationEvent.TRUE_RESPONSE)
            {
                StageReference.instance.stage.dispatchEvent(new AppStepEvent(AppStepEvent.INJECT_USER));
                //StageReference.instance.stage.dispatchEvent(new Event('injectUser'));
                _handleNextStepClick(null);
            }

        }

        private function _handleFormSubmit(event:Event):void
        {
            var notification:AppNotificationEvent = new AppNotificationEvent(AppNotificationEvent.SHOW_NOTIFICATION, false);
            var formIsValid:Boolean = _validateForm();
            if(formIsValid)
            {
                notification.notificationType = AppNotificationEvent.FORM_SUBMISSION_START;
                StageReference.instance.stage.dispatchEvent(notification);
                _submitForm();
            }
            else
            {
                notification.notificationType = AppNotificationEvent.FORM_REJECT_EMPTY_NAME;
                StageReference.instance.stage.dispatchEvent(notification);
                _rejectForm();
            }
        }

        private function _rejectForm():void
        {
            var notification:AppNotificationEvent = new AppNotificationEvent(AppNotificationEvent.SHOW_NOTIFICATION, false);
                notification.notificationType = AppNotificationEvent.FORM_REJECT_EMPTY_NAME;
            StageReference.instance.stage.dispatchEvent(notification);
        }

        private function _submitForm():void
        {
            _content.nextStep.visible = false;
            //_submitButton.visible = false;
            _content.prevStep.visible = false;

            AppUser.userName = _nameField.text;

            var vars:URLVariables = new URLVariables();
                vars.name 		= AppUser.userName;
                vars.video_path = AppUser.userVideoPath;
                vars.origin     = AppUser.userOrigin;
                vars.s			= _genHash();

            if(!devMode)
            {
                var serverUrl:String = super.apiBaseUrl + AppConsts.submitScriptUrl;
                if(AppUser.userOrigin == AppConsts.WEBCAM_ORIGIN)
                    serverUrl = super.apiBaseUrl + AppConsts.webcamSubmitScriptUrl;


                LiveTrace.output(vars.toString() + ' - ' + serverUrl);
                _serverLoader.startLoad(serverUrl, vars, URLLoaderDataFormat.VARIABLES, true);
            }
            else
            {
                trace('server will not work from in ide');
            }
        }

        private function _genHash():String
        {
            var s:String = _nameField.text + AppUser.userVideoPath + 'chadbos|jambro';
            s = s.replace(/[^$a-z0-9_]/gi, '');
            s = MD5.hash(s);
            s = s.substring(5,15);
            return s;
        }

        private function _validateForm():Boolean
        {
            return !_nameField.isBlank();
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
                        _handleFormSubmit(null);
                    }

                        //_handleNextStepClick(null);
                    else
                        _handlePrevStepClick(null);
                    break;

            }
        }

        override public function animateIn():void
        {
            _content.nextStep.visible = true;

            this.alpha = 1;
            this.visible = true;

            StageReference.instance.stage.addEventListener(SiteManagerEvent.SITE_STATE_UPDATE, handleSiteStateUpdate);
        }

        override protected function _animateInComplete():void {}


        override protected function _animateOut():void
        {
            this.alpha = 0;
            this.visible = false;

            _animateOutComplete();
        }

        override protected function _animateOutComplete():void
        {
            super._animateOutComplete();
        }

    }

}






