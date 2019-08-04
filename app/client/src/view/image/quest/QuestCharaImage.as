package view.image.quest
{

    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.*;
    import view.utils.*;
    import view.image.*;

    /**
     * QuestCharaImage表示クラス
     *
     */


    public class QuestCharaImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/unit_mon01.swf")]
        private var _Source00:Class;
        [Embed(source="../../../../data/image/quest/unit_chara01.swf")]
        private var _Source01:Class;
        [Embed(source="../../../../data/image/quest/unit_chara02.swf")]
        private var _Source02:Class;
        [Embed(source="../../../../data/image/quest/unit_chara03.swf")]
        private var _Source03:Class;
        [Embed(source="../../../../data/image/quest/unit_chara04.swf")]
        private var _Source04:Class;
        [Embed(source="../../../../data/image/quest/unit_chara05.swf")]
        private var _Source05:Class;
        [Embed(source="../../../../data/image/quest/unit_chara06.swf")]
        private var _Source06:Class;
        [Embed(source="../../../../data/image/quest/unit_chara07.swf")]
        private var _Source07:Class;

        [Embed(source="../../../../data/image/quest/unit_chara08.swf")]
         private var _Source08:Class;

        [Embed(source="../../../../data/image/quest/unit_chara09.swf")]
        private var _Source09:Class;

        [Embed(source="../../../../data/image/quest/unit_chara10.swf")]
         private var _Source10:Class;

        [Embed(source="../../../../data/image/quest/unit_chara11.swf")]
         private var _Source11:Class;
        [Embed(source="../../../../data/image/quest/unit_chara12.swf")]
         private var _Source12:Class;
        [Embed(source="../../../../data/image/quest/unit_chara13.swf")]
         private var _Source13:Class;
        [Embed(source="../../../../data/image/quest/unit_chara14.swf")]
         private var _Source14:Class;
        [Embed(source="../../../../data/image/quest/unit_chara15.swf")]
         private var _Source15:Class;
        [Embed(source="../../../../data/image/quest/unit_chara16.swf")]
         private var _Source16:Class;
        [Embed(source="../../../../data/image/quest/unit_chara17.swf")]
         private var _Source17:Class;
        [Embed(source="../../../../data/image/quest/unit_chara18.swf")]
         private var _Source18:Class;
        [Embed(source="../../../../data/image/quest/unit_chara19.swf")]
         private var _Source19:Class;
        [Embed(source="../../../../data/image/quest/unit_chara20.swf")]
         private var _Source20:Class;
        [Embed(source="../../../../data/image/quest/unit_chara21.swf")]
         private var _Source21:Class;
        [Embed(source="../../../../data/image/quest/unit_chara22.swf")]
         private var _Source22:Class;
        [Embed(source="../../../../data/image/quest/unit_chara23.swf")]
         private var _Source23:Class;
        [Embed(source="../../../../data/image/quest/unit_chara24.swf")]
         private var _Source24:Class;
        [Embed(source="../../../../data/image/quest/unit_chara25.swf")]
         private var _Source25:Class;
        [Embed(source="../../../../data/image/quest/unit_chara26.swf")]
         private var _Source26:Class;
        [Embed(source="../../../../data/image/quest/unit_chara27.swf")]
         private var _Source27:Class;
        [Embed(source="../../../../data/image/quest/unit_chara28.swf")]
         private var _Source28:Class;
        [Embed(source="../../../../data/image/quest/unit_chara29.swf")]
         private var _Source29:Class;
        [Embed(source="../../../../data/image/quest/unit_chara30.swf")]
         private var _Source30:Class;
        [Embed(source="../../../../data/image/quest/unit_chara31.swf")]
         private var _Source31:Class;
        [Embed(source="../../../../data/image/quest/unit_chara32.swf")]
         private var _Source32:Class;
        [Embed(source="../../../../data/image/quest/unit_chara33.swf")]
         private var _Source33:Class;
        [Embed(source="../../../../data/image/quest/unit_chara34.swf")]
         private var _Source34:Class;
        [Embed(source="../../../../data/image/quest/unit_chara35.swf")]
         private var _Source35:Class;
        [Embed(source="../../../../data/image/quest/unit_chara36.swf")]
         private var _Source36:Class;
        [Embed(source="../../../../data/image/quest/unit_chara37.swf")]
         private var _Source37:Class;
        [Embed(source="../../../../data/image/quest/unit_chara38.swf")]
         private var _Source38:Class;
        [Embed(source="../../../../data/image/quest/unit_chara39.swf")]
         private var _Source39:Class;
        [Embed(source="../../../../data/image/quest/unit_chara40.swf")]
         private var _Source40:Class;
        [Embed(source="../../../../data/image/quest/unit_chara41.swf")]
         private var _Source41:Class;
        [Embed(source="../../../../data/image/quest/unit_chara42.swf")]
         private var _Source42:Class;
        [Embed(source="../../../../data/image/quest/unit_chara43.swf")]
         private var _Source43:Class;
        [Embed(source="../../../../data/image/quest/unit_chara44.swf")]
         private var _Source44:Class;
        [Embed(source="../../../../data/image/quest/unit_chara45.swf")]
         private var _Source45:Class;
        [Embed(source="../../../../data/image/quest/unit_chara46.swf")]
         private var _Source46:Class;
        [Embed(source="../../../../data/image/quest/unit_chara47.swf")]
         private var _Source47:Class;
        [Embed(source="../../../../data/image/quest/unit_chara48.swf")]
         private var _Source48:Class;
        [Embed(source="../../../../data/image/quest/unit_chara49.swf")]
         private var _Source49:Class;
        [Embed(source="../../../../data/image/quest/unit_chara50.swf")]
         private var _Source50:Class;
        [Embed(source="../../../../data/image/quest/unit_chara51.swf")]
         private var _Source51:Class;
        [Embed(source="../../../../data/image/quest/unit_chara52.swf")]
         private var _Source52:Class;
        [Embed(source="../../../../data/image/quest/unit_chara53.swf")]
         private var _Source53:Class;
        [Embed(source="../../../../data/image/quest/unit_chara54.swf")]
         private var _Source54:Class;
        [Embed(source="../../../../data/image/quest/unit_chara55.swf")]
         private var _Source55:Class;
        [Embed(source="../../../../data/image/quest/unit_chara56.swf")]
         private var _Source56:Class;
        [Embed(source="../../../../data/image/quest/unit_chara57.swf")]
         private var _Source57:Class;
        [Embed(source="../../../../data/image/quest/unit_chara58.swf")]
         private var _Source58:Class;
        [Embed(source="../../../../data/image/quest/unit_chara59.swf")]
         private var _Source59:Class;
        [Embed(source="../../../../data/image/quest/unit_chara60.swf")]
         private var _Source60:Class;
        [Embed(source="../../../../data/image/quest/unit_chara61.swf")]
         private var _Source61:Class;
        [Embed(source="../../../../data/image/quest/unit_chara62.swf")]
         private var _Source62:Class;
        [Embed(source="../../../../data/image/quest/unit_chara63.swf")]
         private var _Source63:Class;
        [Embed(source="../../../../data/image/quest/unit_chara64.swf")]
         private var _Source64:Class;
        [Embed(source="../../../../data/image/quest/unit_chara65.swf")]
         private var _Source65:Class;
        [Embed(source="../../../../data/image/quest/unit_chara66.swf")]
         private var _Source66:Class;
        [Embed(source="../../../../data/image/quest/unit_chara67.swf")]
         private var _Source67:Class;
        [Embed(source="../../../../data/image/quest/unit_chara68.swf")]
         private var _Source68:Class;
        [Embed(source="../../../../data/image/quest/unit_chara69.swf")]
         private var _Source69:Class;
        [Embed(source="../../../../data/image/quest/unit_chara70.swf")]
         private var _Source70:Class;
        [Embed(source="../../../../data/image/quest/unit_chara71.swf")]
         private var _Source71:Class;
        [Embed(source="../../../../data/image/quest/unit_chara72.swf")]
         private var _Source72:Class;
        [Embed(source="../../../../data/image/quest/unit_chara73.swf")]
         private var _Source73:Class;
        [Embed(source="../../../../data/image/quest/unit_chara74.swf")]
         private var _Source74:Class;
        [Embed(source="../../../../data/image/quest/unit_chara75.swf")]
         private var _Source75:Class;
        [Embed(source="../../../../data/image/quest/unit_chara76.swf")]
         private var _Source76:Class;
        [Embed(source="../../../../data/image/quest/unit_chara77.swf")]
         private var _Source77:Class;
        [Embed(source="../../../../data/image/quest/unit_chara01n.swf")]
         private var _Source01n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara02n.swf")]
         private var _Source02n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara03n.swf")]
         private var _Source03n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara04n.swf")]
         private var _Source04n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara05n.swf")]
         private var _Source05n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara06n.swf")]
         private var _Source06n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara07n.swf")]
         private var _Source07n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara08n.swf")]
         private var _Source08n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara09n.swf")]
         private var _Source09n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara10n.swf")]
         private var _Source10n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara11n.swf")]
         private var _Source11n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara12n.swf")]
         private var _Source12n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara13n.swf")]
         private var _Source13n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara14n.swf")]
         private var _Source14n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara15n.swf")]
         private var _Source15n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara16n.swf")]
         private var _Source16n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara17n.swf")]
         private var _Source17n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara18n.swf")]
         private var _Source18n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara19n.swf")]
         private var _Source19n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara20n.swf")]
         private var _Source20n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara22n.swf")]
         private var _Source22n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara24n.swf")]
         private var _Source24n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara26n.swf")]
         private var _Source26n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara27n.swf")]
         private var _Source27n:Class;
        [Embed(source="../../../../data/image/quest/unit_chara28n.swf")]
         private var _Source28n:Class;


        private var _SourceSet:Vector.<Class> = Vector.<Class>([_Source00,
                                                                _Source01, _Source02, _Source03, _Source04, _Source05, _Source06, _Source07, _Source08, _Source09, _Source10,
                                                                _Source11, _Source12, _Source13, _Source14, _Source15, _Source16, _Source17, _Source18, _Source19, _Source20,
                                                                _Source21, _Source22, _Source23, _Source24, _Source25, _Source26, _Source27, _Source28, _Source29, _Source30,
                                                                _Source31, _Source32, _Source33, _Source34, _Source35, _Source36, _Source37, _Source38, _Source39, _Source40,
                                                                _Source41, _Source42, _Source43, _Source44, _Source45, _Source46, _Source47, _Source48, _Source49, _Source50,
                                                                _Source51, _Source52, _Source53, _Source54, _Source55, _Source56, _Source57, _Source58, _Source59, _Source60,
                                                                _Source61, _Source62, _Source63, _Source64, _Source65, _Source66, _Source67, _Source68, _Source69, _Source70,
                                                                _Source71, _Source72, _Source73, _Source74, _Source75, _Source76, _Source77]);

        private var _SourceSetReborn:Vector.<Class> = Vector.<Class>([_Source00,
                                                                      _Source01n, _Source02n, _Source03n, _Source04n, _Source05n, _Source06n, _Source07n, _Source08n, _Source09,  _Source10,
                                                                      _Source11n, _Source12n, _Source13n, _Source14n, _Source15n, _Source16n, _Source17n, _Source18n, _Source19n, _Source20,
                                                                      _Source00,  _Source22n,  _Source00,  _Source24n, _Source00, _Source26n, _Source27n, _Source28n]);

        private static const X:int = 0;
        private static const Y:int = 0;
        public static const TYPE_FRAME:int  = 1;
        public static const TYPE_PASS:int  = 3;
        public static const TYPE_END:int  = 3;
        public static const TYPE_START:int  = 4;
        private static const REBORN_CHARA_BASE_ID:int = 4000;

        private var _passMC:MovieClip;
        private var _pos:int = 1;
        private var _type:int = 0;


        /**
         * コンストラクタ
         *
         */
        public function QuestCharaImage(t:int)
        {
            log.writeLog(log.LV_FATAL, this, "rage",_SourceSet.length,t);
            if (t > REBORN_CHARA_BASE_ID)
            {
                _type = t - REBORN_CHARA_BASE_ID < _SourceSetReborn.length ? t : 0;
            }
            else
            {
                _type = t < _SourceSet.length ? t : 0
            }
            log.writeLog(log.LV_FATAL, this, "rage",_type);
            super();
        }


        protected override function get Source():Class
        {
//            log.writeLog(log.LV_FATAL, this, "++++++++++++++++",_type);
            if (_type > REBORN_CHARA_BASE_ID)
            {
                return _SourceSetReborn[_type - REBORN_CHARA_BASE_ID];
            }
            else
            {
                return _SourceSet[_type];
            }
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
        }

    }

}

