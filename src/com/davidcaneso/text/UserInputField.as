﻿package com.davidcaneso.text {	import com.davidcaneso.events.text.UserInputFieldEvent;	import flash.events.FocusEvent;	import flash.events.TextEvent;	import flash.text.TextFieldAutoSize;	import flash.text.TextFieldType;	public class UserInputField extends DynamicTextField	{		//properties		private var _htmlCapable:Boolean;		private var _defaultText:String;		private var _inFocus:Boolean;		//constructor		public function UserInputField(fieldWidth:int,fieldHeight:int,textFormatName: * =null,sizing:String=TextFieldAutoSize.LEFT,htmlCapable:Boolean=false,defaultText:String=''):void		{			//trace("creating UserInputField");			super(fieldWidth,fieldHeight,textFormatName,sizing);			this.type = TextFieldType.INPUT;			_htmlCapable = htmlCapable;			_defaultText = defaultText;			changeFieldValue(defaultText);			_inFocus = false;		}		//public methods		public function activateField(withInputEvents:Boolean=false):void		{			this.selectable = true;			this.tabEnabled = true;			this.addEventListener(FocusEvent.FOCUS_IN,_focusTextField);			this.addEventListener(FocusEvent.FOCUS_OUT,_unfocusTextField);			if (withInputEvents)			{				this.addEventListener(TextEvent.TEXT_INPUT,_handleTextInput);			}		}		public function deactivateField():void		{			this.selectable = false;			this.tabEnabled = false;			this.removeEventListener(FocusEvent.FOCUS_IN,_focusTextField);			this.removeEventListener(FocusEvent.FOCUS_OUT,_unfocusTextField);			if (this.hasEventListener(TextEvent.TEXT_INPUT))			{				this.removeEventListener(TextEvent.TEXT_INPUT,_handleTextInput);			}		}		public function destroy():void		{			//trace('destroy UserInputField');			deactivateField();		}		public function clearField():void		{			//trace("clear the text field");			changeFieldValue('');		}		public function isBlank(allowDefault:Boolean=false):Boolean		{			//trace("check if the field is blank");			var val:String = this.text;			if (!allowDefault)			{				if ((val == _defaultText))				{					return true;				}			}			var listLength:int = 0;			for (var i:int = 0; i < val.length; i++)			{				if (val.charAt(i) != ' ')				{					listLength++;				}			}			if(listLength < 1 || val.length < 1)				return true;			else				return false;		}		public function changeFieldValue(newText:String):void		{			if (_htmlCapable)			{				this.htmlText = newText;			}			else			{				this.text = newText;			}		}		//getters and setters		public function set defaultText(val:String):void		{			_defaultText = val;		}		public function get defaultText():String		{			return _defaultText;		}		public function get inFocus():Boolean		{			return _inFocus;		}		//private methods		private function _focusTextField(e:FocusEvent):void		{			//trace('user input field focus in');			_inFocus = true;			dispatchEvent(new UserInputFieldEvent(UserInputFieldEvent.FOCUS_CHANGE,this));		}		private function _unfocusTextField(e:FocusEvent):void		{			//trace('user input field focus out');			_inFocus = false;			dispatchEvent(new UserInputFieldEvent(UserInputFieldEvent.FOCUS_CHANGE,this));		}		private function _handleTextInput(e:TextEvent):void		{			dispatchEvent(new UserInputFieldEvent(UserInputFieldEvent.VALUE_CHANGE,this));		}	}}