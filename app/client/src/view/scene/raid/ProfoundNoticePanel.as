package view.scene.raid
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
    import mx.events.ToolTipEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import model.*;
    import view.image.common.*;
    import view.image.raid.*;
    import view.utils.*;
    import view.*;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.scene.ModelWaitShowThread;
    import view.scene.common.*;
    import controller.LobbyCtrl;
    import controller.RaidCtrl;
    import controller.RaidDataCtrl;


    /**
     * 渦情報表示クラス
     *
     */

    public class ProfoundNoticePanel extends BaseScene
    {
        public static const VIEW_TYPE_LOBBY:int = 0;
        public static const VIEW_TYPE_RAID:int  = 1;

        private static const RANKING_NUM:int = 10;

        // アバター
        private var _avatar:Avatar = Player.instance.avatar;

        // ベースイメージ
        private var _base:ProfoundInfoImage = new ProfoundInfoImage();

        // 各種ラベル
        private var _message:Text = new Text();    // メッセージ
        private var _rankList:Vector.<RankingLabelSet> = new Vector.<RankingLabelSet>();

        // ベースイメージ
        private var _baseN:LoginInfoImage = new LoginInfoImage();

        // 各種ラベル
        private var _titleN:Label = new Label();     // タイトル
        private var _messageN:Text = new Text();    // ブラウメッセージ


        // 取得カード
        private var _tCardClip:TreasureCardClip;

        // フェード
        private var _fade:Fade = new Fade(0.1, 0.5);

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        private var _currentNotice:ProfoundNotice;

        private var _viewType:int = VIEW_TYPE_LOBBY;
        private var _useY:int = 0;
        private var _isEntry:Boolean = false;
        private var _trsLevel:int;
        private var _ranking:Array;
        private var _page:int = 0;

        private var _monsterName:Label = new Label();
        private var _finderName:Label = new Label();
        private var _findRewardNames:Vector.<Label> = Vector.<Label>([new Label(),new Label(),new Label()]);
        private var _joinRewardName:Label = new Label();
        private var _defeatRewardNames:Vector.<Label> = Vector.<Label>([new Label(),new Label()]);
        private var _rankRewardNames:Vector.<Label> = Vector.<Label>([new Label(),new Label(),new Label()]);
        private var _myRank:RankingLabelSet = new RankingLabelSet(0);

        //private static const _LOBBY_X:int = 200;
        private static const _LOBBY_X:int = 0;
        private static const _LOBBY_Y:int = 0;
        //private static const _RAID_X:int  = 100;
        private static const _RAID_X:int  = 100;
        private static const _RAID_Y:int  = 140;
        private static const _START_Y:int = -120;

        private static const _SHOW_RANKING_NUM:int = 10;

        /**
         * Type
         * 15:渦取得
         * 16:渦撃破:渦撃破報告「渦ID、渦名、発見者名」
         * 17:渦撃破:各種報酬内容「発見、参加、撃破、順位」
         * 18:渦撃破:ランキング報告「自分の順位、ランキング」
         * 19:渦終了:タイムアップ
         */

        private static const _TITLE_SET:Array = [
            "","","","","","","","","","","","","","","",            // 0～14
            "Get Profound",    // 15
            "Finish Profound", // 16
            "Finish Profound Reward", // 17
            "Finish Profound Ranking", // 18
            "Profound Failed", // 19
            ]; /* of String */

        CONFIG::LOCALE_JP
        private static const _MESSAGE_SET:Array = [
            "","","","","","","","","","","","","","","",            // 0～14
            "__FRIEND_NAME__さんが渦「__PRF__」を発見しました！\n協力してボス「__B_NAME__」を撃破しましょう！\nボスの最大HPは「__B_HP__」です！",     // 15
            "渦「__PRF__」の撃退に成功しました！\nおめでとうございます！",          // 16
            "渦「__PRF__」の__BOSS__の撃退に成功しました！\n__NAME__さんはスコア__DMG__で、__RANK__位でした\n 順位報酬をお受け取りください",          // 17
            "渦「__PRF__」の__BOSS__の撃退に成功しました！\n__NAME__さんはスコア__DMG__で、__RANK__位でした\n 撃破報酬をお受け取りください",          // 18
            "渦「__PRF__」のボス「__B_NAME__」の撃破に失敗しました。",                                                                                // 19
            ]; /* of String */

        CONFIG::LOCALE_TCN
        private static const _MESSAGE_SET:Array = [
            "","","","","","","","","","","","","","","",            // 0～14
            "__FRIEND_NAME__發現渦「__PRF__」了！\n協助他將「__B_NAME__」擊破吧！\nBOSS的最大HP為「__B_HP__」！",       // 15
            "成功擊破渦「__PRF__」了！\n恭喜！",          // 16
            "成功擊破渦「__PRF__」的__BOSS__了！\n__NAME__造成了__DMG__傷害，排名第__RANK__名。\n請收下名次獎勵。",          // 17
            "成功擊破渦「__PRF__」的__BOSS__了！\n__NAME__造成了__DMG__傷害，排名第__RANK__名。\n請收下擊破獎勵。",          // 18
            "渦「__PRF__」的「__B_NAME__」擊破失敗。",                                                                  // 19
            // "成攻擊退渦「__PRF__」的__BOSS__了！\n__NAME__得到積分__DMG__，第__RANK__名。\n請收下發現獎勵。",          // 19
            // "渦「__PRF__」的__BOSS__成功擊退！　榜上有名！",          // 19
            ]; /* of String */

        CONFIG::LOCALE_SCN
        private static const _MESSAGE_SET:Array = [
            "","","","","","","","","","","","","","","",            // 0～14
            "__FRIEND_NAME__发现漩涡「__PRF__」！\n一起协力击破首领「__B_NAME__」吧！\n首领的最大HP为「__B_HP__」！",   // 15
            "成功击退漩涡［__PRF__］！\n恭喜！",          // 16
            "成功击退漩涡［__PRF__］的__BOSS__！\n__NAME__得分__DMG__，排在第__RANK__名。\n请接收排位奖励。",          // 17
            "成功击破漩涡［__PRF__］的__BOSS__！\n__NAME__得分__DMG__，排名第__RANK__名。\n请接收击破奖励。",          // 18
            "成功击破漩涡「__PRF__」的「__B_NAME__」失败。",                                                            // 19
            ]; /* of String */

        CONFIG::LOCALE_EN
        private static const _MESSAGE_SET:Array = [
            "","","","","","","","","","","","","","","",            // 0～14
           "__FRIEND_NAME__ discovered the vortex [__PRF__]!\nLet's team up to take down the vortex boss [__B_NAME__], who has __B_HP__ HP!",     // 15
            "Congratulations!\nThe vortex [__PRF__] was defeated!",          // 16
            "__BOSS__ of the vortex [__PRF__] was defeated!\n__NAME__ dealt __DMG__ damage, and finished in position __RANK__.\nPlease accept a reward for your position!",          // 17
            "__BOSS__ of the vortex [__PRF__] was defeated!\n__NAME__ dealt __DMG__ damage, and finished in position __RANK__.\nPlease accept a reward for your victory!",          // 18
            "You failed to defeat __B_NAME__ of the vortex [__PRF__].",                                                                            // 19
            ]; /* of String */

        CONFIG::LOCALE_KR
        private static const _MESSAGE_SET:Array = [
            "","","","","","","","","","","","","","","",            // 0～14
            "__FRIEND_NAME__さんが渦「__PRF__」を発見しました！\n協力してボス「__B_NAME__」を撃破しましょう！\nボスの最大HPは「__B_HP__」です！",     // 15
            "渦「__PRF__」の撃退に成功しました！\nおめでとうございます！",          // 16
            "渦「__PRF__」の__BOSS__の撃退に成功しました！\n__NAME__さんはスコア__DMG__で、__RANK__位でした\n 順位報酬をお受け取りください",          // 17
            "渦「__PRF__」の__BOSS__の撃退に成功しました！\n__NAME__さんはスコア__DMG__で、__RANK__位でした\n 撃破報酬をお受け取りください",          // 18
            "渦「__PRF__」のボス「__B_NAME__」の撃破に失敗しました。",                                                                                // 19
            ]; /* of String */

        CONFIG::LOCALE_FR
        private static const _MESSAGE_SET:Array = [
            "","","","","","","","","","","","","","","",            // 0～14
            "__FRIEND_NAME__ a trouvé le Vortex [__PRF__] !\nCollaborez pour écraser le Boss [__B_NAME__] !\nLe maximum de HP du Boss est __B_HP__ !",  // 15
            "Vous avez réussi à écraser le [__PRF__] !",          // 16
            "Vous avez réussi à écraser le [__BOSS__] du Vortex [__PRF__] !\n__NAME__ a infligé __DMG__dommages. __RANK__ ème.\nAccepter la rétribution liée à votre classement.",          // 17
            "Vous avez réussi à écraser le [__BOSS__] du Vortex [__PRF__] !\n__NAME__ a infligé __DMG__dommages. __RANK__ ème.\nAccepter la rétribution liée à votre victoire.",          // 18
            "échec d'écraser «__PRF__» de Vortex «__B_NAME__» .",                                                                                        // 19
            ]; /* of String */

        CONFIG::LOCALE_ID
        private static const _MESSAGE_SET:Array = [
            "","","","","","","","","","","","","","","",            // 0～14
            "__FRIEND_NAME__さんが渦「__PRF__」を発見しました！\n協力してボス「__B_NAME__」を撃破しましょう！\nボスの最大HPは「__B_HP__」です！",     // 15
            "渦「__PRF__」の撃退に成功しました！\nおめでとうございます！",          // 16
            "渦「__PRF__」の__BOSS__の撃退に成功しました！\n__NAME__さんはスコア__DMG__で、__RANK__位でした\n 順位報酬をお受け取りください",          // 17
            "渦「__PRF__」の__BOSS__の撃退に成功しました！\n__NAME__さんはスコア__DMG__で、__RANK__位でした\n 撃破報酬をお受け取りください",          // 18
            "渦「__PRF__」のボス「__B_NAME__」の撃破に失敗しました。",                                                                                // 19
            ]; /* of String */

        CONFIG::LOCALE_TH
        private static const _MESSAGE_SET:Array = [
            "","","","","","","","","","","","","","","",            // 0～14
            "คุณ_FRIEND_NAME__ค้นพบน้ำวน [__PRF__] แล้ว!\nร่วมมือกันกำจัดบอส [__B_NAME__] กันเถอะ!\nHP สูงสุดของบอสคือ [__B_HP__] ครับ!", // 15 __FRIEND_NAME__さんが渦「__PRF__」を発見しました！\n協力してボス「__B_NAME__」を撃破しましょう！\nボスの最大HPは「__B_HP__」です！
            "ต่อสู้กับ__BOSS__ของน้ำวน [__PRF__] สำเร็จ ! \nคุณ__NAME__ได้รับความเสียหาย__DMG__ได้__RANK__\nกรุณารับค่าตอบแทนการเข้าร่วม",   // 16 渦「__PRF__」の__BOSS__の撃退に成功しました！\n__NAME__さんは__DMG__ダメージ与え、__RANK__位でした\n 参加報酬をお受け取りください
            "ต่อสู้กับ__BOSS__ของน้ำวน [__PRF__] สำเร็จ ! \nคุณ__NAME__ได้รับความเสียหาย__DMG__ได้__RANK__\nกรุณารับค่าตอบแทนลำดับ",   // 17 渦「__PRF__」の__BOSS__の撃退に成功しました！\n__NAME__さんは__DMG__ダメージ与え、__RANK__位でした\n 順位報酬をお受け取りください
            "ต่อสู้กับ__BOSS__ของน้ำวน [__PRF__] สำเร็จ ! \nคุณ__NAME__ได้รับความเสียหาย__DMG__ได้__RANK__\nกรุณรับค่าตอบแทนจากการแพ้",  // 18 渦「__PRF__」の__BOSS__の撃退に成功しました！\n__NAME__さんは__DMG__ダメージ与え、__RANK__位でした\n 撃破報酬をお受け取りください
            "ต่อสู้กับ__BOSS__ของน้ำวน [__PRF__] สำเร็จ ! คุณอยู่ในอันดับสูง !",  // 19 渦「__PRF__」の__BOSS__の撃退に成功しました！ランキング上位入賞者です！
            "ไม่สามารถเอาชนะบอส [__B_NAME__] ของน้ำวน [__PRF__] ได้",                                                           // 20 渦「__PRF__」のボス「__B_NAME__」の撃破に失敗しました。
            ]; /* of String */

        private var _enable:Boolean;


        /**
         * コンストラクタ
         *
         */
        public function ProfoundNoticePanel(type:int = VIEW_TYPE_LOBBY)
        {
            var i:int;
            super();
            _base.nextBtnFunc = setNextPage;
            _base.backBtnFunc = setBackPage;
            _container.addChild(_base);
            _container.addChild(_message);
            _container.addChild(_monsterName);
            _container.addChild(_finderName);
            for (i = 0; i < _findRewardNames.length; i++) {
                _container.addChild(_findRewardNames[i]);
            }
            _container.addChild(_joinRewardName);
            for (i = 0; i < _defeatRewardNames.length; i++) {
                _container.addChild(_defeatRewardNames[i]);
            }
            for (i = 0; i < _rankRewardNames.length; i++) {
                _container.addChild(_rankRewardNames[i]);
            }
            _container.addChild(_myRank);
            for ( i = 0; i < _SHOW_RANKING_NUM; i++) {
                var rank:RankingLabelSet = new RankingLabelSet(i);
                _container.addChild(rank);
                _rankList.push(rank);
            }

            _container.addChild(_baseN);
            _container.addChild(_titleN);
            _container.addChild(_messageN);

            addChild(_container);
            _base.setButtonFunc(pushNextHandler);
            _baseN.setButtonFunc(pushNextHandler);
//            checkInfo();

        }

        public function checkInfo(delID:int = -1):Boolean
        {
            var ret:Boolean = false
            var noticeSet:Vector.<ProfoundNotice> = ProfoundNotice.getNotice(delID);
            if (noticeSet.length >0)
            {
                setNotice(noticeSet[0]);
                show();
                ret = true;
            }else if (_enable){
                hide();
                var num:int = ProfoundNotice.getNoticeNum();
                if (num>0)
                {LobbyCtrl.instance.profoundNoticeClear(num);}
            }
            return ret;
        }

        // 実績ビューを呼び出す
        public function show():void
        {
            // アイテムリスト排他になければいけないので閉じる
            ItemListView.hide();
            _base.ok.visible = false;

            if (_viewType == VIEW_TYPE_LOBBY) {
                x = _LOBBY_X;
                _useY = _LOBBY_Y;
            } else {
                x = _RAID_X;
                _useY = _RAID_Y;
            }

            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new ClousureThread(showBase));

            // if (_currentNotice.type != LobbyNotice.TYPE_FIN_PRF_RANKING && !_isEntry) {
            //     sExec.addThread(new SleepThread(1000));
            //     sExec.addThread(new BeTweenAS3Thread(_base.congrat, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            //     sExec.addThread(new BeTweenAS3Thread(_message, {alpha:1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            //     sExec.addThread(new ClousureThread(function():void{_isEntry = true;}));
            // }

            var cardExec:SerialExecutor = new SerialExecutor();
            if (_tCardClip!=null)
            {
                cardExec.addThread(_tCardClip.getShowThread(_container));
                cardExec.addThread(new SleepThread(200));
                cardExec.addThread(_tCardClip.getFlipThread());
                sExec.addThread(cardExec);
            }

            // 最後にボタンを表示
            if (_viewType == VIEW_TYPE_LOBBY) {
                sExec.addThread(new ClousureThread(function():void{_baseN.ok.visible = true;}));
            } else {
                sExec.addThread(new ClousureThread(function():void{_base.ok.visible = true;}));
            }

            sExec.start();

        }

        private function showBase():void
        {
            // 作ったVIEWをトップビューに突っ込んで背景はクリックできなくする
            BetweenAS3.serial(
                BetweenAS3.addChild(this, Unlight.INS.topContainer.parent),
                BetweenAS3.to(this,{y:_useY},0.3, Quad.easeOut)
                ).play();
            Unlight.INS.topContainer.mouseEnabled = false;
            Unlight.INS.topContainer.mouseChildren = false;
            _enable = true;
        }

        public  function hide():void
        {
            BetweenAS3.serial(
                BetweenAS3.tween(this, {y:_START_Y}, null, 0.15, Sine.easeOut),
                BetweenAS3.removeFromParent(this)
                ).play()
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
            _enable = false;
            _isEntry = false;
        }

        private function setNotice(n:ProfoundNotice):void
        {
            _currentNotice = n;
            var prf:Profound;
            switch (n.type)
            {
            case LobbyNotice.TYPE_GET_PROFOUND:
                _viewType = VIEW_TYPE_LOBBY;
                _base.visible = false;
                _baseN.visible = true;
                _baseN.setNewsMode();
                _titleN.visible = true;
                _message.visible = false;
                _messageN.visible = true;
                _tCardClip = null;
                _myRank.visible = false;
                rankStrVisible(false);
                _base.nextBtnVisible = false;
                _base.backBtnVisible = false;
                var prfMsg:String = _MESSAGE_SET[n.type]
                    .replace("__FRIEND_NAME__",n.finderName)
                    .replace("__PRF__",n.raidObj["prfName"])
                    .replace("__B_NAME__",n.raidObj["bossName"])
                    .replace("__B_HP__",n.raidObj["bossHp"]);
                createTitleAndMessage(n.type, prfMsg);
                break;
            case LobbyNotice.TYPE_FIN_PRF_WIN:
                _viewType = VIEW_TYPE_RAID;
                _base.visible = true;
                _baseN.visible = false;
                _titleN.visible = false;
                _message.visible = true;
                _messageN.visible = false;
                _tCardClip = null;
                _myRank.visible = false;
                rankStrVisible(false);
                prf = Profound.getProfoundForId(n.prfID);
                _base.nextBtnVisible = false;
                _base.backBtnVisible = false;
                var finPrfMsg:String = _MESSAGE_SET[n.type].replace("__PRF__", n.prfName);
                _base.frame = ProfoundInfoImage.WIN_MSG;
                createInfo(n);
                createMessage(n.type, finPrfMsg);
                break;
            case LobbyNotice.TYPE_FIN_PRF_REWARD:
                _viewType = VIEW_TYPE_RAID;
                _base.visible = true;
                _baseN.visible = false;
                _titleN.visible = false;
                _message.visible = false;
                _messageN.visible = false;
                _base.nextBtnVisible = false;
                _base.backBtnVisible = false;
                _myRank.visible = false;
                rankStrVisible(false);
                _base.frame = ProfoundInfoImage.REWARD;
                createTreasueClip(n);
                createRewards(n);
                break;
            case LobbyNotice.TYPE_FIN_PRF_RANKING:
                _viewType = VIEW_TYPE_RAID;
                _base.visible = true;
                _baseN.visible = false;
                _currentNotice.addEventListener(ProfoundNotice.PRF_RESULT_RANKING_UPD, rankingUpdateHandler);
                _titleN.visible = false;
                _message.visible = false;
                _messageN.visible = false;
                rankStrVisible(true);
                _tCardClip = null;
                labelsVisible = false;
                _trsLevel = n.trsLevel;
                _ranking = n.ranking;
                _base.frame = ProfoundInfoImage.RANKING;
                _page = 0;
                pageSet();
                createMyRank(n);
                createRanking(n.type);
                break;
            case LobbyNotice.TYPE_FIN_PRF_FAILED:
                _viewType = VIEW_TYPE_LOBBY;
                _base.visible = false;
                _baseN.visible = true;
                _baseN.setNewsMode();
                _titleN.visible = true;
                _message.visible = false;
                _messageN.visible = true;
                _tCardClip = null;
                _myRank.visible = false;
                rankStrVisible(false);
                _base.nextBtnVisible = false;
                _base.backBtnVisible = false;
                var prfMsg2:String = _MESSAGE_SET[n.type]
                    .replace("__PRF__",n.raidObj["prfName"])
                    .replace("__B_NAME__",n.raidObj["bossName"]);
                createTitleAndMessage(n.type, prfMsg2);
                break;


            }

        }

        private function createTitleAndMessage(t:int,mess:String,fontSize:int=0):void
        {
            _titleN.text = _TITLE_SET[t];
            _titleN.x = 300;
            _titleN.y = 166;
            _titleN.width = 150;
        CONFIG::LOCALE_EN
        {
            _titleN.width = 230;
            _titleN.x = 260;
            _titleN.y = 169;
        }
        CONFIG::LOCALE_FR
        {
            _titleN.width = 230;
            _titleN.x = 260;
            _titleN.y = 169;
        }
            _titleN.height = 30;
            _titleN.filters = [ new GlowFilter(0x000000, 1, 2, 2, 16, 1) ];
            _titleN.styleName = "LoginInfoTitle";

            _messageN.htmlText = mess;
            _messageN.x = 210;
            _messageN.y = 200;
            _messageN.width = 400;
            _messageN.height =300;
            _messageN.styleName = "LoginInfoLabel";
            if (fontSize > 0) {
                _messageN.setStyle("fontSize",fontSize);
            } else {
                _messageN.setStyle("fontSize",16);
            }
            _messageN.selectable = false;
        }

        private function createTreasueClip(n:ProfoundNotice):void
        {
            log.writeLog(log.LV_DEBUG, this, "ACHI tc cre",n.treType, n.cardType, n.itemID, n.num);
            _tCardClip = TreasureCardClip.createNoticeTreasure(n.treType, n.cardType, n.itemID, n.num);
            _tCardClip.x = 440;
            _tCardClip.y = 170;
            _tCardClip.mouseEnabled = false;
            _tCardClip.mouseChildren = false;
        }

        private function createMessage(t:int,mess:String):void
        {
            _message.htmlText = mess;
            _message.x = 120;
            _message.y = 80;
            _message.width = 300;
            _message.height =230;
            _message.styleName = "RaidInfoLabel";
            _message.setStyle("fontSize",13);
            _message.selectable = false;
            _message.mouseEnabled = false;
            _message.mouseChildren = false;
        }
        private function createInfo(n:ProfoundNotice):void
        {
            _monsterName.text = n.bossName;
            _monsterName.x = 163;
            _monsterName.y = 175;
            _monsterName.width = 250;
            _monsterName.height = 40;
            _monsterName.styleName = "RaidInfoLabel";
            _monsterName.setStyle("fontSize",10);
            _monsterName.selectable = false;
            _monsterName.mouseEnabled = false;
            _monsterName.mouseChildren = false;
            _monsterName.visible = true;

            _finderName.text = n.finderName.replace("_rename","");
            _finderName.x = 163;
            _finderName.y = 215;
            _finderName.width = 250;
            _finderName.height =40;
            _finderName.styleName = "RaidInfoLabel";
            _finderName.setStyle("fontSize",10);
            _finderName.selectable = false;
            _finderName.mouseEnabled = false;
            _finderName.mouseChildren = false;
            _finderName.visible = true;

            var i:int;
            for (i = 0; i < _findRewardNames.length; i++) {
                _findRewardNames[i].visible = false;
            }
            _joinRewardName.visible = false;
            for (i = 0; i < _defeatRewardNames.length; i++) {
                _defeatRewardNames[i].visible = false;
            }
            for (i = 0; i < _rankRewardNames.length; i++) {
                _rankRewardNames[i].visible = false;
            }
            _myRank.visible = false;

        }
        private function createRewards(n:ProfoundNotice):void
        {
            log.writeLog(log.LV_DEBUG, this, "createReward ",n.rewards);
            var rewArr:Array = n.rewards.split("-");
            log.writeLog(log.LV_DEBUG, this, "createReward 1",rewArr);
            var i:int;
            var iType:int;
            var itemId:int;
            var num:int;
            var cType:int;

            // 参加報酬
            var all:Array = rewArr.shift().split("+");
            log.writeLog(log.LV_DEBUG, this, "createReward 2",all);
            var allNameList:Array = [];
            all.forEach(function(item:String, index:int, array:Array):void
                        {
                            var itemData:Array = item.split("_");
                            if (int(itemData[0]) != 0) {
                                iType = itemData[0];
                                itemId = itemData[1];
                                num = itemData[2];
                                cType = itemData[3];
                                allNameList.push(getItemName(iType,itemId,cType,num));
                            }
                        });
            log.writeLog(log.LV_DEBUG, this, "createReward 2",allNameList);
            if (allNameList.length > 0) {
                setLabel(_joinRewardName,allNameList.join("+"),130,135);
            } else {
                _joinRewardName.visible = false;
            }

            // ランキング順位報酬
            var rank:Array = rewArr.shift().split("+");
            log.writeLog(log.LV_DEBUG, this, "createReward 3",rank);
            var rankNameList:Array = [];
            rank.forEach(function(item:String, index:int, array:Array):void
                        {
                            var itemData:Array = item.split("_");
                            if (int(itemData[0]) != 0) {
                                iType = itemData[0];
                                itemId = itemData[1];
                                num = itemData[2];
                                cType = itemData[3];
                                rankNameList.push(getItemName(iType,itemId,cType,num));
                            }
                        });
            log.writeLog(log.LV_DEBUG, this, "createReward 3",rankNameList);
            for(i = 0; i < _rankRewardNames.length; i++) {
                if (rankNameList[i]) {
                    setLabel(_rankRewardNames[i],rankNameList[i],130,230+15*i);
                } else {
                    _rankRewardNames[i].visible = false;
                }
            }

            // 撃破報酬
            var defeat:Array = rewArr.shift().split("+");
            log.writeLog(log.LV_DEBUG, this, "createReward 4",defeat);
            var defeatNameList:Array = [];
            defeat.forEach(function(item:String, index:int, array:Array):void
                        {
                            var itemData:Array = item.split("_");
                            if (int(itemData[0]) != 0) {
                                iType = itemData[0];
                                itemId = itemData[1];
                                num = itemData[2];
                                cType = itemData[3];
                                defeatNameList.push(getItemName(iType,itemId,cType,num));
                            }
                        });
            log.writeLog(log.LV_DEBUG, this, "createReward 4",defeatNameList);
            for(i = 0; i < _defeatRewardNames.length; i++) {
                if (defeatNameList[i]) {
                    setLabel(_defeatRewardNames[i],defeatNameList[i],130,175+15*i);
                } else {
                    _defeatRewardNames[i].visible = false;
                }
            }

            // 発見報酬
            var found:Array = rewArr.shift().split("+");
            log.writeLog(log.LV_DEBUG, this, "createReward 5",found);
            var foundNameList:Array = [];
            found.forEach(function(item:String, index:int, array:Array):void
                        {
                            var itemData:Array = item.split("_");
                            if (int(itemData[0]) != 0) {
                                iType = itemData[0];
                                itemId = itemData[1];
                                num = itemData[2];
                                cType = itemData[3];
                                foundNameList.push(getItemName(iType,itemId,cType,num));
                            }
                        });
            log.writeLog(log.LV_DEBUG, this, "createReward 5",foundNameList);
            for(i = 0; i < _findRewardNames.length; i++) {
                if (foundNameList[i]) {
                    setLabel(_findRewardNames[i],foundNameList[i],130,65+15*i);
                } else {
                    _findRewardNames[i].visible = false;
                }
            }


            _monsterName.visible = false;
            _finderName.visible = false;
        }
        private function getItemName(t:int,id:int,ct:int,num:int):String
        {
            var ret:String = "";
            switch (t)
            {
            case Const.TG_CHARA_CARD:
                var cc:CharaCard = CharaCard.ID(id);
                if (cc) {
                    if (cc.kind == Const.CC_KIND_CHARA || cc.kind == Const.CC_KIND_REBORN_CHARA) {
                        ret += "Lv"+cc.level;
                    }
                    ret += cc.name;
                }
                break;
            case Const.TG_AVATAR_ITEM:
                ret = AvatarItem.ID(id).name;
                break;
            case Const.TG_AVATAR_PART:
                ret = AvatarPart.ID(id).name;
                break;
            case Const.TG_SLOT_CARD:
                switch (ct)
                {
                case Const.SCT_WEAPON:
                    ret = WeaponCard.ID(id).name;
                    break;
                case Const.SCT_EQUIP:
                    ret = EquipCard.ID(id).name;
                    break;
                case Const.SCT_EVENT:
                    ret = EventCard.ID(id).name;
                    break;
                default:
                }
                break;
            case Const.TG_GEM:
                ret = num.toString() + "Gem";
                break;
            default:
            }
            if (t != Const.TG_GEM && num > 1) {
                ret += "×" + num.toString();
            }
            return ret;
        }
        private function setLabel(l:Label,text:String,x:int,y:int):void
        {
            log.writeLog(log.LV_DEBUG, this, "setLabel ",l,text,x,y);
            l.text = text;
            l.x = x;
            l.y = y;
            l.width = 250;
            l.height = 40;
            l.styleName = "RaidInfoLabel";
            l.setStyle("fontSize",10);
            l.selectable = false;
            l.mouseEnabled = false;
            l.mouseChildren = false;
            l.visible = true;
        }
        private function set labelsVisible(f:Boolean):void
        {
            var i:int;
            _message.visible = f;
            _monsterName.visible = f;
            _finderName.visible = f;
            _joinRewardName.visible = f;
            for (i = 0; i < _findRewardNames.length; i++) {
                _findRewardNames[i].visible = f;
            }
            for (i = 0; i < _defeatRewardNames.length; i++) {
                _defeatRewardNames[i].visible = f;
            }
            for (i = 0; i < _rankRewardNames.length; i++) {
                _rankRewardNames[i].visible = f;
            }
        }

        private function setNextPage():void
        {
            _page += 1;
            pageSet();
        }
        private function setBackPage():void
        {
            _page -= 1;
            pageSet();
        }
        private function pageSet():void
        {
            log.writeLog(log.LV_FATAL, this, "pageSet",_page,_ranking.length,RANKING_NUM,Math.ceil(_ranking.length/RANKING_NUM-1));
            if (_ranking.length < RANKING_NUM) {
                _page = 0;
                _base.backBtnVisible  = false;
                _base.nextBtnVisible  = false;
            } else {
                if (_page <= 0) {
                    _page = 0;
                    _base.backBtnVisible  = false;
                    _base.nextBtnVisible  = true;
                } else if (_page < (_ranking.length/RANKING_NUM)) {
                    if (_page > 0) {
                        _base.backBtnVisible  = true;
                    } else {
                        _base.backBtnVisible  = false;
                    }
                    _base.nextBtnVisible  = true;
                } else if (_page >= (_ranking.length/RANKING_NUM)) {
                    _page = Math.round(_ranking.length/RANKING_NUM);
                    _base.backBtnVisible  = true;
                    _base.nextBtnVisible  = false;
                }
            }
            updateRanking();
        }

        private function createFoundBonusMess(t:int,trsLevel:int):void
        {
            var bonus:Array = ProfoundTreasureData.getFoundBonus(trsLevel);
            var names:Array = getBonusItemNames(bonus);
            if (names.length > 0) {
                _message.htmlText = names.join("+");
            } else {
                _message.htmlText = "-----";
            }
            _message.x = 130;
            _message.y = 62;
            _message.width = 210;
            _message.height = 16;
            _message.styleName = "RaidInfoLabel";
            _message.setStyle("fontSize",10);
            _message.selectable = false;
            _message.mouseEnabled = false;
            _message.mouseChildren = false;
        }

        private function createMyRank(n:ProfoundNotice):void
        {
            if (_avatar == null) {
                _avatar = Player.instance.avatar;
            }
            log.writeLog(log.LV_DEBUG, this, "createRankng",_avatar);
            _myRank.setStr(n.selfRank,_avatar.name,n.selfDmg);
            _myRank.resetPos(35,63);
            _myRank.visible = true;
        }
        private function createRanking(t:int):void
        {
            log.writeLog(log.LV_DEBUG, this, "createRankng",_trsLevel,_ranking);
            createFoundBonusMess(t,_trsLevel);
            updateRanking();
        }
        private function updateRanking():void
        {
            if (_ranking) {
                var len:int = _ranking.length;
                if (len > RANKING_NUM) len = RANKING_NUM;
                for ( var i:int = 0; i < len; i++) {
                    var idx:int = i + _page * RANKING_NUM;
                    log.writeLog(log.LV_DEBUG, this, "updateRankng",i,_page,idx);
                    if (_ranking[idx]) {
                        var bonus:Array =  ProfoundTreasureData.getRankBonus(_trsLevel,_ranking[idx]["rank"]);
                        var names:Array = getBonusItemNames(bonus);
                        _rankList[i].setStr(_ranking[idx]["rank"],_ranking[idx]["name"].replace("_rename",""),_ranking[idx]["dmg"],names.join("+"));
                    } else {
                        _rankList[i].rankVisible = false;
                    }
                }
                log.writeLog(log.LV_FATAL, this, "updateRankng finish.");
            }
        }
        private function getBonusItemNames(bonus:Array):Array
        {
            var names:Array = [];
            log.writeLog(log.LV_DEBUG, this, "createBonusItemNames",bonus);
            for (var i:int = 0; i < bonus.length; i++) {
                var name:String = "";
                switch (bonus[i].treasureType)
                {
                case Const.TG_CHARA_CARD:
                    var cc:CharaCard = CharaCard.ID(bonus[i].treasureId);
                    if (cc) {
                        if (cc.kind == Const.CC_KIND_CHARA || cc.kind == Const.CC_KIND_REBORN_CHARA) {
                            name += "Lv"+cc.level;
                        }
                        name += cc.name;
                    }
                    break;
                case Const.TG_SLOT_CARD:
                    switch (bonus[i].slotType)
                    {
                    case Const.SCT_EQUIP:
                        if (EquipCard.ID(bonus[i].treasureId)) {name = EquipCard.ID(bonus[i].treasureId).name;}
                        break;
                    case Const.SCT_EVENT:
                        if (EventCard.ID(bonus[i].treasureId)) {name = EventCard.ID(bonus[i].treasureId).name;}
                        break;
                    case Const.SCT_WEAPON:
                        if (WeaponCard.ID(bonus[i].treasureId)) {name = WeaponCard.ID(bonus[i].treasureId).name;}
                        break;
                    default:
                        name = EventCard.ID(1).name;;
                    }
                    break;
                case Const.TG_AVATAR_ITEM:
                    if (AvatarItem.ID(bonus[i].treasureId))  {name = AvatarItem.ID(bonus[i].treasureId).name;}
                    break;
                case Const.TG_AVATAR_PART:
                    if (AvatarPart.ID(bonus[i].treasureId))  {name = AvatarPart.ID(bonus[i].treasureId).name;}
                    break;
                case Const.TG_GEM:
                case Const.TG_OWN_CARD:
                case Const.TG_NONE:
                case Const.TG_BONUS_GAME:
                default:
                    break;
                }
                if (bonus[i].treasureType == Const.TG_GEM) {
                    name = String(bonus[i].value)+"Gem";
                } else {
                    name += "×" + String(bonus[i].value);
                }
                names.push(name);
            }
            return names;
        }

        private function rankStrVisible(v:Boolean):void
        {
            for ( var i:int = 0; i < _rankList.length; i++) {
                _rankList[i].rankVisible = v;
            }
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

            _base.setButtonFunc();

            _container.removeChild(_base);
            _container.removeChild(_message);
            for (var i:int = 0; i < _rankList.length;i++) {
                _container.removeChild(_rankList[i]);
            }

            removeChild(_container);
        }

        private function rankingUpdateHandler(e:Event):void
        {
            _ranking = _currentNotice.ranking;
            createMyRank(_currentNotice);
            createRanking(_currentNotice.type);
        }

        private function pushNextHandler(e:MouseEvent):void
        {
            if (_tCardClip!=null)
            {
                _tCardClip.getHideThread().start();
            }
            checkInfo(_currentNotice.id);
        }


        private function pushExitHandler(e:MouseEvent):void
        {
            // _base.ok.removeEventListener(MouseEvent.CLICK, pushExitHandler);
            // _base.ok.addEventListener(MouseEvent.CLICK, pushNextHandler);
            _base.setButtonFunc(pushNextHandler);
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

        public function getBringOnThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            if (_tCardClip!=null)
            {
                sExec.addThread(_tCardClip.getShowThread(_container));
                sExec.addThread(new SleepThread(200));
                sExec.addThread(_tCardClip.getFlipThread());
            }
            return sExec;
        }
        public function panelEnable():Boolean
        {
            return _enable;
        }
    }
}


