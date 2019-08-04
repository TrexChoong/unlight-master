package view.scene.game
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.filters.GlowFilter;
    import flash.utils.*;

    import mx.core.UIComponent;
    import mx.containers.Box;
    import mx.controls.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.ActionCard;
    import model.Duel;
    import view.ClousureThread;
    import view.SleepThread;
    import view.image.game.*;
    import view.scene.BaseScene;
    import view.utils.*;
    import controller.*;
    import view.utils.*;


    /**
     * ActionCardClip表示クラス
     *
     */

    public class ActionCardClip  extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_DIST_N	:String = "近接";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIST_L	:String = "遠距離";
        CONFIG::LOCALE_JP
        private static const _TRANS_TYPE_DEF	:String = "防御";
        CONFIG::LOCALE_JP
        private static const _TRANS_TYPE_MOV	:String = "移動";
        CONFIG::LOCALE_JP
        private static const _TRANS_TYPE_SPE	:String = "特殊";
        CONFIG::LOCALE_JP
        private static const _TRANS_TYPE_EVENT	:String = "イベント";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_ACTION	:String = "--アクションカード--\nキャラクターの行動力です。攻撃力や必殺技に影響します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_EVENT	:String = "--イベントカード--\n";

        CONFIG::LOCALE_EN
        private static const _TRANS_DIST_N	:String = "Short Range";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIST_L	:String = "Long Range";
        CONFIG::LOCALE_EN
        private static const _TRANS_TYPE_DEF	:String = "Defense";
        CONFIG::LOCALE_EN
        private static const _TRANS_TYPE_MOV	:String = "Move";
        CONFIG::LOCALE_EN
        private static const _TRANS_TYPE_SPE	:String = "Special";
        CONFIG::LOCALE_EN
        private static const _TRANS_TYPE_EVENT	:String = "Event";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_ACTION	:String = "--Action card--\nDetermines a character's movement power, which in turn influences their attack power and special attacks.";
        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_EVENT	:String = "--Event Card--\n";

        CONFIG::LOCALE_TCN
        private static const _TRANS_DIST_N	:String = "近距離";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIST_L	:String = "遠距離";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TYPE_DEF	:String = "防禦";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TYPE_MOV	:String = "移動";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TYPE_SPE	:String = "特殊";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TYPE_EVENT	:String = "事件";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_ACTION	:String = "－－行動卡－－\n人物的行動力。影響到攻擊力跟必殺技。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_EVENT	:String = "－－事件卡－－\n";

        CONFIG::LOCALE_SCN
        private static const _TRANS_DIST_N	:String = "近距离";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIST_L	:String = "远距离";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TYPE_DEF	:String = "防御";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TYPE_MOV	:String = "移动";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TYPE_SPE	:String = "特殊";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TYPE_EVENT	:String = "活动";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_ACTION	:String = "－－活动卡－－\n角色的行动力。对攻击力及必杀技有影响。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_EVENT	:String = "－－活动卡－－\n";

        CONFIG::LOCALE_KR
        private static const _TRANS_DIST_N	:String = "근접";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIST_L	:String = "원거리";
        CONFIG::LOCALE_KR
        private static const _TRANS_TYPE_DEF	:String = "방어";
        CONFIG::LOCALE_KR
        private static const _TRANS_TYPE_MOV	:String = "이동";
        CONFIG::LOCALE_KR
        private static const _TRANS_TYPE_SPE	:String = "특수";
        CONFIG::LOCALE_KR
        private static const _TRANS_TYPE_EVENT	:String = "이벤트";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_ACTION	:String = "--액션 카드--\n캐릭터의 행동력 입니다.공격력과 필살기에 영향을 미칩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_EVENT	:String = "--이벤트 카드--\n";

        CONFIG::LOCALE_FR
        private static const _TRANS_DIST_N	:String = "Courte portée";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIST_L	:String = "Longue portée";
        CONFIG::LOCALE_FR
        private static const _TRANS_TYPE_DEF	:String = "Défense";
        CONFIG::LOCALE_FR
        private static const _TRANS_TYPE_MOV	:String = "Déplacement";
        CONFIG::LOCALE_FR
        private static const _TRANS_TYPE_SPE	:String = "Spécial";
        CONFIG::LOCALE_FR
        private static const _TRANS_TYPE_EVENT	:String = "Evénement";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_ACTION	:String = "-- Carte Action --\nReprésente les AP d'un personnage. Définit les AP et points d'attaque spéciale";
        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_EVENT	:String = "-- Carte événement --\n";

        CONFIG::LOCALE_ID
        private static const _TRANS_DIST_N	:String = "近接";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIST_L	:String = "遠距離";
        CONFIG::LOCALE_ID
        private static const _TRANS_TYPE_DEF	:String = "防御";
        CONFIG::LOCALE_ID
        private static const _TRANS_TYPE_MOV	:String = "移動";
        CONFIG::LOCALE_ID
        private static const _TRANS_TYPE_SPE	:String = "特殊";
        CONFIG::LOCALE_ID
        private static const _TRANS_TYPE_EVENT	:String = "イベント";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_ACTION	:String = "--アクションカード--\nキャラクターの行動力です。攻撃力や必殺技に影響します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_EVENT	:String = "--イベントカード--\n";

        CONFIG::LOCALE_TH
        private static const _TRANS_DIST_N  :String = "ระยะใกล้";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIST_L  :String = "ระยะไกล";
        CONFIG::LOCALE_TH
        private static const _TRANS_TYPE_DEF    :String = "ป้องกัน";
        CONFIG::LOCALE_TH
        private static const _TRANS_TYPE_MOV    :String = "เคลื่อนที่";
        CONFIG::LOCALE_TH
        private static const _TRANS_TYPE_SPE    :String = "พิเศษ";
        CONFIG::LOCALE_TH
        private static const _TRANS_TYPE_EVENT  :String = "อีเวนท์";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_ACTION :String = "-- แอคชั่นการ์ด --\nพลังในการเคลื่อนไหวของการ์ด มีผลต่อพลังโจมตีและท่าไม้ตาย";
        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_EVENT  :String = "-- อีเวนท์การ์ด --\n";


