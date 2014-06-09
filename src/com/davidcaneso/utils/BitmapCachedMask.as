package com.davidcaneso.utils
{
import flash.display.DisplayObject;

public class BitmapCachedMask
    {
        public function BitmapCachedMask()
        {

        }

        public static function MaskItem(item:DisplayObject, maskWith:DisplayObject):void
        {
            item.cacheAsBitmap = true;
            maskWith.cacheAsBitmap = true;

            item.mask = maskWith;
        }
    }
}
