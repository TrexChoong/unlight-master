package view
{
    import flash.display.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.*;
    import flash.filters.*;

    import mx.core.UIComponent;
    import mx.core.MovieClipLoaderAsset;
    import mx.events.StateChangeEvent;
    import mx.containers.Panel;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.thread.threads.tweener.TweenerThread;

    import net.Host;
    import view.image.game.*;
    import view.utils.*;
    import controller.*;
    import model.*;
    import model.events.ChannelEvent;

    /**
     * ゲームロビーのビュークラス
     *
     */

    public class RadderWaitingView extends Thread
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "対戦相手とマッチング中";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "Searching for an opponent.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "正在等待對手加入";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "正等待對手加入";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "대전 상대와 매칭중";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Rechercher votre adversaire";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "対戦相手とマッチング中";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "กำลังทำการจับคู่ผู้เล่น";


        // プレイヤーインスタンス
        private var _player:Player = Player.instance;
//         private var _waitLabel:Label = new Label();
//         private var _waitPanel:Panel = new Panel();

        //キャラカードリスト
        private var _cCardList:Array;

        // 配置物の配列
        private var _objArray:Array = [];

        // 親ステージ
        private var _stage:Sprite;
        private var _container:UIComponent = new UIComponent(); // 表示コンテナ

        // 現在のデュエル
        private var _duel:Duel;

        // マッチングロビー
        private var _match:Match;


        // 消去フラグ
        private var _exitFlag:Boolean = false;
        // 強制消去フラグ
        private var _forceExitFlag:Boolean = false;

        // 部屋のUIDか？
        private var _uid:String = "";
        private var _delete:Boolean = false;


        /**
         * コンストラクタ
         * @param stage 親ステージ
         */
        public function RadderWaitingView(stage:Sprite,s:String)
        {
            _duel = Duel.instance;
            _match = Match.instance;
            _stage = stage;
            _uid = s;
            MatchCtrl.instance.radderWaitingRun(this);
        }

        private function cancelHandler():void
        {
            MatchCtrl.instance.quickmatchCancelOrder();
            // MatchCtrl.instance.deleteQuickmatchList();
            // _exitFlag = true;
        }


        // スレッドのスタート
        override protected  function run():void
        {
            log.writeLog(log.LV_INFO, this, "[run].");
            next(show);
        }
        private function show():void
        {
            next(connect);
            WaitingPanel.show("Waiting...",_TRANS_MSG,!_player.joined,cancelHandler,this,[])
        }

        // シーンの切り替え
        private function connect():void
        {

//            log.writeLog(log.LV_FATAL, this, "++++ server state", DuelCtrl.instance.serverState);
            if (_forceExitFlag) {
                log.writeLog (log.LV_INFO,this,"duel force exit"); //
                next(hide);
                _forceExitFlag = false; // 戻しておく
            }
            else if (_duel.state == Duel.START)
            {
                log.writeLog (log.LV_INFO,this,"duel started"); //
                next(hide);
            }
            else if((!_player.joined)&&(_exitFlag == true|| _player.state == Player.STATE_LOGOUT))
            {
                log.writeLog (log.LV_INFO,this,"duel exit 1"); //
                next(exit);
            }
            else if(DuelCtrl.instance.serverState != Host.CONNECT_AUTHED)
            {
                log.writeLog (log.LV_INFO,this,"duel exit 2"); //
                next(exit);
            }
            else if(!WaitingPanel.enable)
            {
                log.writeLog (log.LV_INFO,this,"duel exit 3"); //
                next(exit);
            }
            else
            {
                Unlight.INS.dummyClick();  // 放置時間を計測しないための処置
                next(connect);
            }
        }

        public function cancelExec(is_success:Boolean):void
        {
            if ( is_success ) {
                _exitFlag = true;
            }
        }

        public function exitPanel():void
        {
            _exitFlag = true;
        }
        public function forceExitPanel():void
        {
            _forceExitFlag = true;
        }


        private function hide():void
        {
            WaitingPanel.hide();
            MatchCtrl.instance.radderWaitingEnd();
            _player.joined = false;
        }

        private function exit():void
        {
            WaitingPanel.hide();
        }

        private function loadInterrupted():void
        {

        }

        // ステージのステートチェンジの状態によって関数を起動する
        private function stateChange(event:StateChangeEvent):void
        {
            if (event.newState == "Connected")
            {
                next(hide);
            }
        }

        // 終了関数
        override protected  function finalize():void
        {
            WaitingPanel.hide();
            log.writeLog (log.LV_INFO,this,"gamelobby end");
        }

   }
}
