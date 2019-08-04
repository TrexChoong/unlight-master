package view.scene.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Duel;
    import model.Entrant;
    import model.FoeEntrant;
    import model.events.DamageEvent;

    import view.scene.BaseScene;
    import view.utils.*;
    import view.*;
    import view.image.game.*;
    import controller.*;

    /**
     * HP表示クラス
     *
     */


    public class HP extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DMG1	:String = "あなたに";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DMG2	:String = "のダメージ";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DMG3	:String = "相手に";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DMG4	:String = "のダメージ";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DMG5	:String = "__NAME__さんに";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DMG6	:String = "のダメージ";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_REC1	:String = "あなたのHPが";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_REC2	:String = "回復";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_REC3	:String = "相手のHPが";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_REC4	:String = "回復";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_REC5	:String = "__NAME__さんのHPが";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_REC6	:String = "回復";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CNG1	:String = "あなたのHPが";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CNG2	:String = "相手のHPが";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CNG3	:String = "__NAME__さんのHPが";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CNG4	:String = "に戻った";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_HP	:String = "キャラクターのヒットポイントです。\n０になると死亡します。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DMG1	:String = "You took ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DMG2	:String = " damage";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DMG3	:String = "Your opponent takes ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DMG4	:String = " damage";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DMG5	:String = "__NAME__ took ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DMG6	:String = " damage.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_REC1	:String = "You recover ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_REC2	:String = " HP";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_REC3	:String = "Your opponent recovers ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_REC4	:String = " HP";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_REC5	:String = "__NAME__ recovered ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_REC6	:String = " HP.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CNG1	:String = "You have ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CNG2	:String = "Your opponent has ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CNG3	:String = "__NAME__ has ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CNG4	:String = " HP.";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_HP	:String = "Hit points of the character.\nThe character will be die if this reaches 0.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DMG1	:String = "你受到了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DMG2	:String = "點傷害";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DMG3	:String = "對手受到了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DMG4	:String = "點傷害";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DMG5	:String = "__NAME__受到";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DMG6	:String = "點傷害";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_REC1	:String = "你的HP回復了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_REC2	:String = "點";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_REC3	:String = "對手的HP恢復了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_REC4	:String = "點";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_REC5	:String = "__NAME__HP ";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_REC6	:String = "回復";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CNG1	:String = "你的HP變回到";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CNG2	:String = "對手的HP變回到";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CNG3	:String = "__NAME__的HP變回到";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CNG4	:String = "了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_HP	:String = "角色的生命值。\n變成0時就會死亡。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DMG1	:String = "对您的";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DMG2	:String = "伤害";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DMG3	:String = "对对手的";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DMG4	:String = "伤害";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DMG5	:String = "__NAME__受到";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DMG6	:String = "的伤害";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_REC1	:String = "您的HP恢复了";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_REC2	:String = "点";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_REC3	:String = "对手的HP恢复了";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_REC4	:String = "点";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_REC5	:String = "__NAME__的HP回到";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_REC6	:String = "点";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CNG1	:String = "您的HP回到";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CNG2	:String = "对手的HP回到";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CNG3	:String = "__NAME__的HP回到";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CNG4	:String = "点";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_HP	:String = "角色的体力值。体力值为0时角色死亡。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DMG1	:String = "당신에게 ";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DMG2	:String = "의 데미지";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DMG3	:String = "상대에게 ";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DMG4	:String = "의 데미지";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DMG5	:String = "__NAME__さんに";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DMG6	:String = "のダメージ";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_REC1	:String = "당신의 HP가 ";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_REC2	:String = "회복";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_REC3	:String = "상대의 HP가 ";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_REC4	:String = "회복";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_REC5	:String = "__NAME__さんのHPが";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_REC6	:String = "回復";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CNG1	:String = "あなたのHPが";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CNG2	:String = "相手のHPが";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CNG3	:String = "__NAME__さんのHPが";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CNG4	:String = "に戻った";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_HP	:String = "캐릭터의 히트 포인트  입니다.\n0이 되면 사망합니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DMG1	:String = "Vous subissez ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DMG2	:String = " dégâts.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DMG3	:String = "Vous infligez ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DMG4	:String = " dégâts à votre adversaire.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DMG5	:String = "__NAME__ subit ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DMG6	:String = " dégâts.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_REC1	:String = "";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_REC2	:String = " HP récupérés.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_REC3	:String = "Votre adversaire a récupéré ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_REC4	:String = " HP.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_REC5	:String = "__NAME__ a récupéré ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_REC6	:String = "HP";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CNG1	:String = "Votre HP est à de nouveau de ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CNG2	:String = "L'HP de votre adversaire est à nouveau de ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CNG3	:String = "L'HP de __NAME__ est de nouveau de ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CNG4	:String = ".";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_HP	:String = "HP du Personnage.\nVotre Personnage meurt lorsque son HP atteint 0.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DMG1	:String = "あなたに";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DMG2	:String = "のダメージ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DMG3	:String = "相手に";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DMG4	:String = "のダメージ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DMG5	:String = "__NAME__さんに";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DMG6	:String = "のダメージ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_REC1	:String = "あなたのHPが";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_REC2	:String = "回復";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_REC3	:String = "相手のHPが";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_REC4	:String = "回復";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_REC5	:String = "__NAME__さんのHPが";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_REC6	:String = "回復";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CNG1	:String = "あなたのHPが";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CNG2	:String = "相手のHPが";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CNG3	:String = "__NAME__さんのHPが";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CNG4	:String = "に戻った";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_HP	:String = "キャラクターのヒットポイントです。\n０になると死亡します。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DMG1    :String = "ท่านได้รับบาดเจ็บ";//"あなたに";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DMG2    :String = "แต้ม";//"のダメージ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DMG3    :String = "ฝ่ายตรงข้ามได้รับบาดเจ็บ";//"相手に";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DMG4    :String = "แต้ม";//"のダメージ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DMG5    :String = "คุณ __NAME__";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DMG6    :String = "แต้ม";//"のダメージ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_REC1    :String = "HPของท่านฟื้นคืน";//"あなたのHPが";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_REC2    :String = "แต้ม";//"回復";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_REC3    :String = "HPของฝ่ายตรงข้ามฟื้นคืน";//"相手のHPが";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_REC4    :String = "แต้ม";//"回復";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_REC5    :String = "HP ของคุณ __NAME__";//"__NAME__さんのHPが";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_REC6    :String = "แต้ม";//"回復";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CNG1	:String = "";//"あなたのHPが";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CNG2	:String = "";//"相手のHPが";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CNG3	:String = "";//"__NAME__さんのHPが";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CNG4	:String = "";//"に戻った";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_HP :String = "HP ของตัวละคร หากเป็น 0 จะเท่ากับเสียชีวิต";//"キャラクターのヒットポイントです。\n０になると死亡します。";


        private static const LIFE_WIDTH:int = 24;
        private static const LIFE_HEIGHT:int = 0;
        private static const PL_X:int = 186;
        private static const PL_Y:int = 423;
        private static const FE_X:int = 605;
        private static const FE_Y:int = 75;

        private var _bg:HPImage = new HPImage();
        // private var _text:HPText = new HPText();
        private var _plHPGauge:HPGauge = new HPGauge();
        private var _foeHPGauge:HPGauge = new HPGauge(true);
        private var _plHPPoint:HPPoint = new HPPoint();
        private var _foeHPPoint:HPPoint = new HPPoint(true);

        private var _plEntrant:Entrant;
        private var _foeEntrant:FoeEntrant;

        private var _plHP:int;
        private var _foeHP:int;

        // プレイヤー名 (主に観戦で使用)
        private var _plName:String = "";
        private var _foeName:String = "";

        private var _duel:Duel = Duel.instance;

        // ゲームのコントローラ

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["キャラクターのヒットポイントです。\n０になると死亡します。"],   // 0
                [_TRANS_HELP_HP],   // 0
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function HP()
        {
           super();
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  // プレイヤーのライフ
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


//        // 初期化
        public override function init():void
        {
            addChild(_bg);
            addChild(_foeHPGauge);
            addChild(_plHPGauge);
            //addChild(_text);

            addChild(_foeHPPoint);
            addChild(_plHPPoint);

            _plEntrant = Duel.instance.plEntrant;
            _foeEntrant = Duel.instance.foeEntrant;

            _plHP = _plEntrant.hitPoint;
            _foeHP =_foeEntrant.hitPoint;

            _plEntrant.addEventListener(DamageEvent.HEAL, playerHPUpHandler,false, 100)
            _foeEntrant.addEventListener(DamageEvent.HEAL, foeHPUpHandler,false, 100)
            _plEntrant.addEventListener(DamageEvent.DAMAGE, playerHPDownHandler,false, 100)
            _foeEntrant.addEventListener(DamageEvent.DAMAGE, foeHPDownHandler,false, 100)
            _plEntrant.addEventListener(DamageEvent.CHANGE, playerHPChangeHandler,false, 100)
            _foeEntrant.addEventListener(DamageEvent.CHANGE, foeHPChangeHandler,false, 100)
            _plEntrant.addEventListener(Entrant.CHANGE_DONE, plCharaCardChangeHandler);
            _foeEntrant.addEventListener(Entrant.CHANGE_DONE, foeCharaCardChangeHandler);
            log.writeLog(log.LV_FATAL, this, "+++ hp gauge event listen stage", _plEntrant.uid, _foeEntrant.uid);

            _plHP = _plEntrant.hitPoint;
            _plHPGauge.visible = false;
            _plHPGauge.setHP(_plEntrant.hitPoint, _duel.playerCharaCard.hp);
            _plHPPoint.visible = false;
            _plHPPoint.setHP(_plEntrant.hitPoint, _duel.playerCharaCard.hp);

            _plHPPoint.parent

            _foeHP = _foeEntrant.hitPoint;
            _foeHPGauge.visible = false;
            _foeHPGauge.setHP(_foeEntrant.hitPoint, _duel.foeCharaCard.hp);
            _foeHPPoint.visible = false;
            _foeHPPoint.setHP(_foeEntrant.hitPoint, _duel.foeCharaCard.hp);

            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);
            log.writeLog(log.LV_FATAL, this, "hp", _plHPPoint, _plHPPoint.parent, _plHPPoint.x, _plHPPoint.y,_plHPPoint.visible,_plHPPoint.alpha);

            //_plName = _foeName = "";
        }

        public override function final():void
        {
            _plEntrant.removeEventListener(DamageEvent.HEAL, playerHPUpHandler)
            _foeEntrant.removeEventListener(DamageEvent.HEAL, foeHPUpHandler)
            _plEntrant.removeEventListener(DamageEvent.DAMAGE, playerHPDownHandler)
            _foeEntrant.removeEventListener(DamageEvent.DAMAGE, foeHPDownHandler)
            _plEntrant.removeEventListener(DamageEvent.CHANGE, playerHPChangeHandler)
            _foeEntrant.removeEventListener(DamageEvent.CHANGE, foeHPChangeHandler)
            _plEntrant.removeEventListener(Entrant.CHANGE_DONE, plCharaCardChangeHandler);
            _foeEntrant.removeEventListener(Entrant.CHANGE_DONE, foeCharaCardChangeHandler);


//             _foeLifeArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     removeChild(item);
//                 });
//             _foeLifeArray = [];
//             _foeDeadArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     removeChild(item);
//                 });
//             _foeDeadArray = [];
//             _playerLifeArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     removeChild(item);
//                 });
//             _playerLifeArray = [];
//             _playerDeadArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     removeChild(item);
//                 });
//             _playerDeadArray = [];
            RemoveChild.apply(this);
            RemoveChild.apply(_bg);
                //RemoveChild.apply(_text)
        }

