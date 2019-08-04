package view.scene.common
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;
    import mx.events.ToolTipEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import view.image.common.*;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.scene.game.BuffClip;
    import view.utils.*;

    /**
     * ExpCardClipのアイコン表示クラス
     * 全部ビットマップでキャッシュすべできか。同時に二つでることがない？
     */

    public class ExpCardClip extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_EXP	:String = "獲得EXP増加";

        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_EXP	:String = "Bonus EXP";

        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_EXP	:String = "獲得EXP增加";

        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_EXP	:String = "获得EXP增加";

        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_EXP	:String = "획득 EXP 증가";

        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_EXP	:String = "EXP supplémentaires";

        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_EXP	:String = "獲得EXP増加";

        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_EXP    :String = "ได้รับ EXP";


        // イメージ
        private var _caption:Label = new Label();
        private var _name:Label = new Label();
        private var _cardFrame:CardFrame;
        private var _image:AvatarItemImage;

        // EXP倍率
        private var _exp:Number;

        /**
         * コンストラクタ
         *
         */
        public function ExpCardClip(exp:int)
        {
            _exp = exp;
        }

        // 初期化
        public override function init():void
        {
            _cardFrame = new CardFrame(CardFrame.FRAME_RED);
            _image = new AvatarItemImage("item_a_a000.swf");

            _image.x = 83;
            _image.y = 100;

            _name.x = 0;
            _name.y = 5;
            _name.width = 164;
            _name.height = 100;
//            _name.text = "獲得EXP増加";
            _name.text = _TRANS_HELP_EXP;
            _name.styleName = "ResultNameLabel";
            _name.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];

            _caption.x = -62;
            _caption.y = 185;
            _caption.htmlText = "EXP" + " x " +  _exp.toString() + "%";
            _caption.width = 200
            _caption.height = 100;
            _caption.styleName = "ResultNumericLabel";
            _caption.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];

            addChild(_cardFrame);
            addChild(_caption);
            addChild(_image);
            addChild(_name);
        }

        // 後処理
        public override function final():void
        {
            RemoveChild.apply(_cardFrame);
            RemoveChild.apply(_caption);
            RemoveChild.apply(_image);
            RemoveChild.apply(_name);
        }

    }
}
