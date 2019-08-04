package controller
{
    import flash.events.*;

    import mx.controls.*;
    import mx.events.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;

    import net.server.*;
    import net.Host;
    import model.*;
    import model.events.AvatarItemEvent;

    import view.*;


    import sound.BaseSound;
    import sound.bgm.*;
    import sound.se.*;

    /**
     * ゲーム画面コントロールクラス
     *
     */
    public class GameCtrl extends DuelCtrl
    {
        public static const DUEL:int  = 0;
        public static const QUEST:int = 1;
        public static const RAID:int  = 2;

        private static var __type:int = DUEL;

//         private static function createInstance():DuelCtrl
//         {
//             return new GameCtrl(arguments.callee);
//         }

        public static function get instance():DuelCtrl
        {
            if (__type == DUEL)
            {
                return DuelCtrl.instance;
            }else if(__type == QUEST)
            {
                return QuestCtrl.instance;
            }else if(__type == RAID)
            {
                return RaidCtrl.instance;
            }else{
                return DuelCtrl.instance;
            }
        }

        public static function  switchMode(mode:int):void
        {
            __type = mode;
        }

   }
}