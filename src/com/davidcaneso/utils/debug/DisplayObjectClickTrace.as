package com.davidcaneso.utils.debug
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	public class DisplayObjectClickTrace
	{
		private var _stage:Stage;

		public function DisplayObjectClickTrace(stage:Stage)
		{
			_stage = stage;
			stage.addEventListener(MouseEvent.CLICK, iterateThroughDisplayList, true);
		}

		private function iterateThroughDisplayList(e:MouseEvent):void
		{
			var displayObj:DisplayObject = e.target as DisplayObject;
			var displayObjClass:String = getQualifiedClassName(displayObj);
			trace("=========initDisplayObjectHelper START==============");
            trace("=========[Properties]\nstage x: " + _stage.mouseX + "\n stage y: " + _stage.mouseY);
			while(displayObj != null && displayObj != _stage)
			{
				trace("currentItemClass: ", displayObjClass + " String:" + displayObj + " Name:" + displayObj.name);
				displayObj = displayObj.parent;
				displayObjClass = getQualifiedClassName(displayObj);
			}
			trace("=========initDisplayObjectHelper END==============");
		}
	}
}
