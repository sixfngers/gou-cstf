/**
 * Created with IntelliJ IDEA.
 * User: ifreelance3
 * Date: 12/9/13
 * Time: 1:28 PM
 * To change this template use File | Settings | File Templates.
 */
package com.site.ui.characterModelRotation
{
	import flash.events.Event;

	public class RotationControllerEvent extends Event
	{
		public static const UPDATE:String = 'RotationControllerEvent.UPDATE';


		private var _rotationAmount:Number;

		public function RotationControllerEvent(type:String, rotation:Number, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
			_rotationAmount = rotation;
		}

		public override function clone():Event
		{
			return new RotationControllerEvent(type,_rotationAmount,bubbles,cancelable);
		}

		public override function toString():String
		{
			return formatToString('RotationControllerEvent','type','_rotationAmount', 'bubbles','cancelable','eventPhase');
		}

		public function get rotationAmount():Number
		{
			return _rotationAmount;
		}
	}
}
