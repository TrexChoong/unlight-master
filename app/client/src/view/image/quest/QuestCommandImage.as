package view.image.quest
{

    import flash.display.*;
    import flash.events.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import model.Player;
    import view.*;
    import view.utils.*;
    import view.image.*;
    import controller.QuestCtrl;

    /**
     * CommandImage表示クラス
     *
     */


    public class QuestCommandImage extends BaseImage
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM		:String = "確認";
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM_STARTMSG	:String = "このクエストを始めますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM_STOPMSG	:String = "このクエストを途中でやめますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM_DELMSG	:String = "このクエストを削除しますか？";

        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM		:String = "Confirm";
        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM_STARTMSG	:String = "Start this quest?";
        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM_STOPMSG	:String = "Do you wish to abandon this quest partway?";
        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM_DELMSG	:String = "Do you really want to delete this quest?";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM		:String = "確認";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM_STARTMSG	:String = "確定要開始這個任務？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM_STOPMSG	:String = "確定要放棄這個任務？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM_DELMSG	:String = "確定要刪除這個任務?";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM		:String = "确认";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM_STARTMSG	:String = "是否开始这个任务？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM_STOPMSG	:String = "确定要放弃这个任务？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM_DELMSG	:String = "是否删除这个任务？";

        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM		:String = "확인";
        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM_STARTMSG	:String = "이 퀘스트를 시작하겠습니까?";
        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM_STOPMSG	:String = "이 퀘스트를 그만 하시겠습니까?";
        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM_DELMSG	:String = "이 퀘스트를 삭제하겠습니까?";

        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM		:String = "Confirmer";
        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM_STARTMSG	:String = "Commencer la Quête ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM_STOPMSG	:String = "Quitter cette Quête ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM_DELMSG	:String = "Supprimer cette Quête ?";

        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM		:String = "確認";
        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM_STARTMSG	:String = "このクエストを始めますか？";
        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM_STOPMSG	:String = "このクエストを途中でやめますか？";
        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM_DELMSG	:String = "このクエストを削除しますか？";

        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM     :String = "ตกลง";
        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM_STARTMSG    :String = "จะเริ่มเควสนี้หรือไม่?";
        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM_STOPMSG :String = "จะยกเลิกเควสนี้กลางคันหรือไม่?";
        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM_DELMSG  :String = "จะลบเควสนี้หรือไม่?";


        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/btn_quest.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        private static const DROP_BUTTON:String  ="btn_map_drop"; // 1
        private static const PRESENT_BUTTON:String  ="btn_map_pres"; // 0
        private static const BUTTON_ITEM:String = "btn_map_item"; // 2
        private static const BUTTON_START:String = "btn_map_start";
        private static const BUTTON_QUIT:String = "btn_map_give"; // 3

        public static const STATE_NONE:int = 0;
        public static const STATE_INPROGRESS:int = 1;

        private var _questDropButton:SimpleButton;
        private var _questPresentButton:SimpleButton;
//        private var _questItemButton:SimpleButton;
        private var _questStartButton:SimpleButton;
        private var _questQuitButton:SimpleButton;

        private var _ctrl:QuestCtrl = QuestCtrl.instance;

        private var _state:int;

        /**
         * コンストラクタ
         *
         */
        public function QuestCommandImage()
        {
            super();
        }


        protected override function get Source():Class
        {
            return _Source;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
//            SwfNameInfo.toLog(_root);
            _questStartButton = SimpleButton(_root.getChildByName(BUTTON_START));
            _questQuitButton = SimpleButton(_root.getChildByName(BUTTON_QUIT));
//            _questItemButton = SimpleButton(_root.getChildByName(BUTTON_ITEM));
            _questDropButton = SimpleButton(_root.getChildByName(DROP_BUTTON));
            _questPresentButton = SimpleButton(_root.getChildByName(PRESENT_BUTTON));
            _questPresentButton.visible = true;
             changeStateImage();
             if (_questQuitButton!=null)
             {
                 _questQuitButton.visible =false;
             }
        }


        public override function init():void
        {
            log.writeLog(log.LV_FATAL, this, _questStartButton.name,_questQuitButton.name);
            _questStartButton.addEventListener(MouseEvent.CLICK,startClickHandler);
            _questQuitButton.addEventListener(MouseEvent.CLICK,quitClickHandler);
//            _questItemButton.addEventListener(MouseEvent.CLICK,itemClickHandler);
            _questDropButton.addEventListener(MouseEvent.CLICK,dropClickHandler);
            _questPresentButton.addEventListener(MouseEvent.CLICK,presentClickHandler);


            _ctrl.addEventListener(QuestCtrl.QUEST_INPROGRESS, improgressHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_SOLVED, solevedHandler);
        }

        public  override function final():void
        {
            _questStartButton.removeEventListener(MouseEvent.CLICK,startClickHandler);
            _questQuitButton.removeEventListener(MouseEvent.CLICK,quitClickHandler);
//            _questItemButton.removeEventListener(MouseEvent.CLICK,itemClickHandler);
            _questDropButton.removeEventListener(MouseEvent.CLICK,dropClickHandler);

            _ctrl.removeEventListener(QuestCtrl.QUEST_INPROGRESS, improgressHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_SOLVED, solevedHandler);

        }


        private function startClickHandler(e:MouseEvent):void
        {
////            ConfirmPanel.show("確認", "このクエストを始めますか？", _ctrl.startQuest,this);
//            ConfirmPanel.show(_TRANS_CONFIRM, _TRANS_CONFIRM_STARTMSG, _ctrl.startQuest,this);
            // ダブルクリックを汚い方法で防ぐ
            _questStartButton.removeEventListener(MouseEvent.CLICK,startClickHandler);
            _questDropButton.removeEventListener(MouseEvent.CLICK,dropClickHandler);
            SE.playClick();
            _ctrl.startQuest();
            new WaitThread(1500,_questStartButton.addEventListener,[MouseEvent.CLICK,startClickHandler]).start();
            new WaitThread(1500,_questDropButton.addEventListener,[MouseEvent.CLICK,dropClickHandler]).start();

        }

        private function quitClickHandler(e:MouseEvent):void
        {
            SE.playClick();
//            ConfirmPanel.show("確認","このクエストを途中でやめますか？", _ctrl.quitQuest,this);
            ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_CONFIRM_STOPMSG, _ctrl.quitQuest,this);
        }

