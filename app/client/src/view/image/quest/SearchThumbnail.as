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
     * SearchThumbnail表示クラス
     *
     */


    public class SearchThumbnail extends BaseImage
    {
//         [Embed(source="../../../../data/image/quest/land_sl_plane")]
//             private var _SourceCastle:Class;
        [Embed(source="../../../../data/image/quest/searchthum00.swf")]
            private var _SourceCastle:Class;
        [Embed(source="../../../../data/image/quest/searchthum01.swf")]
            private var _SourceForest:Class;
        [Embed(source="../../../../data/image/quest/searchthum02.swf")]
            private var _SourceRoad:Class;
        [Embed(source="../../../../data/image/quest/searchthum03.swf")]
            private var _SourceLake:Class;
        [Embed(source="../../../../data/image/quest/searchthum04.swf")]
            private var _SourceGrave:Class;
        [Embed(source="../../../../data/image/quest/searchthum05.swf")]
            private var _SourceVillage:Class;
        [Embed(source="../../../../data/image/quest/searchthum06.swf")]
            private var _SourceWild:Class;
        [Embed(source="../../../../data/image/quest/searchthum07.swf")]
            private var _SourceRuin:Class;
        [Embed(source="../../../../data/image/quest/searchthum10.swf")]
            private var _SourceMoon:Class;
        [Embed(source="../../../../data/image/quest/searchthum11.swf")]
            private var _SourceMoor:Class;
        [Embed(source="../../../../data/image/quest/searchthum12.swf")]
            private var _SourceStone:Class;
        [Embed(source="../../../../data/image/quest/searchthum99.swf")]
            private var _SourceThrone:Class;

        // ステージごとのサムネイル
        private var _SourceSet:Object = { 
            0:_SourceWild,       // なし
            1:_SourceWild,       // 魔女の谷
            2:_SourceRoad,       // 隠者の道
            3:_SourceVillage,    // 人狼の住処
            4:_SourceForest,     // 黒の森
            5:_SourceRoad,       // 掃き溜めの街道
            6:_SourceWild,       // 名伏せられし丘
            7:_SourceRuin,       // 修道院廃墟
            8:_SourceLake,       // 物忌みの湖
            9:_SourceVillage,    // 食人鬼の村
            10:_SourceGrave,     // 幽霊騎士の首塚
            11:_SourceForest,    // 風斬り森
            12:_SourceCastle,    // 碧空の尖塔
            13:_SourceWild,      // レン高原
            14:_SourceRoad,      // 世歩く影の道
            15:_SourceCastle,    // ロマール人の砦
            16:_SourceVillage,   // 牧神の絶鋒
            17:_SourceForest,    // 瑪瑙採掘所
            18:_SourceVillage,   // 忘れ去られし島
            19:_SourceCastle,    // 幻影城
            20:_SourceGrave,     // 妖蛆の巣窟
            21:_SourceRuin,      // 死人図書館
            22:_SourceCastle,    // 鉄夢の要塞
            23:_SourceLake,      // ウボスの黒い湖
            24:_SourceForest,    // 植物見張り塔
            25:_SourceStone,     // 白魔の円環列石
            26:_SourceVillage,   // 死都ヘルドン
            27:_SourceWild,      // 翼竜の宝物庫
            28:_SourceGrave,     //  忘却の辺獄
            29:_SourceRuin,      // 魔境の胎臓
            30:_SourceCastle,    // 暗黒塔
            31:_SourceRoad,      // 妖婦の魔道
            32:_SourceVillage,   // 三界の絶頂
            33:_SourceGrave,     // 異端者の墓標
            34:_SourceGrave,     // 幻視された冥府
            35:_SourceCastle,    // 玉座への回廊
            36:_SourceThrone,    // 玉座
            2001:_SourceWild,    // 哀憐の丘
            2002:_SourceForest,  // 揺籃の森
            2003:_SourceLake,    // 甘き湖
            2004:_SourceCastle,  // 怪夢の要塞
            2005:_SourceForest,  // 流竄の森
            2006:_SourceVillage, // 驕る絶峰
            2007:_SourceRuin,    // 思量の淵
            2008:_SourceCastle,   // 軛の城
            2009:_SourceCastle,   // 微笑の平原
            2010:_SourceCastle,   // 屍の森
            2011:_SourceCastle,   // 刻印の峡谷
            2012:_SourceCastle,   // 無窮の荒野
            2013:_SourceCastle,  // 爪牙の城
            3001:_SourceCastle,   // 外壁通り
            3002:_SourceCastle,   // 19番街
            3003:_SourceCastle,   // 67番通り
            3004:_SourceCastle,   // 3番公園
            3005:_SourceCastle,   // 13番広場
            3006:_SourceForest,   // 結界の樹林
            3007:_SourceForest,   // 死霊蠢く林地
            3008:_SourceForest,   // 呪詛の深緑
            3009:_SourceForest,   // 怨嗟の森林
            3010:_SourceCastle,   // 南瓜王の城
            3011:_SourceForest,   // 隠匿の宝物庫
            3012:_SourceCastle,   // 哄笑の平原
            3013:_SourceCastle,   // 不死の森
            3014:_SourceCastle,   // 瑕瑾の峡谷
            3015:_SourceCastle,   // 須臾の荒野
            3016:_SourceCastle,   // 黒衣の城
            3017:_SourceCastle,   // 201607イベント1
            3018:_SourceCastle,   // 201607イベント2
            3019:_SourceCastle,   // 201607イベント3
            3020:_SourceCastle,   // 201607イベント4
            3021:_SourceCastle,   // 201607イベント5
            3022:_SourceCastle,   // 201610イベント1
            3023:_SourceCastle,   // 201610イベント2
            3024:_SourceCastle,   // 201610イベント3
            3025:_SourceCastle,   // 201610イベント4
            3026:_SourceCastle,   // 201610イベント5
            3027:_SourceGrave,   // 哄笑の平原
            3028:_SourceForest,   // 不死の森
            3029:_SourceWild,   // 瑕瑾の峡谷
            3030:_SourceGrave,   // 須臾の荒野
            3031:_SourceCastle,   // 黒衣の城
            5001:_SourceCastle,   // 人気投票2015
            5002:_SourceCastle,   // 人気投票2015
            5003:_SourceCastle,   // 人気投票2015
            5004:_SourceCastle,   // 人気投票2015
            5005:_SourceCastle,   // 人気投票2015
            5006:_SourceCastle,   // 人気投票2015
            5007:_SourceCastle,   // 人気投票2015
            5008:_SourceCastle,   // 人気投票2015
            5009:_SourceCastle,   // 人気投票2015
            5010:_SourceCastle   // 人気投票2015
        };


//        private var _stageMC:MovieClip;
        private var _type:int = 0;


        /**
         * コンストラクタ
         *
         */
        public function SearchThumbnail(type:int)
        {
//            log.writeLog(log.LV_FATAL, this, "type is ", type);
            _type = type;
            super();
        }


        protected override function get Source():Class
        {
            return _SourceSet[_type];
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
        }


    }

}

