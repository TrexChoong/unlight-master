package view.image.match
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;

    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;

    import view.image.BaseImage;
    import view.utils.*;
    import controller.TitleCtrl;

    import model.Option;

    /**
     * 部屋作成パネルクラス
     *
     */

    public class RoomCreatePanel extends Panel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_GREET	:String = "よろしくお願いします";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP1	:String = "レーデンベルグ城";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP2	:String = "誘惑の森";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP3	:String = "掃き溜めの街道";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP4	:String = "氷結の湖畔";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP5	:String = "人魂墓地";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP6	:String = "最果ての村";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP7	:String = "嵐の荒野";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP8	:String = "フォーンハイル遺跡";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP9	:String = "魔都ローゼンブルグ";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP10	:String = "狂気山脈";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAKEROOM	:String = "対戦ルーム作成";
        CONFIG::LOCALE_JP
        private static const _TRANS_ROOMNAME	:String = "部屋名";
        CONFIG::LOCALE_JP
        private static const _TRANS_DUELSTAGE	:String = "対戦ステージ";
        CONFIG::LOCALE_JP
        private static const _TRANS_DUELRULE	:String = "対戦ルール";

        CONFIG::LOCALE_EN
        private static const _TRANS_GREET	:String = "Normal Battle";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP1	:String = "Reighdenberg Castle";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP2	:String = "The Enchanted Forest";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP3	:String = "The Junk Road";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP4	:String = "A Frozen Lakeside";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP5	:String = "Soulmist Cemetery";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP6	:String = "The Village at the End of the World";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP7	:String = "Tempest Plains";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP8	:String = "Fornheil Ruins";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP9	:String = "Rosenburg, City of the Damned";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP10	:String = "Mountains of Madness";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAKEROOM	:String = "Create Battle Room";
        CONFIG::LOCALE_EN
        private static const _TRANS_ROOMNAME	:String = "Room Name";
        CONFIG::LOCALE_EN
        private static const _TRANS_DUELSTAGE	:String = "Arena";
        CONFIG::LOCALE_EN
        private static const _TRANS_DUELRULE	:String = "Battle Rules";

        CONFIG::LOCALE_TCN
        private static const _TRANS_GREET	:String = "請多關照";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP1	:String = "雷德貝魯格城";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP2	:String = "誘惑森林";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP3	:String = "垃圾之街";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP4	:String = "冰封湖畔";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP5	:String = "人魂墓地";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP6	:String = "盡頭之村";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP7	:String = "風暴荒野";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP8	:String = "峰亥盧遺跡";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP9	:String = "魔都羅占布爾克";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP10	:String = "瘋狂山脈";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAKEROOM	:String = "創建對戰房間";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ROOMNAME	:String = "房間名";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DUELSTAGE	:String = "對戰地點";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DUELRULE	:String = "對戰規則";

        CONFIG::LOCALE_SCN
        private static const _TRANS_GREET	:String = "请多指教";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP1	:String = "雷德贝鲁格城";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP2	:String = "诱惑之森";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP3	:String = "无法清扫的街道";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP4	:String = "冰冻的湖畔";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP5	:String = "人魂墓地";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP6	:String = "尽头之村";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP7	:String = "暴风雨的荒野";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP8	:String = "藩骸儿的遗迹";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP9	:String = "魔都罗占布尔克";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP10	:String = "疯狂山脉";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAKEROOM	:String = "创建对战室";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ROOMNAME	:String = "对战室的名称";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DUELSTAGE	:String = "对战台";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DUELRULE	:String = "对战规则";

        CONFIG::LOCALE_KR
        private static const _TRANS_GREET	:String = "잘 부탁드리겠습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP1	:String = "레덴베르그 성";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP2	:String = "유혹의 숲";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP3	:String = "쓰레기가 쌓인 궤도";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP4	:String = "빙결의 호반";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP5	:String = "도깨비불 묘지";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP6	:String = "세상 끝의 마을";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP7	:String = "돌풍의 황야";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP8	:String = "폰하일 유적";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP9	:String = "마도 로젠부르그";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP10	:String = "광기산맥";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAKEROOM	:String = "대전룸 작성";
        CONFIG::LOCALE_KR
        private static const _TRANS_ROOMNAME	:String = "룸 이름";
        CONFIG::LOCALE_KR
        private static const _TRANS_DUELSTAGE	:String = "대전 스테이지";
        CONFIG::LOCALE_KR
        private static const _TRANS_DUELRULE	:String = "대전 룰";

        CONFIG::LOCALE_FR
        private static const _TRANS_GREET	:String = "Bonjour";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP1	:String = "Château Reighdenberg";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP2	:String = "Forêt Enchantée";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP3	:String = "Chemin de Fatras";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP4	:String = "Lac Gelé";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP5	:String = "Cimetière aux Âmes";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP6	:String = "Village aux Confins du Monde";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP7	:String = "Désert Tempétueux";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP8	:String = "Vestiges de Phornhyle";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP9	:String = "Ville diabolique Rosenbourg";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP10	:String = "Les Monts Déments";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAKEROOM	:String = "Créer une Salle de duel en ligne";
        CONFIG::LOCALE_FR
        private static const _TRANS_ROOMNAME	:String = "Nom de la Salle";
        CONFIG::LOCALE_FR
        private static const _TRANS_DUELSTAGE	:String = "Hall de Duel ";
        CONFIG::LOCALE_FR
        private static const _TRANS_DUELRULE	:String = "Règle des duels en ligne";

        CONFIG::LOCALE_ID
        private static const _TRANS_GREET	:String = "よろしくお願いします";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP1	:String = "レーデンベルグ城";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP2	:String = "誘惑の森";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP3	:String = "掃き溜めの街道";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP4	:String = "氷結の湖畔";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP5	:String = "人魂墓地";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP6	:String = "最果ての村";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP7	:String = "嵐の荒野";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP8	:String = "フォーンハイル遺跡";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP9	:String = "魔都ローゼンブルグ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP10	:String = "狂気山脈";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAKEROOM	:String = "対戦ルーム作成";
        CONFIG::LOCALE_ID
        private static const _TRANS_ROOMNAME	:String = "部屋名";
        CONFIG::LOCALE_ID
        private static const _TRANS_DUELSTAGE	:String = "対戦ステージ";
        CONFIG::LOCALE_ID
        private static const _TRANS_DUELRULE	:String = "対戦ルール";

        CONFIG::LOCALE_TH
        private static const _TRANS_GREET   :String = "ขอความกรุณาด้วย";//"よろしくお願いします";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP1    :String = "ปราสาทเรเดนเบิร์ก";//"レーデンベルグ城";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP2    :String = "ป่ามนต์เสน่ห์";//"誘惑の森";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP3    :String = "ถนนกองขยะ";//"掃き溜めの街道";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP4    :String = "ขอบทะเลสาปน้ำแข็ง";//"氷結の湖畔";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP5    :String = "สุสานวิญญาณ";//"人魂墓地";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP6    :String = "หมู่บ้านสุดขอบโลก";//"最果ての村";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP7    :String = "ทะเลทรายแห่งพายุ";//"嵐の荒野";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP8    :String = "ซากโบราณฟอนไฮล์";//"フォーンハイル遺跡";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP9    :String = "เมืองปิศาจโรเธนเบิร์ก";//"魔都ローゼンブルグ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP10   :String = "หุบเขาแห่งความคลั่ง";//"狂気山脈";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAKEROOM    :String = "สร้างห้องประลอง";//"対戦ルーム作成";
        CONFIG::LOCALE_TH
        private static const _TRANS_ROOMNAME    :String = "ชื่อห้อง";//"部屋名";
        CONFIG::LOCALE_TH
        private static const _TRANS_DUELSTAGE   :String = "สนามประลอง";//"対戦ステージ";
        CONFIG::LOCALE_TH
        private static const _TRANS_DUELRULE    :String = "กฎการประลอง";//"対戦ルール";


        // イベント定数
        public static const CREATE_ROOM:String = "create_room";
        public static const CREATE_ROOM_CANCEL:String = "create_room_cancel";
        public static const CLICK_ROOM_CREATE_BUTTON:String = "click_room_create_button";

        // 内包するデータ
