package view
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.MouseEvent;
    import flash.events.Event;

    import mx.core.UIComponent;
    import mx.containers.Panel;
    import mx.controls.Label;
    import mx.controls.Button;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.CharaCard;
    import model.CharaCardDeck;
    import model.Player;
    import model.Avatar;
    import model.events.ExchangeEvent;
    import view.scene.common.CharaCardClip;
    import view.image.regist.*;
    import view.scene.regist.*;
    import view.utils.*;

    import controller.LobbyCtrl;

    /**
     * アバター登録のビュークラス
     *
     */
    public class RegistView extends Thread
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1	:String = "最低";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "文字必要です";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG3	:String = "未選択の項目があります";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG4	:String = "登録済みの名前です。再入力をお願いします";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG5	:String = "アバター名にNGWordが含まれています";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG6	:String = "カードが未選択です";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG7	:String = "このアバター名は使用できません。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1	:String = "Please use at least ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = " characters.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG3	:String = "Please complete your selection.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG4	:String = "That name is already taken, please choose another one.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG5	:String = "Avatar name contains restricted words.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG6	:String = "No cards selected.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG7	:String = "This avatar name can not be used.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1	:String = "最少需要";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "個字";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG3	:String = "有未選擇的項目";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG4	:String = "此名稱已存在。請輸入其他名稱";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG5	:String = "虛擬人物名稱包含NG Word";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG6	:String = "未選擇卡片";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG7	:String = "此虛擬人物名無法使用。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1	:String = "不少于";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "个字";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG3	:String = "有未选的项目";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG4	:String = "该名字已存在。请重新输入。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG5	:String = "虚拟人物的名字中含有NG Word。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG6	:String = "未选择卡片";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG7	:String = "此虚拟人物名无法使用。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1	:String = "최소 ";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = " 문자가 필요합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG3	:String = "선택되지 않은 항목이 있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG4	:String = "이미 등록된 이름입니다. 다시 입력해 주십시오.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG5	:String = "アバター名にNGWordが含まれています";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG6	:String = "カードが未選択です";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG7	:String = "このアバター名は使用できません。";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1	:String = "Vous avez besoin de plus de ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = " lettres";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG3	:String = "Entrée non sélectionnée";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG4	:String = "Nom déjà utilisé. Veuillez choisir un nom différent.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG5	:String = "Le nom de votre Avatar n'est pas approprié.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG6	:String = "Vous n'avez pas sélectionné de carte.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG7	:String = "このアバター名は使用できません。";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1	:String = "最低";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "文字必要です";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG3	:String = "未選択の項目があります";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG4	:String = "登録済みの名前です。再入力をお願いします";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG5	:String = "アバター名にNGWordが含まれています";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG6	:String = "カードが未選択です";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG7	:String = "このアバター名は使用できません。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1    :String = "ตัวอักษรต้องไม่ต่ำกว่า";//"最低";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "ตัว";//"文字必要です";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG3    :String = "มีหัวข้อที่ไม่ได้ถูกเลือกอยู่";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG4    :String = "ชื่อนี้ถูกใช้แล้ว กรุณาใส่ชื่อใหม่อีกครั้ง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG5    :String = "มีคำที่ห้ามใช้ในชื่อของอวาตาร์";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG6    :String = "ไม่มีการ์ดที่ถูกเลือก";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG7	:String = "このアバター名は使用できません。";



        // 親ステージ
        private var _stage:Sprite;

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // オープニング
        private var _preStroy:PreStory = new PreStory();

        // 基本BG
        private var _bg:RegistBG = new RegistBG();

        // 基本BG
        private var _frame:RegistFrame = new RegistFrame();

        // 名前登録時のBG
        private var _nameInput:NameInput = new NameInput();
        // アバター設定時のBG
        private var _avatarStyle:AvatarStyleEditor = new AvatarStyleEditor();

