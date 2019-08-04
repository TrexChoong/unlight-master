package view.utils
{
    import flash.display.*;

    public class SwfNameInfo extends Object
    {

        public static function toLog(d:DisplayObjectContainer):void
        {
            for(var i:int = 0; i < d.numChildren; i++)
            {
                log.writeLog(log.LV_FATAL, "MC NAME IS", "name:::", d.getChildAt(i).name,d.getChildAt(i));
            }

        }


    }

}