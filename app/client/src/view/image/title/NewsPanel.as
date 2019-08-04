package view.image.title
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.containers.*;
    import mx.controls.*;

    import view.image.BaseImage;

    import controller.TitleCtrl;

    /**
     * ニュースパネルクラス
     *
     */

    public class NewsPanel extends Panel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "情報取得中";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "Loading";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "取得訊息中";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "正在获取信息";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "정보 취득중";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Chargement";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "情報取得中";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "Loading";


        private static const X:int = 15;
        private static const Y:int = 480;

        private var _newsText:TextArea = new TextArea();

        private var _ctrl:TitleCtrl = TitleCtrl.instance;

        private var _textInputArray:Array = [];


        /**
         * コンストラクタ
         *
         */
        public function NewsPanel()
        {
            super();
            styleName = "NewsPanel";
            width = 220;
            height = 200;
            layout = "vertical";
            x = X;
            y  =Y;
            title = "News"

            alpha = 0.0;
            visible = false;

            _newsText.percentWidth = 100;
            _newsText.percentHeight = 100;
//            _newsText.htmlText = "情報取得中";
            _newsText.htmlText = _TRANS_MSG;
            _newsText.editable = false;
            _newsText.styleName = "NewsTextArea";
            addChild(_newsText)
            _ctrl.setNewsPanel(this);
        }


        public function updateNews(text:String):void
        {
            _newsText.htmlText = text;

        }


    }

}
