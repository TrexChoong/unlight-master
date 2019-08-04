/**
 * TODO:フラグチェックをModelに委譲すべし
 *
 *
 */
package view.scene.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.ActionCard;
    import model.Duel;
    import model.Entrant;
    import model.CharaCard;
    import model.events.CharaChangeEvent;
    import model.events.CharaTransformEvent;
    import model.events.ChangeCharaCardEvent;
    import model.events.FieldStatusEvent;
    import model.events.ConstraintEvent;

    import view.scene.BaseScene;
    import view.ClousureThread;
    import view.scene.game.PlayerHand;
    import view.image.game.*;
    import view.utils.*;

    import controller.*;

    /**
     * ドロップテーブル 表示クラス
     *
     */

    public class DropTable extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG0	:String = "アクションカードをドロップする場所です。\nカードの組み合わせで行動します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1OLD	:String = "自分が戦闘に使用するダイスです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2OLD	:String = "対戦相手が戦闘に使用するダイスです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1	:String = "自分が戦闘に使用するダイスを合計した数値です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "対戦相手が戦闘に使用するダイスを合計した数値です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG3	:String = "カードを決定します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG4	:String = "その場で待機します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG5	:String = "１マス前進します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG6	:String = "１マス後退します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG7	:String = "キャラを変更します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG8OLD	:String = "移動カードをドロップしてください";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG9OLD	:String = "イニシアチブ決定";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG10OLD	:String = "バトル決定";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG0	:String = "This is where action cards are dropped.\nYou will move according to the combination of cards which accumulate here.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1OLD	:String = "Your battle dice.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2OLD	:String = "Your opponent's battle dice.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1	:String = "The total number of your battle dice.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = "The total number of dice your opponent's battle dice.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG3	:String = "Confirm card/action selection.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG4	:String = "Remain where you are.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG5	:String = "Take 1 step forward.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG6	:String = "Take 1 step back.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG7	:String = "Switch characters.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG8OLD	:String = "Please drop movement cards.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG9OLD	:String = "Decide initiative";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG10OLD	:String = "Decide battle";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG0	:String = "出行動卡的地方。\n依照卡片的組合來行動。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1OLD	:String = "自己在戰鬥時使用的骰子。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2OLD	:String = "對手在戰鬥時使用的骰子。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1	:String = "自己在戰鬥時使用的骰子的合計值。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "對手在戰鬥時使用的骰子的合計值。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG3	:String = "決定卡片。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG4	:String = "原地待機。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG5	:String = "前進一格";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG6	:String = "後退一格";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG7	:String = "更換角色。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG8OLD	:String = "請出移動卡。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG9OLD	:String = "決定主動權";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG10OLD	:String = "決定戰鬥";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG0	:String = "出具行动卡的地方。\n根据卡片组合来采取行动。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1OLD	:String = "自己在战斗中使用的骰子。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2OLD	:String = "对手在战斗中使用的骰子。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1	:String = "自己在战斗中使用的骰子的合计值。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "对手在战斗中使用的骰子的合计值。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG3	:String = "决定卡片。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG4	:String = "原地待命。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG5	:String = "前进1步";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG6	:String = "后退1步";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG7	:String = "更换角色。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG8OLD	:String = "请出移动卡。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG9OLD	:String = "决定先攻权。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG10OLD	:String = "决定战斗。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG0	:String = "액션 카드를 드롭하는 장소입니다.\n카드의조합으로 행동을 합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1OLD	:String = "자신이 전투에 사용하는 주사위입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2OLD	:String = "대전 상대가 전투에 사용하는 주사위입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1	:String = "자신이 전투에 사용하는 주사위를 합산한 수치 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "대전 상대가 전투에 사용하는 주사위를 합산한 수치입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG3	:String = "카드를 결정합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG4	:String = "그 장소에서 대기 합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG5	:String = "1마스 전진합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG6	:String = "1마스 후퇴합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG7	:String = "캐릭을 변경합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG8OLD	:String = "이동 카드를 드롭하여 주십시오.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG9OLD	:String = "이니시아칩 결정";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG10OLD	:String = "배틀 결정";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG0	:String = "C'est ici que vous devez poser vos cartes d'action.\nVos actions seront déterminées par les combinaisons que vous allez réaliser ici.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1OLD	:String = "Voici vos dés de Duel";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2OLD	:String = "Votre adversaire lance les dés";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1	:String = "Total de vos dés";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = "Total des dés de votre adversaire";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG3	:String = "Sélectionnez une Carte";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG4	:String = "Attendez";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG5	:String = "Avancez d'un pas";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG6	:String = "Reculez d'un pas";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG7	:String = "Changez de personnage";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG8OLD	:String = "Poser la carte de déplacement ici";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG9OLD	:String = "Vous avez l'Initiative";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG10OLD	:String = "Choisissez un Duel";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG0	:String = "アクションカードをドロップする場所です。\nカードの組み合わせで行動します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1OLD	:String = "自分が戦闘に使用するダイスです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2OLD	:String = "対戦相手が戦闘に使用するダイスです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1	:String = "自分が戦闘に使用するダイスを合計した数値です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "対戦相手が戦闘に使用するダイスを合計した数値です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG3	:String = "カードを決定します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG4	:String = "その場で待機します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG5	:String = "１マス前進します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG6	:String = "１マス後退します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG7	:String = "キャラを変更します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG8OLD	:String = "移動カードをドロップしてください";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG9OLD	:String = "イニシアチブ決定";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG10OLD	:String = "バトル決定";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG0    :String = "ที่สำหรับใส่แอคชั่นการ์ด\nแอคชั่นการ์ดจะทำงานร่วมกับการ์ดอื่น ๆ";//"アクションカードをドロップする場所です。\nカードの組み合わせで行動します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1OLD :String = "ลูกเต๋าที่ใช้ในการต่อสู้";//"自分が戦闘に使用するダイスです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2OLD :String = "ลูกเต๋าที่ฝ่ายตรงข้ามใช้ในการต่อสู้";//"対戦相手が戦闘に使用するダイスです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1    :String = "ตัวเลขที่คำนวณได้จากการทอยลูกเต๋าเพื่อใช้ในการต่อสู้";//"自分が戦闘に使用するダイスを合計した数値です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "ตัวเลขที่คำนวณได้จากการทอยลูกเต๋าที่ฝ่ายตรงข้ามจะใช้ในการต่อสู้";//"対戦相手が戦闘に使用するダイスを合計した数値です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG3    :String = "กำหนดการ์ดที่ใช้";//"カードを決定します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG4    :String = "รอ";//"その場で待機します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG5    :String = "เดินหน้า 1 ช่อง";//"１マス前進します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG6    :String = "ถอยหลัง 1 ช่อง";//"１マス後退します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG7    :String = "สลับตัวละคร";//"キャラを変更します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG8OLD :String = "กรุณาทิ้งการ์ดเคลื่อนที่";//"移動カードをドロップしてください";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG9OLD :String = "กำหนดผู้เริ่มโจมตีก่อนได้แล้ว";//"イニシアチブ決定";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG10OLD    :String = "กำหนดการต่อสู้แล้ว";//"バトル決定";


        // OKボタン 表示元SWF
        private var _fwdButton:MoveButton = new MoveButton(MoveButton.FRONT);
        private var _bkwButton:MoveButton = new MoveButton(MoveButton.BACK);
        private var _styButton:MoveButton = new MoveButton(MoveButton.STAY);
        private var _changeButton:MoveButton = new MoveButton(MoveButton.CHANGE);

        private static const LABEL_X:int = 428;
        private static const LABEL_Y:int = 353;

        private static const A:Number = 0.3;

        private static const X:int = 0;
        private static const Y:int = 0;
        private static const W:int = 1024;
        private static const H:int = 616;
        private var _dropArea:Rectangle = new Rectangle(X, Y, W, H);

        private static const _PL_CARD_X:int = 380;
        private static const _PL_CARD_Y:int = 389;
        private static const _FE_CARD_X:int = 378;
        private static const _FE_CARD_Y:int = 127;
        public static const PL_CARD_PT:Point = new Point(_PL_CARD_X, _PL_CARD_Y)
        public static const FE_CARD_PT:Point = new Point(_FE_CARD_X, _FE_CARD_Y)

        private static const PL_POINT_X:int =219;
        //private static const PL_POINT_Y:int =266;
        private static const PL_POINT_Y:int =263;
        private static const FOE_POINT_X:int =543;
        private static const FOE_POINT_Y:int =PL_POINT_Y;

