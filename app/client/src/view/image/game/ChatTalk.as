package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.utils.*;

    import view.image.BaseImage;
    import controller.*;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;


    /**
     * OKボタン
     *
     */


    public class ChatTalk extends BaseImage
    {

//         // OKボタン 表示元SWF
//         [Embed(source="../../../../data/image/ok.swf")]
        // OKボタン 表示元SWF
        [Embed(source="../../../../data/image/game/talk.swf")]
        private var _Source:Class;
        private static const _X:int = 0;
        private static const _Y:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function ChatTalk()
        {
            super();
            x = _X;
            y = _Y;
            mouseEnabled = false;
            alpha = 0.0;
//            Unlight.GCW.watch(this,getQualifiedClassName(this));

        }

        override protected function swfinit(event: Event): void 
        {

            super.swfinit(event);
            _root.enabled =false;
            _root.mouseEnabled = false;
        }

        public override function init():void
        {
            ChatCtrl.instance.addEventListener(ChatCtrl.MATCH_LOG_UPDATE, updateHandler)
        }

        public override function final():void
        {
            ChatCtrl.instance.removeEventListener(ChatCtrl.MATCH_LOG_UPDATE, updateHandler)
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        private function updateHandler(e:Event):void
        {
            BetweenAS3.serial
                (
                    BetweenAS3.tween(this,
                                     { alpha:1.0},
                                     { alpha:0.0},
                                     0.3,
                                     Sine.easeIn),
                    BetweenAS3.delay(
                    BetweenAS3.tween(this,
                                     { alpha:0.0},
                                     { alpha:1.0},
                                     0.5,
                                     Sine.easeIn),
                    0.5,0)
                    ).play();

        }


//         public function set buttonEnabled(b:Boolean):void
//         {
//             _buttonEnabled = b;
//             var func:Function;
//             func =  function():void
//             {
//                 _root.enabled = b;
//                 mouseChildren = b;
//                 _buttunOk.visible = b;
//             }
//             waitComplete(func);
//         }

    }

}
