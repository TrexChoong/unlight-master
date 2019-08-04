package view.scene.common
{
    import flash.utils.IDataInput;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.*;

    import mx.controls.Label;
    import mx.controls.Text;
    import mx.controls.Button;
    import mx.core.UIComponent;
    import mx.containers.Canvas;
    import mx.core.IDataRenderer;
    import mx.events.FlexEvent;

    import model.*;

    import view.scene.BaseScene;
    import view.utils.*;

    public class FriendListContainer extends UIComponent
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DEL	:String = "をフレンドリストから削除しますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ASK	:String = "へフレンド申し込みをおこないますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ALLOW	:String = "をフレンド許可しますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_UNBLOCK	:String = "をブロック解除しますか？";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DEL_PRE	:String = "Delete ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DEL	:String = " from your friend list?";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ASK_PRE	:String = "Send a friend request to ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ASK	:String = "?";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ALLOW_PRE	:String = "Authorize ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ALLOW	:String = "?";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_UNBLOCK_PRE	:String = "Unblock ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_UNBLOCK	:String = "？";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DEL_PRE	:String = "要把";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DEL	:String = "從朋友名單中刪除嗎？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ASK_PRE	:String = "要向";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ASK	:String = "申請成為朋友嗎？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ALLOW_PRE	:String = "要同意";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ALLOW	:String = "成為您的朋友嗎？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_UNBLOCK_PRE	:String = "要同意";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_UNBLOCK	:String = "";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DEL_PRE	:String = "是否要将";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DEL	:String = "从好友名单中删除？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ASK_PRE	:String = "是否要向";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ASK	:String = "发送好友申请？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ALLOW_PRE	:String = "是否同意让";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ALLOW	:String = "加入您的好友名单？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_UNBLOCK_PRE	:String = "是否解除对";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_UNBLOCK	:String = "的屏蔽？";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DEL	:String = "을(를) 친구 리스트에서 삭제하겠습니까?";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ASK	:String = "을(를) 친구 신청을 하겠습니까?";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ALLOW	:String = "을(를) 친구 신청을 허가하겠습니까?";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_UNBLOCK	:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DEL_PRE	:String = "Supprimer ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DEL	:String = " de la liste d'amis ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ASK_PRE	:String = "Demander à devenir ami avec ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ASK	:String = " ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ALLOW_PRE	:String = "Autoriser ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ALLOW	:String = " ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_UNBLOCK_PRE	:String = "Voulez-vous bloquer ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_UNBLOCK	:String = "？";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DEL_PRE	:String = "Supprimer ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DEL	:String = " de la liste d'amis ?";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ASK_PRE	:String = "Demander à devenir ami avec ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ASK	:String = " ?";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ALLOW_PRE	:String = "Autoriser ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ALLOW	:String = " ?";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_UNBLOCK_PRE	:String = "Voulez-vous bloquer ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_UNBLOCK	:String = "？";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DEL_PRE :String = "จะลบ ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DEL :String = " ออกจากรายชื่อเพื่อนหรือไม่?";//"をフレンドリストから削除しますか？";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ASK_PRE :String = "จะรับ ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ASK :String = "เป็นเพื่อนหรือไม่?";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ALLOW_PRE   :String = "จะรับ ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ALLOW   :String = "เป็นเพื่อนหรือไม่?";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_UNBLOCK_PRE :String = "จะบล็อค ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_UNBLOCK :String = "หรือไม่?";



        private static var __instance:FriendListContainer;

        public static const TAB_FRIEND:int   = 0;
        public static const TAB_WAITING:int  = 1;
        public static const TAB_BLOCKING:int = 2;
        public static const TAB_SEARCH:int   = 3;
        public static const TAB_SIZE:int     = 4;

        public static const BLOCK_MAX:int    = 10;

        private var _avatar:Avatar = Player.instance.avatar;

        private var _currentTab:int = 0;
        private var _friendMax:int = 0;

        public static var presentMode:Boolean = false;

        private var _friendAvatarDic:Dictionary = new Dictionary(); // アバター顔画像のキャッシュ

        private var _pageNumSet:Vector.<int> = Vector.<int>([0,0,0,0]); // 今いるページのセット
        private var _counterSet:Vector.<int> = Vector.<int>([0,0,0,0]); // 要素数
        private var _containerSet:Vector.<UIComponent>  =  Vector.<UIComponent>(
            [
                new UIComponent(),
                new UIComponent(),
                new UIComponent(),
                new UIComponent()
                ]);

        private var _friendLinkSet:Vector.<Vector.<FriendLink>>  =  Vector.<Vector.<FriendLink>>(
            [
                new Vector.<FriendLink>(FriendLink.FRIEND_LIST_MAX),
                new Vector.<FriendLink>(FriendLink.FRIEND_LIST_MAX),
                new Vector.<FriendLink>(FriendLink.FRIEND_LIST_MAX),
                new Vector.<FriendLink>(FriendLink.FRIEND_LIST_MAX)
                ]);
//        protected var _slotSets:Vector.<Vector.<SlotImage>> = Vector.<Vector.<SlotImage>>([new Vector.<SlotImage>(), new Vector.<SlotImage>(), new Vector.<SlotImage>()]);

//         private var _title:Label = new Label();
        private var _pageNum:Label = new Label();
        private var _friendNum:Label = new Label();

        // ページ用ボタン表示切替関数
        private var _pageBtnVisibleFunc:Function = null;


//        public static const DELETE_ALERT:String = "をフレンドリストから削除しますか？";
        public static const DELETE_ALERT:String = _TRANS_MSG_DEL;
//        public static const COFIRM_ALERT:String = "へフレンド申し込みをおこないますか？";
        public static const COFIRM_ALERT:String = _TRANS_MSG_ASK;
//        public static const OK_ALERT:String     = "をフレンド許可しますか？";
        public static const OK_ALERT:String     = _TRANS_MSG_ALLOW;
//        public static const REMOVE_ALERT:String = "をブロック解除しまうすか？";
        public static const REMOVE_ALERT:String = _TRANS_MSG_UNBLOCK;

        private static const _AVATAR_CLIP_X:int = 32;
        private static const _AVATAR_CLIP_Y:int = 70;
        private static const _AVATAR_CLIP_W:int = 94;
        private static const _AVATAR_CLIP_H:int = 145;
        private static const _AVATAR_CLIP_COLUMN:int = 5;
        private static const _AVATAR_CLIP_ROW:int = 2;

        private static const _PAGE_LABEL_X:int = 253;
        private static const _PAGE_LABEL_Y:int = 360;
        private static const _PAGE_LABEL_W:int = 50;
        private static const _PAGE_LABEL_H:int = 20;

        private static const _FRIEND_LABEL_X:int = 432;
        private static const _FRIEND_LABEL_Y:int = 50;
        private static const _FRIEND_LABEL_W:int = 90;
        private static const _FRIEND_LABEL_H:int = 32;

        private static const PAGE_MAX:int = _AVATAR_CLIP_COLUMN*_AVATAR_CLIP_ROW;


        // コンテナを取る
        public static function get instance():FriendListContainer
        {
            if (__instance == null)
            {
                __instance = new FriendListContainer();
            }
            return __instance;
        }

        public function FriendListContainer()
        {
            _pageNum.x = _PAGE_LABEL_X;
            _pageNum.y = _PAGE_LABEL_Y;
            _pageNum.height = _PAGE_LABEL_H;
            _pageNum.width = _PAGE_LABEL_W;
            _pageNum.setStyle("textAlign",  "center");
            addChild(_pageNum);

            _friendNum.x = _FRIEND_LABEL_X;
            _friendNum.y = _FRIEND_LABEL_Y;
            _friendNum.height = _FRIEND_LABEL_H;
            _friendNum.width = _FRIEND_LABEL_W;
            addChild(_friendNum);
            updateFriendMax();
            setTab(TAB_FRIEND);
            updateList();

            _avatar.addEventListener(Avatar.FRIEND_MAX_UPDATE, updateFriendMaxHandler);
//            updatePosition();
        }

        // 更新
        public static function update():void
        {
            if (__instance != null)
            {
                __instance.updateFriendMax();
                __instance.updateList();
                __instance.updatePosition();
                __instance.pageNumUpdate();
                __instance.pageBtnUpdate();
            }
        }

        // コンテナのクリップを並べ直す
        private function updatePosition():void
        {
//            log.writeLog(log.LV_FATAL, this, "update pos");
            var avaibleList:Vector.<int> = new Vector.<int>();
//             // タブごとに並べ直す
//             for(var j:int = 0; j < TAB_SIZE; j++)
//             {
//                 var len:int = _friendLinkSet[j].length;
//                 for(var i:int = 0; i < len; i++){
// //                    setPosition(i, getOtherAvatarImage(_friendLinkSet[j][i]),j);
//                     if (_friendLinkSet[j][i]) {
//                         setPosition(i, _friendLinkSet[j][i],j);
//                         avaibleList.push(_friendLinkSet[j][i].avatarId);
//                     }
//                 }
//             }

            var i:int;
            var key:Object;
            if (convertFlType(_currentTab) != -1) {
                // 一度全部消してしまう
                for (key in _friendAvatarDic) {
                    RemoveChild.apply(_friendAvatarDic[key]);
                }

                // 現在ページのアバターを表示
                for(i = 0;i < PAGE_MAX;i ++) {
                    var offset:int = (currentPage()-1)*PAGE_MAX;
                    if (_friendLinkSet[_currentTab][i+offset]) {
                        setPosition(i+offset, _friendLinkSet[_currentTab][i+offset],_currentTab);
                    }
                }
            } else {
                var len:int = _friendLinkSet[_currentTab].length;
                for(i = 0; i < len; i++){
//                    setPosition(i, getOtherAvatarImage(_friendLinkSet[_currentTab][i]),j);
                    if (_friendLinkSet[_currentTab][i]) {
                        setPosition(i, _friendLinkSet[_currentTab][i],_currentTab);
                        avaibleList.push(_friendLinkSet[_currentTab][i].avatarId);
                    }
                }

                // 存在しなくなったフレンドアバターを消す
                for (key in _friendAvatarDic) {
//                log.writeLog(log.LV_FATAL, this, "delete check");
                    if(avaibleList.indexOf(key) == -1)
                    {
//                    log.writeLog(log.LV_FATAL, this, "delete");
                        RemoveChild.apply(_friendAvatarDic[key]);
                    }
                }
            }



        }

        // クリップを正しい位置に置く
//        private function setPosition(i:int, bs:BaseScene, tabType:int):void
        private function setPosition(i:int, flink:FriendLink, tabType:int):void
        {
            var pageNum:int = int(i/PAGE_MAX);
            var pos:int = i%PAGE_MAX;
            var collumn:int = int(pos%_AVATAR_CLIP_COLUMN);
            var row:int = int(pos/_AVATAR_CLIP_COLUMN);
            log.writeLog(log.LV_FATAL, this, "++ set positon ",pageNum, pos, collumn,row,tabType);

            log.writeLog(log.LV_DEBUG, this, "setPoosition",flink.avatarId,(_pageNumSet[tabType] == pageNum));
            // 現在のページなら
            if(_pageNumSet[tabType] == pageNum)
            {
                var bs:BaseScene = getOtherAvatarImage(flink)
                bs.x = _AVATAR_CLIP_X + collumn*_AVATAR_CLIP_W;
                bs.y = _AVATAR_CLIP_Y + row*_AVATAR_CLIP_H;
                _containerSet[tabType].addChild(bs);
//                bs.getShowThread().start()
            }else{
                if (_friendAvatarDic[flink.avatarId]!=null)
                {
                    RemoveChild.apply(_friendAvatarDic[flink.avatarId]);
                }

            }

        }

        public function nextPage():void
        {
            if ((currentPage()) < currentPageNum())
            {
                _pageNumSet[_currentTab] = _pageNumSet[_currentTab] +1;
                updateList();
                updatePosition();
                pageNumUpdate();
                pageBtnUpdate();
            }
            else if ((currentPage()) == currentPageNum() && (currentPage()) > 1)
            {
                _pageNumSet[_currentTab] = 0;
                updateList();
                updatePosition();
                pageNumUpdate();
                pageBtnUpdate();
            }
        }

        public function prevPage():void
        {
            if ((currentPage()) > 1)
            {
                _pageNumSet[_currentTab] = _pageNumSet[_currentTab] -1;
                updateList();
                updatePosition();
                pageNumUpdate();
                pageBtnUpdate();
            }
            else if ((currentPage()) == 1 && currentPageNum() > 1)
            {
                _pageNumSet[_currentTab] = currentPageNum() - 1;
                updateList();
                updatePosition();
                pageNumUpdate();
                pageBtnUpdate();
            }
        }

        public function resetPage():void
        {
            if ((currentPage()) > 1)
            {
                _pageNumSet[_currentTab] = 0;
                updateList();
                updatePosition();
                pageNumUpdate();
                pageBtnUpdate();
            }
        }

        // 表示タブをセット
        public function setTab(tabType:int):void
        {
            _currentTab = tabType;
            updateList();
            updatePosition();
            // セットされたタブだけ表示する
            for(var j:int = 0; j < TAB_SIZE; j++){
                if (j == tabType)
                {
                    addChild(_containerSet[j]);
                }else{
                    RemoveChild.apply(_containerSet[j])
                }
            }
            _friendNum.visible = (tabType == TAB_FRIEND||tabType == TAB_BLOCKING)
            pageNumUpdate();
            pageBtnUpdate();
        }

        private function pageNumUpdate():void
        {
            _pageNum.text = currentPage()+"/"+Math.max(currentPageNum(),1);
            if (_currentTab == TAB_FRIEND)
            {
                _friendNum.text = "Friend "+FriendLink.getFriendNum()+"/"+_friendMax;
            }else if (_currentTab == TAB_BLOCKING)
            {
                _friendNum.text = "Blocked "+FriendLink.getBlockNum()+"/"+BLOCK_MAX;
            }
        }

        public function currentTabListNum():int
        {
            var ret:int = 0;
            if (_currentTab == TAB_FRIEND)
            {
                ret = FriendLink.getFriendNum();
            }else if (_currentTab == TAB_BLOCKING)
            {
                ret = FriendLink.getBlockNum();
            }else if (_currentTab == TAB_WAITING)
            {
                ret = FriendLink.getRequestNum();
            }else if (_currentTab ==  TAB_SEARCH)
            {
                ret = FriendLink.getRequestNum();
            }
            return ret;
        }

        public function currentPageNum():int
        {
            return int(currentTabListNum()/(PAGE_MAX)+ 1);
        }
        public function currentPage():int
        {
            return (_pageNumSet[_currentTab]+1)
        }

        private function pageBtnUpdate():void
        {
            if (_pageBtnVisibleFunc != null) {
                var vsbl:Boolean = (currentPageNum() > 1);
                _pageBtnVisibleFunc(vsbl,vsbl);
            }
        }
        public function setPageBtnVisibleFunc(func:Function):void
        {
            if (func != null) {
                _pageBtnVisibleFunc = func;
            }
        }

        // フレンドリストを表示リストとして再構成
        private function updateList():void
        {
            // // タブごとのフレンドリストセットを空に戻す
            // for(var j:int = 0; j < TAB_SIZE; j++){
            //     if (_friendLinkSet[j].length > 0)
            //     {
            //         _friendLinkSet[j].length = 0;
            //     }
            // }

            if (convertFlType(_currentTab) != -1) {
                // 同一ページを一度リセット
                var i:int;
                var offset:int = (currentPage()-1)*PAGE_MAX;
                for (i=0;i < PAGE_MAX; i++) {
                    _friendLinkSet[_currentTab][offset+i] = null;
                }
                log.writeLog(log.LV_WARN, this, "updatelist. get new friend link. 0",convertFlType(_currentTab),offset,PAGE_MAX);
                var flList:Array = FriendLink.getLinkList(convertFlType(_currentTab),offset,PAGE_MAX);
                log.writeLog(log.LV_WARN, this, "updatelist. get new friend link. 1",_currentTab,flList.length);
                for (i=0;i < flList.length; i++) {
                    if (flList[i]) {
                        if (convertTabType(flList[i].status) != -1)
                        {
                            log.writeLog(log.LV_WARN, this, "updatelist. get new friend link. 2",_currentTab,(offset+i));
                            _friendLinkSet[convertTabType(flList[i].status)][offset+i] = flList[i];
                        }
                    }
                }
            } else {
                if (_friendLinkSet[_currentTab].length > 0)
                {
                    _friendLinkSet[_currentTab].length = 0;
                }
                var f_set:Object = FriendLink.getLinkSet();
                for (var key:Object in f_set)
                {
                    var tabType:int = convertTabType(f_set[key].status);
                    if (tabType == TAB_SEARCH)
                    {
                        log.writeLog(log.LV_WARN, this, "updatelist. get new friend link. ",key, f_set[key]);
                        _friendLinkSet[convertTabType(f_set[key].status)].push(f_set[key]);
                    }
                }
            }


//             var f_set:Array = FriendLink.getLinkSet().slice(); //FriendLinkのSet
//             var len:int = f_set.length;
// //            log.writeLog(log.LV_WARN, this, "++set num", len,f_set);

//             // 各タブに収納していく
//             for(var i:int = 0; i < len; i++)
//             {
//                 log.writeLog(log.LV_WARN, this, "++set num3", f_set[i].id,f_set[i].status);
//                 if (convertTabType(f_set[i].status) != -1)
//                 {
//                     _friendLinkSet[convertTabType(f_set[i].status)].push(f_set[i]);
//                 }
//             }

        }

        // リンクステータスからタブタイプに変換
        private function convertTabType(fType:int):int
        {
            var ret:int;
            switch (fType)
            {
            case FriendLink.FR_ST_OTHER_CONFIRM:
                ret = TAB_WAITING;
                // ret = TAB_FRIEND;
                break;
            case FriendLink.FR_ST_MINE_CONFIRM:
                ret = TAB_WAITING;
                break;
            case FriendLink.FR_ST_FRIEND:
                ret = TAB_FRIEND;
                break;
            case FriendLink.FR_ST_BLOCK:
                ret = TAB_BLOCKING;
                break;
            case FriendLink.FR_ST_BLOCKED:
                ret = -1;
                break;
            case FriendLink.FR_ST_ONLY_SNS:
                ret = -1;
                break;
            case FriendLink.FR_ST_FRIEND_LOGIN:
                ret = TAB_FRIEND;
                break;
            case FriendLink.FR_ST_SEARCH:
                ret = TAB_SEARCH;
                break;
            default:
                ret = -1;
            }
            return ret;
        }

        private function convertFlType(tab:int):int
        {
            var ret:int = -1;
            switch (tab)
            {
            case TAB_FRIEND:
                ret = FriendLink.TYPE_FRIEND;
                break;
            case TAB_BLOCKING:
                ret = FriendLink.TYPE_BLOCK;
                break;
            case TAB_WAITING:
                ret = FriendLink.TYPE_CONFIRM;
                break;
            default:
                ret = -1
            }
            return ret;
        }

        private function getOtherAvatarImage(fLink:FriendLink):AvatarClipScene
        {
            log.writeLog(log.LV_FATAL, this, "++ge oa image",fLink);
            log.writeLog(log.LV_DEBUG, this, "getOtherAvatarImage",fLink.avatarId,(_friendAvatarDic[fLink.avatarId]==null));
            if (_friendAvatarDic[fLink.avatarId]==null)
            {
//                 _friendAvatarDic[oa] = new AvatarClip(oa);
//                 _friendAvatarDic[oa].type = Const.PL_AVATAR_MATCH_ROOM;
                _friendAvatarDic[fLink.avatarId] = new AvatarClipScene(fLink);
            }
            _friendAvatarDic[fLink.avatarId].setStatus(fLink)
            return _friendAvatarDic[fLink.avatarId];
        }

        // フレンド人数アップデート
        private function updateFriendMaxHandler(e:Event):void
        {
            updateFriendMax();
            pageNumUpdate();
        }

        // フレンド人数アップデート
        private function updateFriendMax():void
        {
            _friendMax = _avatar.friendMax;
        }

//          private function clickDeleteHandler(e:MouseEvent):void
//          {
//              log.writeLog(log.LV_INFO, this, "click delete!", e.target);
// //             dispatchEvent(new Event(USE_ITEM, true, true));
//              LobbyCtrl.instance.friendDelete.(e.target.friendLink.id);
//          }

//          private function clickConfirmHandler(e:MouseEvent):void
//          {
// //             log.writeLog(log.LV_INFO, this, "click buy!");
// //             dispatchEvent(new Event(BUY_ITEM, true, true));
//              LobbyCtrl.instance.friendConfirm.(e.target.friendLink.id);
//          }

//          private function clickOKHandler(e:MouseEvent):void
//          {
// //             log.writeLog(log.LV_INFO, this, "click buy!");
// //             dispatchEvent(new Event(BUY_ITEM, true, true));
//          }

    }
}

