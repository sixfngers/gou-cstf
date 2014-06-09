package com.site.ui
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import com.davidcaneso.singletons.RuntimeAssets;

    public class CharacterOrbData
    {
        private var _startingRotation:int;
        private var _orbitSpeed:Number;
        private var _offsetX:Number;
        private var _offsetY:Number;
        private var _orbitWidth:int;
        private var _orbitHeight:int;
        private var _maxOrbitScale:Number;
        private var _orbitScaleChange:Number;
        private var _visualAssetName:String;

        public function CharacterOrbData (data:XML)
        {
            _offsetX = Number(data.@offsetx);
            _offsetY = Number(data.@offsety);

            _orbitWidth = Number(data.@orbitwidth);
            _orbitHeight = Number(data.@orbitheight);
            _orbitSpeed = 0;
            _maxOrbitScale = 1;
            _orbitScaleChange = Number(data.@scalechange);
            _startingRotation = Number(data.@startrot);
            _visualAssetName = String(data.@orbasset);
        }


        public function get startingRotation():int {
            return _startingRotation;
        }

        public function get orbitSpeed():Number {
            return _orbitSpeed;
        }

        public function get offsetX():Number {
            return _offsetX;
        }

        public function get offsetY():Number {
            return _offsetY;
        }

        public function get orbitWidth():int {
            return _orbitWidth;
        }

        public function get orbitHeight():int {
            return _orbitHeight;
        }

        public function get maxOrbitScale():Number {
            return _maxOrbitScale;
        }

        public function get orbitScaleChange():Number {
            return _orbitScaleChange;
        }

        public function get visualAssetName():String {
            return _visualAssetName;
        }
    }

}
