﻿package com.davidcaneso.display.drawing{	import flash.display.Sprite;		public class SquareDualGradient extends Sprite	{		private var _area:Sprite;				public function SquareDualGradient(w:int, h:int, topGradientPercent:uint = 20, bottomGradientPercent:uint = 20, gradientColor:uint = 0xff0000):void		{			var gradient0Height:uint = uint(h * (topGradientPercent * .01));			var solidHeight:uint = uint(h - (h * ((topGradientPercent + bottomGradientPercent) * .01)));			var gradient1Height:uint = uint(h * (bottomGradientPercent * .01));						trace(gradient0Height, solidHeight, gradient1Height);						_area = new Sprite();						var gradient0:SquareGradient = new SquareGradient(w, gradient0Height, gradientColor, 0, gradientColor, 1);			_area.addChild(gradient0);						var solid:SquareArea = new SquareArea(w, solidHeight, gradientColor, false);			solid.y = gradient0Height;			_area.addChild(solid);						var gradient1:SquareGradient = new SquareGradient(w, gradient1Height, gradientColor, 1, gradientColor, 0);			gradient1.y =  gradient0Height + solidHeight;			_area.addChild(gradient1);						addChild(_area);		}		public function get area():Sprite		{			return _area;		}	}}