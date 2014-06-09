package com.site.ui.video
{
    import flash.display.MovieClip;

    public class VideoController extends MovieClip
    {
        public var pausePlayButton:VideoPausePlayButton;

        public function VideoController()
        {
            pausePlayButton = this[icon]
        }

        public function updateElapsedTime():void
        {

        }
    }
}
