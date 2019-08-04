package model
{
    import model.events.*;
    import flash.utils.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;


    import flash.events.EventDispatcher;
    import flash.events.Event;
    import view.scene.game.DuelCharaCardClip;
    import view.scene.game.BuffClip;
    import view.*;

    import model.Player;            // By_K2
    import model.Avatar;            // By_K2
    import controller.QuestCtrl;    // By_K2
    
    /**
     * デュエル参加者クラス
     *
     *
     */
    public class Duel  extends BaseModel
    {
        public static const START:String                          = 'start';                                 // スタート

        public static const START_TURN_PHASE:String   = 'start_turn_phase';    // バトルカードのドロップを開始
        public static const REFILL_PHASE:String                   = 'refill_phase';                          // 補充フェイズ
        public static const MOVE_CARD_DROP_PHASE_START:String     = 'move_card_drop_phase_start';            // 移動カードのドロップを開始
        public static const MOVE_CARD_DROP_PHASE_FINISH:String    = 'move_card_drop_phase_finish';           // 移動カードのドロップを終了

        public static const DETERMINE_MOVE_PHASE:String           = 'determine_move_phase';                  // 移動フェイズを確定

        public static const CHARA_CHANGE_PHASE_START:String     = 'chara_change_phase_start';                // キャラチェンジフェイズを開始
        public static const CHARA_CHANGE_PHASE_FINISH:String    = 'chara_change_phase_finish';               // キャラチェンジフェイズを終了

        public static const BATTLE_CARD_DROP_ATTACK_PHASE_START:String   = 'battle_card_drop_attack_phase_start';    // バトルカードのドロップを開始
        public static const BATTLE_CARD_DROP_DEFFENCE_PHASE_START:String   = 'battle_card_drop_deffence_phase_start';    // バトルカードのドロップを開始
        public static const BATTLE_CARD_DROP_WAITING_PHASE_START:String   = 'battle_card_drop_waiting_phase_start';    // バトルカードのドロップを開始

        public static const BATTLE_CARD_DROP_PHASE_FINISH:String  = 'battle_card_drop_phase_finish';         // バトルカードのドロップを終了

        public static const DETERMINE_BATTLE_POINT_PHASE:String   = 'determine_battle_point_phase';          // バトルカードを確定

        public static const DEAD_CHARA_CHANGE_PHASE_START:String     = 'dead_chara_change_phase_start';      // 移動カードのドロップを開始
        public static const DEAD_CHARA_CHANGE_PHASE_FINISH:String    = 'dead_chara_change_phase_finish';     // 移動カードのドロップを終了

        public static const FINISH_TURN_PHASE:String              = 'finish_turn_phase';                     // ターン終了

        public static const USE_EVENT_ACTION_CARD:String              = 'use_event_action_card';             // イベントアクションカードを使用

        public static const END:String           = 'end';           // バトルの決定
        public static const DECK_INIT:String     = 'deck init';     // デッキを初期化
        public static const DECK_RESET:String     = 'deck_reset';     // デッキを再設定
        public static const DISTANCE_UPDATE:String     = 'distance_update';     // 距離の更新

        public static const RULE_1VS1:int = 0;     // 1vs1のルール
        public static const RULE_3VS3:int = 1;     // 3vs3のルール

        public static const ATK_TYPE_SWORD:int = 0;     // 現在の攻撃タイプ
        public static const ATK_TYPE_ARROW:int = 1;     // 現在の攻撃タイプ

        public static const RAGE_SKILL_NO:int = 6;     // レイジパッシブのスキルナンバー

        private static var __instance:Duel; // シングルトンインスタンス

        public var plEntrant:Entrant;
        public var foeEntrant:FoeEntrant;

        private var _inited:Boolean = false; // 初期化は終わったか？
        private var _rule:int = 0;           // デュエルのルール

        private var _ruleQuest:Boolean = false;     // By_K2 (퀘스트 인지 체크)

        private var _turn:int = 0;          //現在のターン
        private var _initi:Boolean = false; //イニシアチブの結果
        private var _isDetermineMovePhase:Boolean = false; //移動確定フェイズか
        private var _playerStayHealDone:Boolean = false; //ステイによる回復を行ったか
        private var _bTurn:int = 0;         //バトルのターン 0_ or 1
        private var _state:String = ''; // 現在の状態
        private var _deckSize:int;         // 現在のデッキの残り枚数
        private var _distance:int;         // 現在の距離
        private var _truth_distance:int = 0;   // ハイド中の距離 PL側からのみ更新して使う

        private var _raidScore:int = 0;         // 現在のレイドスコア

        // private var _playerCharaCard:CharaCard;     // カレントキャラカード
        // private var _foeCharaCard:CharaCard;        // カレントキャラカード

        private var _playerCharaCards:Array = [];   // 
        private var _foeCharaCards:Array = [];      // 

        private var _playerBuffClips:Array = [];   // 状態異常を保持する
        private var _foeBuffClips:Array = [];      // 状態異常を保持する
        private var _playerCatState:Array = [false, false, false]; // 猫化状態を保持する 暫定的に。後で変身含め一般化する予定
        private var _foeCatState:Array = [false, false, false]; // 猫化状態を保持する

        private var _reward:Reward // 報酬情報のオブジェクト
        private var _resultMovePoint:int;

        private var _stage:int;

        private var _plDamages:Array;
        private var _foeDamages:Array;
        private var _bonus:Boolean;

        private var _isWatch:Boolean = false;  // 観戦モードか
        private var _raidBoss:Boolean = false; // レイドボスか

        private var _fieldStatus:Array = [];

        private var _playerOverrideFeats:Object = new Object(); // 上書きされた技
        private var _foeOverrideFeats:Object = new Object(); // 上書きされた技

        private var _plStuffedToysNum:int = 0;
        private var _foeStuffedToysNum:int = 0;

        private var _overrideActionCards:Dictionary = new Dictionary();

        /**
         * シングルトンインスタンスを返すクラス関数
         *
         *
         */
        public static function get instance():Duel
        {
            if( __instance == null )
            {
                __instance = createInstance();
            }
            return __instance;
        }

        public static function get currentDuel():Duel
        {
            return __instance;
        }

        // 本当のコンストラクタ
        private static function createInstance():Duel
        {
            return new Duel(arguments.callee);
        }

        // コンストラクタ
        public function Duel(caller:Function)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
        }

        // 遅延初期化
        public function initialize(plCCID:Array, foeCCID:Array, stage:int=0, plDameges:Array=null, foeDamages:Array=null, raidBoss:Boolean=false):void
        {
            log.writeLog(log.LV_INFO, this, "initialize chara card id", plCCID, foeCCID, plDameges, foeDamages);
            _playerCharaCards = [];
            _foeCharaCards = [];
            _playerBuffClips =[];
            _foeBuffClips = [];
            _playerOverrideFeats = new Object();
            _foeOverrideFeats = new Object();
            _overrideActionCards = new Dictionary();
            _fieldStatus = [];
            _playerCatState= [false, false, false];
            _foeCatState = [false, false, false];
            _plStuffedToysNum = 0;
            _foeStuffedToysNum = 0;
            plCCID.forEach(function(item:*, index:int, array:Array):void{_playerCharaCards.push(CharaCard.ID(item))});
            foeCCID.forEach(function(item:*, index:int, array:Array):void{_foeCharaCards.push(CharaCard.ID(item))});
            _plDamages = plDameges;
            _foeDamages = foeDamages;
            _raidBoss = raidBoss;
            new CreateEntrant([_playerCharaCards,_foeCharaCards]).start() ;
            _state = START;
            _stage = stage;
            _reward = new Reward();

            // By_K2 (무한의탑 층수만큼 POWER 증가)
            if (_ruleQuest == true && QuestCtrl.instance.currentMapNo > 0)
            {
                if (QuestCtrl.instance.currentMap.id >= 99991 && QuestCtrl.instance.currentMap.id <= 99996 && Player.instance.avatar.floorCount > 0 && Player.instance.avatar.floorCount <= 10000)
                {
                    //log.writeLog(log.LV_INFO, this, "By_K2 QuestCtrl.instance.currentMap.id", QuestCtrl.instance.currentMap.id);
                    _foeCharaCards[0].setPower(Player.instance.avatar.floorCount);
                }
            }
        }

        // プレイヤーの現在のキャラクターのFeatを配列で返す
        public function getPlayerFeats():Array
        {
            var ret:Array = [];
            var feats:Array = playerCharaCard.feats;
            for (var feat_index:String in feats)
            {
                if (_playerOverrideFeats.hasOwnProperty(plEntrant.currentCharaCardIndex) &&
                    _playerOverrideFeats[plEntrant.currentCharaCardIndex]["feat_index"] == int(feat_index))
                {
                    ret.push(_playerOverrideFeats[plEntrant.currentCharaCardIndex]["feat"]);
                }
                else
                {
                    ret.push(feats[feat_index]);
                }
            }
            return ret;
        }

        // 敵の現在のキャラクターのFeatを配列で返す
        public function getFoeFeats():Array
        {
            var ret:Array = [];
            var feats:Array = foeCharaCard.feats;
            for (var feat_index:String in feats)
            {
                if (_foeOverrideFeats.hasOwnProperty(foeEntrant.currentCharaCardIndex) &&
                    _foeOverrideFeats[foeEntrant.currentCharaCardIndex]["feat_index"] == int(feat_index))
                {
                    ret.push(_foeOverrideFeats[foeEntrant.currentCharaCardIndex]["feat"]);
                }
                else
                {
                    ret.push(feats[feat_index]);
                }
            }
            return ret;
        }

        // 上書きされたアクションカードのリストを返す
        public function getOverrideActionCards():Object
        {
            return _overrideActionCards;
        }

        // キャラのロードを終わってから参加者クラスを作る
        public function createEntrant():void
        {
            if (foeEntrant != null)
            {
                foeEntrant.removeEventListener(DamageEvent.DAMAGE, foeDamageHandler);
            }

            plEntrant = (!_isWatch) ? new Entrant(_playerCharaCards, _plDamages) : new AudienceEntrant(_playerCharaCards, _plDamages);
//            foeEntrant = new FoeEntrant(_foeCharaCards, _foeDamages);
            foeEntrant = new FoeEntrant(_foeCharaCards, _foeDamages);
            log.writeLog(log.LV_INFO, this, "+++ entrant new",plEntrant.uid, foeEntrant.uid);

           foeEntrant.addEventListener(DamageEvent.DAMAGE, foeDamageHandler);

            _inited = true;
            notifyAll();
            dispatchEvent(new Event(START));
        }

        private function foeDamageHandler(e:Event):void
        {
            // updateRaidScore();
        }

        public function setDuelBonus(k:int, v:int, pl:Boolean = true):void
        {
            dispatchEvent(new DuelBonusEvent(DuelBonusEvent.GET,k,v));
            // updateRaidScore();
        }

        public function updateRaidScore():void
        {
           dispatchEvent(new RaidScoreEvent(RaidScoreEvent.UPDATE,raidScore));
        }

        public function ragePassiveOn(charaSet:Array):void
        {
            dispatchEvent(new RagePassiveEvent(RagePassiveEvent.ON, charaSet));
        }

       public function ragePassiveOff():void
        {
           dispatchEvent(new RagePassiveEvent(RagePassiveEvent.OFF,[]));
        }

        // ターンの更新
        public function setTurn(t:int):void
        {
            _turn = t;
            dispatchEvent(new Event(START_TURN_PHASE));
        }

        public function cardLock(id:int):void
        {
            dispatchEvent(new CardLockEvent(CardLockEvent.LOCK, id));
        }

        public function clearCardLocks():void
        {
            dispatchEvent(new CardLockEvent(CardLockEvent.UNLOCK));
        }


        // フィールド状態変更
        public function setFieldStatus(kind:int, pow:int, turn:int):void
        {
            dispatchEvent(new FieldStatusEvent(FieldStatusEvent.SET, kind, pow, turn));
        }

        // 補充フェイズ
        public function refillPhase(pl:Array, foe:int):void
        {
            _state = REFILL_PHASE;
            _resultMovePoint = 0;
            deckSize = deckSize - pl.length;
            deckSize = deckSize - foe;
            var plArr:Array = (!_isWatch) ? pl:[pl.length];
            plEntrant.dealed(plArr);
            foeEntrant.dealed([foe]);
            plEntrant.flagReset();
            foeEntrant.flagReset();
            dispatchEvent(new Event(REFILL_PHASE));
            dispatchEvent(new DealCardEvent(DealCardEvent.DEAL,pl,foe));
        }
        // イベントカード補充フェイズ
        public function refillEventPhase(pl:Array, foe:int):void
        {
            _resultMovePoint = 0;
//             deckSize = deckSize - pl.length;
//             deckSize = deckSize - foe;
            var plArr:Array = (!_isWatch) ? pl:[pl.length];
            plEntrant.dealed(plArr);
            foeEntrant.dealed([foe]);
//             plEntrant.flagReset();
//             foeEntrant.flagReset();
//            dispatchEvent(new Event(REFILL_PHASE));
            dispatchEvent(new DealCardEvent(DealCardEvent.DEAL,pl,foe,true));
        }

        // 移動カードドロップフェイズ開始
        public function moveCardDropPhaseStart():void
        {
            _state = MOVE_CARD_DROP_PHASE_START;
            dispatchEvent(new Event(MOVE_CARD_DROP_PHASE_START));
        }

        // 移動カードドロップフェイズ終了
        public function moveCardDropPhaseFinish():void
        {
            _isDetermineMovePhase = true;
            _state = MOVE_CARD_DROP_PHASE_FINISH;
            dispatchEvent(new Event(MOVE_CARD_DROP_PHASE_FINISH));
        }

        // 移動フェイズ確定
        public function determineMovePhase(initi:Boolean, dist:int, pl:Array, foe:Array, pow:int, foePow:int):void
        {
            _initi = initi;
            _state = DETERMINE_MOVE_PHASE;
            if (_initi && !_playerStayHealDone)
            {
                Voice.playCharaVoice(playerCharaCard.parentID, Const.VOICE_SITUATION_BATTLE_INITIATIVE, 0, 0, Const.VOICE_PLAYING_METHOD_EXCLUSIVE);
            }
            dispatchEvent(new Event(DETERMINE_MOVE_PHASE));
            dispatchEvent(new DetermineMoveEvent(DetermineMoveEvent.UPDATE, pow, foePow));
            plEntrant.cardsSweep(pl);
            dispatchEvent(new SweepCardEvent(SweepCardEvent.SWEEP_ALL_PLAYER, pl));
            foeEntrant.cardsSweep(foe);
            dispatchEvent(new SweepCardEvent(SweepCardEvent.SWEEP_ALL_FOE, foe));
            _isDetermineMovePhase = false;
            _playerStayHealDone = false;
//            setDistance(dist);
        }

        // キャラチェンジフェイズ開始
        public function charaChangePhaseStart():void
        {
            _state = CHARA_CHANGE_PHASE_START;
            dispatchEvent(new Event(CHARA_CHANGE_PHASE_START));
        }

        // キャラチェンジフェイズ終了
        public function charaChangePhaseFinish():void
        {
            foeEntrant.changeDone();
            plEntrant.changeDone();
            _state = CHARA_CHANGE_PHASE_FINISH;
            dispatchEvent(new Event(CHARA_CHANGE_PHASE_FINISH));

        }

        // 攻撃カードドロップフェイズ開始
        public function attackCardDropPhaseStart(attack:Boolean):void
        {
            if(attack)
            {
                _state = BATTLE_CARD_DROP_ATTACK_PHASE_START;

                dispatchEvent(new Event(BATTLE_CARD_DROP_ATTACK_PHASE_START));
            }
            else
            {
                _state = BATTLE_CARD_DROP_WAITING_PHASE_START;
                dispatchEvent(new Event(BATTLE_CARD_DROP_WAITING_PHASE_START));
            }
        }

        // 防御カードドロップフェイズ開始
        public function deffenceCardDropPhaseStart(deffence:Boolean):void
        {
            if(deffence)
            {
//                log.writeLog(log.LV_WARN, this, "deffence drop phase start??????????????", deffence);
                _state = BATTLE_CARD_DROP_DEFFENCE_PHASE_START;
                dispatchEvent(new Event(BATTLE_CARD_DROP_DEFFENCE_PHASE_START));
            }
            else
            {
                _state = BATTLE_CARD_DROP_WAITING_PHASE_START;
                dispatchEvent(new Event(BATTLE_CARD_DROP_WAITING_PHASE_START));
            }
        }

        // 攻撃カードドロップフェイズ終了
        public function attackCardDropPhaseFinish():void
        {
            plEntrant.battleFlagReset();
            _state = BATTLE_CARD_DROP_PHASE_FINISH;
            dispatchEvent(new Event(BATTLE_CARD_DROP_PHASE_FINISH));
        }

        // 防御カードドロップフェイズ終了
        public function deffenceCardDropPhaseFinish():void
        {
            plEntrant.battleFlagReset();
            _state = BATTLE_CARD_DROP_PHASE_FINISH;
            dispatchEvent(new Event(BATTLE_CARD_DROP_PHASE_FINISH));
        }

        // バトルカード確定
        public function determineBattlePointPhase(pl:Array, foe:Array):void
        {
            _state = DETERMINE_BATTLE_POINT_PHASE;
            plEntrant.cardsSweep(pl);
            dispatchEvent(new SweepCardEvent(SweepCardEvent.SWEEP_ALL_PLAYER, pl));
            foeEntrant.cardsSweep(foe);
            dispatchEvent(new SweepCardEvent(SweepCardEvent.SWEEP_ALL_FOE, foe));
            dispatchEvent(new Event(DETERMINE_BATTLE_POINT_PHASE));
        }

        // バトル結果のフェイズ
        public function battleResultPhase(player:Boolean, attack:Array, deffence:Array):void
        {
            // １ターン目でかつ、イニシアチブを取った場合と1ターン目でもなく、イニシアチブも取っていない場合
            if (player)
            {
                if ((attack.length > 0)&&(deffence.length > 0))
                {
                    dispatchEvent(new RollResultEvent(RollResultEvent.PLAYER_ATTACK,attack,deffence));
                }
            }
            else
            {
                if ((attack.length > 0)&&(deffence.length > 0))
                {
                    dispatchEvent(new RollResultEvent(RollResultEvent.FOE_ATTACK,attack,deffence));
                }
            }
        }

        // 死亡キャラチェンジフェイズ開始
        public function deadCharaChangePhaseStart(pl:Array, foe:Array):void
        {
            plEntrant.cardsSweep(pl);
            dispatchEvent(new SweepCardEvent(SweepCardEvent.SWEEP_ALL_PLAYER, pl));
            foeEntrant.cardsSweep(foe);
            dispatchEvent(new SweepCardEvent(SweepCardEvent.SWEEP_ALL_FOE, foe));
            _state = DEAD_CHARA_CHANGE_PHASE_START;
            dispatchEvent(new Event(DEAD_CHARA_CHANGE_PHASE_START));
        }

        // 死亡キャラチェンジフェイズ終了
        public function deadCharaChangePhaseFinish():void
        {
            foeEntrant.changeDone();
            plEntrant.changeDone();
            log.writeLog(log.LV_INFO, this, "finish dead chara change phase");
            _state = DEAD_CHARA_CHANGE_PHASE_FINISH;
            dispatchEvent(new Event(DEAD_CHARA_CHANGE_PHASE_FINISH));
        }

        // ターン終了
        public function finishTurnPhase():void
        {
            _state = FINISH_TURN_PHASE;
            dispatchEvent(new Event(FINISH_TURN_PHASE));
        }

        // ============ Entrant Event ==============

        // 特別にカードが配られたときのイベント
        public function specialDealEvent(player:Boolean, list:Array, size:int):void
        {
            deckSize -= size;
            if (player)
            {
                plEntrant.dealed(list);
                dispatchEvent(new DealCardEvent(DealCardEvent.DEAL,list,0));
            }
            else
            {
                foeEntrant.dealed([size]);
                dispatchEvent(new DealCardEvent(DealCardEvent.DEAL,[],size));
            }
       }

        // 墓地からカードが配られた時のイベント
        public function graveDealEvent(player:Boolean, list:Array, size:int):void
        {
            if (player)
            {
                var plArr:Array = (!_isWatch) ? list:[list.length];
                plEntrant.dealed(plArr);
                dispatchEvent(new DealCardEvent(DealCardEvent.GRAVE_DEAL,list,0));
            }
            else
            {
                foeEntrant.dealed([size]);
                dispatchEvent(new DealCardEvent(DealCardEvent.GRAVE_DEAL,[],size));
            }
       }

        // プレイヤーからプレイヤーへカードが配られた時のイベント
        public function stealDealEvent(player:Boolean, list:Array, size:int):void
        {
            if (player)
            {
                var plArr:Array = (!_isWatch) ? list:[list.length];
                plEntrant.dealed(plArr);
                dispatchEvent(new DealCardEvent(DealCardEvent.STEAL_DEAL,list,0));
            }
            else
            {
                foeEntrant.dealed([size]);
                dispatchEvent(new DealCardEvent(DealCardEvent.STEAL_DEAL, list,size));
            }
       }

        // 特別にイベントカードが配られたときのイベント
        public function specialEventCardDealEvent(player:Boolean, list:Array, size:int):void
        {
            if (player)
            {
                plEntrant.dealed(list);
                dispatchEvent(new DealCardEvent(DealCardEvent.DEAL,list,0,true));
            }
            else
            {
                foeEntrant.dealed([size]);
                dispatchEvent(new DealCardEvent(DealCardEvent.DEAL,[],size,true));
            }
        }

        // イベントカード使用後の廃棄イベント
        public function useActionCard(player:Boolean, ac:ActionCard):void
        {
            dispatchEvent(new Event(USE_EVENT_ACTION_CARD));
            var ac_array:Array= [ac]; /* of ActionCard */
            if (player)
            {
                if (!_isWatch){
                    plEntrant.cardsSweep(ac_array);
                } else {
                    AudienceEntrant(plEntrant).openEventCard(ac);
                    plEntrant.cardsSweep([ac]);
                }
                log.writeLog(log.LV_FATAL, this, "pl use ActionCard",ac_array);
                dispatchEvent(new SweepCardEvent(SweepCardEvent.SWEEP_PLAYER, ac_array));
            }else{
                foeEntrant.openEventCard(ac)
                foeEntrant.cardsSweep([ac]);
//                log.writeLog(log.LV_FATAL, this, "foe use ActionCard",ac_array);
                dispatchEvent(new SweepCardEvent(SweepCardEvent.SWEEP_FOE, ac_array));
            }
        }

        // カード廃棄イベント
        public function discard(player:Boolean, ac:ActionCard):void
        {
            log.writeLog(log.LV_FATAL, this, "dicard ActionCard",ac.id);
            var ac_array:Array= [ac]; /* of ActionCard */
            if (player)
            {
                if (! _isWatch) {
                    plEntrant.cardsSweep(ac_array);
                } else {
                    AudienceEntrant(plEntrant).openDiscardCard(ac);
                    plEntrant.cardsSweep([ac]);
                }
//                plEntrant.cardsSweep(ac_array);
                dispatchEvent(new SweepCardEvent(SweepCardEvent.DISCARD_PLAYER, ac_array));
            }else{
                foeEntrant.openDiscardCard(ac)
                foeEntrant.cardsSweep([ac]);
                dispatchEvent(new SweepCardEvent(SweepCardEvent.DISCARD_FOE, ac_array));
            }
        }

        // テーブルカード廃棄イベント
        public function discardTable(player:Boolean, ac:ActionCard):void
        {
            var ac_array:Array= [ac]; /* of ActionCard */
            if (player)
            {
                if (! _isWatch) {
                    plEntrant.cardsSweep(ac_array);
                } else {
                    AudienceEntrant(plEntrant).openDiscardCard(ac);
                    plEntrant.cardsSweep([ac]);
                }
//                plEntrant.cardsSweep(ac_array);
                dispatchEvent(new SweepCardEvent(SweepCardEvent.SWEEP_PLAYER, ac_array));
            }else{
                foeEntrant.cardsSweep([ac]);
                dispatchEvent(new SweepCardEvent(SweepCardEvent.SWEEP_FOE, ac_array));
            }
        }

        // 強奪用カード廃棄イベント
        public function stealDiscard(player:Boolean, ac:ActionCard):void
        {
            log.writeLog(log.LV_FATAL, this, "dicard ActionCard",ac.id);
            var ac_array:Array= [ac]; /* of ActionCard */
            if (player)
            {
                if (! _isWatch) {
                    plEntrant.cardsSweep(ac_array);
                } else {
                    AudienceEntrant(plEntrant).blankCardSweep([ac]);
                }
                dispatchEvent(new SweepCardEvent(SweepCardEvent.STEAL_DISCARD_PLAYER, ac_array));
            }else{
                if (! _isWatch) {
                    foeEntrant.openDiscardCard(ac);
                    foeEntrant.cardsSweep([ac]);
                } else {
                    foeEntrant.closeDiscardCard(ac);
                }
                dispatchEvent(new SweepCardEvent(SweepCardEvent.STEAL_DISCARD_FOE, ac_array));
            }
        }

        // 必殺技が有効になったときのイベント
        public function featOnEvent(player:Boolean, featId:int):void
        {
            if(player)
            {
                dispatchEvent(new FeatInfoEvent(FeatInfoEvent.PLAYER_FEAT_ON, featId));
            }
            else
            {
            }
        }

        // 必殺技が無効になったときのイベント
        public function featOffEvent(player:Boolean, featId:int):void
        {
            if(player)
            {
                dispatchEvent(new FeatInfoEvent(FeatInfoEvent.PLAYER_FEAT_OFF, featId));
            }
            else
            {
            }
        }

        // 必殺技が変更されたときのイベント
        public function featChangeEvent(player:Boolean, chara_index:int, feat_index:int, feat_id:int, feat_no:int):void
        {
            if(player)
            {
                _playerOverrideFeats[chara_index] = {"feat_index": feat_index, "feat": Feat.ID(feat_id)};
                if (plEntrant.currentCharaCardIndex == chara_index)
                {
                    dispatchEvent(new FeatInfoChangeEvent(FeatInfoChangeEvent.PLAYER_FEAT_CHANGE, chara_index, feat_index, feat_id, feat_no));
                }
            }
            else
            {
                _foeOverrideFeats[chara_index] = {"feat_index": feat_index, "feat": Feat.ID(feat_id)};
                if (foeEntrant.currentCharaCardIndex == chara_index)
                {
                    dispatchEvent(new FeatInfoChangeEvent(FeatInfoChangeEvent.FOE_FEAT_CHANGE, chara_index, feat_index, feat_id, feat_no));
                }
            }
        }

        // 必殺技が使用されたときのイベント
        public function featUseEvent(player:Boolean, useFeatId:int):void
        {
            if(player)
            {
//                dispatchEvent(new FeatInfoEvent(FeatInfoEvent.PLAYER_FEAT_OFF_ALL, useFeatId));
                Voice.playCharaVoice(playerCharaCard.parentID, Const.VOICE_SITUATION_BATTLE_FEAT, useFeatId);
                dispatchEvent(new FeatInfoEvent(FeatInfoEvent.PLAYER_FEAT_OFF, useFeatId));
                dispatchEvent(new FeatSceneEvent(FeatSceneEvent.PLAYER_FEAT_USE, useFeatId));
            }
            else
            {
                dispatchEvent(new FeatSceneEvent(FeatSceneEvent.FOE_FEAT_USE, useFeatId));
            }
        }

        // パッシブが使用されたときのイベント
        public function passiveUseEvent(player:Boolean, usePassiveSkillId:int):void
        {
            if(player)
            {
                dispatchEvent(new PassiveSkillSceneEvent(PassiveSkillSceneEvent.PLAYER_PASSIVE_SKILL_USE, usePassiveSkillId));
            }
            else
            {
                dispatchEvent(new PassiveSkillSceneEvent(PassiveSkillSceneEvent.FOE_PASSIVE_SKILL_USE, usePassiveSkillId));
            }
        }

        // キャラカード交換イベント
        public function changeCharaCardEvent(player:Boolean, charaCardId:int):void
        {
            if(player)
            {
                plEntrant.setChangeDone(false);
                _playerCharaCards[plEntrant.currentCharaCardIndex] = CharaCard.ID(charaCardId);
                plEntrant.changeDone();
                dispatchEvent(new ChangeCharaCardEvent(ChangeCharaCardEvent.PLAYER, charaCardId));
                log.writeLog(log.LV_FATAL, this, "HP UPDATE IS ",_playerCharaCards[plEntrant.currentCharaCardIndex].hp);
                foeEntrant.loadingCC = false;
                new UpdateHPThread(_playerCharaCards[plEntrant.currentCharaCardIndex], plEntrant.updateCharaCardHp, plEntrant.currentCharaCardIndex).start();
            }
            else
            {
                var sExec:SerialExecutor = new SerialExecutor();
                foeEntrant.setChangeDone(false);
                _foeCharaCards[foeEntrant.currentCharaCardIndex] = CharaCard.ID(charaCardId);
                dispatchEvent(new ChangeCharaCardEvent(ChangeCharaCardEvent.FOE, charaCardId));
                log.writeLog(log.LV_FATAL, this, "HP UPDATE IS ",_foeCharaCards[foeEntrant.currentCharaCardIndex].hp);
                foeEntrant.loadingCC = false;
                sExec.addThread(new UpdateHPThread(_foeCharaCards[foeEntrant.currentCharaCardIndex], foeEntrant.updateCharaCardHp, foeEntrant.currentCharaCardIndex));
                sExec.addThread(new SleepThread(1500));
                sExec.addThread(new ClousureThread(foeEntrant.changeDone));
                sExec.start();
            }
        }

        // キャラカード変身イベント
        public function onTransformEvent(player:Boolean, type:int):void
        {
            if(player)
            {
                dispatchEvent(new CharaTransformEvent(CharaTransformEvent.PLAYER, true, type));
            }
            else
            {
                dispatchEvent(new CharaTransformEvent(CharaTransformEvent.FOE, true, type));
            }
        }


        // キャラカード変身解除イベント
        public function offTransformEvent(player:Boolean):void
        {
            if(player)
            {
                dispatchEvent(new CharaTransformEvent(CharaTransformEvent.PLAYER, false));
            }
            else
            {
                dispatchEvent(new CharaTransformEvent(CharaTransformEvent.FOE, false));
            }
        }

        // きりがくれイベント
        public function onLostInTheFogEvent(player:Boolean, distance:int, truth_distance:int):void
        {
            if(player)
            {
                if (truth_distance > 0)
                {
                    _truth_distance = truth_distance;
                }
                dispatchEvent(new CharaLostInTheFogEvent(CharaLostInTheFogEvent.PLAYER, true, distance, truth_distance));
            }
            else
            {
                dispatchEvent(new CharaLostInTheFogEvent(CharaLostInTheFogEvent.FOE, true, distance, truth_distance));
            }
        }

        // きりがくれ終了イベント
        public function offLostInTheFogEvent(player:Boolean, distance:int):void
        {
            if(player)
            {
                dispatchEvent(new CharaLostInTheFogEvent(CharaLostInTheFogEvent.PLAYER, false, distance));
            }
            else
            {
                dispatchEvent(new CharaLostInTheFogEvent(CharaLostInTheFogEvent.FOE, false, distance));
            }
        }

        // きりがくれライティングイベント
        public function inTheFogEvent(player:Boolean, range:Array):void
        {
            if(player)
            {
                dispatchEvent(new InTheFogEvent(InTheFogEvent.PLAYER, range));
            }
            else
            {
                dispatchEvent(new InTheFogEvent(InTheFogEvent.FOE, range));
            }
        }

        // パッシブスキル発動イベント
        public function onPassiveEvent(player:Boolean,skillId:int):void
        {
            if(player)
            {
                dispatchEvent(new PassiveSkillEvent(PassiveSkillEvent.PLAYER_ON, skillId));
            }
            else
            {
                dispatchEvent(new PassiveSkillEvent(PassiveSkillEvent.FOE_ON, skillId));
            }
        }


        // パッシブスキル終了イベント
        public function offPassiveEvent(player:Boolean,skillId:int):void
        {
            if(player)
            {
                dispatchEvent(new PassiveSkillEvent(PassiveSkillEvent.PLAYER_OFF, skillId));
            }
            else
            {
                dispatchEvent(new PassiveSkillEvent(PassiveSkillEvent.FOE_OFF, skillId));
                if(skillId == RAGE_SKILL_NO)
                {
                    ragePassiveOff();
                }
            }
        }

        // 技発動条件更新イベント
        public function updateFeatConditionEvent(player:Boolean, chara_index:int, feat_index:int, condition:String):void
        {
            if(player)
            {
                dispatchEvent(new FeatConditionEvent(FeatConditionEvent.PLAYER_UPDATE, chara_index, feat_index, condition));
            }
            else
            {
                dispatchEvent(new FeatConditionEvent(FeatConditionEvent.FOE_UPDATE, chara_index, feat_index, condition));
            }
        }

        // アクションカードの値変更イベント pl
        public function plUpdateCardValueEvent(id:int, u_value:int, b_value:int, reset:Boolean):void
        {
            if (reset)
            {
                delete _overrideActionCards[id.toString()]
            }
            else
            {
                _overrideActionCards[id.toString()] = { "u_value":u_value, "b_value":b_value }
            }
            dispatchEvent(new UpdateCardValueEvent(UpdateCardValueEvent.PLAYER_UPDATE, id, u_value, b_value, reset));
        }

        // アクションカードの値変更イベント foe
        public function foeUpdateCardValueEvent(id:int, u_value:int, b_value:int, reset:Boolean):void
        {
            if (reset)
            {
                delete _overrideActionCards[id.toString()]
            }
            else
            {
                _overrideActionCards[id.toString()] = { "u_value":u_value, "b_value":b_value }
            }
        }

        public function hasOverrideActionCard(k:String):Boolean
        {
            return _overrideActionCards.hasOwnProperty(k);
        }

        public function getOverrideActionCardValues(k:String):Object
        {
            return _overrideActionCards[k];
        }

        public function stuffedToysSetEvent(player:Boolean, num:int):void
        {
            if(player)
            {
                _plStuffedToysNum = num;
                dispatchEvent(new StuffedToysSetEvent(StuffedToysSetEvent.PLAYER_SET, num));
            }
            else
            {
                _foeStuffedToysNum = num;
                dispatchEvent(new StuffedToysSetEvent(StuffedToysSetEvent.FOE_SET, num));
            }
        }

        // キャラを指定して状態異常を付加させるときのイベント
        public function buffCharaOnEvent(player:Boolean, buffId:int, value:int, turn:int, idx:int, limit:int = 0):void
        {
            if(player)
            {
                dispatchEvent(new BuffEvent(BuffEvent.PLAYER_IDX, buffId, value, turn, idx));
            }
            else
            {
                dispatchEvent(new BuffEvent(BuffEvent.FOE_IDX, buffId, value, turn, idx, limit));
            }
        }

        // 状態異常が付加されたときのイベント
        public function buffOnEvent(player:Boolean, buffId:int, value:int, turn:int, index:int, limit:int = 0):void
        {
            if(player)
            {
                dispatchEvent(new BuffEvent(BuffEvent.PLAYER, buffId, value, turn, index));
            }
            else
            {
                dispatchEvent(new BuffEvent(BuffEvent.FOE, buffId, value, turn, index ,limit));
            }
        }

        // 状態異常が消されたときのイベント
        public function buffOffEvent(player:Boolean, buffId:int, value:int, turn:int, index:int):void
        {
            if(player)
            {
                dispatchEvent(new BuffEvent(BuffEvent.PLAYER_OFF, buffId, value, turn, index));
            }
            else
            {
                dispatchEvent(new BuffEvent(BuffEvent.FOE_OFF, buffId, value, turn, index));
            }
        }

        // 状態異常が消されたときのイベント
        public function buffOffAllEvent(player:Boolean):void
        {
            if(player)
            {
                dispatchEvent(new BuffEvent(BuffEvent.PLAYER_OFF_ALL, 0, 0, 0));
            }
            else
            {
                dispatchEvent(new BuffEvent(BuffEvent.FOE_OFF_ALL, 0, 0, 0));
            }
        }


        // 状態異常がアップデートされたときのイベント
        public function buffUpdateEvent(player:Boolean, buffId:int, value:int, turn:int, index:int):void
        {
            if(player)
            {
                dispatchEvent(new BuffEvent(BuffEvent.PLAYER_UPDATE, buffId, value, turn, index));
            }
            else
            {
                dispatchEvent(new BuffEvent(BuffEvent.FOE_UPDATE, buffId, value, turn, index));
            }
        }

        // 猫状態がアップデートされたときのイベント
        public function catStateUpdateEvent(player:Boolean, index:int, value:Boolean):void
        {
            if(player)
            {
                if (!_playerCatState[index] && value)
                {
                    dispatchEvent(new CharaTransformEvent(CharaTransformEvent.PLAYER, true, CharaTransformEvent.TYPE_CAT));
                }
            }
            else
            {
                if (!_foeCatState[index] && value)
                {
                    dispatchEvent(new CharaTransformEvent(CharaTransformEvent.FOE, true, CharaTransformEvent.TYPE_CAT));
                }
            }
        }

        public function setCatState(player:Boolean, index:int, value:Boolean):void
        {
            if (player)
            {
                _playerCatState[index] = value;
            }
            else
            {
                _foeCatState[index] = value;
            }
        }

        public function isCat(player:Boolean, index:int):Boolean
        {
            if (player)
            {
                return _playerCatState[index];
            }
            else
            {
                return _foeCatState[index];
            }
        }

        public function getStuffedToysNum(player:Boolean):int
        {
            if (player)
            {
                return _plStuffedToysNum;
            }
            else
            {
                return _foeStuffedToysNum;
            }
        }

        public function currentCharaCardIsCat(player:Boolean):Boolean
        {
            if (player)
            {
                return _playerCatState[plEntrant.currentCharaCardIndex];
            }
            else
            {
                return _foeCatState[foeEntrant.currentCharaCardIndex];
            }
        }

        public function currentCharaCardIsControlled(player:Boolean):Boolean
        {
            if (player)
            {
                for each (var bc:BuffClip in _playerBuffClips[plEntrant.currentCharaCardIndex])
                         {
                             if (bc.no == Const.BUFF_CONTROL) return true;
                         }
            }
            else
            {
                for each (bc in _foeBuffClips[foeEntrant.currentCharaCardIndex])
                         {
                             if (bc.no == Const.BUFF_CONTROL) return true;
                         }
            }
            return false;
        }

        public function setPlayerBuffClips(index:int, clip:DuelCharaCardClip):void
        {
            _playerBuffClips[index] = clip.getBuffClips();
        }

        public function getPlayerBuffClips():Array
        {
            return _playerBuffClips;
        }

        public function setFoeBuffClips(index:int, clip:DuelCharaCardClip):void
        {
            _foeBuffClips[index] = clip.getBuffClips();
        }

        public function getFoeBuffClips():Array
        {
            return _foeBuffClips;
        }

        // ボスに状態異常をつけた場合
        public function bossBuffOnEvent(buffId:int, value:int, turn:int, limit:int):void
        {
            dispatchEvent(new BuffEvent(BuffEvent.BOSS, buffId, value, turn, 0, limit));
        }

        // 必殺技が解除されたときのイベント
        public function featSealedEvent(player:Boolean):void
        {
            if(player)
            {
                dispatchEvent(new FeatInfoEvent(FeatInfoEvent.PLAYER_FEAT_OFF_ALL, 0));
            }
            else
            {
            }
        }

        // ゲームの終了
        public function endGame(result:int, gems:int, exp:int, expBonus:int, gemsPow:int, expPow:int, totalGems:int, totalExp:int, bonus:Boolean):void
        {
            _foeCharaCards[0].unSetPower();     // By_K2 (무한의탑 종료시 POWER 초기화)

            _bonus = bonus;
            _state = END;
            dispatchEvent(new EndGameEvent(EndGameEvent.GAME_END,result, gems, exp, expBonus, gemsPow, expPow, totalGems, totalExp ));
            _inited = false;
            _isWatch = false;
            dispatchEvent(new Event(END));
        }

        // ゲームの終了
        public function endWatchGame():void
        {
            _state = END;
            _isWatch = false;
            _inited = false;
            dispatchEvent(new Event(END));
        }

        // ゲームの中断
        public function abortGame():void
        {
            _state = END;
            _inited = false;
            _isWatch = false;
            dispatchEvent(new Event(END));
        }

        public function get bonus():Boolean
        {
            return _bonus;
        }

        public function initializeDeck(size:int):void
        {
            log.writeLog(log.LV_INFO, this, "//////////////////////////////////duel deck initia", size);
            _deckSize = size;
            dispatchEvent(new Event(DECK_INIT));
        }

        public function resetDeck(size:int):void
        {
            // log.writeLog(log.LV_INFO, this, "//////////////////////////////////duel deck reset", size);
            _deckSize = size;
            dispatchEvent(new Event(DECK_RESET));
        }

        // ルールの設定
        public function setRule(rule:int):void
        {
            log.writeLog(log.LV_INFO, this, "//////////////////////////////////duel rule", rule);
            _rule = rule;
        }

        // ルールの設定
        public function get rule():int
        {
            return _rule;
        }

        // By_K2 (퀘스트인지 체크)
        public function setQuestRule(rule:Boolean):void
        {
            _ruleQuest = rule;
        }
        
        public function set deckSize(i:int):void
        {
            _deckSize = i;
//            dispatchEvent(new Event(DECK_UPDATE));
        }

        public function get deckSize():int
        {
            return _deckSize;
        }

        public function get state():String
        {
            return _state;
        }

        public function get turn():int
        {
            return _turn;
        }
        public function get initi():Boolean
        {
            return _initi;
        }
        public function get bTurn():int
        {
            return _bTurn;
        }

        public function get plDameges():Array
        {
            return _plDamages;
        }

        public function get foeDameges():Array
        {
            return _foeDamages;
        }

        public function isAttack():Boolean
        {
            return ((!((_bTurn==0)||_initi))||((_bTurn==0)&&_initi));
        }

        public function get distance():int
        {
            return _distance;
        }

        public function get truth_distance():int
        {
            return _truth_distance;
        }

        public function setInitiative(initi:Boolean):void
        {
            _initi = initi;
        }

        public function setDistance(d:int):void
        {
            if (d == 0) return;

            _distance = d;
            foeEntrant.distance = d;
            plEntrant.distance = d;
            dispatchEvent(new Event(DISTANCE_UPDATE));

        }

        public function setHideDistance(d:int):void
        {
            _truth_distance = d;
            dispatchEvent(new HideMoveEvent(HideMoveEvent.HIDE_MOVE, d));
        }

        public function get attakType():int
        {
            var d:int
            if (plEntrant.inFog)
            {
                d = _truth_distance;
            }
            else
            {
                d = _distance;
            }

            if (d == 1)
            {
                return ATK_TYPE_SWORD;
            }else{
                return ATK_TYPE_ARROW;
            }
        }


        public function get resultMovePoint():int
        {
            return _resultMovePoint;
        }

        public function set resultMovePoint(d:int):void
        {
            _resultMovePoint = d;
        }

        public function get playerCharaCards():Array
        {
            return _playerCharaCards;
        }

        public function get playerCharaCard():CharaCard
        {
            // エントラントが作られていない場合は0番目のカードを返す
            if(plEntrant!=null)
            {
                return _playerCharaCards[plEntrant.currentCharaCardIndex];
            }
            else
            {
                return _playerCharaCards[0];
            }
        }

        public function get foeCharaCards():Array
        {
            return _foeCharaCards;
        }

        public function get foeCharaCard():CharaCard
        {
            // エントラントが作られていない場合は0番目のカードを返す
            if(foeEntrant!=null)
            {
                return _foeCharaCards[foeEntrant.currentCharaCardIndex];
            }
            else
            {
                return _foeCharaCards[0];
            }
        }

        public function get foeLastCharaCard():CharaCard
        {
            // エントラントが作られていない場合は0番目のカードを返す
            if(foeEntrant!=null)
            {
                return _foeCharaCards[_foeCharaCards.length-1];
            }
            else
            {
                return _foeCharaCards[0];
            }
        }

        public function setRaidScore(i:int):void
        {
            _raidScore = i;
            updateRaidScore();
        }

        public function get raidScore():int
        {
            return _raidScore;
        }

        // 正体不明だったキャラカードをアップデートする
        public function updateUnknownCharaCard(player:Boolean, index:int, cardId:int):void
        {
            //log.writeLog(log.LV_FATAL, this, "CHARA UPDATE IS ",player,index,cardId);
            if(player)
            {
                // 観戦中で、キャラカードが不明なら差し替える
                if ( _isWatch && _playerCharaCards[index] && _playerCharaCards[index].id == 0)
                {
                    _playerCharaCards[index] = CharaCard.ID(cardId);
                    log.writeLog(log.LV_FATAL, this, "HP UPDATE IS ",_playerCharaCards[index].hp);
                    plEntrant.loadingCC = false;
                    new UpdateHPThread(_playerCharaCards[index], plEntrant.updateCharaCardHp, index).start();
                }
            }
            else
            {
                // キャラカードが不明なら差し替える
                if(_foeCharaCards[index] && _foeCharaCards[index].id == 0)
                {
                    _foeCharaCards[index] = CharaCard.ID(cardId);
//                    foeEntrant.updateCharaCardHp(index, _foeCharaCards[index].hp);
                    log.writeLog(log.LV_FATAL, this, "HP UPDATE IS ",_foeCharaCards[index].hp);
                    foeEntrant.loadingCC = false;
                    new UpdateHPThread(_foeCharaCards[index], foeEntrant.updateCharaCardHp, index).start();
                }
            }
        }


//         public function shiftEvent():String
//         {
//             e:Event = _eventArray.shift();
//             dispatchEvent(e);
//             return (e.type);

//         }

        public function get inited():Boolean
        {
            return _inited;
        }
        public function get reward():Reward
        {
            return _reward;
        }

        public function get stage():int
        {
            return _stage;
        }

        public function get isWatch():Boolean
        {
            return _isWatch;
        }
        public function set isWatch(isWatch:Boolean):void
        {
            _isWatch = isWatch;
        }

        public function get raidBoss():Boolean
        {
            return _raidBoss;
        }

        public function get isDetermineMovePhase():Boolean
        {
            return _isDetermineMovePhase;
        }

        public function playerStayHealDone():void
        {
            _playerStayHealDone = true;
        }

        public function get fieldStatus():Array
        {
            return _fieldStatus;
        }

    }
}


