package com.davidcaneso.facebook.utils
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * ...
	 * @author Brian Hodge // brian@hodgedev.com
	 */
	public class Logger
	{
		private var _logToDatabase	:Boolean;
		private var _logToLocal		:Boolean = true;
		
		public static function log(pMessage:String, pLogToDatabase:Boolean = false):void
		{
			if (pLogToDatabase) Logger.logToDatabase(pMessage);
			trace(pMessage);
		}
		
		private static function logToDatabase(pMessage:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			var request:URLRequest = new URLRequest("scripts/logger.php");
			request.method = URLRequestMethod.POST;
			var vars:URLVariables = new URLVariables();
			vars.time = new Date().toLocaleDateString();
			vars.message = pMessage;
			request.data = vars;
			
			loader.addEventListener(Event.COMPLETE, _onLogComplete);
			loader.load(request);
		}
		private static function _onLogComplete(e:Event):void
		{
			trace("Logged to database.");
		}
	}
}