package view.scene.game
{
    import flash.display.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.*;

    import model.Duel;
    import model.Entrant;
    import model.CharaCard;
    import model.events.PassiveSkillEvent;
    import model.events.PassiveSkillSceneEvent;
    import view.*;
    import view.image.game.*;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.utils.*;
    import controller.*;

    /**
     * パッシブスキルシーンクラス
     *
     */

    public class PassiveSkillScene extends BaseScene
    {
        // プレイヤーエントラント
        private var _duel:Duel = Duel.instance;

        private var _plPassiveSkills:Vector.<PassiveSkillBar> = new Vector.<PassiveSkillBar>();
        private var _foePassiveSkills:Vector.<PassiveSkillBar> = new Vector.<PassiveSkillBar>();

        private var _passiveSkillClips:Array = [];

        // 切り替えフラグ
        private var _plSkillReset:Boolean = false;
        private var _foeSkillReset:Boolean = false;
        private var _plLabelArray:Array = [];
        private var _foeLabelArray:Array = [];

        private const _PL_BAR_X:int = 0;
        private const _PL_LBL_X:int = 20;
        private const _BAR_HEIGHT:int = 20;
        private const _BAR_WIDTH:int = 130;
        private const _FOE_BAR_X:int = 760;
        private const _FOE_LBL_X:int = 740;
        private const _BAR_START_Y:int = 110;
        private const _BAR_OFFSET_Y:int = 16;
        private const _LBL_START_Y:int = 100;

        /**
         * コンストラクタ
         *
         */
        public function PassiveSkillScene()
        {
        }

        public override function init():void
        {
            _duel.plEntrant.addEventListener(Entrant.CHANGE_DONE, plSkillChangeHandler);
            _duel.foeEntrant.addEventListener(Entrant.CHANGE_DONE, foeSkillChangeHandler);
            _duel.plEntrant.addEventListener(Entrant.UPDATE_PASSIVE_SKILL, updatePlPassiveSkill);
            _duel.foeEntrant.addEventListener(Entrant.UPDATE_PASSIVE_SKILL, updateFoePassiveSkill);
            _duel.addEventListener(Duel.CHARA_CHANGE_PHASE_START, changeStartHandler);
            _duel.addEventListener(Duel.DEAD_CHARA_CHANGE_PHASE_START, changeStartHandler);
            _duel.addEventListener(Duel.CHARA_CHANGE_PHASE_FINISH, changeFinishHandler);
            _duel.addEventListener(Duel.DEAD_CHARA_CHANGE_PHASE_FINISH, changeFinishHandler);
            _duel.addEventListener(PassiveSkillEvent.PLAYER_ON, plPassiveOnHandler);
            _duel.addEventListener(PassiveSkillEvent.PLAYER_OFF, plPassiveOffHandler);
            _duel.addEventListener(PassiveSkillEvent.FOE_ON, foePassiveOnHandler);
            _duel.addEventListener(PassiveSkillEvent.FOE_OFF, foePassiveOffHandler);
            _duel.addEventListener(PassiveSkillSceneEvent.PLAYER_PASSIVE_SKILL_USE, plPassiveUseHandler);
            _duel.addEventListener(PassiveSkillSceneEvent.FOE_PASSIVE_SKILL_USE , foePassiveUseHandler);
        }

        public override function final():void
        {
            _passiveSkillClips.forEach(function(item:*, index:int, array:Array):void{
                    if (item != null)
                    {
                        item.getHideThread().start()
                            }
                });

            _duel.plEntrant.removeEventListener(Entrant.CHANGE_DONE, plSkillChangeHandler);
            _duel.foeEntrant.removeEventListener(Entrant.CHANGE_DONE, foeSkillChangeHandler);
            _duel.plEntrant.removeEventListener(Entrant.UPDATE_PASSIVE_SKILL, updatePlPassiveSkill);
            _duel.foeEntrant.removeEventListener(Entrant.UPDATE_PASSIVE_SKILL, updateFoePassiveSkill);
            _duel.removeEventListener(Duel.CHARA_CHANGE_PHASE_START, changeStartHandler);
            _duel.removeEventListener(Duel.DEAD_CHARA_CHANGE_PHASE_START, changeStartHandler);
            _duel.removeEventListener(PassiveSkillEvent.PLAYER_ON, plPassiveOnHandler);
            _duel.removeEventListener(PassiveSkillEvent.PLAYER_OFF, plPassiveOffHandler);
            _duel.removeEventListener(PassiveSkillEvent.FOE_ON, foePassiveOnHandler);
            _duel.removeEventListener(PassiveSkillEvent.FOE_OFF, foePassiveOffHandler);
            _duel.removeEventListener(PassiveSkillSceneEvent.PLAYER_PASSIVE_SKILL_USE, plPassiveUseHandler);
            _duel.removeEventListener(PassiveSkillSceneEvent.FOE_PASSIVE_SKILL_USE , foePassiveUseHandler);

            clearPlPassiveSkills();
            clearFoePassiveSkills();
        }

        // カットインのあるパッシブ用
        public function plPassiveUseHandler(e:PassiveSkillSceneEvent):void
        {
            var passiveSkillClip:PassiveSkillClip = PassiveSkillClip.getInstance(e.id);
            GameCtrl.instance.addViewSequence(passiveSkillClip.getShowThread(this));
            passiveSkillClip.setAnime(true);
            _passiveSkillClips[e.id] = passiveSkillClip;
        }

        // カットインのあるパッシブ用
        public function foePassiveUseHandler(e:PassiveSkillSceneEvent):void
        {
            var passiveSkillClip:PassiveSkillClip = PassiveSkillClip.getInstance(e.id);
            GameCtrl.instance.addViewSequence(passiveSkillClip.getShowThread(this));
            passiveSkillClip.setAnime(false);
            _passiveSkillClips[e.id] = passiveSkillClip;
        }

        public function setPassiveSkills():Thread
        {
            setPlPassiveSkills();
            setFoePassiveSkills();

            var pExec:ParallelExecutor = new ParallelExecutor();
            return pExec;
        }

        private function updatePlPassiveSkill(e:Event):void
        {
            setPlWeaponPassiveSkills();
        }

        private function updateFoePassiveSkill(e:Event):void
        {
            setFoeWeaponPassiveSkills();
        }

        private function setPlPassiveSkills():void
        {
            _plLabelArray = [];
            clearPlPassiveSkills();
            _duel.playerCharaCard.passiveSkill.forEach(
                function(item:*, index:int, array:Array):void
                {
                    _plPassiveSkills.push(new PassiveSkillBar(item.no));

                    var img:PassiveSkillBarImage = new PassiveSkillBarImage();
                    img.x = _PL_BAR_X;
                    img.y = _BAR_START_Y + _BAR_OFFSET_Y * index;
                    img.alpha = 0;
                    addChild(img);
                    _plPassiveSkills[index].img = img;

                    var name:Label = new Label();
                    name.styleName = "CharaCardName";
                    name.x = _PL_LBL_X;
                    name.y = _LBL_START_Y + _BAR_OFFSET_Y * index;
                    name.width = _BAR_WIDTH;
                    name.height = _BAR_HEIGHT;
                    name.setStyle("fontSize", 11);
                    name.setStyle("textAlign", "left");
                    name.text = item.name;
                    name.filters  = [new GlowFilter(0x000000, 1, 2, 2, 8, 1)];
                    name.alpha  = 0;

                    var caption:TextField = new TextField();
                    var txtFormat:TextFormat = new TextFormat();
                    txtFormat.align =TextFormatAlign.CENTER;
                    caption.defaultTextFormat = txtFormat;
                    caption.text = item.caption.slice(0,item.caption.indexOf("\|"));
                    caption.height = _BAR_HEIGHT;
                    caption.width = caption.textWidth + 15;
                    caption.x = name.x + name.width/2;
                    caption.y = name.y + name.height/2;
                    caption.alpha  = 0.0;
                    caption.background = true;
                    caption.backgroundColor = 0x000000;
                    caption.textColor = 0xFFFFFF;
                    caption.border = true;
                    caption.borderColor = 0x4CE1FF;
                    name.addEventListener(MouseEvent.MOUSE_OVER, mouseOverPlHandler);
                    name.addEventListener(MouseEvent.MOUSE_OUT, mouseOutPlHandler);
                    _plLabelArray.push(name);
                    addChild(name);
                    addChild(caption);
                    _plPassiveSkills[index].label = name;
                    _plPassiveSkills[index].caption = caption;
                });
            setPlWeaponPassiveSkills();
        }

        private function setPlWeaponPassiveSkills():void
        {
            var base_index:uint = _duel.playerCharaCard.passiveSkill.length;
            if (base_index >= 4) return;
            var existing:Boolean = false; // 既に存在するスキルをスキップする
            _duel.plEntrant.currentWeaponPassiveSkill.forEach(function(item:*, index:int, array:Array):void {
                    for each (var bar:PassiveSkillBar in _plPassiveSkills)
                             {
                                 if (item.name == bar.label.text) existing = true;
                             }
                    if (!existing) {
                        existing = false;

                        var presents_index:uint = base_index + index;
                        if (presents_index > _plPassiveSkills.length - 1)
                        {
                            _plPassiveSkills.push(new PassiveSkillBar(item.no));
                        }
                        var img:PassiveSkillBarImage = new PassiveSkillBarImage();
                        img.x = _PL_BAR_X;
                        img.y = _BAR_START_Y + _BAR_OFFSET_Y * presents_index;
                        img.alpha = 1;
                        addChild(img);
                        _plPassiveSkills[presents_index].img = img;

                        var name:Label = new Label();
                        name.styleName = "CharaCardName";
                        name.x = _PL_LBL_X;
                        name.y = _LBL_START_Y + _BAR_OFFSET_Y * presents_index;
                        name.width = _BAR_WIDTH;
                        name.height = _BAR_HEIGHT;
                        name.setStyle("fontSize", 11);
                        name.setStyle("textAlign", "left");
                        name.text = item.name;
                        name.filters  = [new GlowFilter(0x000000, 1, 2, 2, 8, 1)];
                        name.alpha  = 1;

                        var caption:TextField = new TextField();
                        var txtFormat:TextFormat = new TextFormat();
                        txtFormat.align =TextFormatAlign.CENTER;
                        caption.defaultTextFormat = txtFormat;
                        caption.text = item.caption.slice(0,item.caption.indexOf("\|"));
                        caption.height = _BAR_HEIGHT;
                        caption.width = caption.textWidth + 15;
                        caption.x = name.x + name.width/2;
                        caption.y = name.y + name.height/2;
                        caption.alpha  = 0.0;
                        caption.background = true;
                        caption.backgroundColor = 0x000000;
                        caption.textColor = 0xFFFFFF;
                        caption.border = true;
                        caption.borderColor = 0x4CE1FF;
                        name.addEventListener(MouseEvent.MOUSE_OVER, mouseOverPlHandler);
                        name.addEventListener(MouseEvent.MOUSE_OUT, mouseOutPlHandler);
                        _plLabelArray.push(name);
                        addChild(name);
                        addChild(caption);
                        _plPassiveSkills[presents_index].label = name;
                        _plPassiveSkills[presents_index].caption = caption;
                    }
                });
        }

        private function setFoePassiveSkills():void
        {
            _foeLabelArray = [];
            clearFoePassiveSkills();
            _duel.foeCharaCard.passiveSkill.forEach(
                function(item:*, index:int, array:Array):void
                {
                    _foePassiveSkills.push(new PassiveSkillBar(item.no));

                    var img:PassiveSkillBarImage = new PassiveSkillBarImage();
                    img.x = _FOE_BAR_X;
                    img.y = _BAR_START_Y + _BAR_OFFSET_Y * index;
                    img.scaleX = -1;
                    img.alpha = 0;
                    addChild(img);
                    _foePassiveSkills[index].img = img;

                    var name:Label = new Label();
                    name.styleName = "CharaCardName";
                    name.x = _FOE_LBL_X - _BAR_WIDTH;
                    name.y = _LBL_START_Y + _BAR_OFFSET_Y * index;
                    name.width = _BAR_WIDTH;
                    name.height = _BAR_HEIGHT;
                    name.setStyle("fontSize", 11);
                    name.setStyle("textAlign", "right");
                    name.text = item.name;
                    name.filters  = [new GlowFilter(0x000000, 1, 2, 2, 8, 1)];
                    name.alpha  = 0;

                    var caption:TextField = new TextField();
                    var txtFormat:TextFormat = new TextFormat();
                    txtFormat.align =TextFormatAlign.CENTER;
                    caption.defaultTextFormat = txtFormat;
                    caption.text = item.caption.slice(0,item.caption.indexOf("\|"));
                    caption.height = _BAR_HEIGHT;
                    caption.width = caption.textWidth + 25;
                    caption.x = name.x + name.width/2 - caption.width;
                    caption.y = name.y + name.height/2;
                    caption.alpha  = 0.0;
                    caption.background = true;
                    caption.backgroundColor = 0x000000;
                    caption.textColor = 0xFFFFFF;
                    caption.border = true;
                    caption.borderColor = 0x4CE1FF;
                    name.addEventListener(MouseEvent.MOUSE_OVER, mouseOverFoeHandler);
                    name.addEventListener(MouseEvent.MOUSE_OUT, mouseOutFoeHandler);
                    _foeLabelArray.push(name);
                    addChild(name);
                    addChild(caption);
                    _foePassiveSkills[index].label = name;
                    _foePassiveSkills[index].caption = caption;

                });
            setFoeWeaponPassiveSkills();
        }

        private function setFoeWeaponPassiveSkills():void
        {
            var base_index:uint = _duel.foeCharaCard.passiveSkill.length;
            if (base_index >= 4) return;
            var existing:Boolean = false; // 既に存在するスキルをスキップする
            _duel.foeEntrant.currentWeaponPassiveSkill.forEach(function(item:*, index:int, array:Array):void {
                    for each (var bar:PassiveSkillBar in _foePassiveSkills)
                             {
                                 if (item.name == bar.label.text) existing = true;
                             }
                    if (!existing) {
                        existing = false;

                        var presents_index:uint = base_index + index;
                        if (presents_index > _foePassiveSkills.length - 1)
                        {
                            _foePassiveSkills.push(new PassiveSkillBar(item.no));
                        }
                        var img:PassiveSkillBarImage = new PassiveSkillBarImage();
                        img.x = _FOE_BAR_X;
                        img.y = _BAR_START_Y + _BAR_OFFSET_Y * presents_index;
                        img.scaleX = -1;
                        img.alpha = 1;
                        addChild(img);
                        _foePassiveSkills[presents_index].img = img;

                        var name:Label = new Label();
                        name.styleName = "CharaCardName";
                        name.x = _FOE_LBL_X - _BAR_WIDTH;
                        name.y = _LBL_START_Y + _BAR_OFFSET_Y * presents_index;
                        name.width = _BAR_WIDTH;
                        name.height = _BAR_HEIGHT;
                        name.setStyle("fontSize", 11);
                        name.setStyle("textAlign", "right");
                        name.text = item.name;
                        name.filters  = [new GlowFilter(0x000000, 1, 2, 2, 8, 1)];
                        name.alpha  = 1;

                        var caption:TextField = new TextField();
                        var txtFormat:TextFormat = new TextFormat();
                        txtFormat.align =TextFormatAlign.CENTER;
                        caption.defaultTextFormat = txtFormat;
                        caption.text = item.caption.slice(0,item.caption.indexOf("\|"));
                        caption.height = _BAR_HEIGHT;
                        caption.width = caption.textWidth + 25;
                        caption.x = name.x + name.width/2 - caption.width;
                        caption.y = name.y + name.height/2;
                        caption.alpha  = 0.0;
                        caption.background = true;
                        caption.backgroundColor = 0x000000;
                        caption.textColor = 0xFFFFFF;
                        caption.border = true;
                        caption.borderColor = 0x4CE1FF;
                        name.addEventListener(MouseEvent.MOUSE_OVER, mouseOverFoeHandler);
                        name.addEventListener(MouseEvent.MOUSE_OUT, mouseOutFoeHandler);
                        _foeLabelArray.push(name);
                        addChild(name);
                        addChild(caption);
                        _foePassiveSkills[presents_index].label = name;
                        _foePassiveSkills[presents_index].caption = caption;
                    }
                });
        }

        public function mouseOverPlHandler(e:MouseEvent):void
        {
            if (e.currentTarget.alpha == 0) return;

            var index:int = _plLabelArray.indexOf(e.currentTarget);
            this.setChildIndex(_plPassiveSkills[index].caption,this.numChildren-1);
            if (_plPassiveSkills[index].img.getState() == PassiveSkillBarImage.STATE_ON)
            {
                _plPassiveSkills[index].caption.borderColor = 0x4CE1FF;
                _plPassiveSkills[index].caption.textColor = 0xFFFFFF;
            }
            else
            {
                _plPassiveSkills[index].caption.borderColor = 0xFFFFFF;
                _plPassiveSkills[index].caption.textColor = 0xBBBBBB;
            }
            _plPassiveSkills[index].caption.alpha = 0.8;
        }

        public function mouseOutPlHandler(e:MouseEvent):void
        {
            var index:int = _plLabelArray.indexOf(e.currentTarget);
            this.setChildIndex(_plPassiveSkills[index].caption,0);
            _plPassiveSkills[index].caption.alpha = 0.0;
        }

        public function mouseOverFoeHandler(e:MouseEvent):void
        {
            if (e.currentTarget.alpha == 0) return;

            var index:int = _foeLabelArray.indexOf(e.currentTarget);
            this.setChildIndex(_foePassiveSkills[index].caption,this.numChildren-1);
            if (_foePassiveSkills[index].img.getState() == PassiveSkillBarImage.STATE_ON)
            {
                _foePassiveSkills[index].caption.borderColor = 0x4CE1FF;
                _foePassiveSkills[index].caption.textColor = 0xFFFFFF;
            }
            else
            {
                _foePassiveSkills[index].caption.borderColor = 0xFFFFFF;
                _foePassiveSkills[index].caption.textColor = 0xBBBBBB;
            }
            _foePassiveSkills[index].caption.alpha = 0.8;
        }

        public function mouseOutFoeHandler(e:MouseEvent):void
        {
            var index:int = _foeLabelArray.indexOf(e.currentTarget);
            this.setChildIndex(_foePassiveSkills[index].caption,0);
            _foePassiveSkills[index].caption.alpha = 0.0;
        }

        private function clearPlPassiveSkills():void
        {
            while (_plPassiveSkills.length > 0) {
                var skill:PassiveSkillBar = _plPassiveSkills.pop();
                skill.label.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverPlHandler);
                skill.label.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutPlHandler);
                RemoveChild.apply(skill.img);
                RemoveChild.apply(skill.label);
                RemoveChild.apply(skill.caption);
                skill = null;
            }
        }
        private function clearFoePassiveSkills():void
        {
            while (_foePassiveSkills.length > 0) {
                var skill:PassiveSkillBar = _foePassiveSkills.pop();
                skill.label.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverFoeHandler);
                skill.label.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutFoeHandler);
                RemoveChild.apply(skill.img);
                RemoveChild.apply(skill.label);
                RemoveChild.apply(skill.caption);
                skill = null;
            }
        }

        private function changeStartHandler(e:Event):void
        {
            getBringOffThread().start();
        }

        private function plSkillChangeHandler(e:Event):void
        {
            _plSkillReset = true;
        }

        private function foeSkillChangeHandler(e:Event):void
        {
            _foeSkillReset = true;
        }

        private function changeFinishHandler(e:Event):void
        {
            getBringOnThread().start();
        }

        private function plPassiveOnHandler(e:PassiveSkillEvent):void
        {
            // log.writeLog(log.LV_DEBUG, this,"plPassiveOnHandler",e.skillId);
            for (var i:int = 0; i < _plPassiveSkills.length; i++) {
                if (_plPassiveSkills[i].skillId == e.skillId) {
                    _plPassiveSkills[i].img.changeState(PassiveSkillBarImage.STATE_ON);
                    break;
                }
            }
        }
        private function plPassiveOffHandler(e:PassiveSkillEvent):void
        {
            // log.writeLog(log.LV_DEBUG, this,"plPassiveOffHandler",e.skillId); 
            for (var i:int = 0; i < _plPassiveSkills.length; i++) {
                if (_plPassiveSkills[i].skillId == e.skillId) {
                    _plPassiveSkills[i].img.changeState(PassiveSkillBarImage.STATE_OFF);
                    break;
                }
            }
        }
        private function foePassiveOnHandler(e:PassiveSkillEvent):void
        {
            for (var i:int = 0; i < _foePassiveSkills.length; i++) {
                if (_foePassiveSkills[i].skillId == e.skillId) {
                    _foePassiveSkills[i].img.changeState(PassiveSkillBarImage.STATE_ON);
                    break;
                }
            }
        }
        private function foePassiveOffHandler(e:PassiveSkillEvent):void
        {
            for (var i:int = 0; i < _foePassiveSkills.length; i++) {
                if (_foePassiveSkills[i].skillId == e.skillId) {
                    _foePassiveSkills[i].img.changeState(PassiveSkillBarImage.STATE_OFF);
                    break;
                }
            }
        }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
            log.writeLog(log.LV_DEBUG, this,"getBringOnThread",_plSkillReset,_foeSkillReset);

            if (_plSkillReset) {
                clearPlPassiveSkills();
                setPlPassiveSkills();
            }
            if (_foeSkillReset) {
                clearFoePassiveSkills();
                setFoePassiveSkills();
            }
            _plSkillReset = false;
            _foeSkillReset = false;

            var sPlExec:SerialExecutor = new SerialExecutor();
            var sFoeExec:SerialExecutor = new SerialExecutor();
            var sPlNameExec:SerialExecutor = new SerialExecutor();
            var sFoeNameExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var i:int = 0;

            for (i = 0; i < _plPassiveSkills.length; i++) {
                sPlExec.addThread(new BeTweenAS3Thread(_plPassiveSkills[i].img, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                sPlNameExec.addThread(new BeTweenAS3Thread(_plPassiveSkills[i].label, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            }
            for (i = 0; i < _foePassiveSkills.length; i++) {
                sFoeExec.addThread(new BeTweenAS3Thread(_foePassiveSkills[i].img, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                sFoeNameExec.addThread(new BeTweenAS3Thread(_foePassiveSkills[i].label, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            }

            pExec.addThread(sPlExec);
            pExec.addThread(sFoeExec);
            pExec.addThread(sPlNameExec);
            pExec.addThread(sFoeNameExec);
            return pExec;
        }
        public function getBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            var i:int = 0;

            for (i = 0; i < _plPassiveSkills.length; i++) {
                pExec.addThread(new BeTweenAS3Thread(_plPassiveSkills[i].img, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                pExec.addThread(new BeTweenAS3Thread(_plPassiveSkills[i].label, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            }
            for (i = 0; i < _foePassiveSkills.length; i++) {
                pExec.addThread(new BeTweenAS3Thread(_foePassiveSkills[i].img, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                pExec.addThread(new BeTweenAS3Thread(_foePassiveSkills[i].label, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            }

            return pExec;
        }

        public function getFinalizeThread():Thread
        {
            return new ClousureThread(final);
        }

        public function getHidePassiveSkillsThread():Thread
        {
            return getBringOffThread();
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
import flash.text.TextField;
import mx.controls.*;

import model.Duel;
import view.scene.BaseScene;
import view.scene.game.PassiveSkillScene;
import view.image.game.PassiveSkillBarImage;
import view.BaseShowThread;
import view.BaseHideThread;

class PassiveSkillBar extends BaseScene
{
    private var _skillId:int = 0;
    private var _img:PassiveSkillBarImage;
    private var _name:Label;
    private var _caption:TextField;

    public function PassiveSkillBar(id:int)
    {
        _skillId = id;
    }

    public function get skillId():int
    {
        return _skillId;
    }
    public function set img(img:PassiveSkillBarImage):void
    {
        _img = img;
    }
    public function get img():PassiveSkillBarImage
    {
        return _img;
    }
    public function set label(name:Label):void
    {
        _name = name;
    }
    public function get label():Label
    {
        return _name;
    }
    public function set caption(caption:TextField):void
    {
        _caption = caption;
    }
    public function get caption():TextField
    {
        return _caption
    }
}

class ShowThread extends BaseShowThread
{
    private var _pss:PassiveSkillScene;
    private var _at:int;

    public function ShowThread(pss:PassiveSkillScene, stage:DisplayObjectContainer, at:int)
    {
        _pss = pss;
        _at = at;
        super(pss, stage)
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
        thread =  _pss.setPassiveSkills();
        thread.start();
        thread.join();
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    private var _pss:PassiveSkillScene;

    public function HideThread(pss:PassiveSkillScene)
    {
        _pss = pss;
        super(pss);
    }

    protected override function run():void
    {
        var thread:Thread;

        thread = _pss.getHidePassiveSkillsThread();
        thread.start();
        thread.join();
        next(exit);
    }


}
