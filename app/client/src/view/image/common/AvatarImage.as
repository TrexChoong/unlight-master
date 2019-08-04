package view.image.common
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;
    import view.utils.*;
    /**
     * アバターのベース表示クラス
     *
     */

    public class AvatarImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/avatar_rig.swf")]

        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        // インスタンスプライオリティ定数 (大きいほど手前)

        public static const HEAD:int = 0;
        public static const MIDDLE:int = 1;
        public static const CHEST:int = 2;

        public static const ARM_U_L:int  = 3;
        public static const ARM_F_L:int  = 4;
        public static const HAND_L:int   = 5;
        public static const THIGH_L:int  = 6;
        public static const SHIN_L:int   = 7;
        public static const FOOT_L:int   = 8;

        public static const ARM_U_R:int = 9;
        public static const ARM_F_R:int = 10;
        public static const HAND_R:int  = 11;
        public static const THIGH_R:int = 12;
        public static const SHIN_R:int  = 13;
        public static const FOOT_R:int  = 14;

        // インスタンス名定数
        private static const INS_HEAD:String = "head";
        private static const INS_MIDDLE:String = "middle";
        private static const INS_CHEST:String = "chest";

        private static const INS_ARM_U_L:String  = "arm_u_L" ; // 左上腕
        private static const INS_ARM_F_L:String  = "arm_f_L";  // 左下椀
        private static const INS_HAND_L:String   = "hand_L";   // 左手
        private static const INS_THIGH_L:String  = "thigh_L";    // 左腿
        private static const INS_SHIN_L:String   = "shin_L";   // 左脛
        private static const INS_FOOT_L:String   = "foot_L";   // 左足

        private static const INS_ARM_U_R:String = "arm_u_R";   // 右上腕
        private static const INS_ARM_F_R:String = "arm_f_R";   // 右下椀
        private static const INS_HAND_R:String  = "hand_R";    // 右手
        private static const INS_THIGH_R:String = "thigh_R";   // 右腿
        private static const INS_SHIN_R:String  = "shin_R";    // 右脛
        private static const INS_FOOT_R:String  = "foot_R";    // 右足

        private var _head:MovieClip;  // 頭
        private var _middle:MovieClip; // 腰
        private var _chest:MovieClip;  // 背中

        private var _arm_u_L:MovieClip; // 左上腕
        private var _arm_f_L:MovieClip; // 左下椀
        private var _hand_L:MovieClip;  // 左手
        private var _thigh_L:MovieClip; // 左腿
        private var _shin_L:MovieClip;  // 左脛
        private var _foot_L:MovieClip;  // 左足

        private var _arm_u_R:MovieClip; // 右上腕
        private var _arm_f_R:MovieClip; // 右下椀
        private var _hand_R:MovieClip;  // 右手
        private var _thigh_R:MovieClip; // 右腿
        private var _shin_R:MovieClip;  // 右脛
        private var _foot_R:MovieClip;  // 右足



        private var _insSet:Array = []; /* of MovieClip */ 

        /**
         * コンストラクタ
         *
         */
        public function AvatarImage()
        {
            super();
            mouseChildren = false;
            mouseEnabled = false;
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
//            SwfNameInfo.toLog(_root);

            _head     =  MovieClip(_root.getChildByName(INS_HEAD));
            _middle   =  MovieClip(_root.getChildByName(INS_MIDDLE));
            _chest    =  MovieClip(_root.getChildByName(INS_CHEST));
            _arm_u_L  =  MovieClip(_root.getChildByName(INS_ARM_U_L));
            _arm_f_L  =  MovieClip(_root.getChildByName(INS_ARM_F_L));
            _hand_L   =  MovieClip(_root.getChildByName(INS_HAND_L));
            _thigh_L  =  MovieClip(_root.getChildByName(INS_THIGH_L));
            _shin_L   =  MovieClip(_root.getChildByName(INS_SHIN_L));
            _foot_L   =  MovieClip(_root.getChildByName(INS_FOOT_L));
            _arm_u_R  =  MovieClip(_root.getChildByName(INS_ARM_U_R));
            _arm_f_R  =  MovieClip(_root.getChildByName(INS_ARM_F_R));
            _hand_R   =  MovieClip(_root.getChildByName(INS_HAND_R));
            _thigh_R  =  MovieClip(_root.getChildByName(INS_THIGH_R));
            _shin_R   =  MovieClip(_root.getChildByName(INS_SHIN_R));
            _foot_R   =  MovieClip(_root.getChildByName(INS_FOOT_R));

            _insSet.push(_head);
            _insSet.push(_middle);
            _insSet.push(_chest);
            _insSet.push(_arm_u_L);
            _insSet.push(_arm_f_L);
            _insSet.push(_hand_L);
            _insSet.push(_thigh_L);
            _insSet.push(_shin_L);
            _insSet.push(_foot_L);
            _insSet.push(_arm_u_R);
            _insSet.push(_arm_f_R);
            _insSet.push(_hand_R);
            _insSet.push(_thigh_R);
            _insSet.push(_shin_R);
            _insSet.push(_foot_R);

            initializePos();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
        }

        public function getIns(i:int):MovieClip
        {
            return _insSet[i];
        }


    }

}
