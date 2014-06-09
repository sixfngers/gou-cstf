package com.site.ui
{
	import com.davidcaneso.display.buttons.BasicButton;

	public class TwoStateAnimatedButton extends BasicButton
	{
		private var _inFrameStart:int;
		private var _outFrameStart:int;
		private var _func:Function;

		public function TwoStateAnimatedButton():void
		{

		}

		public function setup(inFrameStart:int = 1, outFrameStart:int = 2, func:Function = null)
		{
			_inFrameStart = inFrameStart;
			_outFrameStart = outFrameStart;
			_func = func;
		}


		override protected function buttonRollOver():void
		{
			this.gotoAndPlay(_inFrameStart);
		}

		override protected function buttonRollOut():void
		{
			this.gotoAndPlay(_outFrameStart);
		}

		override protected function buttonClick():void
		{
			if(_func)
				_func.call();
		}
	}
}