//         private function lifeCreate(hp:int, a:Array):void
//         {
//             for (var i:Number = 0; i < hp; i++) {
//                 a.push(new HPCrystal());
//             }
//         }

//         private function deadCreate(hp:int, a:Array):void
//         {
//             for (var i:Number = 0; i < hp; i++) {
//                 a.push(new HPCrystal());
//                 callLater(a[i].clash);
//             }
//         }

        private function plCharaCardChangeHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "plHp & maxHp 1");

//             _playerLifeArray.forEach(function (item:*, index:int, array:Array):void{removeChild(item);});
//             _playerLifeArray = [];
//             _playerDeadArray.forEach(function (item:*, index:int, array:Array):void{removeChild(item);});
//             _playerDeadArray = [];
            plCharaCardChange();
        }

        private function plCharaCardChange():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var maxHp:int = _duel.playerCharaCard.hp;
            var insert:int;
            _plHP = _plEntrant.hitPoint;

            _plHPGauge.visible = false;
            _plHPGauge.setHP(_plHP, maxHp);

            _plHPPoint.visible = false;
            _plHPPoint.setHP(_plHP, maxHp);


//             lifeCreate(_plHP, _playerLifeArray);
//             deadCreate(maxHp-_plHP, _playerDeadArray);
//            insert = _playerDeadArray.length-1;

