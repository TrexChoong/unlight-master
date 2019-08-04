package view.scene.lobby
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.*;
    import mx.events.ListEvent;
    import mx.events.ToolTipEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import model.*;
    import view.image.common.*;
    import view.image.quest.*;
    import view.scene.common.*;
    import view.utils.*;
    import view.*;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.scene.ModelWaitShowThread;
    import controller.LobbyCtrl;


    /**
     * ログインインフォ表示クラス
     *
     */

    public class NoticePanel extends BaseScene
    {
        // 選択したパーツIDを保持する
        public var __selectedPartTreasureId:Array = [];
        // 選択形式のノーティスのレコードIDを保持する
        public var __selectableAchiID:Array = [];

        // アバター
        private var _avatar:Avatar = Player.instance.avatar;

        // ベースイメージ
        private var _base:LoginInfoImage = new LoginInfoImage();

        // 各種ラベル
        private var _updateMessage:TextArea = new TextArea();    // 更新情報

        private var _title:Label = new Label();     // タイトル
        private var _message:Text = new Text();    // ブラウメッセージ
        private var _friendName:Text = new Text();    // ブラウメッセージ

        // 取得カード
        private var _tCardClip:TreasureCardClip;

        // 選択カード
        private var _selectableTreasure:Array = [];
        private var _selectableTreasureIds:Array = [];
        private var _selectableTreasureName:Array = [];
        private var _selectableCardClipSet:Array = [];
        private var _selectComboBox:ComboBox = new ComboBox();
        private var _argsSet:Array = [];

        // スルーするか
        private var _isThrough:Boolean = false;

        // レコード更新フラグ
        private var _isUpdAchievement:Boolean = false;

        // フェード
        private var _fade:Fade = new Fade(0.1, 0.5);

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        private var _currentNotice:LobbyNotice;

        private static const _Y:int = 0;
        private static const _START_Y:int = -120;

        private var _lastActivityMess:String = "";
        private var _lastActivityTitle:String = "";
        private var _lastActivityImage:String = "";

        // 翻訳データ
//        private static const _SELECT_ITEM	:String = "選択してください";
//        private static const _TRANS_GET	:String = "__NAME__を獲得しました。";
//        private static const _TRANS_INFO	:String = "情報";

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_UPDATE_INFO	:String = "更新情報";
        CONFIG::LOCALE_JP
        private static const _SELECT_ITEM	:String = "選択してください";
        CONFIG::LOCALE_JP
        private static const _TRANS_GET		:String = "__NAME__を獲得しました。";
        CONFIG::LOCALE_JP
        private static const _TRANS_INFO	:String = "情報";

        CONFIG::LOCALE_EN
        private static const _TRANS_UPDATE_INFO	:String = "Update Information";
        CONFIG::LOCALE_EN
        private static const _SELECT_ITEM	:String = "Please select";
        CONFIG::LOCALE_EN
        private static const _TRANS_GET		:String = "You received __NAME__.";
        CONFIG::LOCALE_EN
        private static const _TRANS_INFO	:String = "Information";

        CONFIG::LOCALE_TCN
        private static const _TRANS_UPDATE_INFO	:String = "更新情報";
        CONFIG::LOCALE_TCN
        private static const _SELECT_ITEM	:String = "請選擇";
        CONFIG::LOCALE_TCN
        private static const _TRANS_GET		:String = "獲得了__NAME__。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_INFO	:String = "情報";

        CONFIG::LOCALE_SCN
        private static const _TRANS_UPDATE_INFO	:String = "更新信息";
        CONFIG::LOCALE_SCN
        private static const _SELECT_ITEM	:String = "请选择";
        CONFIG::LOCALE_SCN
        private static const _TRANS_GET		:String = "获得了__NAME__。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_INFO	:String = "信息";

        CONFIG::LOCALE_KR
        private static const _TRANS_LOGIN_BONUS	:String = "어서 오십시오.\n 오늘의 보너스 아이템을 받아 주십시오.";
        CONFIG::LOCALE_KR
        private static const _TRANS_UPDATE_INFO	:String = "갱신 정보";
        CONFIG::LOCALE_KR
        private static const _SELECT_ITEM	:String = "選択してください";
        CONFIG::LOCALE_KR
        private static const _TRANS_GET		:String = "__NAME__を獲得しました。";
        CONFIG::LOCALE_KR
        private static const _TRANS_INFO	:String = "情報";

        CONFIG::LOCALE_FR
        private static const _TRANS_UPDATE_INFO	:String = "Mise à jour des informations";
        CONFIG::LOCALE_FR
        private static const _SELECT_ITEM	:String = "Veuillez choisir";
        CONFIG::LOCALE_FR
        private static const _TRANS_GET		:String = "Vous recevez __NAME__.";
        CONFIG::LOCALE_FR
        private static const _TRANS_INFO	:String = "Information";

        CONFIG::LOCALE_ID
        private static const _TRANS_UPDATE_INFO	:String = "更新情報";
        CONFIG::LOCALE_ID
        private static const _SELECT_ITEM	:String = "選択してください";
        CONFIG::LOCALE_ID
        private static const _TRANS_GET		:String = "__NAME__を獲得しました。";
        CONFIG::LOCALE_ID
        private static const _TRANS_INFO	:String = "情報";

        CONFIG::LOCALE_TH
        private static const _TRANS_UPDATE_INFO :String = "ข้อมูล Update";
        CONFIG::LOCALE_TH
        private static const _SELECT_ITEM	:String = "選択してください";
        CONFIG::LOCALE_TH
        private static const _TRANS_GET		:String = "__NAME__を獲得しました。";
        CONFIG::LOCALE_TH
        private static const _TRANS_INFO	:String = "情報";


    /**
     * Type
     * 0:ログインボーナス[アイテムタイプとアイテムIDと数]
     * 1:アチーブメント成功ボーナス「アイテムタイプとアイテムIDと数とアチーブメントID」
     * 2:新規アチーブメント「アチーブメントID」
     * 3:ログアウト中のパーツ削除「アイテムID」
     * 4:新しいフレンド認証待ちのが来た「相手の名前」
     * 5:プレゼントもらった「アイテムとIDもらった相手の名前」
     * 6:クエストをもらった「クエストIDともらった相手の名前」
     * 7:貸したものが帰ってきた「カードIDと相手の名前」
     * 8:招待した友人がゲームを始めた「アイテムタイプとアイテムIDと数と相手の名前」
     * 9:宣伝「画像ID」
     * 10:プレゼントしたクエストがクリアされた「相手の名前」
     * 11:カムバック依頼を出した相手が復帰した「相手の名前」
     * 12:久しぶりにUnlightをプレイした「自分の名前」
     * 13:セールを開始した「セール時間」
     * 14:ニコニコ版開始記念
     * 15:渦取得
     * 16:渦撃破:渦撃破報告「渦名」
     * 17:渦撃破:各種報酬内容「発見、参加、撃破、順位」
     * 18:渦撃破:ランキング報告「発見者名、自分の順位、ランキング」
     * 19:渦終了:タイムアップ
     * 20:中文3周年記念プレゼント
     * 21:お詫び
     * 22:新年
     * 23:招待されてゲームを始めた「アイテムタイプとアイテムIDと数」
     * 24:更新情報
     * 25:クリアコード取得
     * 26:アチーブメント成功ボーナス、選択ゲット
     */

        private static const _TITLE_SET:Array = ["Login Bonus",     // 0
                                                 "Record",          // 1
                                                 "Record",          // 2
                                                 "Avatar Parts",    // 3
                                                 "Friends",         // 4
                                                 "Present",         // 5
                                                 "Present",         // 6
                                                 "Card",            // 7
                                                 "Invitation",      // 8
                                                 "News",            // 9
                                                 "QuestBonus",      // 10
                                                 "Comeback",        // 11
                                                 "Comeback",        // 12
                                                 "Sale",            // 13
                                                 "Present",         // 14
                                                 "Get Profound",    // 15
                                                 "Finish Profound", // 16
                                                 "Finish Profound Reward", // 17
                                                 "Finish Profound Ranking", // 19
                                                 "Profound Failed", // 20
                                                 "Anniversary", // 21
                                                 "Apology", // 21
                                                 "NewYear",
                                                 "Invitation",      // 23
                                                 _TRANS_UPDATE_INFO, // 24
                                                 "Reward Code",      // 25
                                                 "Record",          // 26
            ]; /* of String */

        CONFIG::LOCALE_JP
        private static const _MESSAGE_SET:Array = [
            "いらっしゃいませお嬢様。\n本日のボーナスアイテム「__ITEM_NAME__」をお受け取りください。",                                                                    // 0
            "おめでとうございます。レコード「__ARCHIEVEMENT_CAPTION__」がクリアされました。記念アイテムをお受け取り下さい",                                               // 1
            "新しいレコード「__ARCHIEVEMENT_CAPTION__」が追加されました。\n是非、挑戦してみてください",                                                                   // 2
            "アバターパーツ「__AVATAR_PARTS__」が期限切れのため失われました",                                                                                             // 3
            "__FRIEND_NAME__さんからFriend認証の申し込みが来ています",                                                                                                    // 4
            "__FRIEND_NAME__さんからアイテムのプレゼントが届きました",                                                                                                    // 5
            "__FRIEND_NAME__さんからクエスト「__QUEST_NAME__」が届きました",                                                                                              // 6
            "__FRIEND_NAME__さんから貸していたカードが返却されました",                                                                                                    // 7
            "\nがゲームを始めました。\n記念のアイテムをお受け取りください",                                                                                               // 8
            "",                                                                                                                                                           // 9
            "__FRIEND_NAME__さんがプレゼントしたクエストをクリアしました\n ボーナスをお受け取りください",                                                                 // 10
            "__FRIEND_NAME__さんがUnlightに戻ってきました\n記念のアイテムをお受け取りください",                                                                           // 11
            "__FRIEND_NAME__さんおかえりなさい！\n記念のアイテムをお受け取りください",                                                                                    // 12
            "__SALE_TIME__セール開始しました！ 是非この機会にお試しください",                                                                                             // 13
            "Unlightの世界へようこそ！\n記念のアイテムをお受け取りください",                                                                                              // 14
            "__FRIEND_NAME__さんが渦「__PRF__」を発見しました！\n協力してボス「__B_NAME__」を撃破しましょう！\nボスの最大HPは「__B_HP__」です！",                         // 15
            "",                                                                                                                                                           // 16
            "",                                                                                                                                                           // 17
            "",                                                                                                                                                           // 18
            "渦「__PRF__」のボス「__B_NAME__」の撃破に失敗しました。",                                                                                                    // 19
            "Unlightをプレイして頂き、誠にありがとうございます！\n記念パーツ「__AVATAR_PARTS__」をお受け取り下さい",                                                      // 20
            "__DATE__に発生いたしました運営のトラブルにより、ご迷惑をお掛けしてしまい大変申し訳御座いませんでした。\nお詫びと致しまして以下のものをお受け取りください",   // 21
            "新年あけましておめでとうございます！年越しログインボーナスとして以下のものをお受け取りください",                                                             // 22
            "Unlightの世界へようこそ！\n招待特典のアイテムをお受け取りください",                                                                                          // 23
            "",                                                                                                                                                           // 24
            "レコード「__ARCHIEVEMENT_CAPTION__」がクリアされました。\n特典コードは[ __CODE_NUMBER__ ]です",                                                               // 25
            "おめでとうございます。レコード「__ARCHIEVEMENT_CAPTION__」がクリアされました。ボーナスを選択してください"                                               // 26
            ]; /* of String */

        CONFIG::LOCALE_TCN
        private static const _MESSAGE_SET:Array = [
            "歡迎光臨大小姐。\n請收下今天的獎勵道具「__ITEM_NAME__」",                                                  // 0
            "恭喜。您達成了「__ARCHIEVEMENT_CAPTION__」的成就。請收下紀念道具。",                                       // 1
            "追加了新的成就「__ARCHIEVEMENT_CAPTION__」。請您務必挑戰看看。",                                           // 2
            "虛擬人物配件的「__AVATAR_PARTS__」由於期限已到所以消失了。",                                               // 3
            "收到了來自 __FRIEND_NAME__的Friend申請確認。",                                                             // 4
            "收到了來自 __FRIEND_NAME__的禮品道具。",                                                                   // 5
            "收到了來自 __FRIEND_NAME__的禮品任務「__QUEST_NAME__」。",                                                 // 6
            "跟__FRIEND_NAME__借用的卡片已經被收回。",                                                                  // 7
            "\n開始遊戲了。請收下紀念的道具。",                                                                         // 8
            "",                                                                                                         // 9
            "__FRIEND_NAME__完成了任務。\n共有獎勵",                                                                    // 10
            "您的朋友__FRIEND_NAME__回到了Unlight。\n請收下紀念物品。",                                                 // 11
            "__FRIEND_NAME__,歡迎回來！\n請收下紀念物品。",                                                             // 12
            "開始進行__SALE_TIME__分鐘內的特賣活動！",                                                                  // 13
            "歡迎來到Unlight的世界。請收下紀念的道具。",                                                                // 14
            "__FRIEND_NAME__發現渦「__PRF__」了！\n協助他將「__B_NAME__」擊破吧！\nBOSS的最大HP為「__B_HP__」！",       // 15
            "",                                                                                                         // 16
            "",                                                                                                         // 17
            "",                                                                                                         // 18
            "渦「__PRF__」的「__B_NAME__」擊破失敗。",                                                                  // 19
            "非常感謝您登入Unlight！\n請收下為高雄加油所專屬設計的「__AVATAR_PARTS__」。",                                      // 20
            "對於__DATE__系統上的錯誤造成各位玩家的不便，本公司深感抱歉。\n在此附上以下物品作為補償，請查收。",         // 21
            "新年快樂！　請收下跨年的登入獎勵",   // 22
            "歡迎來到Unlight的世界！\n請收下邀請優惠的道具。",                                                                                              // 23
            "",                                                                                                         // 24
            "完成成就「__ARCHIEVEMENT_CAPTION__」。\n獎勵代碼是 __CODE_NUMBER__", // 25
            "恭喜。達成了「__ARCHIEVEMENT_CAPTION__」成就。請選擇獎勵。"                                               // 26
            ]; /* of String */

        CONFIG::LOCALE_SCN
        private static const _MESSAGE_SET:Array = [
            "欢迎光临，小姐。\n请接收今天的奖励道具「__ITEM_NAME__」。",                                                // 0
            "恭喜。您刷新了最高纪录「__ARCHIEVEMENT_CAPTION__」，请接收纪念道具。",                                     // 1
            "新的最高纪录「__ARCHIEVEMENT_CAPTION__」已追加，请务必挑战看看。",                                         // 2
            "虚拟人物的配件「__AVATAR_PARTS__」已到期，该配件将失效。",                                                 // 3
            "收到来自__FRIEND_NAME__的Friend申请。",                                                                    // 4
            "收到__FRIEND_NAME__赠送的道具。",                                                                          // 5
            "收到__FRIEND_NAME__赠送的任务「__QUEST_NAME__」。",                                                        // 6
            "从__FRIEND_NAME__那里借用的卡片已被收回。",                                                                // 7
            "\n已开始游戏。\n请接收纪念道具。",                                                                         // 8
            "",                                                                                                         // 9
            "__FRIEND_NAME__完成了任务。\n可获得奖励",                                                                  // 10
            "__FRIEND_NAME__回到了Unlight。\n请接收纪念道具。",                                                         // 11
            "__FRIEND_NAME__，欢迎回来！请接收纪念道具",                                                                // 12
            "__SALE_TIME__特卖活动开始！",                                                                              // 13
            "欢迎来到Unlight世界。\n请接收纪念道具。",                                                                  // 14
            "__FRIEND_NAME__发现漩涡「__PRF__」！\n一起协力击破首领「__B_NAME__」吧！\n首领的最大HP为「__B_HP__」！",   // 15
            "",                                                                                                         // 16
            "",                                                                                                         // 17
            "",                                                                                                         // 18
            "成功击破漩涡「__PRF__」的「__B_NAME__」失败。",                                                            // 19
            "非常感谢您使用Unlight！\n请接收三周年纪念礼物「__AVATAR_PARTS__」。",                                      // 20
            "对于系统错误给各位玩家造成的不便，本公司深感抱歉。\n在此附上以下物品作为补偿，请查收。",                   // 21
            "新年快乐！　请收下新年登录奖励",                                                                           // 22
            "欢迎来到Unlight的世界！\n请收下邀请特典道具。",                                                            // 23
            "",                                                                                                         // 24
            "完成成就“__ARCHIEVEMENT_CAPTION__”。\n奖励代码是 __CODE_NUMBER__" ,                                      // 25
            "恭禧。达成了[__ARCHIEVEMENT_CAPTION__]成就。请选择奖励。"                                                  // 26
            ]; /* of String */

        CONFIG::LOCALE_EN
        private static const _MESSAGE_SET:Array = [
            "Welcome back!\nPlease accept today's bonus item.",// 0
            "Congratulations! You have completed the [__ARCHIEVEMENT_CAPTION__] achievement. Please accept a bonus item.",                         // 1
            "The new achievement, [__ARCHIEVEMENT_CAPTION__] has been commenced. Enjoy the challenge!",                                            // 2
            "The avatar part [__AVATAR_PARTS__] has expired, and will disappear.",                                                                 // 3
            "Friend authorization from __FRIEND_NAME__ is comming.",                                                                               // 4
            "A gift item arrived from __FRIEND_NAME__!",                                                                                           // 5
            "You received a quest from __FRIEND_NAME__.",                                                                                          // 6
            "The card you lent to __FRIEND_NAME__ has been returned.",                                                                             // 7
            "\n has joined Unlight.\nPlease accept a bonus item!",                                                                                 // 8
            "",                                                                                                                                    // 9
            "__FRIEND_NAME__ completed a quest.\nYou received a bonus.",                                                                           // 10
            "Your friend __FRIEND_NAME__ has returned to Unlight. Please accept a bonus item!",                                                    // 11
            "Welcome back, __FRIEND_NAME__! Please accept a bonus item!",                                                                          // 12
            "__SALE_TIME__ minute sale starting now!",                                                                                             // 13
            "Welcome the world of Unlight.！\nPlease accept a bonus item!",                                                                    // 14
           "__FRIEND_NAME__ discovered the vortex [__PRF__]!\nLet's team up to take down the vortex boss [__B_NAME__], who has __B_HP__ HP!",     // 15
            "",                                                                                                                                    // 16
            "",                                                                                                                                    // 17
            "",                                                                                                                                    // 18
            "You failed to defeat __B_NAME__ of the vortex [__PRF__].",                                                                            // 19
            "Thank you for playing Unlight! Please accept a gift of [__AVATAR_PARTS__] to commemorate our 3rd anniversary.",                       // 20
            "We are deeply sorry for any inconvenience caused by system errors on __DATE__.\nPlease accept the following item as compensation.",    // 21
            "Happy New Year ! Please accept Newyear's bonus item.",   // 22
            "Welcome the world of Unlight.！\nPlease accept a bonus item!",                                                                                              // 23
            "",                                                                                                                                    // 22
            "You have accomplished <__ARCHIEVEMENT_CAPTION__>. The accomplishment code is __CODE_NUMBER__.",// 25
            "Congratulations.  You have accomplished [__ARCHIEVEMENT_CAPTION__] achievement. Please select your reward."                                               // 26
            ]; /* of String */

        CONFIG::LOCALE_FR
        private static const _MESSAGE_SET:Array = [
            "Bienvenue, gente dame !\nVeuillez accepter cet objet bonus !",                                                                              // 0
            "Félicitations. La mission [__ARCHIEVEMENT_CAPTION__] a été accomplie. Veuillez accepter cet article en guise de souvenir.",                 // 1
            "La nouvelle mission [__ARCHIEVEMENT_CAPTION__] a été ajoutée à votre liste.\nAmusez-vous bien !",                                           // 2
            "La pièce détachée [__AVATAR_PARTS__] est invalide car son temps d'utilisation est écoulé.",                                                 // 3
            "Vous avez reçu une lettre de confirmation d'amitié de la part de __FRIEND_NAME__.",                                                         // 4
            "__FRIEND_NAME__ vous offre un cadeau.",                                                                                                     // 5
            "Vous avez reçu une Quête de __FRIEND_NAME__. [__QUEST_NAME__].",                                                                            // 6
            "La carte que __FRIEND_NAME__ vous a prêtée lui a été rendue.",                                                                              // 7
            "\n  a commencé le jeu.\nDe fait, vous recevez.",                                                                                            // 8
            "",                                                                                                                                          // 9
            "__FRIEND_NAME__ a fini la Quête.",                                                                                                          // 10
            "Votre ami __FRIEND_NAME__ est revenu à Unlight.\nPrenez item de commémoration.",                                                            // 11
            "Rebienvenue __FRIEND_NAME__ !\nPrenez item de commémoration.",                                                                              // 12
            "Commencement de solde pendant __SALE_TIME__ minute!",                                                                                       // 13
            "Bienvenue dans le monde Unlight.\nDe fait, vous recevez.",                                                                                  // 14
            "__FRIEND_NAME__ a trouvé le Vortex [__PRF__] !\nCollaborez pour écraser le Boss [__B_NAME__] !\nLe maximum de HP du Boss est __B_HP__ !",   // 15
            "",                                                                                                                                          // 16
            "",                                                                                                                                          // 17
            "",                                                                                                                                          // 18
            "échec d'écraser «__PRF__» de Vortex «__B_NAME__» .",                                                                                        // 19
            "Merci beaucoup de jouer à «Unlight»!\nRecevez [__AVATAR_PARTS__] comme cadeau pour le troisième anniversaire d'Unlight.",                   // 20
            "Nous nous excusons pour le dysfonctionnement qui a eu lieu le __DATE__.\nEn guise de dédommagement, veuillez acceptez l'objet suivant.",    // 21
            "Nous vous souhaitons une très bonne année 2015 !\nPour souhaitez la nouvelle année, nous vous offrons l'objet suivant.",   // 22
            "Bienvenue dans le Monde d'Unlight.\nVeuillez accepter cet objet de bienvenue.",                                                                                              // 23
            "",                                                                                                                                          // 22
            "Vous avez terminé la mission [__ARCHIEVEMENT_CAPTION__]. Votre code privilège est __CODE_NUMBER__.", // 25
            "Félicitations ! Vous avez finaliser <__ARCHIEVEMENT_CAPTION__>. Veuillez choisir votre bonus."                                               // 26
            ]; /* of String */

        CONFIG::LOCALE_ID
        private static const _MESSAGE_SET:Array = [
            "いらっしゃいませお嬢様。\n本日のボーナスアイテム「__ITEM_NAME__」をお受け取りください。",// 0
            "おめでとうございます。レコード「__ARCHIEVEMENT_CAPTION__」がクリアされました。記念アイテムをお受け取り下さい",          // 1
            "新しいレコード「__ARCHIEVEMENT_CAPTION__」が追加されました。\n是非、挑戦してみてください",          // 2
            "アバターパーツ「__AVATAR_PARTS__」が期限切れのため失われました",    // 3
            "__FRIEND_NAME__さんからFriend認証の申し込みが来ています",         // 4
            "__FRIEND_NAME__さんからアイテムのプレゼントが届きました",         // 5
            "__FRIEND_NAME__さんからクエスト「__QUEST_NAME__」が届きました",         // 6
            "__FRIEND_NAME__さんから貸していたカードが返却されました",            // 7
            "\nがゲームを始めました。\n記念のアイテムをお受け取りください",          // 8
            "",            // 9
            "__FRIEND_NAME__さんがプレゼントしたクエストをクリアしました\n ボーナスをお受け取りください", // 10
            "__FRIEND_NAME__さんがUnlightに戻ってきました\n記念のアイテムをお受け取りください", // 11
            "__FRIEND_NAME__さんおかえりなさい！\n記念のアイテムをお受け取りください", // 12
            "__SALE_TIME__セール開始しました！ 是非この機会にお試しください", // 13
            "Unlightの世界へようこそ！\n記念のアイテムをお受け取りください",          // 14
            "__FRIEND_NAME__さんが渦「__PRF__」を発見しました！\n協力してボス「__B_NAME__」を撃破しましょう！\nボスの最大HPは「__B_HP__」です！",       // 15
            "",       // 16
            "",       // 17
            "",       // 18
            "",       // 19
            "",       // 20
            "Unlightをプレイして頂き、誠にありがとうございます！\n3周年記念アイテムをお受け取り下さい",       // 21
            "運営のトラブルによりご迷惑をお掛けしてしまい、大変申し訳御座いませんでした。\nお詫びと致しまして以下のものをお受け取りください",       // 21
            "新年あけましておめでとうございます！年越しログインボーナスとして以下のものをお受け取りください",   // 22
            "Unlightの世界へようこそ！\n招待特典のアイテムをお受け取りください",                                                                                              // 23
            "",       // 22
            "レコード「__ARCHIEVEMENT_CAPTION__」がクリアされました。特典コードは__CODE_NUMBER__です" ,//
            "おめでとうございます。レコード「__ARCHIEVEMENT_CAPTION__」がクリアされました。ボーナスを選択してください"                                               // 26
            ]; /* of String */

        CONFIG::LOCALE_TH
        private static const _MESSAGE_SET:Array = [
            "ยินดีต้อนรับครับ นายหญิง \nโบนัสไอเท็มวันนี้คือ [__ITEM_NAME__] กรุณารับไว้ด้วยครับ",                              // 0 いらっしゃいませお嬢様。\n本日のボーナスアイテム「__ITEM_NAME__」をお受け取りください。
            "ขอแสดงความยินดีด้วยครับ ท่านเคลียร์ Record [__ARCHIEVEMENT_CAPTION__] สำเร็จแล้ว กรุณารับไอเท็มที่ระลึกด้วยครับ", // 1 おめでとうございます。レコード「__ARCHIEVEMENT_CAPTION__」がクリアされました。記念アイテムをお受け取り下さい
            "Record [__ARCHIEVEMENT_CAPTION__] ถูกเพิ่มแล้ว ลองท้าทายดูให้ได้นะครับ",                                            // 2 新しいレコード「__ARCHIEVEMENT_CAPTION__」が追加されました。\n是非、挑戦してみてください
            "ชิ้นส่วนอวาตาร์ [__AVATAR_PARTS__] หมดอายุแล้ว",                                                                    // 3  アバターパーツ「__AVATAR_PARTS__」が期限切れのため失われました
            "มีคำขอเป็นเพื่อนจากคุณ __FRIEND_NAME__",                                                                          // 4 __FRIEND_NAME__さんからFriend認証の申し込みが来ています
            "มีของขวัญเป็นไอเท็มส่งมาจากคุณ __FRIEND_NAME__",                                                                   // 5 __FRIEND_NAME__さんからアイテムのプレゼントが届きました
            "มีของขวัญเป็นเควสส่งมาจากคุณ __FRIEND_NAME__",                                                                     // 6 __FRIEND_NAME__さんからクエスト「__QUEST_NAME__」が届きました
            "คืนการ์ดที่ขอยืมมาจากคุณ __FRIEND_NAME__ แล้ว",                                                                    // 7 __FRIEND_NAME__さんから貸していたカードが返却されました
            "\nเริ่มเล่นเกมแล้ว\nกรุณารับไอเท็มที่ระลึกไว้ด้วยครับ",                                                            // 8 \nがゲームを始めました。\n記念のアイテムをお受け取りください
            "",            // 9
            "คุณ__FRIEND_NAME__เคลียร์เควสที่มอบเป้นของขวัญให้แล้ว\n กรุณารับโบนัสไว้ด้วยครับ",                                // 10 __FRIEND_NAME__さんがプレゼントしたクエストをクリアしました\n ボーナスをお受け取りください
            "คุณ__FRIEND_NAME__ได้กลับมายังUnlightแล้ว\nกรุณารับไอเท็มที่ระลึกไว้ด้วยครับ",                                    // 11 __FRIEND_NAME__さんがUnlightに戻ってきました\n記念のアイテムをお受け取りください
            "ยินดีต้อนรับกลับมาครับ คุณ__FRIEND_NAME__!\nกรุณารับไอเท็มที่ระลึกไว้ด้วยครับ",                                   // 12 __FRIEND_NAME__さんおかえりなさい！\n記念のアイテムをお受け取りください
            "เริ่มการลดราคา__SALE_TIME__แล้ว! ใช้โอกาสนี้ทดลองใช้ให้ได้นะครับ",                                                  // 13 __SALE_TIME__セール開始しました！ 是非この機会にお試しください
            "ยินดีต้อนรับสู่โลก Unlight!\nกรุณารับไอเท็มที่ระลึกไว้ด้วยครับ",                                                   // 14 Unlightの世界へようこそ！\n記念のアイテムをお受け取りください
            "คุณ_FRIEND_NAME__ค้นพบน้ำวน [__PRF__] แล้ว!\nร่วมมือกันกำจัดบอส [__B_NAME__] กันเถอะ!\nHP สูงสุดของบอสคือ [__B_HP__] ครับ!", // 15 __FRIEND_NAME__さんが渦「__PRF__」を発見しました！\n協力してボス「__B_NAME__」を撃破しましょう！\nボスの最大HPは「__B_HP__」です！
            "",       // 16
            "",       // 17
            "",       // 18
            "",       // 19
            "ไม่สามารถเอาชนะบอส [__B_NAME__] ของน้ำวน [__PRF__] ได้",                                                           // 20 渦「__PRF__」のボス「__B_NAME__」の撃破に失敗しました。
            "ขอบคุณที่เล่นUnlight ! \nกรุณารับของที่ระลึกครบรอบ3ปี [__AVATAR_PARTS__]",                                        // 21 Unlightをプレイして頂き、誠にありがとうございます！\n記念パーツ「__AVATAR_PARTS__」をお受け取り下さい
            "",   // 21 __DATE__に発生いたしました運営のトラブルにより、ご迷惑をお掛けしてしまい大変申し訳御座いませんでした。\nお詫びと致しまして以下のものをお受け取りください
            "新年あけましておめでとうございます！年越しログインボーナスとして以下のものをお受け取りください",   // 22
            "Unlightの世界へようこそ！\n招待特典のアイテムをお受け取りください",                                                                                              // 23
            "",       // 24
            "レコード「__ARCHIEVEMENT_CAPTION__」がクリアされました。特典コードは__CODE_NUMBER__です", // 25
            "おめでとうございます。レコード「__ARCHIEVEMENT_CAPTION__」がクリアされました。ボーナスを選択してください"                                               // 26
            ]; /* of String */

        CONFIG::LOCALE_JP
        private static const _ACTIVEITY_MESSAGE_SET:Array = [
            "",                                                                  // 0
            "__NICKNAME__はレコード「__ARCHIEVEMENT_CAPTION__」をクリアしました", // 1
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "__FRIEND_NAME__さんからクエストが届きました",          // 6
            "",                                                                  // 7
            "__FRIEND_NAME__さんがゲームを始めました。\n記念のアイテムがあります",          // 8
            "",                                                                  // 9
            "__FRIEND_NAME__さんがクエストをクリア。\nボーナスがあります",                                                                  // 10
            "__FRIEND_NAME__さんがUnlightに戻ってきました\n記念のアイテムをお受け取りください", // 11
            "__FRIEND_NAME__さんおかえりなさい！\n記念のアイテムをお受け取りください", // 12
            "",                                                                   // 13
            "Unlightの世界へようこそ！\n記念のアイテムをお受け取りください",          // 14
            "",                                                                   // 15
            "",                                                                   // 16
            "",                                                                   // 17
            "",                                                                   // 18
            "",                                                                   // 18
            ""                                                                   // 20
            ]; /* of String */

        CONFIG::LOCALE_TCN
        private static const _ACTIVEITY_MESSAGE_SET:Array = [
            "",                                                                  // 0
            "__NICKNAME__達成了「__ARCHIEVEMENT_CAPTION__」的成就。", // 1
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "收到了來自 __FRIEND_NAME__的禮品任務。",          // 6
            "",                                                                  // 7
            "__FRIEND_NAME__開始遊戲了。有紀念的道具。",          // 8
            "",                                                                  // 9
            "",                                                                  // 9
            "__FRIEND_NAME__完成了任務。\n共有獎勵",      // 10
            "您的朋友__FRIEND_NAME__回到了Unlight。\n請收下紀念物品。", // 11
            "__FRIEND_NAME__,歡迎回來！\n請收下紀念物品。", // 12
            "",                                                                   // 13
            "歡迎來到Unlight的世界。請收下紀念的道具。",          // 14
            "",                                                                   // 15
            "",                                                                   // 16
            "",                                                                   // 17
            "",                                                                   // 18
            "",                                                                   // 18
            ""                                                                   // 15
            ]; /* of String */

        CONFIG::LOCALE_SCN
        private static const _ACTIVEITY_MESSAGE_SET:Array = [
            "",                                                                  // 0
            "__NICKNAME__刷新了「__ARCHIEVEMENT_CAPTION__」最高纪录。",          // 1
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "收到__FRIEND_NAME__赠送的任务",                                     // 6
            "",                                                                  // 7
            "__FRIEND_NAME__开始进行游戏。\n请接收纪念道具。",                   // 8
            "",                                                                  // 9
            "__FRIEND_NAME__完成任务。\n可获得奖励",                             // 10
            "您的朋友__FRIEND_NAME__已回到Unlight。\n请接收纪念道具。",          // 11
            "__FRIEND_NAME__，欢迎回来！\n请接收纪念道具。",                     // 12
            "",                                                                  // 13
            "欢迎来到Unlight世界！\n请接收纪念道具。",                           // 14
            "",                                                                  // 15
            "",                                                                  // 16
            "",                                                                  // 17
            "",                                                                  // 18
            "",                                                                  // 19
            ""                                                                   // 20
            ]; /* of String */

        CONFIG::LOCALE_EN
        private static const _ACTIVEITY_MESSAGE_SET:Array = [
            "",                                                                                                   // 0
            "__NICKNAME__ has completed the achievement [__ARCHIEVEMENT_CAPTION__].",                             // 1
            "",                                                                                                   // 2
            "",                                                                                                   // 3
            "",                                                                                                   // 4
            "",                                                                                                   // 5
            "You received a quest from __FRIEND_NAME__.",                                                         // 6
            "",                                                                                                   // 7
            "__FRIEND_NAME__ has joined Unlight.\nPlease accept a bonus item!",                                   // 8
            "",                                                                                                   // 9
            "__FRIEND_NAME__ completed a quest.\nYou received a bonus.",                                          // 10
            "Your friend __FRIEND_NAME__ has returned to Unlight.\nPlease accept a bonus item!",                  // 11
            "Welcome back, __FRIEND_NAME__!\n__FRIEND_NAME__さんおかえりなさい！\nPlease accept a bonus item!",   // 12
            "",                                                                                                   // 13
            "Welcome the world of Unlight!\nPlease accept a bonus item.",                                     // 14
            "",                                                                                                   // 15
            "",                                                                                                   // 16
            "",                                                                                                   // 17
            "",                                                                                                   // 18
            "",                                                                                                   // 19
            ""                                                                                                    // 20
            ]; /* of String */

        CONFIG::LOCALE_FR
        private static const _ACTIVEITY_MESSAGE_SET:Array = [
            "",                                                                  // 0
            "__NICKNAME__ a fini la mission [__ARCHIEVEMENT_CAPTION__].", // 1
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "Vous avez reçu une Quête de __FRIEND_NAME__.",          // 6
            "",                                                                  // 7
            "__FRIEND_NAME__ commence le jeu.\nDe fait, vous recevez.",          // 8
            "",                                                                  // 9
            "__FRIEND_NAME__ a fini la Quête.\nVous avez obtenu une prime.",                                                                  // 10
            "Votre ami __FRIEND_NAME__ est revenu à Unlight.\nPrenez item de commémoration.", // 11
            "Rebienvenue __FRIEND_NAME__ !\nPrenez item de commémoration.", // 12
            "",                                                                   // 13
            "Bienvenue dans le monde Unlight.\nDe fait, vous recevez.",          // 14
            "",                                                                   // 15
            "",                                                                   // 16
            "",                                                                   // 17
            "",                                                                   // 18
            "",                                                                   // 18
            ""                                                                   // 15
            ]; /* of String */

        CONFIG::LOCALE_ID
        private static const _ACTIVEITY_MESSAGE_SET:Array = [
            "",                                                                  // 0
            "__NICKNAME__はレコード「__ARCHIEVEMENT_CAPTION__」をクリアしました", // 1
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "__FRIEND_NAME__さんからクエストが届きました",          // 6
            "",                                                                  // 7
            "__FRIEND_NAME__さんがゲームを始めました。\n記念のアイテムがあります",          // 8
            "",                                                                  // 9
            "__FRIEND_NAME__さんがクエストをクリア。\nボーナスがあります",                                                                  // 10
            "__FRIEND_NAME__さんがUnlightに戻ってきました\n記念のアイテムをお受け取りください", // 11
            "__FRIEND_NAME__さんおかえりなさい！\n記念のアイテムをお受け取りください", // 12
            "",                                                                   // 13
            "Unlightの世界へようこそ！\n記念のアイテムをお受け取りください",          // 14
            "",                                                                   // 15
            "",                                                                   // 16
            "",                                                                   // 17
            "",                                                                   // 18
            "",                                                                   // 18
            ""                                                                   // 20
            ]; /* of String */

        CONFIG::LOCALE_TH
        private static const _ACTIVEITY_MESSAGE_SET:Array = [
            "",                                                                  // 0
            "คุณ __NICKNAME__ เคลียร์ record 「__ARCHIEVEMENT_CAPTION__」สำเร็จแล้ว",         // 1 __NICKNAME__はレコード「__ARCHIEVEMENT_CAPTION__」をクリアしました"
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "มีของขวัญเป็นเควสส่งมาจากคุณ __FRIEND_NAME__",                                    // 6 __FRIEND_NAME__さんからクエストが届きました
            "",                                                                  // 7
            "คุณ __FRIEND_NAME__ เริ่มเล่นเกมแล้ว กรุณารับไอเท็มที่ระลึกไว้ด้วยครับ",         // 8 __FRIEND_NAME__さんがゲームを始めました。\n記念のアイテムがあります
            "",                                                                  // 9
            "คุณ __FRIEND_NAME__เคลียร์เควสสำเร็จ และได้รับโบนัส",                            //10 __FRIEND_NAME__さんがクエストをクリア。\nボーナスがあります
            "คุณ __FRIEND_NAME__กลับเข้ามาในเกม Unlight แล้ว\nกรุณารับไอเท็มที่ระลึกไว้ด้วย", //11 __FRIEND_NAME__さんがUnlightに戻ってきました\n記念のアイテムをお受け取りください
            "ยินดีต้อนรับคุณ __FRIEND_NAME__! กรุณารับไอเท็มที่ระลึกไว้ด้วย",                 //12 __FRIEND_NAME__さんおかえりなさい！\n記念のアイテムをお受け取りください
            "",                                                                  // 13
            "ยินดีต้อนรับสู่โลก Unlight!\nกรุณารับไอเท็มที่ระลึกไว้ด้วยครับ",                 // 14 Unlightの世界へようこそ！\n記念のアイテムをお受け取りください
            "",                                                                  // 15
            "",                                                                  // 16
            "",                                                                  // 17
            "",                                                                  // 18
            "",                                                                  // 18
            ""                                                                   // 20
            ]; /* of String */


        // 新規翻訳
        CONFIG::LOCALE_JP
        private static const _ACTIVEITY_TITLE_SET:Array = [
            "",                                                                  // 0
            "記録達成！",                                                        // 1
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "クエストプレゼント",                                                // 6
            "",                                                                  // 7
            "友達がゲームを開始",                                                // 8
            "",                                                                  // 9
            "クエストボーナス",                                                  // 10
            "カムバック報告",                                                    // 11
            "おかえりなさい！",                                                  // 12
            "セール開始！",                                                      // 13
            "Unlightへようこそ！",                                               // 14
            "",                                                                  // 15
            "",                                                                  // 16
            "",                                                                  // 17
            "",                                                                  // 18
            "",                                                                  // 19
            ""                                                                   // 20
            ]; /* of String */

        CONFIG::LOCALE_TCN
        private static const _ACTIVEITY_TITLE_SET:Array = [
            "",                                                                  // 0
            "成就達成！",                                                        // 1
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "任務禮物",                                                          // 6
            "",                                                                  // 7
            "",                                                                  // 8
            "",                                                                  // 9
            "任務獎勵",                                                          // 10
            "Come Back 成功",                                                    // 11
            "歡迎回來！",                                                        // 12
            "特賣活動開始！",                                                    // 13
            "歡迎來到Unlight的世界！",                                           // 14
            "",                                                                  // 15
            "",                                                                  // 16
            "",                                                                  // 17
            "",                                                                  // 18
            "",                                                                  // 19
            ""                                                                   // 20
            ]; /* of String */

        CONFIG::LOCALE_SCN
        private static const _ACTIVEITY_TITLE_SET:Array = [
            "",                                                                  // 0
            "达成纪录！",                                                        // 1
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "任务礼物",                                                          // 6
            "",                                                                  // 7
            "朋友已开始游戏。",                                                  // 8
            "",                                                                  // 9
            "任务奖励",                                                          // 10
            "回归",                                                              // 11
            "欢迎回来！",                                                        // 12
            "特卖活动开始！",                                                    // 13
            "欢迎来到Unlight世界！",                                             // 14
            "",                                                                  // 15
            "",                                                                  // 16
            "",                                                                  // 17
            "",                                                                  // 18
            "",                                                                  // 19
            ""                                                                   // 20
            ]; /* of String */

        CONFIG::LOCALE_EN
        private static const _ACTIVEITY_TITLE_SET:Array = [
            "",                                                                  // 0
            "Achievement recorded!",                                             // 1
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "Gift Quest",                                                        // 6
            "",                                                                  // 7
            "Your friend has started the game.",                                 // 8
            "",                                                                  // 9
            "Quest Bonus",                                                       // 10
            "Comeback report.",                                                  // 11
            "Welcome back!",                                                     // 12
            "Sale starting now!",                                                // 13
            "Welcome the world of Unlight!",                                 // 14
            "",                                                                  // 15
            "",                                                                  // 16
            "",                                                                  // 17
            "",                                                                  // 18
            "",                                                                  // 19
            ""                                                                   // 20
            ]; /* of String */

        CONFIG::LOCALE_FR
        private static const _ACTIVEITY_TITLE_SET:Array = [
            "",                                                                  // 0
            "Mission achevée !",                                                 // 1
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "Cadeau de la Quête",                                                // 6
            "",                                                                  // 7
            "Votre ami a commence le jeu",                                       // 8
            "",                                                                  // 9
            "Bonus de la Quête",                                                 // 10
            "Succès de retour",                                                  // 11
            "Rebienvenue!!",                                                     // 12
            "Commencement du Solde!",                                            // 13
            "Bienvenue dans le monde Unlight!",                                  // 14
            "",                                                                  // 15
            "",                                                                  // 16
            "",                                                                  // 17
            "",                                                                  // 18
            "",                                                                  // 19
            ""                                                                   // 20
            ]; /* of String */

        CONFIG::LOCALE_ID
        private static const _ACTIVEITY_TITLE_SET:Array = [
            "",                                                                  // 0
            "記録達成！",                                                        // 1
            "",                                                                  // 2
            "",                                                                  // 3
            "",                                                                  // 4
            "",                                                                  // 5
            "クエストプレゼント",                                                // 6
            "",                                                                  // 7
            "友達がゲームを開始",                                                // 8
            "",                                                                  // 9
            "クエストボーナス",                                                  // 10
            "カムバック報告",                                                    // 11
            "おかえりなさい！",                                                  // 12
            "セール開始！",                                                      // 13
            "Unlightへようこそ！",                                               // 14
            "",                                                                  // 15
            "",                                                                  // 16
            "",                                                                  // 17
            "",                                                                  // 18
            "",                                                                  // 18
            ""                                                                   // 15
            ]; /* of String */

        CONFIG::LOCALE_TH
        private static const _ACTIVEITY_TITLE_SET:Array = [
            "",                          // 0
            "การบันทึกเสร็จสิ้น!",       // 1 記録達成！
            "",                          // 2
            "",                          // 3
            "",                          // 4
            "",                          // 5
            "ของขวัญจากการทำเควส",      // 6 "クエストプレゼント",
            "",                          // 7
            "เพื่อนเริ่มเล่นเกม",        // 8 友達がゲームを開始
            "",                          // 9
            "โบนัสจากการทำเควส",         // 10 クエストボーナス
            "การกลับมาประสบความสำเร็จ", // 11 カムバック報告
            "ยินดีต้อนรับ!",             // 12 おかえりなさい！
            "เริ่มทำการลดราคา!",        // 13 セール開始！
            "ยินดีต้อนรับสู่ Unlight!",  // 14 Unlightへようこそ！
            "",                          // 15
            "",                          // 16
            "",                          // 17
            "",                          // 18
            "",                          // 19
            ""                           // 20
            ]; /* of String */

        private static const _ACIVEMENT_SUCC_FEED_IMAGE_SET:Array = [
            "/public/image/feeds/feed_level.gif",   // 0 AVATAR_LEVEL
            "/public/image/feeds/feed_duel.gif",   // 1 DUEL
            "/public/image/feeds/feed_quest.gif",   // 2 QUEST
            "/public/image/feeds/feed_friend.gif",   // 3 FRIEND
            "/public/image/feeds/feed_event.gif",   // 4 EVENT
            "/public/image/feeds/feed_friend.gif",   // 5 FRIEND
            "/public/image/feeds/feed_friend.gif",   // 6 FRIEND変える必要あり！！！！！！！！
            "/public/image/feeds/feed_friend.gif",   // 7 FRIEND
            "/public/image/feeds/feed_invite.gif",   // 8 FRIEND
            "/public/image/feeds/feed_invite.gif",   // 9 FRIEND
            "/public/image/feeds/feed_friend.gif",   // 10 FRIEND
            "/public/image/feeds/feed_friend.gif",   // 11 FRIEND
            "/public/image/feeds/feed_friend.gif",   // 12 FRIEND
            "/public/image/feeds/feed_friend.gif",   // 13 FRIEND
            "/public/image/feeds/feed_friend.gif",   // 14 FRIEND
            "/public/image/feeds/feed_duel.gif",   // 15 DUEL
            "/public/image/feeds/feed_duel.gif",   // 16 DUEL
            "/public/image/feeds/feed_duel.gif",   // 17 DUEL
            "/public/image/feeds/feed_duel.gif",   // 18 DUEL
            "/public/image/feeds/feed_duel.gif",   // 19 DUEL
            ]; /* of String */

        private var _enable:Boolean;
        private var _isShow:Boolean = false;


        /**
         * コンストラクタ
         *
         */
        public function NoticePanel()
        {
            super();
            News.instance.addEventListener(News.NEWS_CHANGE, setUpdateMessageHandler)
            _updateMessage.visible = false;
            _container.addChild(_base);
            _container.addChild(_title);
            _container.addChild(_message);
            _container.addChild(_friendName)
            _container.addChild(_updateMessage);
            addChild(_container);
            _selectComboBox.dropdownWidth = 125;
            _selectComboBox.rowCount = 7;
            _selectComboBox.x = 300;
            _selectComboBox.y = 493;
            _selectComboBox.width = 160;
            _selectComboBox.height =18;
            _selectComboBox.visible = false;
            _selectComboBox.addEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            _container.addChild(_selectComboBox);

            _base.setButtonFunc(pushNextHandler);
//            checkInfo();

        }

        private function changeDropDownListHandler(e:ListEvent):void
        {
            SE.playDeckTabClick();
            if (_selectComboBox.selectedIndex == -1)
            {
                _base.ok.enabled = false;
                _base.ok.mouseEnabled = false;
            }else{
                _base.ok.enabled = true;
                _base.ok.mouseEnabled = true;
                _selectableCardClipSet.forEach(function(item:TreasureCardClip, index:int, array:Array):void
                                               {
                                                   if( index == _selectComboBox.selectedIndex)
                                                   {
                                                       item.visible = true;
                                                       if(item.isFlip())
                                                       {
                                                           item.getFlipThread().start();
                                                       }
                                                   }else{
                                                       item.visible = false;
                                                       // item.flipReset(false);
                                                   }
                                               });

            }

        }

        public function checkInfo(delID:int = -1,arg:int = -1):Boolean
        {
            var ret:Boolean = false;
            var arciID:int = -1;
            if (_currentNotice != null)
            {
                arciID = _currentNotice.achiID;
            }

            var noticeSet:Vector.<LobbyNotice> = LobbyNotice.getNotice(delID);
            if (arg > -1){_argsSet.push([arciID, arg].join(","))}
            // log.writeLog(log.LV_INFO, this, "check info",noticeSet.length);
            if (noticeSet.length >0)
            {
                setNotice(noticeSet[0]);
                show();
                ret = true;
            }else if (_enable){
                clientAcitivityFeed();
                hide();
                var num:int = LobbyNotice.getNoticeNum();
                if (num>0)
                {
                    LobbyCtrl.instance.getNoticeSelectableItem(_argsSet);
                    num = num - _argsSet.length;
                    LobbyCtrl.instance.clearNotice(num, _argsSet);
                    _argsSet = [];
                    // レコード情報を一新する
                    if (_isUpdAchievement) {
                        LobbyCtrl.instance.updateAchievementInfo();
                        _isUpdAchievement = false;
                    }
                }
            }
            return ret;
        }

        public function selectableItemsCheck():Boolean
        {
            // スルー設定になっている場合は表示しない
            if (_isThrough) {
                return false;
            }

            // 選択ボックス使用時にパーツ選択なら所持済みを表示前に排除
            if (_selectComboBox.visible&&_selectableTreasure[0][0] == Const.TG_AVATAR_PART) {
                var havePartIdList:Array = AvatarPartInventory.getPartIdList().sort();
                // log.writeLog(log.LV_INFO, this, "selectableItemsCheck !!!","_selectableTreasure",_selectableTreasure);
                // log.writeLog(log.LV_INFO, this, "selectableItemsCheck !!!","havePartIdList",havePartIdList);
                // log.writeLog(log.LV_INFO, this, "selectableItemsCheck !!!","__selectedPartTreasureId",__selectedPartTreasureId);
                _selectableTreasure.forEach(function(item:Array, index:int, array:Array):void
                                            {
                                                // 所持済みなら排除する
                                                if (havePartIdList.indexOf(item[1])!=-1||__selectedPartTreasureId.indexOf(item[1])!=-1) {
                                                    var delIdx:int = _selectableTreasureIds.indexOf(item[1]);
                                                    var delClip:TreasureCardClip = _selectableCardClipSet.splice(delIdx, 1)[0];
                                                    if (delClip) {
                                                        delClip.getHideThread().start();
                                                    }
                                                    _selectableTreasureName.splice(delIdx,1);
                                                    _selectableTreasureIds.splice(delIdx,1);
                                                }
                                            });
                _selectComboBox.dataProvider = _selectableTreasureName;
            } else {
                // 選択ボックス未使用ならshow()に移行
                return true;
            }

            // log.writeLog(log.LV_INFO, this, "selectableItemsCheck !!!","_isThrough",_isThrough);
            // log.writeLog(log.LV_INFO, this, "selectableItemsCheck !!!","_selectableTreasureIds",_selectableTreasureIds);
            // 選択肢があるなら、show()に、ないならスルー処理に
            if (_isThrough==false&&_selectableTreasureIds.length > 0) {
                return true;
            } else {
                return false;
            }
        }

        // 実績ビューを呼び出す
        public function show():void
        {
            // アイテムリスト排他になければいけないので閉じる
            ItemListView.hide();

            _isShow = selectableItemsCheck();

            if (_isShow) {
                // 作ったVIEWをトップビューに突っ込んで背景はクリックできなくする
                // Unlight.INS.topContainer.parent.addChild(__achievementView);
                BetweenAS3.serial(
                    BetweenAS3.addChild(this, Unlight.INS.topContainer.parent),
                    BetweenAS3.to(this,{y:_Y},0.3, Quad.easeOut)
                    ).play();
                Unlight.INS.topContainer.mouseEnabled = false;
                Unlight.INS.topContainer.mouseChildren = false;
            } else {
                new WaitThread(100, throughNotice,[]).start();
                y = -800;
            }
            _enable = true;

            // var sExec:SerialExecutor = new SerialExecutor();
            // if (_tCardClip!=null)
            // {
            //     sExec.addThread(_tCardClip.getShowThread(_container));
            //     sExec.addThread(new SleepThread(200));
            //     sExec.addThread(_tCardClip.getFlipThread());
            //     sExec.start();
            // }
            getBringOnThread().start();
        }

        public  function waitingAlert(name:String):void
        {
            Alerter.showWithSize(_TRANS_GET.replace("__NAME__", name), _TRANS_INFO)
        }


        public  function hide():void
        {
            if (_isShow) {
                BetweenAS3.serial(
                    BetweenAS3.tween(this, {y:_START_Y}, null, 0.15, Sine.easeOut),
                    BetweenAS3.removeFromParent(this)
                    ).play()
                    Unlight.INS.topContainer.mouseEnabled = true;
                Unlight.INS.topContainer.mouseChildren = true;
                _lastActivityMess = "";
                _lastActivityTitle = "";
                _lastActivityImage = "";
            }
            _enable = false;
            _isShow = false;
        }

        private function setNotice(n:LobbyNotice):void
        {
            selectComboBoxReset();
            _currentNotice = n;
            switch (n.type)
//            switch (LobbyNotice.TYPE_SALE_START)
            {
            case LobbyNotice.TYPE_LOGIN:
                _base.setNewsMode();
                var itemName:String;
                _message.visible = true;
                _updateMessage.visible = false;
                _friendName.visible = false;
                createTreasueClip(n);
                createTitleAndMessage(n.type,_MESSAGE_SET[n.type].replace("__ITEM_NAME__",_tCardClip.treasureName));
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_ENTRANCE_LOGIN);
                break;
            case LobbyNotice.TYPE_ACHI_SUCC:
                _base.setNewsMode();
                _message.visible = true;
                _updateMessage.visible = false;
                _friendName.visible = false;
                createTreasueClip(n);
                _lastActivityTitle = _ACTIVEITY_TITLE_SET[n.type];
                _lastActivityMess = _ACTIVEITY_MESSAGE_SET[n.type].replace("__ARCHIEVEMENT_CAPTION__", Achievement.ID(n.achiID).caption);
                _lastActivityImage = _ACIVEMENT_SUCC_FEED_IMAGE_SET[Achievement.ID(n.achiID).kind];
                createTitleAndMessage(n.type, _MESSAGE_SET[n.type].replace("__ARCHIEVEMENT_CAPTION__", Achievement.ID(n.achiID).caption));
                _isUpdAchievement = true;
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_ENTRANCE_ACHIVEMENT_SUCCESS);
                break;
            case LobbyNotice.TYPE_ACHI_NEW:
                // レコードが初心者クエストクリアの場合特別な画像を出す
                if (n.achiID == 180||n.achiID == 181||n.achiID == 182)
                {
                    _base.setRecordBeginerMode();
                }
                else
                {
                    _base.setRecordMode();
                }
                _tCardClip = null;
                _selectableCardClipSet = [];
                _message.visible = true;
                _friendName.visible = false;
                _updateMessage.visible = false;
                log.writeLog(log.LV_INFO, this, "Achievement.ID(n.achiID).caption", Achievement.ID(n.achiID).caption, n.achiID);
                createTitleAndMessage(n.type, _MESSAGE_SET[n.type].replace("__ARCHIEVEMENT_CAPTION__", Achievement.ID(n.achiID).caption));
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_ENTRANCE_ACHIVEMENT_NEW);
                break;
            case LobbyNotice.TYPE_VANISH_PART:
                _base.setNewsMode();
                //未設定