//         // カード設定時のBG
        private var _cardSelector:CardSelector = new CardSelector();

        // アバターの名前
        private var _name:String = "";

        // ビューのステート
        private var _registState:int = 0;

        // ビューのステート
        private var _alreadyState:int = 0;

        // ステート定数
        private static const _START:int = 0;               // 開始
        private static const _EDIT_NAME:int = 1;           // 名前設定
        private static const _EDIT_AVATAR:int = 2;         // アバターを編集
        private static const _EDIT_CARD:int = 3;           // カード選択
        private static const _REGISTRATION:int = 4;// カード選択
        private static const _END:int = 5;                 // 終了

        private var _okFunc:Function;

        private var _ctrl:LobbyCtrl = LobbyCtrl.instance;
        private var _player:Player = Player.instance;

        // 位置定数

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */
        public function RegistView(stage:Sprite)
        {
            _stage = stage;
            _stage.addChild(_container);
            _nameInput.setEnterFunc(nameOk);
        }

        // スレッドのスタート
        override protected function run():void
        {
            _ctrl.addEventListener(LobbyCtrl.CHECK_NAME_SUCCESS, nameSuccessHandler);
            _ctrl.addEventListener(LobbyCtrl.CHECK_NAME_FAILED, nameFailedHandler);
            _ctrl.playRegistBGM()
            next(startStory);
        }
        private function startStory():void
        {
            var thread:Thread = _preStroy.getShowThread(_container,1);
            thread.join();
            thread.start();
            next(endStory);
        }

        private function endStory():void
        {
            _preStroy.getHideThread().start();
            _bg.getShowThread(_container,0).start();
            _frame.getShowThread(_container,2).start();
            _registState = _EDIT_NAME;
            next(waiting);
            _frame.addEventListener(RegistFrame.NEXT_CLICK, nextClickHandler);
            _frame.addEventListener(RegistFrame.PREV_CLICK, prevClickHandler);
            _frame.addEventListener(RegistFrame.OK_CLICK, okClickHandler);
        }
        // ループ部分
        private function waiting():void
        {
            if (_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else{

            switch (_registState)
            {
            case _EDIT_NAME:
                next(avatarName);
                break;
            case _EDIT_AVATAR:
                next(avatarStyle);
                break;
            case _EDIT_CARD:
                next(card);
                break;
            case _REGISTRATION:
                next(registration);
                break;
            case _END:
                next(hide);
                break;
            default:
                next(waiting);
            }
            }
        }

        // 名前の設定
        private function avatarName():void
        {
            arrowUpdate();
            _frame.setNamePhase();
            _okFunc = _nameInput.enterInput;
            _nameInput.getShowThread(_container).start();
            next(nameWait);
        }

        // 入力待ち
        private function nameWait():void
        {
            if (_registState == _EDIT_NAME)
            // 状態変化なし
            {
                next(nameWait);
            }else{
            // 状態変化あり
                // インプットを消す
                var t:Thread = _nameInput.getHideThread();
                t.start();
//                t.join();
                next(waiting);
            }
        }

        // 名前OKボタン
        private function nameOk():void
        {
            if (_nameInput.avatarName.length < Const.NAME_MIN)
            {
//                Alerter.showWithSize("最低"+Const.NAME_MIN.toString()+"文字必要です", 'Error', 4, null, null);
                Alerter.showWithSize(_TRANS_MSG1+Const.NAME_MIN.toString()+_TRANS_MSG2, 'Error', 4, null, null);
            }
            else if (_nameInput.avatarName.indexOf("***") > -1)
            {
                Alerter.showWithSize(_TRANS_MSG5, 'Error', 4, null, null);
            }
            else
            {
                if(Player.instance.invitedCode.length == 0 || Player.instance.invitedPID > 0)
                {
                    _ctrl.checkAvatarName(_nameInput.avatarName);
                }
            }
        }


        // アバター読み込みのハンドラ
        private function nameSuccessHandler(e:Event):void
        {
            registState = _EDIT_AVATAR;
        }

        // アバター読み込みのハンドラ
        private function nameFailedHandler(e:Event):void
        {
//            Alerter.showWithSize('登録済みの名前です。再入力をお願いします', 'Error', 4, null, null);
            if (_ctrl.nameChackErrCode == Avatar.NAME_ALREADY_USED) {
                Alerter.showWithSize(_TRANS_MSG4, 'Error', 4, null, null);
            } else {
                Alerter.showWithSize(_TRANS_MSG7, 'Error', 4, null, null);
            }
            registState = _EDIT_NAME;
        }

        // アバターの設定
        private function avatarStyle():void
        {
            arrowUpdate();
            _okFunc = styleOk;
            _avatarStyle.getShowThread(_container).start();
            log.writeLog(log.LV_INFO, this, "avatar regist start");
            _frame.setAvatarPhase();
            next(avatarWait);
        }
        // アバターの姿選択
        private function styleOk():void
        {
            if (_avatarStyle.validateRegistParts())
            {
                registState = _EDIT_CARD;
            }else{
//                Alerter.showWithSize('未選択の項目があります', 'Error', 4, null, null);
                Alerter.showWithSize(_TRANS_MSG3, 'Error', 4, null, null);
            }
        }

        // 入力待ち
        private function avatarWait():void
        {
            if (_registState == _EDIT_AVATAR)
            {
                next(avatarWait);
            }else{
                // インプットを消す
                var t:Thread = _avatarStyle.getHideThread();
                t.start();
//                t.join();
                next(waiting);
            }
        }

        // カードの設定
        private function card():void
        {
            arrowUpdate();
            _frame.setCardPhase();
            _okFunc = cardOk;
            _cardSelector.getShowThread(_container,1).start();
            next(cardWait);
        }

        // 入力待ち
        private function cardWait():void
        {
            if (_registState == _EDIT_CARD)
            // 状態変化なし
            {
                next(cardWait);
            }else{
            // 状態変化あり
                // インプットを消す
                var t:Thread = _cardSelector.getHideThread();
                t.start();
//                t.join();
                next(waiting);
            }
        }

        // 名前OKボタン
        private function cardOk():void
        {
            if (_cardSelector.selectedCard == -1)
            {
                //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                Alerter.showWithSize(_TRANS_MSG6, 'Error', 4, null, null);}
            else{
                registState = _REGISTRATION;
            }
        }

        // カードの設定
        private function registration():void
        {
            _ctrl.registAvatar(_nameInput.avatarName, _avatarStyle.avatarSelectedStyle,[_cardSelector.selectedCard]);
            // ステージのステートチェンジイベントをリッスンする
            event(_player, Player.CHANGE_STATE, getAvatarHandler);
        }

        // アバター読み込みのハンドラ
        private function getAvatarHandler(e:Event):void
        {
            if (_player.state == Player.STATE_REGIST)
            {
//                Alerter.showWithSize('登録済みの名前です。再入力をお願いします', 'Error', 4, null, null);
                Alerter.showWithSize(_TRANS_MSG4, 'Error', 4, null, null);
                registState = _EDIT_NAME ;
                next(waiting);
            }
            else if (_player.state == Player.STATE_TUTORIAL)
            {
                next(hide);
            }else{
                next(waiting);
            }
        }


        // 描画オブジェクトを消去
        private function hide():void
        {
            _bg.getHideThread().start();
            _frame.getHideThread().start();
            next(exit);
        }

        // 終了
        private function exit():void
        {
            _ctrl.stopRegistBGM();
            _ctrl.removeEventListener(LobbyCtrl.CHECK_NAME_SUCCESS, nameSuccessHandler);
            _ctrl.removeEventListener(LobbyCtrl.CHECK_NAME_FAILED, nameFailedHandler);

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.start();
            pExec.join();
        }

        // 終了関数
        override protected  function finalize():void
        {

            RemoveChild.apply(_container);
            _ctrl.removeEventListener(LobbyCtrl.CHECK_NAME_SUCCESS, nameSuccessHandler);
            _ctrl.removeEventListener(LobbyCtrl.CHECK_NAME_FAILED, nameFailedHandler);
            _frame.removeEventListener(RegistFrame.NEXT_CLICK, nextClickHandler);
            _frame.removeEventListener(RegistFrame.PREV_CLICK, prevClickHandler);
            _frame.removeEventListener(RegistFrame.OK_CLICK, okClickHandler);

            _frame =null;
            _preStroy= null;
            _bg = null;
            _nameInput = null;
            _avatarStyle = null;
            _cardSelector = null;
        }

        // 状態
        public function set registState(s:int):void
        {
            var st:int;
            st = s;
            if (s < _EDIT_NAME){st = _EDIT_NAME};
            if (s > _EDIT_NAME){st = _EDIT_CARD};
            _registState = s;
            if (_alreadyState < _registState){_alreadyState = _registState}
        }
        public function get registState():int
        {
            return _registState;
        }

        // 矢印表示のアップデート
        private function arrowUpdate():void
        {
            prevArrowOn();
            nextArrowOn();
        }

        // 戻る矢印をON
        private function prevArrowOn():void
        {
            // 最初のNameの場合出さない
            if (_registState != _EDIT_NAME)
            {
                _frame.prevOn();
            }else{
                _frame.prevOff();
            }
        }

        // 進む矢印をON
        private function nextArrowOn():void
        {
            // 最後のカードの場合出さない、入力済みの状態がある場合出す
            if (_registState != _EDIT_CARD&&_alreadyState > _registState)
            {
                _frame.nextOn();
            }else{
                _frame.nextOff();
            }
        }


        private function prevClickHandler(e:Event):void
        {
            registState -=1;
            log.writeLog(log.LV_FATAL, this, "++ prev", registState);
        }

        private function nextClickHandler(e:Event):void
        {
            if (registState == _EDIT_NAME)
            {
                nameOk();
            }else{
                registState +=1;
                log.writeLog(log.LV_FATAL, this, "++ next", registState);
            }
        }

        private function okClickHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "button down");
            _okFunc()
        }



   }
}
