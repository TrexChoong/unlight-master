package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class AvatarQuestEvent extends Event
    {
        public static const GET_QUEST:String = 'get_quest';
        public static const USE_QUEST:String = 'use_quest';

        public var obj:*;
        public var id:int;

        public function AvatarQuestEvent(type:String, o:* = null, i:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i
            obj = o;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("AvatarQuestEvent", "type", "obj", "id", "bubbles", "cancelable"); 
        }

    }

 
}