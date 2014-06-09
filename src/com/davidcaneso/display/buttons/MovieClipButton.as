package com.davidcaneso.display.buttons
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MovieClipButton extends MovieClip
	{
		//	properties
		protected var _mc:MovieClip;
		protected var _isClickable:Boolean;

		//	constructor
		public function MovieClipButton(mc:MovieClip, isEnabledAtCreation:Boolean = true):void
		{
			_mc = mc;
			_mc.tabEnabled 		= false;
			_mc.mouseChildren 	= false;
			disable();
			if(isEnabledAtCreation) enable();
		}

		//	public methods
		public function destroy():void
		{
			disable();
		}

		//	getters
		public function get isClickable():Boolean
		{
			return _isClickable;
		}

		//	protected methods
		protected function enable():void
		{
			_mc.buttonMode 		= true;
			_isClickable 	= true;
			_mc.addEventListener(MouseEvent.ROLL_OVER	, _interact);
			_mc.addEventListener(MouseEvent.ROLL_OUT	, _interact);
			_mc.addEventListener(MouseEvent.CLICK		, _interact);
		}

		protected function disable():void
		{
			_mc..buttonMode 		= false;
			_isClickable 	= false;
			_mc.removeEventListener(MouseEvent.ROLL_OVER	, _interact);
			_mc.removeEventListener(MouseEvent.ROLL_OUT		, _interact);
			_mc.removeEventListener(MouseEvent.CLICK		, _interact);
		}

		protected function buttonRollOver():void{}
		protected function buttonRollOut():void{}
		protected function buttonClick():void{}

		//	private methods
		private function _interact(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.ROLL_OVER:
					buttonRollOver();
					break;

				case MouseEvent.ROLL_OUT:
					buttonRollOut();
					break;

				case MouseEvent.CLICK:
					buttonClick();
					break;
			}
		}

		public function get mc():MovieClip
		{
			return _mc;
		}
	}

}