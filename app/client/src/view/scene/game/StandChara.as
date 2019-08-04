package view.scene.game
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.PixelSnapping;
    import flash.display.MovieClip;
    import flash.utils.*;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.filters.GlowFilter;

    import mx.core.UIComponent;
    import mx.containers.Box;
    import mx.controls.Label;
    import mx.controls.Image;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.CharaCard;
    import model.Duel;
    import model.Entrant;
    import model.events.*;

    import view.*;
    import view.utils.*;
    import view.image.game.*;
    import view.scene.BaseScene;
    import controller.*;



    /**
     * StandChara表示クラス
     *
     */


    public class StandChara  extends BaseScene
    {

        private var _plChara:StandCharaImage;
        private var _foeChara:StandCharaImage;
//         private var _plFilter:GlowFilter;
//         private var _foeFilter:GlowFilter;


        private static const URL:String = "/public/image/standchara/";
        private static const CAT_STANDIMAGE:String = "standchara01cat";
        private static const RESULT_SUFIX:RegExp = /_res\d/;
        private var _duel:Duel = Duel.instance;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                [""],
                [""],   // 0
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int = 0;
//        private var _effect:StateEffect = new StateEffect();
        private var _plDupeCharaArray:Array = [];
        private var _foeDupeCharaArray:Array = [];
        private var _plStandCharaArray:Array = [];
        private var _foeStandCharaArray:Array = [];
        private var _animeThread:Thread = null; // 稼働中のアニメスレッド

        /**
         * コンストラクタ
         *
         */
        public function StandChara()
        {
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return  new ShowThread(this, stage);
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


        public override function init():void
        {

            _foeChara = new StandCharaImage( false, _duel.foeCharaCard.standImage);
            _plChara = new StandCharaImage( true,  _duel.playerCharaCard.standImage);
//             _foeFilter = new GlowFilter();
//             _plFilter = new GlowFilter();

//             Unlight.GCW.watch(_plChara,getQualifiedClassName(this));
//             Unlight.GCW.watch(_foeChara,getQualifiedClassName(this));

            _foeChara.x = 500;
            _plChara.x = -500;

            _foeChara.visible = false;
            _plChara.visible = false;

            addChild(_foeChara);
            addChild(_plChara);

            // イベントを追加
            _duel.plEntrant.addEventListener(DamageEvent.DAMAGE, playerDamageHandler);
            _duel.foeEntrant.addEventListener(DamageEvent.DAMAGE, foeDamageHandler);
            _duel.plEntrant.addEventListener(DamageEvent.HEAL, playerHealHandler);
            _duel.foeEntrant.addEventListener(DamageEvent.HEAL, foeHealHandler);
            _duel.addEventListener(Duel.DISTANCE_UPDATE, distanceUpdateHandler);
            _duel.addEventListener(Duel.BATTLE_CARD_DROP_ATTACK_PHASE_START, setAttackHandler);
            _duel.addEventListener(Duel.BATTLE_CARD_DROP_DEFFENCE_PHASE_START, setDeffenceHandler);
            _duel.addEventListener(Duel.BATTLE_CARD_DROP_WAITING_PHASE_START, setWaitingHandler);
            _duel.addEventListener(Duel.MOVE_CARD_DROP_PHASE_START, setMoveHandler);
            _duel.addEventListener(Duel.MOVE_CARD_DROP_PHASE_FINISH, finishPhaseHandler);
            _duel.addEventListener(Duel.BATTLE_CARD_DROP_PHASE_FINISH, finishPhaseHandler);
            _duel.addEventListener(CharaTransformEvent.PLAYER, playerTransformHandler);
            _duel.addEventListener(CharaTransformEvent.FOE, foeTransformHandler);
            _duel.addEventListener(CharaLostInTheFogEvent.PLAYER, playerLostInTheFogHandler);
            _duel.addEventListener(CharaLostInTheFogEvent.FOE, foeLostInTheFogHandler);
            _duel.addEventListener(InTheFogEvent.PLAYER, playerInTheFogHandler);
            _duel.addEventListener(HideMoveEvent.HIDE_MOVE, playerHideMoveHandler);
            _duel.addEventListener(StuffedToysSetEvent.PLAYER_SET, playerStuffedToysSetHandler);
            _duel.addEventListener(StuffedToysSetEvent.FOE_SET, foeStuffedToysSetHandler);
            _duel.plEntrant.addEventListener(TrapActionEvent.ACTION, playerTrapActionHandler);
            _duel.foeEntrant.addEventListener(TrapActionEvent.ACTION, foeTrapActionHandler);
            _duel.plEntrant.addEventListener(TrapActionEvent.UPDATE, playerTrapUpdateHandler);
            _duel.foeEntrant.addEventListener(TrapActionEvent.UPDATE, foeTrapUpdateHandler);


            // 顔アップ出す
            _duel.addEventListener(RollResultEvent.PLAYER_ATTACK, battlePlayerResultHandler, false,10);
            _duel.addEventListener(RollResultEvent.FOE_ATTACK, battleFoeResultHandler, false,10);


            _duel.addEventListener(Duel.CHARA_CHANGE_PHASE_START, changeStartHandler);
            _duel.addEventListener(Duel.DEAD_CHARA_CHANGE_PHASE_START, changeStartHandler);

            _duel.plEntrant.addEventListener(Entrant.CHANGE_DONE, plCharaCardChangeHandler);
            _duel.foeEntrant.addEventListener(Entrant.CHANGE_DONE, foeCharaCardChangeHandler);

            // _duel.addEventListener(ChangeCharaCardEvent.PLAYER, plCharaCardChangeHandler);
            // _duel.addEventListener(ChangeCharaCardEvent.FOE, foeCharaCardChangeHandler);

            deadCountReset();
            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);
        }

        public override function final():void
        {
            log.writeLog(log.LV_INFO, this, "finalize stand chara");
            _plChara.getHideThread().start();
            _foeChara.getHideThread().start();
            RemoveChild.apply(_foeChara);
            RemoveChild.apply(_plChara);
            _foeChara = null;
            _plChara = null;
//             _foeFilter = null;
//             _plFilter = null;

            if (_plStandCharaArray && _plStandCharaArray.length > 0)
            {
                for each (var sc:StandCharaImage in _plStandCharaArray) {
                        RemoveChild.apply(sc);
                    };
                _plStandCharaArray = null;
            }

            if (_foeStandCharaArray && _foeStandCharaArray.length > 0)
            {
                for each (sc in _foeStandCharaArray) {
                        RemoveChild.apply(sc);
                    };
                _foeStandCharaArray = null;
            }

            // イベントを追加
            _duel.plEntrant.removeEventListener(DamageEvent.DAMAGE, playerDamageHandler);
            _duel.foeEntrant.removeEventListener(DamageEvent.DAMAGE, foeDamageHandler);
            _duel.plEntrant.removeEventListener(DamageEvent.HEAL, playerHealHandler);
            _duel.foeEntrant.removeEventListener(DamageEvent.HEAL, foeHealHandler);
            _duel.removeEventListener(Duel.DISTANCE_UPDATE, distanceUpdateHandler);
            _duel.removeEventListener(Duel.BATTLE_CARD_DROP_ATTACK_PHASE_START, setAttackHandler);
            _duel.removeEventListener(Duel.BATTLE_CARD_DROP_DEFFENCE_PHASE_START, setDeffenceHandler);
            _duel.removeEventListener(Duel.BATTLE_CARD_DROP_WAITING_PHASE_START, setWaitingHandler);
            _duel.removeEventListener(Duel.MOVE_CARD_DROP_PHASE_START, setMoveHandler);
            _duel.removeEventListener(Duel.MOVE_CARD_DROP_PHASE_FINISH, finishPhaseHandler);
            _duel.removeEventListener(Duel.BATTLE_CARD_DROP_PHASE_FINISH, finishPhaseHandler);
            _duel.removeEventListener(CharaLostInTheFogEvent.PLAYER, playerLostInTheFogHandler);
            _duel.removeEventListener(CharaLostInTheFogEvent.FOE, foeLostInTheFogHandler);
            _duel.removeEventListener(InTheFogEvent.PLAYER, playerInTheFogHandler);
            _duel.addEventListener(HideMoveEvent.HIDE_MOVE, playerHideMoveHandler);
            _duel.plEntrant.removeEventListener(TrapActionEvent.ACTION, playerTrapActionHandler);
            _duel.foeEntrant.removeEventListener(TrapActionEvent.ACTION, foeTrapActionHandler);
            _duel.plEntrant.removeEventListener(TrapActionEvent.UPDATE, playerTrapUpdateHandler);
            _duel.foeEntrant.removeEventListener(TrapActionEvent.UPDATE, foeTrapUpdateHandler);

            // 顔アップ出す
            _duel.removeEventListener(RollResultEvent.PLAYER_ATTACK, battlePlayerResultHandler);
            _duel.removeEventListener(RollResultEvent.FOE_ATTACK, battleFoeResultHandler);

            _duel.removeEventListener(Duel.CHARA_CHANGE_PHASE_START, changeStartHandler);
            _duel.removeEventListener(Duel.DEAD_CHARA_CHANGE_PHASE_START, changeStartHandler);

            _duel.removeEventListener(CharaTransformEvent.PLAYER, playerTransformHandler);
            _duel.removeEventListener(CharaTransformEvent.FOE, foeTransformHandler);

            _duel.plEntrant.removeEventListener(Entrant.CHANGE_DONE, plCharaCardChangeHandler);
            _duel.foeEntrant.removeEventListener(Entrant.CHANGE_DONE, foeCharaCardChangeHandler);

            _duel.removeEventListener(ChangeCharaCardEvent.PLAYER, plCharaCardChangeHandler);
            _duel.removeEventListener(ChangeCharaCardEvent.FOE, foeCharaCardChangeHandler);

            _duel.removeEventListener(StuffedToysSetEvent.PLAYER_SET, playerStuffedToysSetHandler);
            _duel.removeEventListener(StuffedToysSetEvent.FOE_SET, foeStuffedToysSetHandler);
        }

        public function getBringOnThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_plChara, {x:0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            pExec.addThread(new BeTweenAS3Thread(_foeChara, {x:0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            return pExec;
        }

        public function getBringOffThread(result:int=0):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            if(result)
            {
                if (_foeChara != null) {pExec.addThread(new BeTweenAS3Thread(_foeChara, {x:700}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));}
                if (_plChara != null)  {pExec.addThread(new BeTweenAS3Thread(_plChara, {alpha:0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));}
                sExec.addThread(pExec);
            }
            else
            {
                if (_plChara != null)  {pExec.addThread(new BeTweenAS3Thread(_plChara, {x:-700}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));}
                if (_foeChara != null) {pExec.addThread(new BeTweenAS3Thread(_foeChara, {alpha:0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));}
                sExec.addThread(pExec);
            }

            return sExec;
        }

        private function distanceUpdateHandler(e:Event):void
        {
            _foeChara.updateDistance(_duel.distance);
            _plChara.updateDistance(_duel.distance);
        }

        // キャラチェンジがスタートしたら
        private function changeStartHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "CHARA CHANGE IN STAND CHARA!",_duel.foeEntrant.getChangeDone(),_duel.plEntrant.getChangeDone() );
            if (!(_duel.foeEntrant.getChangeDone()))
            {
                GameCtrl.instance.addNoWaitViewSequence(new ClousureThread(_foeChara.thinkStart)); //.start();
            }
            if (!(_duel.plEntrant.getChangeDone()))
            {
                if (_duel.plEntrant.hitPoint > 0)
                {
                    Voice.playCharaVoice(_duel.playerCharaCard.parentID, Const.VOICE_SITUATION_BATTLE_CHANGE_OUT);
                }
                GameCtrl.instance.addNoWaitViewSequence(new ClousureThread(_plChara.thinkStart)); //.start();
            }

        }


        // プレイヤーキャラが変更されたときのハンドラ
        private function plCharaCardChangeHandler(e:Event):void
        {
//            _plThinkIcon.getHideThread().start();
            _plChara.thinkStop();
            // 既存のプレイヤーを消去
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(_plChara, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
            sExec.addThread(_plChara.getHideThread());
            plCharaCardChange(sExec);
            Voice.playCharaVoice(_duel.playerCharaCard.parentID, Const.VOICE_SITUATION_BATTLE_CHANGE_IN);
        }


        // 装甲猟兵乗り 立ち絵切り替え用
        private var HAS_PILOTS:Array = [20,27];
        private var VERONICA:int = 73;

        // 新しいキャラに差し替える
        private function plCharaCardChange(sExec:SerialExecutor):void
        {
            var imageUrl:String = "";
            if (_duel.isCat(true, _duel.plEntrant.currentCharaCardIndex))
            {
                imageUrl = CAT_STANDIMAGE;
            }
            else if (HAS_PILOTS.indexOf(_duel.playerCharaCard.charactor) >= 0 && isSealing(true))
            {
                imageUrl = _duel.playerCharaCard.standImage.replace(RESULT_SUFIX, "") + "ch";
            }
            else
            {
                imageUrl = _duel.playerCharaCard.standImage;
            }

            var charaImage:StandCharaImage = new StandCharaImage( true, imageUrl);
            charaImage.alpha = 0.0;
            sExec.addThread(charaImage.getShowThread(this));
            var sExec2:SerialExecutor = new SerialExecutor();
            sExec2.addThread(new BeTweenAS3Thread(charaImage, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
            _animeThread = sExec2;
            GameCtrl.instance.addNoWaitViewSequence(sExec);
            GameCtrl.instance.addNoWaitViewSequence(sExec2);
            _plChara = charaImage;
            if (_duel.playerCharaCard.charactor == VERONICA)
                _plChara.setStuffedToys(_duel.getStuffedToysNum(true));
            _plChara.updateDistance(_duel.distance);
        }

        // 相手キャラが変更されたときのハンドラ
        private function foeCharaCardChangeHandler(e:Event):void
        {
            _foeChara.thinkStop();
            // 既存のプレイヤーを消去
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(_foeChara, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
            sExec.addThread(_foeChara.getHideThread());
            sExec.addThread(new CCLoadWaitThread(_duel.foeCharaCard));
            sExec.addThread(new ClousureThread(foeCharaCardChange));
            GameCtrl.instance.addViewSequence(sExec);
        }

        // 新しいキャラに差し替える
        private function foeCharaCardChange():void
        {

            var imageUrl:String = "";
            if (_duel.isCat(false, _duel.foeEntrant.currentCharaCardIndex))
            {
                imageUrl = CAT_STANDIMAGE;
            }
            else if (HAS_PILOTS.indexOf(_duel.foeCharaCard.charactor) >= 0 && isSealing(false))
            {
                imageUrl = _duel.foeCharaCard.standImage.replace(RESULT_SUFIX, "") + "ch";
            }
            else
            {
                imageUrl = _duel.foeCharaCard.standImage;
            }

            var sExec:SerialExecutor = new SerialExecutor();
            var charaImage:StandCharaImage = new StandCharaImage( false, imageUrl);
            charaImage.alpha = 0.0;

            sExec.addThread(charaImage.getShowThread(this));
            sExec.addThread(new BeTweenAS3Thread(charaImage, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
            GameCtrl.instance.addNoWaitViewSequence(sExec);

            _foeChara = charaImage;
            if (_duel.foeCharaCard.charactor == VERONICA)
                _foeChara.setStuffedToys(_duel.getStuffedToysNum(false));
            _foeChara.updateDistance(_duel.distance);
            GameCtrl.instance.addViewSequence(sExec);
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

        // プレイヤーキャラが変身したときのハンドラ
        private function playerTransformHandler(e:CharaTransformEvent):void
        {
//            _plThinkIcon.getHideThread().start();
            var charaImage:StandCharaImage;
            var sExec:SerialExecutor = new SerialExecutor();

            if(e.enabled)
            {
                switch (e.transformType) {
                case CharaTransformEvent.TYPE_STANDARD:
                    charaImage = new StandCharaImage( true, _duel.playerCharaCard.standImage.replace(RESULT_SUFIX, "")+"ch");
                    break;
                case CharaTransformEvent.TYPE_CAT:
                    // 増えたらCharaCardに項目を足す予定
                    _duel.setCatState(true, _duel.plEntrant.currentCharaCardIndex, true);
                    charaImage = new StandCharaImage( true, CAT_STANDIMAGE);
                }
            }
            else
            {
                _duel.setCatState(true, _duel.plEntrant.currentCharaCardIndex, false);
                charaImage = new StandCharaImage( true, _duel.playerCharaCard.standImage);
            }
            charaImage.alpha = 0.0;

            // 既存のプレイヤーを消去
            sExec.addThread(new BeTweenAS3Thread(_plChara, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
            sExec.addThread(_plChara.getHideThread());
            sExec.addThread(charaImage.getShowThread(this));
            sExec.addThread(new BeTweenAS3Thread(charaImage, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
            GameCtrl.instance.addNoWaitViewSequence(sExec);
            _plChara = charaImage;
            _plChara.updateDistance(_duel.distance);
        }

        // 対戦キャラが変身したときのハンドラ
        private function foeTransformHandler(e:CharaTransformEvent):void
        {
//            _plThinkIcon.getHideThread().start();
            var charaImage:StandCharaImage;
            var sExec:SerialExecutor = new SerialExecutor();

            if(e.enabled)
            {
                switch (e.transformType) {
                case CharaTransformEvent.TYPE_STANDARD:
                    charaImage = new StandCharaImage( false, _duel.foeCharaCard.standImage.replace(RESULT_SUFIX, "")+"ch");
                    break;
                case CharaTransformEvent.TYPE_CAT:
                    // 増えたらCharaCardに項目を足す予定
                    _duel.setCatState(false, _duel.foeEntrant.currentCharaCardIndex, true);
                    charaImage = new StandCharaImage( false, "standchara01cat");
                }
            }
            else
            {
                _duel.setCatState(false, _duel.foeEntrant.currentCharaCardIndex, false);
                charaImage = new StandCharaImage( false, _duel.foeCharaCard.standImage);
            }
            charaImage.alpha = 0.0;

            // 既存のプレイヤーを消去
            sExec.addThread(new BeTweenAS3Thread(_foeChara, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
            sExec.addThread(_foeChara.getHideThread());
            sExec.addThread(charaImage.getShowThread(this));
            sExec.addThread(new BeTweenAS3Thread(charaImage, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
            GameCtrl.instance.addNoWaitViewSequence(sExec);
            _foeChara = charaImage;
            _foeChara.updateDistance(_duel.distance);
        }

        // ヌイグルミをセットするハンドラ
        private function playerStuffedToysSetHandler(e:StuffedToysSetEvent):void
        {
            _plChara.setStuffedToys(e.num);
        }

        // ヌイグルミをセットするハンドラ
        private function foeStuffedToysSetHandler(e:StuffedToysSetEvent):void
        {
            _foeChara.setStuffedToys(e.num);
        }


        // プレイヤーキャラを霧に出し入れするハンドラ
        private function playerLostInTheFogHandler(e:CharaLostInTheFogEvent):void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            // 「中距離を取る」と「半透明化＋空席に分身を入れる」を並列に実行する
            // オリジナルは必ず中距離に移動し、距離表示を「hiding」にする
            if (_animeThread) _animeThread.interrupt();
            if(e.enabled)
            {
                _duel.plEntrant.inFog = true;
                _plStandCharaArray = [];
                _plStandCharaArray.push(new StandCharaImage(true, _duel.playerCharaCard.standImage, true));
                _plStandCharaArray.push(_plChara);
                _plStandCharaArray.push(new StandCharaImage(true, _duel.playerCharaCard.standImage, true));
                for (var i:uint=0; i < 3; i ++) {
                    if (i != 1)
                    {
                        _plStandCharaArray[i].x = _plChara.x;
                        addChild(_plStandCharaArray[i]);
                        _plStandCharaArray[i].alpha = 0;
                    }
                }

                // 現在距離を専用表示にする
                _duel.setDistance(4);

                var start_alpha:Number;
                for (i = 0; i < 3; i++) {
                    if (i != 1)
                    {
                        start_alpha = 0;
                        _plStandCharaArray[i].setStandX(i+1);
                    }
                    else
                    {
                        start_alpha = 1;
                    }
                    pExec.addThread(new BeTweenAS3Thread(_plStandCharaArray[i],
                                                         {
                                                             transform:{
                                                                 colorTransform:{
                                                                     alphaMultiplier:0.3,
                                                                     blueMultiplier:0,
                                                                     greenMultiplier:0,
                                                                     redMultiplier:0
                                                                         }
                                                             },
                                                                 alpha:1},
                                                         {transform:null, alpha:start_alpha},
                                                         0.5, BeTweenAS3Thread.EASE_OUT_SINE));

                    if (i!=1)
                    {
                        _plStandCharaArray[i].updateDistance(i+1);
                    }
                }
                if (e.truth_distance)
                {
                    var truth:int = e.truth_distance;
                    pExec2.addThread(new BeTweenAS3Thread(_plStandCharaArray[truth-1],
                                                          {
                                                              transform:{
                                                                  colorTransform:{
                                                                      alphaMultiplier:0.7,
                                                                          blueMultiplier:0.8,
                                                                          greenMultiplier:0.8,
                                                                          redMultiplier:0.8
                                                                          }
                                                              }},
                                                          null,
                                                          0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                }
            }
            else
            {
                // 分身消去 -> 位置修正+距離表示復帰
                _duel.plEntrant.inFog = false;
                if (_plStandCharaArray.length > 0)
                {
                    var end_alpha:Number;
                    for (i = 0; i < 3; i++)
                    {
                        _plStandCharaArray[i].updateDistance(e.distance);
                        if (i != 1)
                        {
                            _plStandCharaArray[i].updateDistance(e.distance);
                            pExec2.addThread(_plStandCharaArray[i].getHideThread());
                            end_alpha = 0;
                        }
                        else
                        {
                            _duel.setDistance(e.distance);
                            end_alpha = 1;
                        }

                        pExec.addThread(new BeTweenAS3Thread(_plStandCharaArray[i],
                                                             {
                                                                 transform:{
                                                                     colorTransform:{
                                                                         alphaMultiplier:1,
                                                                             blueMultiplier:1,
                                                                             greenMultiplier:1,
                                                                             redMultiplier:1
                                                                             }
                                                                 },
                                                                     alpha:end_alpha},
                                                             {transform:null, alpha:1},
                                                             0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                        _plStandCharaArray[i].filters = [];
                    }
                }
            }
            sExec.addThread(pExec);
            sExec.addThread(pExec2);
            _animeThread = sExec;
            GameCtrl.instance.addNoWaitViewSequence(sExec);
        }

        // 対戦キャラを霧に出し入れするハンドラ
        private function foeLostInTheFogHandler(e:CharaLostInTheFogEvent):void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            // 「中距離を取る」と「半透明化＋空席に分身を入れる」を並列に実行する
            // オリジナルは必ず中距離に移動し、距離表示を「hiding」にする

            if (_animeThread) _animeThread.interrupt();
            if(e.enabled)
            {
                _duel.foeEntrant.inFog = true;
                _foeStandCharaArray = [];
                _foeStandCharaArray.push(new StandCharaImage(false, _duel.foeCharaCard.standImage, true));
                _foeStandCharaArray.push(_foeChara);
                _foeStandCharaArray.push(new StandCharaImage(false, _duel.foeCharaCard.standImage, true));
                for (var i:uint=0; i < 3; i ++) {
                    if (i != 1)
                    {
                        _foeStandCharaArray[i].x = _foeChara.x;
                        addChild(_foeStandCharaArray[i]);
                        _foeStandCharaArray[i].alpha = 0;
                    }
                }

                // 現在距離を専用表示にする
                _duel.setDistance(4);

                var start_alpha:Number;
                for (i = 0; i < 3; i++) {
                    if (i != 1)
                    {
                        start_alpha = 0;
                        _foeStandCharaArray[i].setStandX(i+1);
                    }
                    else
                    {
                        start_alpha = 1;
                    }
                    pExec.addThread(new BeTweenAS3Thread(_foeStandCharaArray[i],
                                                         {
                                                             transform:{
                                                                 colorTransform:{
                                                                     alphaMultiplier:0.3,
                                                                     blueMultiplier:0,
                                                                     greenMultiplier:0,
                                                                     redMultiplier:0
                                                                         }
                                                             },
                                                                 alpha:1},
                                                         {transform:null, alpha:start_alpha},
                                                         0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                    if (i!=1)
                    {
                        _foeStandCharaArray[i].updateDistance(i+1);
                    }
                }
            }
            else
            {
                _duel.foeEntrant.inFog = false;
                // 分身消去 -> 位置修正+距離表示復帰
                if (_foeStandCharaArray.length > 0)
                {
                    var end_alpha:Number;
                    for (i = 0; i < 3; i++)
                    {
                        _foeStandCharaArray[i].updateDistance(e.distance);
                        if (i != 1)
                        {
                            _foeStandCharaArray[i].updateDistance(e.distance);
                            pExec2.addThread(_foeStandCharaArray[i].getHideThread());
                            end_alpha = 0;
                        }
                        else
                        {
                            _duel.setDistance(e.distance);
                            end_alpha = 1;
                        }

                        pExec.addThread(new BeTweenAS3Thread(_foeStandCharaArray[i],
                                                             {
                                                                 transform:{
                                                                     colorTransform:{
                                                                         alphaMultiplier:1,
                                                                             blueMultiplier:1,
                                                                             greenMultiplier:1,
                                                                             redMultiplier:1
                                                                             }
                                                                 },
                                                                     alpha:end_alpha},
                                                             {transform:null, alpha:1},
                                                             0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                        _foeStandCharaArray[i].filters = [];

                    }
                }
            }
            sExec.addThread(pExec);
            sExec.addThread(pExec2);
            _animeThread = sExec;
            GameCtrl.instance.addNoWaitViewSequence(sExec);

        }

        // 霧をライティングするハンドラ
        private function playerInTheFogHandler(e:InTheFogEvent):void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            if (_animeThread) _animeThread.interrupt();
            if(_foeStandCharaArray && _foeStandCharaArray.length > 0)
            {
                var glow:GlowFilter = new GlowFilter();
                glow.color = 0x9D1919;
                glow.alpha = 1;
                glow.blurX = 15;
                glow.blurY = 15;
                for (var i:uint=0; i < 3; i++)
                {
                    if (_foeStandCharaArray[i])
                    {
                        if (e.range.indexOf(i+1) != -1)
                        {
                             pExec.addThread(new BeTweenAS3Thread(_foeStandCharaArray[i],
                                                                 {
                                                                     transform:{
                                                                         colorTransform:{
                                                                             // alphaMultiplier:0.5,
                                                                             alphaMultiplier:0.5,
                                                                                 blueMultiplier:0.1,
                                                                                 greenMultiplier:0.1,
                                                                                 //redMultiplier:0.6
                                                                                 redMultiplier:0.8
                                                                                 }
                                                                     }
                                                                 },
                                                                 null,
                                                                 0.1, BeTweenAS3Thread.EASE_OUT_SINE));
                             //_foeStandCharaArray[i].filters = [glow];
                        }
                        else
                        {
                            pExec.addThread(new BeTweenAS3Thread(_foeStandCharaArray[i],
                                                                 {
                                                                     transform:{
                                                                         colorTransform:{
                                                                             alphaMultiplier:0.3,
                                                                                 blueMultiplier:0,
                                                                                 greenMultiplier:0,
                                                                                 redMultiplier:0
                                                                                 }
                                                                     }
                                                                 },
                                                                 null,
                                                                 0.1, BeTweenAS3Thread.EASE_OUT_SINE));
                            _foeStandCharaArray[i].filters = [];
                        }
                    }
                }
            }

            _animeThread = pExec;
            GameCtrl.instance.addNoWaitViewSequence(pExec);
        }

        // ハイド状態で位置が変更された場合
        private function playerHideMoveHandler(e:HideMoveEvent):void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_animeThread) _animeThread.interrupt();
            if(_plStandCharaArray && _plStandCharaArray.length > 0)
            {
                for (var i:uint=0; i < 3; i++)
                {
                    if (_plStandCharaArray[i])
                    {
                        if (i+1 == e.distance)
                        {
                            pExec.addThread(new BeTweenAS3Thread(_plStandCharaArray[i],
                                                                  {
                                                                      transform:{
                                                                          colorTransform:{
                                                                              alphaMultiplier:0.7,
                                                                                  blueMultiplier:0.8,
                                                                                  greenMultiplier:0.8,
                                                                                  redMultiplier:0.8
                                                                                  }
                                                                      }},
                                                                  null,
                                                                  0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                        }
                        else
                        {
                            pExec.addThread(new BeTweenAS3Thread(_plStandCharaArray[i],
                                                                 {
                                                                     transform:{
                                                                         colorTransform:{
                                                                             alphaMultiplier:0.3,
                                                                                 blueMultiplier:0,
                                                                                 greenMultiplier:0,
                                                                                 redMultiplier:0
                                                                                 }
                                                                     }
                                                                 },
                                                                 null,
                                                                 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                        }
                    }
                }

                _animeThread = pExec;
                GameCtrl.instance.addNoWaitViewSequence(pExec);
            }
        }


      // 自分が攻撃の場合
        private function battlePlayerResultHandler(e:RollResultEvent):void
        {
            _plChara.onAttack();

        }

        // 敵が攻撃
        private function battleFoeResultHandler(e:RollResultEvent):void
        {

            _foeChara.onAttack();

        }

        private var lose_count:int = 0;
        // 自分ダメージ
        private function playerDamageHandler(e:DamageEvent):void
        {
            log.writeLog(log.LV_INFO, this, "player vib");
            GameCtrl.instance.addNoWaitViewSequence(new ClousureThread(_plChara.playHitEffect,[e.point]));
            if (Duel.instance.plEntrant.hitPoint > 0 && !e.is_not_hostile && Duel.instance.plEntrant.hitPoint <= _duel.playerCharaCard.hp * 0.4)
            {
                Voice.playCharaVoice(_duel.playerCharaCard.parentID, Const.VOICE_SITUATION_BATTLE_HEAVY_DAMAGE_DEF, 0, 0, Const.VOICE_PLAYING_METHOD_EXCLUSIVE);
            }
            else if (Duel.instance.plEntrant.hitPoint < 1 && Duel.instance.foeEntrant.hitPoint > 0)
            {
                if (lose_count > 2){
                    lose_count += 1 + Math.floor(Math.random() * 2); // 1 or 2 を加算して剰余を取る。今の音声以外の2つから無作為に選らぶ
                }
                Voice.playCharaVoice(_duel.playerCharaCard.parentID, Const.VOICE_SITUATION_BATTLE_LOSE,(lose_count % 3)+1,_duel.foeCharaCard.parentID, Const.VOICE_PLAYING_METHOD_ADDITIOAL);
                lose_count++;
            }
       }

        private var win_count:int = 0;
        // 相手ダメージ
        private function foeDamageHandler(e:DamageEvent):void
        {
            log.writeLog(log.LV_INFO, this, "foe vib");
            GameCtrl.instance.addNoWaitViewSequence(new ClousureThread(_foeChara.playHitEffect,[e.point]));
            if (Duel.instance.raidBoss) return;
            if (Duel.instance.foeEntrant.hitPoint > 0 && !e.is_not_hostile && Duel.instance.foeEntrant.hitPoint <= _duel.foeCharaCard.hp * 0.4 && Duel.instance.foeEntrant.hitPoint <= 20)
            {
                Voice.playCharaVoice(_duel.playerCharaCard.parentID, Const.VOICE_SITUATION_BATTLE_HEAVY_DAMAGE_ATK, 0, 0, Const.VOICE_PLAYING_METHOD_EXCLUSIVE);
            }
            else if (Duel.instance.plEntrant.hitPoint > 0 && Duel.instance.foeEntrant.hitPoint < 1)
            {
                if (win_count > 2){
                    win_count += 1 + Math.floor(Math.random() * 2); // 1 or 2 を加算して剰余を取る。今の音声以外の2つから無作為に選らぶ
                }
                Voice.playCharaVoice(_duel.playerCharaCard.parentID, Const.VOICE_SITUATION_BATTLE_WIN,(win_count % 3)+1,_duel.foeCharaCard.parentID, Const.VOICE_PLAYING_METHOD_ADDITIOAL);
                win_count++;
            }
        }

        private function deadCountReset():void
        {
            win_count = 0;
            lose_count = 0;
        }

        // 自分回復
        private function playerHealHandler(e:DamageEvent):void
        {
            log.writeLog(log.LV_INFO, this, "player heal");
            GameCtrl.instance.addNoWaitViewSequence(new ClousureThread(_plChara.playPlayerHealEffect,[e.point, _duel.playerCharaCard.parentID]));

//             var pExec:ParallelExecutor = new ParallelExecutor();
//             var pExec2:ParallelExecutor  = new ParallelExecutor();
//             var sExec:SerialExecutor;


//             // ここでごちゃごちゃ動かしています
//             for(var i:int = 0; i < e.point; i++)
//             {
//                 sExec = new SerialExecutor();

//                 sExec.addThread(new SleepThread(500*i));
//                 sExec.addThread(createHealEffect(0));
//                 pExec.addThread(sExec)
//             }
//             GameCtrl.instance.addNoWaitViewSequence(pExec);
       }

        // 相手回復
        private function foeHealHandler(e:DamageEvent):void
        {
            log.writeLog(log.LV_INFO, this, "foe heal");
            GameCtrl.instance.addNoWaitViewSequence(new ClousureThread(_foeChara.playHealEffect,[e.point]));

//             var pExec:ParallelExecutor = new ParallelExecutor();
//             var pExec2:ParallelExecutor  = new ParallelExecutor();
//             var sExec:SerialExecutor;

//             // ここでごちゃごちゃ動かしています
//             for(var i:int = 0; i < e.point; i++)
//             {
//                 sExec = new SerialExecutor();

//                 sExec.addThread(new SleepThread(500*i));
//                 sExec.addThread(createHealEffect(520));
//                 pExec.addThread(sExec)
//             }
//             GameCtrl.instance.addNoWaitViewSequence(pExec);
        }

        // 自分トラップ発動
        private function playerTrapActionHandler(e:TrapActionEvent):void
        {
            GameCtrl.instance.addNoWaitViewSequence(new ClousureThread(_plChara.playTrapActionEffect,[e.kind, e.distance]));
        }

        // 相手トラップ発動
        private function foeTrapActionHandler(e:TrapActionEvent):void
        {
            GameCtrl.instance.addNoWaitViewSequence(new ClousureThread(_foeChara.playTrapActionEffect,[e.kind, e.distance]));
        }

        // 自分トラップ更新
        private function playerTrapUpdateHandler(e:TrapActionEvent):void
        {
            // 相手には見せない
            if (e.visible)
            {
                GameCtrl.instance.addNoWaitViewSequence(new ClousureThread(_plChara.playTrapUpdateEffect,[e.kind, e.distance, e.turn, e.visible]));
            }
        }

        // 相手トラップ更新
        private function foeTrapUpdateHandler(e:TrapActionEvent):void
        {
            GameCtrl.instance.addNoWaitViewSequence(new ClousureThread(_foeChara.playTrapUpdateEffect,[e.kind, e.distance, e.turn, e.visible]));
        }

        private function createHealEffect(offset:int):Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            var offsetX:Array = [180, 210, 260];
            var offsetY:Array = [300, 400, 320];

            var randX:int = Math.random() * 80;
            var randY:int = Math.random() * 80;

            for(var j:int = 0; j < 3; j++)
            {
//                 var sExec:SerialExecutor = new SerialExecutor();
//                 var effect:StateEffect = new StateEffect();
//                 // エフェクトを追加
//                 effect.x = offsetX[j] + randX + offset;
//                 effect.y = offsetY[j] + randY;
//                 // 動きを追加
//                 sExec.addThread(new SleepThread(100*j));
//                 sExec.addThread(effect.getShowThread(this));
//                 sExec.addThread(effect.getHideThread());
//                 pExec.addThread(sExec);
//                 log.writeLog(log.LV_INFO, this, "e.point", j);
            }
            return pExec;
        }


        // 毎フレームごとのイベント
        private function enterFrameHandler(e:Event):void
        {
//             var pExec:ParallelExecutor = new ParallelExecutor();
//             var pExec2:ParallelExecutor = new ParallelExecutor();
//             var sExec:SerialExecutor = new SerialExecutor();
//             _plChara.filters[0].alpha -= 0.1;
//             _foeChara.filters[0].alpha -= 0.1;
//             if(_plChara.filters[0].alpha <= 0.0)
//             {
//                 _plChara.filters[0].alpha = 1.0;
//                 _foeChara.filters[0].alpha = 1.0;
//             }
        }

        //
        private function setAttackHandler(e:Event):void
        {
            setPlAttack();
        }

        //
        private function setDeffenceHandler(e:Event):void
        {
            setPlDeffence();
        }

        //
        private function setMoveHandler(e:Event):void
        {
            setPlMove();
            setFoeMove();
        }

        //
        private function setWaitingHandler(e:Event):void
        {
            setPlWait();
            setFoeWait();
        }

        //
        private function finishPhaseHandler(e:Event):void
        {
//             playerDeleteFlash();
//             foeDeleteFlash();
        }

        // 自分光る
        public function setPlAttack():void
        {
//             _plFilter.color = 0xFF0000;
//             _plFilter.alpha = 1.0;
//             _plFilter.blurX = 8;
//             _plFilter.blurY = 8;
//             _plChara.filters = [_plFilter];
        }

        // 自分光る
        public function setFoeAttack():void
        {
//             _foeFilter.color = 0xFF0000;
//             _foeFilter.alpha = 1.0;
//             _foeFilter.blurX = 8;
//             _foeFilter.blurY = 8;
//             _foeChara.filters = [_foeFilter];
        }

        // 自分光る
        public function setPlDeffence():void
        {
//             _plFilter.color = 0x0000FF;
//             _plFilter.alpha = 1.0;
//             _plFilter.blurX = 8;
//             _plFilter.blurY = 8;
//             _plChara.filters = [_plFilter];
        }

        // 自分光る
        public function setFoeDeffence():void
        {
//             _foeFilter.color = 0x0000FF;
//             _foeFilter.alpha = 1.0;
//             _foeFilter.blurX = 8;
//             _foeFilter.blurY = 8;
//             _foeChara.filters = [_foeFilter];
        }

        // 自分光る
        public function setPlMove():void
        {
//             _plFilter.color = 0xFF20FF;
//             _plFilter.alpha = 1.0;
//             _plFilter.blurX = 8;
//             _plFilter.blurY = 8;
//             _plChara.filters = [_plFilter];
        }

        // 自分光る
        public function setFoeMove():void
        {
//             _foeFilter.color = 0xFF20FF;
//             _foeFilter.alpha = 1.0;
//             _foeFilter.blurX = 8;
//             _foeFilter.blurY = 8;
//             _foeChara.filters = [_foeFilter];
        }

        // 自分光る
        public function setPlWait():void
        {
//             _plFilter.color = 0xFFFFFF;
//             _plFilter.alpha = 1.0;
//             _plFilter.blurX = 8;
//             _plFilter.blurY = 8;
//             _plChara.filters = [_plFilter];
        }

        // 自分光る
        public function setFoeWait():void
        {
//             _foeFilter.color = 0xFFFFFF;
//             _foeFilter.alpha = 1.0;
//             _foeFilter.blurX = 8;
//             _foeFilter.blurY = 8;
//             _foeChara.filters = [_foeFilter];
        }
    }

}


// Duelのinitを待つShowスレッド

import flash.display.*;
import flash.utils.*;
import view.*;
import flash.geom.Rectangle;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import org.libspark.thread.Thread;
import org.libspark.thread.utils.SerialExecutor;
import model.*;
import view.scene.game.StandChara;
import view.BaseShowThread;

class ShowThread extends BaseShowThread
{
    private var _sc:StandChara;

    public function ShowThread(sc:StandChara, stage:DisplayObjectContainer)
    {
        _sc = sc;
        super(sc,stage)
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

// ディレイつきで関数が呼べるスレッド
class ClousureDelayThread extends Thread
{
    private var _func:Function;
    private var _delay:int;

    public function ClousureDelayThread(func:Function, delay:int)
    {
        _delay = delay;
        _func = func;
    }

    protected override function run():void
    {
        setInterval(_func, _delay);
    }
}
// キャラカードのロードをまつスレッド
class CCLoadWaitThread extends Thread
{
    private var _m:BaseModel;
    private var _func:Function;

    public function CCLoadWaitThread (m:BaseModel)
    {
        _m = m;
    }

    protected override function run():void
    {
        if (_m.loaded == false)
        {
            _m.wait();
            }
        next(close);
    }

    private function close():void
    {
    }
}

class DrawThread extends Thread
{
    private var _d:DisplayObject;
    private var _bd:BitmapData;
    private var _offset:Matrix;
    private var _counter:int = 0;
    private static const _WAIT_FRAME:int = 8;
    private var _colorTransform:ColorTransform;
    private var _blendMode:String;
    private var _clipRect:Rectangle;
    private var _smoothing:Boolean = false;

    public function DrawThread(d:DisplayObject, b:BitmapData, offset:Matrix = null, colorTransform:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false)
    {
        _d = d;
        _bd = b;
        _offset = offset;
        _colorTransform = _colorTransform;
        _blendMode      = _blendMode;
        _clipRect       = _clipRect;
        _smoothing      = _smoothing;
    }

    protected override function run():void
    {
        next(draw);
    }

    private function draw():void
    {
        if (_counter > _WAIT_FRAME)
        {
            _bd.draw(_d, _offset,_colorTransform, _blendMode, _clipRect, _smoothing);
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new SleepThread(1000));
            sExec.addThread(new ClousureThread(_bd.draw,[_d, _offset,_colorTransform, _blendMode, _clipRect, _smoothing]));
            sExec.addThread(new SleepThread(1000));
            sExec.addThread(new ClousureThread(_bd.draw,[_d, _offset,_colorTransform, _blendMode, _clipRect, _smoothing]));
            sExec.addThread(new SleepThread(1000));
            sExec.addThread(new ClousureThread(_bd.draw,[_d, _offset,_colorTransform, _blendMode, _clipRect, _smoothing]));
            sExec.addThread(new SleepThread(1000));
            sExec.addThread(new ClousureThread(_bd.draw,[_d, _offset,_colorTransform, _blendMode, _clipRect, _smoothing]));
            sExec.start();
            return;
        }else{
            _counter +=1;
            next(draw)
                }
    }
}