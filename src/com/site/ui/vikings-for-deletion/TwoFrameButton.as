package com.site.ui
{
    import com.davidcaneso.display.buttons.BasicButton;

    public class TwoFrameButton extends BasicButton
    {
        private var _overFrame:int;
        private var _idleFrame:int;
        private var _func:Function;

        public function TwoFrameButton():void
        {

        }

        public function setup(idleFrame:int = 1, overFrame:int = 2, func:Function = null):void
        {
            _overFrame = overFrame;
            _idleFrame = idleFrame;
            _func = func;
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
            this.gotoAndStop(_overFrame);
        }

        override protected function buttonRollOut():void
        {
            this.gotoAndStop(_idleFrame);
        }

        override protected function buttonClick():void
        {
            if(_func != null)
				_func.call();
        }
    }
}