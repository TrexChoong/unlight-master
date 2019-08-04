package view.image.common
{

    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.controls.Text;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;

    /**
     * ScrollBarBase表示クラス
     *
     */

    public class FreeDuelCountImage extends BaseImage
    {

        // 表示元SWF
        [Embed(source="../../../../data/image/common/star_battle.swf")]
        private var _Source:Class;

        private var _count:int = 3;
        /**
         * コンストラクタ
         *
         */
        public function FreeDuelCountImage()
        {
            super();
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            _count = 3;
            setCount()

        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function set count(c:int):void
        {
            _count = c;
            waitComplete(setCount);
        }

        private function setCount():void
        {
            if (_count == 3)
            {
                _root.gotoAndStop(1);
            }
            else if (_count==2)
            {
                _root.gotoAndStop(2);

            }
            else if (_count==1)
            {
                _root.gotoAndStop(3);

            }
            else if (_count==0)
            {
                _root.gotoAndStop(4);

            }


        }

    }

}
