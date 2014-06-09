/**
 * Created by ifreelance3 on 5/8/14.
 */
package com.site.app.ui
{
    import com.davidcaneso.display.buttons.ToggleButton;
    import com.davidcaneso.display.drawing.SquareArea;
    import com.davidcaneso.singletons.Styling;
    import com.davidcaneso.text.DynamicTextField;
    import com.site.ui.SquareAppTextButton;

    import flash.text.TextFieldAutoSize;

    public class AppCheckBox extends ToggleButton
    {
        private var _bg:SquareArea;
        private var _icon:DynamicTextField;
        private var _tf:DynamicTextField;

        public function AppCheckBox(isOnAtCreation:Boolean, buttonEnabledAtCreation:Boolean = true)
        {
            super(isOnAtCreation, buttonEnabledAtCreation);

            _bg = new SquareArea(17, 18, Styling.instance.findColor('yellow'));
            addChild(_bg);

            _icon = new DynamicTextField(30, _bg.height, Styling.instance.findFormat('verifyCheckboxMark'), TextFieldAutoSize.LEFT);
            _icon.y = -8;
            _icon.text = "X";
            _icon.visible = false;

            _tf = new DynamicTextField(0, 0, Styling.instance.findFormat('verifyField'));
            _tf.x = 20;
            _tf.y = -8;
            _tf.text = 'Click to Verify Video';

            addChild(_bg);
            addChild(_icon);
            addChild(_tf);

            this.buttonMode = true;
            this.mouseChildren = false;

        }

        public function reset():void
        {
            _icon.visible = false;
            toggleOff(true);
        }

        override protected function buttonClick():void
        {
            super.buttonClick();
            if(isOn)
                _icon.visible = true;
            else
                _icon.visible = false;
        }

        override protected function toggleOn(supressEvent:Boolean = false):void
        {
            super.toggleOn(supressEvent);
        }

        override protected function toggleOff(supressEvent:Boolean = false):void
        {
            super.toggleOff(supressEvent);
        }
    }
}
