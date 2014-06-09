﻿package com.davidcaneso.facebook.auth{	import com.davidcaneso.facebook.events.GraphEvent;	import com.davidcaneso.utils.LiveTrace;	import flash.events.EventDispatcher;	import flash.external.ExternalInterface;	/*	 *	 * ...	 * @author Brian Hodge	 */	public class FacebookOAuth2 extends EventDispatcher	{		private var _session:Session;		private var _loggedIn:Boolean;				public function FacebookOAuth2():void		{			_loggedIn = false;						if (ExternalInterface.available)			{				//				ExternalInterface.addCallback("handleConnectedUser", _onConnectedUser);				ExternalInterface.addCallback("handleUnconnectedUser", _onUnconnectedUser);			}		}				public  function init():void		{			if(ExternalInterface.available) ExternalInterface.call("com.davidcaneso.facebookgraph.oauth2.init");		}				public function login(pPermissions:Object):void 		{ 			dispatchEvent(new GraphEvent(GraphEvent.LOGIN_WINDOW_OPEN));			if(ExternalInterface.available) ExternalInterface.call("com.davidcaneso.facebookgraph.oauth2.login", pPermissions);		}		public function logout():void		{			ExternalInterface.call("com.davidcaneso.facebookgraph.oauth2.logout");		}				//Getters		//*******		public function get session():Session	{return _session; 	}		public function get loggedIn():Boolean	{return _loggedIn;	}				//Private Methods		//***************				private function _onConnectedUser(pSession:Object):void		{			LiveTrace.output('FacebookOAuth2 _onConnectedUser_loggedIn :'+_loggedIn);			LiveTrace.output('FacebookOAuth2 _onConnectedUser _session:'+ _session);						_loggedIn = true;			_session = new Session(pSession);						//LiveTrace.output('FacebookOAuth2 _onConnectedUser_loggedIn :'+_loggedIn)			//LiveTrace.output('FacebookOAuth2 _onConnectedUser _session:'+ _session)						//dispatchEvent(new GraphEvent(GraphEvent.USER_TEST_COMPLETE));			//dispatchEvent(new GraphEvent(GraphEvent.LOGGED_IN));			connectedUserTestComplete();		}				private function _onUnconnectedUser():void		{			//dispatchEvent(new GraphEvent(GraphEvent.USER_TEST_COMPLETE));			connectedUserTestComplete();		}				private function connectedUserTestComplete():void		{			if (ExternalInterface.available)			{				ExternalInterface.addCallback("handleOAuth2Login", _onOAuth2Login);				ExternalInterface.addCallback("handleOAuth2Logout", _onOAuth2Logout);			}						dispatchEvent(new GraphEvent(GraphEvent.USER_TEST_COMPLETE));		}				private function _onOAuth2Login(pSession:Object):void		{			LiveTrace.output('FacebookOAuth2 _onOAuth2Login _loggedIn :'+_loggedIn);			LiveTrace.output('FacebookOAuth2 _onOAuth2Login _session:'+ _session);						_loggedIn = true;			_session = new Session(pSession);						LiveTrace.output('FacebookOAuth2 _onOAuth2Login _loggedIn :'+_loggedIn);			LiveTrace.output('FacebookOAuth2 _onOAuth2Login _session:'+ _session);						dispatchEvent(new GraphEvent(GraphEvent.LOGIN_WINDOW_CLOSED));			dispatchEvent(new GraphEvent(GraphEvent.LOGGED_IN));		}				private function _onOAuth2Logout():void		{			_loggedIn = false;						if(_session != null)			{				_session.endSession();				_session = null;			}						LiveTrace.output('FacebookOAuth2 _loggedIn :'+_loggedIn);			LiveTrace.output('FacebookOAuth2 _onOAuth2Logout _session :'+_session);						dispatchEvent(new GraphEvent(GraphEvent.LOGIN_WINDOW_CLOSED));				dispatchEvent(new GraphEvent(GraphEvent.LOGGED_OUT));		}	}}