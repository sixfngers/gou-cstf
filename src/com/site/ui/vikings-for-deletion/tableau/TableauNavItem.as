
package com.site.ui.tableau
{
    import com.davidcaneso.utils.HitSpriteHelper;
    import com.greensock.TweenMax;
    import com.greensock.easing.Expo;
import com.greensock.easing.Quad;

import flash.display.DisplayObjectContainer;

import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
	import flash.geom.Point;

	public class TableauNavItem extends MovieClip
    {
		public var trackingName:String;
        public var interactive:Boolean;
		public var navNumber:int;
        public var idlePosition:Point;
		public var idleScale:Number;
		public var focusPosition:Point;
		public var focusScale:Number;

        private var _area:Sprite;
        private var _nameField:MovieClip;
        private var _charImage:MovieClip;
        private var _rolloverClip:MovieClip;
        private var _lockClip:MovieClip;
		private var _mouseIsOver:Boolean;
		private var _outFrameStart:int;


        public function TableauNavItem()
        {
            this.mouseEnabled = false;

            var content:MovieClip = this['content'] as MovieClip;
            //trace('content name ',content.name, content.numChildren);

            content.mouseChildren = false;
            content.mouseEnabled = false;
            content.buttonMode = false;

            //  hitAreaFill is a movieclip that fills in any holes in the hit area
            var hitAreaFill:MovieClip = content['hitAreaFill'];

            //  assure there is a hit area fill clip in case one isnt there
            if(hitAreaFill == null) hitAreaFill = new MovieClip();

            //  show hit area so the hitSpriteHelper can fill in any holes
            hitAreaFill.alpha = 100;

            //  draw hit area
            _area = HitSpriteHelper.makeHitSprite(content,0);
            addChild(_area);

            // hide hitAreaFill so we dont see it any more
            hitAreaFill.alpha = 0;
        }

        public function setup(isActive:Boolean = false):void
        {
            var content:MovieClip = this['content'] as MovieClip;

            _rolloverClip = content['overMc'] as MovieClip;

            _charImage = content['characterImage'] as MovieClip;
            _nameField = content['details'] as MovieClip;

            _lockClip = content['lock'] as MovieClip;
            trace('_lockClip ',_lockClip);

			_rolloverClip.gotoAndStop(1);
        }


        public function enableButton():void
        {
            _area.buttonMode = true;
            _area.addEventListener(MouseEvent.ROLL_OVER, _interact);
            _area.addEventListener(MouseEvent.ROLL_OUT, _interact);
            _area.addEventListener(MouseEvent.CLICK, _interact);
        }


        public function disableButton():void
        {
            _area.buttonMode = false;
            _area.removeEventListener(MouseEvent.ROLL_OVER, _interact);
            _area.removeEventListener(MouseEvent.ROLL_OUT, _interact);
            _area.removeEventListener(MouseEvent.CLICK, _interact);
        }


        private function _interact(e:MouseEvent):void
        {
            switch (e.type)
            {
                case MouseEvent.ROLL_OVER:
                    _mouseIsOver = true;
					if(interactive)
                    {
                        if(_rolloverClip.currentFrame == 1 || _rolloverClip.currentFrame >= _outFrameStart)
                            _rollOverAnimation();
                    }
                    else
                    {
                        showLocked();
                    }


                    break;

                case MouseEvent.ROLL_OUT:
					_mouseIsOver = false;
                    if(interactive)
                    {
                        _rollOutAnimation();
                    }
                    else
                    {
                        hideLocked();
                    }
                    break;

                case MouseEvent.CLICK:
                    if(interactive)
                    {
                        _rollOutAnimation();
                        dispatchEvent(new Event(Event.SELECT));
                    }
                    break;
            }
        }

        private function showLocked():void
        {

            TweenMax.to(_charImage,.3, {glowFilter:{color:0xffffff, blurX:4, blurY:4, strength:1.2, alpha:1}, colorMatrixFilter:{saturation:0},ease:Quad.easeOut});
            TweenMax.to(_lockClip,.3, {autoAlpha:1, ease:Quad.easeOut})
        }

        private function hideLocked():void
        {

            TweenMax.to(_charImage,.2, {glowFilter:{color:0xffffff, blurX:0, blurY:0, strength:0, alpha:0, remove:true}, colorMatrixFilter:{saturation:1}, ease:Quad.easeOut});
            TweenMax.to(_lockClip,.2, {autoAlpha:0, ease:Quad.easeOut})
        }


        private function _rollOverAnimation():void
        {
            TweenMax.to(_nameField, 1, {alpha:1, ease:Expo.easeOut});
            _rolloverClip.gotoAndPlay('in');
        }

        private function _rollOutAnimation():void
        {
            TweenMax.to(_nameField, 1, {alpha:0, ease:Expo.easeOut});
            _rolloverClip.gotoAndPlay('out');
        }


        public function get charImage():MovieClip
        {
            return _charImage;
        }
    }
}
