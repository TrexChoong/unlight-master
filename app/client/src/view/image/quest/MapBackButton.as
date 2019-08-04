package view.image.quest
{

    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.*;
    import view.utils.*;
    import view.image.*;

    /**
     * MapBackButton表示クラス
     *
     */


    public class MapBackButton extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/btn_mapback.swf")]
        private var _Source:Class;

        /**
         * コンストラクタ
         *
         */
        public function MapBackButton()
        {
            super();
        }


        protected override function get Source():Class
        {
            return _Source;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
        }



    }

}

