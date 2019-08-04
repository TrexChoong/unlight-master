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
    public class CharaCardGetLog extends ClientLog
    {
        CONFIG::LOCALE_JP
        private static const  _GOT_CHARA_CARD_STR:String        = "__DATA__:__NAME____RARE____LV__を入手しました。";

        CONFIG::LOCALE_EN
        private static const  _GOT_CHARA_CARD_STR:String        = "__DATA__:__NAME__ __RARE____LV__ acquired.";

        CONFIG::LOCALE_TCN
        private static const  _GOT_CHARA_CARD_STR:String        = "__DATA__:您得到了__NAME____RARE____LV__。";

        CONFIG::LOCALE_SCN
        private static const  _GOT_CHARA_CARD_STR:String        = "__DATA__:已获得__NAME____RARE____LV__。";

        CONFIG::LOCALE_KR
        private static const  _GOT_CHARA_CARD_STR:String        = "__DATA__:__NAME____RARE____LV__を入手しました。";

        CONFIG::LOCALE_FR
        private static const  _GOT_CHARA_CARD_STR:String        = "__DATA__:Vous avez obtenu __NAME__ __RARE____LV__.";

        CONFIG::LOCALE_ID
        private static const  _GOT_CHARA_CARD_STR:String        = "__DATA__:__NAME____RARE____LV__を入手しました。";

        CONFIG::LOCALE_TH
        private static const  _GOT_CHARA_CARD_STR:String        = "__DATA__:ได้รับ __NAME____RARE____LV__ แล้ว";


        public function CharaCardGetLog()
        {
            super();
        }

        public override function get type():int
        {
            return ClientLog.GOT_CHARA_CARD;
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
            var nameData:Array  = nameArr[i];
            var ret:String = "";
            if (date != null && nameData != null)
            {
                ret = _GOT_CHARA_CARD_STR.replace(/__DATA__/, TimeFormat.transDateStr(date)).replace(/__NAME__/, nameData[1]);
                if ( nameData[1] < 1000 ) {
                    ret = ret.replace(/__LV__/, " Lv."+nameData[3]);
                    if ( nameData[3] > 5 ) {
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

            var name:String = CharaCard.ID(id).name;
            var rare:int    = CharaCard.ID(id).rarity;
            var lv:int      = CharaCard.ID(id).level;

            var setData:Array = [ id, name, rare, lv ];
            dateSet.unshift(new Date());
            nameSet.unshift(setData);
            if (save)
            {
                _sharedObj.flush();
            }

            // テキストを先に作ってしまう
            return setText( 0 );
//            return nameSet.length - 1;
        }


    }


}