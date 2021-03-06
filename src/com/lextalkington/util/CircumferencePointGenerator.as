/**
*	Author: Lex Talkington Design, Inc
*	November 12, 2009
*	http://www.lextalkington.com/blog
*
*	VERSION 1.0;
*
*	Copyright (c) 2009 Lex Talkington and Lex Talkington Design, Inc.
*
*	Permission is hereby granted, free of charge, to any person obtaining a copy
*	of this software and associated documentation files (the "Software"), to deal
*	in the Software without restriction, including without limitation the rights
*	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*	copies of the Software, and to permit persons to whom the Software is
*	furnished to do so, subject to the following conditions:
*
*	The above copyright notice and this permission notice shall be included in
*	all copies or substantial portions of the Software.
*
*	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*	THE SOFTWARE.
*
*
*	*/

/**
*	EXAMPLE:
*	import com.lextalkington.util.CircumferencePointGenerator;
*
*	// create a circle to place the points around
*	var _target:Shape = new Shape();
*	with(_target.graphics) {
*		beginFill(0x666666);
*		drawCircle(0,0,100);
*		endFill();
*	}
*	_target.x = stage.stageWidth/2;
*	_target.y = stage.stageHeight/2;
*	addChild(_target);
*
*	// change this to vary number of points around the circle
*	var totalPts:int = 13;
*	// change this to vary the angle that the point generator initially starts from
*	var startAng:int = 270;
*	// change this to place points along an arc vs. evenly distributing them around the circle
*	var distributionRange:int = 360;
*	// change this to change the direction of the points are oriented, options are COUNTERCLOCKWISE, and CLOCKWISE - CLOCKWISE is the default
*	var ptDirection:String = CircumferencePointGenerator.COUNTERCLOCKWISE;
*	// execute the points based on the above variables, this returns an array of points
*	//var pts:Array = CircumferencePointGenerator.getPoints(_target.x, _target.y, _target.width/2, totalPts, startAng, distributionRange, ptDirection);
*	var pts:Array = [];
*	pts = pts.concat(CircumferencePointGenerator.getPoints(_target.x, _target.y, _target.width/2, totalPts, startAng, distributionRange, ptDirection));
*	// this will trace all the point objects generated around the perimeter of your circular object
*	tracer(pts);
*
*	*/

package com.lextalkington.util {

	/**
	 *	creates an array of points around a defined circle
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Lex Talkington
	 *	@since  11.12.2009
	 */

	import flash.geom.Point;

	public class CircumferencePointGenerator
	{

		/** Distribute the points clockwise around the circle. */
		public static const CLOCKWISE:String = "clockwise";
		/** Distribute the points counterclockwise around the circle. */
		public static const COUNTERCLOCKWISE:String = "counterclockwise";

		/**
		*	This method accepts arguments based on the size and position of your circle
		*	along with the amount of points to distribute around the circle,
		*	what angle to start the first point, which direction to plot the points,
		*	how much of the circumference to use for the distribution, and which direction
		*	around the circle to plot the points.
		*
		*	@param centerx The center x position of the circle to place the points around.
		*	@param centery The center y position of the circle to place the points around.
		*	@param radi The radius of the circle to distribute the points around.
		*	@param total The total amount of point to distribute around the circle.
		*	@param startangle [Optional] The starting angle of the first point. This is based on the 0-360 range.
		*	@param arc [Optional] The length of distribution around the circle to evenly distribute the points. This is based on 0-360.
		*	@param dir [Optional] This determines the direction that the points will distribute around the circle.
		*	@param evenDist [Optional] If set to true, AND if you're arc angle is less than 360, this will evently distribute the points around the circle.<br/>If set to true, the points are visually arranged in this manner POINT-SPACE-POINT-SPACE-POINT,<br/>if set to false, an extra space will be added after the last point: POINT-SPACE-POINT-SPACE-POINT-SPACE
		*
		*	@return Returns an <code>Array</code> containing <code>Points</code>.
		*
		*	@example
		*	<p><code>import com.lextalkington.util.CircumferencePointGenerator;<br/><br/>
		*
		*	// create a circle to place the points around<br/>
		*	var _target:Shape = new Shape();<br/>
		*	with(_target.graphics) {<br/>
		*	&nbsp;&nbsp;&nbsp;&nbsp;beginFill(0x666666);<br/>
		*	&nbsp;&nbsp;&nbsp;&nbsp;drawCircle(0,0,100);<br/>
		*	&nbsp;&nbsp;&nbsp;&nbsp;endFill();<br/>
		*	}<br/>
		*	_target.x = stage.stageWidth/2;<br/>
		*	_target.y = stage.stageHeight/2;<br/>
		*	addChild(_target);<br/><br/>
		*
		*	// change this to vary number of points around the circle<br/>
		*	var totalPts:int = 13;<br/><br/>
		*	// change this to vary the angle that the point generator initially starts from<br/>
		*	var startAng:int = 270;<br/><br/>
		*	// change this to place points along an arc vs. evenly distributing them around the circle<br/>
		*	var distributionRange:int = 360;<br/><br/>
		*	// change this to change the direction of the points are oriented, options are COUNTERCLOCKWISE, and CLOCKWISE - CLOCKWISE is the default<br/>
		*	var ptDirection:String = CircumferencePointGenerator.COUNTERCLOCKWISE;<br/><br/>
		*	// execute the points based on the above variables, this returns an array of points<br/>
		*	var pts:Array = [];<br/>
		*	pts = pts.concat(CircumferencePointGenerator.getPoints(_target.x, _target.y, _target.width/2, totalPts, startAng, distributionRange, ptDirection));<br/><br/>
		*	// this will trace all the point objects generated around the perimeter of your circular object<br/>
		*	trace(pts);<code/></p>
		*/
		public static function getPoints(centerx:Number, centery:Number, circleradius:Number, totalpoints:int, startangle:Number=0, arc:int=360, pointdirection:String="clockwise", evendistribution:Boolean=true):Array {

			var mpi:Number = Math.PI/180;
			var startRadians:Number = startangle * mpi;

			var incrementAngle:Number = arc/totalpoints;
			var incrementRadians:Number = incrementAngle * mpi;

			if(arc<360) {
				// this spreads the points out evenly across the arc
				if(evendistribution) {
					incrementAngle = arc/(totalpoints-1);
					incrementRadians = incrementAngle * mpi;
				} else {
					incrementAngle = arc/totalpoints;
					incrementRadians = incrementAngle * mpi;
				}
			}

			var pts:Array = [];
			var diameter:Number = circleradius*2;

			while(totalpoints--) {
				var xp:Number = centerx + Math.sin(startRadians) * circleradius;
				var yp:Number = centery + Math.cos(startRadians) * circleradius;
				var pt:Point = new Point(xp, yp);
				pts.push(pt);

				if(pointdirection==CircumferencePointGenerator.COUNTERCLOCKWISE) {
					startRadians += incrementRadians;
				} else {
					startRadians -= incrementRadians;
				}
			}

			return pts;
		}

		/** @private */
		private static function tracer(str:String=""):void {
			trace("[ CircumferencePointGenerator ] :: "+str);
		}


	}

}
