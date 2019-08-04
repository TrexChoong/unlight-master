package view.scene.lobby
{

    import flash.display.*;
    import flash.events.*;
    import flash.utils.Timer;
    import flash.filters.GlowFilter;

    import mx.core.UIComponent;
    import mx.core.IToolTip;
    import mx.controls.*
    import mx.managers.ToolTipManager;

    import model.Player;
    import view.scene.BaseScene;
    import view.image.lobby.*;
    import view.RealMoneyShopView;
    import view.scene.ranking.*;
    import view.utils.RemoveChild;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    /**
     * Lobby表示クラス
     *
     */


    public class Entrance extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_DUELLOBBY	:String = "デュエルロビー。対戦ができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_DECKEDIT	:String = "デッキ編集。デッキの閲覧、編集ができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_OPTION		:String = "オプション。音量などの設定ができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_TUTOLIAL	:String = "チュートリアル。ゲームの説明を聞くことができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_DUEL		:String = "デュエル。他のプレイヤーと対戦することができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_QUEST		:String = "クエスト。地域ごとのクエストを請けることができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_ITEM		:String = "アイテム。アイテムを確認、使用ができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_SHOP		:String = "ショップ。カードやアイテムの購入ができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_LOT		:String = "ダークルーム。カードやパーツをクジで手に入れることができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_LIBRARY        :String = "ライブラリ。カードリストやストーリーが確認できます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_RAID           :String = "レイド。強力なボスを相手に複数人で挑む事ができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_SALE           :String = "残り[__SALE_TIME__]";

        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_DUELLOBBY	:String = "Duel Lobby. Find opponents to battle against here.";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_DECKEDIT	:String = "Deck Editor. You can inspect and edit your deck here.";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_OPTION		:String = "Options. Change settings such as audio volume.";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_TUTOLIAL	:String = "Tutorial. Watch a step by step explanation of game mechanics.";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_DUEL		:String = "Duel. Battle with other online players.";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_QUEST		:String = "Quest. Each area has its own quests.";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_ITEM		:String = "Items. Inspect or use your items.";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_SHOP		:String = "Shop. Buy cards and items here.";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_LOT		:String = "Darkroom. Gamble for cards or parts.";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_LIBRARY        :String = "Library. Research cards or stories.";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_RAID           :String = "Raid: several people team up to take on a powerful boss in battle.";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_SALE           :String = "[__SALE_TIME__]";

        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_DUELLOBBY	:String = "決鬥大廳。可以對戰。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_DECKEDIT	:String = "牌組編輯。可以瀏覽和編輯卡組。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_OPTION		:String = "選項。可以調整音量之類的設定。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_TUTOLIAL	:String = "遊戲教學。可以看到詳細的遊戲說明。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_DUEL		:String = "決鬥。可以跟其它玩家進行對戰。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_QUEST		:String = "任務。可以在各個區域進行任務。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_ITEM		:String = "道具。可以確認和使用道具。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_SHOP		:String = "商店。可以購買卡片和道具。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_LOT		:String = "暗房。卡片以及道具已經可以經由抽獎取得物品。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_LIBRARY        :String = "圖書館。可以觀看擁有的卡片名單以及故事劇情。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_RAID           :String = "Raid。可以多人一起挑戰強大的BOSS。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_SALE           :String = "剩餘時間[__SALE_TIME__]";

        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_DUELLOBBY	:String = "决斗大厅。可以对战。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_DECKEDIT	:String = "卡组编辑。可浏览、编辑卡组。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_OPTION		:String = "选项。可设定音量等。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_TUTOLIAL	:String = "教学。可听取游戏的说明。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_DUEL		:String = "决斗。可与其他玩家对战。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_QUEST		:String = "任务。可在不同区域进行任务。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_ITEM		:String = "道具。可确认并使用道具。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_SHOP		:String = "商店。可购买卡片及道具。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_LOT		:String = "暗房。可通过抽奖获得卡片及配件。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_LIBRARY        :String = "图书馆。可确认卡片列表并阅读故事。 ";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_RAID           :String = "Raid。可多人一起挑战强大的首领。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_SALE           :String = "剩余[__SALE_TIME__]";

        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_DUELLOBBY	:String = "듀엘 로비. 대전이 가능합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_DECKEDIT	:String = "덱 편집. 덱의 관람, 편집이 가능합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_OPTION		:String = "옵션. 음량등의 설정이 가능합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_TUTOLIAL	:String = "튜토리얼. 게임의 설명을 들을 수 있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_DUEL		:String = "듀엘. 다른 플레이어와 대전을 할 수 있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_QUEST		:String = "퀘스트. 지역별의 퀘스트를 수령할 수 있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_ITEM		:String = "아이템. 아이템을 확인, 사용 할 수 있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_SHOP		:String = "샵. 카드, 아이템을 구입할 수 있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_LOT		:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_LIBRARY        :String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_RAID           :String = "レイド。強力なボスを相手に複数人で挑む事ができます。";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_SALE           :String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_DUELLOBBY	:String = "Couloir. Trouvez votre adversaire ici.";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_DECKEDIT	:String = "Modification de pioche. Vous pouvez modifier votre pioche ici.";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_OPTION		:String = "Option. Volume, etc.";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_TUTOLIAL	:String = "Tutoriaux. Ecoutez les explications concernant le jeu.";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_DUEL		:String = "Duel. Combattez d'autres joueurs en ligne.";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_QUEST		:String = "Quête. Chaque région a ses propres quêtes.";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_ITEM		:String = "Objet. Regardez les objets que vous possédez et utilisez-les.";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_SHOP		:String = "Magasin. Vous pouvez acheter des cartes et des objets ici.";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_LOT		:String = "Pièce Obscure. Endroit où vous pouvez obtenir des carte et des accessoires en tentant votre chance à la Lotterie.";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_LIBRARY        :String = "Bibliothèque. Vous pouvez y vérifier la liste des cartes et les histoires des personnages.";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_RAID           :String = "Raid. Vous pouvez vous allier avec plusieurs joueur pour combattre un Boss puissant.";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_SALE           :String = "Reste [__SALE_TIME__]";

        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_DUELLOBBY	:String = "デュエルロビー。対戦ができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_DECKEDIT	:String = "デッキ編集。デッキの閲覧、編集ができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_OPTION		:String = "オプション。音量などの設定ができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_TUTOLIAL	:String = "チュートリアル。ゲームの説明を聞くことができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_DUEL		:String = "デュエル。他のプレイヤーと対戦することができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_QUEST		:String = "クエスト。地域ごとのクエストを請けることができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_ITEM		:String = "アイテム。アイテムを確認、使用ができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_SHOP		:String = "ショップ。カードやアイテムの購入ができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_LOT		:String = "ダークルーム。カードやパーツをクジで手に入れることができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_LIBRARY        :String = "ライブラリ。カードリストやストーリーが確認できます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_RAID           :String = "レイド。強力なボスを相手に複数人で挑む事ができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_SALE           :String = "残り[__SALE_TIME__]";

        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_DUELLOBBY  :String = "ห้องดูเอล ท่านสามารถทำการประลองได้ที่นี่";//"デュエルロビー。対戦ができます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_DECKEDIT   :String = "จัดการสำรับ";//"デッキ編集。デッキの閲覧、編集ができます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_OPTION     :String = "Option ท่านสามารถปรับเสียงและอื่นๆ ได้ที่นี่";//"オプション。音量などの設定ができます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_TUTOLIAL   :String = "แนะนำผู้เล่น";//"チュートリアル。ゲームの説明を聞くことができます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_DUEL       :String = "ดูเอล การประลองกับผู้เล่นอื่น";//"デュエル。他のプレイヤーと対戦することができます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_QUEST      :String = "เควส ท่านสามารรถทำเควสได้ตามแผนที่ต่างๆ";//"クエスト。地域ごとのクエストを請けることができます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_ITEM       :String = "ไอเท็ม ท่านสามารถใช้หรือดูไอเท็มได้ที่นี่";//"アイテム。アイテムを確認、使用ができます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_SHOP       :String = "ร้านค้า ท่านสามารถซื้อการ์ดหรือไอเท็มต่างๆ ได้ที่นี่";//"ショップ。カードやアイテムの購入ができます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_LOT        :String = "ห้องแห่งความมืด ท่านจะได้รับการ์ดและชิ้นส่วนต่างๆ จากการเสี่ยงโชคที่นี่";//"ダークルーム。カードやパーツをクジで手に入れることができます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_LIBRARY        :String = "ห้องสมุด ท่านสามารถดูรายชื่อการ์ดและเรื่องราวต่างๆ ได้จากที่นี่";//"ライブラリ。カードリストやストーリーが確認できます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_RAID           :String = "การโจมตีบอสที่มีพลังมาก สามารถสู้ได้หลายคน"; // レイド。強力なボスを相手に複数人で挑む事ができます。
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_SALE           :String = "เวลาที่เหลือ[__SALE_TIME__]";

        private static const _TOOLTIP_OFFSET_X_TUTO:int = 280;
        private static const _TOOLTIP_OFFSET_X_OPT:int  = 150;
        private static const _TOOLTIP_OFFSET_X_CARD:int = 85;
        private static const _TOOLTIP_OFFSET_X_ITEM:int = 140;
        private static const _TOOLTIP_OFFSET_X_LOT:int  = 40;
        private static const _TOOLTIP_OFFSET_X_LIB:int  = 280;
        private static const _TOOLTIP_OFFSET_Y:int  = 8;


        private var _bgSet:EntranceSet = new EntranceSet();
        private var _ranking:RankingArea = new RankingArea;
//        private var _battle:BattleButton = new BattleButton();
        private var _cardToolTip:IToolTip;
        private var _optionToolTip:IToolTip;
        private var _tutorialToolTip:IToolTip;
        private var _duelToolTip:IToolTip;
        private var _questToolTip:IToolTip;
        private var _itemToolTip:IToolTip;
        private var _shopToolTip:IToolTip;
        private var _lotToolTip:IToolTip;
        private var _libraryToolTip:IToolTip;
        private var _raidToolTip:IToolTip;
        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["デュエルロビー。対戦ができます。"],   // 0
//                ["デッキ編集。デッキの閲覧、編集ができます。"],   // 1
//                ["オプション。音量などの設定ができます。"],   // 2
//                ["チュートリアル。ゲームの説明を聞くことができます。"],   // 3
//                ["デュエル。他のプレイヤーと対戦することができます。"],   // 4
//                ["クエスト。地域ごとのクエストを請けることができます。"],   // 5
//                ["アイテム。アイテムを確認、使用ができます。"],   // 6
//                ["ショップ。カードやアイテムの購入ができます。"],   // 6
                [_TRANS_AREA_DUELLOBBY],   // 0
                [_TRANS_AREA_DECKEDIT],   // 1
                [_TRANS_AREA_OPTION],   // 2
                [_TRANS_AREA_TUTOLIAL],   // 3
                [_TRANS_AREA_DUEL],   // 4
                [_TRANS_AREA_QUEST],   // 5
                [_TRANS_AREA_ITEM],   // 6
                [_TRANS_AREA_SHOP],   // 7
                [_TRANS_AREA_LOT],   // 8
                [_TRANS_AREA_LIBRARY],   // 9
                [_TRANS_AREA_RAID],   // 10
                [_TRANS_AREA_SALE]   // 11
            ];

        // 描画コンテナ
        private var _labelContainer:UIComponent = new UIComponent();

        // セール表示用ラベル
        private var _saleDiscountLabel:Label = new Label();
        private static const _SALE_DISC_LABEL_X:int = 35;
        private static const _SALE_DISC_LABEL_Y:int = 143;
        private static const _LABEL_WIDTH:int  = 40;
        private static const _LABEL_HEIGHT:int = 40;
        private var _saleRestTimeLabel:Label = new Label();
        private static const _SALE_TIME_LABEL_X:int = 85;
        private static const _SALE_TIME_LABEL_Y:int = 147;
        private static const _TIME_LABEL_WIDTH:int  = 90;
        private static const _TIME_LABEL_HEIGHT:int = 20;

        private var _serialInputPanel:SerialInputPanel = new SerialInputPanel;
        private var _eventInfoPanel:EventInfoPanel = new EventInfoPanel();

        private var _time:Timer;  // セール監視用タイマー

        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function Entrance()
        {
            alpha = 0.0;
            super();
        }

        // 各種ボタンのゲッター
        public function get battle():InteractiveObject
        {
            return _bgSet.battle;
        }
        public function get card():InteractiveObject
        {
            return _bgSet.card;
        }
        public function get option():InteractiveObject
        {
            return _bgSet.option;
        }
        public function get item():InteractiveObject
        {
            return _bgSet.item;
        }
        public function get shop():InteractiveObject
        {
            return _bgSet.shop;
        }
        public function get quest():InteractiveObject
        {
            return _bgSet.quest;
        }
        public function get tutorial():InteractiveObject
        {
            return _bgSet.tutorial;
        }
        public function get lot():InteractiveObject
        {
            return _bgSet.lot;
        }
        public function get library():InteractiveObject
        {
            return _bgSet.library;
        }

        public function get serial():InteractiveObject
        {
            return _bgSet.serial;
        }

        public function get sale():MovieClip
        {
            return _bgSet.sale;
        }

        public function get raid():InteractiveObject
        {
            return _bgSet.raid;
        }

        public function get info():InteractiveObject
        {
            return _bgSet.info;
        }

        public override function init():void
        {
            addChild(_bgSet);
            addChild(_ranking);
//            addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_CHARA_CARD));
            initSaleMC();
            initilizeToolTipOwners();
            CONFIG::LOCALE_JP
            {
            serial.addEventListener(MouseEvent.CLICK, serialMouseClickHandler);
            }
            CONFIG::LOCALE_TCN
            {
            serial.addEventListener(MouseEvent.CLICK, serialMouseClickHandler);
            }
            CONFIG::LOCALE_SCN
            {
            serial.addEventListener(MouseEvent.CLICK, serialMouseClickHandler);
            }
            CONFIG::LOCALE_TH
            {
            serial.addEventListener(MouseEvent.CLICK, serialMouseClickHandler);
            }
            CONFIG::LOCALE_EN
            {
            serial.addEventListener(MouseEvent.CLICK, serialMouseClickHandler);
            }
            CONFIG::LOCALE_FR
            {
            serial.addEventListener(MouseEvent.CLICK, serialMouseClickHandler);
            }
//            CONFIG::LOCALE_EN
//            {
//            serial.addEventListener(MouseEvent.CLICK, serialMouseClickHandler);
//            }
            info.addEventListener(MouseEvent.CLICK,infoClickHandler);
            updateHelp(_GAME_HELP);
        }

