package view.scene.match
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.utils.*;
    import view.image.common.AvatarImage;
    import view.scene.BaseScene;
    import view.scene.edit.CharaCardDeckClip;
    import view.scene.common.CharaCardClip;
    import view.scene.common.AvatarView;

    import model.*;
    import model.events.*;

    /**
     * マッチング画面のアバター表示部分のクラス
     *
     */
    public class AvatarArea extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1	:String = "あなたのアバターのデータです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "あなたのアバターのコメントです。\nクリック後に入力ができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_COMMENT	:String = "コメントを入力できます";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1	:String = "Your avatar's data.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = "Your avatar's comments.\nClick to edit.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_COMMENT	:String = "Enter comments here.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1	:String = "你的虛擬人物資訊";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "你的虛擬人物簡介。\n可以在點擊後輸入。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_COMMENT	:String = "可以輸入簡介";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1	:String = "您的虚拟人物数据。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "您的虚拟人物的简介。\n点击后可进行输入。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_COMMENT	:String = "可输入简介。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1	:String = "당신의 아바타의 데이터입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "당신의 아바타의 코멘트입니다.\n클릭후에 입력이 가능합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_COMMENT	:String = "코멘트를 입력할 수 있습니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1	:String = "Informations de l'Avatar.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = "Commentaires à propos de l'Avatar.\nCliquez ici pour éditer vos commentaires.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_COMMENT	:String = "Ajoutez vos commentaires ici.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1	:String = "あなたのアバターのデータです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "あなたのアバターのコメントです。\nクリック後に入力ができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_COMMENT	:String = "コメントを入力できます";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1    :String = "ข้อมูลอวาตาร์ของท่าน";//"あなたのアバターのデータです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "ข้อคิดเห็น ท่านสามารถคลิกและพิมพ์ข้อความลงไปได้";//"あなたのアバターのコメントです。\nクリック後に入力ができます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_COMMENT :String = "แสดงความคิดเห็น";//"コメントを入力できます";


        // アバターインスタンス
        private var _avatar:Avatar = Player.instance.avatar;
        // マッチインスタンス
        private var _match:Match = Match.instance;
        // エディットインスタンス
        private var _deckEditor:DeckEditor = DeckEditor.instance;

        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

//         // 表示
//         private var _avatarClip:AvatarClip = new AvatarClip();      // アバター表示

// //      private var _level:Label = new Label();                   // レベルラベル
//         private var _name:Label = new Label();                    // 名前ラベル
//         private var _energy:Label = new Label();                  // 行動力ラベル
//         private var _exp:Label = new Label();                     // 経験値ラベル
//         private var _gems:Label = new Label();                    // ジェムラベル

//         private var _nameTitle:Label = new Label();                    // 名前ラベルタイトル
//         private var _energyTitle:Label = new Label();                  // 行動力ラベルタイトル
//         private var _expTitle:Label = new Label();                     // 経験値ラベルタイトル
//         private var _gemsTitle:Label = new Label();                    // ジェムラベルタイトル


        private var _point:Label = new Label();                      // BP表示
        private var _result:Label = new Label();                     // 勝敗表示
        private var _level:Label = new Label();                      // レベル
        private var _cost:Label = new Label();                       // コスト

        private var _avatarView:AvatarView;

        private var _comment:TextArea = new TextArea();           // コメントエリア

        private var _deckClip:CharaCardDeckClip;                  // カレントデッキ

        private var _deckName:Label = new Label();                 // デッキの名前ラベル

//         // 定数
//         private const _AVATAR_X:int = 840;                       // アバターのX位置
//         private const _AVATAR_Y:int = 380;                       // アバターのY位置
//         private const _AVATAR_SCALE:Number = 1;                 // アバターのサイズ


