package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import mx.controls.*;

    import model.Feat;
    import view.image.BaseImage;

    /**
     * 必殺技情報の表示クラス
     *
     */


    public class FeatInfoPanel extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/game/skill_base.swf")]
        private var _Source:Class;

        private static const _BASE:String = "base";
        private static const _TYPE:String = "type";
        private static const _BASE_DISABLE:String = "dis";
        private static const _BASE_ENABLE:String = "en";
        private static const _TYPE_DEF:String = "deff";
        private static const _TYPE_ATK:String = "atk";
        private static const _TYPE_MOV:String = "mov";
//         private static const _TYPE_DEF:String = "mov";
//         private static const _TYPE_ATK:String = "mov";
//         private static const _TYPE_MOV:String = "mov";

        private var _baseMC:MovieClip;
        private var _typeMC:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function FeatInfoPanel()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _baseMC = MovieClip(_root.getChildByName(_BASE));
            _typeMC = MovieClip(_root.getChildByName(_TYPE));
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function setBase(enable:Boolean):void
        {
            if (enable)
            {
                waitComplete(setBaseEnable)
            }else{
                waitComplete(setBaseDisable)
            }

        }

        private function setBaseEnable():void
        {
            _baseMC.gotoAndPlay(_BASE_ENABLE);
        }

        private function setBaseDisable():void
        {
            _baseMC.gotoAndPlay(_BASE_DISABLE);
        }


        public function setType(t:int):void
        {
            switch (t)
            {
            case Feat.TYPE_ATK:
                waitComplete(setTypeAtk);
                break;
            case Feat.TYPE_DEF:
                waitComplete(setTypeDef);
                break;
            case Feat.TYPE_MOVE:
                waitComplete(setTypeMove);
                break;
            default:
            }

        }

        private function setTypeAtk():void
        {
            _typeMC.gotoAndStop(_TYPE_ATK);
        }
        private function setTypeDef():void
        {
//            _typeMC.gotoAndPlay(_TYPE_DEF);
            _typeMC.gotoAndStop(_TYPE_DEF);
        }
        private function setTypeMove():void
        {
            _typeMC.gotoAndStop(_TYPE_MOV);
        }


    }

}
