package view.image.game
{

    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.controls.Text;
    import mx.controls.Label;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import view.image.BaseImage;
    import view.utils.*;

    /**
     * CharaCardFrame表示クラス
     *
     */

    public class CharaCardFrame extends BaseImage
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_ATK	:String = "攻撃";
        CONFIG::LOCALE_JP
        private static const _TRANS_DEF	:String = "防御";
        CONFIG::LOCALE_JP
        private static const _TRANS_MOV	:String = "移動";

        CONFIG::LOCALE_EN
        private static const _TRANS_ATK	:String = "Attack";
        CONFIG::LOCALE_EN
        private static const _TRANS_DEF	:String = "Defense";
        CONFIG::LOCALE_EN
        private static const _TRANS_MOV	:String = "Move";

        CONFIG::LOCALE_TCN
        private static const _TRANS_ATK	:String = "攻擊";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DEF	:String = "防禦";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MOV	:String = "移動";

        CONFIG::LOCALE_SCN
        private static const _TRANS_ATK	:String = "攻击";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DEF	:String = "防御";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MOV	:String = "移动";

        CONFIG::LOCALE_KR
        private static const _TRANS_ATK	:String = "공격";
        CONFIG::LOCALE_KR
        private static const _TRANS_DEF	:String = "방어";
        CONFIG::LOCALE_KR
        private static const _TRANS_MOV	:String = "이동";

        CONFIG::LOCALE_FR
        private static const _TRANS_ATK	:String = "Attaque";
        CONFIG::LOCALE_FR
        private static const _TRANS_DEF	:String = "Défense";
        CONFIG::LOCALE_FR
        private static const _TRANS_MOV	:String = "Déplacement";

        CONFIG::LOCALE_ID
        private static const _TRANS_ATK	:String = "攻撃";
        CONFIG::LOCALE_ID
        private static const _TRANS_DEF	:String = "防御";
        CONFIG::LOCALE_ID
        private static const _TRANS_MOV	:String = "移動";

        CONFIG::LOCALE_TH
        private static const _TRANS_ATK :String = "โจมตี";
        CONFIG::LOCALE_TH
        private static const _TRANS_DEF :String = "ป้องกัน";
        CONFIG::LOCALE_TH
        private static const _TRANS_MOV :String = "เคลื่อนที่";

        // CharaCardFrame表示元SWF
        [Embed(source="../../../../data/image/ccframe_a.swf")]
        private var _Source:Class;

        private var _yPosition:Array = [];                    // Array of int
        private var _yPositionPassive:Array = [];                    // Array of int

        private static const _FEAT_INVENTRY:Array = ["tab0", "tab1", "tab2", "tab3"];
        private static const _PASSIVE_INVENTORY:Array = ["skill_p0","skill_p1","skill_p2","skill_p3"];
        private static const _PASSIVE_BASE:String = "base_passive";
        private static const _TAB_A:String = "tab_skill_a";
        private static const _TAB_B:String = "tab_skill_b";

        private var _featInventory0MC:MovieClip;
        private var _featInventory1MC:MovieClip;
        private var _featInventory2MC:MovieClip;
        private var _featInventory3MC:MovieClip;
        private var _passiveInventory0MC:MovieClip;
        private var _passiveInventory1MC:MovieClip;
        private var _passiveInventory2MC:MovieClip;
        private var _passiveInventory3MC:MovieClip;
        private var _passiveBaseMC:MovieClip;
        private var _tabA_SB:SimpleButton;
        private var _tabB_SB:SimpleButton;

        private static const _FEAT_NAME_X:int = 4;
        private static const _FEAT_NAME_Y:int = 22;
        private static const _PASSIVE_NAME_X:int = 6;
        private static const _PASSIVE_NAME_Y:int = 26;
        private static const _FEAT_NAME_HEIGHT:int = 18;
        private static const _FEAT_NAME_WIDTH:int = 140;
        private static const _FEAT_NAME_INTERVAL:int = 30;

        private static const _FEAT_CAPTION_X:int = 4;
        private static const _FEAT_CAPTION_Y:int = 38;
        private static const _FEAT_CAPTION_HEIGHT:int =100;
        private static const _FEAT_CAPTION_WIDTH:int = 160;
        private static const _FEAT_CAPTION_INTERVAL:int = 35;
        private static const _FEAT_INVENTORY_PADDING_TOP:int = 70;

        private static const _FEAT_VALUE_X:int = 65;
        private static const _FEAT_VALUE_Y:int = 25;
        private static const _FEAT_VALUE_INTERVAL:int = 20;
        private static const _CONDITION_PADDING_TOP:int = 27;
        private static const _CAPTOPN_PADDING_TOP:int = 18;
        private static const _PASSIVE_CAPTION_PADDING_TOP:int = 21;
        private static const _PASSIVE_NAME_HEIGHT:int = 65;

        private static const _FEAT_MAX:int = 4;

        // フレーム番号
        private var _frameNo:int = 0;

        // 選択中の必殺技の番号
        private var _featNo:int = -1;
        // 必殺技の最大数
        private var _featMax:int = 0;

        // 選択中のパッシブスキルの番号
        private var _passiveNo:int = -1;
        // パッシブスキルの最大数
        private var _passiveMax:int = 0;

        // 必殺技の情報
        private var _featsName:Array = [];                    // Array of Text
        private var _featsCaption:Array = [];                 // Array of Text
        private var _featsValue:Array = [];                   // Array of CharaCardFeatValue
        private var _featInventory:Array = [];                // Array of CharaCardFeatValue
        // 必殺技の表示を格納するコンテナ
        private var _featsContainers:Array = [];              // Array of UIComponent

        private var _passiveName:Array = [];                    // Array of Text
        private var _passiveCaption:Array = [];                 // Array of Text
        private var _passiveInventory:Array = [];
        private var _passiveContainers:Array = [];            // Array of UIComponent

        /**
         * コンストラクタ
         *
         */
        public function CharaCardFrame(featMax:int = 0, passiveMax:int = 0, frameNo:int = 1)
        {
            _frameNo = frameNo;
            _featMax = featMax;
            _passiveMax = passiveMax;
            super();
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            waitComplete(initializeFrame);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        // 初期化処理 1
        public function initializeFrame():void
        {
            _passiveBaseMC = MovieClip(_root.getChildByName(_PASSIVE_BASE));
            _passiveBaseMC.stop();
            _tabA_SB = SimpleButton(_root.getChildByName(_TAB_A));
            _tabB_SB = SimpleButton(_root.getChildByName(_TAB_B));

            _featInventory = [_featInventory0MC,_featInventory1MC,_featInventory2MC,_featInventory3MC];
            _passiveInventory = [_passiveInventory0MC,_passiveInventory1MC,_passiveInventory2MC,_passiveInventory3MC];
            _tabA_SB.visible = false;
            _tabB_SB.visible = false;
            _passiveBaseMC.visible = false;
            _passiveBaseMC.cacheAsBitmap = true;

            for(var i:int = 0; i < 4; i++){
                _featInventory[i] = MovieClip(_root.getChildByName(_FEAT_INVENTRY[i]));
                _featInventory[i].stop();
                if (i<_featMax)
                {
                    _featInventory[i].visible =true;
                    _featInventory[i].y -= _FEAT_CAPTION_INTERVAL*2-_FEAT_INVENTORY_PADDING_TOP;
                    //_featInventory[i].cacheAsBitmap = true;
                    _yPosition.push(_featInventory[i].y);

                }
                else{
                    RemoveChild.apply(_featInventory[i]);
                }

                _passiveInventory[i] = MovieClip(_root.getChildByName(_PASSIVE_INVENTORY[i]));
                _passiveInventory[i].stop();
                if (i<_passiveMax)
                {
                    _passiveInventory[i].visible =true;
                    _passiveInventory[i].y -= _FEAT_CAPTION_INTERVAL*2-_FEAT_INVENTORY_PADDING_TOP;
                    _passiveInventory[i].cacheAsBitmap = true;
                    _yPositionPassive.push(_passiveInventory[i].y);
                }
                else{
                    RemoveChild.apply(_passiveInventory[i]);
                }
            }

            // タブボタンクリック時のイベントを登録
            _tabA_SB.addEventListener(MouseEvent.CLICK, onTabAClick);
            _tabB_SB.addEventListener(MouseEvent.CLICK, onTabBClick);

            // フレームを設定
            _root.gotoAndStop(_frameNo);
        }

        // 後始末処理
        public  override function final():void
        {
//            _featInventory0MC.removeEventListener(MouseEvent.CLICK, featOpenHandler);
//            _featInventory1MC.removeEventListener(MouseEvent.CLICK, featOpenHandler);
//            _featInventory2MC.removeEventListener(MouseEvent.CLICK, featOpenHandler);
//            _featInventory3MC.removeEventListener(MouseEvent.CLICK, featOpenHandler);
//            _passiveInventory0MC.removeEventListener(MouseEvent.CLICK, passiveOpenHandler);
//            _passiveInventory1MC.removeEventListener(MouseEvent.CLICK, passiveOpenHandler);
//            _passiveInventory2MC.removeEventListener(MouseEvent.CLICK, passiveOpenHandler);
//            _passiveInventory3MC.removeEventListener(MouseEvent.CLICK, passiveOpenHandler);

            _featInventory.forEach(function(item:*, index:int, array:Array):void{if (item) {item.removeEventListener(MouseEvent.CLICK, featOpenHandler)}});
            _passiveInventory.forEach(function(item:*, index:int, array:Array):void{if (item) {item.removeEventListener(MouseEvent.CLICK, featOpenHandler)}});
            _featsName = null;
            _featsValue = null;
            _featsCaption =null;
            _featsContainers =null;

            _tabA_SB = null;
            _tabB_SB = null;

            RemoveChild.all(this);
        }

        public function get featsContainers():Array
        {
            return _featsContainers;
        }

        // 必殺技を追加
        public function addFeatContainer(name:String, caption:String):void
        {
            // 挿入index
            var index:int = _featsContainers.length;

            // コンテナを追加
            _featsContainers.push(new UIComponent());
            _featsContainers[index].y = _yPosition[index+2];
            _featsContainers[index].mouseEnabled = false;
            _featsContainers[index].doubleClickEnabled = false;
            _featsContainers[index].mouseChildren = false;
            addChild(featsContainers[index]);

            // 名前ラベルの設定
            _featsName.push(new Label());
            _featsName[index].width = _FEAT_NAME_WIDTH;
            _featsName[index].height = _FEAT_NAME_HEIGHT;
            _featsName[index].text = name;
            _featsName[index].x = _FEAT_NAME_X;
            _featsName[index].y = _FEAT_NAME_Y;
            _featsName[index].mouseEnabled = false;
            _featsName[index].doubleClickEnabled = false;
            _featsName[index].mouseChildren = false;
            _featsName[index].styleName = "CharaCardFeatNameLabel";
            //_featsName[index].filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1),];
            callLater(fontSizeAdjust,[_featsName[index]]);
            _featsContainers[index].addChild(_featsName[index]);

            // ラベルの設定
            _featsCaption.push(new Text());
            _featsCaption[index].width = _FEAT_CAPTION_WIDTH;
            _featsCaption[index].height = _FEAT_CAPTION_HEIGHT;
            _featsCaption[index].text = caption.slice(getCaptionStartIndex(caption)).replace(/\|/, "\n");
            _featsCaption[index].x = _FEAT_CAPTION_X;
            _featsCaption[index].y = _FEAT_CAPTION_Y + _FEAT_NAME_INTERVAL*(_FEAT_MAX-index-1) + _CAPTOPN_PADDING_TOP;
            _featsCaption[index].mouseEnabled = false;
            _featsCaption[index].doubleClickEnabled = false;
            _featsCaption[index].mouseChildren = false;
            _featsCaption[index].styleName = "CharaCardFeatInfoLabel";
            //_featsCaption[index].filters = [new GlowFilter(0x000000, 1, 1.1, 1.1, 256, 3),];
            _featsCaption[index].visible = false;
            callLater(fontSizeAdjustCaption,[_featsCaption[index]]);
            _featsContainers[index].addChild(_featsCaption[index]);
            // 必殺技の条件を配列にして保持しておく
            var str:Array = caption.slice(caption.indexOf("[")+1, getCaptionStartIndex(caption)-1).split(":");
            var strValue:Array = str[2].split(",");

            setFeatTiming(str[0]);

            setFeatDistance(str[1]);

            setFeatCondition(index, strValue);

            // 必殺技を開くイベントを設定
            _featInventory[_featsCaption.length-1].addEventListener(MouseEvent.CLICK, featOpenHandler);

            // 必殺技の説明を表示
            setFeatNo(index);
            if (index != 0 && index == _featMax-1)
            {
                setFeatNo(0);
            }
        }

        // 必殺技の発動タイミングの設定
        private function setFeatTiming(phaseStr:String):void
        {
            if(phaseStr == "攻撃")
            {
                _featInventory[_featsCaption.length-1].getChildByName("icon_phase").gotoAndStop(1);
            }
            else if(phaseStr == "防御")
            {
                _featInventory[_featsCaption.length-1].getChildByName("icon_phase").gotoAndStop(2);
            }
            else if(phaseStr == "移動")
            {
                _featInventory[_featsCaption.length-1].getChildByName("icon_phase").gotoAndStop(3);
            }
        }

        // 必殺技の有効距離設定
        private function setFeatDistance(distStr:String):void
        {
            if(distStr.match(/近/))
            {
                _featInventory[_featsCaption.length-1].getChildByName("icon_range0").gotoAndStop(2);
            }
            if(distStr.match(/中/))
            {
                _featInventory[_featsCaption.length-1].getChildByName("icon_range1").gotoAndStop(2);
            }
            if(distStr.match(/遠/))
            {
                _featInventory[_featsCaption.length-1].getChildByName("icon_range2").gotoAndStop(2);
            }
        }

        private function setFeatCondition(index:int, condArray:Array, overRide:Boolean=false):void
        {
            if (_featsContainers.length <= index) return;

            if (_featsContainers[index].numChildren > 2)
            {
                // featValueが既にあるときクリア
                for (var i:int = _featsContainers[index].numChildren-1; i > 1; i--)
                {
                    RemoveChild.apply(_featsContainers[index].getChildAt(i));
                }
            }

            // 必殺技の説明を追加
            _featsValue.push(new Array());

            // 発動条件アイコンの設定
            for(i = 0; i < condArray.length; i++)
            {
                // 必殺技の発動条件のタイプを設定する
                var type:int = -1;
                if (condArray[i].match(/\[(.+)\]/))
                {
                    var setStr:String = condArray[i].match(/\[(.+)\]/)[1];
                    if (setStr.length > 1)
                    {
                        type = CharaCardFeatValue.CMP;
                    }
                }
                else if(condArray[i].match(/近/))
                {
                    type = CharaCardFeatValue.SWD;
                }
                else if(condArray[i].match(/遠/))
                {
                    type = CharaCardFeatValue.GUN;
                }
                else if(condArray[i].match(/移/))
                {
                    type = CharaCardFeatValue.MOV;
                }
                else if(condArray[i].match(/特/))
                {
                    type = CharaCardFeatValue.STR;
                }
                else if(condArray[i].match(/防/))
                {
                    type = CharaCardFeatValue.SHD;
                }
                else if(condArray[i].match(/無/))
                {
                    type = CharaCardFeatValue.WLD;
                }
                // 数値属性を設定する
                var valueType:int = 0;
                if(condArray[i].match(/\+/))
                {
                    valueType = CharaCardFeatValue.VALUE_UP;
                }
                else if(condArray[i].match(/\-/))
                {
                    valueType = CharaCardFeatValue.VALUE_DOWN;
                }
                else
                {
                    valueType = CharaCardFeatValue.VALUE_EQUAL;
                }

                // 必殺技の条件を追加する
                if(type != -1)
                {
                    var value:int = int(condArray[i].match(/[0-9]/)[0]);
                    if (_featsContainers[index].numChildren > 2 + i)
                    {
                        // featValueが既にあるとき
                        _featsContainers[index].getChildAt(2+i).setValue(type, valueType, value);
                    }
                    else
                    {
                        // 新規でつくる場合
                        var featValue:CharaCardFeatValue = new CharaCardFeatValue(type, valueType, int(condArray[i].match(/[0-9]/)[0]));
                        featValue.x = _FEAT_VALUE_X + _featsValue[_featsValue.length-1].length * _FEAT_VALUE_INTERVAL - 1;
                        featValue.y = _FEAT_VALUE_Y + _CONDITION_PADDING_TOP;
                        _featsValue[_featsValue.length-1].push(featValue);
                        _featsContainers[index].addChild(featValue);
                    }
                }

                if (overRide)
                {
                    _featsName[index].styleName = "CharaCardFeatNameLabelBlue";
                }
            }
        }


        // キャプション本文の開始インデックスを返す
        private function getCaptionStartIndex(s:String):int
        {
            _featsValue.push(new Array());
            if (s.charAt(0) != "[") return 0;

            var cnt:int = 0;
            for (var i:int = 0; i < s.length; i++) {
                if (s.charAt(i) == "[")
                {
                    cnt += 1;
                }
                else if (s.charAt(i) == "]")
                {
                    cnt -= 1;
                    if (cnt == 0 && i < s.length - 1) return i + 1;
                }
            }

            return 0;
        }

        // パッシブスキルを追加
        public function addPassiveSkillContainer(name:String, caption:String):void
        {
            // 存在するときのみボタンを有効にする。
            _passiveBaseMC.visible = true;
            _tabB_SB.visible = true;

            // 挿入index
            var index:int = _passiveContainers.length;

            // コンテナを追加
            _passiveContainers.push(new UIComponent());
            _passiveContainers[index].y = _yPositionPassive[index+2];
            _passiveContainers[index].mouseEnabled = false;
            _passiveContainers[index].doubleClickEnabled = false;
            _passiveContainers[index].mouseChildren = false;
            addChild(_passiveContainers[index]);

            // 名前ラベルの設定
            _passiveName.push(new Label());
            _passiveName[index].width = _FEAT_NAME_WIDTH;
            _passiveName[index].height = _PASSIVE_NAME_HEIGHT;
            _passiveName[index].text = name;
            _passiveName[index].x = _PASSIVE_NAME_X;
            _passiveName[index].y = _PASSIVE_NAME_Y;
            _passiveName[index].mouseEnabled = false;
            _passiveName[index].doubleClickEnabled = false;
            _passiveName[index].mouseChildren = false;
            _passiveName[index].styleName = "CharaCardPassiveNameLabel";
            //_passiveName[index].filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1),];
            callLater(fontSizeAdjust,[_passiveName[index]]);
            _passiveContainers[index].addChild(_passiveName[index]);

            // キャプションの設定
            _passiveCaption.push(new Text());
            _passiveCaption[index].width = _FEAT_CAPTION_WIDTH;
            _passiveCaption[index].height = _FEAT_CAPTION_HEIGHT;
            _passiveCaption[index].text = caption.slice(getCaptionStartIndex(caption)).replace(/\|/, "\n");
            _passiveCaption[index].x = _FEAT_CAPTION_X;
            _passiveCaption[index].y = _FEAT_CAPTION_Y + _FEAT_NAME_INTERVAL*(_FEAT_MAX-index-1) + _CAPTOPN_PADDING_TOP;
            _passiveCaption[index].mouseEnabled = false;
            _passiveCaption[index].doubleClickEnabled = false;
            _passiveCaption[index].mouseChildren = false;
            _passiveCaption[index].styleName = "CharaCardPassiveInfoLabel";
            //_passiveCaption[index].filters = [new GlowFilter(0x000000, 1, 1.1, 1.1, 256, 3),];
            _passiveCaption[index].visible = false;
            _passiveContainers[index].addChild(_passiveCaption[index])


            // 必殺技を開くイベントを設定
            _passiveInventory[_passiveCaption.length-1].addEventListener(MouseEvent.CLICK, passiveOpenHandler);

            // 必殺技の説明を表示
            setPassiveNo(index);
            if (index != 0 && index == _passiveMax-1)
            {
                setPassiveNo(0);
            }

            _passiveInventory.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = false}});
            _passiveContainers.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = false}});
        }

        public function removePassiveBase():void
        {
            // 存在しない場合はリムーブする
            RemoveChild.apply(_passiveBaseMC);
            RemoveChild.apply(_tabB_SB);
        }

        // 名前が全部はいるように調整
        private function fontSizeAdjust(label:Label):void
        {
            var w:int = label.width;
            label.validateNow();
            while (label.textWidth > w-3)
            {
                label.validateNow();
                label.setStyle("fontSize",  int(label.getStyle("fontSize"))-1);
                label.setStyle("paddingTop",  int(label.getStyle("paddingTop"))+1);
            }
        }

        private function fontSizeAdjustCaption(text:Text):void
        {
            var h:int = text.height;
            text.validateNow();
            if (text.textHeight > h-3) {
                text.setStyle("fontSize",  int(text.getStyle("fontSize"))-1);
                callLater(fontSizeAdjustCaption,[text]);
            }
        }

        // 必殺技切り替えのマウスイベント
        public function featOpenHandler(e:MouseEvent):void
        {
            e.stopPropagation();
            setFeatNo(_featInventory.indexOf(e.currentTarget));
        }

        public function passiveOpenHandler(e:MouseEvent):void
        {
            e.stopPropagation();
            setPassiveNo(_passiveInventory.indexOf(e.currentTarget));
        }

        // タブ切り替えのマウスイベント
        public function onTabAClick(e:MouseEvent):void
        {
            e.stopPropagation();
            if (!_tabA_SB.visible) return

            _tabA_SB.visible = false;
            _tabB_SB.visible = true;

            _passiveInventory.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = false}});
            _passiveContainers.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = false}});

            _featInventory.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = true}});
            _featsContainers.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = true}});
        }

        public function onTabBClick(e:MouseEvent):void
        {
            e.stopPropagation();
            if (!_tabB_SB.enabled || !_tabB_SB.visible) return

            _tabA_SB.visible = true;
            _tabB_SB.visible = false;

            _featInventory.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = false}});
            _featsContainers.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = false}});

            _passiveInventory.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = true}});
            _passiveContainers.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = true}});

        }

        // 使用中の必殺技の設定
        private function setFeatNo(no:int):void
        {
            if(_featNo != no)
            {
                _featNo = no;
                waitComplete(setCompleteFeatNo);
            }
        }
        private function setCompleteFeatNo():void
        {
            var t:Array = [];
            var pExec:SerialExecutor = new SerialExecutor()
            // キャプションの表示
            _featsCaption.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = false}});
            _featsCaption[_featNo].visible = true;

            for(var i:int = 0; i < _featsContainers.length; i++)
            {
                _featsContainers[i].y = _FEAT_NAME_INTERVAL*(i);
            }

            for(i = 0; i < _featMax; i++)
            {
                 if(_featNo+1 > i)
                 {
                     _featInventory[i].y = _yPosition[i];

                 }
                 _featInventory[i].gotoAndStop(0);
            }
            _featInventory[_featNo].gotoAndStop(2);
        }

        private function setPassiveNo(no:int):void
        {
            if(_passiveNo != no)
            {
                _passiveNo = no;
                waitComplete(setCompletePassiveNo);
            }
        }
        private function setCompletePassiveNo():void
        {

            var t:Array = [];
            var pExec:SerialExecutor = new SerialExecutor()
            // キャプションの表示
            _passiveCaption.forEach(function(item:*, index:int, array:Array):void{if (item) {item.visible = false}});
            _passiveCaption[_passiveNo].visible = true;
            for(var i:int = 0; i < _passiveContainers.length; i++)
            {
                _passiveContainers[i].y = _FEAT_NAME_INTERVAL*(i);
            }

            for(i = 0; i < _passiveMax; i++)
            {
                 if(_passiveNo+1 > i)
                 {
                     _passiveInventory[i].y = _yPositionPassive[i];
                 }
                 _passiveInventory[i].gotoAndStop(0);
            }

            _passiveInventory[_passiveNo].gotoAndStop(2);

        }

        // 表表示
        public function onObverse():void
        {
            waitComplete(setObverse)
        }
        private function setObverse():void
        {
            _root.gotoAndStop(1);
        }

        // 裏表示
        public function onReverse():void
        {
            waitComplete(setReverse);
        }
        private function setReverse():void
        {
            _root.gotoAndStop(_frameNo);
            RemoveChild.apply(_featInventory0MC);
            RemoveChild.apply(_featInventory1MC);
            RemoveChild.apply(_featInventory2MC);
            RemoveChild.apply(_featInventory3MC);
            RemoveChild.apply(_passiveInventory0MC);
            RemoveChild.apply(_passiveInventory1MC);
            RemoveChild.apply(_passiveInventory2MC);
            RemoveChild.apply(_passiveInventory3MC);
            RemoveChild.apply(_passiveBaseMC);
            RemoveChild.apply(_tabA_SB);
            RemoveChild.apply(_tabB_SB);
        }

        // 発動条件を更新
        public function updateFeatCondition(feat_index:int, condition:String):void
        {
            var strValues:Array = condition.split(":")[1].split(",");
            var overRide:Boolean = true;
            setFeatCondition(feat_index, strValues, overRide);
        }

    }

}