import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.filters.GlowFilter;
import flash.geom.*;

import mx.core.UIComponent;
import mx.controls.*;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;

import view.scene.BaseScene;
import view.scene.common.*;
import view.image.common.*;
import view.*;
import view.utils.*;

import model.*;
import model.events.*;
import model.utils.*;

import controller.*;


/**
 * アバター情報
 *
 */
class AvatarClipScene extends BaseScene
{
        CONFIG::LOCALE_JP
        private static const _TRANS_COM_DEL	:String = "削除";
        CONFIG::LOCALE_JP
        private static const _TRANS_COM_ASK	:String = "申請";
        CONFIG::LOCALE_JP
        private static const _TRANS_COM_ALLOW	:String = "認証";
        CONFIG::LOCALE_JP
        private static const _TRANS_COM_UNBLOCK	:String = "解除";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIA_ALLOW	:String = "認証中";
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_JP
        private static const _TRANS_COM_PRESENT	:String = "選択";
        CONFIG::LOCALE_JP
        private static const _TRANS_COM_MAIL	:String = "送信";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIA_MSG1	:String = "__AVATAR_NAME__を\nフレンドリストから削除しますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIA_MSG2	:String = "を\nフレンド申し込みしますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIA_MSG3	:String = "を\nフレンド許可しますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIA_MSG4	:String = "__AVATAR_NAME__へクエスト「__QUEST_NAME__」をプレゼントしますか？（APを__AP__消費します）";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIA_MSG5	:String = "__AVATAR_NAME__をブロックしますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIA_MSG6	:String = "__AVATAR_NAME__をブロック解除しますか？";

