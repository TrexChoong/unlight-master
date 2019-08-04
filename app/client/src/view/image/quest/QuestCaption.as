package view.image.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;
    import flash.filters.*;

    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;

    import view.scene.BaseScene;
    import view.ModelWaitThread;

    import controller.QuestCtrl;

    import model.Quest;

    /**
     *  取得確認パネル
     *
     */

    public class QuestCaption extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_QUEGETMSG	:String = "新クエストを取得しました";
        CONFIG::LOCALE_JP
        private static const _TRANS_REGION	:String = "\n <FONT SIZE =\"10\" >[地域]";
        CONFIG::LOCALE_JP
        private static const _TRANS_ACHIE	:String = "\n [QuestPoint]: ＋";

        CONFIG::LOCALE_EN
        private static const _TRANS_QUEGETMSG	:String = "You have a new quest!";
        CONFIG::LOCALE_EN
        private static const _TRANS_REGION	:String = "\n <FONT SIZE =\"10\" >[Area]";
        CONFIG::LOCALE_EN
        private static const _TRANS_ACHIE	:String = "\n [QuestPoint]: + ";

        CONFIG::LOCALE_TCN
        private static const _TRANS_QUEGETMSG	:String = "取得了新的任務";
        CONFIG::LOCALE_TCN
        private static const _TRANS_REGION	:String = "\n <FONT SIZE =\"10\" >[地區]";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ACHIE	:String = "\n [QuestPoint]: ＋";

        CONFIG::LOCALE_SCN
        private static const _TRANS_QUEGETMSG	:String = "获得新任务";
        CONFIG::LOCALE_SCN
        private static const _TRANS_REGION	:String = "\n <FONT SIZE =\"10\" >[地域]";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ACHIE	:String = "\n [QuestPoint]: ＋";

        CONFIG::LOCALE_KR
        private static const _TRANS_QUEGETMSG	:String = "새로운 퀘스트를 취득했습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_REGION	:String = "\n <FONT SIZE =\"10\" >[지역]";
        CONFIG::LOCALE_KR
        private static const _TRANS_ACHIE	:String = "\n [QuestPoint]: ＋";

        CONFIG::LOCALE_FR
        private static const _TRANS_QUEGETMSG	:String = "Vous avez obtenu une nouvelle Quête !";
        CONFIG::LOCALE_FR
        private static const _TRANS_REGION	:String = "\n <FONT SIZE =\"10\" >[Zone]";
        CONFIG::LOCALE_FR
        private static const _TRANS_ACHIE	:String = "\n [QuestPoint]: ＋";

        CONFIG::LOCALE_ID
        private static const _TRANS_QUEGETMSG	:String = "新クエストを取得しました";
        CONFIG::LOCALE_ID
        private static const _TRANS_REGION	:String = "\n <FONT SIZE =\"10\" >[地域]";
        CONFIG::LOCALE_ID
        private static const _TRANS_ACHIE	:String = "\n [QuestPoint]: ＋";

        CONFIG::LOCALE_TH
        private static const _TRANS_QUEGETMSG   :String = "ได้รับเควสใหม่";
        CONFIG::LOCALE_TH
        private static const _TRANS_REGION  :String = "\n <FONT SIZE =\"10\" >[พื้นที่]";
        CONFIG::LOCALE_TH
        private static const _TRANS_ACHIE   :String = "\n [QuestPoint]: ＋";

        CONFIG::LOCALE_JP
        private static const _TRANS_BANAME	:String = "[プレゼントの送り主]：__NAME__";
        CONFIG::LOCALE_EN
        private static const _TRANS_BANAME	:String = "[Sender of this gift]：__NAME__";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BANAME	:String = "[送礼来的大小姐]：__NAME__";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BANAME	:String = "[送禮來的大小姐]：__NAME__";
        CONFIG::LOCALE_KR
        private static const _TRANS_BANAME	:String = "[선물한 아바타명]：__NAME__";
        CONFIG::LOCALE_FR
        private static const _TRANS_BANAME	:String = "[Expéditeur de ce don]：__NAME__";
        CONFIG::LOCALE_ID
        private static const _TRANS_BANAME	:String = "[プレゼントしたアバター名]：__NAME__";
        CONFIG::LOCALE_TH
        private static const _TRANS_BANAME	:String = "[プレゼントしたアバター名]：__NAME__";

        // タイトル表示
        private var _text:Label = new Label();
        private var _text2:Label = new Label();

        private const NAME:String = ""

        // 決定ボタン
        private var _okButton:Button = new Button();
        private var _quest:Quest;

        private var _baNameText:Label = new Label();


        /**
         * コンストラクタ
         *
         */
        public function QuestCaption()
        {
            super();
            visible = false;
            _text.x = 200;
            _text.y = 33;
            _text.width = 250;
            _text.height =200;
////            _text.text = "新クエストを取得しました";
//            _text.text = _TRANS_QUEGETMSG;
            _text.styleName = "QuestCaptionTitleLabel";
            _text.filters = [new GlowFilter(0x000000, 1.0, 4, 4, 3, 1),];

            _text2.x = 11;
            _text2.y = 446;
            _text2.width = 400;
            _text2.height = 60;
            _text2.text = "";
            _text2.styleName = "QuestCaptionLabel";

            _baNameText.x = 11;
            _baNameText.y = 420;
            _baNameText.width = 400;
            _baNameText.height = 60;
            _baNameText.text = "";
            _baNameText.styleName = "QuestCaptionLabel";

            addChild(_text);
            addChild(_text2);
            addChild(_baNameText);
        }

        public override function init():void
        {
            QuestCtrl.instance.addEventListener(QuestCtrl.QUEST_LIST_CLICK,clickHandler);
        }
        public override function final():void
        {
            QuestCtrl.instance.removeEventListener(QuestCtrl.QUEST_LIST_CLICK,clickHandler);
        }

        //
        public function setQuest(quest:Quest):void
        {
            _quest = quest;
            new ModelWaitThread(quest,waitMap).start();
        }

        private function waitMap():void
        {
            new ModelWaitThread(_quest.map,updateText).start();
        }
        private function updateText():void
        {
            log.writeLog(log.LV_DEBUG, this, "udpate text!!!!!!!!!!!!!!!!!!!!!!!");
//            _text.htmlText = _quest.name+"\n <FONT SIZE =\"10\" >[地域]"+_quest.map.name+"\n [達成度]: ＋"+_quest.difficulty.toString()+"</FONT>";;
            _text.htmlText = _quest.name+_TRANS_REGION+_quest.map.name+_TRANS_ACHIE+_quest.difficulty.toString()+"</FONT>";;
            _text2.text = _quest.caption;
        }
        private function clickHandler(e:Event):void
        {
            // プレゼントしたアバター名表示
            if (QuestCtrl.instance.currentQuestInventory.baName != Const.QUEST_PRESENT_AVATAR_NAME_NIL) {
                _baNameText.text = _TRANS_BANAME.replace("__NAME__",QuestCtrl.instance.currentQuestInventory.baName);
            } else {
                _baNameText.text = "";
            }
        }

    }
}