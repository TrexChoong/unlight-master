package view.scene.match
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.filters.GlowFilter;
    import flash.filters.BlurFilter;
    import flash.filters.DropShadowFilter;
    import flash.ui.Keyboard;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.ClousureThread;
    import view.image.match.*;
    import view.scene.BaseScene;
    import view.scene.common.AvatarClip;
    import view.scene.edit.CharaCardDeckClip;
    import view.scene.common.CharaCardClip;

    import model.*;
    import model.events.*;

    /**
     * マッチング画面のデータ表示部分のクラス
     *
     */
    public class DataArea extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_BT_SINGLE		:String = "シングルバトル";
        CONFIG::LOCALE_JP
        private static const _TRANS_BT_MULTI		:String = "マルチバトル";
        CONFIG::LOCALE_JP
        private static const _TRANS_BT_TEAM		:String = "チームバトル";
        CONFIG::LOCALE_JP
        private static const _TRANS_BT_BOSS		:String = "ボスバトル";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_ROOM		:String = "選択中のルームのデータです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_ROOMNAME	:String = "ルームの名前です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_RULE		:String = "対戦ルールです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_AVA		:String = "ルームにいるアバターの名前です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_RATE		:String = "アバターのレーティングです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_ORDER		:String = "アバターの勝敗です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_GUILD		:String = "アバターの勝率です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_POINT		:String = "アバターの総合ポイントです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_COMMENT	:String = "アバターのコメントです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_WL		:String = "勝敗";
        CONFIG::LOCALE_JP
        private static const _TRANS_WL_W		:String = "勝";
        CONFIG::LOCALE_JP
        private static const _TRANS_WL_L		:String = "負";
        CONFIG::LOCALE_JP
        private static const _TRANS_WL_E		:String = "分";
        CONFIG::LOCALE_JP
        private static const _TRANS_WL_PERCENT		:String = "勝率";

        CONFIG::LOCALE_EN
        private static const _TRANS_BT_SINGLE		:String = "Single Battle";
        CONFIG::LOCALE_EN
        private static const _TRANS_BT_MULTI		:String = "Multi Battle";
        CONFIG::LOCALE_EN
        private static const _TRANS_BT_TEAM		:String = "Team Battle";
        CONFIG::LOCALE_EN
        private static const _TRANS_BT_BOSS		:String = "Boss Battle";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_ROOM		:String = "Information about the selected room.";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_ROOMNAME	:String = "Name of this room.";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_RULE		:String = "Rules of this battle.";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_AVA		:String = "Names of avatars in this room.";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_RATE		:String = "Avatar's rating.";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_ORDER		:String = "Avatar's ranking.";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_GUILD		:String = "Avatar's victory rate.";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_POINT		:String = "Avatar's accumulated points.";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_COMMENT	:String = "Avatar's comments.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_WL		:String = "Outcome";
        CONFIG::LOCALE_EN
        private static const _TRANS_WL_W		:String = " wins, ";
        CONFIG::LOCALE_EN
        private static const _TRANS_WL_L		:String = " losses, ";
        CONFIG::LOCALE_EN
        private static const _TRANS_WL_E		:String = " draws";
        CONFIG::LOCALE_EN
        private static const _TRANS_WL_PERCENT		:String = "Victory Rate";

        CONFIG::LOCALE_TCN
        private static const _TRANS_BT_SINGLE		:String = "單人對戰";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BT_MULTI		:String = "多人對戰";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BT_TEAM		:String = "團隊對戰";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BT_BOSS		:String = "BOSS對戰";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_ROOM		:String = "選擇中對戰房的資訊。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_ROOMNAME	:String = "對戰房的名稱";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_RULE		:String = "對戰規則";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_AVA		:String = "在對戰間裏的虛擬人物的名稱。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_RATE		:String = "虛擬人物的評分。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_ORDER		:String = "虛擬人物的排名。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_GUILD		:String = "虛擬人物的勝率。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_POINT		:String = "虛擬人物的綜合分數。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_COMMENT	:String = "虛擬人物的簡介。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_WL		:String = "勝負";
        CONFIG::LOCALE_TCN
        private static const _TRANS_WL_W		:String = "勝";
        CONFIG::LOCALE_TCN
        private static const _TRANS_WL_L		:String = "負";
        CONFIG::LOCALE_TCN
        private static const _TRANS_WL_E		:String = "平";
        CONFIG::LOCALE_TCN
        private static const _TRANS_WL_PERCENT		:String = "勝率";

        CONFIG::LOCALE_SCN
        private static const _TRANS_BT_SINGLE		:String = "单人战斗";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BT_MULTI		:String = "多人对战";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BT_TEAM		:String = "团体战";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BT_BOSS		:String = "首领战";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_ROOM		:String = "选中的对战室的数据。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_ROOMNAME	:String = "对战室的名称。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_RULE		:String = "对战规则。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_AVA		:String = "对战室内的虚拟人物的名称。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_RATE		:String = "虚拟人物的等级划分。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_ORDER		:String = "虚拟人物的排名。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_GUILD		:String = "虚拟人物的取胜率。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_POINT		:String = "虚拟人物的综合分数。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_COMMENT	:String = "虚拟人物的简介。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_WL		:String = "胜负";
        CONFIG::LOCALE_SCN
        private static const _TRANS_WL_W		:String = "胜";
        CONFIG::LOCALE_SCN
        private static const _TRANS_WL_L		:String = "败";
        CONFIG::LOCALE_SCN
        private static const _TRANS_WL_E		:String = "分";
        CONFIG::LOCALE_SCN
        private static const _TRANS_WL_PERCENT		:String = "取胜率";

        CONFIG::LOCALE_KR
        private static const _TRANS_BT_SINGLE		:String = "싱글 배틀";
        CONFIG::LOCALE_KR
        private static const _TRANS_BT_MULTI		:String = "멀티 배틀";
        CONFIG::LOCALE_KR
        private static const _TRANS_BT_TEAM		:String = "팀 배틀";
        CONFIG::LOCALE_KR
        private static const _TRANS_BT_BOSS		:String = "보스 배틀";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_ROOM		:String = "선택 중인 방의 데이터입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_ROOMNAME	:String = "방이름 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_RULE		:String = "대전 룰입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_AVA		:String = "룸에 있는 아바타의 이름입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_RATE		:String = "아바타의 레어도 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_ORDER		:String = "아바타의 순위입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_GUILD		:String = "아바타의 승률입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_POINT		:String = "아바타의 통합포인트  입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_COMMENT	:String = "아바타의 코멘트입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_WL		:String = "승패";
        CONFIG::LOCALE_KR
        private static const _TRANS_WL_W		:String = "승";
        CONFIG::LOCALE_KR
        private static const _TRANS_WL_L		:String = "패";
        CONFIG::LOCALE_KR
        private static const _TRANS_WL_E		:String = "무";
        CONFIG::LOCALE_KR
        private static const _TRANS_WL_PERCENT		:String = "승률";

        CONFIG::LOCALE_FR
        private static const _TRANS_BT_SINGLE		:String = "Solo";
        CONFIG::LOCALE_FR
        private static const _TRANS_BT_MULTI		:String = "Multijoueur";
        CONFIG::LOCALE_FR
        private static const _TRANS_BT_TEAM		:String = "Combat en équipe";
        CONFIG::LOCALE_FR
        private static const _TRANS_BT_BOSS		:String = "Affrontez le Boss";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_ROOM		:String = "Information de la Salle sélectionnée";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_ROOMNAME	:String = "Nom de la Salle";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_RULE		:String = "Règles des Duels en ligne";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_AVA		:String = "Nom des avatars présents dans la Salle";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_RATE		:String = "Evaluation de votre avatar";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_ORDER		:String = "Classement de votre avatar";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_GUILD		:String = "Statistiques de votre avatar";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_POINT		:String = "Total des points de votre avatar";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_COMMENT	:String = "Commentaires concernant votre avatar";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_WL		:String = "Victoire ou Défaite";
        CONFIG::LOCALE_FR
        private static const _TRANS_WL_W		:String = " VICTOIRES ";
        CONFIG::LOCALE_FR
        private static const _TRANS_WL_L		:String = " DEFAITES ";
        CONFIG::LOCALE_FR
        private static const _TRANS_WL_E		:String = " NULS";
        CONFIG::LOCALE_FR
        private static const _TRANS_WL_PERCENT		:String = "Victoire %";

        CONFIG::LOCALE_ID
        private static const _TRANS_BT_SINGLE		:String = "シングルバトル";
        CONFIG::LOCALE_ID
        private static const _TRANS_BT_MULTI		:String = "マルチバトル";
        CONFIG::LOCALE_ID
        private static const _TRANS_BT_TEAM		:String = "チームバトル";
        CONFIG::LOCALE_ID
        private static const _TRANS_BT_BOSS		:String = "ボスバトル";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_ROOM		:String = "選択中のルームのデータです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_ROOMNAME	:String = "ルームの名前です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_RULE		:String = "対戦ルールです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_AVA		:String = "ルームにいるアバターの名前です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_RATE		:String = "アバターのレーティングです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_ORDER		:String = "アバターの勝敗です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_GUILD		:String = "アバターの勝率です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_POINT		:String = "アバターの総合ポイントです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_COMMENT	:String = "アバターのコメントです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_WL		:String = "勝敗";
        CONFIG::LOCALE_ID
        private static const _TRANS_WL_W		:String = "勝";
        CONFIG::LOCALE_ID
        private static const _TRANS_WL_L		:String = "負";
        CONFIG::LOCALE_ID
        private static const _TRANS_WL_E		:String = "分";
        CONFIG::LOCALE_ID
        private static const _TRANS_WL_PERCENT		:String = "勝率";

        CONFIG::LOCALE_TH
        private static const _TRANS_BT_SINGLE       :String = "ซิงเกิลแบทเทิล";//"シングルバトル";
        CONFIG::LOCALE_TH
        private static const _TRANS_BT_MULTI        :String = "มัลติแบทเทิล";//"マルチバトル";
        CONFIG::LOCALE_TH
        private static const _TRANS_BT_TEAM     :String = "ทีมแบทเทิล";//"チームバトル";
        CONFIG::LOCALE_TH
        private static const _TRANS_BT_BOSS     :String = "บอสแบทเทิล";//"ボスバトル";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_ROOM       :String = "ข้อมูลห้องที่เลือกอยู่";//"選択中のルームのデータです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_ROOMNAME   :String = "ชื่อห้อง";//"ルームの名前です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_RULE       :String = "กฎการต่อสู้";//"対戦ルールです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_AVA        :String = "ชื่อของอวาตาร์ที่อยู่ในห้อง";//"ルームにいるアバターの名前です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_RATE       :String = "ขั้นของอวาตาร์";//"アバターのレーティングです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_ORDER      :String = "ลำดับของอวาตาร์";//"アバターの勝敗です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_GUILD      :String = "อัตราการชนะของอวาตาร์";//"アバターの勝率です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_POINT      :String = "แต้มโดยรวมของอวาตาร์";//"アバターの総合ポイントです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_COMMENT    :String = "ความคิดเห็นของอวาตาร์";//"アバターのコメントです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_WL      :String = "ผลการต่อสู้";//"勝敗";
        CONFIG::LOCALE_TH
        private static const _TRANS_WL_W        :String = "ชนะ";//"勝";
        CONFIG::LOCALE_TH
        private static const _TRANS_WL_L        :String = "แพ้";//"負";
        CONFIG::LOCALE_TH
        private static const _TRANS_WL_E        :String = "ครั้ง";//"分";
        CONFIG::LOCALE_TH
        private static const _TRANS_WL_PERCENT      :String = "อัตราการชนะ";//"勝率";


        // マッチインスタンス
        private var _match:Match = Match.instance;

        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

        // 基本表示
        private var _base:RoomDataBase;                               // 部屋ベース
        private var _stg:RoomDataStageBase;                           // ステージベース
        private var _name:Label;                                      // 部屋名表示
        private var _rule:Label;                                      // レベルラベル
