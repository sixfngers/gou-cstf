package com.site.app
{

import flash.events.Event;

public class AppStepEvent extends Event
{
    public static const PREV_STEP_EVENT_TYPE    :String = 'AppStepEvent.PREV_STEP_EVENT_TYPE';
    public static const NEXT_STEP_EVENT_TYPE    :String = 'AppStepEvent.NEXT_STEP_EVENT_TYPE';

    public static const SLEEP_APP               :String = 'AppStepEvent.APP_SLEEP';
    public static const WAKE_APP                :String = 'AppStepEvent.APP_WAKE';

    public static const SOUND_TOGGLE            :String = 'AppStepEvent.SOUND_TOGGLE';
    public static const SOUND_MUTED             :String = 'AppStepEvent.SOUND_MUTED';
    public static const SOUND_UNMUTED           :String = 'AppStepEvent.SOUND_UNMUTED';

    public static const UPLOAD_STEP             :String = 'AppStepEvent.UPLOAD_STEP';
    public static const WEBCAM_RECORD_STEP      :String = 'AppStepEvent.WEBCAM_RECORD_STEP';

    public static const START_APP               :String = 'AppStepEvent.START_APP';

    public static const LEARN_MOVES             :String = 'AppStepEvent.LEARN_MOVES';
    public static const CLOSE_LEARN_MOVES       :String = 'AppStepEvent.CLOSE_LEARN_MOVES';

    public static const INJECT_USER             :String = 'AppStepEvent.INJECT_USER';

    public static const SEARCH_FOR_VIDEO        :String = 'AppStepEvent.SEARCH_FOR_VIDEO';


    public static const ACTIVE_STEP_UPDATE      :String = 'AppStepEvent.ACTIVE_STEP_UPDATE';
    public static const VIDEO_SLOT_ACTIVATED    :String = 'AppStepEvent.VIDEO_SLOT_ACTIVATED';

    public static const HIDE_SEARCH             :String = 'AppStepEvent.HIDE_SEARCH';
    public static const SHOW_SEARCH             :String = 'AppStepEvent.SHOW_SEARCH';

    public static const INITIAL_VIDEO_COMPLETE  :String = 'AppStepEvent.INITIAL_VIDEO_COMPLETE';
    public static const SHOW_NEXT_VIDEO_BUTTON  :String = 'AppStepEvent.SHOW_NEXT_VIDEO_BUTTON';


    private var _param:String;


    public function AppStepEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false)
    {
        super(type,bubbles,cancelable);
    }

    public function set param(val:String):void
    {
        _param = val;
    }

    public function get param():String
    {
        return _param;
    }

    public override function clone():Event
    {
        var clonedShareEvent:AppStepEvent = new AppStepEvent(type, bubbles,cancelable);
            clonedShareEvent.param = _param;

        return clonedShareEvent;
    }

    public override function toString():String
    {
        return formatToString('AppStepEvent','type','_param','bubbles','cancelable','eventPhase');
    }


}
}