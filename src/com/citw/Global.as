﻿package com.citw {		public class Global {		public function Global() {			// constructor code		}				public static var xml;		public static var percentLoaded;		public static var container;		public static var currentSectionNumber;		public static var intro = true;		public static var percentLoadedTemp;				public static var videoContainer;				public static var dl;				public static var footer;				public static function getY() {			if(!container.hasOwnProperty("stage")) return;			var y = (container.stage.stageHeight-870)*0.5;			y *= 0.7;			if(y < 0) y = 0;			return y;		}	}	}