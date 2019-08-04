package model
{
    import flash.events.*;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import model.*;

    public class Feed
    {

      CONFIG::LOCALE_JP
      private static const _GOT_RARE_CARD_TITLE:String = "レアカードGET!!";
      CONFIG::LOCALE_JP
      private static const _GOT_RARE_CARD_MESS:String ="__NICKNAME__はレアカード「__CARD_NAME__」をゲットしました";

      private static const _GOT_RARE_CARD_IMAGE:String =   "/public/image/feeds/feed_rare.gif";   // 0

      CONFIG::LOCALE_EN
      private static const _GOT_RARE_CARD_TITLE:String = "You received a rare card!";
      CONFIG::LOCALE_EN
      private static const _GOT_RARE_CARD_MESS:String ="__NICKNAME__ acquired the rare card [__CARD_NAME__].";

      CONFIG::LOCALE_TCN
      private static const _GOT_RARE_CARD_TITLE:String = "稀有卡GET!!";
      CONFIG::LOCALE_TCN
      private static const _GOT_RARE_CARD_MESS:String ="__NICKNAME__得到了稀有卡片「__CARD_NAME__」";

      CONFIG::LOCALE_SCN
      private static const _GOT_RARE_CARD_TITLE:String = "稀有卡GET！！";
      CONFIG::LOCALE_SCN
      private static const _GOT_RARE_CARD_MESS:String ="__NICKNAME__获得了稀有卡「__CARD_NAME__」";


      CONFIG::LOCALE_KR
      private static const _GOT_RARE_CARD_TITLE:String = "レアカードGET!!";
      CONFIG::LOCALE_KR
      private static const _GOT_RARE_CARD_MESS:String ="__NICKNAME__はレアカード「__CARD_NAME__」をゲットしました";

      CONFIG::LOCALE_FR
      private static const _GOT_RARE_CARD_TITLE:String = "Vous avez obtenu une carte rare !!";
      CONFIG::LOCALE_FR
      private static const _GOT_RARE_CARD_MESS:String ="__NICKNAME__ a obtenu la carte [ __CARD_NAME__ ] ";

      CONFIG::LOCALE_ID
      private static const _GOT_RARE_CARD_TITLE:String = "レアカードGET!!";
      CONFIG::LOCALE_ID
      private static const _GOT_RARE_CARD_MESS:String ="__NICKNAME__はレアカード「__CARD_NAME__」をゲットしました";

      CONFIG::LOCALE_TH
      private static const _GOT_RARE_CARD_TITLE:String = "ได้รับแรร์การ์ด!";
      CONFIG::LOCALE_TH
      private static const _GOT_RARE_CARD_MESS:String = "__NICKNAME__ได้แรร์การ์ด [__CARD_NAME__] มาแล้ว";


        public static function clientAcitivityUpdate(activityTitle:String, activityMess:String, activityImage:String):void
        {
            log.writeLog(log.LV_INFO, "Feed", "clientActitivityFeed", activityTitle,activityMess,activityImage);
            if (activityMess != "")
            {

            }

        }

        public static function clientAcitivityUpdateRareCard(cardID:int):void
        {
            var cardName:String = CharaCard.ID(cardID).name;
            var cardLevel:String = CharaCard.ID(cardID).level.toString();
            cardName = cardName+":LV"+cardLevel;
            clientAcitivityUpdate(_GOT_RARE_CARD_TITLE, _GOT_RARE_CARD_MESS.replace("__CARD_NAME__",cardName),_GOT_RARE_CARD_IMAGE);

        }

    }



}