//             // ヒットポイントを並べ直して表示
//             for(var i:int = 0; i < maxHp; i++)
//             {
//                 // 残存HPの分を並べる
//                 if(_playerLifeArray.length > i)
//                 {
//                     _playerLifeArray[i].x = PL_X+LIFE_WIDTH*i;
//                     _playerLifeArray[i].y = PL_Y;
//                     _playerLifeArray[i].alpha = 0.0;
//                     _playerLifeArray[i].visible = false;
//                     addChild(_playerLifeArray[i]);
//                     sExec.addThread(new BeTweenAS3Thread(_playerLifeArray[i], {alpha:1.0}, null, 0.01, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
//                 }
//                 else
//                 // ダメージHPの分を並べる
//                 {
// //                     insert = i - _playerLifeArray.length;
//                     log.writeLog(log.LV_INFO, this, "pldeadarray insert", insert);
//                     _playerDeadArray[insert].x = PL_X+LIFE_WIDTH*i;
//                     _playerDeadArray[insert].y = PL_Y;
//                     _playerDeadArray[insert].alpha = 0.0;
//                     _playerDeadArray[insert].visible = false;
//                     addChild(_playerDeadArray[insert]);
//                     sExec.addThread(new BeTweenAS3Thread(_playerDeadArray[insert], {alpha:1.0}, null, 0.01, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
//                     insert -= 1;
//                 }
//             }
            GameCtrl.instance.addViewSequence(_plHPGauge.getUpdateHPThread(_plHP));
            GameCtrl.instance.addViewSequence(_plHPPoint.getUpdateHPThread(_plHP));
        }

        private function foeCharaCardChangeHandler(e:Event):void
        {
//             _foeLifeArray.forEach(function (item:*, index:int, array:Array):void{removeChild(item);});
//             _foeLifeArray = [];
//             _foeDeadArray.forEach(function (item:*, index:int, array:Array):void{removeChild(item);});
//             _foeDeadArray = [];
            new EntrantLoadWaitThread(_foeEntrant, foeCharaCardChange).start();
//            foeCharaCardChange();
        }

        private function foeCharaCardChange():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var maxHp:int = _duel.foeCharaCard.hp;
            var insert:int;

            _foeHP = _foeEntrant.hitPoint
