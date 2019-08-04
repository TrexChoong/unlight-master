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
    import view.*;
    import model.FriendLink;
    import view.utils.*;

    /**
     * FriendListButton表示クラス
     *
     */

    public class FriendListButton extends BaseImage
    {

        // 表示元SWF
        [Embed(source="../../../../data/image/friend/btn_f_list.swf")]
        private var _Source:Class;


        private static const NORMAL_BUTTON:String = "btn_f_list";
        private static const ALERT_BUTTON:String = "btn_f_list_m";
        private static var __instance:FriendListButton;

        private var _normalBtn:SimpleButton;
        private var _alertBtn:SimpleButton;
        private var _alerted:Boolean = false;
        /**
         * コンストラクタ
         *
         */
        public function FriendListButton()
        {
            super();
            __instance = this;
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            SwfNameInfo.toLog(_root);
            _normalBtn =  SimpleButton(_root.getChildByName(NORMAL_BUTTON));
            _alertBtn =  SimpleButton(_root.getChildByName(ALERT_BUTTON));
            addEventListener(MouseEvent.CLICK, clickHandler);
            setAlertVisible();

        }

        override protected function get Source():Class
        {
            return _Source;
        }

        private function clickHandler(e:MouseEvent):void
        {

            FriendListView.show();
        }

        public function alertVisible(v:Boolean):void
        {
            _alerted = v;
            waitComplete(setAlertVisible);
        }

        private function setAlertVisible():void
        {
            if (_alerted)
            {
                _normalBtn.visible = false;
                _alertBtn.visible = true;
            }else{
                _normalBtn.visible = true;
                _alertBtn.visible = false;
            }
        }

        static public function updateAlert():void
        {
            var f_set:Object = FriendLink.getLinkSet();
            var alerted:Boolean = false;
            for (var key:Object in f_set)
            {
                if (f_set[key].status == FriendLink.FR_ST_MINE_CONFIRM)
                {
                    alerted = true
                }

            }
            if (__instance) {
                __instance.alertVisible(alerted);
            }
        }



    }

}
