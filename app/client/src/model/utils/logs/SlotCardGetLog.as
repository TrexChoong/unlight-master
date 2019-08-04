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
    public class SlotCardGetLog extends ClientLog
    {
        CONFIG::LOCALE_JP
        private static const  _GOT_SLOT_CARD_STR:String        = "__DATA__:__NAME__を入手しました。";

        CONFIG::LOCALE_EN
        private static const  _GOT_SLOT_CARD_STR:String        = "__DATA__:__NAME__ acquired.";

        CONFIG::LOCALE_TCN
        private static const  _GOT_SLOT_CARD_STR:String        = "__DATA__:您得到了__NAME__。";

        CONFIG::LOCALE_SCN
        private static const  _GOT_SLOT_CARD_STR:String        = "__DATA__:已获得__NAME__。";

        CONFIG::LOCALE_KR
        private static const  _GOT_SLOT_CARD_STR:String        = "__DATA__:__NAME__を入手しました。";

        CONFIG::LOCALE_FR
        private static const  _GOT_SLOT_CARD_STR:String        = "__DATA__:Vous avez obtenu __NAME__.";

        CONFIG::LOCALE_ID
        private static const  _GOT_SLOT_CARD_STR:String        = "__DATA__:__NAME__を入手しました。";

        CONFIG::LOCALE_TH
        private static const  _GOT_SLOT_CARD_STR:String        = "__DATA__:ได้รับ __NAME__ แล้ว";


        public function SlotCardGetLog()
        {
            super();
        }

        public override function get type():int
        {
            return ClientLog.GOT_SLOT_CARD;
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
            var name:String = nameArr[i];
            var ret:String = "";
            if (date != null && name != null)
            {
                ret = _GOT_SLOT_CARD_STR.replace(/__DATA__/, TimeFormat.transDateStr(date)).replace(/__NAME__/, name);
                _textSet.unshift(ret);
            }
            checkMax();
            return ret;
        }

        public override function setLog(a:Object, save:Boolean = false ):String
        {
            var type:int = int(a[0]);
            var id:int = int(a[1]);
            var name:String;
            switch (type)
            {
            case InventorySet.TYPE_WEAPON:
                name = WeaponCard.ID(id).name;
                break;
            case InventorySet.TYPE_EQUIP:
                name = EquipCard.ID(id).name;
                break;
            case InventorySet.TYPE_EVENT:
                name = EventCard.ID(id).name;
                break;
            }

            dateSet.unshift(new Date());
            nameSet.unshift(name);
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