//             lifeCreate(_foeHP, _foeLifeArray);
//             deadCreate(maxHp-_foeHP, _foeDeadArray);
//            insert = _foeDeadArray.length-1;

            _foeHPGauge.visible = false;
            _foeHPGauge.setHP(_foeHP, maxHp)
            _foeHPPoint.visible = false;
            _foeHPPoint.setHP(_foeHP, maxHp)


            log.writeLog(log.LV_INFO, this, "foe hp recreate", _foeHP, maxHp);

//             // ヒットポイントを並べ直して表示
//             for(var i:int = 0; i < maxHp; i++)
//             {
//                 // 残存HPの分を並べる
//                 if(_foeLifeArray.length > i)
//                 {
//                     _foeLifeArray[i].x = FE_X-LIFE_WIDTH*i;
//                     _foeLifeArray[i].y = FE_Y;
//                     _foeLifeArray[i].alpha = 0.0;
//                     _foeLifeArray[i].visible = false;
//                     addChild(_foeLifeArray[i]);
//                     sExec.addThread(new BeTweenAS3Thread(_foeLifeArray[i], {alpha:1.0}, null, 0.01, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
//                 }
//                 else
//                 // ダメージHPの分を並べる
//                 {
// //                    insert = (_foeDeadArray.length-1) - (_foeLifeArray.length-i);
// //                    insert = i - _playerLifeArray.length;
//                     log.writeLog(log.LV_INFO, this, "foe hp insert", insert);
//                     _foeDeadArray[insert].x = FE_X-LIFE_WIDTH*i;
//                     _foeDeadArray[insert].y = FE_Y;
//                     _foeDeadArray[insert].alpha = 0.0;
//                     _foeDeadArray[insert].visible = false;
//                     addChild(_foeDeadArray[insert]);
//                     sExec.addThread(new BeTweenAS3Thread(_foeDeadArray[insert], {alpha:1.0}, null, 0.01, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
//                     insert -= 1;

