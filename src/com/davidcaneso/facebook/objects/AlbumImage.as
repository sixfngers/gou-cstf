﻿package com.davidcaneso.facebook.objects {		public class AlbumImage extends GraphObject	{		private var _id				:String;		private var _thumbUrl		:String;		private var _sourceUrl		:String;						public function AlbumImage(data:Object):void		{			_id 		= data.id;			_thumbUrl	= data.picture;			_sourceUrl	= data.source;		}				public function get id():String			{ return _id;		}		public function get thumbUrl():String	{ return _thumbUrl;	}		public function get sourceUrl():String	{ return _sourceUrl;}	}}