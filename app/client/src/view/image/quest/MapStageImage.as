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
     * MapStageImage表示クラス
     *
     */


    public class MapStageImage extends BaseImage
    {
//         [Embed(source="../../../../data/image/quest/land_sl_plane")]
//             private var _SourceCastle:Class;
        [Embed(source="../../../../data/image/quest/land_sl_gate.swf")]
            private var _SourceCastle:Class;
        [Embed(source="../../../../data/image/quest/land_sl_forest.swf")]
            private var _SourceForest:Class;
        [Embed(source="../../../../data/image/quest/land_sl_road.swf")]
            private var _SourceRoad:Class;
        [Embed(source="../../../../data/image/quest/land_sl_lake.swf")]
            private var _SourceLake:Class;
        [Embed(source="../../../../data/image/quest/land_sl_cemetery.swf")]
            private var _SourceGrave:Class;
        [Embed(source="../../../../data/image/quest/land_sl_village.swf")]
            private var _SourceVillage:Class;
        [Embed(source="../../../../data/image/quest/land_sl_wilderness.swf")]
            private var _SourceWild:Class;
        [Embed(source="../../../../data/image/quest/land_sl_ruin.swf")]
            private var _SourceRuin:Class;
        [Embed(source="../../../../data/image/quest/land_sl_lake.swf")]
            private var _SourceTown:Class;
        [Embed(source="../../../../data/image/quest/land_sl_lake.swf")]
            private var _SourcePlane:Class;
        [Embed(source="../../../../data/image/quest/land_ml_castle.swf")]
            private var _SourceMlCastle:Class;
        [Embed(source="../../../../data/image/quest/land_am_wasteland.swf")]
            private var _SourceMoor:Class;
        [Embed(source="../../../../data/image/quest/land_am_stone.swf")]
            private var _SourceStone:Class;
        [Embed(source="../../../../data/image/quest/land_al_arch.swf")]
            private var _SourceGate:Class;
        [Embed(source="../../../../data/image/quest/land_end_throne.swf")]
            private var _SourceThrone:Class;

        // 0:城ステージ，1:森ステージ,2:街道, 3:湖畔, 4:墓場,  5:村, 6:荒野, 7:遺跡, 8:街, 9:平原
        private var _SourceSet:Vector.<Class> = Vector.<Class>([
                                                                   _SourceCastle,
                                                                   _SourceForest,
                                                                   _SourceRoad,
                                                                   _SourceLake,
                                                                   _SourceGrave,
                                                                   _SourceVillage,
                                                                   _SourceWild,
                                                                   _SourceRuin,
                                                                   _SourceTown,
                                                                   _SourcePlane,
                                                                   _SourceMlCastle,
                                                                   _SourceMoor,
                                                                   _SourceLake,
                                                                   _SourceStone,
                                                                   _SourceGate,
                                                                   _SourceThrone
                                                                   ]);

        private static const ENABLE:String = "en"
        private static const DISABLE:String = "dis"


//        private var _stageMC:MovieClip;
        private var _type:int = 0;
        private var _enableSB:SimpleButton;
        private var _disableSB:MovieClip;
        private var _enable:Boolean;

        /**
         * コンストラクタ
         *
         */
        public function MapStageImage(type:int)
        {
//            log.writeLog(log.LV_FATAL, this, "type is ", type);
            _type = type;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
//             SwfNameInfo.toLog(_root);
            _enableSB = SimpleButton(_root.getChildByName(ENABLE));
            _disableSB = MovieClip(_root.getChildByName(DISABLE));
            _enable = false;
            setEnable()
        }

        private function setEnable():void
        {
            if (_enable)
            {
                _enableSB.visible = true;
                _disableSB.visible = false;
            }else{
                _enableSB.visible = false;
                _disableSB.visible = true;
            }
            
        }

        public function enable(e:Boolean):void
        {
            _enable = e;
            waitComplete(setEnable);
        }

        protected override function get Source():Class
        {
            return _SourceSet[_type];
        }



    }

}