//        private static const TYPE:Array = ["","近接", "遠距離", "防御", "移動", "特殊", "イベント"];
        private static const TYPE:Array = ["",_TRANS_DIST_N, _TRANS_DIST_L, _TRANS_TYPE_DEF, _TRANS_TYPE_MOV, _TRANS_TYPE_SPE, _TRANS_TYPE_EVENT];
        // # 0:ブランク,1:近接 2:遠距離, 3:防御, 4:移動 5:特殊, 6:イベント
//         BLNK, SWD, ARW, DEF, MOVE, SPC, EVT = (0..6).to_a

        private static var __cards:Object ={};        // ロード済みのカードクリップ
        private static var __checkList:Dictionary = new Dictionary(true);        // ロード済みのカードクリップ

        private static var __colorSet:Vector.<GlowFilter> = Vector.<GlowFilter>([
                                                                                            new GlowFilter(0xFFFFFF,0.5, 3.0, 3.0, 2, 2,true), // なし
                                                                                            new GlowFilter(0xFFFFFF,1.0, 7.0, 7.0, 3, 2,true), // 白
                                                                                            new GlowFilter(0x000000,1.0, 7.0, 7.0, 3, 2,true), // 黒
                                                                                            new GlowFilter(0xFF0000,1.0, 7.0, 7.0, 3, 2,true), // 赤
                                                                                            new GlowFilter(0x00FF00,1.0, 7.0, 7.0, 3, 2,true), // 緑
                                                                                            new GlowFilter(0x0000FF,1.0, 7.0, 7.0, 3, 2,true), // 青
                                                                                            new GlowFilter(0xFFFF00,1.0, 7.0, 7.0, 3, 2,true), // 黄
                                                                                            new GlowFilter(0xFF00FF,1.0, 7.0, 7.0, 3, 2,true)  // 紫
                                                                                            ]);

        // 移動中を表すフラグ（ここプライベートにする）
        public var moved:Boolean = false;
        private var _uContainer:UIComponent = new UIComponent(); // 上部コンテナ
        private var _bContainer:UIComponent = new UIComponent(); // 下部コンテナ
        private var _frame:ActionCardFrame;
        private var _button:ActionCardButton;
        private var _uValue:ActionCardValue = new ActionCardValue(ActionCard.SWD);
        private var _bValue:ActionCardValue = new ActionCardValue(ActionCard.SWD);
        private var _eValue:EventCardValue;

        private var _eventFilter:GlowFilter = new GlowFilter(0xFFFFDD,1.0, 7.0, 7.0, 3, 2,true);;

        private var _captionText:TextArea = new TextArea();

        private var _flip:Boolean = false; // 裏か表か
        private var _lergeFlip:Boolean = false; // 裏か表か
        private var _locked:Boolean = false; //ロック状態か

        private var _points:int;

        private var _id:int;
        private var _ac:ActionCard;
        private var _rotateFunc:Function;

        private var _setButton:Boolean = false;

        private var _clickOn:Boolean  =false;

        private var _onTable:Boolean = false;
        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["--アクションカード--\nキャラクターの行動力です。攻撃力や必殺技に影響します。"],   // 0
                [_TRANS_HELP_ACTION],   // 0
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int = 0;
        private var _rewritten:Boolean = false;

