package view.scene.match
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.scene.BaseScene;
    import view.scene.common.CharaCardClip;
    import view.image.match.*;
    import view.utils.*;

    import controller.MatchCtrl;
    import model.*;
    import model.events.*;

    /**
     * 対戦ロビールームリスト表示部クラス
     *
     */
    public class RoomClip extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DUEL1	:String = "対戦部屋です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DUEL2	:String = "ルームにいるアバターの名前です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DUEL3	:String = "ルームにいるアバターのレベルです。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DUEL1	:String = "The battle room.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DUEL2	:String = "Names of avatars in this room.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DUEL3	:String = "Levels of avatars in this room.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DUEL1	:String = "對戰房間";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DUEL2	:String = "在對戰房裡的虛擬人物名稱。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DUEL3	:String = "在對戰房裡的虛擬人物等級";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DUEL1	:String = "对战室。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DUEL2	:String = "对战室内的虚拟人物的名称。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DUEL3	:String = "对战室内的虚拟人物的等级。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DUEL1	:String = "대전 룸입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DUEL2	:String = "룸에 있는 아바타의 이름입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DUEL3	:String = "룸에 있는 아바타의 레벨 입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DUEL1	:String = "Salle";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DUEL2	:String = "Nom des avatars présents dans la Salle";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DUEL3	:String = "Niveau des avatars présents dans la Salle";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DUEL1	:String = "対戦部屋です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DUEL2	:String = "ルームにいるアバターの名前です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DUEL3	:String = "ルームにいるアバターのレベルです。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DUEL1   :String = "ห้องประลอง";//"対戦部屋です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DUEL2   :String = "ชื่อของอวาตาร์ที่อยู่ในห้อง";//"ルームにいるアバターの名前です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DUEL3   :String = "เลเวลของอวาตาร์ที่อยู่ในห้อง";//"ルームにいるアバターのレベルです。";


        // マッチインスタンス
        private var _match:Match = Match.instance;

        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

        // 実体
        private var _rid:String;                                // 部屋ID

        private var _base:RoomBase = new RoomBase();             // 部屋のベース
        private var _roomId:Label = new Label();                 // 部屋ID
        private var _roomName:Label = new Label();               // 部屋名
        private var _avatarName:Array = [new Label(), new Label()];                           // Array of Label
        private var _friendMarkSet:Array = [new FriendMark(), new FriendMark()];                          // Array of Label
        private var _vsLabel:Label = new Label();                          // Array of Label

        // キャッシュ用
        public static var BaseCache:RoomBase;                 // 部屋のベース

        // 定数
        private static const _ROOM_X:int = 0;                   // 部屋位置X
        private static const _ROOM_Y:int = 0;                   // 部屋位置Y
        private static const _ROOM_ID_X:int = -10;                 // 部屋ID
        private static const _ROOM_ID_Y:int = -15;                 // 部屋ID
        private static const _ROOM_NAME_X:int = 25;              // 部屋名X
        private static const _ROOM_NAME_Y:int = 2;               // 部屋名Y
        private static const _AVATAR_NAME_X:int = 14;              // アバターの名前位置X
        private static const _AVATAR_NAME_Y:int = 20;             // アバターの名前位置Y
        private static const _OFFSET_X:int = 173;                // アバター表示のズレX
        private static const _VS_X:int = 155;                // アバター表示のズレX
        private static const _MARK_X:int = 2;                // アバター表示のズレX
        private static const _MARK_OFFSET:int = 173;                // アバター表示のズレX

        private static const _NAME_WIDTH:int = 275;                // 表示ラベルの幅
        private static const _NAME_HEIGHT:int = 20;                // 表示ラベルの高さ
        private static const _AVATAR_NAME_WIDTH:int = 145;                // 表示ラベルの幅
        private static const _AVATAR_NAME_HEIGHT:int = 18;                // 表示ラベルの高さ
