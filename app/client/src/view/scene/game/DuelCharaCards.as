
package view.scene.game
{
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.events.TweenEvent;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import controller.*;

    import model.Duel;
    import model.Entrant;
    import model.CharaCard;
    import model.events.CharaChangeEvent;
    import model.events.DamageEvent;
    import model.events.BuffEvent;
    import model.events.ChangeCharaCardEvent;
    import model.events.FeatConditionEvent;

    import view.*;
    import view.utils.*;
    import view.scene.BaseScene;
    import view.image.game.*;
    import view.scene.raid.RaidBossBuffList;

    /**
     * DuelCharaCards
     * CharaCardをまとめて管理する
     *
     *
     */

    public class DuelCharaCards  extends BaseScene
    {
        private static const _CHARA_CARD_W:int = 240;
        private static const _CHARA_CARD_X:int = 272;
        private static const _S_FOE_CHARA_CARD_X:int = 404;
        private static const _CHARA_CARD_Y:int = 456;
        private static const _CHARA_CARD_OFFSET_X:int = 56;
        private static const _CHARA_CARD_OFFSET_Y:int = 23;

//         private static const _PLAYER_CHARA_CARD_X:Array = [2, 12, 92];
//         private static const _PLAYER_CHARA_CARD_Y:Array = [459, 351, 351];
//         private static const _FOE_CHARA_CARD_X:Array = [774, 786, 864];
//         private static const _FOE_CHARA_CARD_Y:Array = [4, 255, 255];
//         private static const _CHARA_CARD_SCALE:Array = [1.0, 0.4, 0.4];

        private static const _PLAYER_CHARA_CARD_X:Array = [0, 168, 336];
        private static const _PLAYER_CHARA_CARD_Y:Array = [440, 680, 680];
        private static const _FOE_CHARA_CARD_X:Array = [0, 168, 336];
        private static const _FOE_CHARA_CARD_Y:Array = [-240, -240, -240];

        private static const _CHARA_CARD_SCALE:Array = [1.0, 1.0, 1.0];

        private static const _ENLARGE_PLAYER_CHARA_CARD_X:int = 0;
        private static const _ENLARGE_PLAYER_CHARA_CARD_Y:int = 440;

        private static const _ENLARGE_FOE_CHARA_CARD_X:int = 0;
        private static const _ENLARGE_FOE_CHARA_CARD_Y:int = 0;


        private static const _ENLARGE_CHARA_CARD_SCALE:Number = 1.0;

        private static const _CHARA_CARD_ALPHA:Number = 0.0;

        private static const _ENLARGE_CHARA_CARD_W:int = 171;
        private static const _ENLARGE_CHARA_CARD_H:int = 245;


        private static const _ENLARGE_NONE:int = 0;
        private static const _ENLARGE_PLAYER:int = 1;
        private static const _ENLARGE_FOE:int = 2;
        private static const _ENLARGE_MARGIN:int = 5;

        private static const _STATE_END:int = 0;
        private static const _STATE_NORMAL:int = 1;
        private static const _STATE_CHANGE:int = 2;


//        private var _playerCharaCardClips:Array = [];
//        private var _foeCharaCardClips:Array = [];
        private var _playerCharaCardClips:Vector.<DuelCharaCardClip> = new Vector.<DuelCharaCardClip>();
        private var _foeCharaCardClips:Vector.<DuelCharaCardClip> = new Vector.<DuelCharaCardClip>();

        private var _leftCharaCardClip:DuelCharaCardClip;
        private var _rightCharaCardClip:DuelCharaCardClip;

        private var _enlarged:int = _ENLARGE_NONE;
        private var _enlargeBeforeX:int = -1;
        private var _enlargeBeforeY:int = -1;
        private var _enlargedCard:DuelCharaCardClip;
        private var _enlargedCardsPoints:Dictionary = new Dictionary(); // 大きくしたカードの元位置保存

        private var _charaChangePanel:CharaChangePanel = new CharaChangePanel();

        private var _state:int = _STATE_END;

        protected var _duel:Duel;

        // ゲームのコントローラ

        /**
         * コンストラクタ
         *
         */
        public function DuelCharaCards()
        {
            
        }

        public function charaCardsInitialize():Thread
        {
            _duel = Duel.instance;
            _duel.plEntrant.addEventListener(Entrant.CHANGE_DONE, plCharaCardChangeHandler);
            _duel.foeEntrant.addEventListener(Entrant.CHANGE_DONE, foeCharaCardChangeHandler);
            _duel.plEntrant.addEventListener(Entrant.UPDATE_WEAPON_BONUS, plUpdateWeaponBonusHandler);
            _duel.foeEntrant.addEventListener(Entrant.UPDATE_WEAPON_BONUS, foeUpdateWeaponBonusHandler);
            _duel.addEventListener(Duel.CHARA_CHANGE_PHASE_START, changeStartHandler);
            _duel.addEventListener(Duel.DEAD_CHARA_CHANGE_PHASE_START, changeStartHandler);

            // カードステートの更新
            _duel.plEntrant.addEventListener(DamageEvent.DAMAGE, playerDamageHandler,false,-1);
            _duel.foeEntrant.addEventListener(DamageEvent.DAMAGE, foeDamageHandler,false,-1);
            _duel.plEntrant.addEventListener(DamageEvent.HEAL, playerHealHandler);
            _duel.foeEntrant.addEventListener(DamageEvent.HEAL, foeHealHandler);
            _duel.plEntrant.addEventListener(DamageEvent.CHANGE, playerHPChangeHandler);
            _duel.foeEntrant.addEventListener(DamageEvent.CHANGE, foeHPChangeHandler);
            _duel.plEntrant.addEventListener(DamageEvent.REVIVE, playerReviveHandler);
            _duel.foeEntrant.addEventListener(DamageEvent.REVIVE, foeReviveHandler);
            _duel.plEntrant.addEventListener(DamageEvent.PARTY_HEAL, playerPartyHealHandler);
            _duel.foeEntrant.addEventListener(DamageEvent.PARTY_HEAL, foePartyHealHandler);
            _duel.plEntrant.addEventListener(DamageEvent.PARTY_DAMAGE, playerPartyDamageHandler);
            _duel.foeEntrant.addEventListener(DamageEvent.PARTY_DAMAGE, foePartyDamageHandler);
            _duel.addEventListener(FeatConditionEvent.PLAYER_UPDATE, playerFeatConditionUpdate);
            _duel.addEventListener(FeatConditionEvent.FOE_UPDATE, foeFeatConditionUpdate);

            // Buffの更新
            _duel.addEventListener(BuffEvent.PLAYER, playerBuffHandler);
            _duel.addEventListener(BuffEvent.FOE, foeBuffHandler);
            _duel.addEventListener(BuffEvent.PLAYER_OFF, playerBuffOffHandler);
            _duel.addEventListener(BuffEvent.FOE_OFF, foeBuffOffHandler);
            _duel.addEventListener(BuffEvent.PLAYER_OFF_ALL, playerBuffOffAllHandler);
            _duel.addEventListener(BuffEvent.FOE_OFF_ALL, foeBuffOffAllHandler);
            _duel.addEventListener(BuffEvent.PLAYER_UPDATE, playerBuffUpdateHandler);
            _duel.addEventListener(BuffEvent.FOE_UPDATE, foeBuffUpdateHandler);
            _duel.addEventListener(BuffEvent.PLAYER_IDX, playerCharaBuffHandler);
            _duel.addEventListener(BuffEvent.FOE_IDX, foeCharaBuffHandler);
            _duel.addEventListener(BuffEvent.BOSS, bossBuffHandler);

            // キャラカード差し替え
            _duel.addEventListener(ChangeCharaCardEvent.PLAYER, playerChangeCharaCardHandler);
            _duel.addEventListener(ChangeCharaCardEvent.FOE, foeChangeCharaCardHandler);

            // パネル
            _charaChangePanel.alpha = 0.0;
            _charaChangePanel.visible = false;
            addChild(_charaChangePanel);

            _playerCharaCardClips = new Vector.<DuelCharaCardClip>();;
            _foeCharaCardClips = new Vector.<DuelCharaCardClip>();;
            _duel.foeEntrant.bossBuffLists = new Vector.<RaidBossBuffList>();

//            log.writeLog(log.LV_INFO, this, "initialize cc", _duel.playerCharaCards.length,  _duel.foeCharaCards.length);

            var hpUpdatePExec:ParallelExecutor = new ParallelExecutor();
            // 1vs1なら1枚だけ作る
            if(_duel.rule == Duel.RULE_3VS3)
            {
                _duel.playerCharaCards.forEach(
                    function(item:*, index:int, array:Array):void
                    {
                        _playerCharaCardClips.push(new DuelCharaCardClip(item));
                        _playerCharaCardClips[index].x = _CHARA_CARD_X - _CHARA_CARD_OFFSET_X * index;
                        _playerCharaCardClips[index].y = -300;
                        if (_duel.plDameges !=null && _duel.plDameges[index]!=null)
                        {
                            hpUpdatePExec.addThread(new ClousureThread(updatePlayerHP,[index]));
                        }
//                         Unlight.GCW.watch(_playerCharaCardClips[index]);
                    });
                _duel.foeCharaCards.forEach(
                    function(item:*, index:int, array:Array):void
                    {
                        _foeCharaCardClips.push(new DuelCharaCardClip(item,true,_duel.raidBoss));
                        _foeCharaCardClips[index].x = _S_FOE_CHARA_CARD_X + _CHARA_CARD_OFFSET_X * index;
                        _foeCharaCardClips[index].y = -300;
                        if (_duel.foeDameges !=null && _duel.foeDameges[index]!=null){
                            hpUpdatePExec.addThread(new ClousureThread(updateFoeHP,[index]));
                        }
                        if (_duel.raidBoss) {
                            _duel.foeEntrant.bossBuffLists.push(new RaidBossBuffList());
                            _duel.foeEntrant.bossBuffLists[index].addEventListener(BuffEvent.BOSS_BUFF_DELETE,bossBuffOffHandler);
                        }
//                         Unlight.GCW.watch(_foeCharaCardClips[index]);
                    });
            }
            else
            {
                _playerCharaCardClips.push(new DuelCharaCardClip(_duel.playerCharaCards[0]));
                _playerCharaCardClips[0].x = _CHARA_CARD_X;
                _playerCharaCardClips[0].y = -300;
//                log.writeLog(log.LV_FATAL, this, "DAMAGE UPDATE",_duel.plDameges);
                if (_duel.plDameges !=null && _duel.plDameges[0]!=null){
                    hpUpdatePExec.addThread(new ClousureThread(updatePlayerHP,[0]))
                }
                _foeCharaCardClips.push(new DuelCharaCardClip(_duel.foeCharaCards[0],true,_duel.raidBoss));
                _foeCharaCardClips[0].x = _S_FOE_CHARA_CARD_X;
                _foeCharaCardClips[0].y = -300;
                if (_duel.foeDameges !=null && _duel.foeDameges[0]!=null){
                    hpUpdatePExec.addThread(new ClousureThread(updateFoeHP,[0]));
                }
                if (_duel.raidBoss) {
                    _duel.foeEntrant.bossBuffLists.push(new RaidBossBuffList());
                    _duel.foeEntrant.bossBuffLists[0].addEventListener(BuffEvent.BOSS_BUFF_DELETE,bossBuffOffHandler);
                }


//                 Unlight.GCW.watch(_playerCharaCardClips[0]);
//                 Unlight.GCW.watch(_foeCharaCardClips[0]);
            }


            var sExec:SerialExecutor = new SerialExecutor();
            var plThread:ParallelExecutor = new ParallelExecutor();
            for(var i:int = _playerCharaCardClips.length-1; i >= 0; i--)
            {
                plThread.addThread(_playerCharaCardClips[i].getShowThread(this));
            }
            for(i = _foeCharaCardClips.length-1; i >= 0; i--)
            {
                plThread.addThread(_foeCharaCardClips[i].getShowThread(this));
            }

            sExec.addThread(plThread);
            sExec.addThread(hpUpdatePExec)


            log.writeLog(log.LV_DEBUG, this,"charaCardInitialize");
            _state = _STATE_NORMAL;
            return sExec;
        }

        public function updateDuelCharaCardsThread():Thread
        {
            var ccc:DuelCharaCardClip;

            if (_playerCharaCardClips != null)
            {
                while(_playerCharaCardClips.length > 0)
                {
                    ccc = _playerCharaCardClips.pop();
                    ccc.removeEventListener(MouseEvent.ROLL_OVER, playerCardMouseOverHandler);
                    ccc.removeTab();
                }
            }

            if(_foeCharaCardClips!=null)
            {
                while(_foeCharaCardClips.length > 0)
                {
                    ccc = _foeCharaCardClips.pop();
                    ccc.removeEventListener(MouseEvent.ROLL_OVER, foeCardMouseOverHandler);
                    ccc.removeTab();
                }
            }

            if(_duel.foeEntrant.bossBuffLists!=null)
            {
                while(_duel.foeEntrant.bossBuffLists.length > 0)
                {
                    var buffList:RaidBossBuffList = _duel.foeEntrant.bossBuffLists.pop();
                    buffList.removeEventListener(BuffEvent.BOSS_BUFF_DELETE,bossBuffOffHandler);
                    buffList = null;
                }
            }
            _leftCharaCardClip = null;
            _rightCharaCardClip = null;
            _enlargedCard = null;

            _playerCharaCardClips = new Vector.<DuelCharaCardClip>();;
            _foeCharaCardClips = new Vector.<DuelCharaCardClip>();;
            _duel.foeEntrant.bossBuffLists = new Vector.<RaidBossBuffList>();

            var hpUpdatePExec:ParallelExecutor = new ParallelExecutor();
            // 1vs1なら1枚だけ作る
            if(_duel.rule == Duel.RULE_3VS3)
            {
                _duel.playerCharaCards.forEach(
                    function(item:*, index:int, array:Array):void
                    {
                        _playerCharaCardClips.push(new DuelCharaCardClip(item));
                        _playerCharaCardClips[index].x = _CHARA_CARD_X - _CHARA_CARD_OFFSET_X * index;
                        _playerCharaCardClips[index].y = -300;
                        if (_duel.plDameges !=null && _duel.plDameges[index]!=null)
                        {
                            hpUpdatePExec.addThread(new ClousureThread(updatePlayerHP,[index]));
                        }
//                         Unlight.GCW.watch(_playerCharaCardClips[index]);
                    });
                _duel.foeCharaCards.forEach(
                    function(item:*, index:int, array:Array):void
                    {
                        _foeCharaCardClips.push(new DuelCharaCardClip(item,true,_duel.raidBoss));
                        _foeCharaCardClips[index].x = _S_FOE_CHARA_CARD_X + _CHARA_CARD_OFFSET_X * index;
                        _foeCharaCardClips[index].y = -300;
                        if (_duel.foeDameges !=null && _duel.foeDameges[index]!=null){
                            hpUpdatePExec.addThread(new ClousureThread(updateFoeHP,[index]));
                        }
                        if (_duel.raidBoss) {
                            _duel.foeEntrant.bossBuffLists.push(new RaidBossBuffList());
                            _duel.foeEntrant.bossBuffLists[index].addEventListener(BuffEvent.BOSS_BUFF_DELETE,bossBuffOffHandler);
                        }
//                         Unlight.GCW.watch(_foeCharaCardClips[index]);
                    });
            }
            else
            {
                _playerCharaCardClips.push(new DuelCharaCardClip(_duel.playerCharaCards[0]));
                _playerCharaCardClips[0].x = _CHARA_CARD_X;
                _playerCharaCardClips[0].y = -300;
//                log.writeLog(log.LV_FATAL, this, "DAMAGE UPDATE",_duel.plDameges);
                if (_duel.plDameges !=null && _duel.plDameges[0]!=null){
                    hpUpdatePExec.addThread(new ClousureThread(updatePlayerHP,[0]))
                }
                _foeCharaCardClips.push(new DuelCharaCardClip(_duel.foeCharaCards[0],true,_duel.raidBoss));
                _foeCharaCardClips[0].x = _S_FOE_CHARA_CARD_X;
                _foeCharaCardClips[0].y = -300;
                if (_duel.foeDameges !=null && _duel.foeDameges[0]!=null){
                    hpUpdatePExec.addThread(new ClousureThread(updateFoeHP,[0]));
                }
                if (_duel.raidBoss) {
                    _duel.foeEntrant.bossBuffLists.push(new RaidBossBuffList());
                    _duel.foeEntrant.bossBuffLists[0].addEventListener(BuffEvent.BOSS_BUFF_DELETE,bossBuffOffHandler);
                }


//                 Unlight.GCW.watch(_playerCharaCardClips[0]);
//                 Unlight.GCW.watch(_foeCharaCardClips[0]);
            }


            var sExec:SerialExecutor = new SerialExecutor();
            var plThread:ParallelExecutor = new ParallelExecutor();
            for(var i:int = _playerCharaCardClips.length-1; i >= 0; i--)
            {
                plThread.addThread(_playerCharaCardClips[i].getShowThread(this));
            }
            for(i = _foeCharaCardClips.length-1; i >= 0; i--)
            {
                plThread.addThread(_foeCharaCardClips[i].getShowThread(this));
            }

            sExec.addThread(plThread);
            sExec.addThread(hpUpdatePExec)


            log.writeLog(log.LV_DEBUG, this,"charaCardInitialize");
            _state = _STATE_NORMAL;
            return sExec;
        }


        private function updatePlayerHP(index:int):void
        {
            _playerCharaCardClips[index].hp = _playerCharaCardClips[index].hp - _duel.plDameges[index];
        }

        private function updateFoeHP(index:int):void
        {
            _foeCharaCardClips[index].hp = _foeCharaCardClips[index].hp - _duel.foeDameges[index];
        }

        private function playerFeatConditionUpdate(e:FeatConditionEvent):void
        {
            _playerCharaCardClips[e.chara_index].feats[e.feat_index].setConditionCaption(e.condition.split(":")[1]);
            _playerCharaCardClips[e.chara_index].updateFeatCondition(e.feat_index, e.condition);
        }

        private function foeFeatConditionUpdate(e:FeatConditionEvent):void
        {
            _foeCharaCardClips[e.chara_index].feats[e.feat_index].setConditionCaption(e.condition.split(":")[1]);
            _foeCharaCardClips[e.chara_index].updateFeatCondition(e.feat_index, e.condition);
        }


        public override function final():void
        {
            _duel.plEntrant.removeEventListener(Entrant.CHANGE_DONE, plCharaCardChangeHandler);
            _duel.foeEntrant.removeEventListener(Entrant.CHANGE_DONE, foeCharaCardChangeHandler);
            _duel.plEntrant.removeEventListener(Entrant.UPDATE_WEAPON_BONUS, plUpdateWeaponBonusHandler);
            _duel.foeEntrant.removeEventListener(Entrant.UPDATE_WEAPON_BONUS, foeUpdateWeaponBonusHandler);
            _duel.removeEventListener(Duel.CHARA_CHANGE_PHASE_START, changeStartHandler);
            _duel.removeEventListener(Duel.DEAD_CHARA_CHANGE_PHASE_START, changeStartHandler);

            // カードステートの更新
            _duel.plEntrant.removeEventListener(DamageEvent.DAMAGE, playerDamageHandler);
            _duel.foeEntrant.removeEventListener(DamageEvent.DAMAGE, foeDamageHandler);
            _duel.plEntrant.removeEventListener(DamageEvent.HEAL, playerHealHandler);
            _duel.foeEntrant.removeEventListener(DamageEvent.HEAL, foeHealHandler);
            _duel.plEntrant.removeEventListener(DamageEvent.CHANGE, playerHPChangeHandler);
            _duel.foeEntrant.removeEventListener(DamageEvent.CHANGE, foeHPChangeHandler);
            _duel.plEntrant.removeEventListener(DamageEvent.REVIVE, playerReviveHandler);
            _duel.foeEntrant.removeEventListener(DamageEvent.REVIVE, foeReviveHandler);
            _duel.plEntrant.removeEventListener(DamageEvent.PARTY_HEAL, playerPartyHealHandler);
            _duel.foeEntrant.removeEventListener(DamageEvent.PARTY_HEAL, foePartyHealHandler);
            _duel.plEntrant.removeEventListener(DamageEvent.PARTY_DAMAGE, playerPartyDamageHandler);
            _duel.foeEntrant.removeEventListener(DamageEvent.PARTY_DAMAGE, foePartyDamageHandler);
            _duel.removeEventListener(FeatConditionEvent.PLAYER_UPDATE, playerFeatConditionUpdate);
            _duel.removeEventListener(FeatConditionEvent.FOE_UPDATE, foeFeatConditionUpdate);

            // Buffの更新
            _duel.removeEventListener(BuffEvent.PLAYER, playerBuffHandler);
            _duel.removeEventListener(BuffEvent.FOE, foeBuffHandler);
            _duel.removeEventListener(BuffEvent.PLAYER_OFF, playerBuffOffHandler);
            _duel.removeEventListener(BuffEvent.FOE_OFF, foeBuffOffHandler);
            _duel.removeEventListener(BuffEvent.PLAYER_OFF_ALL, playerBuffOffAllHandler);
            _duel.removeEventListener(BuffEvent.FOE_OFF_ALL, foeBuffOffAllHandler);
            _duel.removeEventListener(BuffEvent.PLAYER_UPDATE, playerBuffUpdateHandler);
            _duel.removeEventListener(BuffEvent.FOE_UPDATE, foeBuffUpdateHandler);
            _duel.removeEventListener(BuffEvent.PLAYER_IDX, playerCharaBuffHandler);
            _duel.removeEventListener(BuffEvent.FOE_IDX, foeCharaBuffHandler);
            _duel.removeEventListener(BuffEvent.BOSS, bossBuffHandler);

            // キャラカード差し替え
            _duel.removeEventListener(ChangeCharaCardEvent.PLAYER, playerChangeCharaCardHandler);
            _duel.removeEventListener(ChangeCharaCardEvent.FOE, foeChangeCharaCardHandler);

            _charaChangePanel.leftButton.removeEventListener(MouseEvent.CLICK, leftClickCharaChangeHandler);
            _charaChangePanel.rightButton.removeEventListener(MouseEvent.CLICK, rightClickCharaChangeHandler);
            _charaChangePanel.closeButton.removeEventListener(MouseEvent.CLICK, closeClickCharaChangeHandler);




            _state = _STATE_END;
//            log.writeLog(log.LV_FATAL, this, "DuelCards final start");

            var ccc:DuelCharaCardClip;

            if (_playerCharaCardClips != null)
            {
                while(_playerCharaCardClips.length > 0)
                {
                    ccc = _playerCharaCardClips.pop();
                    ccc.removeEventListener(MouseEvent.ROLL_OVER, playerCardMouseOverHandler);
                    ccc.removeTab();
                }
            }

            if(_foeCharaCardClips!=null)
            {
                while(_foeCharaCardClips.length > 0)
                {
                    ccc = _foeCharaCardClips.pop();
                    ccc.removeEventListener(MouseEvent.ROLL_OVER, foeCardMouseOverHandler);
                    ccc.removeTab();
                }
            }

            if(_duel.foeEntrant.bossBuffLists!=null)
            {
                while(_duel.foeEntrant.bossBuffLists.length > 0)
                {
                    var buffList:RaidBossBuffList = _duel.foeEntrant.bossBuffLists.pop();
                    buffList.removeEventListener(BuffEvent.BOSS_BUFF_DELETE,bossBuffOffHandler);
                    buffList = null;
                }
            }


            _duel.plEntrant.removeEventListener(Entrant.CHANGE_DONE, plCharaCardChangeHandler);
            _duel.foeEntrant.removeEventListener(Entrant.CHANGE_DONE, foeCharaCardChangeHandler);

            _charaChangePanel.leftButton.removeEventListener(MouseEvent.CLICK, leftClickCharaChangeHandler);
            _charaChangePanel.rightButton.removeEventListener(MouseEvent.CLICK, rightClickCharaChangeHandler);
            _charaChangePanel.closeButton.removeEventListener(MouseEvent.CLICK, closeClickCharaChangeHandler);

            RemoveChild.apply(_charaChangePanel);

            _playerCharaCardClips = null;
            _foeCharaCardClips = null;

            _leftCharaCardClip = null;
            _rightCharaCardClip = null;

            _enlargedCard = null;
//            log.writeLog(log.LV_FATAL, this, "DuelCards final end");

            _duel.foeEntrant.bossBuffLists = null;
        }


        // プレイヤー側の状態付加イベント
        private function playerBuffHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END){return}
            var currentIndex:int = _duel.plEntrant.currentCharaCardIndex;
            _playerCharaCardClips[currentIndex].addBuffStatus(e.id, e.value, e.turn);
            _duel.setPlayerBuffClips(currentIndex, _playerCharaCardClips[currentIndex]);
        }

        // 対戦相手側の状態付加イベント
        private function foeBuffHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END){return}
            var currentIndex:int = _duel.foeEntrant.currentCharaCardIndex;
            _foeCharaCardClips[currentIndex].addBuffStatus(e.id, e.value, e.turn);
            _duel.setFoeBuffClips(currentIndex, _foeCharaCardClips[currentIndex]);
        }

        // ボスの状態付加イベント
        private function bossBuffHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END&&_duel.raidBoss){return}
            var currentIndex:int = _duel.foeEntrant.currentCharaCardIndex;
            _duel.foeEntrant.bossBuffLists[currentIndex].addBuff(e.id, e.value, e.turn, e.limit);
            bossBuffClipUpdate(_duel.foeEntrant.bossBuffLists[currentIndex]);
        }
        private function bossBuffClipUpdate(buffList:RaidBossBuffList):void
        {
            var currentIndex:int = _duel.foeEntrant.currentCharaCardIndex;
            var buffs:Array = buffList.getBuffList();
            if (buffs.length > 0) {
                for ( var i:int=0; i<buffs.length; i++) {
                    _foeCharaCardClips[currentIndex].addBossBuffStatus(buffs[i].buffId, buffs[i].value, buffs[i].turn, buffs[i].limitAt);
                }
            }
        }

        // プレイヤー側の状態解除イベント
        private function playerBuffOffHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END){return}
            // var currentIndex:int = _duel.plEntrant.currentCharaCardIndex;
            _playerCharaCardClips[e.index].removeBuffStatus(e.id, e.value);
            _duel.setPlayerBuffClips(e.index, _playerCharaCardClips[e.index]);
        }

        // 対戦相手側の状態解除イベント
        private function foeBuffOffHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END){return}
            // var currentIndex:int = _duel.foeEntrant.currentCharaCardIndex;
            _foeCharaCardClips[e.index].removeBuffStatus(e.id, e.value);
            if (_duel.foeEntrant.bossBuffLists && _duel.foeEntrant.bossBuffLists.length > 0)
            {
                _duel.foeEntrant.bossBuffLists[_duel.foeEntrant.currentCharaCardIndex].delBuff(e.id, e.value);
            }
            else
            {
                _duel.setFoeBuffClips(e.index, _foeCharaCardClips[e.index]);
            }
        }

        // ボスの状態解除イベント
        private function bossBuffOffHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END&&_duel.raidBoss){return}
            var currentIndex:int = _duel.foeEntrant.currentCharaCardIndex;
            _foeCharaCardClips[currentIndex].removeBuffStatus(e.id, e.value);
        }

        // プレイヤー側の全状態解除イベント
        private function playerBuffOffAllHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END){return}
            var currentIndex:int = _duel.plEntrant.currentCharaCardIndex;
            _playerCharaCardClips[currentIndex].removeBuffStatusAll();
            _duel.setPlayerBuffClips(currentIndex, _playerCharaCardClips[currentIndex]);
        }

        // 対戦相手側の全状態解除イベント
        private function foeBuffOffAllHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END){return}
            var currentIndex:int = _duel.foeEntrant.currentCharaCardIndex;
            _foeCharaCardClips[currentIndex].removeBuffStatusAll();
            if (_duel.foeEntrant.bossBuffLists && _duel.foeEntrant.bossBuffLists.length > 0)
            {
                _duel.foeEntrant.bossBuffLists[currentIndex].allDelBuff();
            }
            else
            {
                _duel.setFoeBuffClips(currentIndex, _foeCharaCardClips[currentIndex]);
            }
        }

        // プレイヤーの状態異常更新
        private function playerBuffUpdateHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END){return}
            var plTargetIndex:int = e.index;
            log.writeLog(log.LV_DEBUG,this,"e.value");
            _playerCharaCardClips[plTargetIndex].updateBuffStatus(e.id, e.value, e.turn);
            _duel.setPlayerBuffClips(plTargetIndex, _playerCharaCardClips[plTargetIndex]);
        }

        // 対戦相手側の状態異常更新
        private function foeBuffUpdateHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END){return}
            var foeTargetIndex:int = e.index;
            _foeCharaCardClips[foeTargetIndex].updateBuffStatus(e.id, e.value, e.turn);
            _duel.setFoeBuffClips(foeTargetIndex, _foeCharaCardClips[foeTargetIndex]);
        }

        // プレイヤー側のキャラ指定状態付加イベント
        private function playerCharaBuffHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END){return}
            _playerCharaCardClips[e.index].addBuffStatus(e.id, e.value, e.turn);
            _duel.setPlayerBuffClips(e.index, _playerCharaCardClips[e.index]);
        }

        // 対戦相手側の状態付加イベント
        private function foeCharaBuffHandler(e:BuffEvent):void
        {
            if (_state == _STATE_END){return}
            _foeCharaCardClips[e.index].addBuffStatus(e.id, e.value, e.turn);
            _duel.setFoeBuffClips(e.index, _foeCharaCardClips[e.index]);
        }

        // キャラカード選択イベント
        private function leftClickCharaChangeHandler(e:MouseEvent):void
        {
            _duel.plEntrant.charaChange(_playerCharaCardClips.indexOf(_leftCharaCardClip));
        }
        private function rightClickCharaChangeHandler(e:MouseEvent):void
        {
            _duel.plEntrant.charaChange(_playerCharaCardClips.indexOf(_rightCharaCardClip));
        }
        private function closeClickCharaChangeHandler(e:MouseEvent):void
        {            if (_state == _STATE_END){return}
            _duel.plEntrant.charaChange(_playerCharaCardClips.indexOf(_playerCharaCardClips[_duel.plEntrant.currentCharaCardIndex]));
        }

        // キャラ選択をスタートするハンドラ
        private function changeStartHandler(e:Event):void
        {
            if (_state == _STATE_END){return}

            _state = _STATE_CHANGE;
            var pExec:ParallelExecutor = new ParallelExecutor();
//            log.writeLog(log.LV_FATAL, this, "change start handler",_duel.plEntrant.getChangeDone() );

            // キャラ選択可能か？
            if(!_duel.plEntrant.getChangeDone())
            {
                // パネルを表示
                GameCtrl.instance.addNoWaitViewSequence(new BeTweenAS3Thread(_charaChangePanel, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0, true));

                // 3vs3なら残りのカードもあわせて表示
                if(_duel.rule == Duel.RULE_3VS3)
                {
                    var currentIndex:int = _duel.plEntrant.currentCharaCardIndex;
                    // マウスオーバで拡大しているものがあれば取り除く
                    restoreCard();

                    for(var i:int = 0; i < _playerCharaCardClips.length; i++)
                    {
                        var leftClip:Boolean = true;
                        _playerCharaCardClips[i].removeEventListener(MouseEvent.ROLL_OVER, playerCardMouseOverHandler);
                        _playerCharaCardClips[i].removeTab();

                        if(i == currentIndex)
                        {
                            if(_duel.plEntrant.hitPoint)
                            {
                                pExec.addThread(new BeTweenAS3Thread(_playerCharaCardClips[i], {x:_PLAYER_CHARA_CARD_X[0] ,y:_PLAYER_CHARA_CARD_Y[0] ,scaleX:_CHARA_CARD_SCALE[0] ,scaleY:_CHARA_CARD_SCALE[0],alpha:1}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                            }
                            else
                            {
                                pExec.addThread(new BeTweenAS3Thread(_playerCharaCardClips[i], {x:_PLAYER_CHARA_CARD_X[0] ,y:_PLAYER_CHARA_CARD_Y[0] ,scaleX:_CHARA_CARD_SCALE[0] ,alpha:1 ,scaleY:_CHARA_CARD_SCALE[0]}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                                pExec.addThread(new ClousureThread(_playerCharaCardClips[i].dead));

                            }
                        }
                        else if(i > currentIndex)
                        {
                            i == 1 ? leftClip = true : leftClip = false;
                            if (leftClip) {
                                pExec.addThread(new BeTweenAS3Thread(_playerCharaCardClips[i], {x:16+i*184 ,y:144 ,scaleX:_CHARA_CARD_SCALE[0] ,scaleY:_CHARA_CARD_SCALE[0],alpha:1}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ));
                                _leftCharaCardClip = _playerCharaCardClips[i];
                            } else {
                                pExec.addThread(new BeTweenAS3Thread(_playerCharaCardClips[i], {x:24+i*184 ,y:144 ,scaleX:_CHARA_CARD_SCALE[0] ,scaleY:_CHARA_CARD_SCALE[0],alpha:1}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ));
                                _rightCharaCardClip = _playerCharaCardClips[i];
                            }
                        }
                        else if(i < currentIndex)
                        {
                            i == 0 ? leftClip = true : leftClip = false;
                            if (leftClip) {
                                pExec.addThread(new BeTweenAS3Thread(_playerCharaCardClips[i], {x:16+(i+1)*184 ,y:144 ,scaleX:_CHARA_CARD_SCALE[0] ,scaleY:_CHARA_CARD_SCALE[0],alpha:1}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                                _leftCharaCardClip = _playerCharaCardClips[i];
                            } else {
                                pExec.addThread(new BeTweenAS3Thread(_playerCharaCardClips[i], {x:24+(i+1)*184 ,y:144 ,scaleX:_CHARA_CARD_SCALE[0] ,scaleY:_CHARA_CARD_SCALE[0],alpha:1}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                                _rightCharaCardClip = _playerCharaCardClips[i];
                            }
                        }
                        // マウスオーバはすべてはずす

                    }

                    if(_playerCharaCardClips.length >= 2)
                    {
                        _charaChangePanel.leftButton.visible = true;
                        _charaChangePanel.leftButton.addEventListener(MouseEvent.CLICK, leftClickCharaChangeHandler);
                        if(_playerCharaCardClips.length == 3)
                        {
                            _charaChangePanel.rightButton.visible = true;
                            _charaChangePanel.rightButton.addEventListener(MouseEvent.CLICK, rightClickCharaChangeHandler);
                        }
                        else
                        {
                            _charaChangePanel.rightButton.visible = false;
                        }
                    }
                    else
                    {
                        _charaChangePanel.leftButton.visible = false;
                    }
                    _charaChangePanel.closeButton.addEventListener(MouseEvent.CLICK, closeClickCharaChangeHandler);
                }
                GameCtrl.instance.addViewSequence(pExec);
            }
            // 相手側の死んだカードを判定
            if((!_duel.foeEntrant.getChangeDone()) && _duel.foeEntrant.hitPoint <= 0)
            {
                GameCtrl.instance.addViewSequence(new ClousureThread(_foeCharaCardClips[_duel.foeEntrant.currentCharaCardIndex].dead));
            }
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{_state = _STATE_NORMAL}));
        }

        // プレイヤーキャラが変更されたときのハンドラ
        private function plCharaCardChangeHandler(e:Event):void
        {
            if (_state == _STATE_END){return}
            var sExec:ParallelExecutor = new ParallelExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var currentIndex:int = _duel.plEntrant.currentCharaCardIndex;
            var currentBonus:Array = _duel.plEntrant.currentWeaponBonus;
            sExec.addThread(pExec);

            showUnknownCard(true);

            for(var i:int = 0; i < _playerCharaCardClips.length; i++)
            {
                if(i > currentIndex)
                {
                    pExec.addThread(new BeTweenAS3Thread(_playerCharaCardClips[i], {x:_PLAYER_CHARA_CARD_X[i] ,y:_PLAYER_CHARA_CARD_Y[i] ,scaleX:_CHARA_CARD_SCALE[i] ,scaleY:_CHARA_CARD_SCALE[i], alpha:_CHARA_CARD_ALPHA}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                    _enlargedCardsPoints[_playerCharaCardClips[i]] = [_PLAYER_CHARA_CARD_X[i], _PLAYER_CHARA_CARD_Y[i]];
                    // マウスオーバのつけなおし
                    sExec.addThread(new ClousureThread(regitCharaCardHandler, [_playerCharaCardClips[i], playerCardMouseOverHandler]));
                    sExec.addThread(new ClousureThread(_playerCharaCardClips[i].setTab,[i-1]));

                }
                else if(i < currentIndex)
                {
                    pExec.addThread(new BeTweenAS3Thread(_playerCharaCardClips[i], {x:_PLAYER_CHARA_CARD_X[i+1] ,y:_PLAYER_CHARA_CARD_Y[i+1] ,scaleX:_CHARA_CARD_SCALE[i+1] ,scaleY:_CHARA_CARD_SCALE[i+1],alpha:_CHARA_CARD_ALPHA}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                    _enlargedCardsPoints[_playerCharaCardClips[i]] = [_PLAYER_CHARA_CARD_X[i+1], _PLAYER_CHARA_CARD_Y[i+1]];
                    // マウスオーバのつけなおし
                    sExec.addThread(new ClousureThread(regitCharaCardHandler, [_playerCharaCardClips[i], playerCardMouseOverHandler]));
                    sExec.addThread(new ClousureThread(_playerCharaCardClips[i].setTab,[i]));
                }
                else if(i == currentIndex)
                {
                    pExec.addThread(new BeTweenAS3Thread(_playerCharaCardClips[i], {x:_PLAYER_CHARA_CARD_X[0] ,y:_PLAYER_CHARA_CARD_Y[0] ,scaleX:_CHARA_CARD_SCALE[0] ,scaleY:_CHARA_CARD_SCALE[0]}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                    pExec.addThread(new ClousureThread(_playerCharaCardClips[i].removeTab));

                    if (_playerCharaCardClips[i].parent != null) {
                        setChildIndex(_playerCharaCardClips[i], numChildren-1 );

                        // 装備カードの補正
                        _playerCharaCardClips[currentIndex].setAttackBonus(currentBonus[0], currentBonus[1], currentBonus[4], currentBonus[5]);
                        _playerCharaCardClips[currentIndex].setDeffenceBonus(currentBonus[2], currentBonus[3], currentBonus[6], currentBonus[7]);
                    }
                }
//                 // クリックイベントの削除
//                 _playerCharaCardClips[i].removeEventListener(MouseEvent.CLICK, clickCharaChangeHandler);
            }

            _charaChangePanel.leftButton.removeEventListener(MouseEvent.CLICK, leftClickCharaChangeHandler);
            _charaChangePanel.rightButton.removeEventListener(MouseEvent.CLICK, rightClickCharaChangeHandler);
            _charaChangePanel.closeButton.removeEventListener(MouseEvent.CLICK, closeClickCharaChangeHandler);

            // パネルを消す
            GameCtrl.instance.addNoWaitViewSequence(new BeTweenAS3Thread(_charaChangePanel, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0, false));
            GameCtrl.instance.addNoWaitViewSequence(sExec);
        }

        private function regitCharaCardHandler(ccc:DuelCharaCardClip,func:Function):void
        {
            ccc.addEventListener(MouseEvent.ROLL_OVER,func)
        }


        // 相手キャラが変更されたときのハンドラ
        private function foeCharaCardChangeHandler(e:Event):void
        {
            if (_state == _STATE_END){return}
            var sExec:ParallelExecutor = new ParallelExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var currentIndex:int = _duel.foeEntrant.currentCharaCardIndex;
            var currentBonus:Array = _duel.foeEntrant.currentWeaponBonus;
            sExec.addThread(pExec);

            showUnknownCard();

            for(var i:int = i; i < _foeCharaCardClips.length; i++)
            {
                if(i > currentIndex)
                {
                    pExec.addThread(new BeTweenAS3Thread(_foeCharaCardClips[i], {x:_FOE_CHARA_CARD_X[i] ,y:_FOE_CHARA_CARD_Y[i] ,scaleX:_CHARA_CARD_SCALE[i] ,scaleY:_CHARA_CARD_SCALE[i]}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                    _enlargedCardsPoints[_foeCharaCardClips[i]] = [_FOE_CHARA_CARD_X[i], _FOE_CHARA_CARD_Y[i]];
                    // マウスオーバのつけなおし
                    sExec.addThread(new ClousureThread(regitCharaCardHandler, [_foeCharaCardClips[i], foeCardMouseOverHandler]));
                    sExec.addThread(new ClousureThread(_foeCharaCardClips[i].setTab,[i-1]));
                }
                else if(i < currentIndex)
                {
                    pExec.addThread(new BeTweenAS3Thread(_foeCharaCardClips[i], {x:_FOE_CHARA_CARD_X[i+1] ,y:_FOE_CHARA_CARD_Y[i+1] ,scaleX:_CHARA_CARD_SCALE[i+1] ,scaleY:_CHARA_CARD_SCALE[i+1]}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                    _enlargedCardsPoints[_foeCharaCardClips[i]] = [_FOE_CHARA_CARD_X[i+1], _FOE_CHARA_CARD_Y[i+1]];
                    // マウスオーバのつけなおし
                    sExec.addThread(new ClousureThread(regitCharaCardHandler, [_foeCharaCardClips[i], foeCardMouseOverHandler]));
                    sExec.addThread(new ClousureThread(_foeCharaCardClips[i].setTab,[i]));
                }
                else if(i == currentIndex)
                {
                    pExec.addThread(new BeTweenAS3Thread(_foeCharaCardClips[i], {x:_FOE_CHARA_CARD_X[0] ,y:_FOE_CHARA_CARD_Y[0] ,scaleX:_CHARA_CARD_SCALE[0] ,scaleY:_CHARA_CARD_SCALE[0]}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                    _enlargedCardsPoints[_foeCharaCardClips[i]] = [_FOE_CHARA_CARD_X[0], _FOE_CHARA_CARD_Y[0]];
                    // マウスオーバのつけなおし
                    sExec.addThread(new ClousureThread(regitCharaCardHandler, [_foeCharaCardClips[i], foeCardMouseOverHandler]));
                    sExec.addThread(new ClousureThread(_foeCharaCardClips[i].setTab,[i]));
//                     _foeCharaCardClips[i].removeEventListener(MouseEvent.ROLL_OVER, foeCardMouseOverHandler);
//                     pExec.addThread(new ClousureThread(_foeCharaCardClips[i].removeTab));
//                    log.writeLog(log.LV_FATAL, this, "ayaziiiii",_foeCharaCardClips[i].parent,i);
                    if (_foeCharaCardClips[i].parent != null)
                    {
                        setChildIndex(_foeCharaCardClips[i], numChildren-1 );
                        // 装備カードの補正
                        _foeCharaCardClips[currentIndex].setAttackBonus(currentBonus[0], currentBonus[1], currentBonus[4], currentBonus[5]);
                        _foeCharaCardClips[currentIndex].setDeffenceBonus(currentBonus[2], currentBonus[3], currentBonus[6], currentBonus[7]);
                    }
                }
            }
            GameCtrl.instance.addNoWaitViewSequence(sExec);
        }

        // 武器情報が更新されたときのハンドラ
        private function plUpdateWeaponBonusHandler(e:Event):void
        {
            var plBonus:Array = _duel.plEntrant.weaponBonuses;
            var currentBonus:Array;

            for(var i:int = 0; i < _playerCharaCardClips.length; i++)
            {
                currentBonus = plBonus[i];
                // 装備カードの補正
                _playerCharaCardClips[i].setAttackBonus(currentBonus[0], currentBonus[1], currentBonus[4], currentBonus[5]);
                _playerCharaCardClips[i].setDeffenceBonus(currentBonus[2], currentBonus[3], currentBonus[6], currentBonus[7]);
            }

            if (_duel.plEntrant.currentWeaponPassiveSkill.length > 0)
            {
                _duel.plEntrant.dispatchEvent(new Event(Entrant.UPDATE_PASSIVE_SKILL));
            }
        }

        // 相手の武器情報が変更されたときの装備ハンドラ
        private function foeUpdateWeaponBonusHandler(e:Event):void
        {
            var foeBonus:Array = _duel.foeEntrant.weaponBonuses;
            var currentBonus:Array;

            var passiveUpdated:Boolean = false;
            for(var i:int = 0; i < _foeCharaCardClips.length; i++)
            {
                currentBonus = foeBonus[i];
                // 装備カードの補正
                _foeCharaCardClips[i].setAttackBonus(currentBonus[0], currentBonus[1], currentBonus[4], currentBonus[5]);
                _foeCharaCardClips[i].setDeffenceBonus(currentBonus[2], currentBonus[3], currentBonus[6], currentBonus[7]);
            }

            if (_duel.foeEntrant.currentWeaponPassiveSkill.length > 0)
            {
                _duel.foeEntrant.dispatchEvent(new Event(Entrant.UPDATE_PASSIVE_SKILL));
            }

        }

        // カレントキャラカードを更新する。変身用。
        private function playerChangeCharaCardHandler(e:ChangeCharaCardEvent):void
        {
            updateCharaCard(true, e.id);
        }

        private function foeChangeCharaCardHandler(e:ChangeCharaCardEvent):void
        {
            updateCharaCard(false, e.id);
        }

        private function updateCharaCard(player:Boolean = false, charaCardId:int = 0):void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            var sExec:SerialExecutor = new SerialExecutor();

            var entrant:Entrant = ( player ) ? _duel.plEntrant : _duel.foeEntrant;
            var charaCards:Array = ( player ) ? _duel.playerCharaCards : _duel.foeCharaCards;
            var charaCardClips:Vector.<DuelCharaCardClip> = ( player ) ? _playerCharaCardClips : _foeCharaCardClips;

            var idx:int = entrant.currentCharaCardIndex;
            var currentBonus:Array = entrant.currentWeaponBonus;
            //var decHp:int = charaCardClips[idx].hp < 0 ? charaCardClips[idx].hp : 0;

            charaCards[idx] = CharaCard.ID(charaCardId);

            // バフデータを取得
            var buffArr:Array = charaCardClips[idx].buffData;
            sExec.addThread(pExec);
            sExec.addThread(pExec2);
            // log.writeLog(log.LV_FATAL, this, "show unknown card");
            var ccc:DuelCharaCardClip = new DuelCharaCardClip(charaCards[idx],!player);
            ccc.x = charaCardClips[idx].x;
            ccc.y = charaCardClips[idx].y;
            _enlargedCardsPoints[ccc] = [charaCardClips[idx].x, charaCardClips[idx].y];
            ccc.alpha = 1.0;
            ccc.setTab();
            ccc.scaleX = ccc.scaleY = _CHARA_CARD_SCALE[idx];
            charaCardClips[idx].removeEventListener(MouseEvent.ROLL_OVER, playerCardMouseOverHandler);
            pExec.addThread(charaCardClips.splice(idx, 1, ccc)[0].getHideThread());
            pExec.addThread(charaCardClips[idx].getShowThread(this));
            pExec.addThread(new BeTweenAS3Thread(charaCardClips[idx], {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ));
            var currentIndex:int = _duel.foeEntrant.currentCharaCardIndex;

            showUnknownCard();
            for(var i:int = 0; i < _foeCharaCardClips.length; i++)
            {
                if(i > currentIndex)
                {
                    pExec.addThread(new BeTweenAS3Thread(_foeCharaCardClips[i], {x:_FOE_CHARA_CARD_X[i] ,y:_FOE_CHARA_CARD_Y[i] ,scaleX:_CHARA_CARD_SCALE[i] ,scaleY:_CHARA_CARD_SCALE[i]}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                    _enlargedCardsPoints[_foeCharaCardClips[i]] = [_FOE_CHARA_CARD_X[i], _FOE_CHARA_CARD_Y[i]];
                    // マウスオーバのつけなおし
                    sExec.addThread(new ClousureThread(regitCharaCardHandler, [_foeCharaCardClips[i], foeCardMouseOverHandler]));
                    sExec.addThread(new ClousureThread(_foeCharaCardClips[i].setTab,[i-1]));
                }
                else if(i < currentIndex)
                {
                    pExec.addThread(new BeTweenAS3Thread(_foeCharaCardClips[i], {x:_FOE_CHARA_CARD_X[i+1] ,y:_FOE_CHARA_CARD_Y[i+1] ,scaleX:_CHARA_CARD_SCALE[i+1] ,scaleY:_CHARA_CARD_SCALE[i+1]}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                    _enlargedCardsPoints[_foeCharaCardClips[i]] = [_FOE_CHARA_CARD_X[i+1], _FOE_CHARA_CARD_Y[i+1]];
                    // マウスオーバのつけなおし
                    sExec.addThread(new ClousureThread(regitCharaCardHandler, [_foeCharaCardClips[i], foeCardMouseOverHandler]));
                    sExec.addThread(new ClousureThread(_foeCharaCardClips[i].setTab,[i]));
                }
                else if(i == currentIndex)
                {
                    pExec.addThread(new BeTweenAS3Thread(_foeCharaCardClips[i], {x:_FOE_CHARA_CARD_X[0] ,y:_FOE_CHARA_CARD_Y[0] ,scaleX:_CHARA_CARD_SCALE[0] ,scaleY:_CHARA_CARD_SCALE[0]}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE));
                    _enlargedCardsPoints[_foeCharaCardClips[i]] = [_FOE_CHARA_CARD_X[0], _FOE_CHARA_CARD_Y[0]];
                    // マウスオーバのつけなおし
                    sExec.addThread(new ClousureThread(regitCharaCardHandler, [_foeCharaCardClips[i], foeCardMouseOverHandler]));
                    sExec.addThread(new ClousureThread(_foeCharaCardClips[i].setTab,[i]));
                    if (_foeCharaCardClips[i].parent != null)
                    {
                        setChildIndex(_foeCharaCardClips[i], numChildren-1 );
                    }
                }
            }

            GameCtrl.instance.addNoWaitViewSequence(sExec);

        }

        // 正体不明キャラカードを表示する
        private function showUnknownCard(player:Boolean = false):void
        {
            if (_state == _STATE_END){return}
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            var sExec:SerialExecutor = new SerialExecutor();

            var entrant:Entrant = ( player ) ? _duel.plEntrant : _duel.foeEntrant;
            var charaCards:Array = ( player ) ? _duel.playerCharaCards : _duel.foeCharaCards;
            var charaCardClips:Vector.<DuelCharaCardClip> = ( player ) ? _playerCharaCardClips : _foeCharaCardClips;

            var i:int = entrant.currentCharaCardIndex;
            var currentBonus:Array = entrant.currentWeaponBonus;
            var decHp:int = charaCardClips[i].hp < 0 ? charaCardClips[i].hp : 0;

            log.writeLog(log.LV_INFO, this, "decdecdec",decHp);

            if(charaCardClips[i].charaCardId == 0)
            {
                // バフデータを取得
                var buffArr:Array = charaCardClips[i].buffData;
                sExec.addThread(pExec);
                sExec.addThread(pExec2);
                // log.writeLog(log.LV_FATAL, this, "show unknown card");
                var ccc:DuelCharaCardClip = new DuelCharaCardClip(charaCards[i],!player);
                ccc.x = charaCardClips[i].x;
                ccc.y = charaCardClips[i].y;
                _enlargedCardsPoints[ccc] = [charaCardClips[i].x, charaCardClips[i].y];
                ccc.alpha = 1.0;
                ccc.setTab();
                ccc.scaleX = ccc.scaleY = _CHARA_CARD_SCALE[i];
                charaCardClips[i].removeEventListener(MouseEvent.ROLL_OVER, playerCardMouseOverHandler);
                pExec.addThread(charaCardClips.splice(i, 1, ccc)[0].getHideThread());
                pExec.addThread(charaCardClips[i].getShowThread(this));
                pExec.addThread(new BeTweenAS3Thread(charaCardClips[i], {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ));
                // 装備カードの補正
                pExec2.addThread(new ClousureThread(charaCardClips[i].setAttackBonus, [currentBonus[0], currentBonus[1], currentBonus[4], currentBonus[5]]));
                pExec2.addThread(new ClousureThread(charaCardClips[i].setDeffenceBonus, [currentBonus[2], currentBonus[3], currentBonus[6], currentBonus[7]]));
                pExec2.addThread(new ClousureThread(charaCardClips[i].setUnknownHp, [(charaCards[i].hp+decHp)]));

                // if (entrant.currentWeaponPassiveSkill.length > 0)
                // {
                //     entrant.dispatchEvent(new Event(Entrant.UPDATE_PASSIVE_SKILL));
                // }

                // バフデータの設定
                for ( var j:int = 0; j < buffArr.length; j++ ) {
                    pExec2.addThread(new ClousureThread(charaCardClips[i].addBuffStatus, [buffArr[j].no,buffArr[j].value,buffArr[j].turn]));
                }
                GameCtrl.instance.addNoWaitViewSequence(sExec);
            }
        }

        // 控えのカードにマウスが触れたときのハンドラ
        private function playerCardMouseOverHandler(e:MouseEvent):void
        {
//            log.writeLog(log.LV_FATAL, this, "mousein", _enlarged);
            if (_enlarged == _ENLARGE_NONE)
            {
            _enlarged = _ENLARGE_PLAYER;
            enlargeCard(DuelCharaCardClip(e.currentTarget));
            }
        }

        // 控えのカードにマウスが触れたときのハンドラ
        private function foeCardMouseOverHandler(e:MouseEvent):void
        {
            if (_enlarged == _ENLARGE_NONE)
            {
                _enlarged = _ENLARGE_FOE;
                enlargeCard(DuelCharaCardClip(e.currentTarget));
            }
        }


        // カード拡大
        private function enlargeCard(ccc:DuelCharaCardClip):void
        {
            _enlargedCard = ccc;
            _enlargedCard.onTab();
            // 問答無用で最前線
            setChildIndex(ccc, numChildren-1 );
            // マウスがはずれたかのチェックを行う関数を登録
            addEventListener(Event.ENTER_FRAME, function():void{
                    restoreCard();
                    if (_enlarged == _ENLARGE_NONE){removeEventListener(Event.ENTER_FRAME, arguments.callee)}
                });

            if (_enlarged == _ENLARGE_PLAYER)
            {
//                 BetweenAS3.tween(ccc, {x:_ENLARGE_PLAYER_CHARA_CARD_X, y:_ENLARGE_PLAYER_CHARA_CARD_Y, scaleX:_ENLARGE_CHARA_CARD_SCALE, scaleY:_ENLARGE_CHARA_CARD_SCALE}, null, 0.15, Quad.easeOut).play();
                BetweenAS3.tween(ccc, {y:_ENLARGE_PLAYER_CHARA_CARD_Y, scaleX:_ENLARGE_CHARA_CARD_SCALE, scaleY:_ENLARGE_CHARA_CARD_SCALE,alpha:1.0}, null, 0.15, Quad.easeOut).play();
            }else if(_enlarged == _ENLARGE_FOE)
            {
//                BetweenAS3.tween(ccc, {x:_ENLARGE_FOE_CHARA_CARD_X, y:_ENLARGE_FOE_CHARA_CARD_Y, scaleX:_ENLARGE_CHARA_CARD_SCALE, scaleY:_ENLARGE_CHARA_CARD_SCALE}, null, 0.15, Quad.easeOut).play();
                BetweenAS3.tween(ccc, {y:_ENLARGE_FOE_CHARA_CARD_Y, scaleX:_ENLARGE_CHARA_CARD_SCALE, scaleY:_ENLARGE_CHARA_CARD_SCALE, alpha:1.0}, null, 0.15, Quad.easeOut).play();
            }
        }

        // 拡大済みカードを戻す
        private function restoreCard():void
        {
            if ((_enlargedCard != null) &&(!(_enlargedCard.hitTestPoint(stage.mouseX,stage.mouseY))&&(_enlarged != _ENLARGE_NONE)))
            {
//                var resetTween:ITween= BetweenAS3.tween(_enlargedCard, {x:_enlargeBeforeX, y:_enlargeBeforeY, scaleX:_CHARA_CARD_SCALE[1], scaleY:_CHARA_CARD_SCALE[1]}, null, 0.08, Quad.easeOut);
                _enlarged = _ENLARGE_NONE;
                var resetTween:ITween= BetweenAS3.tween(_enlargedCard, {x:_enlargedCardsPoints[_enlargedCard][0], y:_enlargedCardsPoints[_enlargedCard][1], scaleX:_CHARA_CARD_SCALE[1], scaleY:_CHARA_CARD_SCALE[1], alpha:_CHARA_CARD_ALPHA}, null, 0.08, Quad.easeOut);
                resetTween.addEventListener(TweenEvent.COMPLETE, resetTweenHandler);
                resetTween.play();
//                setChildIndex(ccc, numChildren-1 );
                log.writeLog(log.LV_FATAL, this, "enlargeCard setIndex", _enlargedCard.parent == this);
                if (_enlargedCard.parent == this)
                {
                    setChildIndex(_enlargedCard, 1);
                }
            }
        }

        // 拡張カードを戻すハンドラ
        private function resetTweenHandler(e:TweenEvent):void
        {
            if (_state==_STATE_NORMAL)
            {
                _enlargedCard.offTab();
            }
            e.currentTarget.removeEventListener(TweenEvent.COMPLETE, resetTweenHandler);
            _enlargedCard.removeEventListener(TweenEvent.COMPLETE, resetTweenHandler);
        }


        // プレイヤーにダメージが与えられたときのハンドラ
        private function playerDamageHandler(e:DamageEvent):void
        {
            var index:int = _duel.plEntrant.currentCharaCardIndex;
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _playerCharaCardClips[index].hp = _playerCharaCardClips[index].hp - e.point;
                            }
            ));
        }

        // プレイヤーがダメージを与えられたときのハンドラ
        private function playerPartyDamageHandler(e:DamageEvent):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _playerCharaCardClips[e.index].hp = _playerCharaCardClips[e.index].hp - e.point;
                            }));

            // プレイヤー側の死んだカードを判定
            if(_playerCharaCardClips[e.index].hp <= e.point)
            {
                GameCtrl.instance.addViewSequence(new ClousureThread(_playerCharaCardClips[e.index].dead));
            }
        }

        // プレイヤーが蘇生したときのハンドラ
        private function playerReviveHandler(e:DamageEvent):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _playerCharaCardClips[e.index].HPReview();
                        if (_playerCharaCardClips[e.index].charaCardId == 0)
                        {
                            _playerCharaCardClips[e.index].hp += e.point;
                        }
                        else
                        {
                            _playerCharaCardClips[e.index].hp = e.point;
                        }
                    }));
        }

        // 対戦相手が蘇生したときのハンドラ
        private function foeReviveHandler(e:DamageEvent):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _foeCharaCardClips[e.index].HPReview();
                        if (_foeCharaCardClips[e.index].charaCardId == 0)
                        {
                            _foeCharaCardClips[e.index].hp += e.point;
                        }
                        else
                        {
                            _foeCharaCardClips[e.index].hp = e.point;
                        }
                    }));
        }



        // プレイヤーが回復したときのハンドラ
        private function playerHealHandler(e:DamageEvent):void
        {
            var index:int = _duel.plEntrant.currentCharaCardIndex;
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _playerCharaCardClips[index].hp = _playerCharaCardClips[index].hp + e.point;
                    }));
        }

        // プレイヤーが回復したときのハンドラ
        private function playerPartyHealHandler(e:DamageEvent):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _playerCharaCardClips[e.index].hp = _playerCharaCardClips[e.index].hp + e.point;
                            }));
        }

        // プレイヤーのHPが変更されたときのハンドラ
        private function playerHPChangeHandler(e:DamageEvent):void
        {
            var index:int = _duel.plEntrant.currentCharaCardIndex;
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _playerCharaCardClips[index].HPReview();
                        _playerCharaCardClips[index].hp = e.point;
                    }));
        }

        // 対戦相手のHPが変更されたときのハンドラ
        private function foeHPChangeHandler(e:DamageEvent):void
        {
            var index:int = _duel.foeEntrant.currentCharaCardIndex;
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _foeCharaCardClips[index].HPReview();
                        _foeCharaCardClips[index].hp = e.point;
                    }));
        }

        // 対戦相手がダメージを受けたときのハンドラ
        private function foeDamageHandler(e:DamageEvent):void
        {
            var index:int = _duel.foeEntrant.currentCharaCardIndex;
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _foeCharaCardClips[index].hp = _foeCharaCardClips[index].hp - e.point;
                    }));
        }

        // 対戦相手がダメージを受けたときのハンドラ
        private function foePartyDamageHandler(e:DamageEvent):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _foeCharaCardClips[e.index].hp = _foeCharaCardClips[e.index].hp - e.point;
                    }));

            // 敵側の死んだカードを判定
            if(_foeCharaCardClips[e.index].hp <= e.point && _foeCharaCardClips[e.index].charaCardId != 0)
            {
                GameCtrl.instance.addViewSequence(new ClousureThread(_foeCharaCardClips[e.index].dead));
            }
        }


        // 対戦相手が回復したときのハンドラ
        private function foeHealHandler(e:DamageEvent):void
        {
            var index:int = _duel.foeEntrant.currentCharaCardIndex;
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _foeCharaCardClips[index].hp = _foeCharaCardClips[index].hp + e.point;
                    }));
        }

        // 対戦相手が回復したときのハンドラ
        private function foePartyHealHandler(e:DamageEvent):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(function():void{
                        if (_state == _STATE_END){return}
                        _foeCharaCardClips[e.index].hp = _foeCharaCardClips[e.index].hp + e.point;
                    }));
        }

        public function getHideCharaCardThred():Thread
        {
            var plThread:ParallelExecutor = new ParallelExecutor();
            _playerCharaCardClips.forEach(
                function(item:DuelCharaCardClip, index:int, array:Vector.<DuelCharaCardClip>):void
                {
                    item.removeEventListener(MouseEvent.ROLL_OVER, playerCardMouseOverHandler);
                    item.removeTab();
                    plThread.addThread(item.getHideThread());
                });
            _foeCharaCardClips.forEach(
                function(item:DuelCharaCardClip, index:int, array:Vector.<DuelCharaCardClip>):void
                {
                    item.removeEventListener(MouseEvent.ROLL_OVER, foeCardMouseOverHandler);
                    item.removeTab();
                    plThread.addThread(item.getHideThread());
                });
            return plThread;
        }

        public function getBringOnThread():Thread
        {

            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            for(var i:int = 0; i < _playerCharaCardClips.length; i++)
            {
                _playerCharaCardClips[i].scaleX = 0.5;
                _playerCharaCardClips[i].scaleY = 0.5;
                pExec.addThread(new BeTweenAS3Thread(_playerCharaCardClips[i], {y:_CHARA_CARD_Y}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.6 - 0.2*i));
            }
            for(i = 0; i < _foeCharaCardClips.length; i++)
            {
                _foeCharaCardClips[i].scaleX = 0.5;
                _foeCharaCardClips[i].scaleY = 0.5;
                pExec.addThread(new BeTweenAS3Thread(_foeCharaCardClips[i], {y:_CHARA_CARD_Y}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.6 - 0.2*i));
            }

            sExec.addThread(new SleepThread(1600));
            sExec.addThread(pExec);
            return sExec;
        }

        public function getBringOnAfterThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            var sExec:SerialExecutor = new SerialExecutor();

            var plTween:Thread = new BeTweenAS3Thread(_playerCharaCardClips[0], {x:_PLAYER_CHARA_CARD_X[0] ,y:_PLAYER_CHARA_CARD_Y[0], scaleX:1.0, scaleY:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE );
            var foeTween:Thread = new BeTweenAS3Thread(_foeCharaCardClips[0], {x:_FOE_CHARA_CARD_X[0] ,y:_FOE_CHARA_CARD_Y[0], scaleX:1.0, scaleY:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE );
            _enlargedCardsPoints[_foeCharaCardClips[0]] = [_FOE_CHARA_CARD_X[0], _FOE_CHARA_CARD_Y[0]];
            pExec.addThread(plTween);
            pExec.addThread(foeTween);
            pExec.addThread(new ClousureThread(_foeCharaCardClips[0].setTab,[0]));

            // 3vs3なら残りのカードもあわせて表示
            if(_duel.rule == Duel.RULE_3VS3)
            {
                for(var i:int = 1; i < _playerCharaCardClips.length; i++)
                {
                    _enlargedCardsPoints[_playerCharaCardClips[i]] = [_PLAYER_CHARA_CARD_X[i], _PLAYER_CHARA_CARD_Y[i]];
                    pExec.addThread(new BeTweenAS3Thread(_playerCharaCardClips[i], {x:_PLAYER_CHARA_CARD_X[i], y:_PLAYER_CHARA_CARD_Y[i], scaleX:_CHARA_CARD_SCALE[i], scaleY:_CHARA_CARD_SCALE[i], alpha:_CHARA_CARD_ALPHA}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ));
                    pExec.addThread(new ClousureThread(_playerCharaCardClips[i].setTab,[i-1]));

                    if(i == 1)
                    {
                        _leftCharaCardClip = _playerCharaCardClips[1];
                    }
                    else
                    {
                        _rightCharaCardClip = _playerCharaCardClips[2];
                    }
                }
                for(i = 0; i < _foeCharaCardClips.length; i++)
                {
                    _enlargedCardsPoints[_foeCharaCardClips[i]] = [_FOE_CHARA_CARD_X[i], _FOE_CHARA_CARD_Y[i]];
                    pExec.addThread(new BeTweenAS3Thread(_foeCharaCardClips[i], {x:_FOE_CHARA_CARD_X[i], y:_FOE_CHARA_CARD_Y[i], scaleX:_CHARA_CARD_SCALE[i], scaleY:_CHARA_CARD_SCALE[i], alpha:_CHARA_CARD_ALPHA}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ));
                    pExec.addThread(new ClousureThread(_foeCharaCardClips[i].setTab,[i-1]));
                }

            }

            pExec2.addThread(new ClousureThread(setMouseOverEvent));

            sExec.addThread(pExec);
            sExec.addThread(pExec2);

            return sExec;
        }

        // マウスイベントを設定する関数
        public function setMouseOverEvent():void
        {
            if(_duel.rule == Duel.RULE_3VS3)
            {
                for(var i:int = 1; i < _playerCharaCardClips.length; i++)
                {
                    _playerCharaCardClips[i].addEventListener(MouseEvent.ROLL_OVER, playerCardMouseOverHandler)
                }
                for(i = 0; i < _foeCharaCardClips.length; i++)
                {
                    _foeCharaCardClips[i].addEventListener(MouseEvent.ROLL_OVER, foeCardMouseOverHandler)
                }
            }else{
                    _foeCharaCardClips[0].addEventListener(MouseEvent.ROLL_OVER, foeCardMouseOverHandler)
            }
        }

        public function getBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (_playerCharaCardClips != null) {
                _playerCharaCardClips.forEach(function(item:*, index:int, array:Vector.<DuelCharaCardClip>):void{
                        if (item != null) {pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));}
                            });
            }
            if (_foeCharaCardClips != null) {
                _foeCharaCardClips.forEach(function(item:*, index:int, array:Vector.<DuelCharaCardClip>):void{
                        if (item != null) {pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));}
                            });
            }
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

    }

}

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import org.libspark.thread.Thread;

import model.Duel;
import view.scene.game.DuelCharaCards;
import view.BaseShowThread;
import view.BaseHideThread;

class ShowThread extends BaseShowThread
{
    private var _dcc:DuelCharaCards;
    private var _at:int;

    public function ShowThread(dcc:DuelCharaCards, stage:DisplayObjectContainer, at:int)
    {
        _dcc = dcc;
        _at = at;
        super(dcc, stage)
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


    private function init ():void
    {
        var thread:Thread;
        thread =  _dcc.charaCardsInitialize();
        thread.start();
        thread.join();
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    private var _dcc:DuelCharaCards;

    public function HideThread(dcc:DuelCharaCards)
    {
        _dcc = dcc;
        super(dcc);
    }

    protected override function run():void
    {
        var thread:Thread;

        thread = _dcc.getHideCharaCardThred();
        thread.start();
        thread.join();
        next(exit);
    }


}