//        private var _roomName:String = "よろしくお願いします";
        private var _roomName:String = _TRANS_GREET;
        private var _duelStage:int = 0;
        private var _duelRule:int = 0;

        // タイトル表示
        private var _roomNameLabel:Label = new Label();
        private var _duelStageLabel:Label = new Label();
        private var _duelRuleLabel:Label = new Label();

        private var _roomNameArea:ValidTextInput = new ValidTextInput(false,ValidTextInput.ROOM_NAME);
        private var _duelStageComboBox:ComboBox = new ComboBox();
        private var _duelRuleComboBox:ComboBox = new ComboBox();
        private var _okButton:Button = new Button();
        private var _cancelButton:Button = new Button();

        private var _heartImage:HeartImage = new HeartImage();
        private var _heartText:Label = new Label();

        // combobox用のdataset
//        private const _DUEL_STAGE:ArrayCollection = new ArrayCollection(["レーデンベルグ城",
//                                                                         "誘惑の森",
//                                                                         "掃き溜めの街道",
//                                                                         "氷結の湖畔",
//                                                                         "人魂墓地",
//                                                                         "最果ての村",
//                                                                         "嵐の荒野",
//                                                                         "フォーンハイル遺跡",
//                                                                            ]);
        private const _DUEL_STAGE:ArrayCollection = new ArrayCollection([_TRANS_MAP1,
                                                                         _TRANS_MAP2,
                                                                         _TRANS_MAP3,
                                                                         _TRANS_MAP4,
                                                                         _TRANS_MAP5,
                                                                         _TRANS_MAP6,
                                                                         _TRANS_MAP7,
                                                                         _TRANS_MAP8,
                                                                         _TRANS_MAP9,
                                                                         _TRANS_MAP10,
                                                                            ]);

        private const _DUEL_RULE:ArrayCollection = new ArrayCollection(["1vs1",
                                                                        "3vs3"]);


        /**
         * コンストラクタ
         *
         */
        public function RoomCreatePanel()
        {
            super();
            x = 230;
            y = 200;
            width  = 320;
            height = 225;
        CONFIG::LOCALE_EN
        {
            x = 210;
            width  = 390;
        }
        CONFIG::LOCALE_FR
        {
            width  = 390;
        }
            layout = "absolute"

//            title = "対戦ルーム作成";
            title = _TRANS_MAKEROOM;

//            _roomNameLabel.text = "部屋名";
            _roomNameLabel.text = _TRANS_ROOMNAME;
            _roomNameLabel.x = 30;
            _roomNameLabel.y = 50;
//            _duelStageLabel.text = "対戦ステージ";
            _duelStageLabel.text = _TRANS_DUELSTAGE;
            _duelStageLabel.x = 30;
            _duelStageLabel.y = 90;
//            _duelRuleLabel.text = "対戦ルール";
            _duelRuleLabel.text = _TRANS_DUELRULE;
            _duelRuleLabel.x = 30;
            _duelRuleLabel.y = 130;
            _duelStageLabel.styleName = "createPanelLabel";
            _roomNameLabel.styleName =  "createPanelLabel";
            _duelRuleLabel.styleName =  "createPanelLabel";


            _duelStageComboBox.dataProvider = _DUEL_STAGE;
            _duelRuleComboBox.dataProvider = _DUEL_RULE;

            _duelStageComboBox.x = 120;
            _duelStageComboBox.y = 88;
        CONFIG::LOCALE_EN
        {
            _duelStageComboBox.x = 100;
        }
            _duelRuleComboBox.x = 120;
            _duelRuleComboBox.y = 128;
        CONFIG::LOCALE_EN
        {
            _duelRuleComboBox.x = 220;
        }
        CONFIG::LOCALE_FR
        {
            _duelRuleComboBox.x = 220;
        }

            _roomNameArea.x = 120;
        CONFIG::LOCALE_EN
        {
            _roomNameArea.x = 180;
        }
        CONFIG::LOCALE_FR
        {
            _roomNameArea.x = 180;
        }
            _roomNameArea.y = 50;
            _roomNameArea.width = 150;
            _roomNameArea.height = 20;
            _roomNameArea.text = _roomName;
            _roomNameArea.styleName = "CreateRoomPanelName";
            _roomNameArea.restrict = "^\",";
            _roomNameArea.maxChars = 32;


            _okButton.label = "ok";
            _okButton.x = 60;
            _okButton.y = 180;
            _okButton.width = 80;
            _okButton.height = 20;
        CONFIG::LOCALE_EN
        {
            _okButton.x = 110;
        }
        CONFIG::LOCALE_FR
        {
            _okButton.x = 110;
        }

            _cancelButton.label = "cancel";
            _cancelButton.x = 160;
            _cancelButton.y = 180;
            _cancelButton.width = 80;
            _cancelButton.height = 20;
        CONFIG::LOCALE_EN
        {
            _cancelButton.x = 210;
        }
        CONFIG::LOCALE_FR
        {
            _cancelButton.x = 210;
        }

            _heartImage.x = 220;
        CONFIG::LOCALE_EN
        {
            _heartImage.x = 310;
        }
        CONFIG::LOCALE_FR
        {
            _heartImage.x = 310;
        }
            _heartImage.y = 133;

            _heartText.x = 235;
        CONFIG::LOCALE_EN
        {
            _heartText.x = 325;
        }
        CONFIG::LOCALE_FR
        {
            _heartText.x = 325;
        }
            _heartText.y = 131;
            _heartText.width = 30;
            _heartText.height = 20;
            _heartText.text = "x2";
            _heartText.styleName = "RoomCreateHeartLabel";

            addChild(_okButton);
            addChild(_cancelButton);
            addChild(_roomNameLabel);
            addChild(_duelRuleLabel);
            addChild(_duelStageLabel);
            addChild(_heartImage);
            addChild(_heartText);

            addChild(_roomNameArea);
            addChild(_duelStageComboBox);
            addChild(_duelRuleComboBox);

            _roomNameArea.addEventListener(FlexEvent.ENTER, enterKeyDownHandler);
            _duelRuleComboBox.addEventListener(ListEvent.CHANGE, ruleChangeHandler);
            _duelStageComboBox.addEventListener(ListEvent.CHANGE, stageChangeHandler);
            _okButton.addEventListener(MouseEvent.CLICK, mouseHandler);
            _roomNameArea.addEventListener(ValidTextInput.VALID_OK, createOkHandler);
            _cancelButton.addEventListener(MouseEvent.CLICK, createCancelHandler);
        }

        // 部屋名入力中のエンターキーハンドラ
        private function enterKeyDownHandler(e:FlexEvent):void
        {
                _duelStageComboBox.setFocus();
        }

        // ステージ変更をリッスン
        private function stageChangeHandler(e:ListEvent):void
        {
            log.writeLog(log.LV_INFO, this, "selected stage is", _duelStageComboBox.selectedIndex);
            _duelStage = _duelStageComboBox.selectedIndex;
        }

        // ルール変更をリッスン
        private function ruleChangeHandler(e:ListEvent):void
        {
            log.writeLog(log.LV_INFO, this, "selected rule is", _duelRuleComboBox.selectedIndex);
            _duelRule = _duelRuleComboBox.selectedIndex;

            if(_duelRuleComboBox.selectedIndex == 0)
            {
                _heartText.text = "x2";
            }
            else if(_duelRuleComboBox.selectedIndex == 1)
            {
                _heartText.text = "x5";
            }
        }

        // ボタンを押す
        private function mouseHandler(e:Event):void
        {
            dispatchEvent(new Event(CLICK_ROOM_CREATE_BUTTON));
        }

        public function ValidText():void
        {
            _roomNameArea.validate();
        }

        // 部屋作成
        private function createOkHandler(e:Event):void
        {
            _roomName = _roomNameArea.text;
            dispatchEvent(new Event(CREATE_ROOM));
        }

        // 部屋作成キャンセル
        private function createCancelHandler(e:Event):void
        {
//            _roomName = _roomNameArea.text;
            dispatchEvent(new Event(CREATE_ROOM_CANCEL));
        }

        public function get roomName():String
        {
            return _roomName;
        }

        public function get duelStage():int
        {
            return _duelStage;
        }

        public function get duelRule():int
        {
            return _duelRule;
        }

        private function getCreateThread():void
        {
        }
    }
}
