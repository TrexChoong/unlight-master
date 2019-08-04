package view
{
    import flash.display.*;
    import flash.filters.*;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import mx.core.UIComponent;
    import mx.core.MovieClipLoaderAsset;
    import mx.containers.*;
    import mx.controls.*;


    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;


    import model.*;
    import model.events.*;

    import view.image.lot.*;
    import view.scene.common.*;
    import view.scene.*;
    import view.scene.lot.*;
    import view.utils.*;

    import controller.*;

    /**
     * Lot画面のビュークラス
     *
     */

    public class LotView extends Thread
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_TITLE:String = "レアカードくじ";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1:String ="ようこそダークルームへ。ここは戦士の魂が眠る場所。\n目覚めさせるためにあなたの運を使ってみますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2:String ="ボタンを押すとチケットを消費してカードが3枚現れ、その中の1枚をランダムで得ることができます。このレアカードくじでは、各種キャラカード・各種アイテム・装備カードが出現します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG3:String ="ボタンを押すとチケットを消費してカードが3枚現れ、その中の1枚をランダムで得ることができます。このレアカードくじでは、合成用カード・各種キャラカード・各種アイテム・レアカードが出現します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG4:String ="ボタンを押すとチケットを消費してカードが3枚現れ、その中の1枚をランダムで得ることができます。このレアカードくじでは、合成用カード・各種レアカード・専用装備カード・イベントカードが出現します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG5:String ="さてあなたの運命は・・・";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG6:String ="を得ることが出来ました。\nおめでとうございます。";

        CONFIG::LOCALE_EN
        private static const _TRANS_TITLE:String = "Rare Card Lottery";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1:String ="Welcome to the Darkroom. Here sleep the souls of powerful warriors.\nFeel like trying your luck, see who wakes up?";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2:String ="Click the button to spend 1 ticket and 3 cards will be revealed. You will receive one of those cards at random. In this lottery you can win character, item or equipment cards.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG3:String ="Click the button to spend 1 ticket and 3 cards will be revealed. You will receive one of those cards at random. In this lottery you can win synthesis material, character, item, equipment or rare cards.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG4:String ="Click the button to spend 1 ticket and 3 cards will be revealed. You will receive one of those cards at random. In this lottery you can win synthesis material, rare or equipment cards.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG5:String ="So, what will be your fate?";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG6:String ="Congratulations! You won ";

        CONFIG::LOCALE_TCN
        private static const _TRANS_TITLE:String = "稀有卡抽獎";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1:String ="歡迎來到暗房。這裡是戰士們沉睡的場所。\n要使用您的運氣來讓他們甦醒嗎？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2:String ="按下按鈕後將會消耗抽獎卷出現3張卡片,然後隨機得到其中的1張。此稀有卡抽獎中有機會出現各種角色卡、各種道具卡以及裝備卡。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG3:String ="按下按鈕後將會消耗抽獎卷出現3張卡片,然後隨機得到其中的1張。此稀有卡抽獎中有機會出現各種角色卡、各種道具卡、角色專用裝備卡以及稀有卡。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG4:String ="按下按鈕後將會消耗抽獎卷出現3張卡片,然後隨機得到其中的1張。此稀有卡抽獎中有機會出現合成用卡、各種稀有卡以及角色專用裝備卡。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG5:String ="您的命運會是···";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG6:String ="恭喜您得到了";

        CONFIG::LOCALE_SCN
        private static const _TRANS_TITLE:String = "稀有卡抽奖";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1:String ="欢迎来到暗房。这里是战士的沉眠之地。用您的运气试着唤醒吧？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2:String ="按下按钮将会消耗抽奖券，这时会出现3张卡片，您可随机获得其中1张卡片。稀有卡抽奖的卡片包含合成卡、各种稀有卡、专用装备卡。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG3:String ="按下按钮将会消耗抽奖券，这时会出现3张卡片，您可随机获得其中1张卡片。稀有卡抽奖的卡片包含合成卡、各种稀有卡、专用装备卡。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG4:String ="按下按钮将会消耗抽奖券，这时会出现3张卡片，您可随机获得其中1张卡片。稀有卡抽奖的卡片包含合成卡、各种稀有卡、专用装备卡。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG5:String ="那么，您的命运将会……";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG6:String ="成功获得";

        CONFIG::LOCALE_KR
        private static const _TRANS_TITLE:String = "레어카드 복권";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1:String ="다크룸에 어서 오십시오. 이곳은 전사의 혼이 잠든 장소.\n전사를 깨우기 위해 당신의 운을 시험해보지 않으시겠습니까?";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2:String ="버튼을 누르면 티켓을 소비해서 카드가 3장 나타납니다. \n그 안의 1장을 랜덤하게 얻을 수 있습니다. \n이 레어카드 복권에서는 각종 캐릭터 카드, 각종 아이템, 장비 카드가 나타납니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG3:String ="버튼을 누르면 티켓을 소비해서 카드가 3장 나타납니다. \n그 안의 1장을 랜덤하게 얻을 수 있습니다. \n이 레어카드 복권에서는 합성용 카드, 각종 캐릭터 카드, 각종 아이템, 전용 장비 카드, 레어 카드가 나타납니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG4:String ="버튼을 누르면 티켓을 소비해서 카드가 3장 나타납니다. \n그 안의 1장을 랜덤하게 얻을 수 있습니다. \n이 레어카드 복권에서는 합성용 카드, 각종 캐릭터 카드, 전용 장비 카드가 나타납니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG5:String ="그럼 당신의 운명은…";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG6:String ="을(를) 획득했습니다. 축하드립니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_TITLE:String = "Loterie de cartes rares";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1:String ="Bienvenue dans la Pièce Obscure.\nVoilà où reposent les âmes des soldats.\nSouhaitez-vous utiliser votre chance pour réveiller l'Âme de ces Soldats ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2:String ="En cliquant ici, votre ticket disparaîtra en faisant apparaître 3 cartes. Vous pouvez en saisir une au hasard. Cette loterie de cartes rares contient des cartes personnage, objet et équipement.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG3:String ="En cliquant ici, votre ticket disparaîtra en faisant apparaître 3 cartes. Vous pouvez en saisir une au hasard. Cette loterie de cartes rares contient des cartes composition, personnage ou équipement exclusif.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG4:String ="En cliquant ici, votre ticket disparaîtra en faisant apparaître 3 cartes. Vous pouvez en saisir une au hasard. Cette loterie de cartes rares contient des cartes composition, personnage ou équipement exclusif.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG5:String ="Alors, que vous réserve le destin ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG6:String ="Felicitations !! Vous obtenez ";

        CONFIG::LOCALE_ID
        private static const _TRANS_TITLE:String = "レアカードくじ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1:String ="ようこそダークルームへ。ここは戦士の魂が眠る場所。\n目覚めさせるためにあなたの運を使ってみますか？";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2:String ="ボタンを押すとチケットを消費してカードが3枚現れ、その中の1枚をランダムで得ることができます。このレアカードくじでは、各種キャラカード・各種アイテム・装備カードが出現します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG3:String ="ボタンを押すとチケットを消費してカードが3枚現れ、その中の1枚をランダムで得ることができます。このレアカードくじでは、合成用カード・各種キャラカード・各種アイテム・レアカードが出現します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG4:String ="ボタンを押すとチケットを消費してカードが3枚現れ、その中の1枚をランダムで得ることができます。このレアカードくじでは、合成用カード・各種レアカード・専用装備カード・イベントカードが出現します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG5:String ="さてあなたの運命は・・・";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG6:String ="を得ることが出来ました。\nおめでとうございます。";

        CONFIG::LOCALE_TH
        private static const _TRANS_TITLE:String = "สลากเสี่ยงแรร์การ์ด";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1:String ="ยินดีต้อนรับสู่ Dark Room นี่คือสถานที่ที่วิญญาณของนักรบหลับใหลอยู่\nจะลองใช้ดวงชะตาของท่านเพื่อปลุกชีพเหล่านักรบหรือไม่?";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2:String ="หากกดปุ่ม ตั๋วจะหายไปแล้วมีการ์ด 3 ใบปรากฎขึ้นมาแทนที่ และสามารถสุ่มเลือกการ์ด 1 ใน 3 ใบได้ การสุ่มเลือกแรร์การ์ดจะมีการ์ดตัวละคร, การ์ดไอเท็ม และการ์อาวุธ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG3:String ="หากกดปุ่ม ตั๋วจะหายไปแล้วมีการ์ด 3 ใบปรากฎขึ้นมาแทนที่ และสามารถสุ่มเลือกการ์ด 1 ใน 3 ใบได้ การสุ่มเลือกแรร์การ์ดจะมีการ์ดสำหรับผสม, การ์ดตัวละคร, การ์ดไอเท็ม และแรร์การ์ดอาวุธเฉพาะ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG4:String ="หากกดปุ่ม ตั๋วจะหายไปแล้วมีการ์ด 3 ใบปรากฎขึ้นมาแทนที่ และสามารถสุ่มเลือกการ์ด 1 ใน 3 ใบได้ การสุ่มเลือกแรร์การ์ดจะมีการ์ดสำหรับผสม, การ์ดตัวละคร, การ์ดไอเท็ม และการ์ดอาวุธเฉพาะ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG5:String ="เอาล่ะ ดวงชะตาครั้งนี้ของท่านก็คือ...";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG6:String ="ขอแสดงความยินดี\nท่านได้รับ";



        // 親ステージ
        private var _stage:Sprite;

        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

        private var _bg:BG = new BG();

        private var _exitButton:Button = new Button();

        // タイトル表示
        private var _title:Label = new Label();
        private var _titleJ:Label = new Label();

        // アバタービュー
        private var _avatarView:AvatarView;

        // 定数
        private const _TITLE_X:int = 15;
        private const _TITLE_Y:int = 5;
        private const _TITLE_WIDTH:int = 150;
        private const _TITLE_HEIGHT:int = 40;
        private var _player:Player = Player.instance;

        private var _card1:BaseScene; // あたりカード１
        private var _card2:BaseScene; // あたりカード２
        private var _card3:BaseScene; // あたりカード２
        private static const _DELAY_SET:Array = [[0.0,0.2,0.4],[0.0,0.4,0.2],[0.2,0.0,0.4],[0.2,0.4,0.0],[0.4,0.0,0.2],[0.4,0.2,0.0]]; /* of Numbers */
        private static const _DELAY_NUM:int = 6;
        private var _tween:ITween;

        private const _CARD_X:int = 338;
        private const _CARD_Y_TOP:int = 125;
        private const _CARD_Y_BOTTOM:int = 380;
        private const _CARD_BEZIER_DIFF:int = int((_CARD_Y_BOTTOM-_CARD_Y_TOP)*0.552);
        private const _CARD_Y_MIDDLE:int = 250;

        private var _captionArea:TextArea = new TextArea();
        private var _ticketNum:Label = new Label();
        private var _lastArticleType:int;
        private var _lastArticleID:int;
        private var _lastArticleNum:int;


        private var _bronzePreview:LotItemPreview;
        private var _silverPreview:LotItemPreview;
        private var _goldPreview:LotItemPreview;

        private var _previewSet:Array = []; /* of LotItemPrevire */


        /**
         * コンストラクタ
         * @param stage 親ステージ
         */
        CONFIG::PAYMENT
        public function LotView(stage:Sprite)
        {
            _stage = stage;

            _avatarView = AvatarView.getPlayerAvatar(Const.PL_AVATAR_MATCH);

            _container.addChild(_bg);
//            _container.addChild(_exitButton);

            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);
            LobbyCtrl.instance.addEventListener(DrawLotEvent.SUCCESS, drawLotSuccessHandler);
            LobbyCtrl.instance.addEventListener(AvatarItemEvent.GET_ITEM, getTicketHander);
            _container.addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_LOT));
            Player.instance.avatar.addEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);

            _bronzePreview = LotItemPreview.getLotItemPreview(RareCardLot.KIND_BRONZE);
            _silverPreview = LotItemPreview.getLotItemPreview(RareCardLot.KIND_SILVER);
            _goldPreview = LotItemPreview.getLotItemPreview(RareCardLot.KIND_GOLD);
            _container.addChild(_silverPreview);
            _container.addChild(_bronzePreview);
            _container.addChild(_goldPreview);

            RaidHelpView.instance.isUpdate = true;
        }

        CONFIG::NOT_PAYMENT
        public function LotView(stage:Sprite)
        {
            _stage = stage;

            _avatarView = AvatarView.getPlayerAvatar(Const.PL_AVATAR_MATCH);

            _container.addChild(_bg);
//             _container.addChild(_helpPanel);
//             _container.addChild(_soundPanel);
//            _container.addChild(_exitButton);

            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);
            LobbyCtrl.instance.addEventListener(DrawLotEvent.SUCCESS, drawLotSuccessHandler);
            LobbyCtrl.instance.addEventListener(AvatarItemEvent.GET_ITEM, getTicketHander);
