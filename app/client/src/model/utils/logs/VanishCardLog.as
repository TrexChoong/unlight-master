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
    import model.events.*;
    import model.*;


    /**
     * メッセージのログ情報を扱うクラス
     * チャットやゲームログを保存する
     */
    public class VanishCardLog extends ClientLog
    {
        CONFIG::LOCALE_JP
        private static const  _VANISH_CARD_STR:String      = "__DATA__:__NAME____RARE____LV__が__NUM__枚消滅しました";

        CONFIG::LOCALE_EN
        private static const  _VANISH_CARD_STR:String      = "__DATA__:__NUM__ pieces of __NAME__ __RARE____LV__ cards were destroyed.";

        CONFIG::LOCALE_TCN
        private static const  _VANISH_CARD_STR:String      = "__DATA__:__NAME____RARE____LV__卡片__NUM__張消滅了。";

        CONFIG::LOCALE_SCN
        private static const  _VANISH_CARD_STR:String      = "__DATA__:__NUM__张__NAME____RARE____LV__卡片失效。";

        CONFIG::LOCALE_KR
        private static const  _VANISH_CARD_STR:String      = "__DATA__:__NAME____RARE____LV__が__NUM__枚消滅しました";

        CONFIG::LOCALE_FR
        private static const  _VANISH_CARD_STR:String      = "__DATA__:Vous avez détruit __NUM__ cartes __NAME__ __RARE____LV__.";

        CONFIG::LOCALE_ID
        private static const  _VANISH_CARD_STR:String      = "__DATA__:__NAME____RARE____LV__が__NUM__枚消滅しました";

        CONFIG::LOCALE_TH
        private static const  _VANISH_CARD_STR:String      = "__DATA__:การ์ด__NAME____RARE____LV__ได้หายไป__NUM__ใบ";


        public function VanishCardLog()
        {
            super();
        }

        public override function get type():int
        {
            return ClientLog.VANISH_CARD;
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
                ret = _VANISH_CARD_STR.replace(/__DATA__/, TimeFormat.transDateStr(date)).replace(/__NAME__/, nameData[1]).replace(/__NUM__/, nameData[4]);
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
            var id:int = int(a[0]);
            var name:String = CharaCard.ID(id).name;
            var rare:int = CharaCard.ID(id).rarity;
            var lv:int = CharaCard.ID(id).level;
            var num:int = int(a[1]);
            dateSet.unshift(new Date());
            var setData:Array = [ id, name, rare, lv, num ];
            nameSet.unshift(setData);
            if (save)
            {
                _sharedObj.flush();
            }

            // テキストを先に作ってしまう
            return setText( 0 );
///            return nameSet.length - 1;
        }


    }


}