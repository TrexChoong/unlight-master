package view.image.requirements
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * CombineResultImage表示クラス
     *
     */


    public class CombineResultImage extends BaseImage
    {
        public static const SKILL_SLOT_NUM:int = 3;

        // HP表示元SWF
        [Embed(source="../../../../data/image/compo/compo_result.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        private const OK_BUTTON:String = "btn_ok"
        private var _okButton:SimpleButton;

        private const UNIQ_SKILL:String = "skill_u";
        private var _uniqSkill:MovieClip;
        private var _uniqVisible:Boolean = false;

        private const SKILL_LIST:Array = ["skill_a","skill_b","skill_c"];
        private var _skillList:Array = [];
        private var _skillVisible:Array = [];
        private var _skillVisibleIdx:int = 0;

        /**
         * コンストラクタ
         *
         */

        public function CombineResultImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _okButton = SimpleButton(_root.getChildByName(OK_BUTTON));

            _uniqSkill = MovieClip(_root.getChildByName(UNIQ_SKILL));
            _uniqSkill.visible = false;
            _uniqVisible = false;
            log.writeLog (log.LV_DEBUG,this,"uniqSkill",_uniqSkill);

            for (var i:int = 0; i < SKILL_LIST.length; i++) {
                var skill:MovieClip = MovieClip(_root.getChildByName(SKILL_LIST[i]));
                skill.visible = false;
                _skillList.push(skill);
                _skillVisible.push(false);
                log.writeLog (log.LV_DEBUG,this,"skilllist",i,_skillList[i]);
            }
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        // ボタンを取得
        public function get ok():SimpleButton
        {
            return _okButton;
        }

        public function skillSlotAllHide():void
        {
            log.writeLog (log.LV_DEBUG,this,"uniqSkill",_uniqSkill);
            uniqSkillSlotVisible(false);
            for (var i:int = 0; i < SKILL_LIST.length; i++) {
                log.writeLog (log.LV_DEBUG,this,"skilllist",i,_skillList[i]);
                skillSlotVisible(false,i);
            }
        }

        public function uniqSkillSlotShow():void
        {
            uniqSkillSlotVisible(true);
        }

        public function skillSlotShow(idx:int):void
        {
            skillSlotVisible(true,idx);
        }

        public function uniqSkillSlotVisible(f:Boolean):void
        {
            _uniqVisible = f;
            waitComplete(uniqSkillSlotHideComplete);
        }
        public function uniqSkillSlotHideComplete():void
        {
            _uniqSkill.visible = _uniqVisible;
        }

        public function skillSlotVisible(f:Boolean,idx:int):void
        {
            _skillVisible[idx] = f;
            waitComplete(skillSlotHideComplete);
        }
        public function skillSlotHideComplete():void
        {
            for (var i:int = 0; i < SKILL_LIST.length; i++) {
                _skillList[i].visible = _skillVisible[i];
            }
        }

    }

}