//            _container.addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_LOT));

            _bronzePreview = LotItemPreview.getLotItemPreview(RareCardLot.KIND_BRONZE);
            _silverPreview = LotItemPreview.getLotItemPreview(RareCardLot.KIND_SILVER);
            _goldPreview = LotItemPreview.getLotItemPreview(RareCardLot.KIND_GOLD);
            _container.addChild(_silverPreview);
            _container.addChild(_bronzePreview);
            _container.addChild(_goldPreview);

            RaidHelpView.instance.isUpdate = true;
        }

        // スレッドのスタート
        override protected  function run():void
        {
            // RMItemShopの更新が必要であれば行う
            RealMoneyShopView.itemReset();

            // イベントの登録
            next(initTitle);
        }

        // タイトルの初期化
        private function initTitle():void
        {
//             _previewSet.push(_blozePreview);
//             _previewSet.push(_silverPreview)

            _title.x = _TITLE_X;
            _title.y = _TITLE_Y;
            _title.width = _TITLE_WIDTH;
            _title.height = _TITLE_HEIGHT;
            _title.text = "RareCardLot";
            _title.styleName = "EditTitleLabel";
            _title.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
            _title.alpha = 0.0;

            _titleJ.x = _TITLE_X + 120;
            _titleJ.y = _TITLE_Y + 7;
            _titleJ.width = _TITLE_WIDTH;
            _titleJ.height = _TITLE_HEIGHT;
//            _titleJ.text = "レアカードくじ";
            _titleJ.text = _TRANS_TITLE;
            _titleJ.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _titleJ.alpha = 0.0;
            _captionArea.styleName = "LotViewCaption";
            _captionArea.width = 600;
            _captionArea.height = 80;
            _captionArea.x = 140;
            _captionArea.y = 48;
//            _captionArea.alpha = 0;
            _captionArea.editable = false;
            _captionArea.mouseEnabled = false;
            _captionArea.mouseChildren = false;
            _captionArea.text = _TRANS_MSG1;
            _container.addChild(_captionArea);
            _bg.setOutFunc(mouseOutEvent);
            _bg.setOverBronzeFunc(mouseOverBronzeEvent);
            _bg.setOverSilverFunc(mouseOverSilverEvent);
            _bg.setOverGoldFunc(mouseOverGoldEvent);
            _bg.setDownFunc(mouseDownEvent);

//            LobbyCtrl.instance.alertEnable(false);

            _ticketNum.styleName = "TicketNum";
            _ticketNum.width = 45;
            _ticketNum.height = 20;
            _ticketNum.y = 613;
            _ticketNum.x = 85;
            BetweenAS3.apply(_ticketNum, {_glowFilter: {color: 0xFFFFFF, strength: 1, blurX: 2, blurY: 2}});
            _container.addChild(_ticketNum);
//            _container.addChild(_silverPreview);
            ticketNumUpdate();

            // レイドヘルプイベント
            GlobalChatCtrl.instance.addEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            next(show);
        }

        // 配置オブジェの表示
        private function show():void
        {
            LobbyCtrl.instance.playBGM(LobbyCtrl.BGM_ID_LOT);

            _stage.addChild(_container);

            _stage.addChild(_title);
            _stage.addChild(_titleJ);

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_avatarView.getShowThread(_container));
            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            pExec.start();
            pExec.join();

            next(show2);
        }

        // 配置オブジェの表示
        private function show2():void
        {

            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.start();
            _bg.mouseEnabled = true;
            _bg.mouseChildren = true;
            pExec.join();

            next(waiting);
        }

        // ループ
        private function waiting():void
        {
            if (_player.state == Player.STATE_LOGOUT ||_player.state == Player.STATE_LOBBY )
            {
                next(hide);
            }
            else
            {
                next(waiting);
            }

        }


        // 終了
        private function exitButtonHandler(e:MouseEvent):void
        {
            _container.mouseEnabled = false;
            _container.mouseChildren = false;
            SE.playClick();
            _player.state = Player.STATE_LOBBY;
            log.writeLog(log.LV_INFO, this, "push exit");
        }

        // セールの終了判定が出たときのハンドラ
        private function saleFinishHandler(e:AvatarSaleEvent):void
        {
            // log.writeLog (log.LV_INFO,this,"saleFinish!");
            RealMoneyShopView.hideButtonSaleMC(RealMoneyShopView.TYPE_LOT);
            // ショップアイテムリストの更新
            RealMoneyShopView.itemReset();
        }

        private function helpAcceptHandler(e:RaidHelpEvent):void
        {
            _container.mouseEnabled = false;
            _container.mouseChildren = false;
            _player.state = Player.STATE_LOBBY;
        }

        private function createCard(type:int, id:int, num:int):BaseScene
        {
            switch (type)
            {
                case Const.LOT_ARTICLE_ITEM:
                    return  new ItemCardClip(AvatarItem.ID(id),num);
                    break;
                case Const.LOT_ARTICLE_PART:
                    return new PartCardClip(AvatarPart.ID(id));
                    break;
                case Const.LOT_ARTICLE_EVENT:
                    return new EventCardClip(EventCard.ID(id));
                    break;
                case Const.LOT_ARTICLE_WEAPON:
                    return new WeaponCardClip(WeaponCard.ID(id));
                    break;
                case Const.LOT_ARTICLE_CHARA:
                    return new CharaCardClip(CharaCard.ID(id),true);
                    break;
                default:
                    return new CharaCardClip(CharaCard.ID(1),true);
            }
        }
        private function initCardPositon():void
        {
            _card1.scaleY = _card1.scaleX =_card2.scaleY = _card2.scaleX=_card3.scaleY = _card3.scaleX = 0.75;

            _card1.x = _card2.x = _card3.x = _CARD_X;
            _card1.y = _card2.y= _card3.y = -200;

            var d:Array = _DELAY_SET[int(Math.random()*_DELAY_NUM)]; /* of Number */
            _tween = BetweenAS3.serial(
                BetweenAS3.parallel(createCircleTween(_card1,d[0]),createCircleTween(_card2, d[1]),createCircleTween(_card3, d[2])),
                BetweenAS3.parallel(createFinishTween(_card1,true),createFinishTween(_card2, false),createFinishTween(_card3, false))
                );

        }
        private function ticketNumUpdate():void
        {
            _ticketNum.text = Player.instance.avatar.tickets.toString();
//            _ticketNum.text = "100"
        }
        private function getTicketHander(e:AvatarItemEvent):void
        {
            if (e.id == Const.RARE_CARD_TICKET)
            {
                ticketNumUpdate();
            }
        }


        // 円運動のTweenを作る
        private function createCircleTween(c:BaseScene,delay:Number = 0.0):ITween
        {
            return BetweenAS3.delay(BetweenAS3.serial
                (
                    BetweenAS3.tween(c,
                     {x: _CARD_X, y: _CARD_Y_TOP},
                                     null,
                                     0.5/Unlight.SPEED,
                                     Sine.easeIn
                        ),
                    BetweenAS3.bezier(c, {x: _CARD_X, y: _CARD_Y_BOTTOM}, null, {x: [_CARD_X - _CARD_BEZIER_DIFF, _CARD_X - _CARD_BEZIER_DIFF], y: [_CARD_Y_TOP, _CARD_Y_BOTTOM] },0.2),
                    BetweenAS3.bezier(c, {x: _CARD_X, y: _CARD_Y_TOP}, null, {x: [_CARD_X + _CARD_BEZIER_DIFF, _CARD_X + _CARD_BEZIER_DIFF], y: [_CARD_Y_BOTTOM, _CARD_Y_TOP]},0.2),
                    BetweenAS3.bezier(c, {x: _CARD_X, y: _CARD_Y_BOTTOM}, null, {x: [_CARD_X - _CARD_BEZIER_DIFF, _CARD_X - _CARD_BEZIER_DIFF], y: [_CARD_Y_TOP, _CARD_Y_BOTTOM]},0.3),
                    BetweenAS3.bezier(c, {x: _CARD_X, y: _CARD_Y_TOP}, null, {x: [_CARD_X + _CARD_BEZIER_DIFF, _CARD_X + _CARD_BEZIER_DIFF], y: [_CARD_Y_BOTTOM, _CARD_Y_TOP]},0.3),
                    BetweenAS3.bezier(c, {x: _CARD_X, y: _CARD_Y_BOTTOM}, null, {x: [_CARD_X - _CARD_BEZIER_DIFF, _CARD_X - _CARD_BEZIER_DIFF], y: [_CARD_Y_TOP, _CARD_Y_BOTTOM] },0.4),
                    BetweenAS3.bezier(c, {x: _CARD_X, y: _CARD_Y_TOP}, null, {x: [_CARD_X + _CARD_BEZIER_DIFF, _CARD_X + _CARD_BEZIER_DIFF], y: [_CARD_Y_BOTTOM, _CARD_Y_TOP]},0.4),
                    BetweenAS3.bezier(c, {x: _CARD_X, y: _CARD_Y_BOTTOM}, null, {x: [_CARD_X - _CARD_BEZIER_DIFF, _CARD_X - _CARD_BEZIER_DIFF], y: [_CARD_Y_TOP, _CARD_Y_BOTTOM]},0.5),
                    BetweenAS3.bezier(c, {x: _CARD_X, y: _CARD_Y_TOP}, null, {x: [_CARD_X + _CARD_BEZIER_DIFF, _CARD_X + _CARD_BEZIER_DIFF], y: [_CARD_Y_BOTTOM, _CARD_Y_TOP]},0.5)

                    ),delay, 0.5/Unlight.SPEED);
        }

        // 最後の演出Tweenを作る外れは消える。
        private function createFinishTween(c:BaseScene,hit:Boolean):ITween
        {
            if(hit)
            {
                BetweenAS3.apply(c, {_glowFilter: {color: 0xFFFFFF, strength: 0, blurX: 0, blurY: 0}});
//                BetweenAS3.apply(DisplayObject(c), {_glowFilter: {color: 0xFFFFFF, strength: 0, blurX: 0, blurY: 0}});
                return  BetweenAS3.serial(
                    BetweenAS3.tween(
                        c,
                        {y: _CARD_Y_MIDDLE},
                        null,
                        0.5/Unlight.SPEED,
                        Sine.easeIn
                        ),
                    BetweenAS3.delay(
                        BetweenAS3.serial(
                            BetweenAS3.tween(c, {_glowFilter: {strength: 2, blurX: 30, blurY: 30}}, null, 1, Quad.easeInOut),
                            BetweenAS3.func(getCaptionUpdate),
                            BetweenAS3.tween(c, {_glowFilter: {strength: 0, blurX: 30, blurY: 30}}, null, 1, Quad.easeInOut)
                           ),
                        0.1/Unlight.SPEED,0.55/Unlight.SPEED),
                    BetweenAS3.tween(c,
                                     {alpha: 0.0},
                                     null,
                                     0.5/Unlight.SPEED,
                                     Sine.easeIn
                        ),
                    BetweenAS3.func(finishEvent)
                    );
            }else{
                return BetweenAS3.tween(c,
                {alpha: 0.0},
                    null,
                        0.3/Unlight.SPEED,
                        Sine.easeIn
                    );

            }

        }

        private function finishEvent():void
        {
            ticketNumUpdate();
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_card1.getHideThread());
            pExec.addThread(_card2.getHideThread());
            pExec.addThread(_card3.getHideThread());
            pExec.start();
            drawaAnimeFinish();
            LobbyCtrl.instance.rareCardEventFinish();

            RaidHelpView.instance.isUpdate = true;
        }

        private function drawLotSuccessHandler(e:DrawLotEvent):void
        {
            LogListView.activate(false);
            _silverPreview.showStop();
            _bronzePreview.showStop();
            _goldPreview.showStop();
            log.writeLog(log.LV_WARN, this, "DrawLot succeess ",e);
            _captionArea.text = _TRANS_MSG5;
            _card1 = createCard(e.currentGotLotCardType, e.currentGotLotCardID, e.currentGotLotCardNum);
            _card2 = createCard(e.currentBlankLotCard1Type, e.currentBlankLotCard1ID, e.currentBlankLotCard1Num);
            _card3 = createCard(e.currentBlankLotCard2Type, e.currentBlankLotCard2ID,e.currentBlankLotCard2Num);
            _lastArticleID = e.currentGotLotCardID;
            _lastArticleType = e.currentGotLotCardType;
            _lastArticleNum = e.currentGotLotCardNum;

            initCardPositon();
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_card1.getShowThread(_container,int(Math.random() * 10)+10));
            pExec.addThread(_card2.getShowThread(_container,int(Math.random() * 10)+10));
            pExec.addThread(_card3.getShowThread(_container,int(Math.random() * 10)+10));
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(_tween.play));
            sExec.addThread(new WaitThread(6000, LogListView.activate,[true]));
            sExec.start();

            RaidHelpView.instance.isUpdate = false;
        }

        CONFIG::LOCALE_JP
        private function getCaptionUpdate():void
        {
            var n:String = "";
            if(_lastArticleNum > 1){n=" x "+_lastArticleNum.toString()}

            if(_lastArticleID > 0)
            {
                var itemName:String;
                switch (_lastArticleType)
                {
                case Const.LOT_ARTICLE_ITEM:
                    itemName = AvatarItem.ID(_lastArticleID).name+n;
                break;
                case Const.LOT_ARTICLE_PART:
                    itemName = AvatarPart.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_EVENT:
                    itemName = EventCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_WEAPON:
                    itemName = WeaponCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_CHARA:
                    if (CharaCard.ID(_lastArticleID).kind == Const.CC_KIND_CHARA)
                    {
                        //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                        var rare:String =  (CharaCard.ID(_lastArticleID).rarity > 5)? "のレアカード":"";
                        var level:String =  "Lv."+CharaCard.ID(_lastArticleID).level.toString();
                        itemName = level + CharaCard.ID(_lastArticleID).name + rare;
                    }else if(CharaCard.ID(_lastArticleID).kind == Const.CC_KIND_REBORN_CHARA){
                        //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                        var rare2:String = "の復活キャラカード"
                            var level2:String =  "Lv."+CharaCard.ID(_lastArticleID).level.toString();
                        itemName = level2 + CharaCard.ID(_lastArticleID).name + rare2;
                    }else{
                        itemName = CharaCard.ID(_lastArticleID).name;
                    }
                    break;
                default:
                }
                _captionArea.text = "「"+itemName +"」"+ _TRANS_MSG6;
            }
        }

        CONFIG::LOCALE_EN
        private function getCaptionUpdate():void
        {
            var n:String = "";
            if(_lastArticleNum > 1){n=" x"+_lastArticleNum.toString()}
            if(_lastArticleID > 0)
            {
                var itemName:String;
                switch (_lastArticleType)
                {
                case Const.LOT_ARTICLE_ITEM:
                    itemName = AvatarItem.ID(_lastArticleID).name+n;
                break;
                case Const.LOT_ARTICLE_PART:
                    itemName = AvatarPart.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_EVENT:
                    itemName = EventCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_WEAPON:
                    itemName = WeaponCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_CHARA:
                    if (CharaCard.ID(_lastArticleID).kind == Const.CC_KIND_CHARA)
                    {
                        //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                        var rare:String =  (CharaCard.ID(_lastArticleID).rarity > 5)? "のレアカード":"";
                        var level:String =  "Lv."+CharaCard.ID(_lastArticleID).level.toString();
                        itemName = level + CharaCard.ID(_lastArticleID).name + rare;
                    }else{
                        itemName = CharaCard.ID(_lastArticleID).name;
                    }
                    break;
                default:
                }
                _captionArea.text = _TRANS_MSG6 + "[ "+itemName +" ]";
            }
        }

        CONFIG::LOCALE_TCN
        private function getCaptionUpdate():void
        {
            var n:String = "";
            if(_lastArticleNum > 1){n=" x "+_lastArticleNum.toString()}
            if(_lastArticleID > 0)
            {
                var itemName:String;
                switch (_lastArticleType)
                {
                case Const.LOT_ARTICLE_ITEM:
                    itemName = AvatarItem.ID(_lastArticleID).name+n;
                break;
                case Const.LOT_ARTICLE_PART:
                    itemName = AvatarPart.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_EVENT:
                    itemName = EventCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_WEAPON:
                    itemName = WeaponCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_CHARA:
                    if (CharaCard.ID(_lastArticleID).kind == Const.CC_KIND_CHARA)
                    {
                        var level:String =  "Lv."+CharaCard.ID(_lastArticleID).level.toString();
                        if (CharaCard.ID(_lastArticleID).rarity > 5)
                        {
                            //CONFIG::LOCALE_TCN
                            itemName =  "稀有卡片（" + level + CharaCard.ID(_lastArticleID).name + ")" ;
                        }
                        else
                        {
                            itemName = level + CharaCard.ID(_lastArticleID).name;
                        }
                    }else{
                        itemName = CharaCard.ID(_lastArticleID).name;
                    }
                    break;
                default:
                }
                _captionArea.text = _TRANS_MSG6 + "「"+itemName +"」";
            }
        }

        CONFIG::LOCALE_SCN
        private function getCaptionUpdate():void
        {
            var n:String = "";
            if(_lastArticleNum > 1){n=" x "+_lastArticleNum.toString()}
            if(_lastArticleID > 0)
            {
                var itemName:String;
                switch (_lastArticleType)
                {
                case Const.LOT_ARTICLE_ITEM:
                    itemName = AvatarItem.ID(_lastArticleID).name+n;
                break;
                case Const.LOT_ARTICLE_PART:
                    itemName = AvatarPart.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_EVENT:
                    itemName = EventCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_WEAPON:
                    itemName = WeaponCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_CHARA:
                    if (CharaCard.ID(_lastArticleID).kind == Const.CC_KIND_CHARA)
                    {
                        var level:String =  "Lv."+CharaCard.ID(_lastArticleID).level.toString();
                        if (CharaCard.ID(_lastArticleID).rarity > 5)
                        {
                            //CONFIG::LOCALE_SCN
                            itemName =  "稀有卡（" + level + CharaCard.ID(_lastArticleID).name + ")" ;
                        }
                        else
                        {
                            itemName = level + CharaCard.ID(_lastArticleID).name;
                        }
                    }else{
                        itemName = CharaCard.ID(_lastArticleID).name;
                    }
                    break;
                default:
                }
                _captionArea.text = _TRANS_MSG6 + "「"+itemName +"」";
            }
        }

        CONFIG::LOCALE_KR
        private function getCaptionUpdate():void
        {
            var n:String = "";
            if(_lastArticleNum > 1){n=" x "+_lastArticleNum.toString()}
            if(_lastArticleID > 0)
            {
                var itemName:String;
                switch (_lastArticleType)
                {
                case Const.LOT_ARTICLE_ITEM:
                    itemName = AvatarItem.ID(_lastArticleID).name+n;
                break;
                case Const.LOT_ARTICLE_PART:
                    itemName = AvatarPart.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_EVENT:
                    itemName = EventCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_WEAPON:
                    itemName = WeaponCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_CHARA:
                    if (CharaCard.ID(_lastArticleID).kind == Const.CC_KIND_CHARA)
                    {
                        //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                        var rare:String =  (CharaCard.ID(_lastArticleID).rarity > 5)? "のレアカード":"";
                        var level:String =  "Lv."+CharaCard.ID(_lastArticleID).level.toString();
                        itemName = level + CharaCard.ID(_lastArticleID).name + rare;
                    }else{
                        itemName = CharaCard.ID(_lastArticleID).name;
                    }
                    break;
                default:
                }
                _captionArea.text = "「"+itemName +"」"+ _TRANS_MSG6;
            }
        }

        CONFIG::LOCALE_FR
        private function getCaptionUpdate():void
        {
            var n:String = "";
            if(_lastArticleNum > 1){n=" x"+_lastArticleNum.toString()}
            if(_lastArticleID > 0)
            {
                var itemName:String;
                switch (_lastArticleType)
                {
                case Const.LOT_ARTICLE_ITEM:
                    itemName = AvatarItem.ID(_lastArticleID).name+n;
                break;
                case Const.LOT_ARTICLE_PART:
                    itemName = AvatarPart.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_EVENT:
                    itemName = EventCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_WEAPON:
                    itemName = WeaponCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_CHARA:
                    if (CharaCard.ID(_lastArticleID).kind == Const.CC_KIND_CHARA)
                    {
                        //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                        var rare:String =  (CharaCard.ID(_lastArticleID).rarity > 5)? "のレアカード":"";
                        var level:String =  "Lv."+CharaCard.ID(_lastArticleID).level.toString();
                        itemName = level + CharaCard.ID(_lastArticleID).name + rare;
                    }else{
                        itemName = CharaCard.ID(_lastArticleID).name;
                    }
                    break;
                default:
                }
                _captionArea.text = _TRANS_MSG6 + "[ "+itemName +" ]";
            }
        }

        CONFIG::LOCALE_ID
        private function getCaptionUpdate():void
        {
            var n:String = "";
            if(_lastArticleNum > 1){n=" x"+_lastArticleNum.toString()}
            if(_lastArticleID > 0)
            {
                var itemName:String;
                switch (_lastArticleType)
                {
                case Const.LOT_ARTICLE_ITEM:
                    itemName = AvatarItem.ID(_lastArticleID).name+n;
                break;
                case Const.LOT_ARTICLE_PART:
                    itemName = AvatarPart.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_EVENT:
                    itemName = EventCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_WEAPON:
                    itemName = WeaponCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_CHARA:
                    if (CharaCard.ID(_lastArticleID).kind == Const.CC_KIND_CHARA)
                    {
                        //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                        var rare:String =  (CharaCard.ID(_lastArticleID).rarity > 5)? "のレアカード":"";
                        var level:String =  "Lv."+CharaCard.ID(_lastArticleID).level.toString();
                        itemName = level + CharaCard.ID(_lastArticleID).name + rare;
                    }else{
                        itemName = CharaCard.ID(_lastArticleID).name;
                    }
                    break;
                default:
                }
                _captionArea.text = _TRANS_MSG6 + "[ "+itemName +" ]";
            }
        }

        CONFIG::LOCALE_TH
        private function getCaptionUpdate():void
        {
            var n:String = "";
            if(_lastArticleNum > 1){n=" x"+_lastArticleNum.toString()}
            if(_lastArticleID > 0)
            {
                var itemName:String;
                switch (_lastArticleType)
                {
                case Const.LOT_ARTICLE_ITEM:
                    itemName = AvatarItem.ID(_lastArticleID).name+n;
                break;
                case Const.LOT_ARTICLE_PART:
                    itemName = AvatarPart.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_EVENT:
                    itemName = EventCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_WEAPON:
                    itemName = WeaponCard.ID(_lastArticleID).name;
                break;
                case Const.LOT_ARTICLE_CHARA:
                    if (CharaCard.ID(_lastArticleID).kind == Const.CC_KIND_CHARA)
                    {
                        //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                        var rare:String =  (CharaCard.ID(_lastArticleID).rarity > 5)? "แรร์การ์ด":"";
                        var level:String =  "Lv."+CharaCard.ID(_lastArticleID).level.toString();
                        itemName = rare + CharaCard.ID(_lastArticleID).name + level;
                    }else{
                        itemName = CharaCard.ID(_lastArticleID).name;
                    }
                    break;
                default:
                }
                _captionArea.text = _TRANS_MSG6 + "[ "+itemName +" ]";
            }
        }


        private function drawaAnimeFinish():void
        {
            _lastArticleID = 0;
            _lastArticleType = 0;
            _lastArticleNum = 1;
        }


        private function hide():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_container, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

            pExec.start();
            pExec.join();

            next(hide2);
        }

        // 配置オブジェの表示
        private function hide2():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_avatarView.getHideThread());

            pExec.start();
            pExec.join();

            next(exit);
        }


        private function exit():void
        {
            // イベントの消去
            LobbyCtrl.instance.stopBGM();
            log.writeLog(log.LV_INFO, this, "edit exit");
        }

        // 終了関数
        override protected function finalize():void
        {
            _stage.removeChild(_title);
            _stage.removeChild(_titleJ);
            _stage.removeChild(_container);
            RemoveChild.all(_container);
            _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);
            LobbyCtrl.instance.removeEventListener(DrawLotEvent.SUCCESS, drawLotSuccessHandler);
            LobbyCtrl.instance.removeEventListener(AvatarItemEvent.GET_ITEM, getTicketHander);
            LobbyCtrl.instance.removeEventListener(LobbyCtrl.RARE_CARD_GET_EVENT_FINISH,finishHandler);
            Player.instance.avatar.removeEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);
            // レイドヘルプイベント
            GlobalChatCtrl.instance.removeEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            log.writeLog (log.LV_WARN,this,"option end");
            _bg.final();
            _bg = null;