import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import model.CharaCard;
import model.*;
// キャラカードのロードをまってEntrantを作るスレッド
class CreateEntrant extends Thread
{
    private var _ca:Array;
    public function CreateEntrant(ca:Array)
    {
        _ca = ca;
    }

    protected override function run():void
    {
        var pExec:ParallelExecutor = new ParallelExecutor();
        log.writeLog(log.LV_FATAL, this, "!!!!!!!!!!!!!!!!!!!create entrant!!!!", _ca);

        for(var i:int = 0; i < _ca.length; i++)
        {
            for(var j:int = 0; j < _ca[i].length; j++)
            {
                var x:CharaCard = _ca[i][j];
                pExec.addThread(x.getLoader());
            }
        }

        pExec.start();
        pExec.join();
        next(close);
    }

    private function close ():void
    {
        log.writeLog(log.LV_INFO, this, "create entrant!!!!");
        Duel.instance.createEntrant();
    }
}

// キャラカードのロードをまってHPを読み込むスレッド
class UpdateHPThread extends Thread
{
    private var _cc:CharaCard;
    private var _func:Function;
    private var _index:int;

    public function UpdateHPThread(cc:CharaCard, func:Function, index:int)
    {
        _cc = cc;
        _func =func;
        _index = index;
    }

    protected override function run():void
    {
        // キャラカードの準備を待つ
        if (_cc.loaded == false)
        {
            _cc.wait();
        }
        next(init);
    }

    private function init():void
    {
        log.writeLog(log.LV_INFO, this, "hp update");
       _func(_index, _cc.hp);
    }
}
