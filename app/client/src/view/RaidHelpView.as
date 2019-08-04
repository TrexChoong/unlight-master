package view
{
    import flash.display.*;
    import flash.events.*;
    import flash.display.*;
    import flash.filters.*;

    import mx.core.UIComponent;
    import mx.events.StateChangeEvent;
    import mx.containers.Panel;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.thread.threads.tweener.TweenerThread;

    import net.Host;
    import view.scene.raid.*;
    import view.utils.*;
    import controller.GlobalChatCtrl;
    import model.*;
    import model.events.RaidHelpEvent;

    /**
     * レイドヘルプのビュークラス
     *
     */

    public class RaidHelpView extends Thread
    {
        private static var __instance:RaidHelpView; // シングルトン保存用

        // プレイヤーインスタンス
        private var _player:Player = Player.instance;

        // 親ステージ
        private var _stage:Sprite;
        private var _container:UIComponent = new UIComponent(); // 表示コンテナ

        // コントローラ
        private var _ctrl:GlobalChatCtrl = GlobalChatCtrl.instance;

        // ヘルプリスト
        private var _helpList:Vector.<RaidHelp> = new Vector.<RaidHelp>();

        // パネル
        private var _helpPanel:RaidHelpPanel = new RaidHelpPanel();

        // 更新するか
        private var _isUpdate:Boolean = true;

        // 画面チェンジ
        private var _changeView:Boolean = false;

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */
        public function RaidHelpView(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            init();
        }
        private static function createInstance():RaidHelpView
        {
            return new RaidHelpView(arguments.callee);
        }

        public static function get instance():RaidHelpView
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }

        public function setStage(stage:Sprite):void
        {
            _stage = stage;
        }

        public function set isUpdate(f:Boolean):void
        {
            _isUpdate = f;
            _helpPanel.helpView = f;
            // 移動中で非表示にするならフェードアウト
            if ( _helpPanel.isMove && f==false) {
                _helpPanel.setInterrupt();
            }
        }

        private function init():void
        {
            _ctrl.addEventListener(RaidHelpEvent.UPDATE,updateHelpHandler);
            _helpPanel.setClickFunc(panelClick);
            _helpPanel.start();
        }

        private function updateHelpHandler(e:RaidHelpEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "updateHelpHandler",e.plId,e.name,e.hash);
            _helpList.push(new RaidHelp(e.plId,e.name,e.hash));
        }

        // スレッドのスタート
        override protected  function run():void
        {
            next(changeWait);
        }
        // シーンの切り替え
        private function changeWait():void
        {
            if (_changeView) {
                next(changeWait);
            } else {
                next(waiting);
            }
        }

        private function waiting():void
        {
            // log.writeLog(log.LV_DEBUG, this, "waiting", _helpPanel.isMove,_helpList.length);
            var isShow:Boolean = false;
            if (!_helpPanel.isMove && _helpList.length > 0) {
                var help:RaidHelp = _helpList.shift();
                log.writeLog(log.LV_DEBUG, this, "waiting", help,_isUpdate);
                if (help&&_isUpdate) {
                    _helpPanel.startPanel(help.playerId,help.avatarName,help.prfHash);
                    isShow = true;
                }
            }
            if (isShow) {
                next(show);
            } else {
                next(waiting);
            }
        }
        private function show():void
        {
            if (_helpPanel.isMove) {
                next(show);
            } else {
                next(waiting);
            }
            // log.writeLog(log.LV_DEBUG, this, "show",_helpPanel.isMove);
            // WaitingPanel.show("Waiting...",_TRANS_MSG,!_player.joined,cancelHandler,this,[])
        }

        private function hide():void
        {
        }

        private function exit():void
        {
        }

        private function loadInterrupted():void
        {
        }

        // 終了関数
        override protected  function finalize():void
        {
            log.writeLog (log.LV_INFO,this,"Raid Help View Finalize");
        }

        private function panelClick():void
        {
            log.writeLog(log.LV_FATAL,this,"panelClick");
            if (_helpPanel.isMove) {
                _helpPanel.setInterrupt();
                _ctrl.acceptHelp(_helpPanel.playerId,_helpPanel.avatarName,_helpPanel.prfHash);
            }
        }

   }
}

class RaidHelp
{
    private var _plId:int;
    private var _name:String;
    private var _hash:String;

    public function RaidHelp(id:int,name:String,hash:String)
    {
        _plId = id;
        _name = name;
        _hash = hash;
    }
    public function get playerId():int
    {
        return _plId;
    }
    public function get avatarName():String
    {
        return _name;
    }
    public function get prfHash():String
    {
        return _hash;
    }
}