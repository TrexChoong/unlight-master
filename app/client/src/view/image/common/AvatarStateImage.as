package view.image.common
{

    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.*;

    import mx.core.UIComponent;

    import view.image.BaseImage;
    import mx.controls.*;
    import view.utils.*;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;


    /**
     * AvatarDetailImage表示クラス
     *
     */

    public class AvatarStateImage extends BaseImage
    {

        // CharaCardFrame表示元SWF
        [Embed(source="../../../../data/image/avatar/avatar_state.swf")]
        private var _Source:Class;

        public static  const X:int = 30;
        public static  const Y:int = -5;
        public static const H:int = 32;


        public static const EXP_POW       :int = 0;
        public static const GEM_POW       :int = 1;
        public static const AP_RECOV      :int = 2;
        public static const INC_QUEST     :int = 3;
        public static const SHORTEN_QUEST :int = 4;

        private static const _UP_EXP      :String = "up_exp";
        private static const _UP_GEM      :String = "up_gem";
        private static const _RECOV_TIME  :String =  "short_recov_time";
        private static const _INC_QUEST   :String = "inc_quest_inv";
        private static const _SHORT_QUEST :String = "short_quest_find";

        private var _mouseLabel:TextArea = new TextArea();

        private static const _LABEL_X:int  =-80;
        private static const _LABEL_Y:int = 10;

        private static const _LABEL_WIDTH:int = 80;
        private static const _LABEL_HEIGHT:int = 20;


        private var _type :int;
        private var _typeSet:Array = [_UP_EXP,_UP_GEM,_RECOV_TIME,_INC_QUEST,_SHORT_QUEST]; /* of String */
        CONFIG::LOCALE_JP
        private var _typeTextSet:Array = ["Exp__POW__%UP","Gem__POW__%UP","AP回復__POW__分短縮","探索数+__POW__","探索時間__POW__%短縮"]; /* of String */
        CONFIG::LOCALE_EN
        private var _typeTextSet:Array = ["Exp__POW__%UP","Gem__POW__%UP","AP renewal time reduced by __POW__minutes","Number of explorations + __POW__","Exploration time reduced by __POW__%"]; /* of String */
        CONFIG::LOCALE_TCN
	private var _typeTextSet:Array = ["Exp__POW__%UP","Gem__POW__%UP","縮短AP回復時間__POW__分鐘","探索數+__POW__","縮短__POW__%的探索時間"]; /* of String */
        CONFIG::LOCALE_SCN
	private var _typeTextSet:Array = ["Exp__POW__%UP","Gem__POW__%UP","AP恢复的时间缩短__POW__分","探索数+__POW__","探索时间缩短__POW__%"]; /* of String */
        CONFIG::LOCALE_KR
        private var _typeTextSet:Array = ["Exp__POW__%UP","Gem__POW__%UP","AP回復__POW__分短縮","探索数+__POW__","探索時間__POW__%短縮"]; /* of String */
        CONFIG::LOCALE_FR
        private var _typeTextSet:Array = ["Exp__POW__%UP","Gem__POW__%UP","Temps de récupération d'AP diminué de __POW__ minutes.","Nombre de recherches + __POW__","Raccourcissement du temps de recherche de __POW__ %"]; /* of String */
        CONFIG::LOCALE_ID
        private var _typeTextSet:Array = ["Exp__POW__%UP","Gem__POW__%UP","AP回復__POW__分短縮","探索数+__POW__","探索時間__POW__%短縮"]; /* of String */
        CONFIG::LOCALE_TH
        private var _typeTextSet:Array = ["Exp__POW__%UP","Gem__POW__%UP","ลดระยะเวลาฟื้น AP __POW__นาที","จำนวนครั้งที่สามารถสำรวจได้+__POW__","ลดระยะเวลาสำรวจ__POW__%"]; /* of String */

        CONFIG::LOCALE_JP
        private var _typeTextWidth:Array = [80, 80, 110, 80, 110]; /* of String */
        CONFIG::LOCALE_TCN
        private var _typeTextWidth:Array = [80, 80, 110, 80, 110]; /* of String */
        CONFIG::LOCALE_SCN
        private var _typeTextWidth:Array = [80, 80, 110, 80, 110]; /* of String */
        CONFIG::LOCALE_KR
        private var _typeTextWidth:Array = [80, 80, 110, 80, 110]; /* of String */
        CONFIG::LOCALE_EN
        private var _typeTextWidth:Array = [120, 100, 230, 160, 180]; /* of String */
        CONFIG::LOCALE_FR
        private var _typeTextWidth:Array = [80, 80, 110, 80, 110]; /* of String */
        CONFIG::LOCALE_ID
        private var _typeTextWidth:Array = [80, 80, 110, 80, 110]; /* of String */
        CONFIG::LOCALE_TH
        private var _typeTextWidth:Array = [120, 100, 170, 180, 140]; /* of String */

//        private var _typeTextWidth:Array = [80, 80, 110, 80, 110]; /* of String */


        /**
         * コンストラクタ
         *
         */
        public function AvatarStateImage(t:int)
        {
            _mouseLabel.x = 0;
            _mouseLabel.y = _LABEL_Y;
            _mouseLabel.width = _typeTextWidth[t];
            _mouseLabel.height = _LABEL_HEIGHT;
            _mouseLabel.htmlText = "testestets";
            _mouseLabel.styleName= "ApRemainArea";
            _mouseLabel.alpha = 0;
            _mouseLabel.mouseEnabled= false;
            _mouseLabel.mouseChildren= false;
            _mouseLabel.selectable = false;
            this.addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
            this.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _type =t;
            super();
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            MovieClip(_root.getChildByName(_typeSet[_type])).gotoAndStop(1);
            _typeSet.splice(_type,1);
            for(var i:int = 0; i < _typeSet.length; i++){
                RemoveChild.apply(_root.getChildByName(_typeSet[i]));
            }

        }
        override protected function get Source():Class
        {
            return _Source;
        }

        public function showTween(p:UIComponent):ITween
        {
            log.writeLog(log.LV_FATAL, this, "show type", _type);
            return BetweenAS3.serial(
                BetweenAS3.addChild(this, p),
                BetweenAS3.to(this,{x:-25},0.15)
                );
        }
        public function setPow(p:int):void
        {
            _mouseLabel.text = _typeTextSet[_type].replace("__POW__",p.toString());
        }

        public function alignTween(i:int):ITween
        {
            log.writeLog(log.LV_FATAL, this, "alighn type", _type);
            return BetweenAS3.to(this,{y:i*H},0.1);
        }

        public function vanishTween():ITween
        {
            log.writeLog(log.LV_FATAL, this, "vanish type", _type);
            return BetweenAS3.serial(
                BetweenAS3.to(this, {x:X},0.2),
                BetweenAS3.removeFromParent(this)
                );

        }

        private function mouseOverHandler(e:Event):void
        {
             BetweenAS3.serial(
                BetweenAS3.addChild(_mouseLabel, this),
                BetweenAS3.tween(_mouseLabel, {x:-_typeTextWidth[_type],alpha:1.0}, {x:0,alpha:0.0}, 0.15, Sine.easeOut)
                 ).play();
        }
        private function mouseOutHandler(e:Event):void
        {
             BetweenAS3.serial(
                 BetweenAS3.tween(_mouseLabel, {alpha:0.0, x:0}, {alpha:1.0,x:-_typeTextWidth[_type]}, 0.2, Sine.easeOut),
                 BetweenAS3.removeFromParent(_mouseLabel)
                 ).play();
        }

        public function get type():int
        {
            return _type;
        }

    }

}

