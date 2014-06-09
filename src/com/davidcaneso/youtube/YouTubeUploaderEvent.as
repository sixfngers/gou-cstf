/**
 * Created with IntelliJ IDEA.
 * User: work
 * Date: 3/1/13
 * Time: 7:58 AM
 * To change this template use File | Settings | File Templates.
 */
package com.davidcaneso.youtube
{
import flash.events.Event;

public class YouTubeUploaderEvent extends Event
{
	public static const USER_NOT_LOGGED_IN:String 		= 'YouTubeUploaderEvent.USER_NOT_LOGGED_IN';
	public static const LOGIN_SUCCESS:String 			= 'YouTubeUploaderEvent.LOGIN_SUCCESS';
	public static const LOGIN_FAIL:String 				= 'YouTubeUploaderEvent.LOGIN_FAIL';
	public static const FILE_UPLOAD_START:String 		= 'YouTubeUploaderEvent.FILE_UPLOAD_START';
	public static const FILE_UPLOAD_SUCCESS:String 		= 'YouTubeUploaderEvent.FILE_UPLOAD_SUCCESS';
	public static const FILE_UPLOAD_FAIL:String 		= 'YouTubeUploaderEvent.FILE_UPLOAD_FAIL';

	//	failure codes
	public static const UNDEFINED_TITLE:String 			= 'YouTubeUploaderEvent.UNDEFINED_TITLE';
	public static const UNDEFINED_DESCRIPTION:String 	= 'YouTubeUploaderEvent.UNDEFINED_DESCRIPTION';
	public static const INVALID_TOKEN:String 			= 'YouTubeUploaderEvent.INVALID_TOKEN';
	public static const MISSING_TOKEN:String 			= 'YouTubeUploaderEvent.MISSING_TOKEN';
	public static const DUPLICATE:String 				= 'YouTubeUploaderEvent.DUPLICATE';
	public static const TOKEN_EXPIRED:String 			= 'YouTubeUploaderEvent.TOKEN_EXPIRED';


	public var failReason:String;
	public var youTubeVideoUrl:String;
	public var status:String;
	public var code:String;

	public function YouTubeUploaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
	}

	public override function clone():Event
	{
		var evt:YouTubeUploaderEvent = new YouTubeUploaderEvent(type, bubbles, cancelable);
			evt.youTubeVideoUrl = youTubeVideoUrl;
			evt.failReason 		= failReason;
			evt.status 			= status;
			evt.code 			= code;

		return evt
	}

	public override function toString():String
	{
		return formatToString('YouTubeUploaderEvent', 'type', 'bubbles', 'cancelable', 'eventPhase');
	}

}

}