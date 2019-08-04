package view.image.quest
{

    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import model.QuestMap;
    import view.*;
    import view.utils.*;
    import view.image.*;


    import controller.QuestCtrl;

    /**
     * WorldMapImage表示クラス
     *
     */


    public class WorldMapImage extends BaseImage
    {
        // MAP表示元SWF
        [Embed(source="../../../../data/image/quest/map01.swf")]
        private var _Source01:Class;
        [Embed(source="../../../../data/image/quest/map02.swf")]
        private var _Source02:Class;
        [Embed(source="../../../../data/image/quest/map03.swf")]
        private var _Source03:Class;
        [Embed(source="../../../../data/image/quest/map04.swf")]
        private var _Source04:Class;
        [Embed(source="../../../../data/image/quest/map05.swf")]
        private var _Source05:Class;
        [Embed(source="../../../../data/image/quest/map06.swf")]
        private var _Source06:Class;
        [Embed(source="../../../../data/image/quest/map_e00.swf")]
        private var _Source100:Class;
        [Embed(source="../../../../data/image/quest/map_e07.swf")]
        private var _Source101:Class;
        [Embed(source="../../../../data/image/quest/map_vote.swf")]
        private var _Source102:Class;

        private static const X:int = 0;
        private static const Y:int = 0;
        private static const MAP_NO:int = 0;
        private static const MAP_REGION:int = 1;
        public static const TYPE_FRAME:int  = 1;
        public static const TYPE_PASS:int   = 2;
        public static const TYPE_END:int    = 3;
        public static const TYPE_START:int  = 4;

        private const MAP_CLASS_SET:Array = [_Source01, _Source02, _Source03, _Source04, _Source05, _Source06]; /* of Class */ 
        private const EVENT_MAP_CLASS_SET:Array = [_Source101]; /* of Class */ 
        private const TUTORIAL_MAP_CLASS_SET:Array = [_Source100]; /* of Class */ 
        private const CHARA_VOTE_MAP_CLASS_SET:Array = [_Source102]; /* of Class */ 
        private const CLASS_SET_LIST:Array = [MAP_CLASS_SET,EVENT_MAP_CLASS_SET,TUTORIAL_MAP_CLASS_SET,CHARA_VOTE_MAP_CLASS_SET];

        public static const MAP_BUTTON_SET:Array = 
            [
                [
                    "btn_map01_a",
                    "btn_map01_b",
                    "btn_map01_c"
                    ],
                [
                    "btn_map02_a",
                    "btn_map02_b",
                    "btn_map02_c",
                    "btn_map02_d",
                    "btn_map02_e",
                    "btn_map02_f",
                    "btn_map02_g",
                    "btn_map02_h"
                    ],
                [
                    "btn_map03_a",
                    "btn_map03_b",
                    "btn_map03_c",
                    "btn_map03_d",
                    "btn_map03_e",
                    "btn_map03_f",
                    "btn_map03_g",
                    "btn_map03_h"
                    ],
                [
                    "btn_map04_a",
                    "btn_map04_b",
                    "btn_map04_c",
                    "btn_map04_d",
                    "btn_map04_e",
                    "btn_map04_f",
                    "btn_map04_g",
                    "btn_map04_h"
                    ],
                [
                    "btn_map05_a",
                    "btn_map05_b",
                    "btn_map05_c",
                    "btn_map05_d",
                    "btn_map05_e",
                    "btn_map05_f",
                    "btn_map05_g",
                    "btn_map05_h"
                    ],
                [
                    "btn_map06_a"
                    ]

                ];
        /* of Strrig*/
        public static const MAP_ENABLE_SET:Array = 
            [
                [
                    "map01_a",
                    "map01_b",
                    "map01_c"
                    ],
                [
                    "map02_a",
                    "map02_b",
                    "map02_c",
                    "map02_d",
                    "map02_e",
                    "map02_f",
                    "map02_g",
                    "map02_h"
                    ],
                [
                    "map03_a",
                    "map03_b",
                    "map03_c",
                    "map03_d",
                    "map03_e",
                    "map03_f",
                    "map03_g",
                    "map03_h"
                    ],
                [
                    "map04_a",
                    "map04_b",
                    "map04_c",
                    "map04_d",
                    "map04_e",
                    "map04_f",
                    "map04_g",
                    "map04_h"
                    ],
                [
                    "map05_a",
                    "map05_b",
                    "map05_c",
                    "map05_d",
                    "map05_e",
                    "map05_f",
                    "map05_g",
                    "map05_h"
                    ],
                [
                    "map06_a"
                    ]

            ]; /* of Strrig*/
        public static const EVENT_MAP_BUTTON_SET:Array = 
            [
                [
                    "btn_map_e0_a",
                    "btn_map_e0_b",
                    "btn_map_e0_c",
                    "btn_map_e0_d",
                    "btn_map_e0_e",
//                    "btn_map_e0_f",
                    ],
                ];
        public static const EVENT_MAP_ENABLE_SET:Array = 
            [
                [
                    "map_e0_a",
                    "map_e0_b",
                    "map_e0_c",
                    "map_e0_d",
                    "map_e0_e",
//                    "map_e0_f",
                    ],
                ];
        public static const TUTORIAL_MAP_BUTTON_SET:Array = 
            [
                [
                    "btn_map_e0_a",
                    "btn_map_e0_b",
                    "btn_map_e0_c",
                    "btn_map_e0_d",
                    "btn_map_e0_e",
                    ],
                ];
        public static const TUTORIAL_MAP_ENABLE_SET:Array = 
            [
                [
                    "map_e0_a",
                    "map_e0_b",
                    "map_e0_c",
                    "map_e0_d",
                    "map_e0_e",
                    ],
                ];
        public static const CHARA_VOTE_MAP_BUTTON_SET:Array = 
            [
                [
                    "btn_map_vote_a",
                    "btn_map_vote_b",
                    "btn_map_vote_c",
                    "btn_map_vote_d",
                    // "btn_map_vote_e",
                    // "btn_map_vote_f",
                    // "btn_map_vote_g",
                    // "btn_map_vote_h",
                    // "btn_map_vote_i",
                    // "btn_map_vote_j",
                    ],
                ];
        public static const CHARA_VOTE_MAP_ENABLE_SET:Array = 
            [
                [
                    "map_vote_a",
                    "map_vote_b",
                    "map_vote_c",
                    "map_vote_d",
                    "map_vote_e",
                    "map_vote_f",
                    // "map_vote_g",
                    // "map_vote_h",
                    // "map_vote_i",
                    // "map_vote_j",
                    ],
                ];
        public static const BUTTON_SET_LIST:Array = [MAP_BUTTON_SET,EVENT_MAP_BUTTON_SET,TUTORIAL_MAP_BUTTON_SET,CHARA_VOTE_MAP_BUTTON_SET];
        public static const ENABLE_SET_LIST:Array = [MAP_ENABLE_SET,EVENT_MAP_ENABLE_SET,TUTORIAL_MAP_ENABLE_SET,CHARA_VOTE_MAP_ENABLE_SET];

        private var _shadowLandButton:SimpleButton;
        private var _fade:Boolean = false;
        private var _ct:ColorTransform = new ColorTransform(0.3,0.3,0.3);// トーンを半分に
        private var _ct2:ColorTransform = new ColorTransform(1.0,1.0,1.0);// トーンを半分に

        private var _ctrl:QuestCtrl = QuestCtrl.instance;


        private var _mapNo:int = 0;
        private var _regionNo:int = 0;
        private var _questFlag:int = 0;

        private var _buttonSet:Array = []; /* of SimpleButton */ 
        private var _mcSet:Vector.<MovieClip> = new Vector.<MovieClip>();

        private var _nextButton:SimpleButton;
        private var _backButton:SimpleButton;

        public static const NEXT:String = "next";
        public static const BACK:String = "back";

        private static var __ereaMapNo:int = 5;
        private static var __questType:int = Const.QUEST_NORMAL;

        public static function get ereaMapNo():int
        {
            return __ereaMapNo;
        }

        // 最新のマップを表示
        public static function getNewestWorldMapImage(questFlag:int=0,type:int=Const.QUEST_NORMAL):WorldMapImage
        {
            __questType = type;
            var mapStartNo:int = 0;
            if (type == Const.QUEST_EVENT) {
                mapStartNo = QuestMap.EVENT_QUEST_START_ID;
            } else if (type == Const.QUEST_TUTORIAL) {
                mapStartNo = QuestMap.TUTORIAL_QUEST_START_ID;
            } else if (type == Const.QUEST_CHARA_VOTE) {
                mapStartNo = QuestMap.CHARA_VOTE_QUEST_START_ID;
            }
            var flagMaps:Array = Const.QUEST_FLAG_MAP_LIST[__questType];
            var mapNo:int = questFlag-mapStartNo;
            log.writeLog(log.LV_DEBUG, "WorldMapImage", "getNewestWorldMapImage",__questType,flagMaps,mapStartNo);
            // 進行度が最大を超えている場合
            if (flagMaps.length <= mapNo) {
                mapNo = flagMaps.length - 1;
            }
            log.writeLog(log.LV_DEBUG, "WorldMapImage", "getNewestWorldMapImage",questFlag,__questType,mapNo);
            __ereaMapNo = Const.QUEST_FLAG_MAP_LIST[__questType][mapNo][MAP_NO];
            return new WorldMapImage(questFlag,type);
        }
        // 一つ前のマップを表示
        public static function getPrevWorldMapImage(questFlag:int):WorldMapImage
        {
            __ereaMapNo -= 1;
            if (__ereaMapNo < 0) {__ereaMapNo = 0;}
            return new WorldMapImage(questFlag,__questType)
        }
        // 一つ先のマップを表示
        public static function getNextWorldMapImage(questFlag:int):WorldMapImage
        {
            __ereaMapNo += 1;
            var flagMaps:Array = Const.QUEST_FLAG_MAP_LIST[__questType];
            var ereaMax:int = flagMaps[flagMaps.length-1][MAP_NO];
            if (__ereaMapNo > ereaMax) {__ereaMapNo = ereaMax;}
            return new WorldMapImage(questFlag,__questType)
        }
        // 特定のマップへ移動
        public static function getIndexWorldMapImage(questFlag:int,idx:int,type:int=Const.QUEST_NORMAL):WorldMapImage
        {
            __questType = type;
            __ereaMapNo = idx;
            var flagMaps:Array = Const.QUEST_FLAG_MAP_LIST[__questType];
            var ereaMax:int = flagMaps[flagMaps.length-1][MAP_NO]
            if (__ereaMapNo < 0) {__ereaMapNo = 0;}
            else if (__ereaMapNo > ereaMax) {__ereaMapNo = ereaMax;}
            return new WorldMapImage(questFlag,__questType)
        }

        /**
         * コンストラクタ
         *
         */
        public function WorldMapImage(questFlag:int = 0, type:int = Const.QUEST_NORMAL)
        {
            var param:int = 0;
            for (var i:int = 0; i <= __ereaMapNo; i++) {
                param = param+questMapNum[i];
            }
            if (type == Const.QUEST_EVENT) {
                param += QuestMap.EVENT_QUEST_START_ID;
            } else if (type == Const.QUEST_TUTORIAL) {
                param += QuestMap.TUTORIAL_QUEST_START_ID;
            } else if (type == Const.QUEST_CHARA_VOTE) {
                param += QuestMap.CHARA_VOTE_QUEST_START_ID;
            }
            _ctrl.currentMapNo = questFlag < (param-1) ? questFlag : (param-1);

            var mapStartNo:int = 0;
            if (type == Const.QUEST_EVENT) {
                mapStartNo = QuestMap.EVENT_QUEST_START_ID;
            } else if (type == Const.QUEST_TUTORIAL) {
                mapStartNo = QuestMap.TUTORIAL_QUEST_START_ID;
            } else if (type == Const.QUEST_CHARA_VOTE) {
                mapStartNo = QuestMap.CHARA_VOTE_QUEST_START_ID;
            }

            _questFlag = questFlag;
            log.writeLog(log.LV_DEBUG, "WorldMapImage", "constructa",_ctrl.currentMapNo,mapStartNo,questFlagMap[_ctrl.currentMapNo-mapStartNo][MAP_NO]);
            _mapNo = questFlagMap[_ctrl.currentMapNo-mapStartNo][MAP_NO];
            _regionNo = questFlagMap[_ctrl.currentMapNo-mapStartNo][MAP_REGION];

            super();
        }

        private function get questFlagMap():Array
        {
            return Const.QUEST_FLAG_MAP_LIST[__questType];
        }
        private function get questMapNum():Array
        {
            return Const.QUEST_MAP_NUM_LIST[__questType];
        }
        private function get mapButtonSet():Array
        {
            return BUTTON_SET_LIST[__questType];
        }
        private function get mapEnableSet():Array
        {
            return ENABLE_SET_LIST[__questType];
        }

        protected override function get Source():Class
        {
            log.writeLog(log.LV_FATAL, this, "source !!!!!!!!!!!!!!!!!!!!!!!!!",__questType, _mapNo, CLASS_SET_LIST[__questType][_mapNo]);
            return CLASS_SET_LIST[__questType][_mapNo];
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            log.writeLog(log.LV_FATAL, this, "========================================================");
            SwfNameInfo.toLog(_root);
            log.writeLog(log.LV_FATAL, this, "========================================================");

            log.writeLog(log.LV_DEBUG, this, "swfinit",_mapNo,questMapNum[_mapNo],_regionNo);

            for(var i:int = 0; i < questMapNum[_mapNo]; i++){
                _buttonSet.push(SimpleButton(_root.getChildByName(mapButtonSet[_mapNo][i])));
                _mcSet.push(MovieClip(_root.getChildByName(mapEnableSet[_mapNo][i])));
                if (_regionNo < i)
                {
                    _buttonSet[i].visible = false;
                    _mcSet[i].visible = false;
                }
            }

            if (__questType == Const.QUEST_NORMAL) {
                _nextButton = SimpleButton(_root.getChildByName("btn_next"));
                _backButton = SimpleButton(_root.getChildByName("btn_back"));

                _questFlag > _ctrl.currentMapNo ? _nextButton.addEventListener(MouseEvent.CLICK, nextMapHandler) : _nextButton.visible = false;
                _backButton.addEventListener(MouseEvent.CLICK, backMapHandler);
            }
        }

        public function setFade(b:Boolean):void
        {
            _fade = b;
            waitComplete(setFadeImage);
        }

        private function setFadeImage():void
        {
            if (_fade)
            {
                _root.transform.colorTransform = _ct;
                enabled = false;
                mouseEnabled = false;
                mouseChildren = false;

            }else{
                _root.transform.colorTransform = _ct2;
                enabled = true;
                mouseEnabled = true;
                mouseChildren = true;
            }
        }



        public override function init():void
        {
//             _shadowLandButton.addEventListener(MouseEvent.CLICK, shadowLandClickHandler)
        }

        public  override function final():void
        {
//             _shadowLandButton.removeEventListener(MouseEvent.CLICK, shadowLandClickHandler)
            _buttonSet = null;
            _mcSet = null;

        }


        private function nextMapHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(NEXT));
        }

        private function backMapHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(BACK));
        }


//         private function shadowLandClickHandler(e:MouseEvent):void
//         {
//             _ctrl.requestQuestMapInfo(0);
//         }


        public function getReligion(sb:*):int
        {
            if (_buttonSet.indexOf(sb) !=-1)
            {
                var a:int = 0;
                if(_mapNo != 0)
                {
                    for(var i:int = 0; i < _mapNo; i++)
                    {
                        a += questMapNum[i]
                    }
                }
                return _buttonSet.indexOf(sb)+1+a;
            }
            else
            {
                return -1;
            }
        }

    }

}