//         private static const PL_DICE_X:int =440;
//         private static const PL_DICE_Y:int =379;
//         private static const FOE_DICE_X:int = 440;
//         private static const FOE_DICE_Y:int =313;

        private static const CARD_HEIGHT:int = 45;

        private const _BUTTON_WH:int = 30;               // ボタンの大きさ(仮)
        private const _BUTTON_X:int = 425;                  // ボタン位置基本Y
        //private const _BUTTON_Y:int = 404;                  // ボタン位置基本Y
        private const _BUTTON_Y:int = 401;                  // ボタン位置基本Y
        private const _BUTTON_OFFSET_X:int = 45;            // ボタン位置Yのずれ


//         private var _plDiceState:int;
//         private var _foeDiceState:int;
//        private var _beforeState:int = DropTableDice.DEF;

        private var _label:Label = new Label();
        private var _plPoints:Array = [new DropTableNum(PL_POINT_X),new DropTableNum(PL_POINT_X),
                                       new DropTableNum(PL_POINT_X),new DropTableNum(PL_POINT_X)]; /* of DropTableNum */
        private var _foePoints:Array = [new DropTableNum(FOE_POINT_X,true),new DropTableNum(FOE_POINT_X,true),
                                        new DropTableNum(FOE_POINT_X,true),new DropTableNum(FOE_POINT_X,true)]; /* of DropTableNum */
        private static var __plCharaFaceSet:Dictionary = new Dictionary(true);
        private static var __foeCharaFaceSet:Dictionary = new Dictionary(true);
        private var _plCharaFace:StandCharaFace;
        private var _foeCharaFace:StandCharaFace;


