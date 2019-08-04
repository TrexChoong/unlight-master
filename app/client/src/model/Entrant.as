package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    import model.events.*;
    /**
     * デュエル参加者クラス
     *
     *
     */
    public class Entrant  extends BaseModel
    {
        /**
         * カードの配置
         *
         */
        public static const DEALED:String = 'dealed';

        /**
         * 移動カードの決定
         *
         */
        public static const INIT_DONE:String = 'init_done';

        /**
         * 移動の決定
         *
         */
        public static const MOVE_DONE:String = 'move_done';

        /**
         * キャラ変更の決定
         *
         */
        public static const CHANGE_DONE:String = 'change_done';

        /**
         * 攻撃カードの決定
         *
         */
        public static const ATTACK_DONE:String = 'attack_done';

        /**
         * 防御カードの決定
         *
         */
        public static const DEFFENCE_DONE:String = 'deffence_done';

        /**
         * 移動カードの決定の成功
         *
         */
        public static const INIT_DONE_SUCCES:String = 'init_done_success';
        /**
         * 攻撃カードの決定の成功
         *
         */
        public static const ATTACK_DONE_SUCCES:String = 'attack_done_success';

        /**
         * 防御カードの決定の成功
         *
         */
        public static const DEFFENCE_DONE_SUCCES:String = 'deffence_done_succes';

        /**
         * 戦闘ポイントの更新
         *
         */
        public static const POINT_UPDATE:String = 'point_update';


        /**
         * 移動方向の更新
         *
         */
        public static const DIRECTION_UPDATE_SUCCESS:String = 'direction_update_success';


        /**
         * カードを捨てる
         *
         */
        public static const SWEEP_CARD:String = 'sweep_card';


        /**
         * 装備を更新
         *
         */
        public static const UPDATE_WEAPON_BONUS:String = 'update_weapon_bonus';

        /**
         * パッシブスキルを更新
         *
         */
        public static const UPDATE_PASSIVE_SKILL:String = 'update_passive_skill';

        public static const TABLE_HAND:int = 0;
        public static const TABLE_MOVE:int = 1;
        public static const TABLE_BATTLE:int = 2;
        
        public static const DIRECTION_STAY:int  = 0;
        public static const DIRECTION_FORWARD:int  = -1;
        public static const DIRECTION_CHANGE:int  = 3;
        public static const DIRECTION_BACKWARD:int  = 1;


        protected var _loadingCC:Boolean = true;

        private var _cardsMax:int;
        protected var _cards:Array = []; // Array of ActionCard

        protected var _hitPoints:Array = [];

        private var _currentCharaCardIndex:int = 0;           // 戦闘で使用中のキャラカードインデックス
        private var _weaponBonuses:Array = [[],[],[]];        // 武器カードボーナス
        private var _weaponPassiveSkills:Array = [[],[],[]];        // 武器カードパッシブスキル

        private var _movePoint:int = 0;
        protected var _moveTable:Array = []; // Array of ActionCard

        private var _initDone:Boolean =false;
        private var _initPoint:int;

        private var _moveDone:Boolean = false;
        private var _distance:int = 0;

        private var _changeDone:Boolean = true;    // falseなときにクライアント側でキャラ変更を行う

        private var _battlePoint:int = 0;
        protected var _battleTable:Array = []; // Array of ActionCard
        private var _attackDone:Boolean = false;
        private var _deffenceDone:Boolean = false;

        private var _attackType:int = ActionCard.SWD;
        private var _tmpPower:int = 0;
        public  var uid:int = 0;

        private var _direction:int = DIRECTION_STAY;

        public static var UID:int;
        private var _inFog:Boolean = false;

        // コンストラクタ

        public function Entrant(charaCards:Array, damages:Array=null, cardMax:int = 5)
        {
            // log.writeLog(log.LV_INFO, this, "!!!!!!!!!!!!!!!!!!!!!!");
            if (charaCards[0].loaded)
            {
                charaCards.forEach(function(item:*, index:int, array:Array):void{
                        // ダメージ済みなら適応する
                        if (damages !=null && damages[index]!=null){
                            _hitPoints.push(item.hp - damages[index]);
                        }else{
                            _hitPoints.push(item.hp);
                        }
                            });
                _cardsMax = cardMax;
            }
            else
            {
                if (charaCards.length ==1)
                {
                    throw new ArgumentError("CharaCard is not loaded. No."+charaCards[0].id);
                }else{
                    throw new ArgumentError("CharaCard is not loaded. No."+charaCards[0].id +"or"+charaCards[1].id+"or"+charaCards[2].id);
                }
            }
            UID +=1;
            uid = UID;
            log.writeLog(log.LV_FATAL, this, "+++ creat emtrant ", uid);
        }

        // カードが配られる(カードＩＤ)
        public function dealed(aca:Array):void
        {
            var a:Array =[];
            for(var i:int = 0; i < aca.length; i++){
              var x:int = aca[i];
                a.push(ActionCard.ID(x));
            }
            _cards =  _cards.concat(a);
        }

        public function setDirection(dir:int):void
        {
            dispatchEvent(new DirectionEvent(DirectionEvent.UPDATE,dir));
        }

        public function get direction():int
        {
            return _direction;
        }

        public function get inFog():Boolean
        {
            return _inFog;
        }

        public function set inFog(f:Boolean):void
        {
            _inFog = f;
        }

        public function setDirectionSuccess(dir:int):void
        {
            _direction = dir;
            dispatchEvent(new Event(DIRECTION_UPDATE_SUCCESS));
        }

        // 移動カードを出す
        public function moveCardAdd(ac:ActionCard, dir:Boolean = true,index:int = 0):void
        {
            var i:int = cards.indexOf(ac);
            var j:int = _moveTable.indexOf(ac);
            if (i<0)
            {
                if (j<0)
                {
                    throw new ArgumentError("ActionCard is not dealed. No." + ac.id);
                }
            }
            else
            {
                dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.ADD_MOVE_TABLE, ac, i));
            }
        }


        // 移動カードを出すのに成功
        public function moveCardAddSuccess(ac:ActionCard, dir:Boolean, index:int = 0):void
        {
            if (index != -1)
            {
                replaceCard(ac, cards, _moveTable);
            }
            dispatchEvent(new CardSuccessEvent(CardSuccessEvent.MOVE_ADD, ac.id, index, dir));
        }


        // 移動カードを引っ込める
        public function moveCardRemove(ac:ActionCard,  index:int = 0):void
        {
            var i:int = _moveTable.indexOf(ac);
            if (i<0)
            {
                throw new ArgumentError("ActionCard is not Added Table. No." + ac.id);
            }
            else
            {
                dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.REMOVE_MOVE_TABLE, ac, i));
            }
        }


        // 移動カードを引っ込めるのに成功
        public function moveCardRemoveSuccess(ac:ActionCard, dir:Boolean, index:int = 0):void
        {
            if (index != -1)
            {
                replaceCard(ac, _moveTable, cards);
            }
            dispatchEvent(new CardSuccessEvent(CardSuccessEvent.MOVE_REMOVE, ac.id, index, ac.up));
        }



        // 攻撃カードを回転させる
        public function cardRotate(ac:ActionCard, dir:Boolean, table:int=0, index:int = 0):void
        {
            var i:int = cards.indexOf(ac);
            var j:int = _moveTable.indexOf(ac);
            var k:int = _battleTable.indexOf(ac);
            var idx:int = index;
            var tbl:int = table;
            if ((i!=-1)||(j!=-1)||(k!=-1))
            {
                idx = (int(i!=-1)*i)||(int(j!=-1)*j)||(int(k!=-1)*k);
                tbl = (int(i!=-1)*TABLE_HAND)||(int(j!=-1)*TABLE_MOVE)||(int(k!=-1)*TABLE_BATTLE);
                dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.ROTATE, ac, idx, tbl));
            }
            else
            {
                throw new ArgumentError("ActionCard is not dealed. No." + ac.id);
            }
        }


        // 現在の移動ポイントを返す
        public function get movePoint():int
        {
            _movePoint = 0;
            _moveTable.forEach(function(item:*, index:int, array:Array):void{_movePoint += item.movePoint();});
            return _movePoint;
        }


        // イニシアチブフェイズの終了
        public function initDone():void
        {
            if (!_initDone)
            {
                dispatchEvent(new Event(INIT_DONE));
                _initDone = true;
                _moveTable.splice(0);
            }
        }

        // 攻撃カードを出す
        public function battleCardAdd(ac:ActionCard, dir:Boolean, index:int =0):void
        {
        }

        // 攻撃カードを引っ込める
        public function battleCardRemove(ac:ActionCard, index:int= 0):void
        {
        }

        // 攻撃カードを出す
        public function attackCardAdd(ac:ActionCard, dir:Boolean, index:int = 0):void
        {
            var i:int = cards.indexOf(ac);
            if (i<0)
            {
                throw new ArgumentError("ActionCard is not dealed. No." + ac.id);
            }
            else
            {
                dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.ADD_ATTACK_BATTLE_TABLE, ac, i));
            }
        }


        // 攻撃カードを引っ込める
        public function attackCardRemove(ac:ActionCard, index:int = 0):void
        {
            var i:int = _battleTable.indexOf(ac);
            if (i<0)
            {
                throw new ArgumentError("ActionCard is not Added Table. No." + ac.id);
            }
            else
            {
                dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.REMOVE_ATTACK_BATTLE_TABLE, ac, i));
            }
        }

        // 防御カードを出す
        public function deffenceCardAdd(ac:ActionCard, dir:Boolean, index:int = 0):void
        {
            var i:int = cards.indexOf(ac);
            if (i<0)
            {
                throw new ArgumentError("ActionCard is not dealed. No." + ac.id);
            }
            else
            {
             dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.ADD_DEFFENCE_BATTLE_TABLE, ac, index));
            }
        }

        // 防御カードを引っ込める
        public function deffenceCardRemove(ac:ActionCard, index:int = 0):void
        {
            var i:int = _battleTable.indexOf(ac);
            if (i<0)
            {
                throw new ArgumentError("ActionCard is not Added Table. No." + ac.id);
            }
            else
            {
                 dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.REMOVE_DEFFNCE_BATTLE_TABLE, ac, i));
            }
        }

        // 戦闘カードを出すのに成功
        public function battleCardAddSuccess(ac:ActionCard, dir:Boolean, index:int = 0):void
        {
            if (index != -1)
            {
//                ac.rotate(dir);
                replaceCard(ac, _cards, _battleTable);
            }
            dispatchEvent(new CardSuccessEvent(CardSuccessEvent.BATTLE_ADD, ac.id, index, ac.up));
        }


        // 戦闘カードを引っ込めるのに成功
        public function battleCardRemoveSuccess(ac:ActionCard, dir:Boolean, index:int = 0):void
        {
            if (index != -1)
            {
//                ac.rotate(dir);
                replaceCard(ac, _battleTable, cards);
            }
            dispatchEvent(new CardSuccessEvent(CardSuccessEvent.BATTLE_REMOVE, ac.id, index, ac.up));
        }



        // カードを手札から捨てる
        public function cardsSweep(ac:Array /* of ActionCard */ ):void
        {
            log.writeLog(log.LV_DEBUG, this, "cardSweep ============= 捨てるカードの引数ac:", ac);
            // 捨てるカードのアクティビティをオフにする
            log.writeLog(log.LV_DEBUG, this, "battleTableのカードのアクティビティを切っておく。size:", _battleTable.length);
            _battleTable.forEach(function(item:*, index:int, array:Array):void{
                    if (ac.indexOf(item) !=-1)
                    {log.writeLog(log.LV_DEBUG, this, "cardSweep", item.id, "アクティビティを切る");
                        item.activate(false)}
                });
            _moveTable.forEach(function(item:*, index:int, array:Array):void{
                    if (ac.indexOf(item) !=-1)
                    {item.activate(false)}
                });

            // テーブル上のカードを捨てる
            _battleTable = _battleTable.filter(function(item:*, index:int, array:Array):Boolean {
                    log.writeLog(log.LV_DEBUG,this, "falseのカードを捨てる", item.id, ac.indexOf(item) == -1);
                    return (ac.indexOf(item) ==-1)});
            log.writeLog(log.LV_DEBUG, this, "捨てた後のテーブルサイズ:", _battleTable.length);
            _moveTable = _moveTable.filter(function(item:*, index:int, array:Array):Boolean {return (ac.indexOf(item) ==-1)});
            // 手札から捨てたものを取り除く(ここイベント送ったほうがいいかも)
            _cards = _cards.filter(function(item:*, index:int, array:Array):Boolean {return (ac.indexOf(item) ==-1)});
            // log.writeLog(log.LV_FATAL , this, "moveTAble sweep", _moveTable);
            // log.writeLog(log.LV_FATAL , this, "battTAble sweep", _battleTable);
        }
        // カードを手札から強制的に捨てる (裏表示のまま捨てる場合)
        public function blankCardSweep(ac:Array /* of ActionCard */ ):void
        {
            // log.writeLog(log.LV_FATAL , this, "blankCardSweep", ac.length,_cards.length);
            // 配列個数分捨てる
            for ( var i:int = 0; i < ac.length; i++ ) {
                _cards.shift();
            }
        }

        // // カードをテーブルから捨てる
        // public function tableSweep(ac:Array /* of ActionCard */ ):void
        // {
        //     // 捨てるカードのアクティビティをオフにする
        //     _battleTable.forEach(function(item:*, index:int, array:Array):void{
        //             if (ac.indexOf(item) !=-1)
        //             {item.activate(false)}
        //         });
        //     _moveTable.forEach(function(item:*, index:int, array:Array):void{
        //             if (ac.indexOf(item) !=-1)
        //             {item.activate(false)}
        //         });

        //     // テーブル上のカードを捨てる
        //     _battleTable = _battleTable.filter(function(item:*, index:int, array:Array):Boolean {return (ac.indexOf(item) ==-1)});
        //     _moveTable = _moveTable.filter(function(item:*, index:int, array:Array):Boolean {return (ac.indexOf(item) ==-1)});
        //     // 手札から捨てたものを取り除く(ここイベント送ったほうがいいかも)
        //     _cards = _cards.filter(function(item:*, index:int, array:Array):Boolean {return (ac.indexOf(item) ==-1)});
        //     // log.writeLog(log.LV_FATAL , this, "moveTAble sweep", _moveTable);
        //     // log.writeLog(log.LV_FATAL , this, "battTAble sweep", _battleTable);
        // }


        // リムーブに成功（本来はIDによって同期すべきだ）
        public function removeSuccess(i:int):void
        {
            // 手札のアクティビティを消す
            _cards.forEach(function(item:*, index:int, array:Array):void{item.activate(false)});
        }


        // 現在の移動ポイントを返す
        public function get battlePoint():int
        {
            return _battlePoint;
        }

        // 現在の移動ポイントに代入
        public function updateBattlePoint(i:int):void
        {
            _battlePoint = i;
            dispatchEvent(new Event(POINT_UPDATE));
        }



        // 攻撃の終了
        public function attackDone():void
        {
            if (!_attackDone)
            {
                dispatchEvent(new Event(ATTACK_DONE));
                _attackDone =true;
            }
        }

        // 防御の終了
        public function deffenceDone():void
        {
            if (!_deffenceDone)
            {
                dispatchEvent(new Event(DEFFENCE_DONE));
                _deffenceDone =true;
            }
        }

        // 攻撃の終了成功
        public function initDoneSuccess():void
        {
            dispatchEvent(new Event(INIT_DONE_SUCCES));
        }

        // 攻撃の終了成功
        public function attackDoneSuccess():void
        {
            dispatchEvent(new Event(ATTACK_DONE_SUCCES));
        }

        // 防御の終了
        public function deffenceDoneSuccess():void
        {
            dispatchEvent(new Event(DEFFENCE_DONE_SUCCES));
        }


        // カードの入れ替え
        protected function replaceCard(card:ActionCard, src:*, dist:*):void
        {
            var i:int = src.indexOf(card);
            if (i>-1)
            {
                src.splice(i,1);
                dist.push(card);
            }
            log.writeLog(log.LV_TEST, this, "replce card", i , src, _cards);
        }

        // 移動の終了
        public function moveDone(i:int):void
        {
            if (!_moveDone)
            {
                _distance = i;
                _moveDone = true;
                dispatchEvent(new Event(MOVE_DONE));
            }
        }

        // キャラチェンジフラグの設定
        public function setChangeDone(b:Boolean):void
        {
            _changeDone = b;
        }

        // キャラチェンジフラグの取得
        public function getChangeDone():Boolean
        {
            return _changeDone;
        }

        public function get hitPoint():int
        {
            return _hitPoints[currentCharaCardIndex];
        }

        public function get cards():Array
        {
            return _cards;
        }

        public function get moveTable():Array
        {
            return _moveTable;
        }

        public function get battleTable():Array
        {
            return _battleTable;
        }

        public function get currentCharaCardIndex():int
        {
            return _currentCharaCardIndex;
        }

        public function get currentWeaponPassiveSkill():Array
        {
            return _weaponPassiveSkills[currentCharaCardIndex];
        }

        public function get weaponPassiveskills():Array
        {
            return _weaponPassiveSkills;
        }

        public function get currentWeaponBonus():Array
        {
            return _weaponBonuses[currentCharaCardIndex];
        }

        public function get weaponBonuses():Array
        {
            return _weaponBonuses;
        }

        public function get liveCharaCardIndex():int
        {
            return _hitPoints.indexOf(_hitPoints.filter(function(item:int, index:int, array:Array):Boolean{return item > 0})[0]);
        }

        public function get distance():int
        {
            return _distance;
        }

        public function set distance(dis:int):void
        {
             _distance = dis;
        }

        public function get cardsMax():int
        {
            return _cardsMax;
        }

        public function set loadingCC(b:Boolean):void
        {
            _loadingCC = b;
        }

        public function get loadingCC():Boolean
        {
            return _loadingCC;
        }

        // 正体不明だったキャラカードのＨＰをアップデートする
        public function updateCharaCardHp(index:int, hp:int):void
        {
            var decHp:int = _hitPoints[index] < 0 ? _hitPoints[index] : 0;
            _hitPoints[index] = hp + decHp;
            _loadingCC = true;
            notifyAll();
        }

        public function updateCardsMax(i:int):void
        {
            log.writeLog(log.LV_FATAL, this, "CARDS MAX UPDATE ", i);
             _cardsMax = i;
        }

        public function damage(i:int,is_not_hostile:Boolean):void
        {
            _hitPoints[currentCharaCardIndex] -= i;
            log.writeLog(log.LV_FATAL, this, "+++ entarnt go event damage", i,uid);
            dispatchEvent(new DamageEvent(DamageEvent.DAMAGE, i, 0, is_not_hostile));
        }

        public function revive(index:int, rhp:int):void
        {
            _hitPoints[index] = rhp;
            dispatchEvent(new DamageEvent(DamageEvent.REVIVE, rhp, index));
        }

        public function constraint(flag:uint):void
        {
            dispatchEvent(new ConstraintEvent(ConstraintEvent.CONSTRAINT, flag));
        }

        public function heal(i:int):void
        {
            _hitPoints[currentCharaCardIndex] += i;
            dispatchEvent(new DamageEvent(DamageEvent.HEAL,i));
        }

        public function partyHeal(index:int, i:int):void
        {
            _hitPoints[index] += i;
            if(index == currentCharaCardIndex)
            {
                dispatchEvent(new DamageEvent(DamageEvent.HEAL, i));
            }
            else
            {
                dispatchEvent(new DamageEvent(DamageEvent.PARTY_HEAL,i, index));
            }
        }

        public function hitPointChange(hp:int):void
        {
            _hitPoints[currentCharaCardIndex] = hp;
            dispatchEvent(new DamageEvent(DamageEvent.CHANGE,hp));
        }

        public function partyDamage(index:int, i:int, is_not_hostile:Boolean):void
        {
            _hitPoints[index] -= i;
            if(index == currentCharaCardIndex)
            {
                dispatchEvent(new DamageEvent(DamageEvent.DAMAGE, i, index, is_not_hostile));
            }
            else
            {
                dispatchEvent(new DamageEvent(DamageEvent.PARTY_DAMAGE, i, index, is_not_hostile));
            }
        }

        // キャラを変更する
        public function charaChange(index:int):void
        {
            dispatchEvent(new CharaChangeEvent(CharaChangeEvent.CHARA_CHANGE, index));
        }

        // キャラ変更に成功
        public function charaChangeSuccess(index:int, cardId:int, weaponBonus:Array):void
        {
            // キャラが変更されたらフラグを立てる
            if(index != _currentCharaCardIndex)
            {
                log.writeLog(log.LV_INFO, this, "chara change index is", index, weaponBonus);
                _currentCharaCardIndex = index;
                _weaponBonuses[index] = weaponBonus;
                weaponPassiveSkillsUpdate();
                dispatchEvent(new CharaChangeEvent(CharaChangeEvent.SUCCESS, index));
            }
        }

        // キャラを変更する
        public function changeDone():void
        {
            if(!_changeDone)
            {
                log.writeLog(log.LV_INFO, this, "chara change done!");
                _changeDone = true;
                dispatchEvent(new Event(CHANGE_DONE));
            }
        }

        // 装備補正を更新
        public function updateWeaponBonus(plBonus:Array, foeBonus:Array):void
        {
            _weaponBonuses = plBonus;
            weaponPassiveSkillsUpdate();
            dispatchEvent(new Event(UPDATE_WEAPON_BONUS));
        }

        public function weaponPassiveSkillsUpdate():void
        {
            _weaponPassiveSkills = [];
            weaponBonuses.forEach(function(wb:*, index:int, array:Array):void{
                    var passive_ids:Array = [];
                    if (wb[8])
                    {
                        if (wb[8] is Array)
                        {
                            passive_ids = wb[8];
                        }
                        else
                        {
                            passive_ids.push(wb[8]);
                        }
                    }

                    var passive:PassiveSkill;
                    var passiveSkills:Array=[];

                    passive_ids.forEach(function(pid:*, index:int, array:Array):void{
                            if (!pid) return;
                            passive = PassiveSkill.ID(pid);
                            passiveSkills.push(passive);
                        });
                    _weaponPassiveSkills.push(passiveSkills);
                });
        }

        public function trapAction(kind:int,distance:int):void
        {
            dispatchEvent(new TrapActionEvent(TrapActionEvent.ACTION, kind, distance));
        }

        public function trapUpdate(kind:int,distance:int,turn:int,visible:Boolean):void
        {
            dispatchEvent(new TrapActionEvent(TrapActionEvent.UPDATE, kind, distance, turn, visible));
        }

        // ターンのはじめにフラグを全部リセット
        public function flagReset():void
        {
            _initDone = false;
            _moveDone = false;
            _deffenceDone = false;
            _attackDone = false;
        }

        public function battleFlagReset():void
        {
            _deffenceDone = false;
            _attackDone = false;
        }

    }
}