//                createTitleAndMessage(n.type, _MESSAGE_SET[n.type].replace("__ARCHIEVEMENT_CAPTION__", Achievement.ID(n.achiID).caption));
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_ENTRANCE_VANISH_PARTS);
                break;
            case LobbyNotice.TYPE_FRIEND_COME:
                _base.setNewsMode();
                //未設定
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_ENTRANCE_FRIEND_COME);
                break;
            case LobbyNotice.TYPE_ITEM_PRESENT:
                _base.setNewsMode();
                //未設定
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_ENTRANCE_ITEM_PRESENT);
                break;
            case LobbyNotice.TYPE_QUEST_PRESENT:
                _base.setNewsMode();
                _tCardClip = null;
                _selectableCardClipSet = [];
                _message.visible = true;
                _friendName.visible = false;
                _updateMessage.visible = false;
                createTitleAndMessage(n.type, _MESSAGE_SET[n.type].replace("__QUEST_NAME__", Quest.ID(n.questID).name).replace("__FRIEND_NAME__", n.friendName));
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_ENTRANCE_QUEST_PRESENT);
                break;
            case LobbyNotice.TYPE_RETURN_CARD:
                _base.setNewsMode();
                //未設定
                break;
            case LobbyNotice.TYPE_INVITE_SUCC:
                _base.setNewsMode();
                _message.visible = true;
                _updateMessage.visible = false;
                _friendName.visible = true;
                createTreasueClip(n);
                _lastActivityTitle = _ACTIVEITY_TITLE_SET[n.type];
                _lastActivityMess = _ACTIVEITY_MESSAGE_SET[n.type].replace("__FRIEND_NAME__", n.friendName);
                _lastActivityImage = _ACIVEMENT_SUCC_FEED_IMAGE_SET[Achievement.ID(n.achiID).kind];
                createTitleAndMessage(n.type, _MESSAGE_SET[n.type]);
                CONFIG::LOCALE_JP
                {
                    createFriendName(n.friendName+"さん");
                }
                CONFIG::LOCALE_TCN
                {
                    createFriendName(n.friendName);
                }
                CONFIG::LOCALE_SCN
                {
                    createFriendName(n.friendName);
                }
                CONFIG::LOCALE_EN
                {
                    createFriendName(n.friendName);
                }
                CONFIG::LOCALE_FR
                {
                    createFriendName(n.friendName);
                }
                CONFIG::LOCALE_ID
                {
                    createFriendName(n.friendName);
                }
                CONFIG::LOCALE_TH
                {
                    createFriendName(n.friendName);
                }
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_ENTRANCE_INVITE);
//                createTitleAndMessage(n.type, _MESSAGE_SET[n.type].replace("__FRIEND_NAME__", "フレンド"));
                break;

                //未設定
                break;
            case LobbyNotice.TYPE_AD:
                _base.setNewsMode();
                //未設定
                break;

            case LobbyNotice.TYPE_QUEST_SUCC:
                _base.setNewsMode();
                _message.visible = true;
                _updateMessage.visible = false;
                _friendName.visible = true;
                createTreasueClip(n);
                createTitleAndMessage(n.type, _MESSAGE_SET[n.type].replace("__FRIEND_NAME__", n.friendName));
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_ENTRANCE_QUEST_SUCCESS);
                //未設定
                break;

            case LobbyNotice.TYPE_UPDATE_NEWS:
                _base.setNewsMode();
                _tCardClip = null;
                _selectableCardClipSet = [];
                _message.visible = false;
                _friendName.visible = false;
                _updateMessage.visible = true;
                createTitleAndMessage(n.type, "");
                createUpdateMessage(n.text);
                break;

            case LobbyNotice.TYPE_COMEBK_SUCC:
            case LobbyNotice.TYPE_COMEBKED_SUCC:
                _base.setNewsMode();
                _message.visible = true;
                _updateMessage.visible = false;
                _friendName.visible = true;
                createTreasueClip(n);
                createTitleAndMessage(n.type, _MESSAGE_SET[n.type].replace("__FRIEND_NAME__", n.friendName));
                break;
            case LobbyNotice.TYPE_SALE_START:
                _base.setSaleMode(Const.SALE_DISCOUNT_VALUES[n.saleType]);
                _selectableCardClipSet = [];
                _tCardClip = null;
                _message.visible = true;
                _friendName.visible = false;
                _updateMessage.visible = false;
                createTitleAndMessage(n.type, _MESSAGE_SET[n.type].replace("__SALE_TIME__", n.text));
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_ENTRANCE_SALE);
                break;
            case LobbyNotice.TYPE_ROOKIE_START:
                _base.setNewsMode();
                _selectableCardClipSet = [];
                _tCardClip = null;
                _message.visible = true;
                _friendName.visible = false;
                _updateMessage.visible = false;
                createTreasueClip(n);
                createTitleAndMessage(n.type, _MESSAGE_SET[n.type]);
                break;
            case LobbyNotice.TYPE_GET_PROFOUND:
                _base.setNewsMode();
                _selectableCardClipSet = [];
                _tCardClip = null;
                _message.visible = true;
                _friendName.visible = false;
                _updateMessage.visible = false;
                var prfMsg:String = _MESSAGE_SET[n.type]
                    .replace("__FRIEND_NAME__",n.friendName)
                    .replace("__PRF__",n.raidObj["prfName"])
                    .replace("__B_NAME__",n.raidObj["bossName"])
                    .replace("__B_HP__",n.raidObj["bossHp"]);
                createTitleAndMessage(n.type, prfMsg);
                break;
            case LobbyNotice.TYPE_FIN_PRF_FAILED:
                _base.setNewsMode();
                _selectableCardClipSet = [];
                _tCardClip = null;
                _message.visible = true;
                _friendName.visible = false;
                _updateMessage.visible = false;
                var prfMsg2:String = _MESSAGE_SET[n.type]
                    .replace("__PRF__",n.raidObj["prfName"])
                    .replace("__B_NAME__",n.raidObj["bossName"]);
                createTitleAndMessage(n.type, prfMsg2);
                break;
            case LobbyNotice.TYPE_3_ANNIVERSARY:
                _base.setNewsMode();
                _message.visible = true;
                _updateMessage.visible = false;
                _friendName.visible = false;
                createTreasueClip(n);
                _selectableCardClipSet = [];
                createTitleAndMessage(n.type,_MESSAGE_SET[n.type].replace("__AVATAR_PARTS__",_tCardClip.treasureName));
                break;
            case LobbyNotice.TYPE_APOLOGY:
                _base.setNewsMode();
                _message.visible = true;
                _updateMessage.visible = false;
                _friendName.visible = false;
                createTreasueClip(n);
                createTitleAndMessage(n.type, _MESSAGE_SET[n.type].replace("__DATE__",n.text),11);
                break;
            case LobbyNotice.TYPE_NEW_YEAR:
                break;
            case LobbyNotice.TYPE_INVITED_SUCC:
                _base.setNewsMode();
                _message.visible = true;
                _updateMessage.visible = false;
                _friendName.visible = false;
                createTreasueClip(n);
                createTitleAndMessage(n.type,_MESSAGE_SET[n.type]);
                break;
            case LobbyNotice.TYPE_CLEAR_CODE:
                _base.setNewsMode();
                _selectableCardClipSet = [];
                _tCardClip = null;
                _message.visible = true;
                _friendName.visible = false;
                _updateMessage.visible = false;
                // 特殊コード取得アチーブメントならばキャプションを変更
                createTitleAndMessage(n.type, _MESSAGE_SET[n.type].replace("__ARCHIEVEMENT_CAPTION__", Achievement.ID(n.achiID).caption).replace("__CODE_NUMBER__", AchievementInventory.getInventory(n.achiID).code));
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_ENTRANCE_ACHIVEMENT_NEW);
                break;
            case LobbyNotice.TYPE_GET_SELECTABLE_ITEM:
                log.writeLog(log.LV_FATAL, this, "setNotice","TYPE_GET_SELECTABLE_ITEM");
                _base.ok.enabled = false;
                _base.ok.mouseEnabled = false;
                _base.setNewsMode();
                _message.visible = true;
                _updateMessage.visible = false;
                _friendName.visible = false;
                _selectableCardClipSet.forEach(function(item:*, index:int, array:Array):void
                                               {
                                                   item.getHideThread().start();
                                               });
                createSelectableTreasureClip(n);
                // createTreasueClip(n);
                // log.writeLog(log.LV_FATAL, this, "created clip");
                _lastActivityTitle = _ACTIVEITY_TITLE_SET[LobbyNotice.TYPE_ACHI_SUCC];
                _lastActivityMess = _ACTIVEITY_MESSAGE_SET[LobbyNotice.TYPE_ACHI_SUCC].replace("__ARCHIEVEMENT_CAPTION__", Achievement.ID(n.achiID).caption);
                _lastActivityImage = _ACIVEMENT_SUCC_FEED_IMAGE_SET[Achievement.ID(n.achiID).kind];
                createTitleAndMessage(n.type, _MESSAGE_SET[n.type].replace("__ARCHIEVEMENT_CAPTION__", Achievement.ID(n.achiID).caption));

                // 重複対策 セットされているAchivementIDは再度表示しない
                // log.writeLog(log.LV_FATAL, this, "setNotice","TYPE_GET_SELECTABLE_ITEM","selectableAchiID",__selectableAchiID);
                // log.writeLog(log.LV_FATAL, this, "setNotice","TYPE_GET_SELECTABLE_ITEM","achiID",n.achiID);
                if (__selectableAchiID.indexOf(n.achiID)!=-1) {
                    _isThrough = true;
                } else {
                    _isThrough = false;
                }
                __selectableAchiID.push(n.achiID);
                break;

            }

        }

        private function createTreasueClip(n:LobbyNotice):void
        {
            log.writeLog(log.LV_FATAL, this, "ACHI tc cre",n.treType, n.cardType, n.itemID, n.num);
            _tCardClip = TreasureCardClip.createNoticeTreasure(n.treType, n.cardType, n.itemID, n.num);
            _tCardClip.x = 375;
            _tCardClip.y = 383;
            _tCardClip.mouseEnabled = false;
            _tCardClip.mouseChildren = false;
        }

        private function createSelectableTreasureClip(n:LobbyNotice):void
        {
            log.writeLog(log.LV_FATAL, this, "ACHI tc cre");
            _selectableTreasure = Achievement.ID(n.achiID).selectableTreasureSet;
            log.writeLog(log.LV_FATAL, "LobbyNotice !!!", "createSelectableTreasureClip", _selectableTreasure);
            _selectableTreasureIds = [];
            _selectableCardClipSet = [];
            _selectableTreasureName = [];
            _selectableTreasure.forEach(function(item:Array, index:int, array:Array):void
                                       {
                                           _tCardClip = TreasureCardClip.createNoticeTreasure(item[0],item[3],item[1],item[2]);
                                           _tCardClip.x = 375;
                                           _tCardClip.y = 371;
                                           _tCardClip.mouseEnabled = false;
                                           _tCardClip.mouseChildren = false;
                                           _selectableCardClipSet.push(_tCardClip);
                                           _selectableTreasureIds.push(item[1]);
                                           _selectableTreasureName.push(_tCardClip.treasureName);

                                       });
            _tCardClip = null;
            _selectComboBox.prompt = _SELECT_ITEM;
            _selectComboBox.dataProvider = _selectableTreasureName;
            _selectComboBox.visible = true;

            // log.writeLog(log.LV_FATAL, this, "ACHI tc cre 2");
        }

        private function selectComboBoxReset():void
        {
            _selectComboBox.dataProvider = [];
            _selectComboBox.visible = false;
            _selectComboBox.selectedIndex = -1;
        }


        private function createTitleAndMessage(t:int,mess:String,fontSize:int=0):void
        {
            _title.text = _TITLE_SET[t];
            _title.x = 300;
            _title.y = 166;
            _title.width = 150;
        CONFIG::LOCALE_EN
        {
            _title.width = 230;
            _title.x = 260;
            _title.y = 169;
        }
        CONFIG::LOCALE_FR
        {
            _title.width = 230;
            _title.x = 260;
            _title.y = 169;
        }
            _title.height = 30;
            _title.filters = [ new GlowFilter(0x000000, 1, 2, 2, 16, 1) ];
            _title.styleName = "LoginInfoTitle";

            _message.htmlText = mess;
            _message.x = 210;
            _message.y = 200;
            _message.width = 400;
            _message.height =300;
            _message.styleName = "LoginInfoLabel";
            if (fontSize > 0) {
                _message.setStyle("fontSize",fontSize);
            } else {
                _message.setStyle("fontSize",16);
            }
            _message.selectable = false;
        }
        private function createFriendName(s:String):void
        {
            _friendName.text = s;
            _friendName.x = 210;
            _friendName.y = 200;
            _friendName.width = 400;
            _friendName.height =300;
            _friendName.setStyle("fontSize",  14);
            _friendName.selectable = false;
        }






        private function createUpdateMessage(mess:String):void
        {
            _updateMessage.htmlText = mess;
            _updateMessage.x = 260;
            _updateMessage.y = 200;
            _updateMessage.width = 350;
            _updateMessage.height = 288;
            _updateMessage.styleName = "LoginMessageArea";
            _updateMessage.condenseWhite = true;
            _updateMessage.editable = false;
//            読み込んだ内容を元に，更新情報データを作成
//            log.writeLog(log.LV_INFO, this, "load HTML data!!!!", mess,_updateMessage.text);
            _updateMessage.visible = true;
        }





        // アップデート情報をセットする
        private function setUpdateMessageHandler(event:Event):void
        {
            var updateText:String = News.newsText;
            LobbyNotice.setUpdateInfo(updateText);
            News.instance.removeEventListener(News.NEWS_CHANGE, setUpdateMessageHandler)
        }

        public override function init():void
        {

        }

        public override function final():void
        {
            if (_tCardClip!=null)
            {
                _tCardClip.getHideThread().start();
            }
            _selectableCardClipSet.forEach(function(item:*, index:int, array:Array):void
                                       {
                                           item.getHideThread().start();
                                       });


            _base.ok.removeEventListener(MouseEvent.CLICK, pushNextHandler);
            _base.ok.removeEventListener(MouseEvent.CLICK, pushExitHandler);
            _selectComboBox.removeEventListener(ListEvent.CHANGE, changeDropDownListHandler);

            _container.removeChild(_base);
            _container.removeChild(_title);
            _container.removeChild(_message);
            _container.removeChild(_updateMessage);

            removeChild(_container);
        }


        private function pushNextHandler(e:MouseEvent):void
        {
            if (_tCardClip!=null)
            {
                _tCardClip.getHideThread().start();
            }
            _selectableCardClipSet.forEach(function(item:*, index:int, array:Array):void
                                           {
                                               item.getHideThread().start();
                                           });

//            LobbyNotice.deleteNotice(_currentNotice.id);
            if(_selectComboBox.selectedIndex > -1)
            {
                new WaitThread(399, waitingAlert,[_selectComboBox.selectedLabel]).start();
            }
            // 残った選択肢からどれが選ばれたのかを送る
            // log.writeLog(log.LV_INFO, this, "pushNextHandler","_selectComboBox.selectedIndex",_selectComboBox.selectedIndex);
            // log.writeLog(log.LV_INFO, this, "pushNextHandler","_selectableTreasureIds",_selectableTreasureIds);
            var selId:int = _selectableTreasureIds[_selectComboBox.selectedIndex];
            // log.writeLog(log.LV_INFO, this, "pushNextHandler","selId",selId);
            var selIdx:int = -1;
            for(var i:int = 0; i < _selectableTreasure.length; i++)
            {
                if (_selectableTreasure[i][1] == selId) {
                    if (_selectableTreasure[i][0]==Const.TG_AVATAR_PART) {
                        __selectedPartTreasureId.push(selId);
                    }
                    selIdx = i;
                    break;
                }
            }
            // log.writeLog(log.LV_INFO, this, "pushNextHandler","__selectedPartTreasureId",__selectedPartTreasureId);
            // checkInfo(_currentNotice.id, _selectComboBox.selectedIndex);
            checkInfo(_currentNotice.id, selIdx);
        }

        // 選択肢が出せない為スルーする
        private function throughNotice():void
        {
            if (_tCardClip!=null)
            {
                _tCardClip.getHideThread().start();
            }
            _selectableCardClipSet.forEach(function(item:*, index:int, array:Array):void
                                           {
                                               item.getHideThread().start();
                                           });

            checkInfo(_currentNotice.id);
        }


        private function pushExitHandler(e:MouseEvent):void
        {
            _base.ok.removeEventListener(MouseEvent.CLICK, pushExitHandler);
            _base.ok.addEventListener(MouseEvent.CLICK, pushNextHandler);
            _container.visible = false;
            _container.mouseEnabled = false;
            _container.mouseChildren = false;
        }


        private function mouseOn():void
        {
            _container.mouseEnabled = true;
            _container.mouseChildren = true;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(_fade.getShowThread(_container, 0));
            sExec.addThread(super.getShowThread(stage, at));
            return sExec;
        }

        public override function getHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(_fade.getHideThread());
            sExec.addThread(super.getHideThread());
            return sExec;
        }

        private function getBringOnThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_tCardClip!=null)
            {
                sExec.addThread(_tCardClip.getShowThread(_container));
                sExec.addThread(new SleepThread(200));
                sExec.addThread(_tCardClip.getFlipThread());
            }
            _selectableCardClipSet.forEach(function(item:*, index:int, array:Array):void
                                           {
                                               log.writeLog(log.LV_INFO, this, "Paralelll!!!");
                                               pExec.addThread(item.getShowThread(_container));
                                           });
            sExec.addThread(pExec);

            return sExec;
        }
        public function panelEnable():Boolean
        {
            return _enable;
        }

        public function clientAcitivityFeed():void
        {
            Feed.clientAcitivityUpdate(_lastActivityTitle, _lastActivityMess, _lastActivityImage)

        }
    }
}
