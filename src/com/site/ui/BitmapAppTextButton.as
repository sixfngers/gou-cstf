/**
 * Created by ifreelance3 on 5/1/14.
 */
package com.site.ui
{
import com.davidcaneso.display.buttons.BasicButton;
import com.davidcaneso.singletons.Styling;
import com.davidcaneso.text.DynamicTextField;
import com.greensock.TweenMax;

import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextFormat;

public class BitmapAppTextButton extends BasicButton
    {
        private var _tf:DynamicTextField;
        private var _bg:MovieClip;


        public function BitmapAppTextButton(buttonText:String, buttonTextFormat:TextFormat, bg:MovieClip, isEnabledAtCreation:Boolean = true)
        {
            super(isEnabledAtCreation);
            _tf = new DynamicTextField(0, 0, buttonTextFormat);
            _tf.y = 5;
            _tf.multiline = false;
            _tf.text = buttonText;

            _bg = bg;

            addChild(_bg);
            addChild(_tf);

            this.mouseChildren = false;
            this.mouseEnabled = true;
            this.buttonMode = true;
        }

        public function get tf():DynamicTextField
        {
            return _tf
        }

        public function get bg():MovieClip
        {
            return _bg
        }

        public function changeText(val:String):void
        {
            _tf.text = val;
            _tf.x = bg.x + int((_bg.width - _tf.width) * .5);

//            _bg.width = _tf.width;
//            _bg.height = _tf.height;
        }

        override protected function buttonClick():void
        {
            trace('button click');
            dispatchEvent(new Event(Event.SELECT));
        }

        override protected function buttonRollOver():void
        {
            TweenMax.to(_tf,.2, {tint:Styling.instance.findColor('black')});
        }

        override protected function buttonRollOut():void
        {
            TweenMax.to(_tf,.2, {removeTint:true});
        }

    }
}
