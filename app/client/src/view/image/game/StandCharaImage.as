package view.image.game
{
    import flash.utils.*;

    import flash.display.*;
    import flash.events.Event;
    import flash.filters.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
//    import org.libspark.betweenas3.easing.*;


    import flash.events.MouseEvent;
    import mx.controls.*;
    import mx.core.*;
    import mx.effects.*;

    import mx.effects.easing.*;

    import view.image.BaseLoadImage;
    import view.utils.*;
    import view.*;
    import view.scene.raid.RageRankingEffect;
    import model.Duel;
    import model.events.*;

    /**
     * StandChara01表示クラス
     *
     */


    public class StandCharaImage extends BaseLoadImage
    {
        public static const DIST_ANIME:Array = ["toleft1","toleft2","toleft3"]; /* of int */ ;

        // インスタンス名
        private static const STAND:String = "stand"
        private static const UP:String = "up"
        private static const SHADOW:String = "shadow"
        private static const STAND_HATE:String = "stand_hate"
        private static const DOLL:String = "doll"
        private static const URL:String = "/public/image/standchara/";
        private static const DIS_X_SET:Array =  [[288,184,80,184],[472,576,680,576]]; // 0が自分1が相手, [3]はハイド、間隔は中距離
        private static const Y:int =  416;
        private static const TIME:Number =  0.3;


        private static const UP_START_X:int = -300;
        private static const UP_END_X:int = 0;
        private static const UP_TIME_IN:Number = 0.45;
        private static const UP_TIME_OUT:Number = 0.3;

        private static const LABEL_WIDTH:int = 250;
        private static const LABEL_HIGHT:int = 120;

        private static const BLOOD_NUM_MAX:int = 15;

        // キャッシュを作っておくためのだけのエフェクトオブジェクト
//        private static var __preLoadEffect:HitHealEffect = new HitHealEffect(1);

        private static var __filter:GradientBevelFilter = new GradientBevelFilter(0,45,[0xFFFFFF, 0xFFFFFF, 0xFFFFFF],[0.5, 0.5, 0.5],[0, 0, 0],0,0);

//        private static var __hitBloodEffect:HitBloodEffect = new HitBloodEffect();

        private var _thinkIcon:CharaChangeThinkImage = new CharaChangeThinkImage();
        private var _damageLabel:Label = new Label();
        private var _damageStr:HitDamageStr = new HitDamageStr();
        private var _healContainer:UIComponent = new UIComponent();

        private var _foe:Boolean = false;
        private var _distType:int = 0;// 0が自分1が相手

        private var _distance:int = 2;
        private var _standMC:MovieClip;
        private var _shadowMC:MovieClip;
        private var _upMC:MovieClip;
        private var _hateStandMC:MovieClip;
        private var _dollMC:MovieClip;

        private var _offsetX:int = 0;
        private var _scaleX:int = 1;
        private var _originalParent:DisplayObjectContainer;
        private var _originalX:int;
        private var _shakeTween:ITween;
        private var _attackOnTween:ITween;
        private var tween : Tween;
        private var _finished:Boolean = false;

        private var _raidBoss:Boolean = false;
        private var _raidBossPat:RegExp = /1[0-9]{3}/;

        private var _rageStatus:Boolean = false;

        private var _rageRankingEffenct:RageRankingEffect;
        private var _traps:Object = new Object();
        private var _fog:Boolean = false;

        private var _dolls_num:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function StandCharaImage(player:Boolean, url:String, fog:Boolean=false)
        {
//            visible = false;
            super(URL+url+".swf");
            if (player)
            {
            }else{
                _scaleX = -1;
                _distType = 1;
            }

            if (url.match(_raidBossPat)!=null)
            {
                _raidBoss = true;
                _rageRankingEffenct = new RageRankingEffect();
                addChild(_rageRankingEffenct);
            }
            _damageLabel.width = LABEL_WIDTH;
            _damageLabel.height = LABEL_HIGHT;
            _damageLabel.styleName = "DamageLabel";
            _damageLabel.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _damageLabel.alpha = 0.0;

            addChild(_healContainer);
            _healContainer.y = Y;
            _fog = fog;

            initShakeTween();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _standMC = MovieClip(_root.getChildByName(STAND));
            _shadowMC = MovieClip(_root.getChildByName(SHADOW));
            _upMC = MovieClip(_root.getChildByName(UP));
            _dollMC = MovieClip(_root.getChildByName(DOLL));
            // SwfNameInfo.toLog(_root);

//            Unlight.GCW.watch(_upMC,getQualifiedClassName(_upMC));

            _originalX = _upMC.x;
            _originalParent = _upMC.parent;
            _originalParent.removeChild(_upMC)

            _standMC.scaleX = _scaleX;
            _shadowMC.scaleX = _scaleX;
            _upMC.scaleX = _scaleX;

            _standMC.y = Y;
            _shadowMC.y = Y;

            if (_dollMC != null)
            {
                _dollMC.scaleX = _scaleX;
                _dollMC.y = Y;
                _dollMC.gotoAndStop(_dolls_num+1);
            }

            if (_raidBoss)
            {
                _hateStandMC = MovieClip(_root.getChildByName(STAND_HATE));

                if (_hateStandMC != null)
                {
                    _hateStandMC.scaleX = _scaleX;
                    _hateStandMC.y = Y;
                    _hateStandMC.alpha = 0.0;
                }
                Duel.instance.addEventListener(RagePassiveEvent.ON,rageOnEventHandler);
                Duel.instance.addEventListener(RagePassiveEvent.OFF,rageOffEventHandler);
            }

//            initAttackOnTween();
            if (!_fog)
            {
                setDist();
            }
//            _upMC.x = _upMC.x+_originalX;

        }

        private function rageOnEventHandler(e:RagePassiveEvent):void
        {
            _rageStatus = true;
            log.writeLog(log.LV_FATAL, this, "RAGE PASSIVE ON",e.charaSet);
            _rageRankingEffenct.updateRanking(e.charaSet);
            waitComplete(setRageStatus);
        }
        private function rageOffEventHandler(e:Event):void
        {
            _rageStatus = false;
            waitComplete(setRageStatus);
        }



        private function twIn():void
        {
            _upMC.x = _originalX + _scaleX*UP_START_X;
            _upMC.visible = true;
            tween = new Tween ( this,_originalX + _scaleX*UP_START_X,_originalX , 300);
            tween .easingFunction = Sine.easeIn;
        }
        private function twOut():void
        {
            tween = new Tween ( this, _originalX , _originalX + _scaleX*UP_START_X, 250);
            tween .easingFunction = Sine.easeOut;
        }

        public function updateDistance(dist:int):void
        {
            if (_distance != dist&&!_finished)
            {
                if ((dist < 5) && (dist > 0)){
                    if (dist == 4)
                    {
                        _distance = 2;
                    }
                    else
                    {
                        _distance = dist;
                    }
                    waitComplete(setDist);
                }
            }
        }

        private function setRageStatus():void
        {
            if (_raidBoss && _rageStatus &&(_hateStandMC != null))
            {
            BetweenAS3.parallel
                (
                    BetweenAS3.tween(_hateStandMC,
                                     {alpha:1.0},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                        ),
                    BetweenAS3.tween(_standMC,
                                     {alpha:0.0},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                        )
                    ).play();
            } else {
                BetweenAS3.parallel
                (
                    BetweenAS3.tween(_hateStandMC,
                                     {alpha:0.0},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                        ),
                    BetweenAS3.tween(_standMC,
                                     {alpha:1.0},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                        )
                    ).play();
            }
            _rageRankingEffenct.showRanking();

        }

        public function get shadowMC():MovieClip
        {
            return _shadowMC;
        }

        public function get standMC():MovieClip
        {
            return _standMC;
        }

        public function upImage():void
        {
            if (!_finished)
            {
                waitComplete(setUpImage);
            }
        }

        public override function final():void
        {
            RemoveChild.apply(_healContainer);
            _healContainer = null;
            if (_standMC!=null)
            {
                RemoveChild.apply(_standMC);
                RemoveChild.apply(_shadowMC);
                RemoveChild.apply(_upMC);
                RemoveChild.apply(_dollMC);
                _standMC = null;
                _shadowMC = null;
                _upMC = null;
                _dollMC = null;
            }
            if (_raidBoss)
            {
                RemoveChild.apply(_rageRankingEffenct);
                RemoveChild.apply(_hateStandMC);
                _rageRankingEffenct = null;
                _hateStandMC = null;
            }
            for each (var te:TrapEffect in _traps)
                     {
                         RemoveChild.apply(te);
                     }
            _traps = null;

            _thinkIcon = null;
            _damageStr = null;
            _originalParent = null;
            RemoveChild.apply(this);
            _finished = true;

            super.final();
            Duel.instance.removeEventListener(RagePassiveEvent.ON,rageOnEventHandler);
            Duel.instance.removeEventListener(RagePassiveEvent.OFF,rageOffEventHandler);
        }


        public function onTweenUpdate(value : Object):void
        {

            _upMC.x = value as Number;;
        }
        public function onTweenEnd(value : Object):void
        {

            _upMC.x = value as Number;;
        }
        // 攻撃中
        public function onAttack():void
        {
            if (!_finished)
            {
                waitComplete(setAttack);
            }
        }

        // いろいろ奇っ怪なことになっているのは謎のメモリリークのため
        private function setAttack():void
        {

            var sExec:SerialExecutor = new SerialExecutor();
            sExec = new SerialExecutor();
            _upMC.visible = false
            sExec.addThread(new ClousureThread(_originalParent.addChild,[_upMC]));
//             sExec.addThread(new BeTweenAS3Thread(_upMC, { x:_originalX}, { x:_originalX+_scaleX*UP_START_X}, UP_TIME_IN, BeTweenAS3Thread.EASE_IN_SINE, 0.0 ,true ));
//             sExec.addThread(new BeTweenAS3Thread(_upMC, { x:_originalX}, null, UP_TIME_OUT, BeTweenAS3Thread.EASE_IN_SINE, 4.5 ,false));
            sExec.addThread(new ClousureThread(twIn));
            sExec.addThread(new SleepThread(4500));
            sExec.addThread(new ClousureThread(twOut));
            sExec.addThread(new ClousureThread(RemoveChild.apply,[_upMC]));
            sExec.start();

//             BetweenAS3.serial
//                 (
//                      BetweenAS3.addChild(_upMC,_originalParent),
// //                     BetweenAS3.delay(
// //                      BetweenAS3.tween(_upMC,
// //                                       { x:_originalX},
// //                                       { x:_originalX+_scaleX*UP_START_X},
// //                                       UP_TIME_IN,
// //                                       Sine.easeIn
// //                          )
// //,0,4.5)
// //,
// //                     BetweenAS3.tween(_upMC,
// //                                      { x:_originalX+_scaleX*UP_START_X},
// //                                      null,
// //                                      UP_TIME_OUT,
// //                                      Sine.easeIn
// //                         ),
//                      BetweenAS3.removeFromParent(_upMC)

//                     ).play();
//            _attackOnTween.play();

        }


        private function setUpImage():void
        {
            _originalParent.addChild(_upMC);
            _standMC.visible = false;
            _shadowMC.visible = false;

            if (_dollMC)
            {
                _dollMC.visible = false;
            }

            if (_hateStandMC != null)
            {
                    _hateStandMC.visible = false;
            }
        }

        private function setDist():void
        {
            if (_standMC!=null)
            {
                var i:int = _distance-1;
                var iTweens:Array = [];

                iTweens.push(BetweenAS3.tween(_standMC,
                                     { x:DIS_X_SET[_distType][i]},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                                                         ));
                iTweens.push(BetweenAS3.tween(_shadowMC,
                                     { x:DIS_X_SET[_distType][i]},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                                 ));
                if (_dollMC)
                {
                    iTweens.push(BetweenAS3.tween(_dollMC,
                                                  { x:DIS_X_SET[_distType][i]},
                                                  null,
                                                  TIME,
                                                  BeTweenAS3Thread.EASE_IN_QUAD
                                     ));
                }

                iTweens.push(BetweenAS3.tween(_healContainer,
                                     { x:DIS_X_SET[_distType][i]},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                                 ));
            if (_hateStandMC != null)
            {
                iTweens.push(BetweenAS3.tween(_hateStandMC,
                                     { x:DIS_X_SET[_distType][i]},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                                 ));
            }

            BetweenAS3.parallelTweens(iTweens).play();

            }

        }

        private function setDistInvisible():void
        {
            if (_standMC!=null)
            {
                var i:int = _distance-1;
                var iTweens:Array = [];

                iTweens.push(BetweenAS3.tween(_standMC,
                                     { x:DIS_X_SET[_distType][i]},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                                                         ));
                iTweens.push(BetweenAS3.tween(_standMC,
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
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                                                         ));
                iTweens.push(BetweenAS3.tween(_shadowMC,
                                     { x:DIS_X_SET[_distType][i]},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                                 ));
                if (_dollMC)
                {
                    iTweens.push(BetweenAS3.tween(_dollMC,
                                                  { x:DIS_X_SET[_distType][i]},
                                                  null,
                                                  TIME,
                                                  BeTweenAS3Thread.EASE_IN_QUAD
                                     ));
                }
                iTweens.push(BetweenAS3.tween(_healContainer,
                                     { x:DIS_X_SET[_distType][i]},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                                 ));
            if (_hateStandMC != null)
            {
                iTweens.push(BetweenAS3.tween(_hateStandMC,
                                     { x:DIS_X_SET[_distType][i]},
                                     null,
                                     TIME,
                                     BeTweenAS3Thread.EASE_IN_QUAD
                                 ));
            }

            BetweenAS3.parallelTweens(iTweens).play();

            }



        }

        public function thinkStart():void
        {
            if (!_finished)
            {
            var i:int = _distance-1;
            _thinkIcon.x =DIS_X_SET[_distType][i];
            BetweenAS3.serial
                (
                    BetweenAS3.addChild(_thinkIcon,this),
                    BetweenAS3.tween(_thinkIcon,
                                     { alpha:1.0},
                                     { alpha:0.0},
                                     0.5,
                                     BeTweenAS3Thread.EASE_IN_SINE)
                    ).play();
            }
        }

        public function thinkStop():void
        {
            if (!_finished)
            {
            BetweenAS3.serial
                (
                    BetweenAS3.tween(_thinkIcon,
                                     { alpha:0.0},
                                     { alpha:1.0},
                                     0.5,
                                     BeTweenAS3Thread.EASE_IN_SINE),
                    BetweenAS3.removeFromParent(_thinkIcon)
                    ).play();

            }
        }

        public function playHitEffect(damage:int, num:int = 1):void
        {
            var effects:Array = [];
            var bloods:Array = [];
            var tween:Array = []; /* of ITween */ 

            // ヒットエフェクトを出す(今は1ループ固定)
            for(var i:int = 0; i < num; i++)
            {
                _distance == 1 ? effects.push(new HitSlashEffect()) : effects.push(new HitBulletEffect());
                effects[i].x += DIS_X_SET[_distType][_distance-1];
                effects[i].y += Y-100;
                tween.push(BetweenAS3.serial(
                               BetweenAS3.addChild(effects[i],this),
                               BetweenAS3.delay(
                                     BetweenAS3.func(effects[i].onAnime),
                                     0.3*i,2.0),
                               BetweenAS3.tween(effects[i],
                                                { alpha:0.0},
                                                { alpha:1.0},
                                                0.5,
                                                BeTweenAS3Thread.EASE_IN_SINE),
                               BetweenAS3.removeFromParent(effects[i])
                               )
                    );

            }

            // Bloodエフェクトを出す
            var bldNum:int = damage;
            if (bldNum > BLOOD_NUM_MAX) {bldNum = BLOOD_NUM_MAX;}
            for( var j:int = 0; j< bldNum+2; j++)
            {
                bloods.push(new HitBloodEffect(bldNum));
                bloods[j].x += DIS_X_SET[_distType][_distance-1];
                bloods[j].y += Y-200;
                tween.push(BetweenAS3.serial(
                               BetweenAS3.addChild(bloods[j],this),
                               BetweenAS3.delay(
                                   BetweenAS3.func(bloods[j].onAnime),
                                   0.5*i,1.5),
                               BetweenAS3.tween(bloods[j],
                                                { alpha:0.0},
                                                { alpha:1.0},
                                                0.5,
                                                BeTweenAS3Thread.EASE_IN_SINE),
                               BetweenAS3.removeFromParent(bloods[j])
                               )
                    );
            }

            _damageStr.x = DIS_X_SET[_distType][_distance-1]+23;
            _damageStr.y = Y-200;
            // Damage文字を出す
            tween.push(BetweenAS3.serial(
                           BetweenAS3.addChild(_damageStr,this),
                           BetweenAS3.delay(
                               BetweenAS3.parallel(
                                                  BetweenAS3.tween(_damageStr,
                                                                   { alpha:1.0},
                                                                   { alpha:0.0},
                                                                   0.2,
                                                                   BeTweenAS3Thread.EASE_IN_SINE),
                                                  BetweenAS3.tween(_damageStr,
                                                                   { scaleX:1.0,scaleY:1.0},
                                                                   { scaleX:4.0,scaleY:4.0},
                                                                   0.25,
                                                                   BeTweenAS3Thread.EASE_IN_OUT_BOUNCE)
                                   ),
                               0.3,2.2),
                           BetweenAS3.tween(_damageStr,
                                            { alpha:0.0},
                                            { alpha:1.0},
                                            0.22,
                                            BeTweenAS3Thread.EASE_IN_SINE),
                           BetweenAS3.removeFromParent(_damageStr)
                           ));
            // Damage数字を出す
            _damageLabel.x = DIS_X_SET[_distType][_distance-1]-240;
            _damageLabel.y = Y-277;
            _damageLabel.text = damage.toString();

            tween.push(BetweenAS3.serial(
                           BetweenAS3.addChild(_damageLabel,this),
                           BetweenAS3.delay(
                               BetweenAS3.parallel(
                                                  BetweenAS3.tween(_damageLabel,
                                                                   { alpha:1.0},
                                                                   { alpha:0.0},
                                                                   0.2,
                                                                   BeTweenAS3Thread.EASE_IN_SINE),
                                                  BetweenAS3.tween(_damageLabel,
                                                                   { scaleX:1.0,scaleY:1.0},
                                                                   { scaleX:4.0,scaleY:4.0},
                                                                   0.25,
                                                                   BeTweenAS3Thread.EASE_IN_OUT_BOUNCE)
                                   ),
                               0.3,2.2),
                           BetweenAS3.tween(_damageLabel,
                                            { alpha:0.0},
                                            { alpha:1.0},
                                            0.22,
                                            BeTweenAS3Thread.EASE_IN_SINE),
                           BetweenAS3.removeFromParent(_damageLabel)
                           ));

            BetweenAS3.parallel(
                BetweenAS3.parallelTweens(tween),
                _shakeTween
                ).play();

        }

        public function playHealEffect(heal:int, num:int = 2):void
        {
            var effects:Array = [];
            var tween:Array = []; /* of ITween */ 

            var pow:int = num+heal;
            // 回復エフェクトを出す
            for(var i:int = 0; i < pow; i++)
            {
                effects.push(new HitHealEffect(pow));

//                effects[i].x += DIS_X_SET[_distType][_distance-1];
                effects[i].y += -250;
                tween.push(BetweenAS3.serial(
//                                BetweenAS3.addChild(effects[i],this),
                                BetweenAS3.addChild(effects[i],_healContainer),
                               BetweenAS3.delay(
                                     BetweenAS3.func(effects[i].onAnime),
                                     0.3*i,0.9),
                               BetweenAS3.tween(effects[i],
                                                { alpha:0.0},
                                                { alpha:1.0},
                                                0.2,
                                                BeTweenAS3Thread.EASE_IN_SINE),
                               BetweenAS3.removeFromParent(effects[i])
                               )
                    );
            }
            BetweenAS3.parallel(
                BetweenAS3.parallelTweens(tween)
                ).play();
        }

        public function playPlayerHealEffect(heal:int, charactor_id:int, num:int = 2):void
        {
            if (Duel.instance.isDetermineMovePhase)
            {
                Duel.instance.playerStayHealDone();
            }
            Voice.playCharaVoice(charactor_id, Const.VOICE_SITUATION_BATTLE_RECOVER, 0, 0, Const.VOICE_PLAYING_METHOD_EXCLUSIVE);
            playHealEffect(heal, num)
        }

        public function playTrapActionEffect(kind:String, distance:int):void
        {
            var effect:TrapActionEffect;
            var tween:Array = []; /* of ITween */

            // トラップエフェクトを出す

            effect = new TrapActionEffect(kind);
            effect.x = DIS_X_SET[_distType][distance-1];
            effect.y += Y;
            tween.push(BetweenAS3.serial(
                           BetweenAS3.addChild(effect,this),
                           BetweenAS3.delay(
                               BetweenAS3.func(effect.onAnime),
                               0.0,1.0),
                           BetweenAS3.tween(effect,
                                            { alpha:0.0},
                                            { alpha:1.0},
                                            0.5,
                                            BeTweenAS3Thread.EASE_IN_SINE),
                           BetweenAS3.removeFromParent(effect)
                           )
                );
            BetweenAS3.parallel(
                BetweenAS3.parallelTweens(tween)
                ).play();
        }

        public function playTrapUpdateEffect(kind:String, distance:int, turn:int, visible:Boolean):void
        {
            var effect:TrapEffect;
            if (!_traps.hasOwnProperty(kind))
            {
                if (turn == 0)
                {
                    return;
                }
                log.writeLog(log.LV_DEBUG, this, "kind"+kind+"のトラップをアップデート");
                _traps[kind] = new TrapEffect(kind);
                _traps[kind].y += Y;
                addChild(_traps[kind]);
            }
            else if (_traps[kind].Turn == turn && _traps[kind].Xpos == DIS_X_SET[_distType][distance-1] && _traps[kind].Visible)
            {
                return;
            }
            _traps[kind].onAnime(DIS_X_SET[_distType][distance-1], turn);
        }

        // キャラのシェイクTweenを作る
        private function initShakeTween():void
        {
            _shakeTween = BetweenAS3.serial
                (
                    BetweenAS3.delay(
                        BetweenAS3.func(addFlash),
                        0.2,0),
                    BetweenAS3.tween(this,
                                     { x:x+5},
                                     null,
                                     0.04,
                                     BeTweenAS3Thread.EASE_IN_SINE),
                    BetweenAS3.tween(this,
                                     { x:x-1},
                                     null,
                                     0.04,
                                     BeTweenAS3Thread.EASE_IN_SINE),
                    BetweenAS3.tween(this,
                                     { x:x},
                                     null,
                                     0.04,
                                     BeTweenAS3Thread.EASE_IN_SINE),
                    BetweenAS3.func(deleteFlash)
                    );
        }

        // キャラのUpのTweenを作る
        private function initAttackOnTween():void
        {
            if (!_finished)
            {
            _attackOnTween = BetweenAS3.serial
                (
                     BetweenAS3.addChild(_upMC,_originalParent),
                    BetweenAS3.delay(
                     BetweenAS3.tween(_upMC,
                                      { x:_originalX},
                                      { x:_originalX+_scaleX*UP_START_X},
                                      UP_TIME_IN,
                                      BeTweenAS3Thread.EASE_IN_SINE)
                     ,0,4.5),
                    BetweenAS3.tween(_upMC,
                                     { x:_originalX+_scaleX*UP_START_X},
                                     null,
                                     UP_TIME_OUT,
                                     BeTweenAS3Thread.EASE_IN_SINE
                        ),
                     BetweenAS3.removeFromParent(_upMC)

                    );
            }
        }

        public function setStuffedToys(num:int):void
        {
            _dolls_num = num;
            if (_dollMC)
            {
                _dollMC.gotoAndStop(_dolls_num+1);
            }
        }


        // 自分光る
        private function addFlash():void
        {
            filters = [__filter];
        }

        // フィルターを外す
        public function deleteFlash():void
        {
            filters = [];
        }

        public function setStandX(d:int):void
        {
            if (_standMC && _shadowMC)
            {
                _standMC.x = DIS_X_SET[_distType][d-1];
                _shadowMC.x = DIS_X_SET[_distType][d-1];
                if (_dollMC)
                {
                    _dollMC.x = DIS_X_SET[_distType][d-1];
                }
            }
        }

        // ロード待ち
        public function getWaitCompleteThread():Thread
        {
            return new WaitCompleteThread(this);
        }

    }

}

import org.libspark.thread.Thread;
// 距離を変化させるスレッド
class DistanceChageThread extends Thread
{

}

import view.image.BaseLoadImage;
class WaitCompleteThread extends Thread
{
    private var _bli:BaseLoadImage;

    public function WaitCompleteThread(bli:BaseLoadImage)
    {
        _bli = bli;
    }

    protected override function run ():void
    {
        if (_bli.loaded == false)
        {
            _bli.wait();
        }
        next(close);
    }

    private function close():void
    {

    }

}