//         private var _plDices:Array = []; /* of DropTableDice */
//         private var _foeDices:Array = []; /* of DropTableDice */

        private var _plPointContainer:UIComponent = new UIComponent(); // プレイヤーのポイントを格納するコンテナ
        private var _foePointContainer:UIComponent = new UIComponent(); // 敵ポイントを格納するコンテナ

//         private var _plDiceContainer:UIComponent = new UIComponent(); // プレイヤーのポイントを格納するコンテナ
//         private var _foeDiceContainer:UIComponent = new UIComponent(); // 敵ポイントの

//        private var _movePiece:DropTableMovePiece = new DropTableMovePiece();

        private var _BG:DropTableClip = new DropTableClip();
        private var _doneButton:DoneButton = new DoneButton();


        private var _accArray:Array = [];   // アクションカードの配列

        private var _totalPoint:int = 0;

        private var _plEntrant:Entrant;
        private var _foeEntrant:Entrant;
        private var _addCardFunc:Function;
        private var _removeCardFunc:Function;

        private var _waiting:Boolean;

        private var _duel:Duel = Duel.instance;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["アクションカードをドロップする場所です。\nカードの組み合わせで行動します。",
////                  "自分が戦闘に使用するダイスです。",
////                  "対戦相手が戦闘に使用するダイスです。",
//                 "自分が戦闘に使用するダイスを合計した数値です。",
//                 "対戦相手が戦闘に使用するダイスを合計した数値です。",
//                 "カードを決定します。",
//                 "その場で待機します。",
//                 "１マス前進します。",
//                 "１マス後退します。",
//                 "キャラを変更します。",]
                [_TRANS_MSG0,
//                  _TRANS_MSG1OLD,
//                  _TRANS_MSG2OLD,
                 _TRANS_MSG1,
                 _TRANS_MSG2,
                 _TRANS_MSG3,
                 _TRANS_MSG4,
                 _TRANS_MSG5,
                 _TRANS_MSG6,
                 _TRANS_MSG7,]
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function DropTable()
        {

            visible = false;
            alpha = 0.0;


            _label.width = 300;
            _label.height = 40;
            _label.x = LABEL_X;
            _label.y = LABEL_Y;
            _label.text = "";
            _label.styleName = "DropTableLabel";


            addChild(_BG);
            addChild(_label);
            addChild(_doneButton);

//             _plPoints.forEach(function(item:*, index:int, array:Array):void{_plPointContainer.addChild(item)});
//             _foePoints.forEach(function(item:*, index:int, array:Array):void{_foePointContainer.addChild(item)});

            _plPointContainer.y = PL_POINT_Y;
            _foePointContainer.y = FOE_POINT_Y ;

            addChild(_plPointContainer);
            addChild(_foePointContainer);

            addChild(_fwdButton);
            addChild(_bkwButton);
            addChild(_styButton);
            addChild(_changeButton);

//             initButton();
//             _doneButton.buttonEnabled = false;
        }

        private function currentFace(player:Boolean = false, ex:Boolean = false):StandCharaFace
        {
            var face:StandCharaFace;
            var dic:Dictionary;
            var cc:CharaCard;
            var c_key:String;
            if (player)
            {
                dic = __plCharaFaceSet;
                cc = _duel.playerCharaCard;
            }else{
                dic = __foeCharaFaceSet;
                cc = _duel.foeCharaCard;
            }

            if (ex)
            {
                c_key = String(cc.id) + "ch";
            }
            else
            {
                c_key = String(cc.id);
            }

            if (dic[c_key] == null)
            {
                face = new StandCharaFace(player, cc, ex);
                dic[c_key] = face;
            }else{
                face = dic[c_key];
            }
            GameCtrl.instance.addViewSequence(face.getShowThread(this));
            return face;
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,_BG]);
//             _toolTipOwnerArray.push([1,_plDiceContainer]);
//             _toolTipOwnerArray.psh([2,_foeDiceContainer]);
            _toolTipOwnerArray.push([1,_plPointContainer]);
            _toolTipOwnerArray.push([2,_foePointContainer]);
            _toolTipOwnerArray.push([3,_doneButton]);
            _toolTipOwnerArray.push([4,_styButton]);
            _toolTipOwnerArray.push([5,_fwdButton]);
            _toolTipOwnerArray.push([6,_bkwButton]);
            _toolTipOwnerArray.push([7,_changeButton]);
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

        // 初期化時に呼ばれる
        public override function init():void
        {

            _plEntrant = _duel.plEntrant;
            _foeEntrant = _duel.foeEntrant;
            _plCharaFace = currentFace(true);
            _foeCharaFace = currentFace(false);


            addChild(_BG);
            addChild(_label);
            addChild(_doneButton);

            _plPoints.forEach(function(item:*, index:int, array:Array):void{_plPointContainer.addChild(item)});
            _foePoints.forEach(function(item:*, index:int, array:Array):void{_foePointContainer.addChild(item)});


            addChild(_plPointContainer);
            addChild(_foePointContainer);

            addChild(_fwdButton);
            addChild(_bkwButton);
            addChild(_styButton);
            addChild(_changeButton);

            initButton();
            _doneButton.visible = !_duel.isWatch;
            _doneButton.buttonEnabled = false;

            _plEntrant.addEventListener(Entrant.POINT_UPDATE, plPointUpdateHandler);
            _foeEntrant.addEventListener(Entrant.POINT_UPDATE, foePointUpdateHandler);

            _plEntrant.addEventListener(CharaChangeEvent.SUCCESS, plCharaChangeHandler);
            _foeEntrant.addEventListener(CharaChangeEvent.SUCCESS, foeCharaChangeHandler);

            _plEntrant.addEventListener(Entrant.ATTACK_DONE_SUCCES, plDoneSuccessHandler);
            _plEntrant.addEventListener(Entrant.DEFFENCE_DONE_SUCCES, plDoneSuccessHandler);
            _plEntrant.addEventListener(Entrant.INIT_DONE_SUCCES, plDoneSuccessHandler);
            _plEntrant.addEventListener(Entrant.DIRECTION_UPDATE_SUCCESS, updateDirectionHandler);

            _plEntrant.addEventListener(ConstraintEvent.CONSTRAINT, plConstraintHandler);

            _fwdButton.addEventListener(MouseEvent.CLICK, pushFwdButtonHandler);
            _bkwButton.addEventListener(MouseEvent.CLICK, pushBkwButtonHandler);
            _styButton.addEventListener(MouseEvent.CLICK, pushStyButtonHandler);
            _changeButton.addEventListener(MouseEvent.CLICK, pushChangeButtonHandler);

            _duel.addEventListener(CharaTransformEvent.PLAYER, plCharaTransformHandler);
            _duel.addEventListener(CharaTransformEvent.FOE, foeCharaTransformHandler);

            _duel.addEventListener(ChangeCharaCardEvent.PLAYER, plCharaChangeHandler);
            _duel.addEventListener(ChangeCharaCardEvent.FOE, foeCharaChangeHandler);

            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);
        }

        // 初期化時に呼ばれる
        public override function final():void
        {
            RemoveChild.apply(_BG);
            RemoveChild.apply(_label);


            _plPoints.forEach(function(item:*, index:int, array:Array):void{RemoveChild.apply(item)});
            _foePoints.forEach(function(item:*, index:int, array:Array):void{RemoveChild.apply(item)});


            RemoveChild.all(_plPointContainer);
            RemoveChild.all(_foePointContainer);
            RemoveChild.apply(_plPointContainer);
            RemoveChild.apply(_foePointContainer);

            RemoveChild.apply(_fwdButton);
            RemoveChild.apply(_bkwButton);
            RemoveChild.apply(_styButton);
            RemoveChild.apply(_changeButton);

            for (var c_key:* in __plCharaFaceSet) {
                RemoveChild.apply(__plCharaFaceSet[c_key]);
                delete __plCharaFaceSet[c_key];
            }

            for (c_key in __foeCharaFaceSet) {
                RemoveChild.apply(__foeCharaFaceSet[c_key]);
                delete __foeCharaFaceSet[c_key];
            }

            if (_plEntrant !=null)
            {
                _plEntrant.removeEventListener(Entrant.POINT_UPDATE, plPointUpdateHandler);
                _plEntrant.removeEventListener(CharaChangeEvent.SUCCESS, plCharaChangeHandler);

                _plEntrant.removeEventListener(Entrant.ATTACK_DONE_SUCCES, plDoneSuccessHandler);
                _plEntrant.removeEventListener(Entrant.DEFFENCE_DONE_SUCCES, plDoneSuccessHandler);
                _plEntrant.removeEventListener(Entrant.INIT_DONE_SUCCES, plDoneSuccessHandler);
                _plEntrant.removeEventListener(Entrant.DIRECTION_UPDATE_SUCCESS, updateDirectionHandler);
                _plEntrant.removeEventListener(ConstraintEvent.CONSTRAINT, plConstraintHandler);
            }
            if (_foeEntrant != null)
            {
                _foeEntrant.removeEventListener(Entrant.POINT_UPDATE, foePointUpdateHandler);
                _foeEntrant.removeEventListener(CharaChangeEvent.SUCCESS, foeCharaChangeHandler);
            }
            _fwdButton.removeEventListener(MouseEvent.CLICK, pushFwdButtonHandler);
            _bkwButton.removeEventListener(MouseEvent.CLICK, pushBkwButtonHandler);
            _styButton.removeEventListener(MouseEvent.CLICK, pushStyButtonHandler);
            _changeButton.removeEventListener(MouseEvent.CLICK, pushChangeButtonHandler);

            _duel.removeEventListener(CharaTransformEvent.PLAYER, plCharaTransformHandler);
            _duel.removeEventListener(CharaTransformEvent.FOE, foeCharaTransformHandler);

            _duel.removeEventListener(ChangeCharaCardEvent.PLAYER, plCharaChangeHandler);
            _duel.removeEventListener(ChangeCharaCardEvent.FOE, foeCharaChangeHandler);

            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);

        }

        // ボタンの初期化
        private function initButton():void
        {
            _fwdButton.initPosition(_duel.rule);
            _bkwButton.initPosition(_duel.rule);
            _styButton.initPosition(_duel.rule);
            _changeButton.initPosition(_duel.rule);
            // 初期ボタンはStay
            _styButton.visible = false;
            moveButtonsEnabled(!_duel.isWatch);
        }

        private function pushFwdButtonHandler(e:Event):void
        {
            if (!_duel.isWatch && _fwdButton.enabled) _plEntrant.setDirection(Entrant.DIRECTION_FORWARD);
        }
        private function pushBkwButtonHandler(e:Event):void
        {
            if (!_duel.isWatch && _bkwButton.enabled) _plEntrant.setDirection(Entrant.DIRECTION_BACKWARD);
        }
        private function pushStyButtonHandler(e:Event):void
        {
            if (!_duel.isWatch && _styButton.enabled) _plEntrant.setDirection(Entrant.DIRECTION_STAY);
        }
        private function pushChangeButtonHandler(e:Event):void
        {
            if (!_duel.isWatch && _changeButton.enabled) _plEntrant.setDirection(Entrant.DIRECTION_CHANGE);
        }

        // entrantのモデル
        private function updateDirectionHandler(e:Event):void
        {
            switch (_plEntrant.direction)
            {
              case Entrant.DIRECTION_FORWARD:
                  _fwdButton.visible = false;
                  _bkwButton.visible = true;
                  _styButton.visible = true;
                  _changeButton.visible = true;
                  break;
            case Entrant.DIRECTION_CHANGE:
                  _fwdButton.visible = true;
                  _bkwButton.visible = true;
                  _styButton.visible = true;
                  _changeButton.visible = false
                  break;
            case Entrant.DIRECTION_BACKWARD:
                  _fwdButton.visible = true;
                  _bkwButton.visible = false;
                  _styButton.visible = true;
                  _changeButton.visible = true;
                  break;
            case Entrant.DIRECTION_STAY:
                  _fwdButton.visible = true;
                  _bkwButton.visible = true;
                  _styButton.visible = false;
                  _changeButton.visible = true;
                  break;
              default:
            }
        }

        private function plConstraintHandler(e:ConstraintEvent):void
        {
            _fwdButton.setFrame(e.isEnabled(ConstraintEvent.CONSTRAINT_FORWARD));
            _bkwButton.setFrame(e.isEnabled(ConstraintEvent.CONSTRAINT_BACKWARD));
            _styButton.setFrame(e.isEnabled(ConstraintEvent.CONSTRAINT_STAY));
            _changeButton.setFrame(e.isEnabled(ConstraintEvent.CONSTRAINT_CHARA_CHANGE));
        }

        public function get BG():DropTableClip
        {
            return _BG;
        }

        public  function get doneButton():DoneButton
        {
            return _doneButton;
        }

        private function get currentPoint():int
        {
            return _plEntrant.movePoint;
        }

        private function plPointUpdateHandler(e:Event):void
        {
            DropTableNum.setNumber(_plPoints,_plEntrant.battlePoint);
//            DropTableDice.setNumber(_plDices,_plEntrant.battlePoint,_plDiceState)
        }

        private function foePointUpdateHandler(e:Event):void
        {
            DropTableNum.setNumber(_foePoints,_foeEntrant.battlePoint)
//            DropTableDice.setNumber(_foeDices,_foeEntrant.battlePoint,_foeDiceState)
        }

        private function isSealing(player:Boolean):Boolean
        {
            var buffClipsArray:Array = [];
            var currentIndex:int = 0;
            if (player)
            {
                buffClipsArray = _duel.getPlayerBuffClips();
                currentIndex = _duel.plEntrant.currentCharaCardIndex;
            }
            else
            {
                buffClipsArray = _duel.getFoeBuffClips();
                currentIndex = _duel.foeEntrant.currentCharaCardIndex;
            }

            var buffClips:Array = [];
            if (buffClipsArray[currentIndex])
            {
                buffClips = buffClipsArray[currentIndex];
            }

            if (buffClips && buffClips.length > 0)
            {
                for(var i:int = 0; i < buffClips.length; i++)
                {
                    if(buffClips[i].no == Const.BUFF_SEAL)
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        private var HAS_PILOTS:Array = [20,27];
        private function plCharaChangeHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(_plCharaFace.outFace));
            GameCtrl.instance.addViewSequence(_plCharaFace.getHideThread());
            if (HAS_PILOTS.indexOf(_duel.playerCharaCard.charactor) >= 0 && isSealing(true))
            {
                _plCharaFace = currentFace(true, true)
            }
            else
            {
                _plCharaFace = currentFace(true);
            }
        }

        private function foeCharaChangeHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(_foeCharaFace.outFace));
            GameCtrl.instance.addViewSequence(_foeCharaFace.getHideThread());
            if (HAS_PILOTS.indexOf(_duel.foeCharaCard.charactor) >= 0 && isSealing(false))
            {
                _foeCharaFace = currentFace(false, true)
            }
            else
            {
                _foeCharaFace = currentFace(false);
            }
        }

        private function plCharaTransformHandler(e:CharaTransformEvent):void
        {
            if (e.transformType == CharaTransformEvent.TYPE_CAT) return;
            GameCtrl.instance.addViewSequence(new ClousureThread(_plCharaFace.outFace));
            GameCtrl.instance.addViewSequence(_plCharaFace.getHideThread());
            _plCharaFace = currentFace(true, e.enabled);
        }

        private function foeCharaTransformHandler(e:CharaTransformEvent):void
        {
            if (e.transformType == CharaTransformEvent.TYPE_CAT) return;
            GameCtrl.instance.addViewSequence(new ClousureThread(_foeCharaFace.outFace));
            GameCtrl.instance.addViewSequence(_foeCharaFace.getHideThread());
            _foeCharaFace = currentFace(false, e.enabled);
        }

        private function plDoneSuccessHandler(e:Event):void
        {
            _doneButton.buttonEnabled = false;
        }


        // ポイントとダイスの可視設定
