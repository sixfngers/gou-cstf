﻿package com.site.ui{	import flash.display.*;	import flash.text.*;	import flash.events.*;	import flash.geom.Point;		import com.greensock.*	import com.greensock.easing.*		import com.davidcaneso.framework.Section;	import com.davidcaneso.framework.DevelopmentEnvironment	import com.davidcaneso.singletons.RuntimeAssets	import com.davidcaneso.singletons.Styling	import com.davidcaneso.singletons.XMLData	import com.davidcaneso.events.framework.DevelopmentEnvironmentEvent	import com.davidcaneso.events.framework.SiteManagerEvent;	import com.davidcaneso.events.framework.SectionEvent;	import com.davidcaneso.text.DynamicTextField;	import com.davidcaneso.framework.SimpleLink;	import com.davidcaneso.display.drawing.SquareArea;	import com.davidcaneso.display.buttons.BasicButton	import com.davidcaneso.display.buttons.LinkButton			public class BlankButton extends BasicButton	{		public function BlankButton()		{			super()						var _area = new SquareArea(100, 100)			_area.alpha = 0						addChild(_area)		}				public function enableButton():void		{			super.enable()		}				public function disableButton():void		{			super.disable()		}				override protected function buttonRollOver():void		{			dispatchEvent(new Event('blankButtonRollOver'))		}				override protected function buttonRollOut():void		{			dispatchEvent(new Event('blankButtonRollOut'))		}				override protected function buttonClick():void		{			dispatchEvent(new Event('blankButtonClick'))		}					}	}