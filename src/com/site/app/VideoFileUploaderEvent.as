package com.site.app
{

    import flash.events.Event;

    public class VideoFileUploaderEvent extends Event
    {
        public static const BROWSE_START    :String = 'fileBrowse';
        public static const BROWSE_CANCEL   :String = 'fileBrowseCancel';
        public static const SELECT          :String = 'fileSelect';
        public static const START           :String = 'loadStart';
        public static const UPDATE          :String = 'loadUpdate';
        public static const COMPLETE        :String = 'loadComplete';
        public static const ERROR           :String = 'loadError';

        private var _file:String;
        private var _percent:int;

        public function VideoFileUploaderEvent(type:String,p_file:String,p_percent:int,bubbles:Boolean=false,cancelable:Boolean=false)
        {
            super(type,bubbles,cancelable);
            _file = p_file;
            _percent = p_percent;
        }

        public function get file():String
        {
            return _file;
        }

        public function get percent():int
        {
            return _percent;
        }

        public override function clone():Event
        {
            return new VideoFileUploaderEvent(type,file,percent,bubbles,cancelable);
        }

        public override function toString():String
        {
            return formatToString('VideoFileUploaderEvent','type','file','percent','bubbles','cancelable','eventPhase');
        }

    }
}