//         private function pointsDiceVisible(v:Boolean):void
//         {
//             // ダイスポイントを再更新する（値が先に届いている場合があるため）
// //             DropTableDice.setNumber(_plDices,_plEntrant.battlePoint,_plDiceState)
// //             DropTableDice.setNumber(_foeDices,_foeEntrant.battlePoint,_foeDiceState)
//             _plPointContainer.visible = v;
//             _foePointContainer.visible = v;
// //             _plDiceContainer.visible = v;
// //             _foeDiceContainer.visible = v;
//         }

        // ポイントの可視設定
        private function pointsVisible(v:Boolean):void
        {
            _plPointContainer.visible = v;
            _foePointContainer.visible = v;
        }


        // 移動ボタンの可視設定
        private function moveButtonsVisible(v:Boolean):void
        {
            _fwdButton.visible = v;
            _bkwButton.visible = v;
            _styButton.visible = v;
            _changeButton.visible = v;
        }

        // 移動ボタンの動作設定
        private function moveButtonsEnabled(v:Boolean):void
        {
            _fwdButton.mouseChildren = v;
            _bkwButton.mouseChildren = v;
            _styButton.mouseChildren = v;
            _changeButton.mouseChildren = v;
        }

        // OKボタンの可視、起動設定
        private function doneButtonEnabled(e:Boolean):void
        {
            if (!_duel.isWatch) {
                _doneButton.visible = e;
                _doneButton.buttonEnabled = e;
            }
        }

        public function get isDone():Boolean
        {
            return !_doneButton.buttonEnabled;
        }

        // 移動カードドロップフェイズへの遷移スレッドを返す
        public function getSetMoveCardDropPhaseThread():Thread
        {
            return new OnMoveCardDropPhaseThread(this);
        }

        // 隠すスレッドを返す
        public  function getHidePhaseThread(type:String = ""):Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_plCharaFace != null){pExec.addThread(_plCharaFace.getHideThread())};
            if (_foeCharaFace != null){ pExec.addThread(_foeCharaFace.getHideThread())};
            _doneButton.buttonEnabled = false;
            return new HideThread(this);
        }

        // 隠すスレッドを返す
        public override function getHideThread(type:String = ""):Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_plCharaFace != null){pExec.addThread(_plCharaFace.getHideThread())};
            if (_foeCharaFace != null){ pExec.addThread(_foeCharaFace.getHideThread())};
            pExec.addThread(_doneButton.getHideThread());
            pExec.addThread(super.getHideThread());
            return pExec;
        }


        // 攻撃モードの遷移スレッドを返す
        public function getSetRefillPhaseThread():Thread
        {
            return new OnDrawPhaseThread(this);
        }

        // 攻撃モードの遷移スレッドを返す
        public function getSetBattleAttackPhaseThread():Thread
        {
            return new OnAttackPhaseThread(this);
        }

        // 防御モードの遷移スレッドを返す
        public function getSetBattleDeffencePhaseThread():Thread
        {
            return new OnDeffencePhaseThread(this);
        }

        // 待機モードの遷移スレッドを返す
        public function getSetBattleWaitingPhaseThread():Thread
        {
            return new OnWaitingPhaseThread(this);
        }


        // 戦闘決定モードの遷移スレッドを返す
        public function getSetBattleResultThread():Thread
        {
            return new OnBattleResult(this);
        }

        // キャラチェンモードの遷移スレッドを返す
        public function getSetCharaChangePhaseThread():Thread
        {
            return new OnCharaChangePhaseThread(this);
        }

        // 移動カードドロップモードをセット
        public function setMoveCardDropPhase():void
        {
//            _movePiece.visible = true;
            pointsVisible(false);
            moveButtonsVisible(true);
            // 現在が３対３か
            if(_duel.rule == Duel.RULE_3VS3)
            {
            _BG.onMoveThree();

            }else{

            _BG.onMove();
            }
            _plCharaFace.inFace();
            _foeCharaFace.inFace();
            _waiting = false;
////            _label.text = "移動カードをドロップしてください";
//            _label.text = _TRANS_MSG8OLD;
            _addCardFunc = _plEntrant.moveCardAdd;
            _removeCardFunc = _plEntrant.moveCardRemove;

            doneButtonEnabled(true);
        }

        // イニシアチブの結果表示
        public function setInitiativeResult():void
        {
////            _label.text = "イニシアチブ決定";
//            _label.text = _TRANS_MSG9OLD;
        }

        // イニシアチブの結果表示
        public function setBattleResult():void
        {
////            _label.text = "バトル決定";
//            _label.text = _TRANS_MSG10OLD;
        }

        // 攻撃モードをセット
        public function setAttackPhase():void
        {
//            _movePiece.visible = false;
            moveButtonsVisible(false);
//             _plDiceState = DropTableDice.ATK;
//             _foeDiceState = DropTableDice.DEF;
//             _beforeState = DropTableDice.ATK;
            _plCharaFace.inFace();
            _foeCharaFace.outFace();
            if (_duel.foeEntrant.inFog || (_duel.plEntrant.inFog && _duel.truth_distance == 0)){
                _BG.onAttackAll();
            }
            else if (_duel.attakType == Duel.ATK_TYPE_SWORD)
            {
                _BG.onAttackSword();
            }else{
                _BG.onAttackArrow();
            }
            pointsVisible(true);
            _waiting = false;
            _addCardFunc = _plEntrant.attackCardAdd;
            _removeCardFunc = _plEntrant.attackCardRemove;
            doneButtonEnabled(true);

        }

        // キャラチェンジモードをセット
        public function setCharaChangePhase():void
        {

            moveButtonsVisible(false);
            pointsVisible(false);

            _plCharaFace.outFace();
            _foeCharaFace.outFace();
            _BG.onCharaChange();
            _waiting = false;
            doneButtonEnabled(true);
        }

        // DrawPhaseモードをセット
        public function setDrawPhase():void
        {

            moveButtonsVisible(false);
            pointsVisible(false);

            _plCharaFace.outFace();
            _foeCharaFace.outFace();
            _BG.onDraw();
            _waiting = false;
            doneButtonEnabled(true);
        }

        // ディフェンスモードをセット
        public function setDeffencePhase():void
        {
//            _movePiece.visible = false;
            moveButtonsVisible(false);
//             _plDiceState = DropTableDice.DEF;
//             _foeDiceState = DropTableDice.ATK;
            _plCharaFace.inFace();
            _foeCharaFace.outFace();
            _BG.onDeffence();
            pointsVisible(true);
            _waiting = false;
            _addCardFunc = _plEntrant.deffenceCardAdd;
            _removeCardFunc = _plEntrant.deffenceCardRemove;
            doneButtonEnabled(true);
        }

        // ウェイトモードをセット
        public function setWaitingPhase():void
        {
            // イニシアチブをうしなっていたらDEF-wait
//             if (_beforeState == DropTableDice.ATK)
//             {
//                 _plDiceState = DropTableDice.ATK;
//                 _foeDiceState = DropTableDice.DEF;
//                 _beforeState = DropTableDice.DEF;

//             }else{
//                 _plDiceState = DropTableDice.DEF;
//                 _foeDiceState = DropTableDice.ATK;
//             }
            _plCharaFace.outFace();
            _foeCharaFace.inFace();

            _BG.onWait();
            pointsVisible(true);
            moveButtonsVisible(false);
            _waiting = true;
            _addCardFunc = null;
            _removeCardFunc = null;
            doneButtonEnabled(false);
//            _movePiece.visible = false;
        }


        // ドロップ可能かを判定する（可能な場合はカードの方向をただす）
        public  function dropDetect(x:Number, y:Number, acc:ActionCardClip):Boolean
        {
            if(_dropArea.contains(x,y))
            {
                if (!(_waiting))
                {
                    return true;
                }else{
                    return false;
                }

            }
            else
            {
                return false;
            }
        }


        // カードを追加する
        public function addCard(acc:ActionCardClip, dir:Boolean):void
        {
            if ( !_duel.isWatch && _addCardFunc != null)
 {
                _addCardFunc(acc.ac,dir);
//                updatePoint();
            }
        }

        // カードを手札に戻す
        public function removeCard(acc:ActionCardClip):void
        {
            if ( !_duel.isWatch && _removeCardFunc != null)
            {
//                log.writeLog(log.LV_FATAL, this, "remove card",acc.ac);
                _removeCardFunc(acc.ac);
//                updatePoint();
            }
        }

        private function updateTotalPoint():void
        {


        }

        public function totalPoint(i:int):void
        {

            _totalPoint = i;
        }

        // 実画面から消去するスレッドを返す
        public function getBringOffThread():Thread
        {
//            return new TweenerThread(this, { alpha: 0.0, transition:"easeOutSine", time: 0.5, hide:true} );
            return new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
        }

    }

}
import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.scene.game.DropTable;
import view.BaseHideThread;

