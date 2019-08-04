package view.scene.common
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;
    import flash.net.*;

    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;
    import mx.events.ToolTipEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.DeckUpdatedEvent;
    import view.image.game.*;
    import view.utils.*;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.scene.game.BuffClip;
    import view.image.raid.RaidBossBuffPanel;

    /**
     * CharaCardClip表示クラス
     *
     */


    public class CharaCardClip  extends BaseScene implements ICardClip
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1	:String = "キャラクターの名前です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "キャラクターのヒットポイントの最大値です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG3	:String = "キャラクターの攻撃力です。\n攻撃ダイスの数に影響します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG4	:String = "キャラクターの防御力です。\n防御ダイスの数に影響します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CARD1	:String = "所持しているキャラクターカードです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_GET0	:String = "手に入れることの出来るカードです";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_GET1	:String = "キャラクターの名前です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_GET2	:String = "キャラクターのヒットポイントの最大値です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_GET3	:String = "キャラクターの攻撃力です。\n攻撃ダイスの数に影響します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_GET4	:String = "キャラクターの防御力です。\n防御ダイスの数に影響します。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1	:String = "The name of the character.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = "The character's maximum hit points.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG3	:String = "The character's attack power.\nAttack power is used to calculate the number of attack dice contributed by this character.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG4	:String = "The character's defensive power.\nDefensive power is used to calculate the number of defensive dice contributed by this character.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CARD1	:String = "The character cards you own.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_GET0	:String = "Cards you can collect.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_GET1	:String = "The name of the character.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_GET2	:String = "The character's maximum hit points.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_GET3	:String = "The character's attack power.\nAttack power is used to calculate the number of attack dice contributed by this character.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_GET4	:String = "The character's defensive power.\nDefensive power is used to calculate the number of defensive dice contributed by this character.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1	:String = "角色名稱。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "角色的最大生命值";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG3	:String = "角色的攻擊力。\n影響攻擊骰子的數量。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG4	:String = "角色的防禦力。\n影響防禦骰子的數量。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CARD1	:String = "所擁有的角色卡。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_GET0	:String = "可以獲得的卡片";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_GET1	:String = "角色名稱。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_GET2	:String = "人物的最大生命值";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_GET3	:String = "角色的攻擊力。\n影響攻擊骰子的數量。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_GET4	:String = "角色的防禦力。\n影響防禦骰子的數量。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1	:String = "角色名称。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "角色的最大体力值。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG3	:String = "角色的攻击力。\n对攻击骰子的数值有影响。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG4	:String = "角色的防御力。\n对防御骰子的数值有影响。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CARD1	:String = "所持有的角色卡。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_GET0	:String = "可获得的卡片。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_GET1	:String = "角色名称。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_GET2	:String = "角色的最大体力值。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_GET3	:String = "角色的攻击力。\n对攻击骰子的数值有影响。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_GET4	:String = "角色的防御力。\n对防御骰子的数值有影响。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1	:String = "캐릭터의 이름 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "캐릭터의 히트 포인트의 최대치 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG3	:String = "캐릭터의 공격력 입니다.\n공격 주사위의 수에 영향을 미칩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG4	:String = "캐릭터의 방어력 입니다.\n방어 주사위의 수에 영향을 미칩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CARD1	:String = "소지하고 있는 캐릭터 카드 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_GET0	:String = "입수 가능한 카드입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_GET1	:String = "캐릭터의 이름 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_GET2	:String = "캐릭터의 히트 포인트의 최대치 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_GET3	:String = "캐릭터의 공격력 입니다.\n공격 주사위의 수에 영향을 미칩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_GET4	:String = "캐릭터의 방어력 입니다.\n방어 주사위의 수에 영향을 미칩니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1	:String = "Nom du Personnage";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = "HP maximum du Personnage";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG3	:String = "Point d'Attaque du Personnage.\nDétermine le nombre de fois que vous pouvez lancer les dés pendant la Phase d'Attaque.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG4	:String = "Point de Défense du Personnage.\nDétermine le nombre de fois que vous pouvez lancer les dés pendant la Phase de Défense.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CARD1	:String = "Liste de vos cartes personnage";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_GET0	:String = "Carte que vous pouvez obtenir";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_GET1	:String = "Nom du Personnage";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_GET2	:String = "HP maximum du Personnage";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_GET3	:String = "Point d'Attaque du Personnage.\nDétermine le nombre de fois que vous pouvez lancer les dés pendant la Phase d'Attaque.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_GET4	:String = "Point de Défense du Personnage.\nDétermine le nombre de fois que vous pouvez lancer les dés pendant la Phase de Défense.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1	:String = "キャラクターの名前です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "キャラクターのヒットポイントの最大値です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG3	:String = "キャラクターの攻撃力です。\n攻撃ダイスの数に影響します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG4	:String = "キャラクターの防御力です。\n防御ダイスの数に影響します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CARD1	:String = "所持しているキャラクターカードです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_GET0	:String = "手に入れることの出来るカードです";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_GET1	:String = "キャラクターの名前です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_GET2	:String = "キャラクターのヒットポイントの最大値です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_GET3	:String = "キャラクターの攻撃力です。\n攻撃ダイスの数に影響します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_GET4	:String = "キャラクターの防御力です。\n防御ダイスの数に影響します。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1    :String = "ชื่อตัวละคร";//"キャラクターの名前です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "ระดับ HP สูงสุดของตัวละคร";//"キャラクターのヒットポイントの最大値です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG3    :String = "พลังโจมตีของตัวละคร\nจะมีผลในการทอยลูกเต๋าโจมตี";//"キャラクターの攻撃力です。\n攻撃ダイスの数に影響します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG4    :String = "พลังป้องกันของตัวละคร\nจะมีผลในการทอยลูกเต๋าป้องกัน";//"キャラクターの防御力です。\n防御ダイスの数に影響します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CARD1   :String = "การ์ดตัวละครที่มีอยู่";//"所持しているキャラクターカードです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_GET0    :String = "การ์ดที่สามารถใช้ได้";//"手に入れることの出来るカードです";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_GET1    :String = "ชื่อตัวละคร";//"キャラクターの名前です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_GET2    :String = "ระดับ HP สูงสุดของตัวละคร";//"キャラクターのヒットポイントの最大値です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_GET3    :String = "พลังโจมตีของตัวละคร\nจะมีผลในการทอยลูกเต๋าโจมตี";//"キャラクターの攻撃力です。\n攻撃ダイスの数に影響します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_GET4    :String = "พลังป้องกันของตัวละคร\nจะมีผลในการทอยลูกเต๋าป้องกัน";//"キャラクターの防御力です。\n防御ダイスの数に影響します。";

        private static const _HP_PARAM_X:int = 18;
        private static const _HP_PARAM_Y:int = 214;
        private static const _AP_PARAM_X:int = 66;
        private static const _AP_PARAM_Y:int = 214;
        private static const _DP_PARAM_X:int = 127;
        private static const _DP_PARAM_Y:int = 214;
        private static const _LEVEL_PARAM_X:int = 15;
        private static const _LEVEL_PARAM_Y:int = 13;

        private static const _BONUS_OFFSET_X:int = 8;
        private static const _BONUS_OFFSET_Y:int = 7;

        private static const _FEAT_MAX:int = 4;

        private static const _BUFF_X:int = 25;
        private static const _BUFF_Y:int = 50;
        private static const _BOSS_BUFF_X:int = _BUFF_X + 5;
        private static const _BUFF_OFFSET_Y:int = 25;

        // ヘルプ用のステート
        private static const _GAME_HELP:int = 0;
        private static const _EDIT_HELP:int = 1;
        private static const _REWARD_HELP:int = 2;

        // 名前のX位置
        CONFIG::LOCALE_JP
        private static const LABEL_Y:int = 6;
        CONFIG::LOCALE_EN
        private static const LABEL_Y:int = 7;
        CONFIG::LOCALE_TCN
        private static const LABEL_Y:int = 10;
        CONFIG::LOCALE_SCN
        private static const LABEL_Y:int = 10;
        CONFIG::LOCALE_KR
        private static const LABEL_Y:int = 6;
        CONFIG::LOCALE_FR
        private static const LABEL_Y:int = 7;
        CONFIG::LOCALE_ID
        private static const LABEL_Y:int = 7;
        CONFIG::LOCALE_TH
        private static const LABEL_Y:int = 7;


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =  [
            // ゲーム時
            [
                "",                                                           // 0
//                "キャラクターの名前です。",                                   // 1
//                "キャラクターのヒットポイントの最大値です。",                 // 2
//                "キャラクターの攻撃力です。\n攻撃ダイスの数に影響します。",   // 3
//                "キャラクターの防御力です。\n防御ダイスの数に影響します。",   // 4
                _TRANS_MSG1,                                   // 1
                _TRANS_MSG2,                 // 2
                _TRANS_MSG3,   // 3
                _TRANS_MSG4,   // 4
                ],
            // バインダーやデッキに収納されているとき
            [
//                "所持しているキャラクターカードです。", // 0
                _TRANS_MSG_CARD1, // 0
                null,                           // 1
                null,                           // 2
                null,                           // 3
                null,                           // 4
            ],
            // get時
            [
//                "手に入れることの出来るカードです",                            // 0
//                "キャラクターの名前です。",                                   // 1
//                "キャラクターのヒットポイントの最大値です。",                 // 2
//                "キャラクターの攻撃力です。\n攻撃ダイスの数に影響します。",   // 3
//                "キャラクターの防御力です。\n防御ダイスの数に影響します。",   // 4
                _TRANS_MSG_GET0,                            // 0
                _TRANS_MSG_GET1,                                   // 1
                _TRANS_MSG_GET2,                 // 2
                _TRANS_MSG_GET3,   // 3
                _TRANS_MSG_GET4,   // 4
                ]
            ];


        // チップヘルプを設定される側のUIComponetオブジェクト
        private  var _toolTipOwnerArray:Array = [];

        protected var _root:UIComponent;
        private var _container:UIComponent = new UIComponent(); // 表示コンテナ
        private var _textContainer:UIComponent = new UIComponent(); // 裏面テキスト
        private var _backContainer:UIComponent = new UIComponent(); // 裏面コンテナ
        protected var _metaContainer:UIComponent = new UIComponent(); // 裏表合わせたコンテナ

        protected var _charaCard:CharaCard;
        private var _frame:CharaCardFrame;
        private var _chara:CharaCardChara;
        private var _over:CharaCardOver;
        private var _chain:CharaCardChain; // 封印の鎖
        private var _caution:CautionCost; // コスト警告
        private var _cautionPool:CautionCost = new CautionCost(0,0);
        private var _base:CharaCardBase; // 選択インスタンス
        private var _onBase:CompoOnCharaCardBase; // 選択インスタンス
        private var _hp:Label = new Label();
        private var _ap:Label = new Label();
        private var _dp:Label = new Label();
        private var _level:Label = new Label();
        private var _name:Label = new Label();

        // hpだけ保持
        private var _hpNum:int = 0;

        private var _backFrame:CharaCardFrame;
        private var _sepia:Boolean =false;

        private var _params:Array = []; // Array of Label
        private var _obverse:Boolean = false;
        private var _id:int;
        private static const URL:String = "/public/image/";

        private var _deckEditor:DeckEditor = DeckEditor.instance;
        private var _growth:Growth = Growth.instance;
        private var _charaCardInventory:ICardInventory;
        private var _storyClip:StoryClip;

        private var _buffClips:Array = [];
        private var _bossBuffPanels:Array = [];

        // カードのフレーム番号
        private var _cardFrame:int = 0;

        // カードのフレーム番号の定数
        private static const _CHARA_FRAME:int = 2;
        private static const _COIN_FRAME:int = 7;
        private static const _TIPS_FRAME:int = 8;
        private static const _EX_COIN_FRAME:int = 9;

        // 開店時にHitAreaが縮こまないようにするHitArea
        private var _hitArea:Sprite = new Sprite();

        private static const _CHARA_CARD_W:int = 171;
        private static const _CHARA_CARD_H:int = 245;
        private static const _MARGIN:int = 5;


        private var _expTip:CharaCardExpTip;
        protected var _foe:Boolean;

        private var _num:int;
        private var _number:Label = new Label();

        protected var _buffSetTurn:Boolean = true;

        // ***** Bitmap つかってみる *****
        private var _loader:Loader;

        /**
         * コンストラクタ
         *
         */
        public function CharaCardClip(cc:CharaCard, foe:Boolean = false, num:int = 1)
        {
            _charaCard = cc;
            _foe = foe;
            _num = num;
            // HITAREAを作る
            _hitArea.graphics.beginFill(0xFFFFFF,0.0);
            _hitArea.graphics.drawRect(-_MARGIN,
                                       -_MARGIN,
                                       _CHARA_CARD_W+_MARGIN*2,
                                       _CHARA_CARD_H+_MARGIN*2);

            // キャラクターで処理を分ける
            switch (_charaCard.kind)
            {
            // コイン
            case Const.CC_KIND_COIN:
                _cardFrame = _COIN_FRAME;
                break;
            // かけら
            case Const.CC_KIND_TIPS:
                _cardFrame = _TIPS_FRAME;
                break;
            // EXコイン
            case Const.CC_KIND_EX_COIN:
                _cardFrame = _EX_COIN_FRAME;
                break;
            // EXかけら
            case Const.CC_KIND_EX_TIPS:
                _cardFrame = _EX_COIN_FRAME;
                break;
            // EXかけら
            case Const.CC_KIND_ORB:
                _cardFrame = _EX_COIN_FRAME; // 変える予定
                break;
            // EXかけら
            case Const.CC_KIND_ARTIFACT:
                _cardFrame = _EX_COIN_FRAME; // 変える予定
                break;
            // キャラ
            default:
                _cardFrame = _CHARA_FRAME;
                break;
            }


//            scaleX = 0.94
//            scaleY = 0.94
        }


        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  // 本体
            _toolTipOwnerArray.push([1,_name]); // 名前
            _toolTipOwnerArray.push([2,_hp]);   // ヒットポイント
            _toolTipOwnerArray.push([3,_ap]);   // 攻撃力
            _toolTipOwnerArray.push([4,_dp]);   // 防御力
        }

        // ロード完了時の処理
        private function loadDone(e:Event):void
        {
            var bmd:BitmapData= new BitmapData(_loader.width,_loader.height);
            bmd.draw(_loader);
            var bitmap:Bitmap = new Bitmap(bmd);
            _container.addChild(bitmap);
        }

        // カードの各要素を読み出す
        public function clipInitialize():Thread
        {
            _frame = new CharaCardFrame(_charaCard.feats.length, _charaCard.passiveSkill.length ,_cardFrame);
            _backFrame= new CharaCardFrame(_charaCard.feats.length, _charaCard.passiveSkill.length);
            _frame.onReverse();
            _backFrame.onObverse();

//            log.writeLog(log.LV_WARN, this, "clip init", URL+_charaCard.charaImage);
            // _loader = new Loader();
            // _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadDone);
            // _loader.load(new URLRequest(URL+_charaCard.charaImage));

            _chara = new CharaCardChara(URL+_charaCard.charaImage);
            _over = new CharaCardOver(_charaCard.kind);

            // レアを1/2にして設定
//            _over.setRarity((_charaCard.rarity-1)/2+1);

            // スロットカラーを指定
            _over.setColorSlot(_charaCard.slotColor);

            // レベルを設定
            _over.setLevel(_charaCard.level);

            // カードタイプを設定
            _over.setCardID(_charaCard.id);

            var plThread:ParallelExecutor = new ParallelExecutor();
            plThread.addThread(_backFrame.getShowThread(_textContainer,1));
            plThread.addThread(_frame.getShowThread(_container,1));
            plThread.addThread(_chara.getShowThread(_container,2));

            // キャラカードのみの処理
            if(_cardFrame == _CHARA_FRAME)
            {
                // パラメーターをセット
                _params.push(_hp);
                _params.push(_ap);
                _params.push(_dp);
                _params.push(_level);
                // 外枠を追加
                plThread.addThread(_over.getShowThread(_container,3));
            }
            // セピアを適応
            if (_sepia)
            {
                _chara.setSepiaEffect();
            }

//             Unlight.GCW.watch(_frame);
//             Unlight.GCW.watch(_backFrame);
//            Unlight.GCW.watch(_chara);
//            Unlight.GCW.watch(_over);
            return plThread;
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

        // 各種ラベル（文字）の初期化
        public function labelInitialize():void
        {

            // もしUNKNOWカードなら
            if (_charaCard.id == 0)
            {
                _hp.text = "?";
                _ap.text = "?"
                _dp.text = "?"
                _level.text = "?"
                _name.text = "Unknown";
            }
            else
            {
                _hpNum = _charaCard.hp;
                _hp.text = (_hpNum < Const.DUEL_CC_VIEW_HP_MAX) ? _hpNum.toString() : Const.OVER_HP_STR;
                _ap.text = _charaCard.ap.toString();
                _dp.text = _charaCard.dp.toString();
                _level.text = _charaCard.level.toString();
                _name.text = _charaCard.name;
            }



            _hp.x = _HP_PARAM_X;
            _hp.y = _HP_PARAM_Y;
            _ap.x = _AP_PARAM_X;
            _ap.y = _AP_PARAM_Y;
            _dp.x = _DP_PARAM_X;
            _dp.y = _DP_PARAM_Y;
            _level.x = _LEVEL_PARAM_X;
            _level.y = _LEVEL_PARAM_Y;

            _name.x = 32;
            _name.y = LABEL_Y;
            CONFIG::LOCALE_SCN
            {
                _name.y = LABEL_Y - 5;
            }

            _name.styleName = "CharaCardName"
            _name.width = 110;
            _name.height = 20;
            _name.filters = [
                new GlowFilter(0x111111, 1, 2, 2, 16, 1),
                ];

            callLater(fontSizeAdjust,[_name])
            // 必殺技のテキストフィールドのイニシャライズ
//            log.writeLog(log.LV_FATAL, this, "lebel init +++",charaCard.feats,charaCard.id);
            for(var i:int = 0; i < _charaCard.feats.length; i++)
            {
//                log.writeLog(log.LV_FATAL, this, "++feat is ", _charaCard.feats[i].caption);
                 _backFrame.addFeatContainer(_charaCard.feats[i].name, _charaCard.feats[i].caption);
//                 log.writeLog(log.LV_FATAL, this, "+++ 必殺技のテキストのイニシャライズ",_charaCard.feats[i].name);
//                 _textContainer.addChild(_backFrame.featsContainers[i]);
            }

            if (_charaCard.passiveSkill,length == 0)
            {
                _backFrame.removePassiveBase();
            }
            else
            {
                for(i = 0; i < _charaCard.passiveSkill.length; i++)
                {
                    _backFrame.addPassiveSkillContainer(_charaCard.passiveSkill[i].name, _charaCard.passiveSkill[i].caption);
                }
            }

            // テキストコンテナを追加
            _backContainer.addChild(_textContainer);
            // 系統樹ボタンを追加
//            _backContainer.addChild(_backFrame.growthButton);
            // ストーリーボタンを追加
//            _backContainer.addChild(_backFrame.bookButton);
            // ストーリーが存在したら出す
//            _backFrame.bookButton.visible = _charaCard.bookExist;

            _backContainer.visible = false;
            _container.addChild(_name);
            _params.forEach(setLabelConfig);
//             _bonuses.forEach(setBonusLabelConfig);
            _metaContainer.addChild(_container);
            _metaContainer.addChild(_backContainer);

            _container.x = -80;
            _container.y = -120;

            // 後ろ側反転させておく
            _backContainer.x =  80;
            _backContainer.y = -120;
            _backContainer.scaleX = -1;

            addChild(_metaContainer);
            _metaContainer.x = 80;
            _metaContainer.y = 120;
            // ツールチップが必要なオブジェをすべて登録する
            initilizeToolTipOwners();

            _container.addEventListener(MouseEvent.CLICK, mouseClickHandler);
            _textContainer.addEventListener(MouseEvent.CLICK, mouseClickHandler);
//            _backFrame.growthButton.addEventListener(MouseEvent.CLICK, pushRequirementsHandler);
//            _backFrame.bookButton.addEventListener(MouseEvent.CLICK, pushStoryHandler);

            if (!_foe)
            {
                // expTipの表示
                _expTip = new CharaCardExpTip(_charaCard.next);
//                  Unlight.GCWOn();
//                  Unlight.GCW.watch(_expTip);

//                _expTip.getShowThread(_container).start();
                _container.addChild(_expTip);
            }
//            log.writeLog(log.LV_FATAL, this, "+INIT5");
            if (_num>1)
            {
                _number.x = -35;
                _number.y = 180;
                _number.width = 190;
                _number.height = 100;
                _number.htmlText = "x<FONT SIZE =\"54\" >"+_num.toString()+"</FONT>";
                _number.styleName = "ResultCardNumLabel";
                _number.filters = [new GlowFilter(0xFF0000, 1, 6, 6, 3, 1)];
                addChild(_number)

            }

            if (_caution)
            {
                _container.setChildIndex(_caution, _container.numChildren-1);
            }
        }

        // 警告表示用のイベントハンドラ。表示するカードにだけ登録する
        public function addDeckUpdatedEventHandler():void
        {
            _deckEditor.addEventListener(DeckUpdatedEvent.UPDATED_CHARA_CARD, deckUpdatedHandler);
        }

        // 閲覧中でないときは外す
        public function removeDeckUpdatedEventHandler():void
        {
            _deckEditor.removeEventListener(DeckUpdatedEvent.UPDATED_CHARA_CARD, deckUpdatedHandler);
            // ついでにマークも捨てる
            if (_caution)
            {
                _container.removeChild(_caution);
                _caution = null;
            }
        }

        // 名前が全部はいるように調整
        private function fontSizeAdjust(label:Label):void
        {
            var w:int = label.width;
            label.validateNow();
            while (label.textWidth > w)
            {
                label.validateNow();
                label.setStyle("fontSize",  int(label.getStyle("fontSize"))-1);
                label.setStyle("paddingTop",  int(label.getStyle("paddingTop"))+1);
            }
        }


        // カードを封印している鎖を読み出す
        public function chainInitialize():void
        {
            _chain = new CharaCardChain(GrowthTree.ID(charaCardId).down.length);
            _container.addChild(_chain);
        }

        // カードを封印している鎖を読み出す
        public function baseInitialize():void
        {
            _base = new CharaCardBase();
            _onBase = new CompoOnCharaCardBase();
            _onBase.visible = false;
            _container.addChildAt(_onBase, 0);
            _container.addChildAt(_base, 0);
        }

        public function cautionInitialize(lv_a:int=0, lv_b:int=0):void
        {
            if (_caution)
            {
                if (lv_a | lv_b)
                {
                    _caution.setCaution(lv_a, lv_b);
                }
                else
                {
                    _container.removeChild(_caution);
                    _caution = null;
                }
            }
            else
            {
                if (lv_a | lv_b)
                {
                    _caution = _cautionPool;
                    _caution.setCaution(lv_a,lv_b);
                    _container.addChild(_caution);
                }
            }
        }


        public override function final():void
        {
//            log.writeLog(log.LV_FATAL, this, "CHARACARDCLIP HIDE HIDE HDIE", _charaCard.id);
            if ((!_foe)&&(_expTip!=null))
            {
                _expTip.final();
//                _container.removeChild(_expTip);
                RemoveChild.apply(_expTip);
            }

            // 必殺技のテキストフィールドのイニシャライズ
            for(var i:int = 0; i < _charaCard.feats.length; i++)
            {
//                RemoveChild.apply(_backFrame.featsContainers[i]);
            }


            RemoveChild.apply(_textContainer);
//            RemoveChild.apply(_backFrame.growthButton);
//            RemoveChild.apply(_backFrame.bookButton);

            RemoveChild.apply(_name);
            RemoveChild.apply(_container);
            RemoveChild.apply(_backContainer);
            _params.forEach(removeLabelConfig);
//             _bonuses.forEach(removeLabelConfig);

            if (_metaContainer.parent != null)
            {
                RemoveChild.apply(_metaContainer);
            }
            var plThread:ParallelExecutor = new ParallelExecutor();

            if (_frame!=null)
            {
                plThread.addThread(_frame.getHideThread());
            }
            if (_chara!=null)
            {
                plThread.addThread(_chara.getHideThread());
            }
            if (_over!=null)
            {
                plThread.addThread(_over.getHideThread());
            }
            if (_backFrame!=null)
             {
                 plThread.addThread(_backFrame.getHideThread());
             }
            plThread.start();
            removeAllEvent();
            RemoveChild.all(_container);
            RemoveChild.all(_textContainer);
            RemoveChild.all(_backContainer);
            RemoveChild.all(_metaContainer);
            _frame=null;
            _chara=null;
            _over=null;
            _backFrame=null;
            super.final();


        }

        // ラベルのスタイル定義
        private function setLabelConfig(item:*, index:int, array:Array):void
        {
            item.styleName = "CharaCardParam";
            item.width = 30;
            item.height = 20;
            item.filters = [
                new GlowFilter(0x000000, 1, 2, 2, 16, 1),
//              new DropShadowFilter(2, 45, 0x000000, 1, 2, 2, 16)
                ];
            _container.addChild(item);
        }

        // ラベルのスタイル定義
        private function setBonusLabelConfig(item:*, index:int, array:Array):void
        {
            item.styleName = "CharaCardParam";
            item.width = 30;
            item.height = 20;
            item.filters = [
                new GlowFilter(0x000000, 1, 2, 2, 16, 1),
//              new DropShadowFilter(2, 45, 0x000000, 1, 2, 2, 16)
                ];
            _container.addChild(item);
        }


        // ラベルのリムーブ
        private function removeLabelConfig(item:*, index:int, array:Array):void
        {
           RemoveChild.apply(item);
        }

        // イベントを初期化
        public function UnrotateEventInitialize():void
        {
            _over.setTurn(false);
            _container.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
            _textContainer.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
        }

        // イベントを初期化
        public function editEventInitialize():void
        {
            _over.setTurn(false);
            addEventListener(MouseEvent.CLICK, selectCardHandler);
            _container.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
            _textContainer.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
        }

        // イベントを初期化
        public function requirementsEventInitialize():void
        {
            _over.setTurn(false);
            removeEventListener(MouseEvent.CLICK, selectCardHandler);
            _container.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
            _textContainer.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
            addEventListener(MouseEvent.CLICK, selectGrowthCardHandler);
        }

        // 全てのイベントをはずす
        public function removeAllEvent():void
        {

//             _backFrame.growthButton.removeEventListener(MouseEvent.CLICK, pushRequirementsHandler);
//             _backFrame.bookButton.removeEventListener(MouseEvent.CLICK, pushStoryHandler);
//            _backFrame.finalizeFrame();
            _container.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
            _textContainer.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
            _deckEditor.removeEventListener(DeckUpdatedEvent.UPDATED_CHARA_CARD, deckUpdatedHandler);
            removeEventListener(MouseEvent.CLICK, selectCardHandler);
            removeEventListener(MouseEvent.CLICK, selectGrowthCardHandler);
        }

        // クリックハンドラ。クリックすると反転
        private function mouseClickHandler(e:MouseEvent):void
        {
//             mouseEnabled = false;
//             mouseChildren = false;
            addChild(_hitArea);
           if (_obverse==true)
            {
                // matrix3dを有効に
                _metaContainer.z = 0;
                (new FlipCardThread(this, true )).start();
            }
            else
            {
                // matrix3dを有効に
                _metaContainer.z = 0;
                (new FlipCardThread(this, false)).start();
            }

            _container.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
            _textContainer.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
        }

        // デッキ更新時のイベントハンドラ
        // このカードのコストとデッキコストを比較して警告を表示する
        private function deckUpdatedHandler(e:DeckUpdatedEvent):void
        {
            setCaution(e.costs, e.charactors, e.parents);
        }

        // デッキに特定のキャラクターが含まれるか
        private function containSameChara(charactors:Array, parents:Array, charactor:int, parent:int):Boolean
        {
            if (charactors.indexOf(charactor) > -1)
            {
                return true;
            }

            // 復活キャラ
            var offset:int = Const.REBORN_CHARACTOR_ID_OFFSET;
            var range:int = Const.REBORN_CHARACTOR_ID_RANGE;
            var cid:int = (charactor > offset && charactor < offset + range) ? charactor - offset : charactor;

            if (parents.indexOf(cid) > -1)
            {
                return true;
            }

            // マイナーチェンジ
            if (parents.indexOf(parent) > -1)
            {
                return true;
            }

            return false;
        }

        // コスト警告をセット
        public function setCaution(costs:Array, charactors:Array, parents:Array):void
        {
            switch (_charaCard.kind)
            {
            case Const.CC_KIND_CHARA:
            case Const.CC_KIND_MONSTAR:
            case Const.CC_KIND_REBORN_CHARA:
            case Const.CC_KIND_RARE_MONSTAR:
            case Const.CC_KIND_RENTAL:
            case Const.CC_KIND_EPISODE:
                break;
            default:
                return;
            }

            if (costs.length == 0 || costs.length == 3 || containSameChara(charactors, parents, _charaCard.charactor, _charaCard.parentID))
            {
                cautionInitialize(0,0);
                return;
            }

            var max_cost_in_deck:int = Math.max.apply(null, costs);
            var caution_lv:Array = [0, 0];

            for (var i:int=0; i < costs.length; i++)
            {
                if (_charaCard.cost < costs[i])
                {
                    if (costs[i] == max_cost_in_deck)
                    {
                        caution_lv[i] = int(Math.abs(_charaCard.cost - costs[i]) / Const.CORRECTION_CRITERIA);
                        if (caution_lv[i] > 2) caution_lv[i] = 2;
                    }
                }
                else
                {
                    if (_charaCard.cost > max_cost_in_deck)
                    {
                        caution_lv[i] = int(Math.abs(_charaCard.cost - costs[i]) / Const.CORRECTION_CRITERIA);
                        if (caution_lv[i] > 2) caution_lv[i] = 2;
                        caution_lv[i] -= CharaCardDeck.decks[DeckEditor.instance.selectIndex].cautionLv[i];
                    }
                }
            }

            if (caution_lv[0] == 0 && caution_lv[1] !=0)
            {
                caution_lv.reverse();
            }

            cautionInitialize(caution_lv[0], caution_lv[1]);
        }

        // マウスイベントを付与する
        public function addMouseClickEvent():void
        {
//             mouseEnabled = true;
//             mouseChildren = true;
            _container.addEventListener(MouseEvent.CLICK, mouseClickHandler);
            _textContainer.addEventListener(MouseEvent.CLICK, mouseClickHandler);
            removeChild(_hitArea);
        }

        public function flipReset(flip:Boolean):void
        {
            if (flip)
            {
                _backContainer.scaleX=-1;
                _backContainer.x=80;
            }
            else
            {
                _backContainer.scaleX=1;
                _backContainer.x=-80;
            }
        }

        public  override function set rotationY(arg:Number):void
        {
            _metaContainer.rotationY = arg;
            if (arg%360<94||arg%360>274)
            {
                _container.visible = true;
                _backContainer.visible = false;
                _obverse = false;
            }else{
                _container.visible = false;
                _backContainer.visible = true;
                _obverse = true;

            }

        }

        public  override function get rotationY():Number
        {
            return _metaContainer.rotationY;
        }

        public function get metaFrame():UIComponent
        {
            return _metaContainer;
        }


        // カードベースのフォーカスを有効にする
        public function baseFocusOn():void
        {
            if(_onBase!=null)
            {
                _onBase.visible = true;
            }
        }

        // カードベースのフォーカスを無効にする
        public function baseFocusOff():void
        {
            if(_onBase!=null)
            {
                _onBase.visible = false;
            }
        }

        // ステータス状態を付与する
        public function addBuffStatus(id:int, value:int, turn:int):void
        {
            if (!_buffSetTurn) return;
            var index:int = _buffClips.length;
            var clipIndex:int = -1;

            // 既に同じ効果が存在するかをソートする
            for(var i:int = 0; i < index; i++)
            {
                if(_buffClips[i].no == id)
                {
                    clipIndex = i;
                }
            }

            // 新しい効果なら
            if(clipIndex == -1)
            {
                // ステータスを追加する
                _buffClips.push(new BuffClip(id, value, turn, _buffSetTurn));
                _buffClips[index].getShowThread(_container).start();
            }
            else
            {
                // 既に同じステータスが存在するならターン数とValueを加算する
                _buffClips[clipIndex].turn = turn;
                _buffClips[clipIndex].value = value;
            }
            updateBuffPosition();
        }

        public function getBuffClips():Array
        {
            return _buffClips;
        }

        public function addBossBuffStatus(id:int, value:int, turn:int, limit:Date):void
        {
            if (_buffSetTurn) return;
            var index:int = _bossBuffPanels.length;
            var clipIndex:int = -1;

            // 既に同じ効果が存在するかをソートする
            for(var i:int = 0; i < index; i++)
            {
                if(_bossBuffPanels[i].no == id)
                {
                    clipIndex = i;
                }
            }

            // 新しい効果なら
            if(clipIndex == -1)
            {
                // ステータスを追加する
                if (id != Const.BUFF_STIGMATA && id != Const.BUFF_CURSE && id != Const.BUFF_TARGET) {
                    _bossBuffPanels.push(new RaidBossBuffPanel(id,value,turn,limit,_container));
                } else {
                    _bossBuffPanels.push(new BuffClip(id, value, turn, true));
                    _bossBuffPanels[index].getShowThread(_container).start();
                }
            }
            else
            {
                // 既に同じステータスが存在するならターン数とValueを加算する
                if (id != Const.BUFF_STIGMATA && id != Const.BUFF_CURSE && id != Const.BUFF_TARGET) {
                    _bossBuffPanels[clipIndex].updateLimitAt(turn,limit);
                } else {
                    _bossBuffPanels[clipIndex].turn = turn;
                    _bossBuffPanels[clipIndex].value = value;
                }
            }
            updateBuffPosition();
        }

        // ステータス状態解除
        public function removeBuffStatus(id:int, value:int):void
        {
            if (!_buffSetTurn) return;
            var tmpArray:Array;

            // 既に同じ効果が存在するかをソートする
            for(var i:int = 0; i < _buffClips.length; i++)
           {
                if(_buffClips[i].no == id && _buffClips[i].value == value)
                {
                    tmpArray = _buffClips.splice(_buffClips.indexOf(_buffClips[i]),1);
                    tmpArray[0].visible = false;
                    tmpArray[0].getHideThread().start();
                    i -= 1;
                }
            }
            updateBuffPosition();
        }
        public function removeBossBuffStatus(id:int, value:int):void
        {
            if (_buffSetTurn) return;
            var tmpArray:Array;

            // 既に同じ効果が存在するかをソートする
            for(var i:int = 0; i < _bossBuffPanels.length; i++)
            {
                if(_bossBuffPanels[i].buffId == id && _bossBuffPanels[i].value == value)
                {
                    tmpArray = _bossBuffPanels.splice(_bossBuffPanels.indexOf(_bossBuffPanels[i]),1);
                    tmpArray[0].visible = false;
                    tmpArray[0].getHideThread().start();
                    i -= 1;
                }
            }
            updateBuffPosition();
        }

        // ステータス状態解除
        public function removeBuffStatusAll():void
        {
            var tmpArray:Array;
            // 全てのbuffを1つずつ外す
            for(var i:int = 0; i < _buffClips.length; i++)
            {
                if (_buffClips[i].no == Const.BUFF_CONTROL) continue;
                tmpArray = _buffClips.splice(_buffClips.indexOf(_buffClips[i]),1);
                tmpArray[0].visible = false;
                tmpArray[0].getHideThread().start();
                i -= 1;
            }
            // 全てのbuffを1つずつ外す
            for(var x:int = 0; x < _bossBuffPanels.length; x++)
            {
                tmpArray = _bossBuffPanels.splice(_bossBuffPanels.indexOf(_bossBuffPanels[x]),1);
                tmpArray[0].visible = false;
                tmpArray[0].getHideThread().start();
                x -= 1;
            }
            updateBuffPosition();
        }

        // ステータスを進行させる
        public function updateBuffStatus(id:int, value:int, turn:int):void
        {
            if (!_buffSetTurn) return;
            var tmpArray:Array;

            for(var i:int = 0; i < _buffClips.length; i++)
            {
                if(_buffClips[i].no == id && _buffClips[i].value == value)
                {
                    // ターン数を変動
                    if (_buffClips[i].turn + turn > 9)
                    {
                        _buffClips[i].turn = 9;
                    }
                    else
                    {
                        _buffClips[i].turn += turn;
                    }
                    // ターンが０以下なら消失させる
                    if(_buffClips[i].turn <= 0)
                    {
                        tmpArray = _buffClips.splice(_buffClips.indexOf(_buffClips[i]),1);
                        tmpArray[0].visible = false;
                        tmpArray[0].getHideThread().start();
                        i -= 1;
                    }
                }
            }
            updateBuffPosition();
        }

        // すべてのbuffの表示位置を更新する
        public function updateBuffPosition():void
        {
            for(var i:int = 0; i < _buffClips.length; i++)
            {
                _buffClips[i].x = _BUFF_X;
                _buffClips[i].y = _BUFF_Y + _BUFF_OFFSET_Y * i;
            }
            for(var x:int = 0; x < _bossBuffPanels.length; x++)
            {
                _bossBuffPanels[x].x = _BOSS_BUFF_X;
                _bossBuffPanels[x].setYPos(_BUFF_Y + _BUFF_OFFSET_Y * x);
            }
        }

        // 装備ボーナスの設定atk
        public function setAttackBonus(sPoint:int, sDice:int, aPoint:int, aDice:int):void
        {
            _over.setAtkBonus([sPoint, sDice, aPoint, aDice]);
//            log.writeLog(log.LV_INFO, this, "set bonus atk!!!", sPoint, sDice, aPoint, aDice);
        }

        // 装備ボーナスの設定def
        public function setDeffenceBonus(sPoint:int, sDice:int, aPoint:int, aDice:int):void
        {
            _over.setDefBonus([sPoint, sDice, aPoint, aDice]);
//            log.writeLog(log.LV_INFO, this, "set bonus def!!!", sPoint, sDice, aPoint, aDice);
        }

        // 鎖を外す
        public function unlockChain():void
        {
            _chain.unlockChain();
        }

        // DicにdClipを格納
        private function setCCC(cc:CharaCard,index:int):void
        {
//             if (_cccDic[cc] ==null)
//             {
//                 _cccDic[cc] = new CharaCardClip(cc);
//                 _cccDic[cc].getEditShowThread(_cardContainers[index],0).start();
//                _loadThread.addThread(_cccDic[cc].getEditShowThread(_cardContainers[index]));
//                 Unlight.GCWOn();
//                 Unlight.GCW.watch(_cccDic[cc] );
//            }
        }

        // カード選択ハンドラ
        private function selectCardHandler(e:MouseEvent):void
        {
            _deckEditor.selectCard(charaCardId);
        }

        // 系統樹表示イベント
        public function pushRequirementsHandler(e:MouseEvent):void
        {
            _growth.requirements(charaCardId);
        }

        // 成長カード選択ハンドラ
        private function selectGrowthCardHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "card select!!!!");
            _growth.selectCard(charaCardId);
        }

        // ストーリー表示イベント
        public function pushStoryHandler(e:MouseEvent):void
        {
            _storyClip = new StoryClip(_charaCard.story);
            _storyClip.getShowThread(this.parent.parent.parent).start();
        }

        // スケールを変えるスレッド
        public function getScaleThread(scale:Number):Thread
        {
//            return new TweenerThread(_metaContainer, {scaleX:scale, scaleY:scale, transition:"easeInSine", time:0.2, show:true});
            return new BeTweenAS3Thread(_metaContainer, {scaleX:scale ,scaleY:scale}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_IN_SINE, 0.0 ,true);
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread( new ShowThread(_charaCard, this, stage));
            sExec.addThread( new ClousureThread(function():void{ updateHelp(_GAME_HELP)}));
            return sExec;
        }

        // 非表示スレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }


        // カードが回転しない表示スレッドを返す
        public function getUnrotateShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new UnrotateShowThread(_charaCard, this, stage));
            sExec.addThread(new ClousureThread(function():void{ updateHelp(_EDIT_HELP)}));
            return sExec;

        }

        // セピア表示用スレッドを返す
        public function getSepiaShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
