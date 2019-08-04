package view.utils
{
     import flash.events.*;

     import mx.containers.*;
     import mx.controls.*;
     import mx.events.*;

     import model.events.*;


     public class ValidTextInput extends TextInput
     {

         public static const VALID_OK:String = "valid_ok";

         public static const USER_NAME:String = "userName";
         public static const DECK_NAME:String = "deckName";
         public static const ROOM_NAME:String = "roomName";

         private var _beforeStr:String;
         private var _type:String;


         public function ValidTextInput(enterCheck:Boolean = true,type:String = USER_NAME)
         {
             if (enterCheck)
             {
                 addEventListener(FlexEvent.ENTER,enterHandler,false,1024);
             }
             _type = type;
             super();
         }

         private function enterHandler(e:FlexEvent):void
         {
             dispatchEvent(new Event(VALID_OK));
         }

         public function validate():void
         {
             dispatchEvent(new Event(VALID_OK));
         }
     }
}