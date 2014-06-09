﻿package com.davidcaneso.display.drawing{	import flash.display.Sprite;	import flash.geom.Matrix;		public class SquareGradient extends Sprite	{		private var _area:Sprite;				public function SquareGradient(w:int, h:int, startColor:uint = 0xff0000, startColorAlpha:uint = 1, endColor:uint = 0xff0000, endColorAlpha:uint = 0):void		{			var matrix:Matrix = new Matrix();				matrix.createGradientBox(w, h, Math.PI * 0.5);						_area = new Sprite();			_area.graphics.beginGradientFill('linear', [ startColor, endColor ], [ startColorAlpha, endColorAlpha ], [ 0, 255 ], matrix );			_area.graphics.drawRect(0, 0, w, h);			_area.graphics.endFill();						addChild(_area);		}		public function get area():Sprite		{			return _area;		}	}}