//
            _sepia = true;
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread( new ShowThread(_charaCard, this, stage));
            sExec.addThread( new ClousureThread(function():void{ updateHelp(_GAME_HELP)}));
            return sExec;
        }


        // 景品用回転しない表示スレッドを返す
        public function getRewardShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new UnrotateShowThread(_charaCard, this, stage));
            sExec.addThread(new ClousureThread(function():void{ updateHelp(_REWARD_HELP)}));
            return sExec;

        }

        // エディット用表示スレッドを返す
        public function getEditShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new EditShowThread(_charaCard, this, stage));
            sExec.addThread(new ClousureThread(function():void{ updateHelp(_EDIT_HELP)}));
//            alpha = 0.0;
            return sExec;

        }

        // エディット用非表示スレッドを返す
        public function getEditHideThread(type:String=""):Thread
        {
            return new EditHideThread(this);
        }

        // 系統樹用表示スレッドを返す
        public function getRequirementsShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread( new RequirementsShowThread(_charaCard, this, stage));
            sExec.addThread( new ClousureThread(function():void{ updateHelp(_EDIT_HELP)}));
            return sExec;
        }

        // 系統樹用表示スレッドを返す
        public function getChainShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread( new ChainShowThread(_charaCard, this, stage));
            sExec.addThread( new ClousureThread(function():void{ updateHelp(_EDIT_HELP)}));
            return sExec;
        }

        // 系統樹用非表示スレッドを返す
        public function getRequirementsHideThread(type:String=""):Thread
        {
            return new RequirementsHideThread(this);
        }

        public function set cardInventory(inv:ICardInventory):void
        {
            _charaCardInventory = inv;
        }

        public function get cardInventory():ICardInventory
        {
            return _charaCardInventory
        }

        public function get charaCard():CharaCard
        {
            return _charaCard;
        }

        public function get charaCardId():int
        {
            return _charaCard.id;
        }

        public function set hp(h:int):void
        {
            log.writeLog(log.LV_DEBUG, this, "set chara card hp",h);
            if(h >= _charaCard.hp)
            {
                _hp.styleName = "CharaCardParam";
            }
            else if(h >= _charaCard.hp / 2)
            {
                _hp.styleName = "CharaCardParamYellow";
            }
            else
            {
                _hp.styleName = "CharaCardParamRed";
            }
            _hpNum = h;
            if (_hpNum < Const.DUEL_CC_VIEW_HP_MAX) {
                _hp.text = h.toString();
            }
        }

        public function get hp():int
        {
            return _hpNum;
            // return _hp.text == "?" ? 0 : int(_hp.text);
        }

        public function setUnknownHp(h:int):void
        {
            this.hp = h;
        }

        public function getEditUpdateShowThread():Thread
        {
            return new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.1 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_EXPO, 0.0 ,true );
        }
        public function getEditUpdateHideThread():Thread
        {
            return new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_IN_EXPO );
        }
        public function get finished():Boolean
        {
            return _finished;
        }

        public function get buffData():Array
        {
            return _buffClips;
        }

        public function updateFeatCondition(feat_index:int, condition:String):void
        {
            _backFrame.updateFeatCondition(feat_index, condition);
        }

    }

}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.geom.*;

