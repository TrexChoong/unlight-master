package view.scene.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.containers.Box;
    import mx.controls.Text;
    import mx.controls.TextArea;
    import mx.controls.Label;
    import mx.containers.Panel;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.events.TweenEvent;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import model.Duel;
    import model.Entrant;
    import model.CharaCard;
    import model.Feat;
    import model.events.FeatInfoEvent;
    import model.events.FeatInfoChangeEvent;

    import view.scene.BaseScene;
    import view.ClousureThread;
    import view.image.game.FeatInfoPanel;
    import controller.*;

    /**
     * 必殺技情報表示クラス
     *
     */

    public class FeatInfo extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "キャラクターが持つ必殺技です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIST_N	:String = "近";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIST_M	:String = "中";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIST_L	:String = "遠";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIST_ALL	:String = "全";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIST	:String = "距離\n";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD	:String = "合計$1以上";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_BELOW	:String = "合計$1以下";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_SWORD	:String = "剣";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_GUN	:String = "銃";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_SPC	:String = "特";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_MOVE	:String = "移";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_DEF	:String = "防";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_WLD	:String = "無";
        CONFIG::LOCALE_JP
        private static const _TRANS_ATK		:String = "攻撃力";
        CONFIG::LOCALE_JP
        private static const _TRANS_DEF		:String = "防御力";
        CONFIG::LOCALE_JP
        private static const _TRANS_MOV		:String = "移動力";
        CONFIG::LOCALE_JP
        private static const _TRANS_NAME_PHASE	:String = "フェイズ\t: ";
        CONFIG::LOCALE_JP
        private static const _TRANS_NAME_RANGE	:String = "間合い\t: ";
        CONFIG::LOCALE_JP
        private static const _TRANS_NAME_CARD	:String = "カード\t: ";
        CONFIG::LOCALE_JP
        private static const _TRANS_EFFECT	:String = "効果";
        CONFIG::LOCALE_JP
        private static const _TRANS_PHASE_ATK	:String = "攻撃";
        CONFIG::LOCALE_JP
        private static const _TRANS_PHASE_DEF	:String = "防御";
        CONFIG::LOCALE_JP
        private static const _TRANS_PHASE_MOV	:String = "移動";
        CONFIG::LOCALE_JP
        private static const _LEFT_MARGIN	:String = "66";
        CONFIG::LOCALE_JP
        private static const _TRANS_REQUIRE	:String = "<b>[条件]</b>\n";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "The character's special attack.";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIST_N	:String = "Short";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIST_M	:String = "Medium";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIST_L	:String = "Long";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIST_ALL	:String = "Any";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIST	:String = "Range\n";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD	:String = "Total of at least $1";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_BELOW	:String = "Total of less than $1";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_SWORD	:String = "Sword ";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_GUN	:String = "Gun ";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_SPC	:String = "Special ";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_MOVE	:String = "Movement ";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_DEF	:String = "Def ";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_WLD	:String = "None ";
        CONFIG::LOCALE_EN
        private static const _TRANS_ATK		:String = "Attack Power";
        CONFIG::LOCALE_EN
        private static const _TRANS_DEF		:String = "Defensive Power";
        CONFIG::LOCALE_EN
        private static const _TRANS_MOV		:String = "Movement Power";
        CONFIG::LOCALE_EN
        private static const _TRANS_NAME_PHASE	:String = "Phase\t: ";
        CONFIG::LOCALE_EN
        private static const _TRANS_NAME_RANGE	:String = "Range\t: ";
        CONFIG::LOCALE_EN
        private static const _TRANS_NAME_CARD	:String = "Card\t: ";
        CONFIG::LOCALE_EN
        private static const _TRANS_EFFECT	:String = "Effect";
        CONFIG::LOCALE_EN
        private static const _TRANS_PHASE_ATK	:String = "Attack";
        CONFIG::LOCALE_EN
        private static const _TRANS_PHASE_DEF	:String = "Defense";
        CONFIG::LOCALE_EN
        private static const _TRANS_PHASE_MOV	:String = "Movement";
        CONFIG::LOCALE_EN
        private static const _LEFT_MARGIN	:String = "66";
        CONFIG::LOCALE_EN
        private static const _TRANS_REQUIRE	:String = "<b>[Requirements]</b>\n";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "角色所擁有的必殺技";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIST_N	:String = "近";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIST_M	:String = "中";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIST_L	:String = "遠";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIST_ALL	:String = "全";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIST	:String = "距離\n";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD	:String = "合計$1以上";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_BELOW	:String = "合計$1以下";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_SWORD	:String = "劍";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_GUN	:String = "槍";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_SPC	:String = "特";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_MOVE	:String = "移";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_DEF	:String = "防";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_WLD	:String = "無";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ATK		:String = "攻擊力";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DEF		:String = "防禦力";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MOV		:String = "移動力";
        CONFIG::LOCALE_TCN
        private static const _TRANS_NAME_PHASE	:String = "階段\t: ";
        CONFIG::LOCALE_TCN
        private static const _TRANS_NAME_RANGE	:String = "距離\t: ";
        CONFIG::LOCALE_TCN
        private static const _TRANS_NAME_CARD	:String = "卡片\t: ";
        CONFIG::LOCALE_TCN
        private static const _TRANS_EFFECT	:String = "效果";
        CONFIG::LOCALE_TCN
        private static const _TRANS_PHASE_ATK	:String = "攻擊";
        CONFIG::LOCALE_TCN
        private static const _TRANS_PHASE_DEF	:String = "防禦";
        CONFIG::LOCALE_TCN
        private static const _TRANS_PHASE_MOV	:String = "移動";
        CONFIG::LOCALE_TCN
        private static const _LEFT_MARGIN	:String = "66";
        CONFIG::LOCALE_TCN
        private static const _TRANS_REQUIRE	:String = "<b>[條件]</b>\n";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "角色所拥有的必杀技。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIST_N	:String = "近";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIST_M	:String = "中";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIST_L	:String = "远";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIST_ALL	:String = "全";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIST	:String = "距离\n";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD	:String = "合计超过$1";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_BELOW	:String = "合计更少$1";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_SWORD	:String = "剑";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_GUN	:String = "枪";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_SPC	:String = "特";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_MOVE	:String = "移";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_DEF	:String = "防";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_WLD	:String = "無";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ATK		:String = "攻击力";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DEF		:String = "防御力";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MOV		:String = "移动力";
        CONFIG::LOCALE_SCN
        private static const _TRANS_NAME_PHASE	:String = "环节\t: ";
        CONFIG::LOCALE_SCN
        private static const _TRANS_NAME_RANGE	:String = "时机\t: ";
        CONFIG::LOCALE_SCN
        private static const _TRANS_NAME_CARD	:String = "卡片\t: ";
        CONFIG::LOCALE_SCN
        private static const _TRANS_EFFECT	:String = "效果";
        CONFIG::LOCALE_SCN
        private static const _TRANS_PHASE_ATK	:String = "攻击";
        CONFIG::LOCALE_SCN
        private static const _TRANS_PHASE_DEF	:String = "防御";
        CONFIG::LOCALE_SCN
        private static const _TRANS_PHASE_MOV	:String = "移动";
        CONFIG::LOCALE_SCN
        private static const _LEFT_MARGIN	:String = "66";
        CONFIG::LOCALE_SCN
        private static const _TRANS_REQUIRE	:String = "<b>[条件]</b>\n";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "캐릭터의 필살기입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIST_N	:String = "근";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIST_M	:String = "중";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIST_L	:String = "원";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIST_ALL	:String = "전";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIST	:String = "거리\n";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD	:String = "합계$1이상";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_BELOW	:String = "合計$1以下";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_SWORD	:String = "검";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_GUN	:String = "총";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_SPC	:String = "특수";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_MOVE	:String = "이동";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_DEF	:String = "방어";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_WLD	:String = "無";
        CONFIG::LOCALE_KR
        private static const _TRANS_ATK		:String = "공격력";
        CONFIG::LOCALE_KR
        private static const _TRANS_DEF		:String = "방어력";
        CONFIG::LOCALE_KR
        private static const _TRANS_MOV		:String = "이동력";
        CONFIG::LOCALE_KR
        private static const _TRANS_NAME_PHASE	:String = "페이즈\t: ";
        CONFIG::LOCALE_KR
        private static const _TRANS_NAME_RANGE	:String = "거리\t: ";
        CONFIG::LOCALE_KR
        private static const _TRANS_NAME_CARD	:String = "카드\t: ";
        CONFIG::LOCALE_KR
        private static const _TRANS_EFFECT	:String = "효과";
        CONFIG::LOCALE_KR
        private static const _TRANS_PHASE_ATK	:String = "공격";
        CONFIG::LOCALE_KR
        private static const _TRANS_PHASE_DEF	:String = "방어";
        CONFIG::LOCALE_KR
        private static const _TRANS_PHASE_MOV	:String = "이동";
        CONFIG::LOCALE_KR
        private static const _LEFT_MARGIN	:String = "66";
        CONFIG::LOCALE_KR
        private static const _TRANS_REQUIRE	:String = "<b>[조건]</b>\n";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "Attaque spéciale du Personnage";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIST_N	:String = "S";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIST_M	:String = "MID";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIST_L	:String = "L";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIST_ALL	:String = "TOUT";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIST	:String = "Portée\n";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD	:String = "Total de plus de $1";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_BELOW	:String = "Total inférieur à $1";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_SWORD	:String = "EPEE ";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_GUN	:String = "FUSIL ";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_SPC	:String = "SP ";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_MOVE	:String = "M ";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_DEF	:String = "D ";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_WLD	:String = "Rien ";
        CONFIG::LOCALE_FR
        private static const _TRANS_ATK		:String = "Capacité d'Attaque";
        CONFIG::LOCALE_FR
        private static const _TRANS_DEF		:String = "Défense";
        CONFIG::LOCALE_FR
        private static const _TRANS_MOV		:String = "Capacité de Déplacement";
        CONFIG::LOCALE_FR
        private static const _TRANS_NAME_PHASE	:String = "Phase\t: ";
        CONFIG::LOCALE_FR
        private static const _TRANS_NAME_RANGE	:String = "Gamme\t: ";
        CONFIG::LOCALE_FR
        private static const _TRANS_NAME_CARD	:String = "Carte\t: ";
        CONFIG::LOCALE_FR
        private static const _TRANS_EFFECT	:String = "Effet";
        CONFIG::LOCALE_FR
        private static const _TRANS_PHASE_ATK	:String = "Attaque";
        CONFIG::LOCALE_FR
        private static const _TRANS_PHASE_DEF	:String = "Défense";
        CONFIG::LOCALE_FR
        private static const _TRANS_PHASE_MOV	:String = "Déplacement";
        CONFIG::LOCALE_FR
        private static const _LEFT_MARGIN	:String = "66";
        CONFIG::LOCALE_FR
        private static const _TRANS_REQUIRE	:String = "<b>[Conditions]</b>\n";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "キャラクターが持つ必殺技です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIST_N	:String = "近";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIST_M	:String = "中";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIST_L	:String = "遠";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIST_ALL	:String = "全";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIST	:String = "距離\n";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD	:String = "合計$1以上";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_BELOW	:String = "合計$1以下";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_SWORD	:String = "剣";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_GUN	:String = "銃";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_SPC	:String = "特";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_MOVE	:String = "移";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_DEF	:String = "防";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_WLD	:String = "無";
        CONFIG::LOCALE_ID
        private static const _TRANS_ATK		:String = "攻撃力";
        CONFIG::LOCALE_ID
        private static const _TRANS_DEF		:String = "防御力";
        CONFIG::LOCALE_ID
        private static const _TRANS_MOV		:String = "移動力";
        CONFIG::LOCALE_ID
        private static const _TRANS_NAME_PHASE	:String = "フェイズ\t: ";
        CONFIG::LOCALE_ID
        private static const _TRANS_NAME_RANGE	:String = "間合い\t: ";
        CONFIG::LOCALE_ID
        private static const _TRANS_NAME_CARD	:String = "カード\t: ";
        CONFIG::LOCALE_ID
        private static const _TRANS_EFFECT	:String = "効果";
        CONFIG::LOCALE_ID
        private static const _TRANS_PHASE_ATK	:String = "攻撃";
        CONFIG::LOCALE_ID
        private static const _TRANS_PHASE_DEF	:String = "防御";
        CONFIG::LOCALE_ID
        private static const _TRANS_PHASE_MOV	:String = "移動";
        CONFIG::LOCALE_ID
        private static const _LEFT_MARGIN	:String = "66";
        CONFIG::LOCALE_ID
        private static const _TRANS_REQUIRE	:String = "<b>[条件]</b>\n";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG     :String = "ท่าไม้ตายของตัวละคร";//"キャラクターが持つ必殺技です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIST_N  :String = "ใกล้";//"近";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIST_M  :String = "กลาง";//"中";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIST_L  :String = "ไกล";//"遠";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIST_ALL    :String = "ทั้งหมด";//"全";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIST    :String = "\n";//"距離\n";