//         private var _gameStage:GameStage = new GameStage();        // ステージ表示

        // アバター表示
        private var _avatarLevel:Array = [];                           // Array of Label
        private var _avatarName:Array = [];                            // Array of Label
        private var _avatarPointTitle:Array = [];                      // Array of Label
        private var _avatarPoint:Array = [];                           // Array of Label
        private var _avatarResultTitle:Array = [];                     // Array of Label
        private var _avatarResult:Array = [];                          // Array of Label
        private var _avatarPercentTitle:Array = [];                    // Array of Label
        private var _avatarPercent:Array = [];                         // Array of Label
        private var _avatarCardClip:Array = [];                        // Array of CharaCardClip
        private var _avatarClip:Array = [];                            // Array of AvatarClip
        private var _avatarClipContainer:UIComponent = new UIComponent();
//         private var _avatarLevel:Array = [];                          // Array of Label

        // 定数
        private const _NAME_X:int = 475;                              // 部屋名X
        private const _NAME_Y:int = 50;                               // 部屋名Y
        private const _NAME_WIDTH:int = 320;                          // 部屋名幅
        private const _NAME_HEIGHT:int = 20;                          // 部屋名高さ

        private const _RULE_X:int = 781;                              // ルールX
        private const _RULE_Y:int = 52;                               // ルールY
        private const _RULE_WIDTH:int = 130;                          // ルール横幅
        private const _RULE_HEIGHT:int = 20;                          // ルール高さ

        private const _AVATAR_CLIP_X:int = 387;                      // アバターイメージX
        private const _AVATAR_CLIP_Y:int = 35;                       // アバターイメージY
