package view.image.common
{

    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;

    /**
     * FriendListButton表示クラス
     *
     */

    public class FriendButton extends BaseImage
    {

        // 表示元SWF
        [Embed(source="../../../../data/image/friend/btn_invite.swf")]
        private var _Source:Class;

        private var _label:Label = new Label();
        private var _text:String;
        private var _clickFunc:Function;

        /**
         * コンストラクタ
         *
         */
        public function FriendButton(name:String = "")
        {
            _text = name;
            super();
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            initLabel();
            addEventListener(MouseEvent.CLICK, clickHandler);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        private function clickHandler(e:MouseEvent):void
        {
            if (_clickFunc != null)
            {
                _clickFunc();
            }
        }
        public function setText(t:String):void
        {
            _text = t;
            initLabel();
        }


        public function setClickHandler(f:Function):void
        {
            _clickFunc = f;
        }


        private function initLabel():void
        {
            _label.x = 0;
            _label.y = -3;

            CONFIG::LOCALE_TCN{
                _label.y += 6;
            }

            _label.height = 20;
            _label.width = 78;
            _label.text = _text;
            _label.styleName = "FriendButton";
            _label.filters = [new GlowFilter(0x0000000, 1, 2, 2, 16, 1),];
            CONFIG::LOCALE_SCN{
                _label.y += 3;
                _label.setStyle("fontSize",10);
            }

            _label.mouseChildren = false;
            _label.mouseEnabled = false;
            addChild(_label);
        }




    }

}
