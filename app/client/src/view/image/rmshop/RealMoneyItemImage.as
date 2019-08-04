package view.image.rmshop
{

    import flash.display.*;
    import flash.events.Event;

    import mx.core.UIComponent;

    import flash.events.MouseEvent;
    import view.image.BaseLoadImage;

    /**
     * EventCardValue表示クラス
     *
     */

    public class RealMoneyItemImage extends BaseLoadImage
    {
        private static const URL:String = "/public/image/rm_shop/";
        private var _bitmap:Bitmap;

        /**
         * コンストラクタ
         *
         */
        public function RealMoneyItemImage(url:String)
        {
//            log.writeLog(log.LV_INFO, this, "+++++++++++++++",url);
            super(URL+url);
        }
        override protected function swfinit(event: Event): void
        {
            _loaderInfo.removeEventListener(Event.INIT, swfinit);
            _bitmap = event.target.content;

        }

    }

}