//            _exitButton = null;
//            LobbyCtrl.instance.alertEnable(true);

        }
        // ボタンマウスオーバ時
        private function mouseOverBronzeEvent():void
        {
            _bronzePreview.showStart();
            _captionArea.text = _TRANS_MSG2;
        }
        // ボタンマウスオーバ時
        private function mouseOverSilverEvent():void
        {
            _silverPreview.showStart();
            _captionArea.text = _TRANS_MSG3;
        }
        // ボタンマウスオーバ時
        private function mouseOverGoldEvent():void
        {
            _goldPreview.showStart();
            _captionArea.text = _TRANS_MSG4;
        }

        private function mouseOutEvent():void
        {
            _captionArea.text = _TRANS_MSG1;
            _silverPreview.showStop();
            _bronzePreview.showStop();
            _goldPreview.showStop();
        }

        private function mouseDownEvent():void
        {
            LobbyCtrl.instance.addEventListener(LobbyCtrl.RARE_CARD_GET_EVENT_FINISH,finishHandler);
            _avatarView.exitButton.visible = false;
            _captionArea.text = "";
        }

        private function finishHandler(e:Event):void
        {
            LobbyCtrl.instance.removeEventListener(LobbyCtrl.RARE_CARD_GET_EVENT_FINISH,finishHandler);
            _avatarView.exitButton.visible = true;

        }
   }

}
