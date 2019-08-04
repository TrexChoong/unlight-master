package view.image.common
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;

    import view.image.BaseLoadImage;

    /**
     * AvatarPartImage表示クラス
     *
     */


    public class AvatarPartImage extends BaseLoadImage
    {
        private static const URL:String = "/public/image/avatar_parts/";


        /**
         * コンストラクタ
         *
         */
        public function AvatarPartImage(url:String)
        {
//            log.writeLog(log.LV_INFO, this, "url", URL+url);
            super(URL+url+".swf");
        }

        protected override function swfinit(event: Event):void
        {
            super.swfinit(event);
            if (_root != null)
            {
            _root.cacheAsBitmap = true;
            }
        }

        public function mouseOff():void
        {
            waitComplete(mouseEnabledAllOff);
        }
        private function mouseEnabledAllOff():void
        {
//             _loader.mouseChildren = false;
//             _loader.mouseEnabled = false;
            if (_root != null)
            {
                _root.enabled = false;
                _root.mouseEnabled = false;
                _root.mouseChildren = false;
            }
        }

    }
}
