﻿package com.davidcaneso.framework{	import com.asual.swfaddress.SWFAddress;	import com.asual.swfaddress.SWFAddressEvent;	import com.davidcaneso.collections.types.*;	import com.davidcaneso.events.framework.IntroEvent;	import com.davidcaneso.events.framework.SectionEvent;	import com.davidcaneso.events.framework.SiteManagerEvent;	import com.davidcaneso.events.framework.SleeperEvent;	import com.davidcaneso.loading.Preloader;	import com.davidcaneso.singletons.RuntimeAssets;	import com.davidcaneso.singletons.SiteEnvironment;	import com.davidcaneso.singletons.StageReference;	import com.davidcaneso.utils.LiveTrace;	import flash.display.DisplayObjectContainer;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;// imports	public class SiteManager extends MovieClip	{		//	properties		private 	var _siteState				:String;		private 	var _nextSectionNumber		:int;		private		var _activeSectionNumber	:int;				protected 	var _siteEnvironment		:SiteEnvironment;		protected	var _showTraces				:Boolean = false;		protected 	var _siteName				:String;		protected 	var _sectionRuntimeLoads	:Array;		protected 	var _sectionList			:Array;		protected 	var _introList				:Array;		protected 	var _preloader				:Preloader;		protected 	var _sectionHolder			:DisplayObjectContainer;		protected 	var _introHolder			:DisplayObjectContainer;		protected 	var _stateAfterSiteWakes	:String;		protected 	var _totalSections			:int;				public 		var globalType				:MovieClip;		public 		var initialBuild			:Boolean;		public 		var deeplinkDelimiter		:String 	= '-|-'	;		public 		var multistageDeeplinks		:Array;		public 		var dl						:String;		public 		var deeplink				:Deeplink;		public 		var useSWFAddress			:Boolean 	= false	;		public 		var blockSWFAddressEvent 	:Boolean;		public		var baseUrl					:String;						//	site states		public static const INITIAL_LOADING_STATE:String						= 'initialLoadState';		public static const INITIAL_ANIMATION_START:String						= 'initialAnimationStart';		public static const INITIAL_ANIMATION_STATE:String						= 'initialAnimationState';		public static const INITIAL_ANIMATION_COMPLETE_STATE:String				= 'initialAnimationCompleteState';				public static const INTRO_LOADING_STATE:String							= 'introLoadingState';		public static const INTRO_TRANS_IN_STATE:String							= 'introTransInState';		public static const INTRO_ACTIVE_STATE:String							= 'introActiveState';		public static const INTRO_TRANS_OUT_STATE:String						= 'introTransOutState';		public static const INTRO_TRANS_OUT_TO_LOADER_STATE:String				= 'introTransOutToLoaderState';		public static const INTRO_TRANS_OUT_COMPLETE_STATE:String				= 'introTransOutCompleteState';		public static const INTRO_TRANS_OUT_TO_LOADER_COMPLETE_STATE:String		= 'introTransOutToLoaderCompleteState';				public static const SECTION_LOADING_STATE:String						= 'sectionLoadingState';				public static const SECTION_TRANS_IN_STATE:String						= 'sectionTransInState';		public static const SECTION_ACTIVE_STATE:String							= 'sectionActiveState';		public static const SECTION_TRANS_OUT_STATE:String						= 'sectionTransOutState';				public static const SLEEP_STATE:String									= 'sleepSite';		public static const WAKE_STATE:String 									= 'wakeSite';				//	constructor		public function SiteManager():void		{			StageReference.instance.stage = stage;			_siteEnvironment = SiteEnvironment.instance;			_activeSectionNumber = -1;			_sectionList = new Array();			_introList = new Array();			multistageDeeplinks = new Array();			addEventListener(Event.ADDED_TO_STAGE, _init);		}				//	mandatory override methods		protected function initialSiteBuild(e:SiteManagerEvent):void		{			trace('initialSiteBuild');		}				protected function loadInitialFiles(e:Event = null):void{}				//	public methods		public function prepareNextSection(nextSectionNumber:int):void		{			_nextSectionNumber = nextSectionNumber;			var curState:String = _siteState;			if(curState == SECTION_LOADING_STATE || curState == INTRO_LOADING_STATE)			{				//stage.dispatchEvent(new SiteManagerEvent(SiteManagerEvent.STOP_CURRENT_LOAD, curState, _activeSectionNumber, nextSectionNumber))				_preloader.stopLoad();				_preloader.clearLoadStack();				try				{					Section(sectionHolder.getChildAt(0)).destroy();				}catch(e:Error){					trace('nothing to destroy in sectionHolder');				}				clearContainer(sectionHolder);				try{					SectionIntro(introHolder.getChildAt(0)).destroy();				}catch(e:Error){					trace('nothing to destroy in introHolder');				}				clearContainer(introHolder);			}						_preloader.clearLoadStack();						var runtimeAssets:Array = _sectionRuntimeLoads[_nextSectionNumber];			trace('_sectionRuntimeLoads: '+_sectionRuntimeLoads[_nextSectionNumber]);			var iLimit:int = runtimeAssets.length;						var fileName:String;			var targetName:String;			var container:Sprite;						for(var i:int = 0; i<iLimit; i++)			{				fileName = runtimeAssets[i][0];				targetName = runtimeAssets[i][1];				container = new Sprite();				container.visible = false;								RuntimeAssets.instance.addAsset(targetName, container);				_preloader.addToLoadStack(baseUrl + fileName, RuntimeAssets.instance.findAsset(targetName));			}						var sectionFile	:String = _sectionList[_nextSectionNumber];			var introFile	:String = _introList[_nextSectionNumber];						_preloader.addToLoadStack(baseUrl + sectionFile, _sectionHolder);						if( introFile != null )			{				if(introFile.length > 0)	_preloader.addToLoadStack(baseUrl + introFile, _introHolder);			}						trace('\n\n'+'load stack: '+_preloader.loadStack+'\n\n');						if (curState == SECTION_ACTIVE_STATE || curState == SECTION_TRANS_IN_STATE)            {				changeSiteState(SECTION_TRANS_OUT_STATE);			}            else if(curState == SECTION_TRANS_OUT_STATE)            {				trace('do nothing section is already animating out');			}            else if(curState == SECTION_LOADING_STATE || curState == INTRO_LOADING_STATE)            {				trace('site is loading content changing state to '+SECTION_LOADING_STATE);				changeSiteState(SECTION_LOADING_STATE);			}            else if(curState == INTRO_ACTIVE_STATE || curState == INTRO_TRANS_IN_STATE)            {				changeSiteState(INTRO_TRANS_OUT_TO_LOADER_STATE);			}            else if(curState == INTRO_TRANS_OUT_STATE)            {				trace('not sure this may be causing the error');				changeSiteState(SECTION_TRANS_OUT_STATE);			}		}				public function clearContainer(mc:DisplayObjectContainer):void		{			var target:DisplayObjectContainer = DisplayObjectContainer(mc);			var targetChildren:int = target.numChildren;						if( targetChildren > 0){				for(var i:int = 0; i < targetChildren; i++){					target.removeChildAt(0);				}			}		}				//	getters & setters		public function get sectionList():Array		{			return _sectionList;		}				protected function setSectionListAt(val:String, pos:int):void		{			if( !isNaN(pos) ){				_sectionList[pos] = val;			}else{				_sectionList.push( val );			}		}				public function get introList():Array		{			return _introList;		}				protected function setIntroListAt(val:String, pos:int):void		{			if( !isNaN(pos) ){				_introList[pos] = val;			}else{				_introList.push( val );			}			}				public function get totalSections():int		{			return _totalSections;		}				public function get siteState():String		{			return _siteState;		}				public function changeSiteState(val:String, supressEvent:Boolean = false):void		{			if(_siteState == SLEEP_STATE && val != WAKE_STATE)			{				trace('setting site state to '+val+' while site is in sleep state');				_changeStateAfterSiteWakes(val);				return;			}						//trace('changeSiteState current siteState = '+_siteState+ ' change to = '+val)						_siteState = val;			if(supressEvent) return;						trace('new siteState = '+val + ' active section = '+_activeSectionNumber+' next section = '+_nextSectionNumber);			stage.dispatchEvent(new SiteManagerEvent(SiteManagerEvent.SITE_STATE_UPDATE, _siteState, _activeSectionNumber, _nextSectionNumber));		}				public function get stateAfterSiteWakes():String		{			return _stateAfterSiteWakes;		}				public function set stateAfterSiteWakes(val:String):void		{			_changeStateAfterSiteWakes(val);		}				private function _changeStateAfterSiteWakes(val:String):void		{			var validatedState:String = val;			var currentState:String = _siteState;						//	check to see if the site loading anything			if(validatedState != SLEEP_STATE)			{				if(		currentState == INTRO_LOADING_STATE						|| currentState == SECTION_LOADING_STATE						|| currentState == INITIAL_LOADING_STATE				){					//	this keeps the loader from reanimating in when the site wakes.					validatedState = 'continueCurrentLoad';				}								_stateAfterSiteWakes = validatedState;			}						trace('set _stateAfterSiteWakes to '+_stateAfterSiteWakes);		}				public function get nextSectionNumber():int		{			return _nextSectionNumber;		}				public function set nextSectionNumber(val:int):void		{			_nextSectionNumber = val;		}				public function get activeSectionNumber():int		{			return _activeSectionNumber;		}				public function set activeSectionNumber(val:int):void		{			_activeSectionNumber = val;		}				public function get sectionHolder():DisplayObjectContainer		{			return _sectionHolder;		}				public function get introHolder():DisplayObjectContainer		{			return _introHolder;		}				//	development methods		public function output(val:*):void		{			LiveTrace.instance;			LiveTrace.output(val);		}				//	private methods		private function _init(e:Event):void		{			removeEventListener(Event.ADDED_TO_STAGE, _init);			stage.addEventListener(	SiteManagerEvent.INITIAL_ANIMATION_START,		initialSiteBuild																		);			stage.addEventListener(	SiteManagerEvent.INITIAL_ANIMATION_COMPLETE,	function(e:SiteManagerEvent):void{	changeSiteState(INITIAL_ANIMATION_COMPLETE_STATE);}	);			stage.addEventListener(	IntroEvent.TRANSITION_IN_COMPLETE,				function(e:IntroEvent):void{		changeSiteState(INTRO_ACTIVE_STATE);			}	);			stage.addEventListener(	IntroEvent.TRANSITION_OUT_START,				function(e:IntroEvent):void{		changeSiteState(INTRO_TRANS_OUT_STATE);			}	);			stage.addEventListener(	IntroEvent.TRANSITION_OUT_COMPLETE,				_enterSection																			);			stage.addEventListener(	IntroEvent.TRANSITION_OUT_TO_LOADER_COMPLETE,	_enterSection																			);			stage.addEventListener(	SectionEvent.TRANSITION_IN_COMPLETE,			function(e:SectionEvent):void{		changeSiteState(SECTION_ACTIVE_STATE);			}	);			stage.addEventListener(	SectionEvent.TRANSITION_OUT_COMPLETE,			_changeSection																			);			stage.addEventListener(	SleeperEvent.SLEEPER_ACTIVATED,					_sleepSite																				);			stage.addEventListener(	SleeperEvent.SLEEPER_DEACTIVATED,				_wakeSite																				);		}				private function _enterSection(e:Event):void		{			trace('hit enterSection in siteManager from event '+e.type);						//if(evt.type == INTRO_TRANS_OUT_TO_LOADER_COMPLETE_STATE){			if(e.type == IntroEvent.TRANSITION_OUT_TO_LOADER_COMPLETE)            {				trace('IntroEvent.TRANSITION_OUT_TO_LOADER_COMPLETE');                _changeSection(null);			}            else            {				changeSiteState(SECTION_TRANS_IN_STATE);			}		}				private function _changeSection(e:Event):void		{            trace(e.toString());			trace('hit changeSections in siteManager while site state is ', _siteState);			changeSiteState(SECTION_LOADING_STATE);		}				private function _sleepSite(e:Event):void		{			trace(e+'hit sleepSite in siteManager');			_changeStateAfterSiteWakes(_siteState);			changeSiteState(SLEEP_STATE);		}				private function _wakeSite(e:Event):void		{			trace('hit wakeSite in siteManager');			changeSiteState(WAKE_STATE);			changeSiteState(_stateAfterSiteWakes);		}				protected function addRuntimeAssetToLoad(file:String, target:String):void		{			var loadTargetName:String 				= target;			var loadTarget:DisplayObjectContainer	= DisplayObjectContainer(this[target]);						//trace('add '+file+' into section load');			var container:Sprite;						if(loadTarget == null)			{				//trace('create target for runtime asset named '+loadTargetName)				container = new Sprite();				container.visible = false;								RuntimeAssets.instance.addAsset(loadTargetName, container);				_preloader.addToLoadStack(baseUrl + file, RuntimeAssets.instance.findAsset(loadTargetName));				//assetManager.addImageAsset(loadTargetName, container)				//_preloader.addToLoadStack(baseUrl + file, assetManager.findAsset(loadTargetName))			}else{				//trace('use existing container '+loadTarget)				_preloader.addToLoadStack(baseUrl + file, loadTarget );			}		}				//	SWFAddress functions		protected function SWFAddressDeeplink(e:SWFAddressEvent):void		{			output('current SWFAddress value'+'\n'+SWFAddress.getValue());			SWFAddress.removeEventListener(SWFAddressEvent.INIT, SWFAddressDeeplink);						var curAddress:String = SWFAddress.getValue();			var validatedDeeplink:int = 0;						if(curAddress.substr(-1) == '/')	curAddress = curAddress.substr(0, curAddress.length - 1);						if(curAddress == '/' || curAddress == '' || curAddress == null)			{				if(dl != null && dl.length > 0){					validatedDeeplink = deeplink.findDeeplink(multistageDeeplinks[0]);				}			}else			{				validatedDeeplink = deeplink.findDeeplink(curAddress);			}			output('validatedDeeplink '+deeplink.getDeeplinkNameAt(validatedDeeplink));			updateSWFAddress(deeplink.getDeeplinkNameAt(validatedDeeplink));			_handleSWFAddress(null);			_readyAddressListener();		}				private function _readyAddressListener():void		{			output('readyAddressListener');			blockSWFAddressEvent = true;			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, _handleSWFAddress);		}				public function updateSWFAddress(val:String, noEvent:Boolean = false):void		{			output('hit updateSWFAddress');			//	TODO:			//	why would i ever need to block the swfAddress event			//	left over from previous version not sure if needed			if(noEvent){				//trace('do not dispatch SWFAddress CHANGE event')				output('blockSWFAddressEvent');				blockSWFAddressEvent = true;			}						output('\n'+'pre updateSWFAddress '+val);			SWFAddress.setValue(val);			output('\n'+'post updateSWFAddress '+SWFAddress.getValue());		}				private function _handleSWFAddress(e:SWFAddressEvent):void		{			output('_handleSWFAddress');			var pathNames:Array;			var title:String = _siteName;			output('blockSWFAddressEvent '+blockSWFAddressEvent);			if(blockSWFAddressEvent)			{				output('blockSWFAddressEvent');				blockSWFAddressEvent = false;				return;			}						if(e != null)			{				pathNames = e.pathNames;			}			else			{				pathNames = SWFAddress.getPathNames();			}			output('pathNames '+pathNames.toString());			for (var i:int = 0; i < pathNames.length; i++)			{				title += ' / ' + pathNames[i].substr(0,1).toUpperCase() + pathNames[i].substr(1);			}						SWFAddress.setTitle(title);			if(initialBuild)			{				output('initial build loadInitialFiles');				loadInitialFiles();			}			else			{				var curAddress:String = SWFAddress.getValue();				output('curAddress '+curAddress);				var validatedDeeplink:int = 0;								if(curAddress.substr(-1) == '/')				{					curAddress = curAddress.substr(0, curAddress.length - 1);				}				output('validate deeplink '+curAddress);				validatedDeeplink = deeplink.findDeeplink(curAddress);				output('validated deeplink '+validatedDeeplink);				prepareNextSection(validatedDeeplink);			}		}			}	}