package model
{
    import model.PassiveSkill;
    import model.WeaponCard;
    import model.WeaponCardInventory;
    import model.events.*;

    import flash.events.EventDispatcher;
    import flash.events.Event;

    /**
     * 合成クラス
     *
     *
     */
    public class Combine extends BaseModel
    {
        // シングルトンインスタンス
        private static var __instance:Combine;

        // イベント
        public static const START:String = 'start';                              // 開始
        public static const COMBINES:String = 'conbines';                // 系統樹を表示
        public static const SELECT_CARD:String = 'select_card';                  // カードを選択
        public static const WAITING:String = 'waiting';                          // 待機状態にする
        public static const END:String = 'end';                                  // 開始

        // カード関連
        private var _resultCardId:int;
        private var _resultCardInvId:int = 40491;

        // ステータス
        private var _state:String = '';

        // 合成前カードステータス群
        private var _prevInvId:int = 0;
        private var _prevBaseSap:int = 0;
        private var _prevBaseSdp:int = 0;
        private var _prevBaseAap:int = 0;
        private var _prevBaseAdp:int = 0;
        private var _prevBaseMax:int = 0;
        private var _prevAddSap:int = 0;
        private var _prevAddSdp:int = 0;
        private var _prevAddAap:int = 0;
        private var _prevAddAdp:int = 0;
        private var _prevAddMax:int = 0;
        private var _prevLevel:int = 0;
        private var _prevExp:int = 0;
        private var _prevIsSpecial:Boolean = false;
        private var _prevPsvNumMax:int = 0;
        private var _passiveSkillMax:int = 3;
        private var _passiveSkills:Vector.<Object> = Vector.<Object>([{"id":0,"name":"","cnt":0},{"id":0,"name":"","cnt":0},{"id":0,"name":"","cnt":0}]); // 暫定三つ
        private var _prevWeaponCard:WeaponCard;

        /**
         * シングルトンインスタンスを返すクラス関数
         *
         *
         */
        public static function get instance():Combine
        {
            if( __instance == null )
            {
                __instance = createInstance();
            }
            return __instance;
        }

        // 本当のコンストラクタ
        private static function createInstance():Combine
        {
            return new Combine(arguments.callee);
        }

        // コンストラクタ
        public function Combine(caller:Function)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
        }

        // ステートを取得する
        public function get state():String
        {
            return _state;
        }

        // 初期化
        public function initialize():void
        {
            // _resultCardId = 0;
            // _resultCardInvId = 0;
            log.writeLog(log.LV_DEBUG, this,"initialize");
            dispatchEvent(new Event(START));
        }

        // 合成の表示
        public function combines():void
        {
            _state = COMBINES;
            dispatchEvent(new Event(COMBINES));
        }

        // カードの合成
        public function combine(invIdList:Array):void
        {
            log.writeLog(log.LV_DEBUG, this,"combine");
            _prevInvId = invIdList[0]; // 先頭のベースカードを保持
            setPrevCardParams();
            log.writeLog(log.LV_DEBUG, this,"combine 1");
            dispatchEvent(new CombineEvent(CombineEvent.COMBINE, invIdList.join(",")));
        }

        // カードの合成に成功
        public function combineSuccess(cardId:int,invId:int):void
        {
            log.writeLog(log.LV_DEBUG, this,"combineSuccess");
            _resultCardId = cardId;
            _resultCardInvId = invId;

            _state = WAITING;
            dispatchEvent(new CombineEvent(CombineEvent.COMBINE_SUCCESS));
        }

        // 待つ
        public function waiting():void
        {
            _state = WAITING;
            dispatchEvent(new Event(WAITING));
        }

        // 終了時
        public function finalize():void
        {
            dispatchEvent(new Event(END));
        }

        public function get resultCardId():int
        {
            return _resultCardId;
        }
        public function get resultCardInvId():int
        {
            return _resultCardInvId;
        }

        private function setPrevCardParams():void
        {
            var wci:WeaponCardInventory = WeaponCardInventory.getInventory(_prevInvId);
            var wc:WeaponCard = WeaponCard(wci.card);
            _prevBaseSap = wc.baseSap;
            _prevBaseSdp = wc.baseSdp;
            _prevBaseAap = wc.baseAap;
            _prevBaseAdp = wc.baseAdp;
            _prevBaseMax = wc.baseMax;
            _prevAddSap = wc.addSap;
            _prevAddSdp = wc.addSdp;
            _prevAddAap = wc.addAap;
            _prevAddAdp = wc.addAdp;
            _prevAddMax = wc.addMaxParam;
            _prevLevel = (wc.level <= 0) ? 1 : wc.level; // レベル0の場合は1として表示
            _prevExp = wc.exp;
            _prevIsSpecial = wc.isCharaSpecial;
            _prevPsvNumMax = wc.passiveNumMax;
            var passiveId:Array = wc.passiveId;
            var weaponPassiveNum:int = wc.weaponPassiveNum;
            var passiveNum:int = wc.passiveNum;
            for (var i:int = 0; i < _passiveSkills.length; i++) {
                if (passiveId[i]) {
                    var skill:PassiveSkill = PassiveSkill.ID(passiveId[i]);
                    if (i < weaponPassiveNum) {
                        _passiveSkills[i] = {"id":skill.id,"name":skill.name,"cnt":0}
                    } else {
                        var psvIdx:int = i - weaponPassiveNum;
                        var useCnt:int = (wc.getUseCnt(psvIdx)>0) ? wc.getUseCnt(psvIdx) : 0;
                        _passiveSkills[i] = {"id":skill.id,"name":skill.name,"cnt":useCnt}
                    }
                } else {
                    _passiveSkills[i] = {"id":0,"name":"","cnt":0}
                }
            }
            _prevWeaponCard = wc.copyThis();
        }

        public function get prevBaseMax():int
        {
            return _prevBaseMax;
        }
        public function getPrevBaseParamIdx(idx:int):int
        {
            var params:Array = [_prevBaseSap,_prevBaseSdp,_prevBaseAap,_prevBaseAdp];
            return params[idx];
        }
        public function get prevAddMax():int
        {
            return _prevAddMax;
        }
        public function getPrevAddParamIdx(idx:int):int
        {
            var params:Array = [_prevAddSap,_prevAddSdp,_prevAddAap,_prevAddAdp];
            return params[idx];
        }
        public function get prevPassiveSkills():Vector.<Object>
        {
            return _passiveSkills;
        }
        public function get prevLevel():int
        {
            return _prevLevel;
        }
        public function get prevExp():int
        {
            return _prevExp;
        }
        public function get prevIsCharaSpecial():Boolean
        {
            return _prevIsSpecial;
        }
        public function get prevPassiveNumMax():int
        {
            return _prevPsvNumMax;
        }
        public function get prevWeaponCard():WeaponCard
        {
            return _prevWeaponCard;
        }
   }
}