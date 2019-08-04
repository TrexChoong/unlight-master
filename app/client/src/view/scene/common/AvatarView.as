package view.scene.common
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.filters.GlowFilter;


    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.common.*;
    import view.scene.BaseScene;
    import view.scene.common.AvatarClip;
    import view.*;
    import view.ClousureThread;
    import view.utils.*;

    import model.Player;
    import model.Avatar;
    import model.Match;
    import model.AvatarItem;
    import model.events.*;

    /**
     * プレイヤーアバター表示部分のクラス
     *
     */
    public class AvatarView extends BaseScene
    {
//         public static const TYPE_LOBBY:int = 0;
//         public static const TYPE_MATCH_ROOM:int = 1;
//         public static const TYPE_MATCH:int = 2;
//         public static const TYPE_EDIT:int = 3;
//         public static const TYPE_QUEST:int = 4;

        private static const _HIDE_NEXT_EXP_STR:String = "-----";

        // アバターインスタンス
        private var _avatar:Avatar;

        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

        private  var _avatarClip:AvatarClip;

        // 表示ベース
        private var _base:AvatarDetailBase = new AvatarDetailBase();

        private var _name:Label = new Label();                                             // 名前ラベル
        private var _energy:Label = new Label();                                           // 行動力ラベル
        private var _exp:Label = new Label();                                              // 経験値ラベル
        private var _gems:Label = new Label();                                             // ジェムラベル

        private var _nameTitle:Label = new Label();                                        // 名前ラベルタイトル
        private var _expTitle:Label = new Label();                                         // 経験値ラベルタイトル
        private var _gemsTitle:Label = new Label();                                        // ジェムラベルタイトル

        private var _friendListButton:FriendListButton = new FriendListButton();
        private var _achievementListButton:AchievementListButton = new AchievementListButton();
        private var _itemListButton:ItemListButton = new ItemListButton();
        private var _freeDuelCount:FreeDuelCountScene = new FreeDuelCountScene();


//         private var _namePlate:AvatarParamPlate = new AvatarParamPlate();                  // 名前ラベルタイトル
//         private var _expPlate:AvatarParamPlate = new AvatarParamPlate();                   // 経験値ラベルタイトル
//         private var _gemsPlate:AvatarParamPlate = new AvatarParamPlate();                  // ジェムラベルタイトル

        private var _ap:ActionPointGauge = new ActionPointGauge();                         // ジェムラベルタイトル
//
        private var _state:AvatarStateScene = new AvatarStateScene();

        private var _inited:Boolean = false;                                               // 初期化済みか？
                                                                                           // 定数
                                                                                           // 全体のXY
        // 0:LOBBY 1:MATCH 2:MATCH_ROOM 3:EDIT 5:QUEST
        private const _X_SET:Vector.<int> = Vector.<int>([785,  0, 785, 785, 785]);             // アバターのX位置
        private const _Y_SET:Vector.<int> = Vector.<int>([330, 50, 330, 330, 330]);             // アバターのY位置
        private const _SCALE_SET:Vector.<Number> = Vector.<Number>([1.0, 1.0, 1.0, 1.0, 1.0]); // ラベルのサイズ
        private const _DIRECTION_SET:Vector.<int> = Vector.<int >([-1, -1, -1, -1, -1]);       // 方向
        private const _AVATAR_X_SET:Vector.<int > = Vector.<int >([-296, -20,-260, -260, -260]) ;         // ラベルのX位置
        private const _AVATAR_Y_SET:Vector.<int > = Vector.<int >([-100,250,-100, -100, -100]);        // ラベルのX位置
        private const _AVATAR_VISIBLE_SET:Vector.<Boolean> = Vector.<Boolean >([true, true, true, false, true]);       // 方向
        private const _AVATAR_STATE_VISIBLE_SET:Vector.<Boolean> = Vector.<Boolean >([true, false, true, false, true]);       // 方向

        private const _FRIEND_LIST_VISIBLE_SET:Vector.<Boolean> = Vector.<Boolean >([true, true, true,false,false]);       // 方向

        private const _AP_X_SET:Vector.<int > = Vector.<int >([-80, 75, -80, -80, -80]);         // ラベルのX位置
        private const _AP_Y_SET:Vector.<int > = Vector.<int >([316, -145, 316, 316, 316]);      // ラベルのY位置

        private const _LABEL_X_SET:Vector.<int > = Vector.<int >([-118, 50, -118, 110, 110]);     // ラベルのX位置
        private const _LABEL_Y_SET:Vector.<int > = Vector.<int >([295, 20, 295, 110, 110]);      // ラベルのY位置
        private const _LABEL_WIDTH:int = 170;                                              // ラベルの幅
        private const _LABEL_HEIGHT:int = 30;                                              // ラベルの高さ
        private const _LABEL_Y_DIF:int = 30;                                               // ラベルの配置の差分

        private const _CHANGE_X:int = 964;                                                 //        private const _CHANGE_Y:int = 693;                                                 //
        private const _CHANGE_OFFSET_X:int = 20;                                           //
        private const _CHANGE_OFFSET_Y:int = 30;                                           //

        private const _NAME_X:int = -820;                                                  // 名前タイトル
        private const _NAME_Y:int = 330;                                                   // 名前タイトル
        private const _GEMS_X:int = -635;                                                  // ジェムタイトル
        private const _GEMS_Y:int = 330;                                                   // ジェムタイトル
        private const _EXP_X:int = -405;                                                   // 経験値タイトル
        private const _EXP_Y:int = 330;                                                    // 経験値タイトル
        private const _ENERGY_X:int = -58;                                                    // 経験値タイトル
        private const _DATEIL_OFFSET_X:int = 39;                                           // ジェムタイトル
        public static const CURRENT_TYPE:int = -1;


        private static var __currentPlayerID:int;
        private static var __playerAvatar:AvatarView;                                 // プレイヤーアバターの単一インスタンス

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array  =
            [
                [""],
            ];

        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _MATCH_HELP:int = 0;

        private var _type:int = 0;

        private var _reloadCount:int;


        /**
         * コンストラクタ
         *
         */

        // -1はカレントタイプそのまま
        public static function getPlayerAvatar(type:int):AvatarView
        {
            if (__playerAvatar == null)
            {
                __playerAvatar = new AvatarView();
            }
            if(type > -1)
            {
                __playerAvatar.setType(type);
            }
            return __playerAvatar;
        }


        public function AvatarView()
        {
             mouseEnabled = false;
             _container.mouseEnabled = false;
//             mouseChildren = false;
                alpha = 0;
                _reloadCount = Unlight.RELOAD_COUNT;
        }

        private function setType(type:int):void
        {
            log.writeLog(log.LV_FATAL, this, "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! TYPE                    ",type);
            _type = type;
        }
        private function reloadCheck():Boolean
        {
            if (Unlight.RELOAD_COUNT!=_reloadCount)
            {
                _reloadCount = Unlight.RELOAD_COUNT;
                return true;
            }else{
                return false;
            }
        }

        public function refreshType(type:int= -1):void
        {
            _avatar = Player.instance.avatar;
            // 初回処理
            if (_avatarClip == null)
            {
                __currentPlayerID = Player.instance.id
                _avatarClip = new AvatarClip( Player.instance.avatar);
                log.writeLog(log.LV_FATAL, this, " refresh done REMAIN TIME IS ", _avatar.remainTime);
//                _ap.setRemainTime(_avatar);
            }else{
                // 再ログインの
                if (reloadCheck())
                {
                    log.writeLog(log.LV_FATAL, this, "ReLogin!!!!!!!!!!! !!!!!!",Player.instance.avatar.getEquipedParts(),_avatar.remainTime);
                    _avatarClip.getHideThread().start();
                    _avatarClip = new AvatarClip(Player.instance.avatar);
                    _avatarClip.updateType(_type);
//                    _ap.setRemainTime(_avatar);
                    resetPosition();
                    initAvatarData();
                    __currentPlayerID = Player.instance.id;
                    return;
                }
            }
                resetPosition();
        }

        public function partsUpdate():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var thread:Thread = _avatarClip.getPartsChangeHideThread();
            _avatarClip = new AvatarClip(Player.instance.avatar);
            _avatarClip.updateType(_type);
            resetPosition();
            sExec.addThread(_avatarClip.getPartsChangeShowThread(_container, 0));
            sExec.addThread(thread);
            sExec.start();
            _base.back.visible = true;
//             _avatarClip.getPartsChangeShowThread(_container, 0).start();

//            thread.start()
        }


        private function resetPosition():void
        {
            _container.x = _X_SET[_type];
            _container.y = _Y_SET[_type];

            _avatarClip.x = _AVATAR_X_SET[_type];
            _avatarClip.y = _AVATAR_Y_SET[_type];
            _avatarClip.visible = _AVATAR_VISIBLE_SET[_type];
            _state.visible = _AVATAR_STATE_VISIBLE_SET[_type]
            _ap.scaleX = _SCALE_SET[_type];
            _ap.scaleY = _SCALE_SET[_type];
            _ap.x = _AP_X_SET[_type];
            _ap.y = _AP_Y_SET[_type];

            _freeDuelCount.x = _AP_X_SET[_type];
            _freeDuelCount.y = _AP_Y_SET[_type];

            _avatarClip.updateType(_type);

            _friendListButton.visible = _FRIEND_LIST_VISIBLE_SET[_type]
            _achievementListButton.visible = _FRIEND_LIST_VISIBLE_SET[_type]
            _itemListButton.visible = _FRIEND_LIST_VISIBLE_SET[_type]

            // exitを消す
            _type == Const.PL_AVATAR_LOBBY ? _base.back.visible = false : _base.back.visible = true;


        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);
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

        // 初期化
        public override function init():void
        {
//            _avatar = Player.instance.avatar;
            _avatar.addEventListener(Avatar.ENERGY_UPDATE, avatarUpdateHandler);
            _avatar.addEventListener(Avatar.GEMS_UPDATE, avatarUpdateHandler);
            _avatar.addEventListener(Avatar.EXP_UPDATE, avatarUpdateHandler);
            _avatar.addEventListener(Avatar.LEVEL_UPDATE, avatarUpdateHandler);
            _avatar.addEventListener(Avatar.ENERGY_MAX_UPDATE, avatarUpdateHandler);
            _avatar.addEventListener(Avatar.FREE_DUEL_COUNT_UPDATE, avatarUpdateHandler);

            _avatar.addEventListener(Avatar.QUEST_MAX_UPDATE, avatarUpdateHandler);
            _avatar.addEventListener(Avatar.UPDATE_RECOVERY_INTERVAL, avatarUpdateHandler);
            _avatar.addEventListener(Avatar.UPDATE_BONUS, avatarUpdateHandler);
            if (!_inited)
            {
                initilizeToolTipOwners();
                updateHelp(_MATCH_HELP);
                initAvatarData();
                _inited = true;
            }
            addChild(_base);
            addChild(_container);
            addChild(_friendListButton);
            addChild(_achievementListButton);
            addChild(_itemListButton);
        }

        // 終了
        public override function final():void
        {
            _avatar.removeEventListener(Avatar.ENERGY_UPDATE, avatarUpdateHandler)
            _avatar.removeEventListener(Avatar.GEMS_UPDATE, avatarUpdateHandler)
            _avatar.removeEventListener(Avatar.EXP_UPDATE, avatarUpdateHandler)
            _avatar.removeEventListener(Avatar.LEVEL_UPDATE, avatarUpdateHandler)
            _avatar.removeEventListener(Avatar.ENERGY_MAX_UPDATE, avatarUpdateHandler)
            _avatar.removeEventListener(Avatar.FREE_DUEL_COUNT_UPDATE, avatarUpdateHandler);
            RemoveChild.apply(_container);
            RemoveChild.apply(_base);
            // removeChild(_container);
            // removeChild(_base);
            RemoveChild.all(this);
        }

        // アバター部分の表示の初期化
        private function initAvatarData():void
        {

            _name.width = _energy.width = _exp.width = _gems.width = _LABEL_WIDTH;
            _name.height = _energy.height = _exp.height = _gems.height = _LABEL_HEIGHT;
            _nameTitle.width =  _expTitle.width = _gemsTitle.width = _LABEL_WIDTH;
            _nameTitle.height = _expTitle.height = _gemsTitle.height = _LABEL_HEIGHT;

            _energy.width = 120;

            // 値の設定
            _name.htmlText = "Lv." +_avatar.level + " " + _avatar.name;
            _energy.htmlText =   _avatar.energy.toString() + "/" +_avatar.energyMax.toString()  ;
            var nextExpStr:String = (_avatar.nextExp != 0) ? _avatar.nextExp.toString() : _HIDE_NEXT_EXP_STR;
            _exp.htmlText =  _avatar.exp.toString() + "/" + nextExpStr;
            _gems.htmlText =  _avatar.gems.toString();

            _nameTitle.text = "Name";
            _expTitle.text =  "Exp";
            _gemsTitle.text =  "Gem";

            _nameTitle.x = _NAME_X;
            _nameTitle.y = _NAME_Y;
            _gemsTitle.x = _GEMS_X;
            _gemsTitle.y = _GEMS_Y;
            _expTitle.x = _EXP_X;
            _expTitle.y = _EXP_Y;

            _name.x = _NAME_X + _DATEIL_OFFSET_X;
            _name.y = _NAME_Y;
            _gems.x = _GEMS_X + _DATEIL_OFFSET_X;
            _gems.y = _GEMS_Y;
            _exp.x = _EXP_X + _DATEIL_OFFSET_X;
            _exp.y = _EXP_Y;

            _energy.x = _ENERGY_X;
            _name.styleName = "GameLobbyAvatarName";
            _exp.styleName =_gems.styleName = "GameLobbyAvatarLabel";

            _nameTitle.styleName  = _expTitle.styleName =_gemsTitle.styleName = "GameLobbyAvatarTitleLabel";
            _energy.styleName = "GameLobbyAvatarAPLabel";
            _energy.filters = [new GlowFilter(0x000000, 1, 4, 4, 16, 1)];
            _avatarClip.getShowThread(_container, 0).start();
            _freeDuelCount.getShowThread(_container,100).start();

//            _container.addChild(_ap);
            _ap.avatar = _avatar;
            _ap.getShowThread(_container,99).start();
            _ap.addChild(_energy);
            _state.setState(_avatar.expPow, _avatar.gemsPow, _avatar.recoveryInterval, _avatar.questMax, _avatar.questFindPow);
            _state.getShowThread(_container,1000).start();

            _freeDuelCount.countUpdate(_avatar.freeDuelCount)
            _container.addChild(_name);
            _container.addChild(_exp);
            _container.addChild(_gems);
            new WaitThread(1000,_state.setState, [_avatar.expPow, _avatar.gemsPow, _avatar.recoveryInterval, _avatar.questMax, _avatar.questFindPow]).start();

        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new ClousureThread(refreshType));
            sExec.addThread(super.getShowThread( stage, at));
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:1.0}, null, 1.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.2 / Unlight.SPEED ,true));
            return sExec;
        }

        // アバターをロードするだけスレッドを返す
        public function getLoadThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new ClousureThread(refreshType));
            sExec.addThread(super.getShowThread( stage, at));
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.1 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.2 / Unlight.SPEED ,false));
            return sExec;
        }

        // 非表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }

        // アバターアップデート時のハンドラ
        public function avatarUpdateHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "view update!!", _avatar.level, _avatar.energy, _avatar.exp, _avatar.gems,_avatar.remainTime);
            _name.text = "Lv." +_avatar.level + " " + _avatar.name;
            _energy.htmlText = _avatar.energy.toString() + "/" +_avatar.energyMax.toString()  ;
            var nextExpStr:String = (_avatar.nextExp != 0) ? _avatar.nextExp.toString() : _HIDE_NEXT_EXP_STR;
            _exp.htmlText =  _avatar.exp.toString() + "/" + nextExpStr;
            _gems.text =  _avatar.gems.toString();
            _freeDuelCount.countUpdate(_avatar.freeDuelCount);
            _ap.setRemainTime();
            _state.setState(_avatar.expPow, _avatar.gemsPow, _avatar.recoveryInterval, _avatar.questMax, _avatar.questFindPow);
        }
        private function stateUpdate():void
        {

        }

        public function get exitButton():SimpleButton
        {
            return _base.back;
//             return _base.exit;
        }

        public function get logoutButton():SimpleButton
        {
            return _base.logout;
        }
        public function get base():DisplayObject
        {
            return _base;
        }

        public function stopUpdateTimer():void
        {
            if (_ap)
            {
                _ap.stopUpdateTimer();
            }
        }

        public function startUpdateTimer():void
        {
            if (_ap)
            {
                _ap.startUpdateTimer();
            }
        }

    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.common.AvatarView;


// class ShowThread extends BaseShowThread
// {
//     public function ShowThread(aa:AvatarView, stage:DisplayObjectContainer, at:int)
//     {
//         super(aa, stage);
//     }

//     protected override function run():void
//     {
//         next(close);
//     }
// }

class HideThread extends BaseHideThread
{
    public function HideThread(aa:AvatarView)
    {
        super(aa);
    }

    protected override function run():void
    {
        var thread:Thread = new BeTweenAS3Thread(_view, {alpha:0.0}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false);
        thread.start();
        thread.join();
        next(exit)
    }


}