import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import model.CharaCard;
import view.scene.common.CharaCardClip;
import view.BaseShowThread;
import view.BaseHideThread;
import controller.LobbyCtrl;



// 表示スレッド
class ShowThread extends BaseShowThread
{
    protected var _cc:CharaCard;
    protected var _ccc:CharaCardClip;

    public function ShowThread(cc:CharaCard, ccc:CharaCardClip, stage:DisplayObjectContainer)
    {
        _cc = cc;
        _ccc = ccc;
        super(ccc,stage)
    }

    protected override function run():void
    {
        // キャラカードの準備を待つ
        if (_cc.loaded == false)
        {
            _cc.wait();
        }
        next(init);
    }


    private function init ():void
    {
        var thread:Thread;
        thread =  _ccc.clipInitialize();
        thread.start();
        thread.join();
        next(close);
    }

    protected override function close ():void
    {
        _ccc.labelInitialize();
        addStageAt();
    }

}


// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    protected var _ccc:CharaCardClip;
    public function HideThread(ccc:CharaCardClip)
    {
        _ccc = ccc;
        super(ccc);
     }

}

// エディット用表示スレッド
class UnrotateShowThread extends ShowThread
{
    public function UnrotateShowThread(cc:CharaCard, ccc:CharaCardClip, stage:DisplayObjectContainer)
    {
        super(cc,ccc,stage)
    }