        CONFIG::LOCALE_EN
        private static const _TRANS_COM_DEL	:String = "Delete";
        CONFIG::LOCALE_EN
        private static const _TRANS_COM_ASK	:String = "Request";
        CONFIG::LOCALE_EN
        private static const _TRANS_COM_ALLOW	:String = "Authorize";
        CONFIG::LOCALE_EN
        private static const _TRANS_COM_UNBLOCK	:String = "Cancel";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIA_ALLOW	:String = "Authorizing";
        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM	:String = "Confirm";
        CONFIG::LOCALE_EN
        private static const _TRANS_COM_PRESENT	:String = "Selection";
        CONFIG::LOCALE_EN
        private static const _TRANS_COM_MAIL	:String = "Send";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIA_MSG1	:String = "Delete __AVATAR_NAME__ from your friend list?";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIA_MSG2	:String = "Send a friend request to \n";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIA_MSG3	:String = "Authorize __AVATAR_NAME__ ?";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIA_MSG4	:String = "Do you want to send [__QUEST_NAME__] to __AVATAR_NAME__ for __AP__ AP?";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIA_MSG5	:String = "Block __AVATAR_NAME__?";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIA_MSG6	:String = "Unblock __AVATAR_NAME__?";

        CONFIG::LOCALE_TCN
        private static const _TRANS_COM_DEL	:String = "刪除";
        CONFIG::LOCALE_TCN
        private static const _TRANS_COM_ASK	:String = "申請";
        CONFIG::LOCALE_TCN
        private static const _TRANS_COM_ALLOW	:String = "認證";
        CONFIG::LOCALE_TCN
        private static const _TRANS_COM_UNBLOCK	:String = "解除";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIA_ALLOW	:String = "認證中";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_TCN
        private static const _TRANS_COM_PRESENT	:String = "選擇";
        CONFIG::LOCALE_TCN
        private static const _TRANS_COM_MAIL	:String = "送信";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIA_MSG1	:String = "要把__AVATAR_NAME__\n從朋友名單中刪除嗎？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIA_MSG2_PRE	:String = "要向";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIA_MSG2	:String = "\n申請成為朋友嗎？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIA_MSG3_PRE	:String = "要同意";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIA_MSG3	:String = "\n成為您的朋友嗎？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIA_MSG4	:String = "將任務「__QUEST_NAME__」送給__AVATAR_NAME__嗎？（消耗AP__AP__點）";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIA_MSG5	:String = "確定要封鎖 __AVATAR_NAME__ 嗎？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIA_MSG6	:String = "要解除對__AVATAR_NAME__的封鎖嗎？";

