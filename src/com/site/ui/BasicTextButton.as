﻿package com.site.ui{	import flash.display.*;	import flash.text.*;	import flash.events.*;	import flash.geom.Point;		import com.greensock.*	import com.greensock.easing.*		import com.davidcaneso.framework.Section;	import com.davidcaneso.framework.DevelopmentEnvironment	import com.davidcaneso.singletons.RuntimeAssets	import com.davidcaneso.singletons.Styling	import com.davidcaneso.singletons.XMLData	import com.davidcaneso.events.framework.DevelopmentEnvironmentEvent	import com.davidcaneso.events.framework.SiteManagerEvent;	import com.davidcaneso.events.framework.SectionEvent;	import com.davidcaneso.text.DynamicTextField;	import com.davidcaneso.framework.SimpleLink;	import com.davidcaneso.display.drawing.SquareArea;	import com.davidcaneso.display.buttons.BasicButton	import com.davidcaneso.display.buttons.LinkButton			public class BasicTextButton extends BasicButton	{		protected var _tf:DynamicTextField		protected var _bg:SquareArea		protected var _icon:MovieClip				public function BasicTextButton(text:String, format:TextFormat, bgColor:Number)		{			super()						_tf = new DynamicTextField(10, 10, buttonTextFormat);			_tf.multiline = false			_tf.autoSize = TextFieldAutoSize.LEFT;			_tf.text = buttonText;						_bg = new SquareArea(_tf.width + (70 * 2), _tf.height, bgColor, false);						_tf.y = int((_bg.height - _tf.height) * .5);						RuntimeAssets.instance.displayAssetNames();						addChild(_bg);			addChild(_tf);		}				public function get bg():MovieClip		{			return _bg;		}				public function get tf():MovieClip		{			return _tf;		}				public function enableButton():void		{			super.enable()		}				public function disableButton():void		{			super.disable()		}				override protected function buttonRollOver():void		{			dispatchEvent(new Event('BasicTextButtonRollOver'))		}				override protected function buttonRollOut():void		{			dispatchEvent(new Event('BasicTextButtonRollOut'))		}				override protected function buttonClick():void		{			dispatchEvent(new Event('BasicTextButtonClick'))		}					}	}