//         private const _LABEL_X:int = 690;                       // ラベルのX位置
//         private const _LABEL_Y:int = 654;                       // ラベルのY位置
//         private const _LABEL_Y_DIF:int = 20;                       // ラベルの配置の差分

         private const _LABEL_WIDTH:int = 200;                     // ラベルの幅
         private const _LABEL_HEIGHT:int = 32;                     // ラベルの高さ

        private const _POINT_X:int = 380;                       // コメントエリアのX位置
        private const _POINT_Y:int = 450;                       // コメントエリアのY位置
        private const _RESULT_X:int = 380;                       // コメントエリアのX位置
        private const _RESULT_Y:int = 487;                       // コメントエリアのY位置

        private const _COMMENT_X:int = 555;                       // コメントエリアのX位置
        private const _COMMENT_Y:int = 680;                       // コメントエリアのY位置
        private const _COMMENT_WIDTH:int = 123;                    // コメントエリアの幅
        private const _COMMENT_HEIGHT:int = 77;                   // コメントエリアの高さ
        private const _COMMENT_MAX_CHARS:int = 64;                 // 最大文字数

        private const _DECK_X:int = 432;                       // デッキエリアのX位置
        private const _DECK_Y:int = 543;                       // デッキエリアのY位置
        private const _DECK_SIZE:Number = 0.5;                   // デッキサイズ
        private const _DECK_NAME_X:int = 10;                       // デッキネームのX位置
        private const _DECK_NAME_Y:int = 635;                       // デッキネームのY位置

        private const _CHANGE_X:int = 964;                       //
        private const _CHANGE_Y:int = 693;                       //
        private const _CHANGE_OFFSET_X:int = 20;                   //
        private const _CHANGE_OFFSET_Y:int = 30;                   //

        private const _LEVEL_X:int = 388;                         // デッキレベルX
        private const _LEVEL_Y:int = 526;                        // デッキレベルY
        private const _LEVEL_WIDTH:int = 80;                   // デッキレベルの幅
        private const _LEVEL_HEIGHT:int = 24;                   // デッキレベルの高さ

        private const _COST_X:int = 486;                         // デッキコストX
        private const _COST_Y:int = 522;                        // デッキコストY
        private const _COST_WIDTH:int = 80;                   // デッキコストの幅
        private const _COST_HEIGHT:int = 24;                   // デッキコストの高さ

        // 変数
        private var _selectIndex:int;                      // 選択中のデッキインデックス


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["あなたのアバターのデータです。",
//                 "あなたのアバターのコメントです。\nクリック後に入力ができます。",],
                [_TRANS_MSG1,
                 _TRANS_MSG2,],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _MATCH_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function AvatarArea()
        {

            initAvatarData();
            initDeckData();
//             mouseEnabled = false;
//             mouseChildren = false;
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  //
            _toolTipOwnerArray.push([1,_comment]);  //
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
            _avatarView.addEventListener(Avatar.ENERGY_UPDATE, _avatarView.avatarUpdateHandler);
            _avatarView.addEventListener(Avatar.GEMS_UPDATE, _avatarView.avatarUpdateHandler);
            _avatarView.addEventListener(Avatar.EXP_UPDATE, _avatarView.avatarUpdateHandler);
            _avatarView.addEventListener(Avatar.LEVEL_UPDATE, _avatarView.avatarUpdateHandler);
            _avatarView.addEventListener(Avatar.ENERGY_MAX_UPDATE, _avatarView.avatarUpdateHandler);
            _avatar.addEventListener(Avatar.RESULT_UPDATE, updateAvatarDataHandler);

            initilizeToolTipOwners();
            updateHelp(_MATCH_HELP);

            addChild(_container);
        }

        // 終了
        public override function final():void
        {
            _avatarView.removeEventListener(Avatar.ENERGY_UPDATE, _avatarView.avatarUpdateHandler)
            _avatarView.removeEventListener(Avatar.GEMS_UPDATE, _avatarView.avatarUpdateHandler)
            _avatarView.removeEventListener(Avatar.EXP_UPDATE, _avatarView.avatarUpdateHandler)
            _avatarView.removeEventListener(Avatar.LEVEL_UPDATE, _avatarView.avatarUpdateHandler)
            _avatarView.removeEventListener(Avatar.ENERGY_MAX_UPDATE, _avatarView.avatarUpdateHandler)
            _avatar.removeEventListener(Avatar.RESULT_UPDATE, updateAvatarDataHandler);

            _comment.removeEventListener(KeyboardEvent.KEY_DOWN, enterKeyDownHandler);
            deleteDeckData();
            RemoveChild.all(_container)
            RemoveChild.apply(_container);
        }

        // アバター部分の表示の初期化
        private function initAvatarData():void
        {
            _selectIndex = _deckEditor.currentIndex;
            _deckEditor.selectIndex = _selectIndex;

//             _avatarClip.x = _AVATAR_X;
//             _avatarClip.y = _AVATAR_Y;
//             _avatarClip.scaleX = _avatarClip.scaleY = _AVATAR_SCALE;

//             _name.width = _energy.width = _exp.width = _gems.width = _LABEL_WIDTH;
//             _name.height = _energy.height = _exp.height = _gems.height = _LABEL_HEIGHT;
//             _nameTitle.width = _energyTitle.width = _expTitle.width = _gemsTitle.width = _LABEL_WIDTH;
//             _nameTitle.height = _energyTitle.height = _expTitle.height = _gemsTitle.height = _LABEL_HEIGHT;

            _point.x = _POINT_X;
            _point.y = _POINT_Y;
            _point.width = _LABEL_WIDTH;
            _point.height = _LABEL_HEIGHT;

            _result.x = _RESULT_X;
            _result.y = _RESULT_Y;
            _result.width = _LABEL_WIDTH;
            _result.height = _LABEL_HEIGHT;

            // 値の設定
            _point.text = "BattlePoint  " + _avatar.point;
            _result.text = _avatar.win + " win  " + _avatar.lose + " lose  " + _avatar.draw + " draw";

//             _name.text = "Lv." +_avatar.level + " " + _avatar.name;
//             _energy.text =  _avatar.energy.toString() + "/" +_avatar.energyMax.toString()  ;
//             _exp.text =  _avatar.exp.toString() + "/" + _avatar.nextExp.toString();
//             _gems.text =  _avatar.gems.toString();

//             _nameTitle.text = "Name";
//             _energyTitle.text ="AP";
//             _expTitle.text =  "Exp";
//             _gemsTitle.text =  "Gem";

//            _comment.text = "コメントを入力できます";
            _comment.text = _TRANS_MSG_COMMENT;

//             _name.styleName = _energy.styleName = _exp.styleName =_gems.styleName = "GameLobbyAvatarLabel";
//             _nameTitle.styleName = _energyTitle.styleName = _expTitle.styleName =_gemsTitle.styleName = "GameLobbyAvatarTitleLabel";

            _point.styleName = _result.styleName = "GameLobbyBattlePointLabel";
            _comment.styleName = "GameLobbyCommentLabel";

            _point.filters = _result.filters = [ new GlowFilter(0x111111, 1, 4, 4, 16, 1), ];

//             _name.x = _nameTitle.x = _LABEL_X;
//             _energy.x = _energyTitle.x = _LABEL_X;
//             _exp.x = _expTitle.x = _LABEL_X;
//             _gems.x = _gemsTitle.x = _LABEL_X;

//             _name.y = _nameTitle.y = _LABEL_Y;
//             _energy.y = _energyTitle.y = _LABEL_Y+_LABEL_Y_DIF;
//             _exp.y = _expTitle.y = _LABEL_Y+_LABEL_Y_DIF*2;
//             _gems.y = _gemsTitle.y = _LABEL_Y+_LABEL_Y_DIF*3;

//            log.writeLog(log.LV_INFO, this, "energy",_energy.x ,_energy.y ,_energy.text);
            _comment.x = _COMMENT_X;
            _comment.y = _COMMENT_Y;
            _comment.maxChars = _COMMENT_MAX_CHARS;
            _comment.addEventListener(KeyboardEvent.KEY_DOWN, enterKeyDownHandler);

            loadDeckData();

//             _avatarClip.type = Const.PL_AVATAR_MATCH;
//             _avatarClip.getShowThread(_container, -1).start();

            _avatarView = AvatarView.getPlayerAvatar(Const.PL_AVATAR_MATCH);
//           _avatarView = AvatarView.getPlayerAvatar(AvatarView.TYPE_MATCH);

            _avatarView.getShowThread(_container).start();

            _container.addChild(_point);
            _container.addChild(_result);
//            _container.addChild(_level);
            _container.addChild(_cost);

//             _container.addChild(_name);
//             _container.addChild(_energy);
//             _container.addChild(_exp);
//             _container.addChild(_gems);
//             _container.addChild(_nameTitle);
//             _container.addChild(_energyTitle);
//             _container.addChild(_expTitle);
//             _container.addChild(_gemsTitle);
//             _container.addChild(_comment);
        }

        // アバター部分の表示の初期化
        private function updateAvatarDataHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "update avatar text!!!");
            // 値の設定
            _point.text = "BattlePoint  " + _avatar.point;
            _result.text = _avatar.win + " win  " + _avatar.lose + " lose  " + _avatar.draw + " draw";
        }

        // デッキを初期化
        private function initDeckData():void
        {
            _deckClip = new CharaCardDeckClip(CharaCardDeck.decks[_selectIndex]);
            _deckClip.x = _DECK_X;
            _deckClip.y = _DECK_Y;
            _deckClip.scaleX = _deckClip.scaleY = _DECK_SIZE;
            _deckClip.getShowThread(_container,0).start();

            if(_deckEditor.currentIndex == CharaCardDeck.decks.indexOf(_deckClip.charaCardDeck))
            {
                _deckName.styleName = "CurrentDeckNameLabel";
            }
            else
            {
                _deckName.styleName = "DeckNameLabel";
            }
            _deckName.x = _DECK_NAME_X;
            _deckName.y = _DECK_NAME_Y;
            _deckName.width = 220;
            _deckName.height = _LABEL_HEIGHT;
            _deckName.text = "No." + CharaCardDeck.decks.indexOf(_deckClip.charaCardDeck) + "    " + _deckClip.charaCardDeck.name;
            _deckName.filters = [new GlowFilter(0xffffff, 1, 2, 2, 16, 1),]
            _container.addChild(_deckName);
        }

        // デッキを消去
        private function deleteDeckData():void
        {
            if (_deckClip != null)
            {
                _deckClip.getHideThread().start();
            }
        }

        // デッキデータを更新
        private function loadDeckData():void
        {
            var currentIndex:int = _deckEditor.currentIndex;
            var deckLevel:int = CharaCardDeck.decks[currentIndex].level;
            var costCalc:int = CharaCardDeck.decks[currentIndex].cost["total"] + EventCardDeck.decks[currentIndex].cost + WeaponCardDeck.decks[currentIndex].cost;
            var costMax:int = CharaCardDeck.decks[currentIndex].maxCost;

//             // レベル関連
//             _level.x = _LEVEL_X;
//             _level.y = _LEVEL_Y;
//             _level.width = _LEVEL_WIDTH;
//             _level.height = _LEVEL_HEIGHT;
//             _level.styleName = "DeckDataLabel";
//             _level.htmlText = "level " + String(deckLevel);
//             _level.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1),]

            // コスト関連
            _cost.x = _COST_X;
            _cost.y = _COST_Y;
            _cost.width = _COST_WIDTH;
            _cost.height = _COST_HEIGHT;
            // _cost.styleName = costCalc > costMax ? "DeckDataLabelRed" : "DeckDataLabel";
            // _cost.htmlText = "cost " + costCalc + "/" + CharaCardDeck.decks[currentIndex].maxCost;
            _cost.styleName = "DeckDataLabel";
            _cost.htmlText = "cost " + costCalc;
            _cost.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1),]
        }


        // コメントを入力中のエンターキーハンドラ
        private function enterKeyDownHandler(e:KeyboardEvent):void
        {
            if(e.keyCode == Keyboard.ENTER)
            {
//                _name.setFocus();
            }
        }

        // カレントデッキを変更
        public function changeClick():void
        {
            log.writeLog(log.LV_INFO, this, "_deckEditor.selectIndex", _deckEditor.selectIndex);
            // カレントデッキを変更
            _deckEditor.changeCurrentDeck(_deckEditor.selectIndex);
            _deckName.styleName = "CurrentDeckNameLabel";
            // コストとレベル
            loadDeckData();
        }

        // 左のデッキをクリック
        public function leftDeckClick():void
        {
            _deckEditor.selectIndex = _selectIndex-1;
            _selectIndex = _deckEditor.selectIndex;

            deleteDeckData();
            initDeckData();
        }

        // 右のデッキをクリック
        public function rightDeckClick():void
        {
            _deckEditor.selectIndex = _selectIndex+1;
            _selectIndex = _deckEditor.selectIndex;

            deleteDeckData();
            initDeckData();
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }

        // 非表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }

        public function get exitButton():SimpleButton
        {
            return _avatarView.exitButton;
        }

        public function get logoutButton():SimpleButton
        {
            return _avatarView.logoutButton;
        }

//         // アバターアップデート時のハンドラ
//         private function avatarUpdateHandler(e:Event):void
//         {
//             log.writeLog(log.LV_INFO, this, "view update!!", _avatar.level, _avatar.energy, _avatar.exp, _avatar.gems);
//             _name.text = "Lv." +_avatar.level + " " + _avatar.name;
//             _energy.text =  _avatar.energy.toString() + "/" +_avatar.energyMax.toString()  ;
//             _exp.text =  _avatar.exp.toString() + "/" + _avatar.nextExp.toString();
//             _gems.text =  _avatar.gems.toString();
//         }
    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.match.AvatarArea;


class ShowThread extends BaseShowThread
{
    public function ShowThread(aa:AvatarArea, stage:DisplayObjectContainer, at:int)
    {
        super(aa, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(aa:AvatarArea)
    {
        super(aa);
    }

}