import flash.display.*;
import flash.filters.GlowFilter;
import flash.filters.DropShadowFilter;
import flash.text.*;
import flash.geom.*;

import mx.core.UIComponent;
import mx.controls.*;

import view.scene.BaseScene;

class RankingLabelSet extends BaseScene
{
    private const _TRANS_RANK_STR:String = "__RANK__位";
    private const _TRANS_DMG_STR:String  = "[__DMG__]";

    private var _rankLabel:Label = new Label;
    private var _nameLabel:Label = new Label;
    private var _dmgLabel:Label = new Label;
    private var _rewardLabel:Label = new Label;

    private const _X:int       = 35;
    private const _NAME_X:int  = _X + 40;
    private const _REWARD_X:int  = _NAME_X + 160;
    private const _Y:int       = 110;
    private const _W:int       = 190;
    private const _H:int       = 16;

    public function RankingLabelSet(idx:int):void
    {
        _rankLabel.x = _dmgLabel.x = _X;
        _nameLabel.x = _NAME_X;
        _rewardLabel.x = _REWARD_X;
        _rankLabel.y = _nameLabel.y = _dmgLabel.y = _rewardLabel.y = _Y + (_H * idx);
        _rankLabel.width = _nameLabel.width = _dmgLabel.width = _rewardLabel.width = _W;
        _rankLabel.height = _nameLabel.height = _dmgLabel.height = _rewardLabel.height = _H;
        _rankLabel.mouseEnabled = _nameLabel.mouseEnabled = _dmgLabel.mouseEnabled = _rewardLabel.mouseEnabled = false;
        _rankLabel.mouseChildren = _nameLabel.mouseChildren = _dmgLabel.mouseChildren = _rewardLabel.mouseEnabled = false;
        _rankLabel.visible = _nameLabel.visible = _dmgLabel.visible = _rewardLabel.visible = false;

        _rankLabel.styleName = "RankingLabel";
        _rankLabel.setStyle("textAlign","left");
        _rankLabel.filters = [new GlowFilter(0xFFFFFF, 1, 1.5, 1.5, 16, 1),];

        _nameLabel.setStyle("textAlign","left");
        _nameLabel.setStyle("color","#FFFFFF");

        _dmgLabel.setStyle("textAlign","right");
        _dmgLabel.setStyle("color","#FFFFFF");

        _rewardLabel.setStyle("textAlign","left");
        _rewardLabel.setStyle("color","#FFFFFF");
        _rewardLabel.text = "";

        addChild(_rankLabel);
        addChild(_nameLabel);
        addChild(_dmgLabel);
        addChild(_rewardLabel);
    }

