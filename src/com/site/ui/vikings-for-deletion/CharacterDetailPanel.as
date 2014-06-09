
package com.site.ui
{
import com.greensock.TweenMax;
import com.greensock.easing.Quad;

import flash.display.MovieClip;
import flash.text.TextField;
import flash.text.TextFormat;

public class CharacterDetailPanel extends MovieClip
    {
        public var _nameField:TextField;
        public var _infoField:TextField;
        public var _button:TwoFrameButton;
        public var _isShowing:Boolean = false;
        private var _bg:MovieClip;

        private var _nameFormat:TextFormat;
        private var _bodyFormat:TextFormat;

		private var _infoFieldOffsetX:int;

        public function CharacterDetailPanel()
        {
            _nameField = this['nameField'];
            _nameFormat = _nameField.getTextFormat();

            _infoField = this['infoField'];
            _bodyFormat = _infoField.getTextFormat();
			_infoFieldOffsetX = _infoField.x;

			_button = this['toggleButton'];
            _bg = this['bg'];

            _button.setup(1,2,_toggleDetail);

            hideDetail(true);
        }


		public function destroy():void
		{
			_button.destroy();
		}




        public function populate(charName:String, charInfo:String):void
        {
            _nameField.text = charName;
            _nameField.setTextFormat(_nameFormat);
            _infoField.text = charInfo;
            _infoField.setTextFormat(_bodyFormat);
        }


        public function showDetail():void
        {
			var time:Number = .5;
			var endX:int = 0;
            _isShowing = true;
            TweenMax.to(_bg, time, {x:endX, ease:Quad.easeOut});
			TweenMax.to(_infoField,time, {x:endX + _infoFieldOffsetX, ease:Quad.easeOut});
        }


        public function hideDetail(instant:Boolean = false):void
        {
            _isShowing = false;

            var time:Number = .5;
            var delay:Number = 0;
			var endX:int = -_bg.width;
            if(instant)
            {
                time = 0;
                delay = 0;
            }

            TweenMax.to(_bg,time, {x:endX, ease:Quad.easeOut});
			TweenMax.to(_infoField,time, {x:endX + _infoFieldOffsetX, ease:Quad.easeOut});
        }


        private function _toggleDetail():void
        {
            if(!_isShowing)
                showDetail();
            else
                hideDetail();
        }
    }
}