// 移動カードドロップフェイズモードへ
class OnMoveCardDropPhaseThread extends Thread
{
    protected var _dropTable:DropTable;
    private static var _TIME:Number = 0.3;

    public function OnMoveCardDropPhaseThread(dt:DropTable)
    {
        _dropTable = dt;
    }

    protected override function run():void
    {
        next(setMove);
    }

    protected function setMove():void
    {
        _dropTable.setMoveCardDropPhase();
        next(fin);
    }

    protected function fin():void
    {
//        var thread:Thread = new TweenerThread(_dropTable, { alpha: 1.0, transition:"easeOutSine", time: _TIME, show: true});
        var thread:Thread = new BeTweenAS3Thread(_dropTable, {alpha:1.0}, null, _TIME, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        thread.start();
        thread.join();
    }

}

// // イニシアチブ決定モード終了
// class OnInitiativeResult extends Thread
// {
//     protected var _dropTable:DropTable;

//     public function OnInitiativeResult(dt:DropTable)
//     {
//         _dropTable = dt;
//     }

//     protected override function run():void
//     {
//         _dropTable.setInitiativeResult();
//     }
// }

// 攻撃モード表示
class OnAttackPhaseThread extends OnMoveCardDropPhaseThread
{
    public function OnAttackPhaseThread(dt:DropTable):void
    {
        super(dt)
    }
    protected override function setMove():void
    {
        _dropTable.setAttackPhase();
        next(fin);
    }
}

// 防御モード表示
class OnDeffencePhaseThread extends OnMoveCardDropPhaseThread
{
    public function OnDeffencePhaseThread(dt:DropTable):void
    {
        super(dt)
    }
    protected override function setMove():void
    {
        _dropTable.setDeffencePhase();
        next(fin);
    }
}

// 待機モード
class OnWaitingPhaseThread extends OnMoveCardDropPhaseThread
{
    public function OnWaitingPhaseThread(dt:DropTable):void
    {
        super(dt)
    }
    protected override function setMove():void
    {
        _dropTable.setWaitingPhase();
        next(fin);
    }
}

// 戦闘決定モード終了
class OnBattleResult extends OnMoveCardDropPhaseThread
{
    public function OnBattleResult(dt:DropTable)
    {
        super(dt)
    }

