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

    import model.*;
    import model.events.*;

    import view.image.quest.*;
    import view.scene.BaseScene;


    /**
     * キャラカードデッキ表示クラス
     *
     */
    public class QuestSearchItem extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "クエストを取得できるマップです。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "The map where you can acquire quests.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "可以取得任務的地圖。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "可获得任务的地图。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "퀘스트를 취득 할 수 있는 맵 입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Carte sur laquelle vous pourrez localiser les Quêtes.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "クエストを取得できるマップです。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "แผนที่ที่สามารถทำเควสได้";


        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ

        private static const _ITEM_X:int = 0;                         // カードのX基本位置
        private static const _ITEM_Y:int = 48;                          // カードのY基本位置
        private static const _ITEM_H:int = 16;                          // カードのY基本位置

        private var _itemImage:QuestItemImage = new QuestItemImage();
        private var _questMap:QuestMap;


        // ステータスラベル
        private var _name:Label = new Label();
        private var _level:Label = new Label();
        private var _ap:Label = new Label();

        // 一定数
        private static const _NAME_X:int = 72;
        private static const _NAME_Y:int = 0;
        private static const _NAME_WIDTH:int = 150;
        private static const _NAME_HEIGHT:int = 20;
        private static const _LEVEL_X:int = 25;
        private static const _LEVEL_Y:int = 0;
        private static const _LEVEL_WIDTH:int = 40;
        private static const _LEVEL_HEIGHT:int = 20;
        private static const _AP_X:int = 258;
        private static const _AP_Y:int = 0;
        private static const _AP_WIDTH:int = 20;
        private static const _AP_HEIGHT:int = 20;


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["クエストを取得できるマップです。"],
                [_TRANS_MSG],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _QUEST_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function QuestSearchItem(qm:QuestMap,index:int)
        {
            _questMap = qm;
            x = _ITEM_X;
            y = _ITEM_Y+index*_ITEM_H;
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
            _itemImage.changeSelect(false);

            // ここでハンドラを登録
            addEventListener(MouseEvent.MOUSE_OVER, overHandler);
            addEventListener(MouseEvent.MOUSE_OUT, outHandler);

            // 出すものをだす
            _container.addChild(_itemImage);
            addChild(_container);

            mapInitialize(_questMap);

            _helpTextArray[0][0] = _questMap.caption;

            initilizeToolTipOwners();
            updateHelp(_QUEST_HELP);
        }

        // 後始末処理
        public override function final():void
        {
            // ここでハンドラを取り除く
            removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
            itemFinalize();
        }


        // リストの初期化
        protected  function mapInitialize(questMap:QuestMap):void
        {
            log.writeLog(log.LV_INFO, this, "initialize!!!");
            // 一個ずつリストとインベントリのクエスト内容とをを結びつける
            _name.text = questMap.name;
            _ap.text = questMap.ap.toString();
            _level.text = "Lv "+questMap.level.toString();

            log.writeLog(log.LV_INFO, this, "questMap level", questMap.level);


            _name.x = _NAME_X;
            _name.y = _NAME_Y;
            _name.width = _NAME_WIDTH;
            _name.height = _NAME_HEIGHT;

            _ap.x = _AP_X;
            _ap.y = _AP_Y;
            _ap.width = _AP_WIDTH;
            _ap.height = _AP_HEIGHT;

            _level.x = _LEVEL_X;
            _level.y = _LEVEL_Y;
            _level.width = _LEVEL_WIDTH;
            _level.height = _LEVEL_HEIGHT;

            // 正しい位置に並べる
            _container.addChild(_name);
            _container.addChild(_ap);
            _container.addChild(_level);
        }

        // リストの後始末処理
        protected   function itemFinalize():void
        {
            _container.removeChild(_name);
            _container.removeChild(_ap);
            _container.removeChild(_level);
        }

        private function overHandler(e:MouseEvent):void
        {
            _itemImage.changeSelect(true);

        }

        private function outHandler(e:MouseEvent):void
        {
            _itemImage.changeSelect(false);
        }


        // 全体の更新
        public function update():void
        {
//             for (var key:Object in _cccDic)
//             {
//                 clipUpdate(_cccDic[key])
//             }
        }

        // リストのの更新
        protected function itemUpdate():void
        {
//            new BeTweenAS3Thread(cc, {x:_CARD_X+_CARD_OFFSET_X*CharaCardInventory(cc.cardInventory).position ,y:_CARD_Y}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE).start();
        }

        // カードを消す
        protected function removeCard():void
        {
//            _deckEditor.deckToBinderCharaCard(CharaCardInventory(cc.cardInventory));
        }


        // カードを足す
        protected function addCard():void
        {
//             clipInitialize(cci);
//             addMouseEventHandler();
//             update();
        }


        public function get questMap():QuestMap
        {
            return _questMap;
        }
    }
}


