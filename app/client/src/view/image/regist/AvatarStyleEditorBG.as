package view.image.regist
{

    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.Thread;
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;

    /**
     * アバター設定背景
     *
     */

    public class AvatarStyleEditorBG extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/regist/make_2avatar.swf")]
        private var _Source:Class;

        private static const SCALE:Number = 1.0;
        private static const X:int = 0;
        private static const Y:int = 0;
        private static const ENABLE:String = "en";
        private static const DISABLE:String = "dis";


        private var _cat_a:MovieClip;
        private var _cat_b:MovieClip;
        private var _cat_c:MovieClip;


        /**
         * コンストラクタ
         *
         */
        public function AvatarStyleEditorBG()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);


            // パーツのタイプだけ出す(Partsのスタティックからもらうべき)
            initializePos();
        }


        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {

            scaleX = SCALE;
            scaleY = SCALE;
            x = X;
            y = Y;
            alpha = 1.0;
        }

        public function showAvatarBase():void
        {

        }
        public function hideAvatarBase():void
        {

        }



    }

}