//         CONFIG::NOT_PAYMENT
//         public override function init():void
//         {
//             addChild(_bgSet);
//             addChild(_ranking);
//             _ranking.getShowThread(this)
// //            addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_CHARA_CARD));
//             initSaleMC();
//             initilizeToolTipOwners();
//             info.addEventListener(MouseEvent.CLICK,infoClickHandler);
//             updateHelp(_GAME_HELP);
//         }

        public override function final():void
        {
            _bgSet.card.removeEventListener(MouseEvent.ROLL_OVER, cardMouseOverHandler);
            _bgSet.card.removeEventListener(MouseEvent.ROLL_OUT, cardMouseOutHandler);
            _bgSet.option.removeEventListener(MouseEvent.ROLL_OVER, optionMouseOverHandler);
            _bgSet.option.removeEventListener(MouseEvent.ROLL_OUT, optionMouseOutHandler);
            _bgSet.battle.removeEventListener(MouseEvent.ROLL_OVER, battleMouseOverHandler);
            _bgSet.battle.removeEventListener(MouseEvent.ROLL_OUT, battleMouseOutHandler);
            _bgSet.quest.removeEventListener(MouseEvent.ROLL_OVER, questMouseOverHandler);
            _bgSet.quest.removeEventListener(MouseEvent.ROLL_OUT, questMouseOutHandler);
            _bgSet.tutorial.removeEventListener(MouseEvent.ROLL_OVER, tutorialMouseOverHandler);
            _bgSet.tutorial.removeEventListener(MouseEvent.ROLL_OUT, tutorialMouseOutHandler);
            _bgSet.shop.removeEventListener(MouseEvent.ROLL_OVER, shopMouseOverHandler);
            _bgSet.shop.removeEventListener(MouseEvent.ROLL_OUT, shopMouseOutHandler);
            _bgSet.item.removeEventListener(MouseEvent.ROLL_OVER, itemMouseOverHandler);
            _bgSet.item.removeEventListener(MouseEvent.ROLL_OUT, itemMouseOutHandler);
            _bgSet.lot.removeEventListener(MouseEvent.ROLL_OVER, lotMouseOverHandler);
            _bgSet.lot.removeEventListener(MouseEvent.ROLL_OUT, lotMouseOutHandler);
            _bgSet.library.removeEventListener(MouseEvent.ROLL_OVER, libraryMouseOverHandler);
            _bgSet.library.removeEventListener(MouseEvent.ROLL_OUT, libraryMouseOutHandler);
            _bgSet.raid.removeEventListener(MouseEvent.ROLL_OVER, raidMouseOverHandler);
            _bgSet.raid.removeEventListener(MouseEvent.ROLL_OUT, raidMouseOutHandler);
            _bgSet.sale.removeEventListener(MouseEvent.CLICK, serialMouseClickHandler);

            info.removeEventListener(MouseEvent.CLICK,infoClickHandler);

            RemoveChild.all(_labelContainer);

            if (_time) {
                _time.stop();
                _time.removeEventListener(TimerEvent.TIMER, updateDuration);
            }
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
//             _toolTipOwnerArray.push([0,_bgSet.battle]);  //
            _bgSet.card.addEventListener(MouseEvent.ROLL_OVER, cardMouseOverHandler);
            _bgSet.card.addEventListener(MouseEvent.ROLL_OUT, cardMouseOutHandler);
            _bgSet.option.addEventListener(MouseEvent.ROLL_OVER, optionMouseOverHandler);
            _bgSet.option.addEventListener(MouseEvent.ROLL_OUT, optionMouseOutHandler);
            _bgSet.battle.addEventListener(MouseEvent.ROLL_OVER, battleMouseOverHandler);
            _bgSet.battle.addEventListener(MouseEvent.ROLL_OUT, battleMouseOutHandler);
            _bgSet.quest.addEventListener(MouseEvent.ROLL_OVER, questMouseOverHandler);
            _bgSet.quest.addEventListener(MouseEvent.ROLL_OUT, questMouseOutHandler);
            _bgSet.tutorial.addEventListener(MouseEvent.ROLL_OVER, tutorialMouseOverHandler);
            _bgSet.tutorial.addEventListener(MouseEvent.ROLL_OUT, tutorialMouseOutHandler);
            _bgSet.shop.addEventListener(MouseEvent.ROLL_OVER, shopMouseOverHandler);
            _bgSet.shop.addEventListener(MouseEvent.ROLL_OUT, shopMouseOutHandler);
            _bgSet.item.addEventListener(MouseEvent.ROLL_OVER, itemMouseOverHandler);
            _bgSet.item.addEventListener(MouseEvent.ROLL_OUT, itemMouseOutHandler);
            _bgSet.lot.addEventListener(MouseEvent.ROLL_OVER, lotMouseOverHandler);
            _bgSet.lot.addEventListener(MouseEvent.ROLL_OUT, lotMouseOutHandler);
            _bgSet.library.addEventListener(MouseEvent.ROLL_OVER, libraryMouseOverHandler);
            _bgSet.library.addEventListener(MouseEvent.ROLL_OUT, libraryMouseOutHandler);
            _bgSet.raid.addEventListener(MouseEvent.ROLL_OVER, raidMouseOverHandler);
            _bgSet.raid.addEventListener(MouseEvent.ROLL_OUT, raidMouseOutHandler);
        }

        private function initSaleMC():void
        {
            _bgSet.sale.mouseEnabled = false;
            _bgSet.sale.visible = false;
            _labelContainer.mouseEnabled = false;
            _labelContainer.mouseChildren = false;
            _labelContainer.alpha = 0.0;

//            _saleDiscountLabel.styleName = "ApRemainArea";
            _saleDiscountLabel.setStyle("fontSize", 20);
            _saleDiscountLabel.setStyle("textAlign", "left");
            _saleDiscountLabel.setStyle("color",  "#ffffff");
            _saleDiscountLabel.setStyle("fontFamily",  "bradley");
            _saleDiscountLabel.setStyle("letterSpacing",  1);
            _saleDiscountLabel.setStyle("textAlign", "center");
            _saleDiscountLabel.filters = [ new GlowFilter(0x000000, 1, 1, 1, 8, 1) ];
            _saleDiscountLabel.x = _SALE_DISC_LABEL_X;
            _saleDiscountLabel.y = _SALE_DISC_LABEL_Y;
            _saleDiscountLabel.width = _LABEL_WIDTH;
            _saleDiscountLabel.height = _LABEL_HEIGHT;
            _saleDiscountLabel.mouseEnabled = false;
            _saleDiscountLabel.text = (Const.SALE_DISCOUNT_VALUES[Player.instance.avatar.saleType]*10).toString();
            _labelContainer.addChild(_saleDiscountLabel);

            _saleRestTimeLabel.styleName = "ApRemainArea";
            _saleRestTimeLabel.setStyle("fontSize", 9);
            _saleRestTimeLabel.setStyle("textAlign", "right");
            _saleRestTimeLabel.x = _SALE_TIME_LABEL_X;
            _saleRestTimeLabel.y = _SALE_TIME_LABEL_Y;
            _saleRestTimeLabel.width = _TIME_LABEL_WIDTH;
            _saleRestTimeLabel.height = _TIME_LABEL_HEIGHT;
            var lastTime:String = TimeFormat.toString(Player.instance.avatar.saleLimitRestTime);
            _saleRestTimeLabel.text = helpTextArray[11][0].replace("__SALE_TIME__",lastTime);
            _saleRestTimeLabel.mouseEnabled = false;
            _labelContainer.addChild(_saleRestTimeLabel);

            addChild(_labelContainer);

            _time = new Timer(1000);
            _time.addEventListener(TimerEvent.TIMER, updateDuration);
            _time.start();
        }

        //
        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        private function cardMouseOverHandler(e:MouseEvent):void
        {
            if (_cardToolTip == null)
            {
                _cardToolTip = ToolTipManager.createToolTip(helpTextArray[1][0], e.stageX-_TOOLTIP_OFFSET_X_CARD,e.stageY+_TOOLTIP_OFFSET_Y);
            }
        }

        private function cardMouseOutHandler(e:MouseEvent):void
        {
             if (_cardToolTip != null)
             {
                 ToolTipManager.destroyToolTip(_cardToolTip);
                 _cardToolTip =null;
             }
        }

        private function optionMouseOverHandler(e:MouseEvent):void
        {
            if (_optionToolTip == null)
            {
                _optionToolTip = ToolTipManager.createToolTip(helpTextArray[2][0], e.stageX-_TOOLTIP_OFFSET_X_OPT,e.stageY+_TOOLTIP_OFFSET_Y);
            }
        }

        private function optionMouseOutHandler(e:MouseEvent):void
        {
             if (_optionToolTip != null)
             {
                 ToolTipManager.destroyToolTip(_optionToolTip);
                 _optionToolTip =null;
             }
        }

        private function tutorialMouseOverHandler(e:MouseEvent):void
        {
            if (_tutorialToolTip == null)
            {
                _tutorialToolTip = ToolTipManager.createToolTip(helpTextArray[3][0], e.stageX-_TOOLTIP_OFFSET_X_TUTO,e.stageY+_TOOLTIP_OFFSET_Y);
            }
        }

        private function tutorialMouseOutHandler(e:MouseEvent):void
        {
             if (_tutorialToolTip != null)
             {
                 ToolTipManager.destroyToolTip(_tutorialToolTip);
                 _tutorialToolTip =null;
             }
        }

        private function battleMouseOverHandler(e:MouseEvent):void
        {
            if (_duelToolTip == null)
            {
                _duelToolTip = ToolTipManager.createToolTip(helpTextArray[4][0], e.stageX,e.stageY+_TOOLTIP_OFFSET_Y);
            }
        }

        private function battleMouseOutHandler(e:MouseEvent):void
        {
             if (_duelToolTip != null)
             {
                 ToolTipManager.destroyToolTip(_duelToolTip);
                 _duelToolTip =null;
             }
        }

        private function questMouseOverHandler(e:MouseEvent):void
        {
            if (_questToolTip == null)
            {
                _questToolTip = ToolTipManager.createToolTip(helpTextArray[5][0], e.stageX,e.stageY+_TOOLTIP_OFFSET_Y);
            }
        }

        private function questMouseOutHandler(e:MouseEvent):void
        {
             if (_questToolTip != null)
             {
                 ToolTipManager.destroyToolTip(_questToolTip);
                 _questToolTip =null;
             }
        }

        private function itemMouseOverHandler(e:MouseEvent):void
        {
            if (_itemToolTip == null)
            {
                _itemToolTip = ToolTipManager.createToolTip(helpTextArray[6][0], e.stageX-_TOOLTIP_OFFSET_X_ITEM,e.stageY+_TOOLTIP_OFFSET_Y);
            }
        }

        private function itemMouseOutHandler(e:MouseEvent):void
        {
             if (_itemToolTip != null)
             {
                 ToolTipManager.destroyToolTip(_itemToolTip);
                 _itemToolTip =null;
             }
        }

        private function shopMouseOverHandler(e:MouseEvent):void
        {
            if (_shopToolTip == null)
            {
                _shopToolTip = ToolTipManager.createToolTip(helpTextArray[7][0], e.stageX,e.stageY+_TOOLTIP_OFFSET_Y);
            }
        }

        private function shopMouseOutHandler(e:MouseEvent):void
        {
             if (_shopToolTip != null)
             {
                 ToolTipManager.destroyToolTip(_shopToolTip);
                 _shopToolTip =null;
             }
        }

        private function lotMouseOverHandler(e:MouseEvent):void
        {
            if (_lotToolTip == null)
            {
                _lotToolTip = ToolTipManager.createToolTip(helpTextArray[8][0], e.stageX-_TOOLTIP_OFFSET_X_LOT,e.stageY+_TOOLTIP_OFFSET_Y);
            }
        }

        private function lotMouseOutHandler(e:MouseEvent):void
        {
             if (_lotToolTip != null)
             {
                 ToolTipManager.destroyToolTip(_lotToolTip);
                 _lotToolTip =null;
             }
        }

        private function libraryMouseOverHandler(e:MouseEvent):void
        {
            if (_libraryToolTip == null)
            {
                _libraryToolTip = ToolTipManager.createToolTip(helpTextArray[9][0], e.stageX-_TOOLTIP_OFFSET_X_LIB,e.stageY+_TOOLTIP_OFFSET_Y);
            }
        }

        private function libraryMouseOutHandler(e:MouseEvent):void
        {
             if (_libraryToolTip != null)
             {
                 ToolTipManager.destroyToolTip(_libraryToolTip);
                 _libraryToolTip =null;
             }
        }

        private function raidMouseOverHandler(e:MouseEvent):void
        {
            if (_raidToolTip == null)
            {
                _raidToolTip = ToolTipManager.createToolTip(helpTextArray[10][0], e.stageX,e.stageY+_TOOLTIP_OFFSET_Y);
            }
        }

        private function raidMouseOutHandler(e:MouseEvent):void
        {
             if (_raidToolTip != null)
             {
                 ToolTipManager.destroyToolTip(_raidToolTip);
                 _raidToolTip =null;
             }
        }

        private function updateDuration(e:Event):void
        {
            var lastTime:String = TimeFormat.toString(Player.instance.avatar.saleLimitRestTime);
            _saleRestTimeLabel.text = helpTextArray[11][0].replace("__SALE_TIME__",lastTime);
            _saleDiscountLabel.text = (Const.SALE_DISCOUNT_VALUES[Player.instance.avatar.saleType]*10).toString();
        }
        public function getShowSaleMCThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (Player.instance.avatar.isSaleTime) {
                pExec.addThread(new BeTweenAS3Thread(_bgSet.sale, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                pExec.addThread(new BeTweenAS3Thread(_labelContainer, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            } else {
                _bgSet.sale.visible = false;
                _labelContainer.visible = false;
            }
            return pExec;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(super.getShowThread(stage, at));
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(getShowSaleMCThread());
            pExec.addThread(new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            sExec.addThread(pExec);
            return sExec;
        }

        public override  function getHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            sExec.addThread(super.getHideThread());
            return sExec;
        }

        public function getHideSaleMCThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            // セール表示を隠す
            pExec.addThread(new BeTweenAS3Thread(_bgSet.sale, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_labelContainer, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            return pExec;
        }

        public function rankingUpdate():void
        {
            _ranking.update();
        }
        private function serialMouseClickHandler(event:Event):void
        {
            _serialInputPanel.show();
        }

        private function infoClickHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_DEBUG,this,"Info Click!");
            _eventInfoPanel.show();
        }

    }

}