    protected override function run():void
    {
        _dropTable.setBattleResult();
        next(fin);
    }
}

// 攻撃モード表示
class OnCharaChangePhaseThread extends OnMoveCardDropPhaseThread
{
    public function OnCharaChangePhaseThread(dt:DropTable):void
    {
        super(dt)
    }
    protected override function setMove():void
    {
        _dropTable.setCharaChangePhase();
        next(fin);
    }
}

// ドローモード表示
class OnDrawPhaseThread extends OnMoveCardDropPhaseThread
{
    public function OnDrawPhaseThread(dt:DropTable):void
    {
        super(dt)
    }
    protected override function setMove():void
    {
        _dropTable.setDrawPhase();
        next(fin);
    }
}



// 一時的に隠す
class HideThread extends BaseHideThread
{
    private var _dropTable:DropTable;
    private static var _TIME:Number = 0.2;

    public function HideThread(dt:DropTable)
    {
        _dropTable = dt;
        super(dt);
    }

    protected override function run():void
    {
        if (_dropTable.alpha == 1.0)
        {
//            var thread:Thread = new TweenerThread(_dropTable, { alpha: 0.0, transition:"easeOutSine", time: _TIME, hide: true});
            var thread:Thread = new BeTweenAS3Thread(_dropTable, {alpha:0.0}, null, _TIME, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false);
            thread.start();
            thread.join();
        }
        next(hide);
    }
    private function hide():void
    {
        _dropTable.BG.onBlank();
//        next(exit);
    }
}