    protected override function close():void
    {
        _ccc.labelInitialize();
        _ccc.UnrotateEventInitialize();
        _ccc.cautionInitialize();
        addStageAt();
    }
}

// エディット用表示スレッド
class EditShowThread extends ShowThread
{
    public function EditShowThread(cc:CharaCard, ccc:CharaCardClip, stage:DisplayObjectContainer)
    {

        super(cc,ccc,stage)
    }

    protected override function close():void
    {
//         log.writeLog(log.LV_FATAL, this, "+EDIT1");
        _ccc.labelInitialize();
//         log.writeLog(log.LV_FATAL, this, "+EDIT2");
        _ccc.editEventInitialize();
//         log.writeLog(log.LV_FATAL, this, "+EDIT3");
        addStageAt();
    }
}

// Showを待つHideスレッド
class EditHideThread extends HideThread
{
    public function EditHideThread(ccc:CharaCardClip)
    {
        super(ccc);
    }

    protected override function run():void
    {
        if(Sprite(_view).parent != null)
        {
            next(exit);
        }
        else
        {
            if(_ccc.finished)
            {
                next(exit);
            }else{
                next(run);
            }
        }
    }
}


// 系統樹用表示スレッド
class ChainShowThread extends ShowThread
{
    public function ChainShowThread(cc:CharaCard, ccc:CharaCardClip, stage:DisplayObjectContainer)
    {
        super(cc,ccc,stage)
    }

