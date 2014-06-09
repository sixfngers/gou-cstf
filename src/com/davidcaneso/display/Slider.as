﻿package com.davidcaneso.display{	import com.davidcaneso.events.SliderEvent;	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.display.Stage;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.geom.Rectangle;	import flash.utils.Timer;	public class Slider extends Sprite	{		public static const ORIENTATION:Array = ["horizontal","vertical"];		//properties		protected var _handle:DisplayObject;		protected var _track:DisplayObject;		protected var _orientation:String;		protected var _trackSize:Number;		private var _stage:Stage;		private var _bounds:Rectangle;		private var _percent:Number;		private var _isDragging:Boolean;		private var _interval:Timer;		private var _precise:Boolean;		private var _frequency:int = 100;		//---------------------------------		//constructor		//---------------------------------		public function Slider(handle:DisplayObject,track:DisplayObject,stage:Stage,trackSize:int,orientation:String='horizontal',precise:Boolean=false)		{			_handle = handle;			_track = track;			_stage = stage;			_isDragging = false;			_orientation = orientation;			_precise = precise;			_percent = 0;			_interval = new Timer(_frequency,0);			_interval.addEventListener(TimerEvent.TIMER,_update);			_trackSize = trackSize;			if ((_orientation == ORIENTATION[0]))			{				_bounds = new Rectangle(0,0,_trackSize,0);			}			else			{				_bounds = new Rectangle(0,0,0,_trackSize);			}			Sprite(_handle).buttonMode = true;			Sprite(_handle).addEventListener(MouseEvent.MOUSE_DOWN,_drag);			addChild(_track);			addChild(_handle);		}		//---------------------------------		//public methods		//---------------------------------		public function moveHandleToPercent(number:Number,updateAfter:Boolean):void		{			var pct:Number;			if ((number <= 0))			{				pct = 0;			}			else if ((number >= 100))			{				pct = 100;			}			else			{				pct = number;			}			var pos:Number;			if (_precise)			{				pos = _trackSize * (pct / 100);			}			else			{				pos = int((_trackSize * (pct / 100)));			}			switch (_orientation)			{				case ORIENTATION[0] :					_handle.x = _track.x + pos;					break;				case ORIENTATION[1] :					_handle.y = _track.y + pos;					break;			}			if (updateAfter)			{				_drop(null);			}		}		public function changeTrackSize(val:int):void		{			_trackSize = val;			if ((_orientation == ORIENTATION[0]))			{				_bounds = new Rectangle(0,0,_trackSize,0);			}			else			{				_bounds = new Rectangle(0,0,0,_trackSize);			}		}		public function destroy():void		{			//stop all timers and remove all event listeners			_interval.removeEventListener(TimerEvent.TIMER,_update);			Sprite(_handle).buttonMode = false;			Sprite(_handle).removeEventListener(MouseEvent.MOUSE_DOWN,_drag);			Sprite(_handle).removeEventListener(MouseEvent.MOUSE_UP,_drop);			_stage.removeEventListener(MouseEvent.MOUSE_UP,_drop);			_interval.stop();		}		//---------------------------------		//getters & setters		//---------------------------------		public function get orientation():String		{			var validated:String;			if ((_orientation == ORIENTATION[0]))			{				validated = _orientation;			}			else if ((_orientation == ORIENTATION[1]))			{				validated = _orientation;			}			return validated;		}		public function get percent():Number		{			return _percent;		}		public function set frequency(milliseconds:int):void		{			if ((milliseconds <= 0))			{				_frequency = 100;			}			else			{				_frequency = milliseconds;			}		}		public function get frequency():int		{			return _frequency;		}		//---------------------------------		//private methods		//---------------------------------		protected function _drag(event:MouseEvent):void		{			Sprite(_handle).startDrag(false,_bounds);			Stage(_stage).addEventListener(MouseEvent.MOUSE_UP,_drop);			Sprite(_handle).addEventListener(MouseEvent.MOUSE_UP,_drop);			_interval.start();			_isDragging = true;			dispatchEvent(new SliderEvent(SliderEvent.DRAG_START,_percent));			_update(null);		}		protected function _drop(event:MouseEvent):void		{			Sprite(_handle).stopDrag();			Stage(_stage).removeEventListener(MouseEvent.MOUSE_UP,_drop);			Sprite(_handle).removeEventListener(MouseEvent.MOUSE_UP,_drop);			_isDragging = false;			_interval.stop();			_update(null);			dispatchEvent(new SliderEvent(SliderEvent.DRAG_STOP,_percent));		}		private function _update(event:TimerEvent):void		{			if ((_orientation == ORIENTATION[0]))			{				if (_precise)				{					_percent = Number(Sprite(_handle).x / _trackSize * 100);				}				else				{					_percent = int(Sprite(_handle).x / _trackSize * 100);				}			}			else			{				if (_precise)				{					_percent = Number(Sprite(_handle).y / _trackSize * 100);				}				else				{					_percent = int(Sprite(_handle).y / _trackSize * 100);				}			}			dispatchEvent(new SliderEvent(SliderEvent.DRAG_UPDATE,_percent));		}	}}