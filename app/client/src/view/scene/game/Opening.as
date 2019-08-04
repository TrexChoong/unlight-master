package view.scene.game
{
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import model.Player;
    import model.Avatar;
    import model.Match;
    import model.MatchRoom;
    import model.Duel;
    import model.Entrant;
    import model.OtherAvatar;
    import view.scene.BaseScene;
    import view.scene.common.AvatarClip;
    import view.scene.common.CharaCardClip;
    import view.image.game.*;
    import view.SleepThread;
    import view.ClousureThread;

    /**
     * Opening
     * Openingに必要なものををまとめて管理する
     *
     */

    public class Opening extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_EVA		:String = "エヴァリスト";
        CONFIG::LOCALE_JP
        private static const _TRANS_IZAC	:String = "アイザック";
        CONFIG::LOCALE_JP
        private static const _TRANS_GRU		:String = "グリュンワルド";
        CONFIG::LOCALE_JP
        private static const _TRANS_ABEL	:String = "アベル";
        CONFIG::LOCALE_JP
        private static const _TRANS_LEON	:String = "レオン";
        CONFIG::LOCALE_JP
        private static const _TRANS_CRE		:String = "クレーニヒ";
        CONFIG::LOCALE_JP
        private static const _TRANS_JEAD	:String = "ジェッド";
        CONFIG::LOCALE_JP
        private static const _TRANS_ARCH	:String = "アーチボルト";

        CONFIG::LOCALE_EN
        private static const _TRANS_EVA		:String = "Evarist";
        CONFIG::LOCALE_EN
        private static const _TRANS_IZAC	:String = "Izac";
        CONFIG::LOCALE_EN
        private static const _TRANS_GRU		:String = "Grunwald";
        CONFIG::LOCALE_EN
        private static const _TRANS_ABEL	:String = "Abel";
        CONFIG::LOCALE_EN
        private static const _TRANS_LEON	:String = "Leon";
        CONFIG::LOCALE_EN
        private static const _TRANS_CRE		:String = "Kronig";
        CONFIG::LOCALE_EN
        private static const _TRANS_JEAD	:String = "Jead";
        CONFIG::LOCALE_EN
        private static const _TRANS_ARCH	:String = "Archibald";

        CONFIG::LOCALE_TCN
        private static const _TRANS_EVA		:String = "艾伯李斯特";
        CONFIG::LOCALE_TCN
        private static const _TRANS_IZAC	:String = "艾依查庫";
        CONFIG::LOCALE_TCN
        private static const _TRANS_GRU		:String = "古魯瓦魯多";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ABEL	:String = "阿貝爾";
        CONFIG::LOCALE_TCN
        private static const _TRANS_LEON	:String = "利恩";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CRE		:String = "庫勒尼西";
        CONFIG::LOCALE_TCN
        private static const _TRANS_JEAD	:String = "傑多";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ARCH	:String = "阿奇布魯多";

        CONFIG::LOCALE_SCN
        private static const _TRANS_EVA		:String = "艾伯李斯特";
        CONFIG::LOCALE_SCN
        private static const _TRANS_IZAC	:String = "艾依查库";
        CONFIG::LOCALE_SCN
        private static const _TRANS_GRU		:String = "古鲁瓦尔多";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ABEL	:String = "阿贝尔";
        CONFIG::LOCALE_SCN
        private static const _TRANS_LEON	:String = "利恩";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CRE		:String = "库勒尼西";
        CONFIG::LOCALE_SCN
        private static const _TRANS_JEAD	:String = "杰多";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ARCH	:String = "阿奇波尔多";

        CONFIG::LOCALE_KR
        private static const _TRANS_EVA		:String = "에바리스트";
        CONFIG::LOCALE_KR
        private static const _TRANS_IZAC	:String = "아이자크";
        CONFIG::LOCALE_KR
        private static const _TRANS_GRU		:String = "그룬왈드";
        CONFIG::LOCALE_KR
        private static const _TRANS_ABEL	:String = "아벨";
        CONFIG::LOCALE_KR
        private static const _TRANS_LEON	:String = "레온";
        CONFIG::LOCALE_KR
        private static const _TRANS_CRE		:String = "크레니히";
        CONFIG::LOCALE_KR
        private static const _TRANS_JEAD	:String = "제드";
        CONFIG::LOCALE_KR
        private static const _TRANS_ARCH	:String = "아치볼드";

        CONFIG::LOCALE_FR
        private static const _TRANS_EVA		:String = "Evarist";
        CONFIG::LOCALE_FR
        private static const _TRANS_IZAC	:String = "Izac";
        CONFIG::LOCALE_FR
        private static const _TRANS_GRU		:String = "Grunwald";
        CONFIG::LOCALE_FR
        private static const _TRANS_ABEL	:String = "Abel";
        CONFIG::LOCALE_FR
        private static const _TRANS_LEON	:String = "Leon";
        CONFIG::LOCALE_FR
        private static const _TRANS_CRE		:String = "Kronig";
        CONFIG::LOCALE_FR
        private static const _TRANS_JEAD	:String = "Jaed";
        CONFIG::LOCALE_FR
        private static const _TRANS_ARCH	:String = "Archibald";

        CONFIG::LOCALE_ID
        private static const _TRANS_EVA		:String = "エヴァリスト";
        CONFIG::LOCALE_ID
        private static const _TRANS_IZAC	:String = "アイザック";
        CONFIG::LOCALE_ID
        private static const _TRANS_GRU		:String = "グリュンワルド";
        CONFIG::LOCALE_ID
        private static const _TRANS_ABEL	:String = "アベル";
        CONFIG::LOCALE_ID
        private static const _TRANS_LEON	:String = "レオン";
        CONFIG::LOCALE_ID
        private static const _TRANS_CRE		:String = "クレーニヒ";
        CONFIG::LOCALE_ID
        private static const _TRANS_JEAD	:String = "ジェッド";
        CONFIG::LOCALE_ID
        private static const _TRANS_ARCH	:String = "アーチボルト";

        CONFIG::LOCALE_TH
        private static const _TRANS_EVA     :String = "เอวาริสท์"; // エヴァリスト
        CONFIG::LOCALE_TH
        private static const _TRANS_IZAC    :String = "ไอแซค"; // アイザック
        CONFIG::LOCALE_TH
        private static const _TRANS_GRU     :String = "กรุนวัลด์"; // グリュンワルド
        CONFIG::LOCALE_TH
        private static const _TRANS_ABEL    :String = "อาเบล"; // アベル
        CONFIG::LOCALE_TH
        private static const _TRANS_LEON    :String = "เลออน"; // レオン
        CONFIG::LOCALE_TH
        private static const _TRANS_CRE     :String = "โครนิก"; // クレーニヒ
        CONFIG::LOCALE_TH
        private static const _TRANS_JEAD    :String = "เจด"; // ジェッド
        CONFIG::LOCALE_TH
        private static const _TRANS_ARCH    :String = "อาร์ชิบัลท์"; // アーチボルト


        private static const _PLAYER_X:int = 0;
        private static const _PLAYER_Y:int = 0;
        private static const _FOE_X:int = 0;
        private static const _FOE_Y:int = 0;

        private static const _NAME_SWF_URL:Array = [
            "op_cc01.swf",
            "op_cc02.swf",
            "op_cc03.swf",
            "op_cc04.swf",
            "op_cc05.swf",
            "op_cc06.swf",
            "op_cc07.swf",
            "op_cc10.swf",
            ];
        private static const _NAMES:Array = [
//                "エヴァリスト",
//                "アイザック",
//                "グリュンワルド",
//                "アベル",
//                "レオン",
//                "クレーニヒ",
//                "ジェッド",
//                "アーチボルト",
                _TRANS_EVA,
                _TRANS_IZAC,
                _TRANS_GRU,
                _TRANS_ABEL,
                _TRANS_LEON,
                _TRANS_CRE,
                _TRANS_JEAD,
                _TRANS_ARCH,
            ]

        private static const URL:String = "/public/image/";
        private static const RESULT_SUFIX:RegExp = /_res\d/;

        private var _avatar:Avatar = Player.instance.avatar;

        private var _plChara:StandCharaImage;
        private var _foeChara:StandCharaImage;
//         private var _plName:OpeningCharaName;
//         private var _foeName:OpeningCharaName;

        private var _plName:Array = [];
        private var _foeName:Array = [];
        private var _plSubName:Array = [];
        private var _foeSubName:Array = [];

        private var _opUp:OpeningUp;
//        private var _opPop:OpeningPop;
        private var _opDown:OpeningDown;
        private var _opName:OpeningName;
        private var _opPlace:OpeningPlace;

        private var _duel:Duel = Duel.instance;
        private var _match:Match = Match.instance;

        protected var _entrant:Entrant;

        private var _rule:int;                               // デュエルのルール(1on1,3on3)

        private var _isFoeAvatar:Boolean = true;
        private var _avatarClips:Array = [];
        private var _avatarIds:Array = [];
        private static const _OWNER_CLIP_IDX:int  = 0;
        private static const _FOE_CLIP_IDX:int = 1;


        // 位置定数
        private static const _NAME_X:int = 104;               //
        private static const _FOE_NAME_X:int = 432;          //
        private static const _NAME_Y:int = 598;              //
        private static const _NAME_WIDTH:int = 220;          //
        private static const _NAME_HEIGHT:int = 28;          //
        private static const _NAME_OFFSET_X:int = 12;        //
        private static const _NAME_OFFSET_Y:int = 24;        //

        private static const _AVATAR_CLIPS_X:Array = [-180,780];
        private static const _AVATAR_CLIPS_RE_X:Array = [200,560];
        private static const _AVATAR_CLIPS_Y:int = 230;
        private static const _AVATAR_CLIPS_SCALE_X:Array = [-1.0,1.0];

        // デュエルのルール定数
        private static const _RULE_1VS1:int = 0;             //
        private static const _RULE_3VS3:int = 1;             //

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();
        private var _nameContainer:UIComponent = new UIComponent();
        private var _avatarClipContainer:UIComponent = new UIComponent();


        /**
         * コンストラクタ
         *
         */
        public function Opening(isFoe:Boolean=true)
        {
            _isFoeAvatar = isFoe;
        }

        public override function init():void
        {
            _plName = [];
            _foeName = [];
            _plSubName = [];
            _foeSubName = [];

            initializeCharaCardName();

            addChild(_container);
            addChild(_avatarClipContainer);
            addChild(_nameContainer);

            _nameContainer.y = 0;
            _nameContainer.alpha = 0.0;
        }

        public override function final():void
        {
            finalizeCharaCardName();
            removeChild(_nameContainer);
            removeChild(_container);

            _plName = [];
            _foeName = [];
            _plSubName = [];
            _foeSubName = [];

            _plChara = null;
            _foeChara = null;
        }

        public function getInitializeThread():Thread
        {
            // 部屋の人数を見てルール設定
//            _duel.playerCharaCards.length == 1 ? _rule = _RULE_1VS1 : _rule = _RULE_3VS3
            (_duel.playerCharaCards.length == 1&&_duel.foeCharaCards.length == 1) ? _rule = _RULE_1VS1 : _rule = _RULE_3VS3;

            var _foeImage:String = "";
            // クエストの敵は最後のキャラを表示する
            log.writeLog(log.LV_DEBUG,this,"Player.instance.state : ", Player.instance.state);
            if (Player.instance.state == Player.STATE_QUEST)
            {
                _foeImage = _duel.foeLastCharaCard.standImage;
            }
            else
            {
                _foeImage = _duel.foeCharaCard.standImage;
            }
            _plChara = new StandCharaImage( true, _duel.playerCharaCard.standImage);
            _foeChara = new StandCharaImage( false, _foeImage.replace(RESULT_SUFIX, ""));

//             var nameIndex:int =  _NAMES.indexOf(_duel.playerCharaCard.name);
//             if (nameIndex == -1){nameIndex = 0}
//             _plName = new OpeningCharaName( true, URL + _NAME_SWF_URL[nameIndex]);
//             nameIndex =  _NAMES.indexOf(_duel.foeCharaCard.name);
//             if (nameIndex == -1){nameIndex = 0}
//             _foeName = new OpeningCharaName( false, URL +_NAME_SWF_URL[nameIndex]);

//            _opPlace = new OpeningPlace(MatchRoom.list[_match.currentRoomId].stage);
            _opPlace = new OpeningPlace(0);

            _opUp = new OpeningUp();
            _opDown = new OpeningDown();
            _opDown.enemyVisible = _isFoeAvatar;
//            _opPop = new OpeningPop();
            _opName = new OpeningName(_rule);

//             _plChara.updateDistance(1);
//             _foeChara.updateDistance(1);
            _plChara.upImage();
            _foeChara.upImage();

            _plChara.x = _PLAYER_X - 500;
            _plChara.y = _PLAYER_Y;
            _plChara.visible = false;

            _foeChara.x = _FOE_X + 500;
            _foeChara.y = _FOE_Y;
            _foeChara.visible = false;

//             // キャラカードの名前を作成
//             finalizeCharaCardName();

            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(_opUp.getShowThread(_container,6));
//            pExec.addThread(_opPop.getShowThread(_container,10));
            pExec.addThread(_plChara.getShowThread(_container,2));
            pExec.addThread(_foeChara.getShowThread(_container,3));
//            pExec.addThread(_opPlace.getShowThread(_container,4));
            pExec.addThread(_opDown.getShowThread(_container,5));
            pExec.addThread(initializeAvatarClip());
            pExec.addThread(_opName.getShowThread(_nameContainer,7));
//            pExec.addThread(new ClousureThread(function():void{myStage.addChild(_container)}));
//             pExec.addThread(_plName.getShowThread(this,7));
//             pExec.addThread(_foeName.getShowThread(this,8));

            return pExec;
        }

        public function getFinalizeThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            _avatarIds = [];
            // 表示されているアバターをすべて消す
            for(var i:int = 0; i < _avatarClipContainer.numChildren; i++){
                pExec.addThread(AvatarClip(_avatarClipContainer.getChildAt(i)).getHideThread());
            }
            pExec.addThread(_plChara.getHideThread());
            pExec.addThread(_foeChara.getHideThread());
            pExec.addThread(_opDown.getHideThread());
            pExec.addThread(_opPlace.getHideThread());
            pExec.addThread(_opUp.getHideThread());
//            pExec.addThread(_opPop.getHideThread());
            pExec.addThread(_opName.getHideThread());

//             pExec.addThread(_plName.getHideThread());
//             pExec.addThread(_foeName.getHideThread());

            return pExec;
        }

        // キャラカードとキャラカードの名前をルールに応じて作成する
        private function initializeCharaCardName():void
        {
            _duel.playerCharaCards.forEach(
                function(item:*, index:int, array:Array):void
                {
                    var label:Label = new Label();
                    var label2:Label = new Label();
                    label.x = label2.x = _rule == _RULE_1VS1 ? _NAME_X + _NAME_OFFSET_X : _NAME_X + index * _NAME_OFFSET_X;
                    label.y = label2.y = _rule == _RULE_1VS1 ? _NAME_Y + _NAME_OFFSET_Y : _NAME_Y + index * _NAME_OFFSET_Y;
                    label.width = label2.width = _NAME_WIDTH;
                    label.height = label2.height = _NAME_HEIGHT;
                    label.text = _rule == _RULE_1VS1 && index > 0 ? "" : item.name == "" ? "Unknown" : item.name;
                    if(item.abName.indexOf("-") == -1)
                    {
                        label2.text = _rule == _RULE_1VS1 && index > 0 ? "" : item.abName.slice(item.abName.indexOf("-")+1);
                    }
                    else
                    {
                        label2.text = _rule == _RULE_1VS1 && index > 0 ? "" : item.abName.slice(item.abName.indexOf("-")+1,item.abName.lastIndexOf("-"));
                    }
                    label.styleName = "GameOpeningNameLabel";
                    label2.styleName = "GameOpeningSubNameLabel";
                    label.filters = label2.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1),
                                                      new DropShadowFilter(10, 270, 0x000000, 0.3, 8, 8, 1, 1, true)];
                    _plName.push(label);
                    _plSubName.push(label2);
                    _nameContainer.addChild(_plName[index]);
                    _nameContainer.addChild(_plSubName[index]);
                });

            _duel.foeCharaCards.forEach(
                function(item:*, index:int, array:Array):void
                {
                    var label:Label = new Label();
                    var label2:Label = new Label();
                    label.x = label2.x = _rule == _RULE_1VS1 ? _FOE_NAME_X - _NAME_OFFSET_X : _FOE_NAME_X - index * _NAME_OFFSET_X;
                    label.y = label2.y = _rule == _RULE_1VS1 ? _NAME_Y + _NAME_OFFSET_Y : _NAME_Y + index * _NAME_OFFSET_Y;
                    label.width = label2.width = _NAME_WIDTH;
                    label.height = label2.height = _NAME_HEIGHT;
                    label.text = _rule == _RULE_1VS1 && index > 0 ? "" : item.name == "" ? "Unknown" : item.name;

                    if(item.abName.indexOf("-") == -1)
                    {
                        label2.text = _rule == _RULE_1VS1 && index > 0 ? "" : item.abName.slice(item.abName.indexOf("-")+1);
                    }
                    else
                    {
                        label2.text = _rule == _RULE_1VS1 && index > 0 ? "" : item.abName.slice(item.abName.indexOf("-")+1,item.abName.lastIndexOf("-"));
                    }
                    label.styleName = "GameOpeningNameLabel";
                    label2.styleName = "GameOpeningSubNameLabel";
                    label.filters = label2.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1),
                                                      new DropShadowFilter(10, 270, 0x000000, 0.3, 8, 8, 1, 1, true)];
                    _foeName.push(label);
                    _foeSubName.push(label2);
                    _nameContainer.addChild(_foeName[index]);
                    _nameContainer.addChild(_foeSubName[index]);
                });

