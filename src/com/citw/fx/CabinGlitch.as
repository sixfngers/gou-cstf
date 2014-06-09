﻿package com.citw.fx {	import flash.display.BitmapData;	import flash.geom.Rectangle;	import flash.geom.Point;	import flash.display.Bitmap;	import flash.display.BitmapDataChannel;	import flash.filters.BlurFilter;	import flash.geom.Matrix;	import com.greensock.*;	import flash.display.MovieClip;	import flash.events.Event;		public class CabinGlitch {		public function CabinGlitch() {			// constructor code		}				public static function go(target) {			var scale = 1;			var density = new Point(1, 0.5);			var bmd = new BitmapData(target.width*scale, target.height*scale);			var noise = new BitmapData(bmd.width, bmd.height, false);			noise.noise(1);			var matrix = new Matrix();			matrix.scale(scale, scale);			bmd.draw(target, matrix);			var iterations = 5;			var blurAmp = 4;						var bmd0 = new BitmapData(bmd.width, bmd.height);						var channels = new Array();			channels = [BitmapDataChannel.RED, BitmapDataChannel.GREEN];						for(var i=0; i<iterations; i++) {				var rect = new Rectangle(0, Math.random()*bmd.height, bmd.width, Math.random()*bmd.height*density.y);				var channel = channels[Math.floor(Math.random()*channels.length)];								var p = new Point(Math.random()*bmd.width-bmd.width*0.5, rect.y);				bmd0.copyChannel(bmd, rect, p, BitmapDataChannel.RED, channel);				bmd0.copyChannel(bmd, rect, p, BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);			}						var bm = new Bitmap(bmd0);			bm.scaleX = bm.scaleY = scale;						bm.alpha = 0.75;						bm.blendMode = "multiply";						return bm;		}				public static function run(target, delay=0.5) {			var container = new MovieClip();			container.ref = target;			target.addChild(container);			container.addEventListener(Event.ENTER_FRAME, CabinGlitch.render);						TweenMax.delayedCall(delay, function() {				container.removeEventListener(Event.ENTER_FRAME, CabinGlitch.render);				target.removeChild(container);								 });		}				public static function render(e=null) {			if(e.target.numChildren>0) {				e.target.removeChild(e.target.getChildAt(0));			}			e.target.addChild(CabinGlitch.go(e.target.ref));		}	}	}