/**
 * Created by ifreelance3 on 5/1/14.
 */
package com.site.ui
{
    import com.davidcaneso.display.buttons.BasicButton;
import com.davidcaneso.display.drawing.SquareArea;
import com.davidcaneso.singletons.Styling;
import com.davidcaneso.text.DynamicTextField;
import com.greensock.TweenMax;

import flash.events.Event;

import flash.text.TextFormat;

public class SquareAppTextButton extends BasicButton
    {
        private var _tf:DynamicTextField;
        private var _bg:SquareArea;


        public function SquareAppTextButton(buttonText:String, buttonTextFormat:TextFormat, bgColor:String, isEnabledAtCreation:Boolean = true)
        {
            super(isEnabledAtCreation);
            _tf = new DynamicTextField(0, 0, buttonTextFormat);
            _tf.multiline = false;
            _tf.text = buttonText;

            _bg = new SquareArea(_tf.width, _tf.height, Styling.instance.findColor(bgColor), false);

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

        public function get bg():SquareArea
        {
            return _bg
        }

        public function changeText(val:String):void
        {
            _tf.text = val;
            _bg.width = _tf.width;
            _bg.height = _tf.height;
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
