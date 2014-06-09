﻿package com.davidcaneso.framework {	import com.davidcaneso.events.framework.DevelopmentEnvironmentEvent;	import com.davidcaneso.events.framework.SiteManagerEvent;	import com.davidcaneso.singletons.StageReference;	public class ActiveSiteElement extends InactiveSiteElement	{		//	properties        protected	var _devConfigFile			:String;		protected	var _devSectionNumber		:int;		protected 	var _devSetupType			:String;		private		var _developmentEnvironment	:DevelopmentEnvironment;						//	constructor		public function ActiveSiteElement():void		{			super();			_devSectionNumber 	= -1;			_devSetupType 		= DevelopmentEnvironment.INITIAL_EVENT_TYPES;		}				override protected function init():void		{			super.init();			if(_dev){				//	create the development environment				_developmentEnvironment = new DevelopmentEnvironment(_devConfigFile, _devSetupType, _devSectionNumber, _showTraces);				_developmentEnvironment.addEventListener(DevelopmentEnvironmentEvent.SETUP_COMPLETE, devSetupComplete);				_developmentEnvironment.classTrace('create development environment');				addChild(_developmentEnvironment);			}else{				//	element is inside the shell				trace(_className+' setup');                StageReference.instance.stage.addEventListener(SiteManagerEvent.SITE_STATE_UPDATE, handleSiteStateUpdate);                setup();			}					}				//	mandatory override methods		protected function setup():void{}		override public function destroy():void		{            classTrace('destroy', _className);            StageReference.instance.stage.removeEventListener(SiteManagerEvent.SITE_STATE_UPDATE, handleSiteStateUpdate);			_devConfigFile 			= null;			_devSetupType			= null;			_developmentEnvironment = null;			super.destroy();		}				protected function sleep():void		{					}				protected function wake():void		{					}				protected function handleSiteStateUpdate(e:SiteManagerEvent):void		{			switch(e.siteState)			{				case SiteManager.SLEEP_STATE:					sleep();					break;					case SiteManager.WAKE_STATE:					wake();					break;			}		}				//	development methods		protected function devSetupComplete(e:DevelopmentEnvironmentEvent):void		{			classTrace('_devSetupComplete');			StageReference.instance.stage = stage;			_developmentEnvironment.removeEventListener(DevelopmentEnvironmentEvent.SETUP_COMPLETE, devSetupComplete);			_top = _developmentEnvironment;			setup();		}				protected function hideDelevelopmentEnvironment():void		{			_developmentEnvironment.visible = false;		}					}	}