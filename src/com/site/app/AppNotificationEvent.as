package com.site.app
{

    import flash.events.Event;

    public class AppNotificationEvent extends Event
    {
        public static const SHOW_NOTIFICATION:String = 'AppNotificationEvent.SHOW_NOTIFICATION';
        public static const HIDE_NOTIFICATION:String = 'AppNotificationEvent.HIDE_NOTIFICATION';
        public static const NOTIFICATION_RESPONSE:String = 'AppNotificationEvent.NOTIFICATION_RESPONSE';


        // notification types
        public static const VIDEO_FILE_TOO_LARGE:String = 'AppNotificationEvent.VIDEO_FILE_TOO_LARGE';

        public static const FORM_REJECT:String = 'AppNotificationEvent.FORM_REJECT';
        public static const FORM_REJECT_EMPTY_NAME:String = 'AppNotificationEvent.FORM_REJECT_EMPTY_NAME';

        public static const FORM_ERROR:String = 'AppNotificationEvent.FORM_ERROR';
        public static const FORM_SUCCESS:String = 'AppNotificationEvent.FORM_SUCCESS';
        public static const SUBMIT_SUCCESS:String = 'AppNotificationEvent.SUBMIT_SUCCESS';
        public static const FORM_SUBMISSION_START:String = 'AppNotificationEvent.FORM_SUBMISSION_START';

        public static const WEBCAM_UNAVAILALBE:String = 'AppNotificationEvent.WEBCAM_UNAVAILABLE';
        public static const WEBCAM_SUBMIT_SUCCESS:String = 'AppNotificationEvent.WEBCAM_SUBMIT_SUCCESS';
        public static const WEBCAM_SUBMIT_FAIL:String = 'AppNotificationEvent.WEBCAM_SUBMIT_FAIL';
        public static const WEBCAM_SUBMIT_START:String = 'AppNotificationEvent.WEBCAM_SUBMIT_START';

        public static const VIDEO_UNVERIFIED:String = 'AppNotificationEvent.VIDEO_UNVERIFIED';
        public static const VIDEO_INVALID_FORMAT:String = 'AppNotificationEvent.VIDEO_INVALID_FORMAT';
        public static const VIDEO_NOT_FOUND:String = 'AppNotificationEvent.VIDEO_NOT_FOUND';

        public static const SEARCH_START:String = 'AppNotificationEvent.SEARCH_START';
        public static const SEARCH_BLANK:String = 'AppNotificationEvent.SEARCH_BLANK';
        public static const SEARCH_FAIL:String = 'AppNotificationEvent.SEARCH_FAIL';


        // response types
        public static const TRUE_RESPONSE:String = 'AppNotificationEvent.TRUE_RESPONSE';
        public static const FALSE_RESPONSE:String = 'AppNotificationEvent.FALSE_RESPONSE';


        private var _notificationType:String;
        private var _responseRequired:Boolean;









        public function AppNotificationEvent(type:String, responseRequired:Boolean = false, bubbles:Boolean=false,cancelable:Boolean=false)
        {
            super(type,bubbles,cancelable);
            _responseRequired = responseRequired;
        }


        public function get responseRequired():Boolean
        {
            return _responseRequired;
        }

        public function get notificationType():String
        {
            return _notificationType;
        }


        public function set notificationType(value:String):void
        {
            _notificationType = value;
        }


        public override function clone():Event
        {
            var clonedEvent:AppNotificationEvent = new AppNotificationEvent(type,_responseRequired,bubbles,cancelable);
                clonedEvent.notificationType = _notificationType;
            return clonedEvent;
        }


        public override function toString():String
        {
            return formatToString('AppNotificationEvent','type','_responseRequired','_notificationType','bubbles','cancelable','eventPhase');
        }

    }
}