//        private var _foe:Boolean;

        // アクションカードのIDからクリップを作って返す。作成済みならそれを返す。
        public static function getInstance(id:int):ActionCardClip
        {
            if (__cards[id] == null)
            {
                __cards[id] =  new ActionCardClip(ActionCard.ID(id));
//                Unlight.GCW.watch(__cards[id]);
            }
            __cards[id].resetButton();
            __cards[id].init();
            return __cards[id];
        }

        // ブランクのアクションカードをつくって返す。
        public static function getBlankCardInstance():ActionCardClip
        {
            return new ActionCardClip(ActionCard.ID(0));
        }

        // ブランクのアクションカードをつくって返す。(手元用)
        public static function getLergeBlankCardInstance():ActionCardClip
        {
            return new ActionCardClip(ActionCard.ID(0),true);
        }

        public static function clearCache():void
        {
//            log.writeLog(log.LV_FATAL, "Clear start ActionCardClip",__cards);
            for (var key:Object in __cards)
            {
//              log.writeLog(log.LV_FATAL, "Clear start ActionCardClip",key);
                RemoveChild.apply(__cards[key]);
                __cards[key].final();
                delete __cards[key];
            }
            __cards = {};
        }

        public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
//             log.writeLog(log.LV_FATAL,this, "ADD EVENT LISTENER", type, _id.toString(),useWeakReference.toString());

            super. addEventListener(type,listener,useCapture,priority, true);
        }

        public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
//             log.writeLog(log.LV_FATAL,this, "REMOVE EVENT LISTENER", type,_id.toString());
            super. removeEventListener(type,listener,useCapture);
        }

        public static  function eventChcek():void
        {
            for (var key:Object in __checkList) {
                log.writeLog(log.LV_FATAL, __checkList[key],"EVENT CHECK ACC", "click:", key.hasEventListener("click"),
                             "mouseOver:" , key.hasEventListener("mouseOver"), "mouseOut:" , key.hasEventListener("mouseOut")

                    );
                log.writeLog(log.LV_FATAL, __checkList[key],"EVENT CHECK ACC", "click:", key.willTrigger("click"), "mouseOver:" , key.willTrigger("mouseOver"));
                if (key.parent !=null)
                {
                    log.writeLog(log.LV_FATAL, __checkList[key],"EVENT CHECK ACC", key.parent);
                }
                key.final();
            }


        }



        /**
         * コンストラクタ
         *
         */
        public function ActionCardClip(ac:ActionCard,isLerge:Boolean=false)
        {
//          log.writeLog(log.LV_FATAL, this, "create at ac id",ac.id.toString());
//          Unlight.GCW.watch(this,ac.id.toString());
            __checkList[this] = ac.id.toString();
            _ac = ac;
            _id = ac.id;
            _frame = new ActionCardFrame();
            addChild(_frame);
            addChild(_uContainer);
            addChild(_bContainer);
            _lergeFlip = isLerge;
            _button = new ActionCardButton();
            _button.visible = false;
            // idが0なら裏表示なので、ボタンを出さない
            if ( _id != 0 ) {
                addChild(_button);
                _setButton = true;
            }
            if (_ac.loaded)
            {
                setCardInfo(_ac)
            }else
            {
                _ac.addEventListener(ActionCard.INIT, acInitHandler);
            }
            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);