//        private const _AVATAR_CLIP_SCALE:Number = 0.77;               // アバターイメージ幅
        private const _AVATAR_CLIP_OFFSET_X:int = 257;                // アバターイメージXずれ
        private const _AVATAR_CLIP_OFFSET_Y:int = 121;                // アバターイメージYずれ

        private const _DATA_X:int = 468;                              // アバター情報X
        private const _DATA_Y:int = 65;                               // アバター情報Y
        private const _DATA_WIDTH:int = 80;                           // アバター情報の高さ
        private const _DATA_HEIGHT:int = 20;                          // アバター情報の横幅
        private const _DATA_OFFSET_Y:int = 24;                        // アバター情報Yのずれ

        private const _DATA_TITLE_X:int = 474;                        // アバター情報X
        private const _DATA_TITLE_Y:int = 53;                        // アバター情報Y
        private const _DATA_TITLE_WIDTH:int = 65;                     // アバター情報の高さ
        private const _DATA_TITLE_HEIGHT:int = 20;                    // アバター情報の横幅
        private const _DATA_TITLE_OFFSET_Y:int = 24;                  // アバター情報Yのずれ

        private const _COMMENT_X:int = 760;                           // アバターコメントX
        private const _COMMENT_Y:int = 130;                            // アバターコメントY
        private const _COMMENT_WIDTH:int = 95;                        // アバターコメントの高さ
        private const _COMMENT_HEIGHT:int = 95;                       // アバターコメントの横幅
        private const _COMMENT_OFFSET_X:int = -52;                    // アバターコメントのずれX
        private const _COMMENT_OFFSET_Y:int = 229;                    // アバターコメントのずれY

        private const _CARD_X:int = 555;                              // カード情報X
        private const _CARD_Y:int = 35;                               // カード情報Y
