﻿package com.davidcaneso.utils{	import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.geom.Matrix;	import flash.geom.Point;	import flash.geom.Rectangle;	public class HitSpriteHelper	{		public static function makeHitSprite(displayObject:DisplayObject, alphaValue:Number = 0):Sprite		{			var hitSprite:Sprite = new Sprite();			var bounds:Rectangle = displayObject.getBounds(displayObject);			var bmp:BitmapData = new BitmapData(bounds.width, bounds.height,true,0x00000000);			bmp.draw(displayObject,new Matrix(1,0,0,1,-bounds.x,-bounds.y),null,null,null,false);			bmp.threshold(bmp,bmp.rect,new Point(), ">",0x00000000,0xffff6600,0xffffffff,false);			var colorData:Vector.<uint> = bmp.getVector(bmp.rect);			var len:uint = colorData.length;			hitSprite = new Sprite();			var bmpw:uint = bmp.width;			var lastPixelToDraw:Point = new Point(-1,-1);			hitSprite.graphics.lineStyle(1,0x00ff00);			for(var i:uint = 0; i<len; i = i + 1)			{				if(colorData[i] != 0 && i%bmpw != 0)				{					if(lastPixelToDraw.x == -1)					{						hitSprite.graphics.moveTo(i-(bmpw*int(i/bmpw)),i/bmpw);					}					lastPixelToDraw.x = i-(bmpw*int(i/bmpw));					lastPixelToDraw.y = int(i/bmpw);				}				else				{					if(lastPixelToDraw.x != -1)					{						hitSprite.graphics.lineTo(lastPixelToDraw.x,lastPixelToDraw.y);						lastPixelToDraw.x = lastPixelToDraw.y = -1;					}				}			}						hitSprite.x = bounds.x;			hitSprite.y = bounds.y;			hitSprite.alpha = alphaValue;						bmp.dispose();			bmp = null;			colorData = null;						return hitSprite;		}	}}