        CONFIG::LOCALE_SCN
        private static const _TRANS_COM_DEL	:String = "删除";
        CONFIG::LOCALE_SCN
        private static const _TRANS_COM_ASK	:String = "申请";
        CONFIG::LOCALE_SCN
        private static const _TRANS_COM_ALLOW	:String = "认证";
        CONFIG::LOCALE_SCN
        private static const _TRANS_COM_UNBLOCK	:String = "解除";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIA_ALLOW	:String = "认证中";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM	:String = "确认";
        CONFIG::LOCALE_SCN
        private static const _TRANS_COM_PRESENT	:String = "选择";
        CONFIG::LOCALE_SCN
        private static const _TRANS_COM_MAIL	:String = "发送";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIA_MSG1	:String = "是否要将__AVATAR_NAME__从\n好友名单中删除？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIA_MSG2_PRE	:String = "是否要向";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIA_MSG2	:String = "发送\n好友申请？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIA_MSG3_PRE	:String = "是否同意让";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIA_MSG3	:String = "加入您的\n好友名单？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIA_MSG4	:String = "是否赠送任务「__QUEST_NAME__」__AVATAR_NAME__？（将消耗__AP__点AP）";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIA_MSG5	:String = "是否屏蔽 __AVATAR_NAME__ ？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIA_MSG6	:String = "是否解除对 __AVATAR_NAME__的屏蔽？";

