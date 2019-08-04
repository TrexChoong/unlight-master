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
    public class ItemGetLog extends ClientLog
    {
        CONFIG::LOCALE_JP
        private static const  _GOT_ITEM_STR:String        = "__DATA__:__NAME__を入手しました。";

        CONFIG::LOCALE_EN
        private static const  _GOT_ITEM_STR:String        = "__DATA__:__NAME__ acquired";

        CONFIG::LOCALE_TCN
        private static const  _GOT_ITEM_STR:String        = "__DATA__:您得到了__NAME__。";

        CONFIG::LOCALE_SCN
        private static const  _GOT_ITEM_STR:String        = "__DATA__:已获得__NAME__。";

        CONFIG::LOCALE_KR
        private static const  _GOT_ITEM_STR:String        = "__DATA__:__NAME__を入手しました。";

        CONFIG::LOCALE_FR
        private static const  _GOT_ITEM_STR:String        = "__DATA__:Vous avez obtenu __NAME__.";

        CONFIG::LOCALE_ID
        private static const  _GOT_ITEM_STR:String        = "__DATA__:__NAME__を入手しました。";

        CONFIG::LOCALE_TH
        private static const  _GOT_ITEM_STR:String        = "__DATA__:ได้รับ __NAME__ แล้ว";


        public function ItemGetLog()
        {
            super();
        }

        public override function get type():int
        {
            return ClientLog.GOT_ITEM;
        }


        public override function getLog(i:int):String
        {
            log.writeLog(log.LV_INFO, this, "getLOGGG",i,_textSet);
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
            var ret:String = "";
//            log.writeLog(log.LV_INFO, this, "setTxt", i,name,num);
            if (date != null && nameArr[i] != null)
            {
                var name:String = nameArr[i].split(",")[0];
                var num:String = nameArr[i].split(",")[1];
                if(num == "1")
                {
                    ret = _GOT_ITEM_STR.replace(/__DATA__/, TimeFormat.transDateStr(date)).replace(/__NAME__/,name);
                }else{
                    ret = _GOT_ITEM_STR.replace(/__DATA__/, TimeFormat.transDateStr(date)).replace(/__NAME__/,name) + "X"+num;
                    log.writeLog(log.LV_INFO, this, "setText text ",ret);
                }

                if(_textSet[0]==null||_textSet[0].replace(/X\d*/,"") != ret)
                {
                    _textSet.unshift(ret);
                }else{
                    log.writeLog(log.LV_INFO, this, "setText num ",_textSet[0]);
                    var n:int = 1;
                    if (_textSet[0].match(/X\d*/)!=null)
                    {
                        n=int(_textSet[0].match(/X\d*/)[0].replace(/X/,""));
                    }
                    n+=1;
                    _textSet[0] = _textSet[0].replace(/X\d*/,"")+"X"+n.toString();
                    log.writeLog(log.LV_INFO, this, "setText num2 ",_textSet[0]);

                    dateSet.shift();
                    nameSet.shift();
                    nameSet[0] = name +","+ n.toString();
                    log.writeLog(log.LV_INFO, this, "setText num2 ",nameSet);
                    _sharedObj.flush();
                }
            }
            checkMax();
            return ret;
        }

        public override function setLog(a:Object, save:Boolean = false ):String
        {
            var id:int = int(a);


            var name:String = AvatarItem.ID(id).name;

            dateSet.unshift(new Date());
            nameSet.unshift(name+",1");
            if (save)
            {
                _sharedObj.flush();
            }

            // テキストを先に作ってしまう
            return  setText( 0 );
//nameSet.length - 1;

        }


    }


}