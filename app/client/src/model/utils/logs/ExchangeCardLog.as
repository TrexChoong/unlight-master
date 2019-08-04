package model.utils.logs
{
    import flash.events.*;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import model.utils.*;
    import model.CharaCard;


    /**
     * メッセージのログ情報を扱うクラス
     * チャットやゲームログを保存する
     */
    public class ExchangeCardLog extends ClientLog
    {
        CONFIG::LOCALE_JP
        private static const  _GOT_EXCH_CARD_STR:String    = "__DATA__:__NAME____RARE____LV__を合成で取得しました。";

        CONFIG::LOCALE_EN
        private static const  _GOT_EXCH_CARD_STR:String    = "__DATA__:__NAME__ __RARE____LV__ synthesized.";

        CONFIG::LOCALE_TCN
        private static const  _GOT_EXCH_CARD_STR:String    = "__DATA__:您透過合成得到了__NAME____RARE____LV__。";

        CONFIG::LOCALE_SCN
        private static const  _GOT_EXCH_CARD_STR:String    = "__DATA__:通过合成获得了__NAME____RARE____LV__。";

        CONFIG::LOCALE_KR
        private static const  _GOT_EXCH_CARD_STR:String    = "__DATA__:__NAME____RARE____LV__を合成で取得しました。";

        CONFIG::LOCALE_FR
        private static const  _GOT_EXCH_CARD_STR:String    = "__DATA__:Vous avez obtenu la synthèse de __NAME__ __RARE____LV__.";

        CONFIG::LOCALE_ID
        private static const  _GOT_EXCH_CARD_STR:String    = "__DATA__:__NAME____RARE____LV__を合成で取得しました。";

        CONFIG::LOCALE_TH
        private static const  _GOT_EXCH_CARD_STR:String    = "__DATA__:ได้รับ __NAME____RARE____LV__ จากการผสมไอเท็ม";


        public function ExchangeCardLog()
        {
            super();
        }

        public override function get type():int
        {
            return ClientLog.GOT_EXCH_CARD;
        }


        public override function getLog(i:int):String
        {
            if ( _textSet[i] != null)
            {
                return _textSet[i];
            }

            return setText(i);
        }

        private function setText( i:int ):String
        {
            var dateArr:Array = dateSet;
            var nameArr:Array = nameSet;

            var date:Date = dateArr[i];
            var nameData:Array = nameArr[i];
            var ret:String = "";
            if (date != null && nameData != null)
            {
                ret = _GOT_EXCH_CARD_STR.replace(/__DATA__/, TimeFormat.transDateStr(date)).replace(/__NAME__/, nameData[1]);
                if ( nameData[0] < 1000 ) {
                    ret = ret.replace(/__LV__/, " Lv."+nameData[3]);
                    if ( nameData[2] > 5 ) {
                        var rarity:String = "R"+(nameData[2]-5);
                        ret = ret.replace(/__RARE__/, rarity);
                    } else {
                        ret = ret.replace(/__RARE__/, "");
                    }
                } else {
                    ret = ret.replace(/__RARE__/, "").replace(/__LV__/, "");
                }
                _textSet.unshift(ret);
            }
            checkMax();
            return ret;
        }

        public override function setLog(a:Object, save:Boolean = false ):String
        {
            var id:int = int(a);
            var name:String = CharaCard.ID(int(a)).name;
            var rare:int = CharaCard.ID(int(a)).rarity;
            var lv:int = CharaCard.ID(int(a)).level;

            dateSet.unshift(new Date());
            var setData:Array = [ id, name, rare, lv ];
            nameSet.unshift(setData);
            if (save)
            {
                _sharedObj.flush();
            }

            // テキストを先に作ってしまう
            return setText( 0 );
//            return _nameSet.length -1;
        }


    }


}