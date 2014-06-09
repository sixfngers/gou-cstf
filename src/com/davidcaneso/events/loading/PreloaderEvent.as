﻿package com.davidcaneso.events.loading{	import flash.display.DisplayObject;	import flash.events.Event;	import flash.display.LoaderInfo;	public class PreloaderEvent extends Event	{		public static const START:String = 'loadStart';		public static const FILE_CHANGE:String = 'loadFileChange';		public static const UPDATE:String = 'loadUpdate';		public static const COMPLETE:String = 'loadComplete';		public static const ERROR:String = 'loadError';		public var percent:int;		public var file:String;		public var loadTarget:DisplayObject;		public var loaderInfo:LoaderInfo;		public function PreloaderEvent(type:String,p_percent:int,p_file:String,p_target:DisplayObject,p_loaderInfo:LoaderInfo=null,bubbles:Boolean=false,cancelable:Boolean=false)		{			super(type,bubbles,cancelable);			percent = p_percent;			file = p_file;			loadTarget = p_target;			loaderInfo = p_loaderInfo;		}		public override function clone():Event		{			return new PreloaderEvent(type,percent,file,loadTarget,loaderInfo,bubbles,cancelable);		}		public override function toString():String		{			return formatToString('PreloaderEvent','percent','file','loadTarget','loaderInfo','type','bubbles','cancelable','eventPhase');		}	}}