    public override function init():void
    {
    }

    public function resetPos(x:int,y:int):void
    {
        _rankLabel.x = _dmgLabel.x = x;
        _nameLabel.x = x + 40;
        _rankLabel.y = _nameLabel.y = _dmgLabel.y = y;
    }

    public function setStr(rank:int,name:String,dmg:int,rewards:String=""):void
    {
        if (rank > 0) {
            _rankLabel.text = _TRANS_RANK_STR.replace("__RANK__",rank.toString());
        } else {
            _rankLabel.text = "--";
        }
        _nameLabel.text = name;
        _dmgLabel.text = _TRANS_DMG_STR.replace("__DMG__",dmg.toString());
        if (dmg > 0)  {
            _rewardLabel.text = rewards;
        } else {
            _rewardLabel.text = "";
        }
        _rankLabel.visible = _nameLabel.visible = _dmgLabel.visible = _rewardLabel.visible = true;
    }

    public function set rankVisible(v:Boolean):void
    {
        _rankLabel.visible = _nameLabel.visible = _dmgLabel.visible = _rewardLabel.visible = v;
    }

    public override function final():void
    {
        removeChild(_rankLabel);
        removeChild(_nameLabel);
        removeChild(_dmgLabel);
        removeChild(_rewardLabel);
    }
}