        CONFIG::LOCALE_KR
        private static const _TRANS_COM_DEL	:String = "삭제";
        CONFIG::LOCALE_KR
        private static const _TRANS_COM_ASK	:String = "신청";
        CONFIG::LOCALE_KR
        private static const _TRANS_COM_ALLOW	:String = "인증";
        CONFIG::LOCALE_KR
        private static const _TRANS_COM_UNBLOCK	:String = "해제";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIA_ALLOW	:String = "인증중";
        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM	:String = "확인";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIA_MSG1	:String = "__AVATAR_NAME__을(를) 친구 리스트에서 삭제하겠습니까?";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIA_MSG2	:String = "을(를) 친구 신청을 하겠습니까?";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIA_MSG3	:String = "을(를) 친구 신청을 허가하겠습니까?";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIA_MSG4	:String = "將任務「__QUEST_NAME__」送給__AVATAR_NAME__嗎？（消耗AP__AP__點）";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIA_MSG5	:String = "__AVATAR_NAME__をブロックしますか？";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIA_MSG6	:String = "__AVATAR_NAME__をブロック解除しますか？";

        CONFIG::LOCALE_FR
        private static const _TRANS_COM_DEL	:String = "Supprimer";
        CONFIG::LOCALE_FR
        private static const _TRANS_COM_ASK	:String = "Requête";
        CONFIG::LOCALE_FR
        private static const _TRANS_COM_ALLOW	:String = "Autorisation";
        CONFIG::LOCALE_FR
        private static const _TRANS_COM_UNBLOCK	:String = "Annulation";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIA_ALLOW	:String = "Vérification...";
        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM	:String = "Confirmer";
        CONFIG::LOCALE_FR
        private static const _TRANS_COM_PRESENT	:String = "Sélection";
        CONFIG::LOCALE_FR
        private static const _TRANS_COM_MAIL	:String = "Transmission";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIA_MSG1	:String = "Supprimer __AVATAR_NAME__ de la liste d'amis ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIA_MSG2	:String = "Demander à devenir ami avec \n";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIA_MSG3	:String = "Autoriser __AVATAR_NAME__ ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIA_MSG4	:String = "Voulez vous offrir la Quête [__QUEST_NAME__] a __AVATAR_NAME__? （Vos AP diminueront de __AP__）";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIA_MSG5	:String = "Voulez-vous bloquer __AVATAR_NAME__ ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIA_MSG6	:String = "Voulez-vous débloquer __AVATAR_NAME__ ?";

        CONFIG::LOCALE_ID
        private static const _TRANS_COM_DEL	:String = "削除";
        CONFIG::LOCALE_ID
        private static const _TRANS_COM_ASK	:String = "申請";
        CONFIG::LOCALE_ID
        private static const _TRANS_COM_ALLOW	:String = "認証";
        CONFIG::LOCALE_ID
        private static const _TRANS_COM_UNBLOCK	:String = "解除";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIA_ALLOW	:String = "認証中";
        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_ID
        private static const _TRANS_COM_PRESENT	:String = "選択";
        CONFIG::LOCALE_ID
        private static const _TRANS_COM_MAIL	:String = "送信";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIA_MSG1	:String = "__AVATAR_NAME__を\nフレンドリストから削除しますか？";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIA_MSG2	:String = "を\nフレンド申し込みしますか？";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIA_MSG3	:String = "を\nフレンド許可しますか？";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIA_MSG4	:String = "__AVATAR_NAME__へクエスト「__QUEST_NAME__」をプレゼントしますか？（APを__AP__消費します）";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIA_MSG5	:String = "__AVATAR_NAME__をブロックしますか？";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIA_MSG6	:String = "__AVATAR_NAME__をブロック解除しますか？";

