package view.scene.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import view.image.game.AvatarBase;
    import view.image.game.WatchExitPanel;
    import view.scene.BaseScene;
    import view.scene.common.AvatarClip;
    import view.utils.RemoveChild;

    import controller.WatchCtrl;

    /**
     * DuelAvatars
     * 対戦時のアバターをまとめて管理する
     *
     *
     */

    public class DuelAvatars  extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1	:String = "あなたのアバターです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "対戦相手のアバターです。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1	:String = "Your avatar.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = "Your opponent's avatar.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1	:String = "你的虛擬人物。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "對手的虛擬人物。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1	:String = "您的虚拟人物。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "对手的虚拟人物。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1	:String = "당신의 아바타 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "대전 상대의 아바타 입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1	:String = "Avatar";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = "Avatar de votre adversaire";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1	:String = "あなたのアバターです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "対戦相手のアバターです。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1    :String = "อวาตาร์ของท่าน";//"あなたのアバターです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "อวาตาร์ของฝ่ายตรงข้าม";//"対戦相手のアバターです。";


        private static const _PLAYER_AVATAR_X:int = 590;
//        private static const _PLAYER_AVATAR_Y:int = 523;
        private static const _PLAYER_AVATAR_Y:int = 473;
        private static const _FOE_AVATAR_X:int = 845;
        private static const _FOE_AVATAR_Y:int = 11;

        // アバター台座
        private var _playerAvatarBase:AvatarBase = new AvatarBase();

        // アバタークリップ
        private var _playerAvatarClip:AvatarClip;
        private var _foeAvatarClip:AvatarClip;

        private static const _PLAYER_AVATAR_SCALE:Number = 1.0;
        private static const _FOE_AVATAR_SCALE:Number = 1.0;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["あなたのアバターです。",
//                 "対戦相手のアバターです。",],
                [_TRANS_MSG1,
                 _TRANS_MSG2,],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int = 0;

        private var _isWatch:Boolean = false;
        private var _nameLabel:Label = new Label(); // 観戦時の部屋の主のアバター名

        private const _NAME_X:int = 510;
        private const _NAME_Y:int = 660;
        private const _NAME_W:int = 250;
        private const _NAME_H:int = 30;

        /**
         * コンストラクタ
         *
         */
        public function DuelAvatars()
        {
            _nameLabel.x = _NAME_X;
            _nameLabel.y = _NAME_Y;
            _nameLabel.width = _NAME_W;
            _nameLabel.height = _NAME_H;
            _nameLabel.setStyle("textAlign","right");
            _nameLabel.setStyle("color","#FFFFFF");
            // mouseEnabled = false;
            // mouseChildren = false;
        }
        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,_playerAvatarBase]);  //
            _toolTipOwnerArray.push([1,_foeAvatarClip]);  //
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

        public override function init():void
        {
            _playerAvatarClip = new AvatarClip(Player.instance.avatar);
            _foeAvatarClip = new AvatarClip(Player.instance.avatar);

            visible = false;
            alpha = 0.0;

            _playerAvatarClip.x = _PLAYER_AVATAR_X;
            _playerAvatarClip.y = _PLAYER_AVATAR_Y;
            _playerAvatarClip.scaleX = _playerAvatarClip.scaleY = _PLAYER_AVATAR_SCALE;

            _foeAvatarClip.x = _FOE_AVATAR_X;
            _foeAvatarClip.y = _FOE_AVATAR_Y;

            _playerAvatarClip.type = Const.PL_AVATAR_MATCH;

            _playerAvatarBase.watchView(_isWatch);
            if (!_isWatch) {
                _playerAvatarClip.getShowThread(this,1).start();
                mouseEnabled = false;
                mouseChildren = false;
                _nameLabel.visible = false;
            } else {
                mouseEnabled = true;
                mouseChildren = true;
                _playerAvatarClip.mouseEnabled = false;
                _playerAvatarClip.mouseChildren = false;
                _playerAvatarBase.mouseEnabled = true;
                _playerAvatarBase.mouseChildren = true;
                _playerAvatarBase.addChild(_nameLabel);
                _nameLabel.visible = true;
            }

            _playerAvatarBase.getShowThread(this,0).start();
            //_foeAvatarClip.getShowThread(this).start();

            // initilizeToolTipOwners();
            // updateHelp(_GAME_HELP);

        }

        public override function final():void
        {
            _playerAvatarClip.getHideThread().start();
            RemoveChild.apply(_nameLabel);
//            __instance =null;
            //_foeAvatarClip.getHideThread().start();
        }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            pExec.addThread(new BeTweenAS3Thread(_playerAvatarBase, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            return pExec;
        }

        public function getBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_playerAvatarClip  != null) {pExec.addThread(new BeTweenAS3Thread(_playerAvatarClip, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));}
            if (_playerAvatarBase  != null) {pExec.addThread(new BeTweenAS3Thread(_playerAvatarBase, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));}
            return pExec;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
//            stage.addChild(_nameLabel);
            _depthAt = at;
            return new ShowThread(this, stage);
        }

        // 消去のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }

        public function set isWatch(f:Boolean):void
        {
            _isWatch = f;
        }
        public function set ownerName(s:String):void
        {
            _nameLabel.text = s.replace("_rename","");
        }
        public function set isRaid(v:Boolean):void
        {
            _playerAvatarBase.raidPointView = v;
        }

        public function set avatarBaseMouseEnabeld(v:Boolean):void
        {
            _playerAvatarBase.mouseEnabled  = v;
            _playerAvatarBase.mouseChildren = v;
        }
        public function get watchRoomOutBtn():SimpleButton
        {
            return _playerAvatarBase.watchRoomOutBtn;
        }

        public function getHidePlayerAvatarThread():Thread
        {
            return new BeTweenAS3Thread(_playerAvatarClip, {alpha:0.0}, null, 2.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.1 ,true );
        }
        public function getShowPlayerAvatarThread():Thread
        {
            return new BeTweenAS3Thread(_playerAvatarClip, {alpha:1.0}, null, 2.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.1 ,true );
        }

    }

}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.scene.game.DuelAvatars;
import view.BaseShowThread;
import view.BaseHideThread;

import model.Duel;

// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{

    public function ShowThread(da:DuelAvatars, stage:DisplayObjectContainer)
    {
        super(da, stage);
    }

    protected override function run():void
    {
        // デュエルの準備を待つ
        if (Duel.instance.inited == false)
        {
            Duel.instance.wait();
        }
        next(close);
    }
}

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(da:DuelAvatars)
    {
        super(da);
    }
}
