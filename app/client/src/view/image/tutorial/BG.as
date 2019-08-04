package view.image.tutorial
{

    import flash.display.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import flash.filters.GlowFilter;

    import mx.containers.*;
    import mx.controls.*;

    import model.DeckEditor;
    import model.events.*;
    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class BG extends BaseImage
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_INTRO	:String = "ゲーム導入";
        CONFIG::LOCALE_JP
        private static const _TRANS_DESC	:String = "ゲーム説明";
        CONFIG::LOCALE_JP
        private static const _TRANS_BATTLE	:String = "バトルの流れ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHANGE	:String = "キャラ交代";
        CONFIG::LOCALE_JP
        private static const _TRANS_HILOW	:String = "ボーナスゲーム";
        CONFIG::LOCALE_JP
        private static const _TRANS_BONUS	:String = "バトルボーナス";
        CONFIG::LOCALE_JP
        private static const _TRANS_EVENT	:String = "イベントカード";
        CONFIG::LOCALE_JP
        private static const _TRANS_ENTRANCE	:String = "エントランス";
        CONFIG::LOCALE_JP
        private static const _TRANS_AVATAR	:String = "アバター";
        CONFIG::LOCALE_JP
        private static const _TRANS_QUEST	:String = "クエスト";
        CONFIG::LOCALE_JP
        private static const _TRANS_DECKEDIT	:String = "デッキエディット";
        CONFIG::LOCALE_JP
        private static const _TRANS_MATCH	:String = "マッチングロビー";
        CONFIG::LOCALE_JP
        private static const _TRANS_ITEM	:String = "アイテム";
        CONFIG::LOCALE_JP
        private static const _TRANS_SHOP	:String = "ショップ";
        CONFIG::LOCALE_JP
        private static const _TRANS_COMPO	:String = "武器合成";

        CONFIG::LOCALE_EN
        private static const _TRANS_INTRO	:String = "Introduction";
        CONFIG::LOCALE_EN
        private static const _TRANS_DESC	:String = "Game Description";
        CONFIG::LOCALE_EN
        private static const _TRANS_BATTLE	:String = "Battle Sequence";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHANGE	:String = "Character Switching";
        CONFIG::LOCALE_EN
        private static const _TRANS_HILOW	:String = "Bonus Game";
        CONFIG::LOCALE_EN
        private static const _TRANS_BONUS	:String = "Battle Bonuses";
        CONFIG::LOCALE_EN
        private static const _TRANS_EVENT	:String = "Event Cards";
        CONFIG::LOCALE_EN
        private static const _TRANS_ENTRANCE	:String = "Entrance";
        CONFIG::LOCALE_EN
        private static const _TRANS_AVATAR	:String = "Avatar";
        CONFIG::LOCALE_EN
        private static const _TRANS_QUEST	:String = "Quest";
        CONFIG::LOCALE_EN
        private static const _TRANS_DECKEDIT	:String = "Deck Editing";
        CONFIG::LOCALE_EN
        private static const _TRANS_MATCH	:String = "Matching Lobby";
        CONFIG::LOCALE_EN
        private static const _TRANS_ITEM	:String = "Item";
        CONFIG::LOCALE_EN
        private static const _TRANS_SHOP	:String = "Shop";
        CONFIG::LOCALE_EN
        private static const _TRANS_COMPO	:String = "";

        CONFIG::LOCALE_TCN
        private static const _TRANS_INTRO	:String = "遊戲簡介";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DESC	:String = "遊戲說明";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BATTLE	:String = "戰鬥流程";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHANGE	:String = "交換角色";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HILOW	:String = "獎勵遊戲";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BONUS	:String = "戰鬥獎勵";
        CONFIG::LOCALE_TCN
        private static const _TRANS_EVENT	:String = "事件卡";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ENTRANCE	:String = "入口";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AVATAR	:String = "虛擬人物";
        CONFIG::LOCALE_TCN
        private static const _TRANS_QUEST	:String = "任務";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DECKEDIT	:String = "牌組編輯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MATCH	:String = "對戰大廳";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ITEM	:String = "道具";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SHOP	:String = "商店";
        CONFIG::LOCALE_TCN
        private static const _TRANS_COMPO	:String = "武器合成";

        CONFIG::LOCALE_SCN
        private static const _TRANS_INTRO	:String = "导入游戏";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DESC	:String = "游戏说明";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BATTLE	:String = "战斗流程";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHANGE	:String = "角色替换";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HILOW	:String = "奖励游戏";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BONUS	:String = "战斗奖励";
        CONFIG::LOCALE_SCN
        private static const _TRANS_EVENT	:String = "活动卡";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ENTRANCE	:String = "进口";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AVATAR	:String = "虚拟人物";
        CONFIG::LOCALE_SCN
        private static const _TRANS_QUEST	:String = "任务";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DECKEDIT	:String = "卡组编辑";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MATCH	:String = "对战大厅";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ITEM	:String = "道具";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SHOP	:String = "商店";
        CONFIG::LOCALE_SCN
        private static const _TRANS_COMPO	:String = "";

        CONFIG::LOCALE_KR
        private static const _TRANS_INTRO	:String = "게임 도입";
        CONFIG::LOCALE_KR
        private static const _TRANS_DESC	:String = "게임 설명";
        CONFIG::LOCALE_KR
        private static const _TRANS_BATTLE	:String = "배틀의 흐름";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHANGE	:String = "캐릭 교체";
        CONFIG::LOCALE_KR
        private static const _TRANS_HILOW	:String = "보너스 게임";
        CONFIG::LOCALE_KR
        private static const _TRANS_BONUS	:String = "배틀 보너스";
        CONFIG::LOCALE_KR
        private static const _TRANS_EVENT	:String = "이벤트 카드";
        CONFIG::LOCALE_KR
        private static const _TRANS_ENTRANCE	:String = "엔터란스";
        CONFIG::LOCALE_KR
        private static const _TRANS_AVATAR	:String = "아바타";
        CONFIG::LOCALE_KR
        private static const _TRANS_QUEST	:String = "퀘스트";
        CONFIG::LOCALE_KR
        private static const _TRANS_DECKEDIT	:String = "덱 에디터";
        CONFIG::LOCALE_KR
        private static const _TRANS_MATCH	:String = "매칭 로비";
        CONFIG::LOCALE_KR
        private static const _TRANS_ITEM	:String = "아이템";
        CONFIG::LOCALE_KR
        private static const _TRANS_SHOP	:String = "샵";
        CONFIG::LOCALE_KR
        private static const _TRANS_COMPO	:String = "武器合成";

        CONFIG::LOCALE_FR
        private static const _TRANS_INTRO	:String = "Entrer";
        CONFIG::LOCALE_FR
        private static const _TRANS_DESC	:String = "A propos du jeu";
        CONFIG::LOCALE_FR
        private static const _TRANS_BATTLE	:String = "Comment jouer";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHANGE	:String = "Changer de personnage";
        CONFIG::LOCALE_FR
        private static const _TRANS_HILOW	:String = "Bonus Game";
        CONFIG::LOCALE_FR
        private static const _TRANS_BONUS	:String = "Battle Bonus";
        CONFIG::LOCALE_FR
        private static const _TRANS_EVENT	:String = "Carte événement";
        CONFIG::LOCALE_FR
        private static const _TRANS_ENTRANCE	:String = "Entrée ";
        CONFIG::LOCALE_FR
        private static const _TRANS_AVATAR	:String = "Avatar";
        CONFIG::LOCALE_FR
        private static const _TRANS_QUEST	:String = "Quête";
        CONFIG::LOCALE_FR
        private static const _TRANS_DECKEDIT	:String = "Editer la pioche";
        CONFIG::LOCALE_FR
        private static const _TRANS_MATCH	:String = "Hall";
        CONFIG::LOCALE_FR
        private static const _TRANS_ITEM	:String = "Objet";
        CONFIG::LOCALE_FR
        private static const _TRANS_SHOP	:String = "Magasin";
        CONFIG::LOCALE_FR
        private static const _TRANS_COMPO	:String = "";

        CONFIG::LOCALE_ID
        private static const _TRANS_INTRO	:String = "ゲーム導入";
        CONFIG::LOCALE_ID
        private static const _TRANS_DESC	:String = "ゲーム説明";
        CONFIG::LOCALE_ID
        private static const _TRANS_BATTLE	:String = "バトルの流れ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHANGE	:String = "キャラ交代";
        CONFIG::LOCALE_ID
        private static const _TRANS_HILOW	:String = "ボーナスゲーム";
        CONFIG::LOCALE_ID
        private static const _TRANS_BONUS	:String = "バトルボーナス";
        CONFIG::LOCALE_ID
        private static const _TRANS_EVENT	:String = "イベントカード";
        CONFIG::LOCALE_ID
        private static const _TRANS_ENTRANCE	:String = "エントランス";
        CONFIG::LOCALE_ID
        private static const _TRANS_AVATAR	:String = "アバター";
        CONFIG::LOCALE_ID
        private static const _TRANS_QUEST	:String = "クエスト";
        CONFIG::LOCALE_ID
        private static const _TRANS_DECKEDIT	:String = "デッキエディット";
        CONFIG::LOCALE_ID
        private static const _TRANS_MATCH	:String = "マッチングロビー";
        CONFIG::LOCALE_ID
        private static const _TRANS_ITEM	:String = "アイテム";
        CONFIG::LOCALE_ID
        private static const _TRANS_SHOP	:String = "ショップ";
        CONFIG::LOCALE_ID
        private static const _TRANS_COMPO	:String = "武器合成";

        CONFIG::LOCALE_TH
        private static const _TRANS_INTRO   :String = "บทนำเกม";//"ゲーム導入";
        CONFIG::LOCALE_TH
        private static const _TRANS_DESC    :String = "อธิบายเกม";//"ゲーム説明";
        CONFIG::LOCALE_TH
        private static const _TRANS_BATTLE  :String = "วิธีการต่อสู้";//"バトルの流れ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHANGE  :String = "การเปลี่ยนตัวละคร";//"キャラ交代";
        CONFIG::LOCALE_TH
        private static const _TRANS_HILOW   :String = "เกมโบนัส";//"ボーナスゲーム";
        CONFIG::LOCALE_TH
        private static const _TRANS_BONUS   :String = "แบทเทิลโบนัส";//"バトルボーナス";
        CONFIG::LOCALE_TH
        private static const _TRANS_EVENT   :String = "อีเวนท์การ์ด";//"イベントカード";
        CONFIG::LOCALE_TH
        private static const _TRANS_ENTRANCE    :String = "ทางเข้า";//"エントランス";
        CONFIG::LOCALE_TH
        private static const _TRANS_AVATAR  :String = "อวาตาร์";
        CONFIG::LOCALE_TH
        private static const _TRANS_QUEST   :String = "เควส";
        CONFIG::LOCALE_TH
        private static const _TRANS_DECKEDIT    :String = "แก้ไขสำรับ";//"デッキエディット";
        CONFIG::LOCALE_TH
        private static const _TRANS_MATCH   :String = "ห้องจับคู่ประลอง";//"マッチングロビー";
        CONFIG::LOCALE_TH
        private static const _TRANS_ITEM    :String = "ไอเท็ม";//"アイテム";
        CONFIG::LOCALE_TH
        private static const _TRANS_SHOP    :String = "ร้านค้า";//"ショップ";
        CONFIG::LOCALE_TH
        private static const _TRANS_COMPO	:String = "武器合成";


        // HP表示元SWF
        [Embed(source="../../../../data/image/tutorial/tut_list.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        private static const LIST_BTNS:Array = [
            "btn_list0",
            "btn_list1",
            "btn_list2",
            "btn_list3",
            "btn_list4",
            "btn_list5",
            "btn_list6",
            "btn_list7",
            "btn_list8",
            "btn_list9",
            "btn_list10",
            "btn_list11",
            "btn_list12",
            "btn_list13",
            ];

        // 更新時イベント
        public static const UPDATE_SELECT:String = "update_select";

        // ジャンルラベル
        private var _genre:Label = new Label();

        // ラベル
        private var _labels:Array = [new Label(),new Label(),
                                     new Label(),new Label(),
                                     new Label(),new Label(),
                                     new Label(),new Label(),
                                     new Label(),new Label(),
                                     new Label(),new Label(),
                                     new Label(),new Label()];

        // レジスト
//        private var _registTexts:Array = ["ゲーム導入"];
        private var _registTexts:Array = [_TRANS_INTRO];

        // メニュー
//        private var _menuTexts:Array = ["ゲーム説明","エントランス","アバター","クエスト","バトル",
//                                        "デッキエディット", "マッチングロビー","マルチバトル","アイテム","ショップ"];
        private var _menuTexts:Array = [_TRANS_DESC, _TRANS_BATTLE,
                                        _TRANS_CHANGE, _TRANS_HILOW,
                                        _TRANS_BONUS, _TRANS_EVENT,
                                        _TRANS_ENTRANCE,_TRANS_AVATAR,
                                        _TRANS_QUEST,_TRANS_DECKEDIT,
                                        _TRANS_MATCH,_TRANS_ITEM,
                                        _TRANS_SHOP,_TRANS_COMPO,
            ];

        // メニューボタン
        private var _menuButton:Array;
        // メニュー内ボタン
        private var _inMenuButton:Array;

        // 現在のビューの番号
        private var _viewType:int = 0;

        // ビューの定数
        private static const _REGIST:int = -1;
        private static const _DEFAULT:int = 0;
        private static const _OUTLINE:int = 1;
        private static const _BATTLE:int = 2;
        private static const _CHANGE:int = 3;
        private static const _HILOW:int = 4;
        private static const _BONUS:int = 5;
        private static const _EVENT:int = 6;
        private static const _ENTRANCE:int = 7;
        private static const _AVATAR:int = 8;
        private static const _QUEST:int = 9;
        private static const _EDIT:int = 10;
        private static const _MATCH:int = 11;
        private static const _ITEM:int = 12;
        private static const _SHOP:int = 13;
        private static const _COMPO:int = 14;

        // 位置定数
        private static const _EL_X:int = 211;
        private static const _EL_Y:int = 182;
        private static const _EL_OFFSET_X:int = 175;
        private static const _EL_OFFSET_Y:int = 48;

        private static const _SB_X:int = 298;
        private static const _SB_Y:int = 310;
        private static const _SB_OFFSET_Y:int = 48;


        private static const _MAIN_MAX:int = 13;
        private static const _SUB_MAX:int = 7;


        /**
         * コンストラクタ
         *
         */
        public function BG()
        {
            _viewType = _DEFAULT;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);

            registEvent();
            initLabel();

            updateLabel();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        // ビューの番号
        public function set viewType(t:int):void
        {
            _viewType = t;
        }
        public function get viewType():int
        {
            return _viewType;
        }


        // イベント設定
        private function registEvent():void
        {
            MovieClip(_root.getChildByName("sub")).getChildByName("btn_back").visible = false;

            var addFuncs:Array = [pushList0Handler,pushList1Handler,
                                  pushList2Handler,pushList3Handler,
                                  pushList4Handler,pushList5Handler,
                                  pushList6Handler,pushList7Handler,
                                  pushList8Handler,pushList9Handler,
                                  pushList10Handler,pushList11Handler,
                                  pushList12Handler,pushList13Handler
                ];
            _menuButton = [];
            for (var i:int = 0; i < _menuTexts.length; i++) {
                var btn:SimpleButton = SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName(LIST_BTNS[i]));
                btn.addEventListener(MouseEvent.CLICK,addFuncs[i]);
                _menuButton.push(btn);
            }

            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list0")).addEventListener(MouseEvent.CLICK, pushList0Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list1")).addEventListener(MouseEvent.CLICK, pushList1Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list2")).addEventListener(MouseEvent.CLICK, pushList2Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list3")).addEventListener(MouseEvent.CLICK, pushList3Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list4")).addEventListener(MouseEvent.CLICK, pushList4Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list5")).addEventListener(MouseEvent.CLICK, pushList5Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list6")).addEventListener(MouseEvent.CLICK, pushList6Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list7")).addEventListener(MouseEvent.CLICK, pushList7Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list8")).addEventListener(MouseEvent.CLICK, pushList8Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list9")).addEventListener(MouseEvent.CLICK, pushList9Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list10")).addEventListener(MouseEvent.CLICK, pushList10Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list11")).addEventListener(MouseEvent.CLICK, pushList11Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list12")).addEventListener(MouseEvent.CLICK, pushList12Handler);
            // SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list13")).addEventListener(MouseEvent.CLICK, pushList13Handler);

            // _menuButton = [SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list0")), SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list1")),
            //                SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list2")), SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list3")),
            //                SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list4")), SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list5")),
            //                SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list6")), SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list7")),
            //                SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list8")), SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list9")),
            //                SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list10")), SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list11")),
            //                SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list12")), SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list13"))
            //     ];

            _inMenuButton = [SimpleButton(MovieClip(_root.getChildByName("sub")).getChildByName("btn_list_sub0")), SimpleButton(MovieClip(_root.getChildByName("sub")).getChildByName("btn_list_sub1")),
                             SimpleButton(MovieClip(_root.getChildByName("sub")).getChildByName("btn_list_sub2")), SimpleButton(MovieClip(_root.getChildByName("sub")).getChildByName("btn_list_sub3")),
                             SimpleButton(MovieClip(_root.getChildByName("sub")).getChildByName("btn_list_sub4")), SimpleButton(MovieClip(_root.getChildByName("sub")).getChildByName("btn_list_sub5")),
                             SimpleButton(MovieClip(_root.getChildByName("sub")).getChildByName("btn_list_sub6"))];
        }

        // イベント設定
        public function removeEvent():void
        {
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list0")).removeEventListener(MouseEvent.CLICK, pushList0Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list1")).removeEventListener(MouseEvent.CLICK, pushList1Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list2")).removeEventListener(MouseEvent.CLICK, pushList2Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list3")).removeEventListener(MouseEvent.CLICK, pushList3Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list4")).removeEventListener(MouseEvent.CLICK, pushList4Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list5")).removeEventListener(MouseEvent.CLICK, pushList5Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list6")).removeEventListener(MouseEvent.CLICK, pushList6Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list7")).removeEventListener(MouseEvent.CLICK, pushList7Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list8")).removeEventListener(MouseEvent.CLICK, pushList8Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list9")).removeEventListener(MouseEvent.CLICK, pushList9Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list10")).removeEventListener(MouseEvent.CLICK, pushList10Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list11")).removeEventListener(MouseEvent.CLICK, pushList11Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list12")).removeEventListener(MouseEvent.CLICK, pushList12Handler);
            SimpleButton(MovieClip(_root.getChildByName("list")).getChildByName("btn_list13")).removeEventListener(MouseEvent.CLICK, pushList13Handler);
        }

        // メニューからのボタンを押したときのイベント
        private function pushList0Handler(e:MouseEvent):void
        {
            _viewType = 1;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList1Handler(e:MouseEvent):void
        {
            _viewType = 2;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList2Handler(e:MouseEvent):void
        {
            _viewType = 3;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList3Handler(e:MouseEvent):void
        {
            _viewType = 4;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList4Handler(e:MouseEvent):void
        {
            _viewType = 5;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList5Handler(e:MouseEvent):void
        {
            _viewType = 6;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList6Handler(e:MouseEvent):void
        {
            _viewType = 7;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList7Handler(e:MouseEvent):void
        {
            _viewType = 8;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList8Handler(e:MouseEvent):void
        {
            _viewType = 9;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList9Handler(e:MouseEvent):void
        {
            _viewType = 10;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList10Handler(e:MouseEvent):void
        {
            _viewType = 11;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList11Handler(e:MouseEvent):void
        {
            _viewType = 12;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList12Handler(e:MouseEvent):void
        {
            _viewType = 13;
            dispatchEvent(new Event(UPDATE_SELECT));
        }
        private function pushList13Handler(e:MouseEvent):void
        {
            _viewType = 14;
            dispatchEvent(new Event(UPDATE_SELECT));
        }

        // ラベルの初期化
        private function initLabel():void
        {
            for(var i:int = 0; i < _labels.length; i++)
            {
                _labels[i].width = 125;
                _labels[i].height = 25;
                _labels[i].mouseChildren = false;
                _labels[i].mouseEnabled = false;
                _labels[i].styleName = "TutorialTitle";
                _labels[i].filters = [
                    new GlowFilter(0x000000, 1, 2, 2, 16, 1),
//                  new DropShadowFilter(2, 45, 0x000000, 1, 2, 2, 16)
                    ];

                addChild(_labels[i]);
            }
            _genre.x = 298;
            _genre.y = 262;
            _genre.width = 125;
            _genre.height = 25;
            _genre.alpha = 0.4;
//             _genre.mouseEnabled = false;
//             _genre.mouseChildren = false;
            _genre.styleName = "TutorialTitle";
            _genre.filters = [
                new GlowFilter(0x000000, 1, 2, 2, 16, 1),
//                  new DropShadowFilter(2, 45, 0x000000, 1, 2, 2, 16)
                ];
            addChild(_genre);
        }

        // ラベルの更新
        public function updateLabel():void
        {
            var i:int;
            switch (_viewType)
            {
            case _REGIST:
                break;
            case _DEFAULT:
                for(i = 0; i < _labels.length; i++)
                {
                    _labels[i].x = _EL_X + (i%2) * _EL_OFFSET_X;
                    _labels[i].y = _EL_Y + int(i/2) * _EL_OFFSET_Y;
                    _labels[i].text = _menuTexts[i];
                    _labels[i].visible = true;
                    // アバターだけ灰色表示
                    if(i == 7)
                    {
                        _labels[i].alpha = 0.5;
                    }
                }
                for(i = 0; i < _menuButton.length; i++)
                {
                    if(_labels[i] == null)
                    {
                        _menuButton[i].visible = false;
                        _menuButton[i].mouseEnabled = false;
                    }
                }
                for(i = 0; i < _inMenuButton.length; i++)
                {
                    _inMenuButton[i].visible = false;
                    _inMenuButton[i].mouseEnabled = false;
                }
                break;
            default:
            }
        }

//         public function onList():void
//         {
//             waitComplete(onListComplete);
//         }

//         public function onListComplete():void
//         {
//             _root.gotoAndStop("list");
//         }

//         public function onSub():void
//         {
//             waitComplete(onSubComplete);
//         }

//         public function onSubComplete():void
//         {
//             _root.gotoAndStop("sub");
//         }

        public function onExit():void
        {
            waitComplete(onExitComplete);
        }

        public function onExitComplete():void
        {
            _root.gotoAndStop("exit");
        }

    }

}