        CONFIG::LOCALE_TH
        private static const _TRANS_COM_DEL :String = "ลบ";//"削除";
        CONFIG::LOCALE_TH
        private static const _TRANS_COM_ASK :String = "ขอเป็นเพื่อน";
        CONFIG::LOCALE_TH
        private static const _TRANS_COM_ALLOW   :String = "ยืนยัน";
        CONFIG::LOCALE_TH
        private static const _TRANS_COM_UNBLOCK :String = "ยกเลิก";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIA_ALLOW   :String = "กำลังยืนยัน";
        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM :String = "ตกลง";
        CONFIG::LOCALE_TH
        private static const _TRANS_COM_PRESENT :String = "ตัวเลือก";
        CONFIG::LOCALE_TH
        private static const _TRANS_COM_MAIL    :String = "ส่งข้อความ";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIA_MSG1    :String = "จะลบ __AVATAR_NAME__ \nออกจากรายชื่อเพื่อนหรือไม่?";//"__AVATAR_NAME__を\nフレンドリストから削除しますか？";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIA_MSG2_PRE    :String = "จะขอ ";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIA_MSG2    :String = "\nเป็นเพื่อนหรือไม่?";//"を\nフレンド申し込みしますか？";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIA_MSG3_PRE	:String = "จะรับ ";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIA_MSG3    :String = "\nเป็นเพื่อนหรือไม่?";//"を\nフレンド許可しますか？";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIA_MSG4    :String = "จะให้เควส「__QUEST_NAME__」แก่__AVATAR_NAME__หรือไม่? (Apจะลดลง__AP__แต้ม)";//"__AVATAR_NAME__へクエスト「__QUEST_NAME__」をプレゼントしますか？（APを__AP__消費します）";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIA_MSG5    :String = "จะบล็อก __AVATAR_NAME__ หรือไม่?";//"__AVATAR_NAME__をブロックしますか？";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIA_MSG6    :String = "จะบล็อค__AVATAR_NAME__หรือไม่";//"__AVATAR_NAME__をブロック解除しますか？";

    private var _button:FriendButton = new FriendButton();
    private var _onlineState:FriendStateImage = new FriendStateImage();

    private static var __closeButton:FriendCloseButton;
    private static var __deleteFunc:Function;

    private var _ct:ColorTransform = new ColorTransform(0.3,0.3,0.3);// トーンを半分に
    private var _ct2:ColorTransform = new ColorTransform(1.0,1.0,1.0);// トーン元にに


    private var _container:UIComponent;
    private var _stateFunc:Function;
    private var _name:Label = new Label();

    private var _snsName:Label = new Label();

    private var _level:Label = new Label();
    private var _waiting:Label = new Label();
    private var _link:FriendLink;
    private var _clip:AvatarClip;
    private var _bg:Shape = new Shape();

//    public static const DELETE_BUTTON:String = "削除";
    public static const DELETE_BUTTON:String = _TRANS_COM_DEL;
//    public static const CONFIRM_BUTTON:String = "申請";
    public static const CONFIRM_BUTTON:String = _TRANS_COM_ASK;
//    public static const OK_BUTTON:String     = "認証";
    public static const OK_BUTTON:String     = _TRANS_COM_ALLOW;
//    public static const REMOVE_BUTTON:String = "解除";
    public static const REMOVE_BUTTON:String = _TRANS_COM_UNBLOCK;
    public static const SEND_BUTTON:String     = _TRANS_COM_PRESENT;
    public static const MAIL_BUTTON:String     = _TRANS_COM_MAIL;


    private static const _NAME_X:int = 0
    private static const _NAME_Y:int = 100;           // カードの初期位置Y
    private static const _NAME_H:int = 28;           // カードの初期位置Y
    private static const _NAME_W:int = 87;           // カードの初期位置Y

    private static const _LEVEL_X:int = 2;
    private static const _LEVEL_Y:int = 15;           // カードの初期位置Y
    private static const _LEVEL_H:int = 16;           // カードの初期位置Y
    private static const _LEVEL_W:int = 88;           // カードの初期位置Y

    private static const _WAITING_X:int = 2;
    private static const _WAITING_Y:int = 48;           // カードの初期位置Y
    private static const _WAITING_H:int = 24;           // カードの初期位置Y
    private static const _WAITING_W:int = 88;           // カードの初期位置Y

    private static const _BUTTON_X:int = 8;
    private static const _BUTTON_Y:int = 122;           // カードの初期位置Y