    protected override function close():void
    {
        _ccc.labelInitialize();
        _ccc.chainInitialize();
        _ccc.UnrotateEventInitialize();
        _ccc.cautionInitialize();
        addStageAt();
    }
}

// 系統樹用表示スレッド
class RequirementsShowThread extends ShowThread
{
    public function RequirementsShowThread(cc:CharaCard, ccc:CharaCardClip, stage:DisplayObjectContainer)
    {
        super(cc,ccc,stage)
    }

    protected override function close():void
    {
        _ccc.baseInitialize();
        _ccc.labelInitialize();
        _ccc.requirementsEventInitialize();
        _ccc.chainInitialize();
        addStageAt();
    }
}

// Showを待つHideスレッド
class RequirementsHideThread extends HideThread
{

    public function RequirementsHideThread(ccc:CharaCardClip)
    {
        super(ccc);
    }

    protected override function run():void
    {
        if((Sprite(_view).parent != null))
        {
            next(exit);
        }
        else
        {
            if(_ccc.finished)
            {
                next(exit);
            }else{
                next(run);
            }
        }
    }
}

// RotateThread
class FlipCardThread extends Thread
{
    private var _ccc:CharaCardClip;
    private var _x:int;
    private var _y:int;
    private var _scaleX:Number;
    private var _scaleY:Number;

