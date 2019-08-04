package view.scene.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import model.*;
    import model.events.*;

    import view.image.quest.*;
    import view.scene.*;
    import view.*;
    import view.utils.*;

    import controller.QuestCtrl;

    /**
     * クエストキャラ表示クラス
     *
     */
    public class QuestCharaClip extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "現在のキャラの位置です。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "Character's current location.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "角色的當前位置。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "角色现在的位置。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "현재의 캐릭의 위치입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Localisation de votre Personnage";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "現在のキャラの位置です。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "ตำแหน่งตัวละครปัจจุบัน";//"現在のキャラの位置です。";


        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ

        private static const _X_SET:Vector.<int> = Vector.<int>([128,224,320]);                         // 地形のX位置
        private static const _Y_SET:Vector.<int> = Vector.<int>([140,220,300,380,460]);              // 地形のY基本位置

        private var _charaImage:QuestCharaImage;

        private var _start:Boolean;
        private var _charaNo:int;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["現在のキャラの位置です。"],
                [_TRANS_MSG],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _QUEST_HELP:int = 0;
        private var _ctrl:QuestCtrl;

        /**
         * コンストラクタ
         *
         */
        public function QuestCharaClip(charaNo:int)
        {
            _ctrl = QuestCtrl.instance;
            x = _X_SET[_ctrl.currentCharaPoint.x];
            y = _Y_SET[0] - 64;
            _charaImage = new QuestCharaImage(charaNo)
            TopView.enable(false);
        }
        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            toolTipOwnerArray.push([0,this]);  //
        }

        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        public override function init():void
        {
            TopView.enable(true);

            // ここでハンドラを登録
            _ctrl.addEventListener(QuestCtrl.CHARA_POINT_UPDATE,pointUpdateHandler);

            // 出すものをだす
            addChild(_charaImage);
            initilizeToolTipOwners();
            updateHelp(_QUEST_HELP);

        }

        // 後始末処理
        public override function final():void
        {
            log.writeLog(log.LV_FATAL, this, "FINAL REMOVE QUEST CHARA IMAGE");
            // ここでハンドラを登録
            _ctrl.removeEventListener(QuestCtrl.CHARA_POINT_UPDATE,pointUpdateHandler);
            RemoveChild.apply(_charaImage)
//             removeChild(_charaImage);
        }


        // 位置アップデートハンドラ
        private function pointUpdateHandler(e:Event):void
        {
            TopView.enable(false);

//             x = _X_SET[_ctrl.currentCharaPoint.x];
//             y = _Y_SET[0] - 80;
            log.writeLog(log.LV_INFO, this, "pointUpdate",_ctrl.currentCharaPoint);
            var x:int = (_ctrl.currentCharaPoint.x < 0)? 0:_ctrl.currentCharaPoint.x;
            var y:int = (_ctrl.currentCharaPoint.y < 0)? 0:_ctrl.currentCharaPoint.y;

            BetweenAS3.parallel
                (
                    BetweenAS3.tween(this,
                                     { x:_X_SET[x],y:_Y_SET[y]},
                                     null,
                                     0.9 / Unlight.SPEED ,
                                     Sine.easeInOut
                        ),
//                     BetweenAS3.tween(this,
//                                      { x:x},
//                                      null,
//                                      0.04,
//                                      Sine.easeIn),
//                     BetweenAS3.tween(_upMC,
//                                      { x:_originalX+_scaleX*UP_START_X},
//                                      null,
//                                      UP_TIME_OUT,
//                                      Sine.easeIn
//                         ),

                    BetweenAS3.delay(BetweenAS3.func(arrivePoint), 0.75 / Unlight.SPEED )
                ).play();
            new WaitThread(900,TopView.enable,[true]).start();
        }

        // 移動終了
        private function arrivePoint():void
        {
//            log.writeLog(log.LV_INFO, this, "arrive at");
//            _ctrl.arrivelLand();
        }



    }
}


