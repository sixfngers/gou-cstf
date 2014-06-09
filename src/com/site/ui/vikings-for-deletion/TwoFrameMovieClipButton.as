package com.site.ui
{
	import com.davidcaneso.display.buttons.MovieClipButton;

	import flash.display.MovieClip;

	public class TwoFrameMovieClipButton extends MovieClipButton
    {

        private var _overFrame:int;
        private var _idleFrame:int;
        private var _func:Function;

        public function TwoFrameMovieClipButton(mc:MovieClip, idleFrame:int = 1, overFrame:int = 2, clickFunction:Function = null,  enabledAtCreation:Boolean = true):void
        {
			super(mc, enabledAtCreation);
			_idleFrame = idleFrame;
			_overFrame = overFrame;
			_func = clickFunction;
        }

        public function enableButton():void
        {
            super.enable();
        }

        public function disableButton():void
        {
            super.disable();
        }

        override protected function buttonRollOver():void
        {
			_mc.gotoAndStop(_overFrame);
        }

        override protected function buttonRollOut():void
        {
			_mc.gotoAndStop(_idleFrame);
        }

        override protected function buttonClick():void
        {
            if(_func != null) _func.call();
        }
    }
}