//        private const _CARD_OFFSET_X:int = 85;                         // カード情報X

        private const _CARD_OFFSET_X:int = 0;                         // カード情報X
        private const _CARD_OFFSET_Y:int = 122;                       // カード情報Y
        private const _CARD_OFFSET_WIDTH_X:Array = [47, -47];                       // カード情報Y
        private const _CARD_OFFSET_WIDTH_X_2:Array = [0, -74];                       // カード情報Y
        private const _CARD_SCALE:Number = 0.5;                       // カード情報Y

        private const _AVATAR_DATA_OFFSET_X:int = 97;                // アバター情報のずれX
        private const _AVATAR_DATA_OFFSET_Y:int = 122;                // アバター情報のずれY

//        private const _RULES:Array = ["シングルバトル",         // 1枚デッキ
//                                      "マルチバトル",           // 3枚デッキ
//                                      "チームバトル",                 // チーム戦
//                                      "ボスバトル"];                  // 討伐戦
        private const _RULES:Array = [_TRANS_BT_SINGLE,         // 1枚デッキ
                                      _TRANS_BT_MULTI,           // 3枚デッキ
                                      _TRANS_BT_TEAM,                 // チーム戦
                                      _TRANS_BT_BOSS];                  // 討伐戦
        private const _RULES_CARDS_NUM:Array = [1,         // 1枚デッキ
                                                3,           // 3枚デッキ
            ];


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["選択中のルームのデータです。",
//                 "ルームの名前です。",
//                 "対戦ルールです。",
//                 "ルームにいるアバターの名前です。",
//                 "アバターのレーティングです。",
//                 "アバターの勝敗です。",
//                 "アバターの所属ギルドです。",
//                 "アバターの総合ポイントです。",
//                 "アバターのコメントです。",],
                [_TRANS_HELP_ROOM,
                 _TRANS_HELP_ROOMNAME,
                 _TRANS_HELP_RULE,
                 _TRANS_HELP_AVA,
                 _TRANS_HELP_RATE,
                 _TRANS_HELP_ORDER,
                 _TRANS_HELP_GUILD,
                 _TRANS_HELP_POINT,
                 _TRANS_HELP_COMMENT,],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _MATCH_HELP:int = 0;

        // クリック連打で更新しないように前回のIDを記録
        private var _beforeID:String;

        /**
         * コンストラクタ
         *
         */
        public function DataArea()
        {
            initializeBase();
            finalizeData();
            addChild(_container);
            addChild(_avatarClipContainer);
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray = [];
            _toolTipOwnerArray.push([0,this]);  //
            _toolTipOwnerArray.push([1,_name]);  //
            _toolTipOwnerArray.push([2,_rule]);  //
            _avatarName.forEach(function(item:*, index:int, array:Array):void{_toolTipOwnerArray.push([3,item])});  //
            _avatarPoint.forEach(function(item:*, index:int, array:Array):void{_toolTipOwnerArray.push([4,item])});  //
            _avatarResult.forEach(function(item:*, index:int, array:Array):void{_toolTipOwnerArray.push([5,item])});  //
            _avatarPercent.forEach(function(item:*, index:int, array:Array):void{_toolTipOwnerArray.push([6,item])});  //
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
            _match.addEventListener(MatchEvent.CREATE_SUCCESS, roomCreateHandler);
            _match.addEventListener(MatchEvent.EXIT_ROOM, roomExitHandler);
            _match.addEventListener(Match.ROOM_CLICK, roomClickHandler);
            _match.addEventListener(Match.ROOM_OVER, roomOverHandler);
            _match.addEventListener(Match.ROOM_OUT, roomOutHandler);

            initilizeToolTipOwners();
            updateHelp(_MATCH_HELP);
        }

        // 終了
        public override function final():void
        {
            _match.removeEventListener(MatchEvent.CREATE_SUCCESS, roomCreateHandler);
            _match.removeEventListener(MatchEvent.EXIT_ROOM, roomExitHandler);
            _match.removeEventListener(Match.ROOM_CLICK, roomClickHandler);
            _match.removeEventListener(Match.ROOM_OVER, roomOverHandler);
            _match.removeEventListener(Match.ROOM_OUT, roomOutHandler);
            finalizeData();
            _avatarCardClip.forEach(function(item:*, index:int, array:Array):void{
                    item.forEach(function(acc:*, index:int, array:Array):void{
                            acc.getEditHideThread().start()
                                });
                });

        }

        // ルームに触れた時のハンドラ
        private function roomOverHandler(e:Event):void
        {
            _match.removeEventListener(Match.ROOM_OVER, roomOverHandler);
            _match.addEventListener(Match.ROOM_OUT, roomOutHandler);
        }

        // ルームから離れた時のハンドラ
        private function roomOutHandler(e:Event):void
        {
            _match.addEventListener(Match.ROOM_OVER, roomOverHandler);
            _match.removeEventListener(Match.ROOM_OUT, roomOutHandler);
        }

        // カレントルームが変化した時のハンドラ
        private function roomClickHandler(e:Event):void
        {
            visible = true;
            if (_match.currentRoomId != _beforeID)
            {
                _beforeID = _match.currentRoomId;
                finalizeData();
                addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            }
        }

        // ルームを作った時のハンドラ
        private function roomCreateHandler(e:MatchEvent):void
        {
            finalizeData();
            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

        // ルームがけされた時のハンドラ
        private function roomExitHandler(e:MatchEvent):void
        {
            finalizeData();
            _beforeID = ""
        }

        // 毎フレーム呼ばれるハンドラ
        private function enterFrameHandler(e:Event):void
        {
            if(MatchRoom.list[_match.currentRoomId]&&!_match.isQuick)
            {
                finalizeData();
                initializeData(MatchRoom.list[_match.currentRoomId]);
                removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            }
        }

        // ベース部分を表示
        private function initializeBase():void
        {
            _base = new RoomDataBase();
            _stg = new RoomDataStageBase();
            _name = new Label();
            _rule = new Label();

            _name.x = _NAME_X;
            _name.y = _NAME_Y;
            _name.width = _NAME_WIDTH;
            _name.height = _NAME_HEIGHT;
            _name.styleName = "GameLobbyRoomNameLabel"

            _rule.x = _RULE_X;
            _rule.y = _RULE_Y;
            _rule.width = _RULE_WIDTH;
            _rule.height = _RULE_HEIGHT;
            _rule.styleName = "GameLobbyRoomRuleLabel";

            _container.addChild(_stg);
            _container.addChild(_base);
//             _container.addChild(_name);
//             _container.addChild(_rule);

            for(var i:int = 0; i < 2; i++)
            {
                _avatarLevel.push(new Label());
                _avatarLevel[i].x = _DATA_TITLE_X + _AVATAR_DATA_OFFSET_X * i;
                _avatarLevel[i].y = _DATA_TITLE_Y + _AVATAR_DATA_OFFSET_Y * i;
                _avatarLevel[i].filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
                _container.addChild(_avatarLevel[i]);

                _avatarName.push(new Label());
                _avatarName[i].x = _DATA_X + _AVATAR_DATA_OFFSET_X * i;
                _avatarName[i].y = _DATA_Y + _AVATAR_DATA_OFFSET_Y * i;
                _avatarName[i].filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
                _container.addChild(_avatarName[i]);

                _avatarPointTitle.push(new Label());
                _avatarPointTitle[i].x = _DATA_TITLE_X + _AVATAR_DATA_OFFSET_X * i;
                _avatarPointTitle[i].y = _DATA_TITLE_Y + _AVATAR_DATA_OFFSET_Y * i + _DATA_OFFSET_Y * 1;
                _avatarPointTitle[i].filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
                _container.addChild(_avatarPointTitle[i]);

                _avatarPoint.push(new Label());
                _avatarPoint[i].x = _DATA_X + _AVATAR_DATA_OFFSET_X * i;
                _avatarPoint[i].y = _DATA_Y + _AVATAR_DATA_OFFSET_Y * i + _DATA_OFFSET_Y * 1;
                _avatarPoint[i].filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
                _container.addChild(_avatarPoint[i]);

                _avatarResultTitle.push(new Label());
                _avatarResultTitle[i].x = _DATA_TITLE_X + _AVATAR_DATA_OFFSET_X * i;
                _avatarResultTitle[i].y = _DATA_TITLE_Y + _AVATAR_DATA_OFFSET_Y * i + _DATA_OFFSET_Y * 2;
                _avatarResultTitle[i].filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
                _container.addChild(_avatarResultTitle[i]);

                _avatarResult.push(new Label());
                _avatarResult[i].x = _DATA_X + _AVATAR_DATA_OFFSET_X * i;
                _avatarResult[i].y = _DATA_Y + _AVATAR_DATA_OFFSET_Y * i + _DATA_OFFSET_Y * 2;
                _avatarResult[i].filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
                _container.addChild(_avatarResult[i]);

                _avatarPercentTitle.push(new Label());
                _avatarPercentTitle[i].x = _DATA_TITLE_X + _AVATAR_DATA_OFFSET_X * i;
                _avatarPercentTitle[i].y = _DATA_TITLE_Y + _AVATAR_DATA_OFFSET_Y * i + _DATA_OFFSET_Y * 3;
                _avatarPercentTitle[i].filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
                _container.addChild(_avatarPercentTitle[i]);

                _avatarPercent.push(new Label());
                _avatarPercent[i].x = _DATA_X + _AVATAR_DATA_OFFSET_X * i;
                _avatarPercent[i].y = _DATA_Y + _AVATAR_DATA_OFFSET_Y * i + _DATA_OFFSET_Y * 3;
                _avatarPercent[i].filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
                _container.addChild(_avatarPercent[i]);

//                _container.addChild(_avatarComment[i]);

                _avatarLevel[i].width = _avatarName[i].width = _avatarPointTitle[i].width =  _avatarPercentTitle[i].width = _avatarResultTitle[i].width = _avatarPoint[i].width = _avatarResult[i].width = _avatarPercent[i].width = _DATA_WIDTH;
                _avatarLevel[i].height = _avatarName[i].height = _avatarPointTitle[i].height =  _avatarPercentTitle[i].height = _avatarResultTitle[i].height =  _avatarPoint[i].height = _avatarResult[i].height = _avatarPercent[i].height = _DATA_HEIGHT;
                _avatarLevel[i].styleName = _avatarPointTitle[i].styleName = _avatarPercentTitle[i].styleName = _avatarResultTitle[i].styleName ="GameLobbyRoomAvatarDataTitleLabel";
                _avatarName[i].styleName = _avatarPoint[i].styleName = _avatarResult[i].styleName = _avatarPercent[i].styleName  = "GameLobbyRoomAvatarDataLabel";
            }

            initilizeToolTipOwners();
            updateHelp(_MATCH_HELP);
        }

        // データ部分を表示
        private function initializeData(room:MatchRoom):void
        {
            var sExc:SerialExecutor = new SerialExecutor();
            var pExc:ParallelExecutor = new ParallelExecutor();
            log.writeLog(log.LV_INFO, this, "initialize data");

            // キャラカードクリップの初期化
            _avatarCardClip = [];
            log.writeLog(log.LV_INFO, this, "avatarCcID is", room.avatarCcId);
            _avatarClip = [];
            // 部屋データの初期化
            for(var i:int = 0; i < room.length; i++)
            {
                _avatarCardClip[i] = [];

//                _avatarClip[i] = new AvatarClip(OtherAvatar.ID(room.avatarId[i]));
                _avatarClip[i] = new AvatarClip(OtherAvatar.ID(room.avatarId[i]));
                _avatarClip[i].x = _AVATAR_CLIP_X + _AVATAR_CLIP_OFFSET_X * i;
                _avatarClip[i].y = _AVATAR_CLIP_Y + _AVATAR_CLIP_OFFSET_Y * i;
                if (i==1){
                    _avatarClip[i].scaleX = -1;
                    _avatarClip[i].x += 98;
                        };
                _avatarClip[i].filters = [new GlowFilter(0x000000, 1, 1, 1, 1, 3, false, false)];
                _avatarClip[i].type = Const.PL_AVATAR_MATCH_ROOM;

                pExc.addThread(_avatarClip[i].getShowThread(_avatarClipContainer, -1));

//                log.writeLog(log.LV_INFO, this, "room_avatar!!!!!!!!!!!!!!!", room);

                _avatarLevel[i].text = "Level."+ room.avatarLevel[i];
                _avatarName[i].text = room.avatarName[i];
                _avatarPointTitle[i].text = "BattlePoint";
                _avatarPoint[i].text = room.avatarPoint[i]; // room.avatarPoint[i];
//                _avatarResultTitle[i].text = "勝敗";
                _avatarResultTitle[i].text = _TRANS_MSG_WL;
////                _avatarResult[i].text = room.avatarWin[i] + "勝" + room.avatarLose[i] + "負" + room.avatarDraw[i] + "分"; // room.avatarResult[i];
//                _avatarResult[i].text = room.avatarWin[i] + _TRANS_WL_W + room.avatarLose[i] + _TRANS_WL_L + room.avatarDraw[i] + _TRANS_WL_E; // room.avatarResult[i];
//                _avatarResult[i].text = room.avatarWin[i] + "勝" + room.avatarLose[i] + "敗"; // room.avatarResult[i];
                _avatarResult[i].text = room.avatarWin[i] + _TRANS_WL_W + room.avatarLose[i] + _TRANS_WL_L; // room.avatarResult[i];
//                _avatarPercentTitle[i].text = "勝率";
                _avatarPercentTitle[i].text = _TRANS_WL_PERCENT;
                _avatarPercent[i].text = int((room.avatarWin[i] /(room.avatarWin[i] + room.avatarLose[i] + room.avatarDraw[i])) * 100) + "％"; // room.avatarPercent[i];

//                log.writeLog(log.LV_FATAL, this, "!!!!!!!!!!",room.avatarCcId[i]);
                for(var j:int = 0; j < _RULES_CARDS_NUM[room.rule]; j++)
                {
                    if(room.avatarCcId[i][j] != "-1")
                    {
                        _avatarCardClip[i].push(new CharaCardClip(CharaCard.ID(room.avatarCcId[i][j]), true));
                        _avatarCardClip[i][j].x = _CARD_X + _CARD_OFFSET_X * i + _CARD_OFFSET_WIDTH_X[i]*j + _CARD_OFFSET_WIDTH_X_2[i];
                        _avatarCardClip[i][j].y = _CARD_Y + _CARD_OFFSET_Y * i;
                        _avatarCardClip[i][j].scaleX = _CARD_SCALE;
                        _avatarCardClip[i][j].scaleY = _CARD_SCALE;
                        _avatarCardClip[i][j].getUnrotateShowThread(_container,j+30).start();
                    }
                    else if(room.avatarCcId[i][j] == "-1")
                    {
                        _avatarCardClip[i].push(new CharaCardClip(CharaCard.ID(0),true));
                        _avatarCardClip[i][j].x = _CARD_X + _CARD_OFFSET_X * i + _CARD_OFFSET_WIDTH_X[i]*j + _CARD_OFFSET_WIDTH_X_2[i];
                        _avatarCardClip[i][j].y = _CARD_Y + _CARD_OFFSET_Y * i;
                        _avatarCardClip[i][j].scaleX = _CARD_SCALE;
                        _avatarCardClip[i][j].scaleY = _CARD_SCALE;
                        _avatarCardClip[i][j].getUnrotateShowThread(_container,j+30).start();
                    }
                }
            }

            sExc.addThread(pExc);
            sExc.addThread(new ClousureThread(hideAvatarClip));
            sExc.start();
            _name.text = room.name;
            _rule.text = _RULES[room.rule];
            _rule.styleName = "GameLobbyRoomRuleLabel"
            _container.visible = true;
            _avatarClipContainer.visible = true;
        }

        // 表示されているアバターをすべて消す
        private function hideAvatarClip():void
        {
            for(var j:int = 0; j < _avatarClipContainer.numChildren; j++){
                _avatarClipContainer.getChildAt(j).visible = false;
            }
            _avatarClip.forEach(function(item:*, index:int, array:Array):void{item.visible = true});

        }


        // データ部分の非表示
        private function finalizeData():void
        {
            log.writeLog(log.LV_INFO, this, "finalize data");

            _name.text = "";
            _rule.text = "";
            // アバターイメージの初期化
//            _avatarClip.forEach(function(item:*, index:int, array:Array):void{item.getHideThread().start();});
//            _avatarClip.forEach(function(item:*, index:int, array:Array):void{item.visible = false});

            // 表示されているアバターをすべて消す
            for(var i:int = 0; i < _avatarClipContainer.numChildren; i++){
                AvatarClip(_avatarClipContainer.getChildAt(i)).getHideThread().start();
            }
            _avatarLevel.forEach(function(item:*, index:int, array:Array):void{item.text = ""});
            _avatarName.forEach(function(item:*, index:int, array:Array):void{item.text = ""});
            _avatarPointTitle.forEach(function(item:*, index:int, array:Array):void{item.text = ""});
            _avatarPoint.forEach(function(item:*, index:int, array:Array):void{item.text = ""});
            _avatarResultTitle.forEach(function(item:*, index:int, array:Array):void{item.text = ""});
            _avatarResult.forEach(function(item:*, index:int, array:Array):void{item.text = ""});
            _avatarPercentTitle.forEach(function(item:*, index:int, array:Array):void{item.text = ""});
            _avatarPercent.forEach(function(item:*, index:int, array:Array):void{item.text = ""});
            _avatarCardClip.forEach(function(item:*, index:int, array:Array):void{
                    item.forEach(function(acc:*, index:int, array:Array):void{
                            acc.getEditHideThread().start()
                                });
                });
            _avatarClipContainer.visible = false;
            _container.visible = false;
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
    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.match.DataArea;


class ShowThread extends BaseShowThread
{
    public function ShowThread(da:DataArea, stage:DisplayObjectContainer, at:int)
    {
        super(da, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(da:DataArea)
    {
        super(da);
    }

}