//                 }
//             }
            GameCtrl.instance.addViewSequence(_foeHPGauge.getUpdateHPThread(_foeHP));
            GameCtrl.instance.addViewSequence(_foeHPPoint.getUpdateHPThread(_foeHP));

        }

        // プレイヤーＨＰが減る場合のハンドラ
        public function playerHPDownHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(playerHPDown))
        }

        // エネミーＨＰが経る場合のハンドラ
        public function foeHPDownHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(foeHPDown))
        }

        // プレイヤーＨＰがふえる場合のハンドラ
        public function playerHPUpHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(playerHPUp))
        }

        // エネミーＨＰが経る場合のハンドラ
        public function foeHPUpHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(foeHPUp))
        }

        // プレイヤーＨＰが変更される場合のハンドラ
        public function playerHPChangeHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(playerHPChange))
        }

        // エネミーＨＰが変更される場合のハンドラ
        public function foeHPChangeHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(foeHPChange))
        }

        public function playerHPDown():void
        {
            var h:int = _plHP-_plEntrant.hitPoint;
            log.writeLog(log.LV_FATAL, this, "+++ player hp down", h);
            if (h>0)
            {
//                GameCtrl.instance.addViewSequence(hpDown(_playerLifeArray, _playerDeadArray, h));
//                GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage("あなたに"+h+"のダメージ")}));
                var msg1:String = (!_duel.isWatch) ? _TRANS_MSG_DMG1 : _TRANS_MSG_DMG5.replace("__NAME__", _plName);
                GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage(msg1+h+_TRANS_MSG_DMG2)}));
                // GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage(_TRANS_MSG_DMG1+h+_TRANS_MSG_DMG2)}));
                GameCtrl.instance.addViewSequence(_plHPGauge.getUpdateHPThread(_plEntrant.hitPoint));
                GameCtrl.instance.addViewSequence(_plHPPoint.getUpdateHPThread(_plEntrant.hitPoint));
                _plHP = _plEntrant.hitPoint;
                GameCtrl.instance.addViewSequence(new SleepThread(1000));
            }
        }

        public function foeHPDown():void
        {
            var h:int = _foeHP-_foeEntrant.hitPoint;
            log.writeLog(log.LV_FATAL, this, "+++ foe hp down", h);
            if (h>0)
            {
//                GameCtrl.instance.addViewSequence(hpDown(_foeLifeArray, _foeDeadArray, h));
//                GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage("相手に"+h+"のダメージ")}));
                var msg1:String = (!_duel.isWatch) ? _TRANS_MSG_DMG3 : _TRANS_MSG_DMG5.replace("__NAME__", _foeName);
                GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage(msg1+h+_TRANS_MSG_DMG4)}));
                // GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage(_TRANS_MSG_DMG3+h+_TRANS_MSG_DMG4)}));
                GameCtrl.instance.addViewSequence(_foeHPGauge.getUpdateHPThread(_foeEntrant.hitPoint));
                GameCtrl.instance.addViewSequence(_foeHPPoint.getUpdateHPThread(_foeEntrant.hitPoint));
                _foeHP = _foeEntrant.hitPoint;
                GameCtrl.instance.addViewSequence(new SleepThread(1000));
            }
        }

//         private function hpDown(lifeArray:Array, deadArray:Array, down:int):Thread
//         {
//             var pExec:ParallelExecutor = new ParallelExecutor();

