﻿package com.site.ui{		import flash.display.MovieClip;			public class IconRollOvers extends MovieClip	{						public function IconRollOvers()		{			// constructor code		}				public static function createIconRollOver(clipName:String):MovieClip		{			switch(clipName)			{				case 'RagnarFlame':					return new RagnarFlameRollOver();									case 'RagnarSpear':					return new RagnarSpearRollOver();														case 'RagnarRaven':					return new RagnarRavenRollOver();									default:					trace(clipName, 'could not be created an empty MovieClip will be returned to prevent errors')					return new MovieClip();			}		}			}	}