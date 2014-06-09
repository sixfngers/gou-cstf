﻿package com.davidcaneso.facebook.objects{	import com.adobe.serialization.json.JSON;	import com.davidcaneso.facebook.FBConnect;	import com.davidcaneso.facebook.GraphConstants;	import com.davidcaneso.facebook.GraphRequest;	import com.davidcaneso.facebook.events.GraphEvent;	import com.davidcaneso.utils.LiveTrace;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.net.URLLoader;	import flash.net.URLLoaderDataFormat;	import flash.net.URLRequest;	import flash.net.URLRequestMethod;	import flash.net.URLVariables;	public class User extends GraphObject	{		private var _uid					:String;		private var _username				:String;		private var _profileImageUrl		:String;		private var _userInfo				:Object;		private var _albumInfo				:Object;		private var _albums					:Array;		private var _appAlbumId				:String;				public function User():void		{			super();			clearUserData();			_albums = new Array();		}				public function clearUserData():void		{			_uid 				= '';			_username 			= '';			_profileImageUrl 	= '';			_userInfo			= null;			_albumInfo 			= null;			_appAlbumId 		= '';		}				public function loadInfo(uid:String = '', useSecure:Boolean = false):void		{			var userId:String;						if(uid.length > 0) 	userId = uid;			else				userId = _uid;						LiveTrace.output('User loadInfo '+uid);						var request:GraphRequest = new GraphRequest();			request.addEventListener(GraphEvent.REQUEST_READY, _loadInfoComplete);			var url:String = GraphConstants.BASE_HTTP + userId;			if(useSecure) url = GraphConstants.BASE_HTTPS + userId + GraphConstants.ACCESS_TOKEN + FBConnect.instance.session.access_token;			request.load(url);			//request.load(GraphConstants.BASE_HTTPS + userId + GraphConstants.ACCESS_TOKEN + FBConnect.instance.session.access_token);		}				public function loadAlbumInfo(limit:int = 0):void		{			LiveTrace.output('User:: loadAlbumInfo');			var token:String= FBConnect.instance.session.access_token;			var request:GraphRequest = new GraphRequest();			request.addEventListener(GraphEvent.REQUEST_READY, _loadAlbumInfoComplete);			var limitParam:String = '';			if(limit > 0)				limitParam = GraphConstants.LIMIT+limit;			request.load(GraphConstants.BASE_HTTPS + GraphConstants.ME + GraphConstants.ALBUMS + GraphConstants.ACCESS_TOKEN + token+limitParam);		}				public function loadUserImage():void		{			var request:GraphRequest = new GraphRequest();						request.addEventListener(GraphEvent.REQUEST_READY, _loadUserImageComplete);			request.load(GraphConstants.BASE_HTTP + _uid + GraphConstants.PICTURE);		}				public function createAlbum(albumName:String = '', albumDescription:String = ''):void		{			LiveTrace.output('User :: createAlbum');			/*			var vars:URLVariables = new URLVariables();				vars.name = albumName;				vars.message = albumDescription;						var token:String= FBConnect.instance.session.access_token			var request:GraphRequest = new GraphRequest();				request.data = vars				request.addEventListener(GraphEvent.REQUEST_READY, _albumCreated);				request.load(GraphConstants.BASE_HTTPS + _uid + GraphConstants.ALBUMS + GraphConstants.ACCESS_TOKEN + token);							*/			var token:String= FBConnect.instance.session.access_token;						var vars:URLVariables = new URLVariables();				vars.name = albumName;				vars.message = albumDescription;						var request:URLRequest = new URLRequest();				request.method = URLRequestMethod.POST;				request.data = vars;				request.url = GraphConstants.BASE_HTTPS + GraphConstants.ME + GraphConstants.ALBUMS + GraphConstants.ACCESS_TOKEN + token;						var loader:URLLoader = new URLLoader();				loader.dataFormat = URLLoaderDataFormat.TEXT;				loader.addEventListener(Event.COMPLETE, _appAlbumCreated);				loader.addEventListener(IOErrorEvent.IO_ERROR, _appAlbumCreatedError);				loader.load(request);		}				public function get uid()				:String { return _uid; 				}		public function get username()			:String { return _username; 		}		public function get profileImageUrl()	:String	{ return _profileImageUrl;	}		public function get userInfo()			:Object { return _userInfo;			}		public function get albumInfo()			:Object { return _albumInfo;		}		public function get appAlbumId()		:String { return _appAlbumId;		}		public function get albums()			:Array	{ return _albums;			}						///////////////////////////		//    Private Methods    //		///////////////////////////		private function _loadInfoComplete(e:GraphEvent):void		{			LiveTrace.output('User :: _loadInfoComplete '+e.data);			LiveTrace.outputObject(e.data, 'Loaded User Info');			GraphRequest(e.target).removeEventListener(GraphEvent.REQUEST_READY, _loadInfoComplete);									_userInfo 			= e.data;			_uid 				= _userInfo.id;			_username 			= _userInfo.name;			_profileImageUrl 	= GraphConstants.BASE_HTTP + _uid + GraphConstants.PICTURE;						dispatchEvent(new GraphEvent(GraphEvent.USER_INFO_READY));		}				private function _loadUserImageComplete(e:GraphEvent):void		{			LiveTrace.output('User :: _loadUserImageComplete');			GraphRequest(e.target).removeEventListener(GraphEvent.REQUEST_READY, _loadUserImageComplete);						//_profileImageUrl 	= e.data						dispatchEvent(new GraphEvent(GraphEvent.USER_IMAGE_READY));		}				private function _appAlbumCreated(e:Event):void		{			LiveTrace.output('User :: _appAlbumCreated');			URLLoader(e.target).removeEventListener(Event.COMPLETE, _appAlbumCreated);			URLLoader(e.target).removeEventListener(IOErrorEvent.IO_ERROR, _appAlbumCreatedError);						_appAlbumId = JSON.decode(e.target.data).id;						LiveTrace.output('_appAlbumId: '+_appAlbumId);			dispatchEvent(new GraphEvent(GraphEvent.APP_ALBUM_CREATED));		}				private function _appAlbumCreatedError(e:IOErrorEvent):void		{			LiveTrace.output('User :: _appAlbumCreatedError');			URLLoader(e.target).removeEventListener(Event.COMPLETE, _appAlbumCreated);			URLLoader(e.target).removeEventListener(IOErrorEvent.IO_ERROR, _appAlbumCreatedError);			dispatchEvent(new GraphEvent(GraphEvent.APP_ALBUM_CREATED_ERROR));		}				private function _loadAlbumInfoComplete(e:GraphEvent):void		{			LiveTrace.output('User :: _loadAlbumInfoComplete');			GraphRequest(e.target).removeEventListener(GraphEvent.REQUEST_READY, _loadAlbumInfoComplete);			_albumInfo = e.data.data;						var iLimit:int = _albumInfo.length;			for(var i:int = 0; i<iLimit; i++)			{				if(int(_albumInfo[i].count) > 0 )				{					_albums.push(	new Album(_albumInfo[i].id, _albumInfo[i].name, _albumInfo[i].cover_photo, _albumInfo[i].count)	);					LiveTrace.output('next album info');					LiveTrace.output('album '+_albumInfo[i].count+' '+_albumInfo[i].id+' '+_albumInfo[i].name+' '+_albumInfo[i].cover_photo);				}			}						dispatchEvent(new GraphEvent(GraphEvent.ALBUM_INFO_READY));		}			}}