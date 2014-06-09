package com.site.footer
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ExperienceInfoPanel extends MovieClip
	{
		private var _closeButton:MovieClip;

		public function ExperienceInfoPanel()
		{
			_closeButton = this['closeButton'] as MovieClip;
			_closeButton.buttonMode = true;
			_closeButton.mouseChildren = false;
			_closeButton.addEventListener(MouseEvent.ROLL_OVER, _closeInteraction);
            _closeButton.addEventListener(MouseEvent.ROLL_OUT, _closeInteraction);
            _closeButton.addEventListener(MouseEvent.CLICK, _closeInteraction);
		}

		private function _closeInteraction(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.ROLL_OVER:
					_closeButton.gotoAndStop(2);
					break;

                case MouseEvent.ROLL_OUT:
                    _closeButton.gotoAndStop(1);
					break;

                case MouseEvent.CLICK:
					dispatchEvent(new Event(Event.CLOSE));
					break;
			}
		}

	}
}