//             // AIでやると余分なカードまで取得して表示が狂う
//             // 処理的にはこっちのほうがいい
//             _duel.foeCharaCards.forEach(
//                 function(item:*, index:int, array:Array):void
//                 {
//                     var label:Label = new Label();
//                     var label2:Label = new Label();
//                     label.x = label2.x = _FOE_NAME_X;
//                     label.y = label2.y = _rule == _RULE_1VS1 ? _NAME_Y + _NAME_OFFSET_Y : _NAME_Y + index * _NAME_OFFSET_Y;
//                     label.width = label2.width = _NAME_WIDTH;
//                     label.height = label2.height = _NAME_HEIGHT;
//                     label.text = item.name == "" ? "Unknown" : item.name;
//                     label2.text = item.abName.slice(item.abName.indexOf("-")+1,item.abName.lastIndexOf("-"));
//                     label.styleName = "GameOpeningNameLabel";
//                     label2.styleName = "GameOpeningSubNameLabel";
//                     label.filters = label2.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1),
//                                                       new DropShadowFilter(10, 270, 0x000000, 0.3, 8, 8, 1, 1, true)];
//                     _container.addChild(label);
//                     _container.addChild(label2);
//                     _foeName.push(label);
//                 });
        }

        // アバタークリップを作製
        public function initializeAvatarClip():Thread
        {
            var ids:Array = new Array();
            if (_avatarIds[_FOE_CLIP_IDX] == _avatar.id || _duel.isWatch) {
                if (_avatarIds[_FOE_CLIP_IDX]) ids.push(_avatarIds[_FOE_CLIP_IDX]);
                ids.push(_avatarIds[_OWNER_CLIP_IDX]);
            } else {
                ids.push(_avatarIds[_OWNER_CLIP_IDX]);
                if (_avatarIds[_FOE_CLIP_IDX]) ids.push(_avatarIds[_FOE_CLIP_IDX]);
            }

            var pExec:ParallelExecutor = new ParallelExecutor();
            for (var i:int = 0; i < ids.length; i++) {
                if (_avatarIds[i] > 0) {
                    _avatarClips[i] = new AvatarClip(OtherAvatar.ID(ids[i]));
                    _avatarClips[i].x = _AVATAR_CLIPS_X[i];
                    _avatarClips[i].y = _AVATAR_CLIPS_Y;
                    _avatarClips[i].scaleX = _AVATAR_CLIPS_SCALE_X[i];
                    _avatarClips[i].filters = [new GlowFilter(0x000000, 1, 1, 1, 1, 3, false, false)];
                    _avatarClips[i].type = Const.PL_AVATAR_LOBBY;

                    pExec.addThread(_avatarClips[i].getShowThread(_avatarClipContainer, -1));
                }
            }
            return pExec;
        }

        // キャラカードとキャラカードの名前をルールに応じて作成する
        private function finalizeCharaCardName():void
        {
            _plName.forEach(function(item:*, index:int, array:Array):void{_nameContainer.removeChild(item)});
            _plSubName.forEach(function(item:*, index:int, array:Array):void{_nameContainer.removeChild(item)});
            _foeName.forEach(function(item:*, index:int, array:Array):void{_nameContainer.removeChild(item)});
            _foeSubName.forEach(function(item:*, index:int, array:Array):void{_nameContainer.removeChild(item)});
        }

        public function getBringOnThread(nameBringOn:Thread=null,cardBringOn:Thread=null,opPop:Thread=null):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            var pExec3:ParallelExecutor = new ParallelExecutor();
            var pExec4:ParallelExecutor = new ParallelExecutor();
            var pExec5:ParallelExecutor = new ParallelExecutor();
            var pExec6:ParallelExecutor = new ParallelExecutor();
            var pExec7:ParallelExecutor = new ParallelExecutor();
            var pExec8:ParallelExecutor = new ParallelExecutor();
            var pExec9:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(_opPlace.getAnimeThread());
            pExec.addThread(new SleepThread(1000));
            sExec.addThread(pExec);

            pExec2.addThread(_opDown.getAnimeThread());
            pExec2.addThread(_opUp.getAnimeThread());
            if (nameBringOn) {pExec2.addThread(nameBringOn);}
            sExec.addThread(pExec2);

            pExec3.addThread(getAvatarClipBringOnThread());
            sExec.addThread(pExec3);

            pExec4.addThread(_opName.getAnimeThread());
            sExec.addThread(pExec4);

            if (cardBringOn) {pExec5.addThread(cardBringOn);}
            pExec5.addThread(new BeTweenAS3Thread(_nameContainer, {alpha:1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.5 ,true ));
            sExec.addThread(pExec5);

            pExec6.addThread(new SleepThread(1000));
            sExec.addThread(pExec6);

            pExec7.addThread(new BeTweenAS3Thread(_plChara, {x:_PLAYER_X}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            pExec7.addThread(new BeTweenAS3Thread(_foeChara, {x:_FOE_X}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            sExec.addThread(pExec7);

            if (opPop)
            {
                pExec8.addThread(opPop);
                sExec.addThread(pExec8);
            }

            pExec9.addThread(new SleepThread(2000));
            //pExec9.addThread(new SleepThread(20000*60*60*24));
            sExec.addThread(pExec9);

            return sExec;
        }

        private function getAvatarClipBringOnThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            for (var i:int = 0; i<_avatarClips.length; i++) {
                pExec.addThread(new BeTweenAS3Thread(_avatarClips[i], {x:_AVATAR_CLIPS_RE_X[i]}, null, 0.9, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            }
            return pExec;
        }
        private function getAvatarClipBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            for (var i:int = 0; i<_avatarClips.length; i++) {
                pExec.addThread(new BeTweenAS3Thread(_avatarClips[i], {x:_AVATAR_CLIPS_X[i]}, null, 0.9, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            }
            return pExec;
        }

        public function getBringOffThread(opPop:Thread=null):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_plChara, {x:_PLAYER_X-500 ,alpha:0.5}, null, 0.9, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            pExec.addThread(new BeTweenAS3Thread(_foeChara, {x:_FOE_X+500 ,alpha:0.5}, null, 0.9, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            //pExec.addThread(new BeTweenAS3Thread(_opUp, {y:-150 ,alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            pExec.addThread(new BeTweenAS3Thread(_opDown, {y:150 ,alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            if (opPop)
            {
                pExec.addThread(opPop);
            }
            pExec.addThread(new BeTweenAS3Thread(_nameContainer, {y:150, alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            pExec.addThread(new BeTweenAS3Thread(_opName, {y:150 ,alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            pExec.addThread(getAvatarClipBringOffThread());

            sExec.addThread(pExec);

            return sExec;
        }

        public function getUpBarBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_opUp, {y:-150 ,alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
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
            return new HideThread(this);
        }

        public function set avatarIds(ids:Array):void
        {
            _avatarIds = ids;
        }

    }

}

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import org.libspark.thread.Thread;

import model.Duel;
import view.scene.game.Opening;
import view.BaseShowThread;
import view.BaseHideThread;

class ShowThread extends BaseShowThread
{
    private var _op:Opening;
    private var _at:int;

    public function ShowThread(op:Opening, stage:DisplayObjectContainer, at:int)
    {
        _op = op;
        _at = at;
        super(op, stage)
    }

    protected override function run():void
    {
        // デュエルの準備を待つ
        if (Duel.instance.inited == false)
        {
            Duel.instance.wait();
        }
        next(init);
    }

    private function init():void
    {
        var thread:Thread;
        thread = _op.getInitializeThread();
        thread.start();
        thread.join();
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    private var _op:Opening;

    public function HideThread(op:Opening)
    {
        _op = op;
        super(op);
    }

    protected override function run():void
    {
        var thread:Thread;
        thread = _op.getFinalizeThread();
        thread.start();
        thread.join();
        next(exit);
    }
}
