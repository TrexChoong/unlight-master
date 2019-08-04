package view.image.common
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;

    import view.image.BaseLoadImage;

    /**
     * WeaponCardImage表示クラス
     *
     */


    public class WeaponCardImage extends BaseLoadImage
    {
        private static const URL:String = "/public/image/card_weapon/";
        private var _frame:int;

        /**
         * コンストラクタ
         *
         */
        public function WeaponCardImage(url:String, frame:int = 0)
        {
            _frame = frame;
//            log.writeLog(log.LV_INFO, this, "url", URL+url);
            super(URL+url);
        }

        public override function init():void
        {
//            log.writeLog(log.LV_INFO, this, "item part frame", _frame);
            _root.gotoAndStop(_frame);
            _root.cacheAsBitmap = true;
        }

//         public function mouseOff():void
//         {
//             waitComplete(mouseEnabledAllOff);
//         }
//         private function mouseEnabledAllOff():void
//         {
//             _loader.mouseChildren = false;
//             _loader.mouseEnabled = false;
//             _root.enabled = false;
//             _root.mouseEnabled = false;
//             _root.mouseChildren = false;
//         }

    }
}
