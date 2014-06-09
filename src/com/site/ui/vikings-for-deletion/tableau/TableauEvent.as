/**
 * Created with IntelliJ IDEA.
 * User: work
 * Date: 12/8/13
 * Time: 10:07 AM
 * To change this template use File | Settings | File Templates.
 */
package com.site.ui.tableau
{
	import flash.events.Event;

	public class TableauEvent extends Event
	{
		public static const HIDE_CURRENT_CHARACTER_NAV:String = 'TableauEvent.HIDE_CURRENT_CHARACTER_NAV';
        public static const START_CHAR_VIDEO:String = 'TableauEvent.START_CHAR_VIDEO';
        public static const RETURN_TO_TABLEAU:String = 'TableauEvent.RETURN_TO_TABLEAU';

		public function TableauEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}


		override public function clone():Event
		{
			return new TableauEvent(type,bubbles,cancelable);
		}

		override public function toString():String
		{
			return formatToString('TableauEvent','type','bubbles','cancelable','eventPhase');
		}
	}
}
