/**
 * Created by ifreelance3 on 4/28/14.
 */
package com.site.ui
{
    import com.davidcaneso.display.buttons.BasicButton;
import com.davidcaneso.singletons.Styling;
import com.greensock.TweenMax;
    import com.greensock.easing.Quad;

    import flash.display.MovieClip;
    import flash.events.Event;

    public class ShareStepShareButton extends BasicButton
    {
        private var _icon:MovieClip;
        private var _bg:MovieClip;

        public function ShareStepShareButton(frame:int)
        {
            super(true);

            var content:MovieClip = new shareStepButtonStageContent() as MovieClip;
            addChild(content);
            _icon = content.icon;
            _bg = content.bg;
            _bg.gotoAndStop(frame);
            _icon.gotoAndStop(frame);
        }

        override protected function buttonRollOver():void
        {
             TweenMax.to(_icon,.3, {tint:Styling.instance.findColor('yellow'), ease:Quad.easeOut});
        }

        override protected function buttonRollOut():void
        {
            TweenMax.to(_icon,.3, {removeTint:true, ease:Quad.easeOut});
        }

        override protected function buttonClick():void
        {
            dispatchEvent(new Event(Event.SELECT));
        }
    }
}