    private var _rot:Number;
    private var _flip:Boolean;

    public function FlipCardThread(ccc:CharaCardClip, flip:Boolean)
    {
        _ccc = ccc;
        _flip = flip;
        if (_flip)
        {_rot = 360;}else{_rot = 180};
    }

    protected override function run():void
    {

//                (new TweenerThread (this, { z:-100, transition:"easeOutExpo", time: 0.15} )).start();
//                (new BeTweenAS3Thread(this, {z:-100}, null, 0.15, BeTweenAS3Thread.EASE_OUT_EXPO )).start();
//        var t:Thread = new TweenerThread (_ccc, { rotationY:_rot, transition:"easeOutExpo", time: 0.3} );
        var t:Thread = new BeTweenAS3Thread(_ccc, {rotationY:_rot}, null, 0.3, BeTweenAS3Thread.EASE_OUT_EXPO );
        SE.playCharaCardRotate();
        t.start();
        t.join();
        next(fin)

    }

    private function fin():void
    {
        // 3D変換によるボケをリセットする。
        // もっとスマートな方法があるかもしれないが、いまのところ。
        _x=_ccc.metaFrame.x;
        _y=_ccc.metaFrame.y;
        _scaleX=_ccc.metaFrame.scaleX;
        _scaleY=_ccc.metaFrame.scaleY;
        _ccc.metaFrame.transform.matrix3D = null;
        _ccc.metaFrame.x=_x;
        _ccc.metaFrame.y=_y;
        _ccc.metaFrame.scaleX=_scaleX;
        _ccc.metaFrame.scaleY=_scaleY;

        _ccc.flipReset(_flip);
        _ccc.addMouseClickEvent();
        // 3dから2dに変換して書き戻すだけでいいかとおもいきやそういうわけにはいかず･･･
//         _ccc.metaFrame.transform.matrix = mat3d2Mat(_ccc.metaFrame.transform.matrix3D);

    }

//     private function mat3d2Mat(d:Matrix3D):Matrix
//     {

//         var matrixData:Vector.<Number> = d.rawData;

//         var matrix:Matrix = new Matrix();
//         matrix.a = matrixData[0];
//         matrix.c = matrixData[1];

//         matrix.b = matrixData[4];
//         matrix.d = matrixData[5];
//         matrix.tx = matrixData[12];
//         matrix.ty = matrixData[13];


//         return matrix;
//     }


}