//             Unlight.GCW.watch(_frame);
//             Unlight.GCW.watch(_uContainer);
//             Unlight.GCW.watch(_bContainer);
//             Unlight.GCW.watch(_button);
        }

        public function loaded():Boolean
        {
            return _frame.loaded;
        }

        public function resetButton():void
        {
            if (!_setButton) {
                addChild(_button);
            }
        }
        public function removeButton():void
        {
            if (_setButton) {
                RemoveChild.apply(_button);
            }
        }

        override public function init():void
        {
            _ac.addEventListener(ActionCard.ROTATE, acRotateHandler);
            _ac.addEventListener(ActionCard.EVENT_ROTATE, acEventRotateHandler);
            _ac.addEventListener(ActionCard.ON, acOnHandler);
        }
        override public function final():void
        {
            _ac.removeEventListener(ActionCard.INIT, acInitHandler);
            _ac.removeEventListener(ActionCard.ROTATE, acRotateHandler);
            _ac.removeEventListener(ActionCard.EVENT_ROTATE, acEventRotateHandler);
            _ac.removeEventListener(ActionCard.ON, acOnHandler);
            removeRotateButtonHandler();
            RemoveChild.apply(_frame);
            RemoveChild.apply(_uContainer);
            RemoveChild.apply(_bContainer);
            RemoveChild.apply(_button);
            _rotateFunc = null;
            _frame = null;
            _uContainer = null;
            _bContainer = null;
            _button = null;
        }



        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);
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

        public function updateCardValue(u_value:int, b_value:int):void
        {
            _uValue.atValue(u_value);
            _bValue.atValue(b_value);
            _rewritten = true;
        }

        public function resetCardValue():void
        {
            if (_ac.image =="")
            {
                if (_ac.uType != 0)
                {
                    _uValue.atValue(_ac.uValue);
                }
                if (_ac.bType != 0)
                {
                    _bValue.atValue(_ac.bValue);
                }
            }
            _rewritten = false;
        }

        public function isRewritten():Boolean
        {
            return _rewritten;
        }

        private function setCardInfo(ac:ActionCard):void
        {
            if ((ac.uType != 0)&&(ac.image ==""))
            {
                _uValue = new ActionCardValue(ac.uType);
                _uValue.atValue(ac.uValue);
                _uContainer.addChild(_uValue);
            }
            if ((ac.bType != 0)&&(ac.image ==""))
            {
                _bValue = new ActionCardValue(ac.bType);
                _bValue.atValue(ac.bValue);
                _bContainer.addChild(_bValue);
            }

            if (ac.uType == 6)
            {
//                _eValue = new EventCardValue(ac.image);
//                _uContainer.addChild(_eValue);
//                _helpTextArray[_GAME_HELP][0] = "--イベントカード--\n"+ac.caption;
                CONFIG::RELEASE
                {
                    _helpTextArray[_GAME_HELP][0] = _TRANS_HELP_EVENT+ac.caption;
                }
                this.filters = [__colorSet[0]];
            }

            if (ac.image !="")
            {
                    _eValue = new EventCardValue(ac.image);
                    _eValue.atValue(ac.uValue);
                    _uContainer.addChild(_eValue);
                    RemoveChild.apply(_bValue);
                    RemoveChild.apply(_uValue);
            }

            if (ac.caption !="")
            {
//                _helpTextArray[_GAME_HELP][0] = "--イベントカード--\n"+ac.caption;
                _helpTextArray[_GAME_HELP][0] = _TRANS_HELP_EVENT+ac.caption;
                this.filters = [__colorSet[0]];
            }

            CONFIG::DEBUG
            {
                _helpTextArray[_GAME_HELP][0] = _TRANS_HELP_EVENT+ac.caption+"id:"+ _id.toString();
            }

            _bContainer.rotation = 180;
            mouseChildren = true;
            updateActivity()
        }

        public function updateCardInfo(ac:ActionCard):void
        {
//            log.writeLog(log.LV_FATAL, this, "acticon carrrrrrd1!", _ac.id, ac.id);
            if (_ac.id != ac.id)
            {
                _ac.removeEventListener(ActionCard.ROTATE, acRotateHandler);
                _ac.removeEventListener(ActionCard.EVENT_ROTATE, acEventRotateHandler);
                _ac.removeEventListener(ActionCard.ON, acOnHandler);
                _ac.removeEventListener(ActionCard.INIT, acInitHandler);

                _ac = ac;
                _ac.addEventListener(ActionCard.ROTATE, acRotateHandler);
                _ac.addEventListener(ActionCard.EVENT_ROTATE, acEventRotateHandler);
                _ac.addEventListener(ActionCard.ON, acOnHandler);
                removeAllChildren(_uContainer);
                removeAllChildren(_bContainer);
                setCardInfo(ac);
                changeBlankToID(this);
            }
        }

        private function disposeEvent():void
        {
                _ac.removeEventListener(ActionCard.ROTATE, acRotateHandler);
                _ac.removeEventListener(ActionCard.EVENT_ROTATE, acEventRotateHandler);
                _ac.removeEventListener(ActionCard.ON, acOnHandler);
                _ac.removeEventListener(ActionCard.ROTATE, acOnHandler);
        }

        private static function changeBlankToID (acc:ActionCardClip):void
        {
            var i:int = acc.ac.id;
//          log.writeLog(log.LV_FATAL, "BlankToID!!!!!", "create at ac id",i.toString());

//          Unlight.GCW.watch(acc,i.toString());
            __checkList[acc] = i.toString();
            // 古いカードを削除すべきか・
             if (__cards[i] != null)
             {
//                  if (__cards[i].parent){__cards[i].parent.removeChild(__cards[i]);}
//                  __cards[i].disposeEvent();
                 RemoveChild.apply(__cards[i])
                 __cards[i].final();
//               Unlight.GCW.watch(__cards[i],"deleted one:"+i.toString());
//               log.writeLog(log.LV_FATAL, "static ActionCard", "OLD CARD DELETE",i);
             }
             __cards[i] = acc;
        }
        private function removeAllChildren(u:UIComponent):void
        {
            var num:int = u.numChildren;
            for(var i:int = 0; i < num; i++)
            {
                u.removeChildAt(i);
            }
        }

        private function acInitHandler(e:Event):void
        {
            setCardInfo(ActionCard(_ac));
            _ac.removeEventListener(ActionCard.INIT, acInitHandler);
        }

        private function setLabelConfig(item:*, index:int, array:Array):void
        {
            item.styleName = "ActionCardParam";
            item.width = 60;
            item.height = 20;
        }

        private function currentRotation():Boolean
        {
            if (rotation == 0)
            {
                return true;
            }else{
                return false;
            }
        }


        private function acRotateHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "RotateHandaler go");
            if (up !=  currentRotation())
            {
                 rotateTween().start();
            }
        }

        private function acEventRotateHandler(e:Event):void
        {
            if (up !=  currentRotation())
            {
                valueOff();
                GameCtrl.instance.addNoWaitViewSequence(rotateTween());
                GameCtrl.instance.addNoWaitViewSequence( new SleepThread(300));
            }
        }

        public function setButtonVisible(v:Boolean):void
        {
            if (v){_button.arrowBlinkStop()}
            _button.visible = v;
            if (!v){arrowUpdate()}
            updateArrowDir();

        }

        public function arrowUpdate():void
        {
            var t:int;
            t = currentRotation()? _ac.uType:_ac.bType;
            // log.writeLog(log.LV_INFO, this, "ARROW UPDATE",t, Duel.instance.state,Duel.instance.distance,_onTable );
            // テーブルに有るときとクリック出来ないのときなにもしない。
            if (_onTable||!_clickOn)
            {
                return;
            }

            if (Duel.instance.state == Duel.MOVE_CARD_DROP_PHASE_START)
            {
                if(t == ActionCard.MOVE )
                {
                    _button.arrowBlinkStart();
                }else{
                    _button.arrowBlinkStop();
                }

            }
            else if (Duel.instance.state == Duel.BATTLE_CARD_DROP_ATTACK_PHASE_START)
            {
                if((t == ActionCard.SWD && Duel.instance.distance == 1)||(t == ActionCard.ARW && Duel.instance.distance > 1) )
                {
                    _button.arrowBlinkStart();
                }else{
                    _button.arrowBlinkStop();
                }

            }
            else if (Duel.instance.state == Duel.BATTLE_CARD_DROP_DEFFENCE_PHASE_START)
            {
                if(t == ActionCard.DEF)
                {
                    _button.arrowBlinkStart();
                }else{
                    _button.arrowBlinkStop();
                }

            }else{
                _button.arrowBlinkStop();
            }
        }



        public function valueOff():void
        {
                _uValue.onMark = false;
                _bValue.onMark = false;
                if (_eValue != null)
                {
                    _eValue.onMark = false;
                    _eValue.onMarkUp = false;
                }
        }

        public function valueOn():void
        {
            if (currentRotation())
            {
                _uValue.onMark = true;
                _bValue.onMark = false;
            }else{
                _uValue.onMark = false;
                _bValue.onMark = true;
            }
            if (_eValue != null)
            {
                if (currentRotation())
                {
                    _eValue.onMark = true;
                    _eValue.onMarkUp = false;
                }
                else
                {
                    _eValue.onMark = false;
                    _eValue.onMarkUp = true;
                }
            }

        }


        private function updateActivity():void
        {
            log.writeLog(log.LV_DEBUG, this, "* * * * * * ", cardID);
            log.writeLog(log.LV_INFO, this, "Update Activite");
            if (_ac.on)
            {
                valueOn();
            }else
            {
                valueOff();
//                arrowUpdate();
            }
        }
        private function acOnHandler(e:Event):void
        {
            updateActivity();
        }

        // 回転Tween
        private function rotateTween():Thread
        {
            clickOff();
            var i:int;
            if (up){i = 0;}else{i = 180};
            updateArrowDir();
            arrowUpdate();
//            if (up){i = 0;}else{i = 180;};
//            new TweenerThread(this, { rotation: i, transition:"easeOutSine", time: 0.2, show: true}).start();
            new BeTweenAS3Thread(this, {rotation:i}, null, 0.2 / Unlight.SPEED , BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true).start();
            SE.getRotateCardSEThread(0).start();
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new SleepThread(150));
            sExec.addThread(new ClousureThread(clickOn));
            sExec.addThread(new ClousureThread(updateActivity));
            return sExec;
        }

        // 相手側用強制回転Tween
        public function forceRotateTween():void
        {
            var i:int;
//            if (up){i = 0;}else{i = 180;};
            (rotation==0)? i=180:i=0
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new ClousureThread(clickOff));
//            sExec.addThread(new TweenerThread(this, { rotation: i, transition:"easeOutSine", time: 0.2, show: true}));
            sExec.addThread(new BeTweenAS3Thread(this, {rotation:i}, null, 0.2 / Unlight.SPEED , BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            sExec.addThread(new ClousureThread(clickOn));
            sExec.addThread(new ClousureThread(updateActivity));
            sExec.start();
        }

        public function clickOn():void
        {
            _clickOn = true;
            if (hitTestPoint(stage.mouseX,stage.mouseY))
            {
                _button.visible = true;
            }
            arrowUpdate();
        }

        public function clickOff():void
        {
            _clickOn = false;
            _button.visible = false;
        }


        // 相手用回転（方向が逆になる）
        public function foeRotate(inv:Boolean = false):void
        {
            var i:int;
            if (inv){i = 0;}else{i = 180;};
            rotation = i;
        }

        public function lockCard():void
        {
            _locked = true;
        }

        public function setLarge(isLarge:Boolean):void
        {
            _lergeFlip = isLarge;
        }

        public function set flip(value:Boolean):void
        {
            if (value==true)
            {
                if ( _locked ) {
                    if ( _lergeFlip ) {
                        _frame.lLock();
                    } else {
                        _frame.lock();
                    }
                } else if ( _lergeFlip ) {
                    _frame.onLReverse();
                } else {
                    _frame.onReverse();
                }
            }
            else
            {
                _frame.onObverse();
            }

            _uContainer.visible = !_lergeFlip ? value:false ;
            _bContainer.visible = !_lergeFlip ? value:false ;
            _flip = !_lergeFlip ? value:false ;
            if (_lergeFlip) _lergeFlip = false;
        }

        public function get locked():Boolean
        {
            return _locked;
        }

        public function unlock():void
        {
            _locked = false;
        }

        public function get flip():Boolean
        {
            return _flip;
        }

        public function get cardID():int
        {
            return _ac.id;
        }

        public function get up():Boolean
        {
            return _ac.up;
        }

        public function get ac():ActionCard
        {
            return _ac;
        }

        public function setDealStartPoint(x:int, y:int, flip:Boolean, alpha:Number, visible:Boolean):void
        {
            valueOff();
            this.x = x;
            this.y = y;
            this.flip = flip;
            this.alpha = alpha;
            this.visible = visible;
            var i:int;
            if (up){i = 0;}else{i = 180;};
            this.rotation = i;
        }
        public function setRotateButtonHandler(func:Function):void
        {
            _rotateFunc = func;
            _button.registRotateHandler(rotateButonnHandler);
        }

        private function rotateButonnHandler(e:Event):void
        {
            e.stopPropagation();
            _rotateFunc(ac, up)
        }

        public function removeRotateButtonHandler():void
        {
            if (_button) {
                _button.disposeRotateHandler();
            }
            _rotateFunc = null;
        }

        public function setOnTable(on:Boolean):void
        {
            _onTable = on;
//            updateArrowDir();
        }

        private function updateArrowDir():void
        {
            var rotUp:int = _onTable ? 180:0;
            var rotDown:int = _onTable ? 0:180;
            if (up){_button.rotation = rotUp;}else{ _button.rotation = rotDown;};
        }
    }

}
