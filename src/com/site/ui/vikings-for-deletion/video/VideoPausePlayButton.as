package com.site.ui.video
{
import asset.videoPlayerPausePlayButton;

import com.davidcaneso.display.buttons.MovieClipButton;
import com.davidcaneso.utils.BitmapCachedMask;

import flash.display.MovieClip;
import flash.events.Event;

public class VideoPausePlayButton extends MovieClipButton
{
    private var _progressBar:MovieClip;
    private var _icon:MovieClip;

    public function VideoPausePlayButton(mc:videoPlayerPausePlayButton)
    {
        super(mc);
        _progressBar = mc.progressBar;

        BitmapCachedMask.MaskItem(_progressBar.ring, _progressBar.circleMask);

        _icon = mc.icon;

        updateProgress(0);
        updateIcon(true);

    }

    public function enableButton():void
    {
        super.enable();
    }

    public function disableButton():void
    {
        super.disable();
    }


    public function updateIcon(isPaused:Boolean):void
    {
        if(!isPaused)
            _icon.gotoAndStop(1);
        else
            _icon.gotoAndStop(2);
    }


    public function updateProgress(percent:Number):void
    {
        var validPercent:Number = percent;
        if(percent <= 1)
            validPercent = 1;
        if(percent >= 100)
            validPercent = 100;

        _progressBar['circleMask'].gotoAndStop(validPercent);
    }

    override protected function buttonClick():void
    {
        dispatchEvent(new Event(Event.SELECT));
    }
}
}








/*
package com.site.ui.video
{
import com.davidcaneso.display.buttons.BasicButton;
import com.davidcaneso.utils.BitmapCachedMask;

    import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

    public class VideoPausePlayButton extends BasicButton
    {
        private var _progressBar:MovieClip;
        private var _icon:MovieClip;

        public function VideoPausePlayButton()
        {
            _progressBar = this['progressBar'];

            BitmapCachedMask.MaskItem(_progressBar['ring'], _progressBar['circleMask']);

            _icon = this['icon'];

            updateProgress(0);
            updateIcon(true);

        }

        public function enableButton():void
        {
            super.enable();
        }

        public function disableButton():void
        {
            super.disable();
        }


        public function updateIcon(isPaused:Boolean):void
        {
            if(!isPaused)
                _icon.gotoAndStop(1);
            else
                _icon.gotoAndStop(2);
        }


        public function updateProgress(percent:Number):void
        {
            var validPercent:Number = percent;
            if(percent <= 1)
                validPercent = 1;
            if(percent >= 100)
                validPercent = 100;

            _progressBar['circleMask'].gotoAndStop(validPercent);
        }

        override protected function buttonClick():void
        {
            dispatchEvent(new Event(Event.ACTIVATE));
        }
    }
}
*/