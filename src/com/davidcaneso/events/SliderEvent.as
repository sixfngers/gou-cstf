﻿package com.davidcaneso.events{	import flash.events.Event;	public class SliderEvent extends Event	{		public static const DRAG_START:String = 'sliderDragStart';		public static const DRAG_UPDATE:String = 'sliderDragUpdate';		public static const DRAG_STOP:String = 'sliderDragStop';		public var percent:int;		public function SliderEvent(type:String,sliderPercent:int,bubbles:Boolean=false,cancelable:Boolean=false)		{			percent = sliderPercent;			super(type,bubbles,cancelable);		}		public override function clone():Event		{			return new SliderEvent(type,percent,bubbles,cancelable);		}		public override function toString():String		{			return formatToString('SliderEvent','type','percent','bubbles','cancelable','eventPhase');		}	}}