//             var life:HPCrystal;
//             for (var i:Number = 0; i < down; i++)
//             {
//                 life = lifeArray.pop();
//                 deadArray.push(life);
//                 if (life)
//                 {
//                     pExec.addThread(new ClousureThread(life.clash));
//                 }
//             }
//             return pExec;
//         }

        public function playerHPUp():void
        {
            var h:int = _plEntrant.hitPoint - _plHP;
            if (h>0)
            {
//                GameCtrl.instance.addViewSequence(hpUp(_playerLifeArray, _playerDeadArray, h));
//                GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage("あなたのHPが"+h+"回復")}));
                var msg1:String = (!_duel.isWatch) ? _TRANS_MSG_REC1 : _TRANS_MSG_REC5.replace("__NAME__", _plName);
                GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage(msg1+h+_TRANS_MSG_REC2)}));
                // GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage(_TRANS_MSG_REC1+h+_TRANS_MSG_REC2)}));
                GameCtrl.instance.addViewSequence(_plHPGauge.getUpdateHPThread(_plEntrant.hitPoint));
                GameCtrl.instance.addViewSequence(_plHPPoint.getUpdateHPThread(_plEntrant.hitPoint));
                _plHP = _plEntrant.hitPoint;
            }
        }

        public function foeHPUp():void
        {
            var h:int = _foeEntrant.hitPoint-_foeHP;
            if (h>0)
            {
//                GameCtrl.instance.addViewSequence(hpUp(_foeLifeArray, _foeDeadArray, h));
//                GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage("相手のHPが"+h+"回復")}));
                var msg1:String = (!_duel.isWatch) ? _TRANS_MSG_REC3 : _TRANS_MSG_REC5.replace("__NAME__", _foeName);
                GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage(msg1+h+_TRANS_MSG_REC4)}));
                // GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage(_TRANS_MSG_REC3+h+_TRANS_MSG_REC4)}));
                GameCtrl.instance.addViewSequence(_foeHPGauge.getUpdateHPThread(_foeEntrant.hitPoint));
                GameCtrl.instance.addViewSequence(_foeHPPoint.getUpdateHPThread(_foeEntrant.hitPoint));
                _foeHP = _foeEntrant.hitPoint;
            }
        }

        public function playerHPChange():void
        {
            var h:int = _plEntrant.hitPoint;

            log.writeLog(log.LV_FATAL, this, "+++ player hp change", h);
            if (h > 0)
            {
                var msg1:String = (!_duel.isWatch) ? _TRANS_MSG_CNG1 : _TRANS_MSG_CNG3.replace("__NAME__", _plName);
                GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage(msg1+h+_TRANS_MSG_CNG4)}));
                GameCtrl.instance.addViewSequence(_plHPGauge.getUpdateHPThread(h));
                GameCtrl.instance.addViewSequence(_plHPPoint.getUpdateHPThread(h));
                _plHP = h;
                GameCtrl.instance.addViewSequence(new SleepThread(1000));
            }
        }

        public function foeHPChange():void
        {
            var h:int = _foeEntrant.hitPoint;

            log.writeLog(log.LV_FATAL, this, "+++ foe hp change", h);
            if (h > 0)
            {
                var msg1:String = (!_duel.isWatch) ? _TRANS_MSG_CNG2 : _TRANS_MSG_CNG3.replace("__NAME__", _foeName);
                GameCtrl.instance.addViewSequence(new ClousureThread(function():void{GameCtrl.instance.setMessage(msg1+h+_TRANS_MSG_CNG4)}));
                GameCtrl.instance.addViewSequence(_foeHPGauge.getUpdateHPThread(h));
                GameCtrl.instance.addViewSequence(_foeHPPoint.getUpdateHPThread(h));
                _foeHP = h;
                GameCtrl.instance.addViewSequence(new SleepThread(1000));
            }
        }

//         private function hpUp(lifeArray:Array, deadArray:Array, up:int):Thread
//         {
//             var sExec:SerialExecutor = new SerialExecutor()

