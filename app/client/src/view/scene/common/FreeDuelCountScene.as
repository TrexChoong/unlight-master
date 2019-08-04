package view.scene.common
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;

    import flash.filters.DropShadowFilter;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Text;
    import mx.core.IToolTip;
    import mx.controls.*
    import mx.managers.ToolTipManager;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Avatar;
    import model.Option;
    import model.AvatarPart;
    import model.AvatarPartInventory;
    import view.image.common.*;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.*;
    import view.utils.*;

    /**
     * AvatarPartのアイコン表示クラス
     * 全部ビットマップでキャッシュすべできか。同時に二つでることがない？
     */

    public class FreeDuelCountScene extends BaseScene
    {
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG:String = "現在AP消費なしで対戦できる回数です";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG:String = "The number of times you can duel without AP.";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG:String = "不消耗AP可進行的對戰次數";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG:String = "不消耗AP可对战的次数";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG:String = "現在AP消費なしで対戦できる回数です";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG:String = "Voici le nombre de fois où vous pouvez jouer sans utiliser vos AP.";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG:String = "現在AP消費なしで対戦できる回数です";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG:String = "จำนวนครั้งที่สามารถประลองได้โดยที่ AP ไม่ลด";
        private static const _TOOLTIP_OFFSET_X:int  = 541;
        private static const _TOOLTIP_OFFSET_Y:int  = -32;

        // イメージ
//        private var _count:Label = new Label();                                           // 行動力ラベル
        private var _image:FreeDuelCountImage = new FreeDuelCountImage();
        private const X:int = -79;
        private const Y:int = 317;
        private var _toolTip:IToolTip;
        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["あなたのアバターです。",
//                 "対戦相手のアバターです。",],
                    //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                // ["現在AP消費なしで対戦できる回数です"],
                [_TRANS_MSG],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int = 0;
        /**
         * コンストラクタ
         *
         */
        public function FreeDuelCountScene()
        {
//             _count.width = 30;
//             _count.height = 36;
//             _count.styleName = "GameLobbyAvatarDFCLabel";
//            _count.filters = [new GlowFilter(0x000000, 1, 4, 4, 16, 1)];
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
//            _toolTipOwnerArray.push([0,this]);  //
            this.addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
            this.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);

        }
        // 初期化
        public override function init():void
        {
            addChild(_image);
            this.x = X;
            this.y = Y

            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);
        }

        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }


        // 後処理
        public override function final():void
        {
            RemoveChild.apply(_image)
            this.removeEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
            this.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
        }

        public  function countUpdate(i:int):void
        {
            _image.count = i;
//            _count.text = i.toString();
//            _count.htmlText = "111111111111111111111111111111111111"
        }
        private function mouseOverHandler(e:MouseEvent):void
        {
            if (_toolTip == null && Option.instance.help)
            {
                _toolTip = ToolTipManager.createToolTip(helpTextArray[0][0], _TOOLTIP_OFFSET_X,e.stageY+_TOOLTIP_OFFSET_Y);
            }
        }

        private function mouseOutHandler(e:MouseEvent):void
        {
             if (_toolTip != null)
             {
                 ToolTipManager.destroyToolTip(_toolTip);
                 _toolTip =null;
             }
        }


    }

}
