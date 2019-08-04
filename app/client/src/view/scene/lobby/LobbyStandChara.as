package view.scene.lobby
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;

    import mx.core.UIComponent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import model.*;
    import view.scene.BaseScene;
    import view.image.lobby.*;
    import view.image.game.StandCharaImage;
    import view.utils.RemoveChild;

    import controller.LobbyCtrl;

    /**
     * ロビー立ちキャラ表示クラス
     *
     */

    public class LobbyStandChara extends BaseScene
    {
        private static const _PLAYER_X:int = -80;
        private static const _PLAYER_Y:int = 80;
        private static const _START_X:int = _PLAYER_X - 500;

        private static const _CLAMPS_ID:int = 2024;
        private static const _CLAMPS_X:int = -120;

        private var _player:Player;

        private var _chara:StandCharaImage;

        private var _ctrl:LobbyCtrl = LobbyCtrl.instance;

        // 現在表示しているキャラID7
        // 暫定でエヴァを表示
        private var _currentCharaId:int = 1;

        private var _isChanged:Boolean = false;

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        /**
         * コンストラクタ
         *
         */
        public function LobbyStandChara()
        {
        }

        public override function init():void
        {
            addChild(_container);
        }
        public override function final():void
        {
            RemoveChild.apply(_container);
            RemoveChild.apply(_chara);
            _chara = null;
        }

        public function getInitializeThread():Thread
        {
            if (_player == null)_player = Player.instance;
            _currentCharaId = _player.avatar.favoriteCharaId;
            var charaData:Charactor = Charactor.ID(_currentCharaId);
            log.writeLog(log.LV_DEBUG, this, "getInitializeThread",_player,_chara,_currentCharaId,charaData);

            if (_chara == null && charaData && charaData.lobbyImage) {
                _chara = new StandCharaImage( true, charaData.lobbyImage);
                _chara.upImage();
                _chara.x = _START_X;
                _chara.y = _PLAYER_Y;
                _chara.visible = false;
            }

            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_chara) pExec.addThread(_chara.getShowThread(_container,2));
            return pExec;
        }
        public function getBringOnThread():Thread
        {
            _isChanged = false;
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_chara) pExec.addThread(new BeTweenAS3Thread(_chara, {x:_PLAYER_X}, null, 0.8  / Unlight.SPEED , BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            return pExec;
        }
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(getInitializeThread());
            sExec.addThread(super.getShowThread(stage,at,type));
            sExec.addThread(getBringOnThread());
            return sExec;
        }
        public function getBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_chara) pExec.addThread(new BeTweenAS3Thread(_chara, {x:_START_X}, null, 0.8 / Unlight.SPEED , BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            return pExec;
        }
        // 消去のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(getBringOffThread());
            sExec.addThread(super.getHideThread(type));
            return sExec;
        }

        public function getChangeClampsThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(getBringOffThread());
            sExec.addThread(getCharaChangeClampsThread());
            sExec.addThread(getClampsBringOnThread());
            return sExec;
        }
        public function getCharaChangeClampsThread():Thread
        {
            if (_player && _player.state != Player.STATE_LOBBY) return null;

            var charaData:Charactor = Charactor.ID(_CLAMPS_ID);

            if (charaData && charaData.lobbyImage) {
                if (_chara != null) {
                    _chara.getHideThread();
                    _chara  = null;
                }
                _chara = new StandCharaImage( true, charaData.lobbyImage);
                _chara.upImage();
                _chara.x = _START_X;
                _chara.y = _PLAYER_Y;
                _chara.visible = false;
                _chara.addEventListener(MouseEvent.CLICK,clickHandler);
            }

            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_chara) pExec.addThread(_chara.getShowThread(_container,2));
            return pExec;
        }
        public function getCharaChangeFavoriteThread():Thread
        {
            if (_player && _player.state != Player.STATE_LOBBY) return null;

            if (_player == null)_player = Player.instance;
            _currentCharaId = _player.avatar.favoriteCharaId;
            var charaData:Charactor = Charactor.ID(_currentCharaId);
            log.writeLog(log.LV_DEBUG, this, "getInitializeThread",_player,_chara,_currentCharaId,charaData);

            if (charaData && charaData.lobbyImage) {
                if (_chara != null) {
                    _chara.removeEventListener(MouseEvent.CLICK,clickHandler);
                    _chara.getHideThread();
                    _chara  = null;
                }
                _chara = new StandCharaImage( true, charaData.lobbyImage);
                _chara.upImage();
                _chara.x = _START_X;
                _chara.y = _PLAYER_Y;
                _chara.visible = false;
            }

            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_chara) pExec.addThread(_chara.getShowThread(_container,2));
            return pExec;
        }
        public function getClampsBringOnThread():Thread
        {
            _isChanged = true;
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_chara) pExec.addThread(new BeTweenAS3Thread(_chara, {x:_CLAMPS_X}, null, 0.8  / Unlight.SPEED , BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            return pExec;
        }
        private function clickHandler(e:Event):void
        {
            log.writeLog(log.LV_DEBUG, this, "Clamps Clicked");
            _ctrl.clampsClick();
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(getBringOffThread());
            sExec.addThread(getCharaChangeFavoriteThread());
            sExec.addThread(getBringOnThread());
            sExec.start();
        }

        public function get isChanged():Boolean
        {
            return _isChanged;
        }
    }
}
