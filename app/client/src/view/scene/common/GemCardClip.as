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
     * GemCardClipのアイコン表示クラス
     * 全部ビットマップでキャッシュすべできか。同時に二つでることがない？
     */

    public class GemCardClip extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_GEM	:String = "獲得GEM増加";

        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_GEM	:String = "Additional gems";

        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_GEM	:String = "獲得GEM增加";

        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_GEM	:String = "获得GEM增加";

        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_GEM	:String = "획득GEM증가;";

        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_GEM	:String = "GEM supplémentaires";

        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_GEM	:String = "獲得GEM増加";

        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_GEM    :String = "ได้รับ GEM";


        // 倍率タイプ
        public static const TYPE_POW:int = 0;
        // 数字タイプ
        public static const TYPE_NUM:int = 1;

        // イメージ
        private var _caption:Label = new Label();
        private var _name:Label = new Label();
        private var _cardFrame:CardFrame;
        private var _image:AvatarItemImage;

        private var _type:int;

        // GEM倍率
        private var _gem:Number;
        /**
         * コンストラクタ
         *
         */
        public function GemCardClip(gem:int, type:int = TYPE_POW)
        {
            _gem = gem;
            _type = type;
        }

        // 初期化
        public override function init():void
        {
            _cardFrame = new CardFrame(CardFrame.FRAME_BLUE);
            _image = new AvatarItemImage("item_a_a001.swf");

            _image.x = 83;
            _image.y = 100;

            _name.x = 0;
            _name.y = 5;
            _name.width = 164;
            _name.height = 100;
            if (_type==TYPE_POW)
            {
//                _name.text = "獲得GEM増加";
                _name.text = _TRANS_HELP_GEM;
                _caption.htmlText = "GEM" + " x " + _gem.toString() + "%";
                _caption.x = -56;
                _caption.y = 185;
                _caption.width = 200;
                _caption.height = 100;

            }else{
                _caption.x = 15;
                _caption.y = 178;
                _caption.width = 150;
                _caption.height = 100;
                _name.text = "GET GEM!!";
                _caption.htmlText = "<p align=\"center\"> <FONT SIZE = \"50\">"+ _gem.toString()+"</FONT>"+"Gem</p>";;

            }
            _name.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _name.styleName = "ResultNameLabel";

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