    // 共通で使う削除ボタンの初期化
    private static function initCloseButton():void
    {
        __closeButton = new FriendCloseButton();
        __closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler);
    }
    // 削除ボタンのクリックハンドラ
    private static function closeClickHandler(e:MouseEvent):void
    {
        if (__deleteFunc != null)
        {
            __deleteFunc();
        }
    }

    public function AvatarClipScene(link:FriendLink)
    {
        _clip = new AvatarClip(link.otherAvatar);
        _clip.type = Const.PL_AVATAR_MATCH_ROOM;
        _link = link;
        var sExec:SerialExecutor = new SerialExecutor();
        sExec.addThread(_clip.getShowThread(this,0));
        sExec.addThread(new ClousureThread(labelUpdata));
        _bg.graphics.beginFill(0xEEEEEE);
        _bg.graphics.drawRect(0, 0, 87, 15);
        _bg.graphics.endFill();
        _bg.y = 102;
        _bg.alpha = 0.5;
        _button.x = _BUTTON_X;
        _button.y = _BUTTON_Y;
        _onlineState.y = 0;
        sExec.start();
//        mouseEnabled  =false;

        if (__closeButton == null)
        {
            initCloseButton();
        }
    }

    private function labelUpdata():void
    {
        addChild(_bg);

        _name.x = _NAME_X;
        _name.y = _NAME_Y;
        _name.width = _NAME_W;
        _name.height = _NAME_H;
        _name.text = _link.otherAvatar.name;
        _name.styleName = "FriendName";
//        callLater(fontSizeAdjust,[_name])
        addChild(_name);

        _level.x = _LEVEL_X;
        _level.y = _LEVEL_Y;
        _level.width = _LEVEL_W;
        _level.height = _LEVEL_H;
        _level.text = "Level: "+_link.otherAvatar.level.toString();
        _level.styleName = "FriendLevel";
        _level.filters = [new GlowFilter(0x0000000, 1, 2, 2, 16, 1),];
        addChild(_level);

        _waiting.x = _WAITING_X;
        _waiting.y = _WAITING_Y;
        _waiting.width = _WAITING_W;
        _waiting.height = _WAITING_H;
//        _waiting.text = "認証中"
        _waiting.text = _TRANS_DIA_ALLOW
        _waiting.styleName = "FriendWaiting";
        _waiting.filters = [new GlowFilter(0x0000000, 1, 2, 2, 16, 1),];

        _snsName.x = _NAME_X;
        _snsName.y = _NAME_Y - 70;
        _snsName.width = _NAME_W;
        _snsName.height = _NAME_H;
        _snsName.text = "[ "+_link.nickName + " ]";

        _snsName.styleName = "NickName";
        _snsName.selectable = false;
        _snsName.mouseEnabled = false;
        _snsName.mouseChildren = false;

//        callLater(fontSizeAdjust,[_name])
//        addChild(_name);

        addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        addEventListener(MouseEvent.ROLL_OUT, mouseRemoveHandler);
    }

    public function setStatus(fl:FriendLink):void
    {
        _link = fl;
        log.writeLog(log.LV_FATAL, this, "setstatus ", _link.status);
        switch (_link.status)
        {
        case FriendLink.FR_ST_OTHER_CONFIRM:
//                addChild(_button)
            RemoveChild.apply(_snsName);
            RemoveChild.apply(_button);
            RemoveChild.apply(_onlineState);
            addChild(_waiting);
            _clip.transform.colorTransform = _ct;
            break;
        case FriendLink.FR_ST_MINE_CONFIRM:
            _button.setText(OK_BUTTON);
            _button.setClickHandler(clickOK);
            RemoveChild.apply(_waiting);
            RemoveChild.apply(_snsName);
            RemoveChild.apply(_onlineState);
            _clip.transform.colorTransform = _ct2;
            addChild(_button);
            break;
        case FriendLink.FR_ST_FRIEND:
             if (FriendListContainer.presentMode)
             {
                 _button.setText(SEND_BUTTON);
                 addChild(_button);
                 _button.setClickHandler(clickSend);
             }else{
                 CONFIG::FRIEND_MAIL_ON
                 {
                     _button.setText(MAIL_BUTTON);
                     addChild(_button);
                     _button.setClickHandler(clickMail);
                 }
                 CONFIG::FRIEND_MAIL_OFF
                 {
                     RemoveChild.apply(_button);
                 }
             }
            RemoveChild.apply(_waiting);
            RemoveChild.apply(_snsName);
            RemoveChild.apply(_onlineState);
            _clip.transform.colorTransform = _ct2;
            break;
        case FriendLink.FR_ST_BLOCK:
            RemoveChild.apply(_waiting);
            RemoveChild.apply(_button);
            RemoveChild.apply(_snsName);
            RemoveChild.apply(_onlineState);
            _clip.transform.colorTransform = _ct2;
            break;
        case FriendLink.FR_ST_BLOCKED:
            RemoveChild.apply(_button);
            RemoveChild.apply(_snsName);
            RemoveChild.apply(_onlineState);
            break;
        case FriendLink.FR_ST_ONLY_SNS:
            RemoveChild.apply(__closeButton);
            RemoveChild.apply(_waiting);
            RemoveChild.apply(_onlineState);
            _clip.transform.colorTransform = _ct2;
            addChild(_button);
            addChild(_snsName);
            _button.setClickHandler(clickApply);
            _button.setText(CONFIRM_BUTTON);
            break;
        case FriendLink.FR_ST_FRIEND_LOGIN:
             if (FriendListContainer.presentMode)
             {
                 _button.setText(SEND_BUTTON);
                 addChild(_button);
                 _button.setClickHandler(clickSend);

             }else{
                 CONFIG::FRIEND_MAIL_ON
                 {
                     _button.setText(MAIL_BUTTON);
                     addChild(_button);
                     addChild(_onlineState);
                     _button.setClickHandler(clickMail);
                 }
                 CONFIG::FRIEND_MAIL_OFF
                 {
                     RemoveChild.apply(_button);
                     addChild(_onlineState);
                     RemoveChild.apply(_button);
                 }
             }

            RemoveChild.apply(_waiting);
            RemoveChild.apply(_snsName);
            _clip.transform.colorTransform = _ct2;
            break;
        case FriendLink.FR_ST_SEARCH:
            RemoveChild.apply(_waiting);
            RemoveChild.apply(_onlineState);
            _clip.transform.colorTransform = _ct2;
            addChild(_button);
            _button.setClickHandler(clickApply);
            _button.setText(CONFIRM_BUTTON);
            break;

        default:
        }

//         if(_link.avatar.id ==0)
//         {
//             RemoveChild.apply(_button);
//             RemoveChild.apply(__closeButton);

//         }
    }

    private function mouseOverHandler(e:MouseEvent):void
    {
        log.writeLog(log.LV_INFO, this, "mouse over  !!!!!!",_link.status);
        if(!FriendListContainer.presentMode)
        {
            __deleteFunc = clickDelete;
            __closeButton.x = 75;
            addChild(__closeButton);
        }

    }

    public function get friendLink():FriendLink
    {

        return _link;
    }




    private function mouseRemoveHandler(e:MouseEvent):void
    {
        if(_link.status != FriendLink.FR_ST_ONLY_SNS)
        {
            __deleteFunc = null;
            RemoveChild.apply(__closeButton);
        }

    }
    // 名前が全部はいるように調整
    private function fontSizeAdjust(label:Label):void
    {
        var w:int = label.width;
        label.validateNow();
        while (label.textWidth > w-3)
        {
            label.validateNow();
            label.setStyle("fontSize",  int(label.getStyle("fontSize"))-1);
            label.setStyle("paddingTop",  int(label.getStyle("paddingTop"))+1);
        }

        if (int(label.getStyle("fontSize")) < 6)
        {
            label.setStyle("fontSize",  6);
            label.setStyle("paddingTop",  6);
        }
    }

    private function clickDeleteHandler(e:MouseEvent):void
    {
        LobbyCtrl.instance.friendDelete(_link.id);
    }

    private function clickDelete():void
    {
        SE.playClick();
//        ConfirmPanel.show("確認",_link.otherAvatar.name+"を\nフレンドリストから削除しますか？", LobbyCtrl.instance.friendDelete,this,[_link.id], true);

        if (_link.status == FriendLink.FR_ST_BLOCK)
        {
            ConfirmPanel.show(_TRANS_CONFIRM,
                              _TRANS_DIA_MSG6.replace("__AVATAR_NAME__", _link.otherAvatar.name),
                              LobbyCtrl.instance.friendDelete,
                              this,
                              [_link.id],
                              true,
                              true);
        }else if (_link.status == FriendLink.FR_ST_ONLY_SNS||_link.status == FriendLink.FR_ST_SEARCH)
        {
            ConfirmPanel.show(_TRANS_CONFIRM,
                              _TRANS_DIA_MSG5.replace("__AVATAR_NAME__",_link.otherAvatar.name),
                              LobbyCtrl.instance.blockApply,
                              this,
                              [_link.id],
                              true,
                              true);
        }else{
            ConfirmPanel.show(_TRANS_CONFIRM,
                              _TRANS_DIA_MSG1.replace("__AVATAR_NAME__", _link.otherAvatar.name),
                              LobbyCtrl.instance.friendDelete,
                              this,
                              [_link.id],
                              true,
                              true);
        }
        log.writeLog(log.LV_INFO, this, "click delete!");
    }


    CONFIG::LOCALE_JP
    private function clickApply():void
    {
        log.writeLog(log.LV_INFO, this, "click buy!");
        ConfirmPanel.show(_TRANS_CONFIRM,_link.otherAvatar.name+_TRANS_DIA_MSG2, LobbyCtrl.instance.friendApply,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_EN
    private function clickApply():void
    {
        log.writeLog(log.LV_INFO, this, "click buy!");
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG2+_link.otherAvatar.name+" ?", LobbyCtrl.instance.friendApply,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_TCN
    private function clickApply():void
    {
        log.writeLog(log.LV_INFO, this, "click buy!");
//        ConfirmPanel.show("確認",_link.otherAvatar.name+"を\nフレンド申し込みしますか？", LobbyCtrl.instance.friendApply,this,[_link.id], true,true);
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG2_PRE+_link.otherAvatar.name+_TRANS_DIA_MSG2, LobbyCtrl.instance.friendApply,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_SCN
    private function clickApply():void
    {
        log.writeLog(log.LV_INFO, this, "click buy!");
//        ConfirmPanel.show("確認",_link.otherAvatar.name+"を\nフレンド申し込みしますか？", LobbyCtrl.instance.friendApply,this,[_link.id], true,true);
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG2_PRE+_link.otherAvatar.name+_TRANS_DIA_MSG2, LobbyCtrl.instance.friendApply,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_KR
    private function clickApply():void
    {
        log.writeLog(log.LV_INFO, this, "click buy!");
//        ConfirmPanel.show("確認",_link.otherAvatar.name+"を\nフレンド申し込みしますか？", LobbyCtrl.instance.friendApply,this,[_link.id], true,true);
        ConfirmPanel.show(_TRANS_CONFIRM,_link.otherAvatar.name+_TRANS_DIA_MSG2, LobbyCtrl.instance.friendApply,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_FR
    private function clickApply():void
    {
        log.writeLog(log.LV_INFO, this, "click buy!");
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG2+_link.otherAvatar.name+" ?", LobbyCtrl.instance.friendApply,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_ID
    private function clickApply():void
    {
        log.writeLog(log.LV_INFO, this, "click buy!");
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG2.replace("__AVATAR_NAME__", _link.otherAvatar.name), LobbyCtrl.instance.friendApply,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_TH
    private function clickApply():void
    {
        log.writeLog(log.LV_INFO, this, "click buy!");
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG2.replace("__AVATAR_NAME__", _link.otherAvatar.name), LobbyCtrl.instance.friendApply,this,[_link.id], true,true);
    }


    CONFIG::LOCALE_JP
    private function clickOK():void
    {
//             log.writeLog(log.LV_INFO, this, "click buy!");
//        ConfirmPanel.show("確認",_link.otherAvatar.name+"を\nフレンド許可しますか？", LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
        ConfirmPanel.show(_TRANS_CONFIRM,_link.otherAvatar.name+_TRANS_DIA_MSG3, LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_EN
    private function clickOK():void
    {
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG3.replace("__NAME__", _link.otherAvatar.name), LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_TCN
    private function clickOK():void
    {
//             log.writeLog(log.LV_INFO, this, "click buy!");
//        ConfirmPanel.show("確認",_link.otherAvatar.name+"を\nフレンド許可しますか？", LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG3_PRE+_link.otherAvatar.name+_TRANS_DIA_MSG3, LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_SCN
    private function clickOK():void
    {
//             log.writeLog(log.LV_INFO, this, "click buy!");
//        ConfirmPanel.show("確認",_link.otherAvatar.name+"を\nフレンド許可しますか？", LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG3_PRE+_link.otherAvatar.name+_TRANS_DIA_MSG3, LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_KR
    private function clickOK():void
    {
//             log.writeLog(log.LV_INFO, this, "click buy!");
//        ConfirmPanel.show("確認",_link.otherAvatar.name+"を\nフレンド許可しますか？", LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
        ConfirmPanel.show(_TRANS_CONFIRM,_link.otherAvatar.name+_TRANS_DIA_MSG3, LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_FR
    private function clickOK():void
    {
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG3.replace("__NAME__", _link.otherAvatar.name), LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_ID
    private function clickOK():void
    {
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG3.replace("__NAME__", _link.otherAvatar.name), LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
    }

    CONFIG::LOCALE_TH
    private function clickOK():void
    {
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG3.replace("__NAME__", _link.otherAvatar.name), LobbyCtrl.instance.friendConfirm,this,[_link.id], true,true);
    }

    private function clickBLock():void
    {
        log.writeLog(log.LV_INFO, this, "click BLock");
        ConfirmPanel.show(_TRANS_CONFIRM,_TRANS_DIA_MSG5.replace("__AVATAR_NAME__", _link.otherAvatar.name), LobbyCtrl.instance.blockApply,this,[_link.id], true,true);
    }

    private function clickSend():void
    {
//      private static const _TRANS_DIA_MSG4	:String = "__OTHERAVATAR_NAME__へクエスト「__QUEST_NAME__」をプレゼントしますか？（APが__AP__必要です）";

        var msg:String = _TRANS_DIA_MSG4.replace("__AVATAR_NAME__",_link.otherAvatar.name).replace("__QUEST_NAME__",QuestCtrl.instance.currentMap.name).replace("__AP__",QuestCtrl.instance.currentMap.ap.toString());
        log.writeLog(log.LV_INFO, this, "link id",_link.uid);
        ConfirmPanel.show(_TRANS_CONFIRM,msg, QuestCtrl.instance.sendQuest, this, [_link.avatarId], true,true);
    }

    private function clickMail():void
    {
        log.writeLog(log.LV_INFO, this, "link id",_link.uid);
        var uid:String = String(_link.uid.match(/\d+/));
        log.writeLog(log.LV_INFO, this, "sns user id", uid);

        log.writeLog(log.LV_INFO, this, "FriendList Send Message.");
    }



}
