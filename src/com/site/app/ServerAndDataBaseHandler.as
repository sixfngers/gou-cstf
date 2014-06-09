package com.site.app
{
import com.adobe.crypto.MD5;
import com.adobe.images.PNGEncoder;
import com.adobe.serialization.json.JSON;

import flash.display.Bitmap;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.ByteArray;

import ru.inspirit.net.MultipartURLLoader;

public class ServerAndDataBaseHandler extends EventDispatcher
	{
		
		/**
		 * UPLOAD_IMAGE_OR_VIDEO: Upload a video file and/or an image file
		*	POST variables:
		*		image - an image upload (mime whitelist jpg,gif,png)
		*		video - a video upload (currently allowing anything, let me know what formats to whitelist)
		*		origin - one of three strings: ['default', 'ios', 'flash'] this just splits the uploads into different folders. if omitted will default to 'default'.
		*	You can upload both the image and video at once, but you don't have to. You can omit either the video or the image and it will still work fine. If you do upload both at once and one of the uploads fails, the response should reflect that. This call doesn't touch the database.
		*	For all successful uploads, the file's path on the server will be returned. You should use these paths when doing the next submission step.
		*/
		public const UPLOAD_IMAGE_OR_VIDEO:String = "/entries/upload";
		
		/**
		 * SUBMIT_RECORD: Submits a new record into the database.
		*	POST variables:
		 * 		s - md5 hash
		*		name - the display name of the entry
		*		image_path - the relative path to the image on the server, returned from /upload api call
		*		video_path - the relative path to the video on the server, returned from /upload api call
		*		effect - string, whatever you pass here will be stored as-is in the db
		*		origin - string, whatever you pass here will be stored as-is in the db
		*	When successful this returns the id of the new record in the database.
 		*/
		public const SUBMIT_RECORD:String = "/entries/submit";
		
		/**
		 * GET_BY_ID: 
		 * POST variables:
		* 	id - an id of a record in the db
		* 	Returns a specific entry from the db. This ignores the moderation status of the entry.
		 */
		public const GET_BY_ID:String = "/entries/get_by_id";
		
		/**
		 * VOTE: 
		 * POST variables:
		*	id - an id of a record in the db
		*	Increments the entry's rating by one.
 		*/
		public const VOTE:String = "/entries/vote";
		
		/**
		 * GET_100:
		 * no variables, returns 100 approved entries starting from offset 0, 
		 * change the numbers at the end of the url to change the pagination. 
		 * The total number of approved entries is returned every time.
		 */
		public const GET_100:String = "/entries/get/100/0";
		
		public const GET_TOP_TEN:String = "/entries/get/20?order=rating";
		
		/**
		 * SEARCH_GET, aka general get:
		 * text search is just an optional GET parameter to the /get method:
		 * 	http://s.watsondg.com/expendables2/api/index.php/entries/get?search=test
		 * 	http://s.watsondg.com/expendables2/api/index.php/entries/get/100/0?search=notthere
		 */
		public const SEARCH_GET:String = "/entries/get";
		public const SEARCH_GET_TEMP:String = "/entries/get/10/0?origin=flash";
		public const NEW_SEARCH_GET:String = "/entries/get/20/0";
//		http://jointheexpendables.com/api/index.php/entries/get/20/0?search=a
		/**
		 * SEARCH_SUFFIX (again, text search is just an optional GET parameter to the /get method)
		 */
		public const SEARCH_SUFFIX:String = "?search=";
//		public const SEARCH_SUFFIX:String = "?origin=flash&search=";
		
		
		private var locked:Boolean = false;
		private var hasImageChanged:Boolean = true;
		private var receivedFirstReturn:Boolean = false;
		
		private var curOffset:int = 0;
		private var offsetAmount:int = 20;
		
		public function ServerAndDataBaseHandler(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function uploadVideo(data:ByteArray, fileName:String):void{
			var date:Date = new Date();
	//		var fileName:String = 'testimage'+date.time+'.' + extension;
		//	var data:ByteArray = PNGEncoder.encode(bmp.bitmapData);
			//
			var _saveLoader:MultipartURLLoader = new MultipartURLLoader();
			//				_saveLoader.addVariable("message", "The Lorax Speaks is a movement to help save the Atlantic Forest in Brazil. Help Raise awareness by personalizing your profile picture with Truffula Trees from Dr. Seuss' The Lorax, featuring the voice talent of Zac Efron, Taylor Swift, Betty White and Danny DeVito, is in theaters March 2, 2012. https://www.facebook.com/theloraxmovie?sk=app_378606902151850");
			ExpendableUser.videoSource = "upload";
			_saveLoader.addVariable("origin", ExpendableUser.videoSource);
			
			_saveLoader.addFile(data, fileName, "video");
			//_saveLoader.loader
			_saveLoader.addEventListener(Event.COMPLETE, _onUploadVideoComplete);
			_saveLoader.load(Globals.SERVER_API_ROOT + UPLOAD_IMAGE_OR_VIDEO);
			//
			trace('let the user know the upload has started');
		}
		
		private function _onUploadVideoComplete(e:Event):void
		{
			
			
			var _saveLoader:MultipartURLLoader = MultipartURLLoader(e.target)
			
			trace(_saveLoader.loader.data);
			
			var status:String = com.adobe.serialization.json.JSON.decode(_saveLoader.loader.data).status;
			trace("status returned as " + status);
			
			var thumbEvent:EventWithArgs;
			
			if (status == "success"){
				// now get succeeded object
				var dataObject:Object = com.adobe.serialization.json.JSON.decode(_saveLoader.loader.data).data;
				var succeededObj:Object = dataObject.succeeded;
				var videoString:String = succeededObj.video;
				trace("video path is " + videoString);
				
				ExpendableUser.myVideo = videoString;
				
				thumbEvent = new EventWithArgs(ExpendableEvents.VIDEO_SAVED, false, false, {videopath:videoString});
				dispatchEvent(thumbEvent);
			} else {
				ExpendableUser.myThumbnail = "";
				thumbEvent = new EventWithArgs(ExpendableEvents.VIDEO_SAVED, false, false, {videopath:"fail"});
				dispatchEvent(thumbEvent);
			}
			
			
		}
		
		public function uploadImage(bmp:Bitmap):void{
			if (!locked) {
				
				if (hasImageChanged) {
					
					
					//_saveLoader.startLoad('uploadFinalImage.php', )
					var date:Date = new Date();
					var fileName:String = 'testimage'+date.time+'.png';
					var data:ByteArray = PNGEncoder.encode(bmp.bitmapData);
					//
					var _saveLoader:MultipartURLLoader = new MultipartURLLoader();
	//				_saveLoader.addVariable("message", "The Lorax Speaks is a movement to help save the Atlantic Forest in Brazil. Help Raise awareness by personalizing your profile picture with Truffula Trees from Dr. Seuss' The Lorax, featuring the voice talent of Zac Efron, Taylor Swift, Betty White and Danny DeVito, is in theaters March 2, 2012. https://www.facebook.com/theloraxmovie?sk=app_378606902151850");
					_saveLoader.addVariable("origin", ExpendableUser.videoSource);
						
					_saveLoader.addFile(data, fileName, "image");
					//_saveLoader.loader
					_saveLoader.addEventListener(Event.COMPLETE, _onUploadImageComplete);
					_saveLoader.load(Globals.SERVER_API_ROOT + UPLOAD_IMAGE_OR_VIDEO);
					//
					trace('let the user know the upload has started');
					
					
					locked = true;
					
	//				hasImageChanged = false;
				} else {
					// if image hasn't changed, don't reupload, just relaunch cropping popup
					
				}
				
			} else {
				trace("did not allow for upload because image saver is locked");
			}
		}
		
		
		private function _onUploadImageComplete(e:Event):void
		{
			locked = false;
			
			var _saveLoader:MultipartURLLoader = MultipartURLLoader(e.target)
			
			trace(_saveLoader.loader.data);
			
			var status:String = com.adobe.serialization.json.JSON.decode(_saveLoader.loader.data).status;
			trace("status returned as " + status);
			
			var thumbEvent:EventWithArgs;
			
			if (status == "success"){
				// now get succeeded object
				var dataObject:Object = com.adobe.serialization.json.JSON.decode(_saveLoader.loader.data).data;
				var succeededObj:Object = dataObject.succeeded;
				var imageString:String = succeededObj.image;
				trace("image path is " + imageString);
				
				ExpendableUser.myThumbnail = imageString;
				
				thumbEvent = new EventWithArgs(ExpendableEvents.THUMBNAIL_SAVED, false, false, {thumbpath:imageString});
				dispatchEvent(thumbEvent);
			} else {
				ExpendableUser.myThumbnail = "";
				thumbEvent = new EventWithArgs(ExpendableEvents.THUMBNAIL_SAVED, false, false, {thumbpath:"fail"});
				dispatchEvent(thumbEvent);
			}
			
			
		}
		
		public function saveUser():void{
			// rather than pass info, we assume that all info has correctly been saved to
			// Expendable User singleton
			// ...but check also. What was that Bush-era euphemism? Trust, but confirm?
			if (ExpendableUser.myName != "" && ExpendableUser.myEffect != "" && ExpendableUser.myThumbnail != "" && ExpendableUser.myVideo !=""){
				
				
				
				var s:String = createHash();
				
				var request:URLRequest = new URLRequest (Globals.SERVER_API_ROOT + SUBMIT_RECORD);
				//var request:URLRequest = new URLRequest ("http://s.watsondg.com/lorax/api/index.php/icons/submit"); 
				request.method = URLRequestMethod.POST; 
				
				/*
				* 		s - md5 hash
				*		name - the display name of the entry
				*		image_path - the relative path to the image on the server, returned from /upload api call
				*		video_path - the relative path to the video on the server, returned from /upload api call
				*		effect - string, whatever you pass here will be stored as-is in the db
				*		origin - string, whatever you pass here will be stored as-is in the db
				*/
				
				var variables:URLVariables = new URLVariables(); 
				
				variables.s = s; 
				trace("name: " + ExpendableUser.myName);
				trace("image: " + ExpendableUser.myThumbnail);
				trace("video: " + ExpendableUser.myVideo);
				trace("hash: " + s);
				variables.name = ExpendableUser.myName; 
				variables.image_path = ExpendableUser.myThumbnail; 
				variables.video_path = ExpendableUser.myVideo;
				variables.effect = ExpendableUser.myEffect; 
				variables.origin = ExpendableUser.videoSource;             
				request.data = variables; 
				
				var loader:URLLoader = new URLLoader (request); 
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.addEventListener(Event.COMPLETE, _onSubmitComplete, false, 0, true); 
				//loader.dataFormat = URLLoaderDataFormat.VARIABLES; 
				loader.load(request); 
				
				
			} else {
				// not safe to save, return event to say so
				
				var resultEvent:EventWithArgs = new EventWithArgs(ExpendableEvents.UNABLE_TO_COMPLY, false, false, null);
				dispatchEvent(resultEvent);
			}
		}
		
		public function _onSubmitComplete(e:Event):void{
			// do you want to do something here?
			trace(e.target.data);
			
			var status:String = com.adobe.serialization.json.JSON.decode(e.target.data).status;
			trace("status returned as " + status);
			
			if (status == "success"){
				var dataObject:Object = com.adobe.serialization.json.JSON.decode(e.target.data).data;
				ExpendableUser.myID = dataObject.id;
				
				var resultEvent:EventWithArgs = new EventWithArgs(ExpendableEvents.VIDEO_SUBMITTED, false, false, null);
				dispatchEvent(resultEvent);
				trace("user video submitted, submission ID is " + ExpendableUser.myID);
			} else {
				// failure!!
				var failEvent:EventWithArgs = new EventWithArgs(ExpendableEvents.UNABLE_TO_COMPLY, false, false, null);
				dispatchEvent(failEvent);
				trace("user video submission failure");
			}
				
			
		}
		
		public function voteUp(uniqueID:String, curRating:String):void{
			var callURL:String = Globals.SERVER_API_ROOT + VOTE;
			var request:URLRequest = new URLRequest (callURL);
			request.method = URLRequestMethod.POST;
			var variables:URLVariables = new URLVariables(); 
			var s:String = createVoteHash(uniqueID, curRating);
			variables.s = s;
			variables.id = uniqueID;         
			request.data = variables;
			var loader:URLLoader = new URLLoader (request); 
			loader.dataFormat = URLLoaderDataFormat.TEXT;
		//	loader.addEventListener(Event.COMPLETE, _onGetComplete, false, 0, true); 
			//loader.dataFormat = URLLoaderDataFormat.VARIABLES; 
			loader.load(request); 
		}
		
		public function getVideoByID(uniqueID:String):void{
			var callURL:String = Globals.SERVER_API_ROOT + GET_BY_ID;
			var request:URLRequest = new URLRequest (callURL);
			request.method = URLRequestMethod.POST;
			var variables:URLVariables = new URLVariables(); 
			
			variables.id = uniqueID;         
			request.data = variables;
			var loader:URLLoader = new URLLoader (request); 
			loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.addEventListener(Event.COMPLETE, _onGetSingleComplete, false, 0, true); 
			//loader.dataFormat = URLLoaderDataFormat.VARIABLES; 
			loader.load(request); 
		}
		
		private function _onGetSingleComplete(e:Event):void{
			// do you want to do something here?
			trace("GET SINGLE VID BY ID RESULT:");
			trace(e.target.data);
			
			// first, let's see if we got a successful return
			var status:String = com.adobe.serialization.json.JSON.decode(e.target.data).status;
			
			var getEvent:EventWithArgs;
			
			var returnArray:Array = new Array();
			
			if (status == "success"){
				// now get succeeded object
				var vidEntry:Object = com.adobe.serialization.json.JSON.decode(e.target.data).data;
				
				var vidItem:VideoItem = new VideoItem();
				vidItem.id = vidEntry.id;
				vidItem.displayName = vidEntry.name;
				vidItem.thumbnail = vidEntry.image_path;
				vidItem.videoURL = vidEntry.video_path;
				vidItem.effect = vidEntry.effect;
				vidItem.origin = vidEntry.origin;
				vidItem.rating = vidEntry.rating;
				
				var statString:String = vidEntry.status;
				if (statString == "blacklisted") {
					vidItem.blacklisted = true;
				}
				
				returnArray.push(vidItem);
					
				trace("added video with name " + vidItem.displayName + " to the queue");
				
				
				
				getEvent = new EventWithArgs(ExpendableEvents.QUEUE_RETURN, false, false, {returnQueue:returnArray, singleSearch:true, searchReturn:true});
				dispatchEvent(getEvent);
				
			} else {
				
				getEvent = new EventWithArgs(ExpendableEvents.UNABLE_TO_COMPLY, false, false, null);
				dispatchEvent(getEvent);
			}
			
			
		}
		
		public function getHeroes():void{
			trace("getting videos...");
			var callURL:String = Globals.HEROES_JSON;
			//		var callURL:String = Globals.SERVER_API_ROOT + SEARCH_GET_TEMP;
			var request:URLRequest = new URLRequest (callURL);
			request.method = URLRequestMethod.GET;
			var loader:URLLoader = new URLLoader (request); 
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, _onHeroComplete, false, 0, true); 
			//loader.dataFormat = URLLoaderDataFormat.VARIABLES; 
			loader.load(request); 
		}
		
		public function _onHeroComplete(e:Event):void{
			// do you want to do something here?
			trace("GET VIDEOS RESULT:");
			trace(e.target.data);
			
			// first, let's see if we got a successful return
			var status:String = com.adobe.serialization.json.JSON.decode(e.target.data).status;
			
			var getEvent:EventWithArgs;
			
			var returnArray:Array = new Array();
			
			if (status == "success"){
				// now get succeeded object
				var dataObject:Object = com.adobe.serialization.json.JSON.decode(e.target.data).data;
				var totalReturns:int = dataObject.total;
				var randomizer:Number = dataObject.randomizer;
				var increaser:Number = dataObject.increaser;
				var entries:Array = dataObject.entries;
				for (var i:int= 0; i<entries.length; i++){
					var vidEntry:Object = entries[i];
					var vidItem:VideoItem = new VideoItem();
					vidItem.id = vidEntry.id;
					vidItem.displayName = vidEntry.name;
					// HAVE TO DO ORIGIN BEFORE THUMBNAIL!!
					vidItem.origin = vidEntry.origin;
					vidItem.thumbnail = vidEntry.image_path;
					vidItem.videoURL = vidEntry.video_path;
					vidItem.effect = vidEntry.effect;
					vidItem.rating = vidEntry.rating;
					if (vidItem.origin == "hero") {
						//			if (vidItem.origin == "flash" ) {
						returnArray.push(vidItem);
					} else {
						// dump it for now
					}
					
					
					trace("added video with name " + vidItem.displayName + " to the hero queue");
				}
				
				
				getEvent = new EventWithArgs(ExpendableEvents.HERO_RETURN, false, false, {randomizer:randomizer, increaser:increaser, returnQueue:returnArray});
				dispatchEvent(getEvent);
				
			} else {
				
				getEvent = new EventWithArgs(ExpendableEvents.UNABLE_TO_COMPLY, false, false, null);
				dispatchEvent(getEvent);
			}
			
			
			//var resultEvent:EventWithArgs = new EventWithArgs(ExpendableEvents.VIDEO_SUBMITTED, false, false, null);
			//dispatchEvent(resultEvent);
		}
		
		public function getVideos(number:int=20, offset:int=0):void{
			/*		// removing now that server is random 7/19/12
			
			if (offset == 0) {			//replace with current offset
				offset = curOffset;
			}
			if (!receivedFirstReturn) {
				curOffset += offsetAmount;
			}
			*/
			trace("getting videos... current offset is " + offset);
			var callURL:String = Globals.SERVER_API_ROOT + SEARCH_GET + "/" + number.toString() + "/" + offset.toString();
	//		var callURL:String = Globals.SERVER_API_ROOT + SEARCH_GET_TEMP;
			var request:URLRequest = new URLRequest (callURL);
			request.method = URLRequestMethod.GET;
			var loader:URLLoader = new URLLoader (request); 
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, _onGetComplete, false, 0, true); 
			//loader.dataFormat = URLLoaderDataFormat.VARIABLES; 
			loader.load(request); 
		}
		
		public function _onGetComplete(e:Event):void{
			/* // removing now that server is random 7/19/12
			if (!receivedFirstReturn) {
				if (curOffset > offsetAmount) {
					curOffset-= offsetAmount;		// undoing the last blind offset add (line 461)
				}
				receivedFirstReturn = true;
			}
			*/
			// do you want to do something here?
			trace("GET VIDEOS RESULT:");
			trace(e.target.data);
			
			// first, let's see if we got a successful return
			var status:String = com.adobe.serialization.json.JSON.decode(e.target.data).status;
			
			var getEvent:EventWithArgs;
			
			var returnArray:Array = new Array();
			
			if (status == "success"){
				// now get succeeded object
				var dataObject:Object = com.adobe.serialization.json.JSON.decode(e.target.data).data;
				var totalReturns:int = dataObject.total;
				/* // removing now that server is random 7/19/12
				if (totalReturns > curOffset + offsetAmount ) {
					curOffset += offsetAmount;			// increases by another 20 items each return
				} else {
					curOffset = 0;
				}
				*/
				trace("changed offset to " + curOffset + " because total was " + totalReturns);
				var entries:Array = dataObject.entries;
				for (var i:int= 0; i<entries.length; i++){
					var vidEntry:Object = entries[i];
					var vidItem:VideoItem = new VideoItem();
					vidItem.id = vidEntry.id;
					vidItem.displayName = vidEntry.name;
					vidItem.thumbnail = vidEntry.image_path;
					vidItem.videoURL = vidEntry.video_path;
					vidItem.effect = vidEntry.effect;
					vidItem.origin = vidEntry.origin;
					vidItem.rating = vidEntry.rating;
			if (vidItem.origin == "flash" || vidItem.origin == "ios" || vidItem.origin == "upload") {
		//			if (vidItem.origin == "flash" ) {
						returnArray.push(vidItem);
					} else {
						// dump it for now
					}
					
					
					trace("added video with name " + vidItem.displayName + " to the queue");
				}
				
				
				getEvent = new EventWithArgs(ExpendableEvents.QUEUE_RETURN, false, false, {returnQueue:returnArray});
				dispatchEvent(getEvent);
				
			} else {
				
				getEvent = new EventWithArgs(ExpendableEvents.UNABLE_TO_COMPLY, false, false, null);
				dispatchEvent(getEvent);
			}
			
			
			//var resultEvent:EventWithArgs = new EventWithArgs(ExpendableEvents.VIDEO_SUBMITTED, false, false, null);
			//dispatchEvent(resultEvent);
		}
		
		public function getVideosBySearchString(searchString:String):void{
			//		var callURL:String = Globals.SERVER_API_ROOT + SEARCH_GET + "/" + number.toString() + "/" + offset.toString();
			var callURL:String = Globals.SERVER_API_ROOT + NEW_SEARCH_GET + SEARCH_SUFFIX + searchString;
			trace("trying to get single string with " + callURL);
			var request:URLRequest = new URLRequest (callURL);
			request.method = URLRequestMethod.GET;
			var loader:URLLoader = new URLLoader (request); 
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, _onGetSearchComplete, false, 0, true); 
			//loader.dataFormat = URLLoaderDataFormat.VARIABLES; 
			loader.load(request); 
		}
		
		public function getTopVideos():void{
			//		var callURL:String = Globals.SERVER_API_ROOT + SEARCH_GET + "/" + number.toString() + "/" + offset.toString();
			var callURL:String = Globals.SERVER_API_ROOT + GET_TOP_TEN;
			trace("trying to get top videos with " + callURL);
			var request:URLRequest = new URLRequest (callURL);
			request.method = URLRequestMethod.GET;
			var loader:URLLoader = new URLLoader (request); 
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, _onGetSearchComplete, false, 0, true); 
			//loader.dataFormat = URLLoaderDataFormat.VARIABLES; 
			loader.load(request); 
		}
		
		public function _onGetSearchComplete(e:Event):void{
			// do you want to do something here?
			trace("GET VIDEOS SEARCH RESULT:");
			trace(e.target.data);
			
			// first, let's see if we got a successful return
			var status:String = com.adobe.serialization.json.JSON.decode(e.target.data).status;
			
			var getEvent:EventWithArgs;
			
			var returnArray:Array = new Array();
			
			if (status == "success"){
				// now get succeeded object
				var dataObject:Object = com.adobe.serialization.json.JSON.decode(e.target.data).data;
				var totalReturns:int = dataObject.total;
				var entries:Array = dataObject.entries;
				for (var i:int= 0; i<entries.length; i++){
					var vidEntry:Object = entries[i];
					var vidItem:VideoItem = new VideoItem();
					vidItem.id = vidEntry.id;
					vidItem.displayName = vidEntry.name;
					vidItem.thumbnail = vidEntry.image_path;
					vidItem.videoURL = vidEntry.video_path;
					vidItem.effect = vidEntry.effect;
					vidItem.origin = vidEntry.origin;
					vidItem.rating = vidEntry.rating;
					returnArray.push(vidItem);
					
					trace("added video with name " + vidItem.displayName + " to the queue");
				}
				
				
				getEvent = new EventWithArgs(ExpendableEvents.QUEUE_RETURN, false, false, {returnQueue:returnArray, searchReturn:true});
				dispatchEvent(getEvent);
				
			} else {
				
				getEvent = new EventWithArgs(ExpendableEvents.UNABLE_TO_COMPLY, false, false, null);
				dispatchEvent(getEvent);
			}
			
			
			//var resultEvent:EventWithArgs = new EventWithArgs(ExpendableEvents.VIDEO_SUBMITTED, false, false, null);
			//dispatchEvent(resultEvent);
		}
		
		private function createHash():String{
			var s:String = '';
			
			s += ExpendableUser.myName;
			s += ExpendableUser.myThumbnail;
			s += ExpendableUser.myVideo;
			
			s += 'expendable2salt'; // salt
			
			s = s.replace(/[^$a-z0-9_]/gi, ''); // remove weird chars
			s = MD5.hash(s);
			s = s.substring(5,15);
			
			/*
			var s:String = fb_id + "hamburgers";
			s.replace(/[^$a-z0-9_]/gi, '');
			s = MD5.hash(s);
			s = s.substring(5,15);
			*/
			return s;
		}
		
		private function createVoteHash(id:String, curRating:String):String{
			var s:String = '';
			
			s += id;
			s += curRating;
			
			s += 'expendable2salt'; // salt
			
			s = s.replace(/[^$a-z0-9_]/gi, ''); // remove weird chars
			s = MD5.hash(s);
			s = s.substring(5,15);
			
			/*
			var s:String = fb_id + "hamburgers";
			s.replace(/[^$a-z0-9_]/gi, '');
			s = MD5.hash(s);
			s = s.substring(5,15);
			*/
			return s;
		}
		
		
		
	}
}