//             var life:HPCrystal;
//             for (var i:Number = 0; i < up; i++)
//             {
//                 life = deadArray.pop();
//                 lifeArray.push(life);
//                 if (life)
//                 {
//                     sExec.addThread(new ClousureThread(life.recover))
//                     sExec.addThread(new SleepThread(100))
//                 }
//             }
//             return sExec;
//         }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var sExec2:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_bg,{alpha:1.0}, {alpha:0.0}, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            //pExec.addThread(new BeTweenAS3Thread(_text,{alpha:1.0}, {alpha:0.0}, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            pExec.addThread(new BeTweenAS3Thread(_plHPGauge,{alpha:1.0}, null, 0.1, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            pExec.addThread(new BeTweenAS3Thread(_foeHPGauge,{alpha:1.0}, null, 0.1, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));

            pExec.addThread(new BeTweenAS3Thread(_plHPPoint,{alpha:1.0}, null, 0.1, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            pExec.addThread(new BeTweenAS3Thread(_foeHPPoint,{alpha:1.0}, null, 0.1, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));

            pExec.addThread(new ClousureThread(_plHPGauge.startAnime));
            pExec.addThread(new ClousureThread(_foeHPGauge.startAnime));

//             _playerLifeArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     item.alpha = 0.0;
//                     sExec.addThread(new BeTweenAS3Thread(item, {alpha:1.0}, null, 0.01, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
//                 });
//             _playerDeadArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     item.alpha = 0.0;
//                     sExec.addThread(new BeTweenAS3Thread(item, {alpha:1.0}, null, 0.01, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
//                 });

//             pExec.addThread(sExec);

//             _foeLifeArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     item.alpha = 0.0;
//                     sExec2.addThread(new BeTweenAS3Thread(item, {alpha:1.0}, null, 0.01, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
//                 });
//             _foeDeadArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     item.alpha = 0.0;
//                     sExec2.addThread(new BeTweenAS3Thread(item, {alpha:1.0}, null, 0.01, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
//                 });


//             pExec.addThread(sExec2);

            return pExec;
        }

        // 実画面から消すスレッドを返す
        public function getBringOffThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_plHPGauge,{alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            pExec.addThread(new BeTweenAS3Thread(_foeHPGauge,{alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            pExec.addThread(new BeTweenAS3Thread(_plHPPoint,{alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            pExec.addThread(new BeTweenAS3Thread(_foeHPPoint,{alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            pExec.addThread(new BeTweenAS3Thread(_bg,{alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            //pExec.addThread(new BeTweenAS3Thread(_text,{alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));

//             _playerLifeArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
//                 });
//             _foeLifeArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
//                 });
//             _playerDeadArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
//                 });
//             _foeDeadArray.forEach(
//                 function (item:*, index:int, array:Array):void
//                 {
//                     pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
//                 });

            return pExec;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }

        // 消去のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new HideThread(this));
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new ClousureThread(function():void{_plHPGauge.alpha = 0.0}));
            pExec.addThread(new ClousureThread(function():void{_foeHPGauge.alpha = 0.0}));
            pExec.addThread(new ClousureThread(function():void{_plHPPoint.alpha = 0.0}));
            pExec.addThread(new ClousureThread(function():void{_foeHPGauge.alpha = 0.0}));
            pExec.addThread(new ClousureThread(function():void{_bg.alpha = 0.0}));
            //pExec.addThread(new ClousureThread(function():void{_text.alpha = 0.0}));
            sExec.addThread(pExec);
            return sExec;
//            return new HideThread(this);
        }

        public function setName(plName:String,foeName:String):void
        {
            _plName  = plName;
            _foeName = foeName;
        }

        public function get getPlHp():int
        {
            return _plHP;
        }

        public function  get getFoeHp():int
        {
            return _foeHP;
        }
    }

}

// Duelのロードを待つShowスレッド

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.*;
import view.scene.game.HP;
import view.BaseShowThread;
import view.BaseHideThread;

class ShowThread extends BaseShowThread
{

    public function ShowThread(hp:HP, stage:DisplayObjectContainer, at:int)
    {
        super(hp, stage)
    }

    protected override function run():void
    {
        // ロードを待つ
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
    public function HideThread(hp:HP)
    {
        super(hp);
    }
}


// キャラカードのロードをまってHPを読み込むスレッド
class EntrantLoadWaitThread extends Thread
{
    private var _fe:FoeEntrant;
    private var _func:Function;

    public function EntrantLoadWaitThread (fe:FoeEntrant, func:Function)
    {
        _fe = fe;
        _func =func;
    }

    protected override function run():void
    {
        // キャラカードの準備を待つ
        if (_fe.loadingCC == false)
        {
            _fe.wait();
        }
        next(init);
    }

    private function init():void
    {
        log.writeLog(log.LV_INFO, this, "hp update");
       _func();
    }
}
