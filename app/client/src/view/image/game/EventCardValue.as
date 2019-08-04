package view.image.game
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

    public class EventCardValue extends BaseLoadImage
    {
        private static const URL:String = "/public/image/card_event/"

        private var _value:int;
        private var _onMark:MovieClip;
        private var _onMarkUp:MovieClip;
        private var _on:Boolean;
        private const ON_MARK:String = "on_mov"
        private const ON_MARK_U:String = "on_mov_u"
        /**
         * コンストラクタ
         *
         */
        public function EventCardValue(url:String)
        {
            super(URL+url);
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);

           _root.cacheAsBitmap = true;
//           _onMark = MovieClip(_root.getChildAt(1));
           _onMark = MovieClip(_root.getChildByName(ON_MARK));
           _onMarkUp = MovieClip(_root.getChildByName(ON_MARK_U));
           if (_onMark != null)
           {
               _onMark.visible = false;
           }
           if (_onMarkUp != null)
           {
               _onMarkUp.visible = false;
           }

        }
        public function atValue(v:int):void
        {
            if (v > 9)
            {
                _value = 9;
            }else if (v < 1)
            {
                _value = 9+Math.abs(v);
            }else{
                _value = v;
            }
            waitComplete(setValue)
        }


        private function setValue():void
        {
          _root.gotoAndStop(_value);

        }

        public function set onMark(b:Boolean):void
        {
            _on = b;
            waitComplete(setMark)
        }

        private function setMark():void
        {
            if (_onMark!=null)
            {
                _onMark.visible = _on;
            }
        }

        public function set onMarkUp(b:Boolean):void
        {
            _on = b;
            waitComplete(setMarkUp)
        }

        private function setMarkUp():void
        {
            if (_onMarkUp!=null)
            {
                _onMarkUp.visible = _on;
            }
        }

    }

}