//         private static const _WIDTH:int = 200;                // 表示ラベルの幅
//         private static const _HEIGHT:int = 20;                // 表示ラベルの高さ
        private static var listHash:Object = {};

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["対戦部屋です。",
//                 "ルームにいるアバターの名前です。",
//                 "ルームにいるアバターのレベルです。"],
                [_TRANS_MSG_DUEL1,
                 _TRANS_MSG_DUEL2,
                 _TRANS_MSG_DUEL3],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _MATCH_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function RoomClip(rid:String)
        {
            _rid = rid;
            _match.addEventListener(MatchRoomFriendEvent.UPDATE, friendInfoUpdateHandler);
            _container.addChild(_base);
             _vsLabel.visible = false;

            initializeLabel();
            initializeAvatarLabel();
        }

        public static function getRoom(rid:String):RoomClip
        {
            if(listHash[rid]==null)
            {
                listHash[rid] = new RoomClip(rid);
            }
            else
            {
                listHash[rid].finalizeLabel();
                listHash[rid].finalizeAvatarLabel();
                listHash[rid].initializeLabel();
                listHash[rid].initializeAvatarLabel();
            }
            return listHash[rid];
        }

        // 部屋を選択
        public static function currentChange(rid:String):void
        {
            for(var key:* in listHash)
            {
                if(listHash[key] == null)
                {
                    delete listHash[key];
                }else{
                    listHash[key].offSelect();
                }
            }
            listHash[rid].onSelect();
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray = [];
            _toolTipOwnerArray.push([0,this]);  //
            _avatarName.forEach(function(item:*, index:int, array:Array):void{_toolTipOwnerArray.push([1,item])});
//            _avatarLevel.forEach(function(item:*, index:int, array:Array):void{_toolTipOwnerArray.push([2,item])});
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

        // 初期化処理
        public override function init():void
        {
            _container.addEventListener(MouseEvent.CLICK, mouseClickHandler);
            _container.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            _container.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            addChild(_container);
            _base.x = _ROOM_X;
            _base.y = _ROOM_Y;
            _roomId.x = _ROOM_ID_X;
            _roomId.y = _ROOM_ID_Y;
            _roomName.x = _ROOM_NAME_X;
            _roomName.y = _ROOM_NAME_Y;

            _roomId.styleName = _roomName.styleName = "GameLobbyRoomClipNameLabel";

            _roomId.width = _roomName.width = _NAME_WIDTH;
            _roomId.height = _roomName.height = _NAME_HEIGHT;

            _container.addChild(_roomId);
            _container.addChild(_roomName);


            for(var i:int = 0; i < 2; i++){

                _friendMarkSet[i].y = _AVATAR_NAME_Y+2;
                _avatarName[i].y = _AVATAR_NAME_Y;
                _avatarName[i].styleName = "GameLobbyRoomClipLabel";
                _avatarName[i].width = _AVATAR_NAME_WIDTH;
                _avatarName[i].height= _AVATAR_NAME_HEIGHT;

                _container.addChild(_avatarName[i]);
//                _container.addChild(_avatarLevel[i]);
//                _container.addChild(_friendMarkSet[i]);
                _friendMarkSet[i].x = _MARK_X + i * _MARK_OFFSET;
            }
             _vsLabel.x = _VS_X;
             _vsLabel.y  = _AVATAR_NAME_Y;
             _vsLabel.text = "VS";
             _vsLabel.width = 24;
             _vsLabel.height = _AVATAR_NAME_HEIGHT;
             _vsLabel.styleName = "GameLobbyRoomClipLabel";
             _container.addChild(_vsLabel);


        }

        // 後始末処理
        public override function final():void
        {
            _container.removeChild(_base);
            finalizeLabel();
            finalizeAvatarLabel();

            _container.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
            _container.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            _container.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            _match.removeEventListener(MatchRoomFriendEvent.UPDATE, friendInfoUpdateHandler);
            removeChild(_container);
            delete(listHash[_rid]);
//            listHash[_rid] = null;
        }

        // ラベルを初期化する
        public function initializeLabel():void
        {
            _roomName.text = MatchRoom.list[rid].name;
            _base.setRule(MatchRoom.list[rid].rule);
            _base.setChannel(Channel.currentChannelID);
        }

        // アバターデータ表示ラベルの初期化
        public function initializeAvatarLabel():void
        {
            var avatar_ids:Array = [0,0];
            for(var i:int = 0; i < MatchRoom.list[rid].length; i++)
            {
                _avatarName[i].text = "Lv." + MatchRoom.list[rid].avatarLevel[i] + " " + MatchRoom.list[rid].avatarName[i];
//                _avatarName[i].text += "Lv." + "99" + " " + "ああああああ";

                _avatarName[i].x = _AVATAR_NAME_X + i * _OFFSET_X;
//                _friendMarkSet[i].x = _MARK_X + i * _MARK_OFFSET;
                avatar_ids[i] = MatchRoom.list[rid].avatarId[i];
                if (FriendLink.isFriend(MatchRoom.list[rid].avatarId[i]))
                {
                    _container.addChild(_friendMarkSet[i]);
                }else{
                    RemoveChild.apply(_friendMarkSet[i]);

                }

            }

            MatchCtrl.instance.roomFriendCheck(rid, avatar_ids[0], avatar_ids[1]);

            if(MatchRoom.list[rid].length ==1)
            {
                if(MatchRoom.list[rid].avatarId[0] == 1)
                {
                    _base.onCpu();
                }
                else
                {
                    _base.offCapacity();
                }
                _vsLabel.visible = false;
            }
            else
            {
                _base.onCapacity();
                _vsLabel.visible = true;
            }

            initilizeToolTipOwners();
            updateHelp(_MATCH_HELP);
        }


        // ラベルの後始末
        public function finalizeLabel():void
        {
            RemoveChild.apply(_roomId);
            RemoveChild.apply(_roomName);
            // _container.removeChild(_roomId);
            // _container.removeChild(_roomName);
        }

        // アバターデータ表示ラベルの後始末
        public function finalizeAvatarLabel():void
        {
            for(var i:int = 0; i < 2; i++)
            {
                // 1人部屋かどうかを確認してから外す
                if (_avatarName[i].parent == _container)
                {
                    RemoveChild.apply(_avatarName[i]);
//                    _container.removeChild(_avatarName[i]);
//                    _container.removeChild(_chLevel[i]);
                };
            };
        }

        // 情報をアップデートする
        public function update():void
        {
//            finalizeLabel();
//            finalizeAvatarLabel();
            initializeLabel();
            initializeAvatarLabel();
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }

        // 非表示スレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }

        // マウスアウト処理
        public function mouseOutHandler(e:MouseEvent):void
        {
            _match.overRoomId = "";
        }

        // マウスオーバー処理
        public function mouseOverHandler(e:MouseEvent):void
        {
            _match.overRoomId = rid;
        }

        // マウスクリック処理
        public function mouseClickHandler(e:MouseEvent):void
        {
            _match.currentRoomId = rid;
        }

        public function friendInfoUpdateHandler(e:MatchRoomFriendEvent):void
        {
            if (_rid == e.roomId)
            {
                RemoveChild.apply(_friendMarkSet[0]);
                RemoveChild.apply(_friendMarkSet[1]);

                if (e.hostIsFriend)
                {
                    _container.addChild(_friendMarkSet[0]);
                }
                if (e.guestIsFriend)
                {
                    _container.addChild(_friendMarkSet[1]);
                }
            }
        }

        // 選択状態
        public function onSelect():void
        {
            _base.onSelect();
        }

        // 選択状態
        public function offSelect():void
        {
            _base.offSelect();
        }


        // 部屋の取得する
        public function get rid():String
        {
            return _rid;
        }

        // 画面に表示する
        public function show():void
        {
            _container.visible = true;
        }

        // 表示を消す
        public function hide():void
        {
            _container.visible = false;
        }
    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.DeckEditor;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.match.RoomClip;

class ShowThread extends BaseShowThread
{
    public function ShowThread(rc:RoomClip, stage:DisplayObjectContainer, at:int)
    {
        super(rc, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(rc:RoomClip)
    {
        super(rc);
    }
}
