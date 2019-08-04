package view.image.common
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;

    import view.image.BaseLoadImage;

    /**
     * StoryImage表示クラス
     *
     */


    public class StoryImage extends BaseLoadImage
    {


        private var _obverse:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function StoryImage(url:String )
        {
            super(url);
        }

        public override function init():void
        {
            _root.cacheAsBitmap = true;
        }


    }

}
