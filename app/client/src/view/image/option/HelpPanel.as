package view.image.option
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;

    import view.image.BaseImage;

    import controller.TitleCtrl;

    import model.Option;

    /**
     * ニュースパネルクラス
     *
     */

    public class HelpPanel extends Panel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "ツールチップを表示する";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2        :String = "矢印ガイドを表示する";
        CONFIG::LOCALE_JP
        private static const _TRANS_FONTFAMILY	:String = "fontFamily";
        CONFIG::LOCALE_JP
        private static const _TRANS_FONT	:String = "minchoB";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "Show Tooltips";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2        :String = "Display arrow guides.";
        CONFIG::LOCALE_EN
        private static const _TRANS_FONTFAMILY	:String = "fontFamily";
        CONFIG::LOCALE_EN
        private static const _TRANS_FONT	:String = "minchoB";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "顯示工具提示";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2        :String = "顯示箭形符號嚮導";
        CONFIG::LOCALE_TCN
        private static const _TRANS_FONTFAMILY	:String = "fontFamily";
        CONFIG::LOCALE_TCN
        private static const _TRANS_FONT	:String = "minchoB";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "显示工具列表";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2        :String = "显示箭头符号";
        CONFIG::LOCALE_SCN
        private static const _TRANS_FONTFAMILY	:String = "fontFamily";
        CONFIG::LOCALE_SCN
        private static const _TRANS_FONT	:String = "minchoB";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "툴 팁을 표시한다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2        :String = "矢印ガイドを表示する";
        CONFIG::LOCALE_KR
        private static const _TRANS_FONTFAMILY	:String = "fontFamily";
        CONFIG::LOCALE_KR
        private static const _TRANS_FONT	:String = "minchoB";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "Afficher le Tooltip";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2        :String = "Afficher le guide.";
        CONFIG::LOCALE_FR
        private static const _TRANS_FONTFAMILY	:String = "fontFamily";
        CONFIG::LOCALE_FR
        private static const _TRANS_FONT	:String = "minchoB";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "ツールチップを表示する";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2        :String = "矢印ガイドを表示する";
        CONFIG::LOCALE_ID
        private static const _TRANS_FONTFAMILY	:String = "fontFamily";
        CONFIG::LOCALE_ID
        private static const _TRANS_FONT	:String = "minchoB";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG     :String = "แสดง Tooltip";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2        :String = "แสดงลูกศรนำทาง";
        CONFIG::LOCALE_TH
        private static const _TRANS_FONTFAMILY	:String = "fontFamily";
        CONFIG::LOCALE_TH
        private static const _TRANS_FONT	:String = "minchoB";


        private static const X:int = 580;
        private static const Y:int = 460;

        private var _checkBox:CheckBox = new CheckBox();
        private var _arrowCheckBox:CheckBox = new CheckBox();
        // タイトル表示
        private var _BGMLabel:Label = new Label();
        private var _SELabel:Label = new Label();

        private var _option:Option = Option.instance;


        /**
         * コンストラクタ
         *
         */
        public function HelpPanel()
        {
            super();
            x = 230;
            y = 100;

            width  = 300;
            height = 100;
            layout = "absolute"

            title = "Help Option";

            addChild(_checkBox);
            addChild(_arrowCheckBox);

            _checkBox.label= _TRANS_MSG;
            _checkBox.x = 60;
            _checkBox.y = 40;
            _checkBox.selected = _option.help;
            _checkBox.styleName = "LoginLabel";
            _checkBox.setStyle("fontSize",  12);
            _checkBox.setStyle(_TRANS_FONTFAMILY,  _TRANS_FONT);
            _checkBox.addEventListener(Event.CHANGE, changeHandler);

            _arrowCheckBox.label= _TRANS_MSG2;
            _arrowCheckBox.x = 60;
            _arrowCheckBox.y = 60;
            _arrowCheckBox.selected = _option.arrow;
            _arrowCheckBox.styleName = "LoginLabel";
            _arrowCheckBox.setStyle("fontSize",  12);
            _arrowCheckBox.setStyle(_TRANS_FONTFAMILY,  _TRANS_FONT);
            _arrowCheckBox.addEventListener(Event.CHANGE, arrowChangeHandler);

            _option.addEventListener(Option.UPDATE_TOOLTIP, updateHandler)
        }

        public function changeHandler(e:Event):void
        {
            _option.help = _checkBox.selected;
        }

        public function arrowChangeHandler(e:Event):void
        {
            _option.arrow = _arrowCheckBox.selected;
        }

        public function updateHandler(e:Event):void
        {
            _checkBox.selected = _option.help ;
        }

        public function final():void
        {
            _checkBox.removeEventListener(Event.CHANGE, changeHandler);
            _option.removeEventListener(Option.UPDATE_TOOLTIP, updateHandler)
        }

    }

}