//         private function itemClickHandler(e:MouseEvent):void
//         {
//             _ctrl.showItem()
//         }

        private function dropClickHandler(e:MouseEvent):void
        {
            SE.playClick();
//            ConfirmPanel.show("確認","このクエストを削除しますか？",_ctrl.deleteQuest, this);
            var font:Boolean = false;
            CONFIG::LOCALE_SCN
            {
                font = true;
            }
            ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_CONFIRM_DELMSG,_ctrl.deleteQuest, this,null,font);
        }

        private function presentClickHandler(e:MouseEvent):void
        {
            SE.playClick();
            _ctrl.showPresentQuestPanel();
//            ConfirmPanel.show("確認","このクエストを削除しますか？",_ctrl.deleteQuest, this);
//            ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_CONFIRM_DELMSG,_ctrl.deleteQuest, this);

        }



        private function improgressHandler(e:Event):void
        {
            changeState(STATE_INPROGRESS);
        }

        private function solevedHandler(e:Event):void
        {
            changeState(STATE_NONE);
        }


        public function changeState(i:int):void
        {
            _state = i;
            waitComplete(changeStateImage);
        }


        private function changeStateImage():void
        {
            switch (_state)
            {
              case STATE_NONE:
                  _questQuitButton.visible = false;
//                  _questItemButton.visible = true;
                  _questStartButton.visible = true;
                  _questDropButton.visible = true;
                  if (QuestCtrl.instance.currentMap.ap > Player.instance.avatar.energy)
                  {
                      _questPresentButton.visible = false;
                  }else{
                      _questPresentButton.visible = true;
                  }
                  break;
            case STATE_INPROGRESS:
                _questQuitButton.visible = true;
//                _questItemButton.visible = true;
                _questStartButton.visible = false;
                _questDropButton.visible = false;
                _questPresentButton.visible = false;
                break;
            default:
           }
        }


    }

}

