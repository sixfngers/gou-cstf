package com.site.ui.header
{
    import com.davidcaneso.display.buttons.BasicButton;
    import com.greensock.TweenMax;
    import com.greensock.easing.Quad;

	import flash.display.MovieClip;

	import flash.events.Event;

    public class HeaderBackButton extends BasicButton
    {

        public function HeaderBackButton()
        {

        }

//
        public function hideButton():void
        {
			buttonRollOut();
			disable();
            TweenMax.to(this,.2, {autoAlpha:0, ease:Quad.easeOut})
        }


        public function showButton():void
        {
			buttonRollOut();
			enable();
            TweenMax.to(this,.2, {autoAlpha:1, ease:Quad.easeOut})
        }


        override protected function buttonRollOver():void
        {
            TweenMax.to(this,.3, {glowFilter:{color:0xffffff, blurX:4, blurY:4, strength:1.2, alpha:1},ease:Quad.easeOut});
            //TweenMax.to(this,.2, {tint:0xff0000, ease:Quad.easeOut})
        }


        override protected function buttonRollOut():void
        {
            TweenMax.to(this,.3, {glowFilter:{color:0xffffff, blurX:0, blurY:0, strength:1, alpha:0, remove:true},ease:Quad.easeOut});
            //TweenMax.to(this,.2, {removeTint:true, ease:Quad.easeOut})
        }


        override protected function buttonClick():void
        {
            dispatchEvent(new Event(Event.SELECT));
        }
//
    }
}
