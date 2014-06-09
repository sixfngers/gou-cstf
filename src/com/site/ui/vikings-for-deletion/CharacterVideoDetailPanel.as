package com.site.ui
{
    import com.greensock.TweenMax;
    import com.greensock.easing.Quad;

    import flash.display.MovieClip;
    import flash.text.TextField;

    public class CharacterVideoDetailPanel extends MovieClip
    {
        public var _headingField:TextField;
        public var _bodyField:TextField;
        public var _isShowing:Boolean = false;
        private var _bg:MovieClip;

        public function CharacterVideoDetailPanel()
        {
            _headingField = this['headingTf'];
            _bodyField = this['bodyTf'];
            _bg = this['bg'];

            _hideDetail(true);
        }


        public function populate(charName:String, charInfo:String):void
        {
            _headingField.text = charName;
            _bodyField.text = charInfo;
        }


        public function toggleDetail():void
        {
            if(!_isShowing)
                _showDetail();
            else
                _hideDetail();
        }


        private function _showDetail():void
        {
            _isShowing = true;
            TweenMax.to(this,.5, {x:1038 - _bg.width, ease:Quad.easeOut})
        }


        private function _hideDetail(instant:Boolean = false):void
        {
            _isShowing = false;

            var time:Number = .5;
            var delay:Number = 0;
            if(instant)
            {
                time = 0;
                delay = 0;
            }

            TweenMax.to(this,time, {x:1038, ease:Quad.easeOut})

        }

    }
}