//        private static const _TRANS_DIST    :String = "ระยะห่าง\n";//"距離\n";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD    :String = "รวม$1ขึ้นไป";//"合計$1以上";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_BELOW	:String = "";//合計$1以下
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_SWORD  :String = "ดาบ";//"剣";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_GUN    :String = "ปืน";//"銃";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_SPC    :String = "พิเศษ";//"特";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_DEF    :String = "ป้องกัน";//"防";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_WLD    :String = "การ์ดอะไรก็ได้ ";//無
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_MOVE   :String = "เคลื่อนที่";//"移";
        CONFIG::LOCALE_TH
        private static const _TRANS_ATK     :String = "พลังโจมตี";//"攻撃力";
        CONFIG::LOCALE_TH
        private static const _TRANS_DEF     :String = "พลังป้องกัน";//"防御力";
        CONFIG::LOCALE_TH
        private static const _TRANS_MOV     :String = "พลังเคลื่อนที่";//"移動力";
        CONFIG::LOCALE_TH
        private static const _TRANS_NAME_PHASE  :String = "ขั้นตอน\t: ";//"フェイズ\t: ";
        CONFIG::LOCALE_TH
        private static const _TRANS_NAME_RANGE  :String = "ระยะ\t: ";//"間合い\t: ";
//        private static const _TRANS_NAME_RANGE  :String = "โอกาส\t: ";//"間合い\t: ";
        CONFIG::LOCALE_TH
        private static const _TRANS_NAME_CARD   :String = "การ์ด\t: ";//"カード\t: ";
        CONFIG::LOCALE_TH
        private static const _TRANS_EFFECT  :String = "ผลลัพธ์";//"効果";
        CONFIG::LOCALE_TH
        private static const _TRANS_PHASE_ATK   :String = "โจมตี";
        CONFIG::LOCALE_TH
        private static const _TRANS_PHASE_DEF   :String = "ป้องกัน";
        CONFIG::LOCALE_TH
        private static const _TRANS_PHASE_MOV   :String = "เคลื่อนที่";
        CONFIG::LOCALE_TH
        private static const _LEFT_MARGIN   :String = "0";
        CONFIG::LOCALE_TH
        private static const _TRANS_REQUIRE :String = "<b>[เงื่อนไข]</b>\n";//"<b>[条件]</b>\n";


        private static const _X:int = 168;
        private static const _Y:int = 439;
        private static const _FOE_X:int = 444;
        private static const _FOE_Y:int = 32;
        private static const _X_DIF:int = 148;

        private static const _CAPTION_CONDS:Array = [
//            "フェイズ\t: ",
//            "間合い\t: " ,
//            "カード\t: "
            _TRANS_NAME_PHASE,
            _TRANS_NAME_RANGE ,
            _TRANS_NAME_CARD
            ]; /* of String */
        private static const _COND_TYPE_PHASE:int = 0;
        private static const _COND_TYPE_DIST:int = 1;
        private static const _COND_TYPE_CARD:int = 2;

        private var _featIdArray:Array = [];             // 必殺技ID
        private var _panelArray:Array = [];              // ベース表示の配列
        private var _nameLabelArray:Array = [];          // 必殺技名の配列
        private var _captionArray:Array = [];            // string of array

        private var _foeFeatIdArray:Array = [];             // 必殺技ID
        private var _foePanelArray:Array = [];              // ベース表示の配列
        private var _foeNameLabelArray:Array = [];          // 必殺技名の配列
        private var _foeCaptionArray:Array = [];            // string of array

        private var _captionArea:TextArea = new TextArea();   // 説明表示のベース

        // ゲームのコントローラ

        // デュエルインスタンス
        private var _duel:Duel = Duel.instance;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["キャラクターが持つ必殺技です。"],   // 0
                [_TRANS_MSG],   // 0
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int = 0;

        private var _hideTween:ITween;
        private var _showTween:ITween;

        /**
         * コンストラクタ
         *
         */
        public function FeatInfo()
        {
           super();
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  //
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
            initializeFeatInfo();
            initializeFoeFeatInfo();
            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);

            // 必殺技スイッチのイベント
            _duel.addEventListener(FeatInfoEvent.PLAYER_FEAT_ON, featOnHandler);
            _duel.addEventListener(FeatInfoEvent.PLAYER_FEAT_OFF, featOffHandler);
            _duel.addEventListener(FeatInfoEvent.PLAYER_FEAT_OFF_ALL, allFeatOffHandler);

            // 技の変更
            _duel.addEventListener(FeatInfoChangeEvent.PLAYER_FEAT_CHANGE, plFeatChangeHandler);
            _duel.addEventListener(FeatInfoChangeEvent.FOE_FEAT_CHANGE, foeFeatChangeHandler);

            _duel.plEntrant.addEventListener(Entrant.CHANGE_DONE, plCharaCardChangeHandler);
            _duel.foeEntrant.addEventListener(Entrant.CHANGE_DONE, foeCharaCardChangeHandler);
        }

        public override function final():void
        {
            finalizeFeatInfo();
            finalizeFoeFeatInfo();

            _duel.removeEventListener(FeatInfoEvent.PLAYER_FEAT_ON, featOnHandler);
            _duel.removeEventListener(FeatInfoEvent.PLAYER_FEAT_OFF, featOffHandler);
            _duel.removeEventListener(FeatInfoEvent.PLAYER_FEAT_OFF_ALL, allFeatOffHandler);

            _duel.removeEventListener(FeatInfoChangeEvent.PLAYER_FEAT_CHANGE, plFeatChangeHandler);
            _duel.removeEventListener(FeatInfoChangeEvent.FOE_FEAT_CHANGE, foeFeatChangeHandler);

            _duel.plEntrant.removeEventListener(Entrant.CHANGE_DONE, plCharaCardChangeHandler);
            _duel.foeEntrant.removeEventListener(Entrant.CHANGE_DONE, foeCharaCardChangeHandler);
        }

        // 初期化処理
        private function initializeFeatInfo():void
        {
            // 配列を初期化
            _featIdArray = [];
            _panelArray =[];
            _nameLabelArray = [];
            _captionArray = [];

            Duel.instance.getPlayerFeats().forEach(

                function(item:*, index:int, array:Array):void
                {
                    var featInfoPanel:FeatInfoPanel = new FeatInfoPanel();
                    var nameLabel:Label = new Label();
                    nameLabel.text = item.name;
                    nameLabel.styleName = "FeatInfoLabel";
                    nameLabel.width = 130;
                    nameLabel.height = 30;
                    nameLabel.visible = false;
                    nameLabel.truncateToFit = true;
                    callLater(fontSizeAdjust,[nameLabel])
                    featInfoPanel.x = _X + _X_DIF*index;;
                    featInfoPanel.y = _Y
                    featInfoPanel.visible = false;
                    featInfoPanel.setType(item.type);

                    nameLabel.x = _X+12+_X_DIF*index;
                    nameLabel.y = _Y-1;
                    CONFIG::LOCALE_TCN
                    {
                        nameLabel.y = _Y+2;
                    }
                    CONFIG::LOCALE_SCN
                    {
                        nameLabel.y = _Y+2;
                    }

                    _featIdArray.push(item.id);
                    _panelArray.push(featInfoPanel);
                    _nameLabelArray.push(nameLabel);
                    _captionArray.push(captionDecorate(item.caption));

                    // 説明文を読み込むハンドラ
                    nameLabel.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
                    nameLabel.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);

                    addChild(featInfoPanel);
                    addChild(nameLabel);
                });

            _captionArea.styleName = "FeatInfoCaption";
            _captionArea.width = 150;
            _captionArea.height = 142;

            _captionArea.alpha = 0;
            _captionArea.editable = false;
            _captionArea.mouseEnabled = false;
            _captionArea.mouseChildren = false;
            _captionArea.verticalScrollPolicy = "off";
            _showTween= BetweenAS3.tween(_captionArea, {alpha:0.8}, null, 0.1, Quad.easeOut);
            _hideTween= BetweenAS3.tween(_captionArea, {alpha:0.0}, null, 0.05, Quad.easeOut);
            _hideTween.addEventListener(TweenEvent.COMPLETE, hideCaptionArea);
        }


        // 初期化処理
        private function initializeFoeFeatInfo():void
        {
            // 配列を初期化
            _foeFeatIdArray = [];
            _foePanelArray =[];
            _foeNameLabelArray = [];
            _foeCaptionArray = [];

            Duel.instance.getFoeFeats().forEach(

                function(item:*, index:int, array:Array):void
                {
                    var featInfoPanel:FeatInfoPanel = new FeatInfoPanel();
                    var nameLabel:Label = new Label();
                    nameLabel.text = item.name;
                    nameLabel.styleName = "FeatInfoLabel";
                    nameLabel.width = 130;
                    nameLabel.height = 30;
                    nameLabel.visible = false;
                    nameLabel.truncateToFit = true;
                    callLater(fontSizeAdjust,[nameLabel]);
                    featInfoPanel.x = _FOE_X - _X_DIF*index;
                    featInfoPanel.y = _FOE_Y
                    featInfoPanel.visible = false;
                    featInfoPanel.setType(item.type);

                    nameLabel.x = _FOE_X+12 - _X_DIF*index;
                    nameLabel.y = _FOE_Y-1;
                    CONFIG::LOCALE_TCN
                    {
                        nameLabel.y = _FOE_Y+2;
                    }
                    CONFIG::LOCALE_SCN
                    {
                        nameLabel.y = _FOE_Y+2;
                    }


                    _foeFeatIdArray.push(item.id);
                    _foePanelArray.push(featInfoPanel);
                    _foeNameLabelArray.push(nameLabel);
                    _foeCaptionArray.push(captionDecorate(item.caption));

                    // 説明文を読み込むハンドラ
                    nameLabel.addEventListener(MouseEvent.MOUSE_OVER, mouseOverFoeHandler);
                    nameLabel.addEventListener(MouseEvent.MOUSE_OUT, mouseOutFoeHandler);

                    addChild(featInfoPanel);
                    addChild(nameLabel);

                    log.writeLog(log.LV_INFO, this, "add foe feats");
                });

            _captionArea.styleName = "FeatInfoCaption";
            _captionArea.width = 150;
            _captionArea.height = 142;
            _captionArea.alpha = 0;
            _captionArea.editable = false;
            _captionArea.mouseEnabled = false;
            _captionArea.mouseChildren = false;
            _showTween= BetweenAS3.tween(_captionArea, {alpha:0.8}, null, 0.1, Quad.easeOut);
            _hideTween= BetweenAS3.tween(_captionArea, {alpha:0.0}, null, 0.05, Quad.easeOut);
            _hideTween.addEventListener(TweenEvent.COMPLETE, hideCaptionArea);
        }

        private function updatePlFeatInfoAt(chara_index:int, feat_index:int, feat_id:int, feat_no:int):void
        {
            _featIdArray.splice(feat_index, 1, feat_id);

            var feat:Feat = Duel.instance.getPlayerFeats()[feat_index];

            var label:Label = _nameLabelArray[feat_index];
            label.visible = false;
            label.text = feat.name;
            label.clearStyle("fontSize");
            label.clearStyle("paddingTop");
            callLater(fontSizeAdjust,[label]);

            var panel:FeatInfoPanel = _panelArray[feat_index];

            panel.setType(feat.type);

            _captionArray.splice(feat_index, 1, captionDecorate(feat.caption));
            label.visible = true;
        }

        private function updateFoeFeatInfoAt(chara_index:int, feat_index:int, feat_id:int, feat_no:int):void
        {
            _foeFeatIdArray.splice(feat_index, 1, feat_id);

            var feat:Feat = Duel.instance.getFoeFeats()[feat_index];

            var label:Label = _foeNameLabelArray[feat_index];
            label.visible = false;
            label.text = feat.name;
            label.clearStyle("fontSize");
            label.clearStyle("paddingTop");
            callLater(fontSizeAdjust,[label]);

            var panel:FeatInfoPanel = _foePanelArray[feat_index];

            panel.setType(feat.type);

            _foeCaptionArray.splice(feat_index, 1, captionDecorate(feat.caption));
            label.visible = true;
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
        }

        // キャプションをわかりやすいようにHTML装飾
        private function captionDecorate(c:String):String
        {
            // 必殺技の条件を配列にして保持しておく
            var caption:String;
            var condStr:String = getConditionString(c);
            var condArray:Array = condStr.split(":");

            // 括弧の中身を取り出す
//            caption = "<b>[条件]</b>\n";
            caption = _TRANS_REQUIRE;
            caption += "<textFormat indent = \"-56\" leftmargin = \""+_LEFT_MARGIN+"\" >"
            for(var i:int = 0; i < condArray.length; i++){
                switch (i)
                {
                case _COND_TYPE_PHASE:
                    caption += _CAPTION_CONDS[i];
                    caption +=condArray[i]
                        .replace(/攻撃/g, _TRANS_PHASE_ATK)
                        .replace(/防御/g, _TRANS_PHASE_DEF)
                        .replace(/移動/g, _TRANS_PHASE_MOV)
                        +"\n";
                    break;
                case _COND_TYPE_DIST:
                    caption += _CAPTION_CONDS[i];
                    caption +=condArray[i].replace(/近,中,遠/g, _TRANS_DIST_ALL)
                        .replace(/近/g, _TRANS_DIST_N)
                        .replace(/中/g, _TRANS_DIST_M)
                        .replace(/遠/g, _TRANS_DIST_L)
                        +_TRANS_DIST;
//                    caption +=condArray[i].replace(/_TRANS_DIST_N,_TRANS_DIST_M,_TRANS_DIST_L/g, _TRANS_DIST_ALL)+_TRANS_DIST;
                    break;
                case _COND_TYPE_CARD:
                    caption += _CAPTION_CONDS[i];
                    caption +=condArray[i].replace(/(.)\+/g, _TRANS_CARD)
                        .replace(/(.)\-/g, _TRANS_CARD_BELOW)
                        .replace(/近/g,_TRANS_CARD_SWORD)
                        .replace(/遠/g,_TRANS_CARD_GUN)
                        .replace(/特/g,_TRANS_CARD_SPC)
                        .replace(/移/g,_TRANS_CARD_MOVE)
                        .replace(/防/g,_TRANS_CARD_DEF)
                        .replace(/無/g,_TRANS_CARD_WLD)
                        .replace(/S/g,_TRANS_CARD_SWORD)
                        .replace(/A/g,","+_TRANS_CARD_GUN)
                        .replace(/D/g,","+_TRANS_CARD_DEF);
//                    caption +=condArray[i].replace(/(.)\+/g, _TRANS_CARD).replace(/_TRANS_DIST_N/g,_TRANS_CARD_SWORD).replace(/_TRANS_DIST_L/g,_TRANS_CARD_GUN);
                    caption += "\n";
                break;
                default:
                }
            }
            caption += "</textFormat>";

            caption +="<font color = \"#FFFF00\">";
//            caption += "<b>[効果]</b>\n";
            caption += "<b>["+_TRANS_EFFECT+"]</b>\n";
            // 括弧以降を取り出し、改行までを装飾
            caption += "<textFormat leftmargin = \"10\" >";
            //  caption += c.slice(c.indexOf("]")+1,c.indexOf("\|")).replace(",", "\n").replace(/ATK/g,"攻撃力").replace(/DEF/g,"防御力");;
            caption += c.slice(condStr.length+2,c.indexOf("\|")).replace(/,\s?/g, "\n").replace(/ATK/g,_TRANS_ATK).replace(/DEF/g,_TRANS_DEF).replace(/MOV/g,_TRANS_MOV);;
            caption +="</font>" ;
            caption += "</textFormat>";
            return caption;
        }

        // 発動条件を抜き出す
        private function getConditionString(s:String):String
        {
            if (s.charAt(0) != "[") return "";
            var cnt:uint = 0;
            var condition_start_idx:uint = 1;
            var condition_end_idx:uint = 0;
            for (var i:int = 0; i < s.length; i++) {
                if (s.charAt(i) == "[")
                {
                    cnt += 1;
                }
                else if (s.charAt(i) == "]")
                {
                    cnt -= 1;
                    if (cnt == 0 && i < s.length - 1)
                    {
                        condition_end_idx = i - 1;
                        break;
                    }
                }
            }
            return s.slice(condition_start_idx, condition_end_idx + 1);
        }

        // 後始末処理
        private function finalizeFeatInfo():void
        {
            _nameLabelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
                    removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
                    removeChild(item);
                });
            _panelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    removeChild(item);
                });
            _hideTween.removeEventListener(TweenEvent.COMPLETE, hideCaptionArea);

        }

        // 後始末処理
        private function finalizeFoeFeatInfo():void
        {
            _foeNameLabelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    removeEventListener(MouseEvent.MOUSE_OVER, mouseOverFoeHandler);
                    removeEventListener(MouseEvent.MOUSE_OUT, mouseOutFoeHandler);
                    removeChild(item);
                });
            _foePanelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    removeChild(item);
                });
            _hideTween.removeEventListener(TweenEvent.COMPLETE, hideCaptionArea);
        }

        private function plCharaCardChangeHandler(e:Event):void
        {
            finalizeFeatInfo();
            plCharaCardChange();
        }

        private function plCharaCardChange():void
        {
            initializeFeatInfo();
            GameCtrl.instance.addNoWaitViewSequence(getPlayerBringOnThread());
        }

        private function foeCharaCardChangeHandler(e:Event):void
        {
            finalizeFoeFeatInfo();
            foeCharaCardChange();
        }

        private function foeCharaCardChange():void
        {
//            initializeFeatInfo();
            initializeFoeFeatInfo();
            GameCtrl.instance.addNoWaitViewSequence(getFoeBringOnThread());
        }


        // マウスで触れたときのハンドラ
        public function mouseOverHandler(e:MouseEvent):void
        {
            parent.addChild(_captionArea)
            _captionArea.htmlText = _captionArray[_nameLabelArray.indexOf(e.currentTarget)];
            _captionArea.x = e.currentTarget.x-12;
            _captionArea.validateNow();
            _captionArea.height = _captionArea.textHeight+16;
            _captionArea.y = e.currentTarget.y - _captionArea.height;
            _hideTween.stop();
            _showTween.play();
        }

        // マウスで触れたときのハンドラ
        public function mouseOverFoeHandler(e:MouseEvent):void
        {
            parent.addChild(_captionArea)
            _captionArea.htmlText = _foeCaptionArray[_foeNameLabelArray.indexOf(e.currentTarget)];
            _captionArea.x = e.currentTarget.x-5;
            _captionArea.validateNow();
            _captionArea.height = _captionArea.textHeight+16; // 初回にtextHeightがおかしくなることがある
            _captionArea.y = e.currentTarget.y + 26;
            _hideTween.stop();
            _showTween.play();
        }

        // マウスをはずしたときのハンドラ
        public function mouseOutHandler(e:MouseEvent):void
        {
            _showTween.stop();
            _hideTween.play();
        }

        // マウスをはずしたときのハンドラ
        public function mouseOutFoeHandler(e:MouseEvent):void
        {
            _showTween.stop();
            _hideTween.play();
        }

        private function hideCaptionArea(e:TweenEvent):void
        {
            parent.removeChild(_captionArea)

        }

        // 必殺技使用時のハンドラ
        public function featOnHandler(e:FeatInfoEvent):void
        {
            var handle:int = _featIdArray.indexOf(e.id);
            if(handle != -1)
            {
                _nameLabelArray[handle].styleName = "FeatInfoLabelFlash";
                _panelArray[handle].setBase(true);
            }
        }

        // 必殺技未使用時のハンドラ
        public function featOffHandler(e:FeatInfoEvent):void
        {
            var handle:int = _featIdArray.indexOf(e.id);
            if(handle != -1)
            {
                featOff(handle);
            }
        }

        // 必殺技変更時のハンドラ
        public function plFeatChangeHandler(e:FeatInfoChangeEvent):void
        {
            updatePlFeatInfoAt(e.chara_index, e.feat_index, e.feat_id, e.feat_no);
        }

        // 必殺技変更時のハンドラ
        public function foeFeatChangeHandler(e:FeatInfoChangeEvent):void
        {
            updateFoeFeatInfoAt(e.chara_index, e.feat_index, e.feat_id, e.feat_no);
        }

        // 必殺技をリセットするハンドラ
        public function allFeatOffHandler(e:FeatInfoEvent):void
        {
            _nameLabelArray.forEach(function(item:*, index:int, array:Array):void{featOff(index)});
        }

        // FeatをOff
        private function featOff(i:int):void
        {
            _nameLabelArray[i].styleName = "FeatInfoLabel";
            _panelArray[i].setBase(false);
        }


        // 実画面に表示するスレッドを返す
        public function getPlayerBringOnThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var sExec2:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            _nameLabelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    item.alpha = 0.0;
                    sExec.addThread(new BeTweenAS3Thread(item, {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
                });
            pExec.addThread(sExec);

            _panelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    item.alpha = 0.0;
                    sExec2.addThread(new BeTweenAS3Thread(item, {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
                });
            pExec.addThread(sExec2);
            return pExec;
        }

        // 実画面に表示するスレッドを返す
        public function getFoeBringOnThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var sExec2:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            _foeNameLabelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    item.alpha = 0.0;
                    sExec.addThread(new BeTweenAS3Thread(item, {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
                });
            pExec.addThread(sExec);

            _foePanelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    item.alpha = 0.0;
                    sExec2.addThread(new BeTweenAS3Thread(item, {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
                });
            pExec.addThread(sExec2);
            return pExec;
        }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(getPlayerBringOnThread());
            pExec.addThread(getFoeBringOnThread());
            return pExec;
        }

        // 実画面に表示するスレッドを返す
        public function getBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            _nameLabelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
                });
            _panelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
                });

            _foeNameLabelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
                });

            _foePanelArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
                });

            return pExec;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
           _depthAt = at;
           return new ShowThread(this, stage)
        }

        // 隠すスレッドを返す
        public override function getHideThread(type:String = ""):Thread
        {
            getBringOffThread().start();
            return super.getHideThread(type);
        }


    }
}
// Duelのロードを待つShowスレッド

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.Duel;
import view.scene.game.FeatInfo;
import view.BaseShowThread;

class ShowThread extends BaseShowThread
{
    private var _fip:FeatInfo;
    private var _at:int;

    public function ShowThread(fip:FeatInfo, stage:DisplayObjectContainer)
    {
        super(fip,stage)
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


