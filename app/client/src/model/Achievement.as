 // TODO:コンストラクタでIDだけ渡したい。なぜならロード失敗の時IDがわからないから。

package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * アチーブメントクラス
     * 情報を扱う
     *
     */
    public class Achievement extends BaseModel
    {
        public static const NON_CLEAR_PROGRESS_NO:int = 99999;

        public static const COND_TYPE_LEVEL:int             = 0;
        public static const COND_TYPE_DUEL_WIN:int          = 1;
        public static const COND_TYPE_QUEST_CLEAR:int       = 2;
        public static const COND_TYPE_FRIEND_NUM:int        = 3;
        public static const COND_TYPE_ITEM_NUM:int          = 4;
        public static const COND_TYPE_HALLOWEEN:int         = 5;
        public static const COND_TYPE_CHARA_CARD:int        = 6;
        public static const COND_TYPE_CHARA_CARD_DECK:int   = 7;
        public static const COND_TYPE_QUEST_NO_CLEAR:int    = 8;
        public static const COND_TYPE_GET_RARE_CARD:int     = 9;
        public static const COND_TYPE_DUEL_CLEAR:int        = 10;
        public static const COND_TYPE_QUEST_PRESENT:int     = 11;
        public static const COND_TYPE_RECORD_CLEAR:int      = 12;
        public static const COND_TYPE_ITEM:int              = 13;
        public static const COND_TYPE_ITEM_COMPLETE:int     = 14;
        public static const COND_TYPE_ITEM_CALC:int         = 15;
        public static const COND_TYPE_ITEM_SET_CALC:int     = 16;
        public static const COND_TYPE_QUEST_POINT:int       = 17;
        public static const COND_TYPE_GET_WEAPON:int        = 18;
        public static const COND_TYPE_QUEST_ADVANCE:int     = 19;
        public static const COND_TYPE_FIND_PROFOUND:int     = 20;
        public static const COND_TYPE_RAID_BATTLE_CNT:int   = 21;
        public static const COND_TYPE_MULTI_QUEST_CLEAR:int = 22;
        public static const COND_TYPE_INVITE_COUNT:int      = 23;
        public static const COND_TYPE_RAID_BOSS_DEFEAT:int  = 24;
        public static const COND_TYPE_RAID_ALL_DAMAGE:int   = 25;
        public static const COND_TYPE_CREATED_DAYS:int      = 26;
        public static const COND_TYPE_EVENT_POINT:int       = 27;
        public static const COND_TYPE_EVENT_POINT_CNT:int   = 28;
        public static const COND_TYPE_GET_PART:int          = 29;
        public static const COND_TYPE_DAILY_CLEAR:int       = 30;
        public static const COND_TYPE_OTHER_RAID:int        = 31;
        public static const COND_TYPE_USE_ITEM:int          = 32;
        public static const COND_TYPE_SELF_RAID:int         = 33;
        public static const COND_TYPE_OTHER_DUEL:int        = 34;

        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_LEVEL:String             = "アバターLv";                                     // CondType:0
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DUEL_WIN:String          = "デュエル勝利数";                                 // CondType:1
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_QUEST_CLEAR:String       = "「__NAME__」クリア数";                           // CondType:2
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_FRIEND_NUM:String        = "フレンド数";                                     // CondType:3
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ITEM_NUM:String          = "「__NAME__」所持数";                             // CondType:4
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_HALLOWEEN:String         = "ハロウィーンイベント";                           // CondType:5
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CHARA_CARD:String        = "「__NAME__」所持数";                             // CondType:6
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CHARA_CARD_DECK:String   = "「__NAME__」デッキ配置数";                       // CondType:7
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_QUEST_NO_CLEAR:String    = "クエストクリア数";                           // CondType:8
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_GET_RARE_CARD:String     = "レアカード取得数";                               // CondType:9
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DUEL_CLEAR:String        = "デュエル回数";                                   // CondType:10
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_QUEST_PRESENT:String     = "クエストプレゼント回数";                         // CondType:11
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_RECORD_CLEAR:String      = "レコードクリア数";                               // CondType:12
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ITEM:String              = "アイテム所持数";                                 // CondType:13
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ITEM_COMPLETE:String     = "アイテム所持数";                                 // CondType:14
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ITEM_CALC:String         = "アイテム所持数";                                 // CondType:15
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ITEM_SET_CALC:String     = "「__NAME__」所持数";                             // CondType:16
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_QUEST_POINT:String       = "クエストポイント";                               // CondType:17
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_GET_WEAPON:String        = "取得装備カード";                                 // CondType:18
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_QUEST_ADVANCE:String     = "クエストクリア数";                               // CondType:19
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_FIND_PROFOUND:String     = "渦発見数";                                       // CondType:20
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_RAID_BATTLE_CNT:String   = "レイド参加回数";                                 // CondType:21
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_MULTI_QUEST_CLEAR:String = "クエストクリア数";                               // CondType:22
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_INVITE_COUNT:String      = "招待数";                                         // CondType:23
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_RAID_BOSS_DEFEAT:String  = "討伐数";                                         // CondType:24
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_RAID_ALL_DAMAGE:String   = "レイドボスへのダメージ数";                       // CondType:25
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CREATED_DAYS:String      = "アバター作製からの日数";                         // CondType:26
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_EVENT_POINT:String       = "イベントポイント";                               // CondType:27
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_EVENT_POINT_CNT:String   = "イベントポイント";                               // CondType:28
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_GET_PART:String          = "「__NAME__」取得数";                             // CondType:28
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_OTHER_DUEL:String        = "対戦者数";                                       // CondType:34

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_LEVEL:String             = "Avatar Level";                                   // CondType:0
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DUEL_WIN:String          = "Number of duel victories";                       // CondType:1
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_QUEST_CLEAR:String       = "Number of times [__NAME__] completed";           // CondType:2
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_FRIEND_NUM:String        = "Number of friends";                              // CondType:3
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ITEM_NUM:String          = "Number of [__NAME__] owned";                     // CondType:4
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_HALLOWEEN:String         = "Halloween event";                                // CondType:5
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CHARA_CARD:String        = "Number of [__NAME__] owned";                     // CondType:6
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CHARA_CARD_DECK:String   = "Number of [__NAME__] decks configured";          // CondType:7
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_QUEST_NO_CLEAR:String    = "Number of times [__NAME__] completed";           // CondType:8
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_GET_RARE_CARD:String     = "Number of rare cards acquired";                  // CondType:9
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DUEL_CLEAR:String        = "Number of duels";                                // CondType:10
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_QUEST_PRESENT:String     = "Number of quest gifts";                          // CondType:11
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_RECORD_CLEAR:String      = "Number of achievements recorded";                // CondType:12
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ITEM:String              = "Number of items owned";                          // CondType:13
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ITEM_COMPLETE:String     = "Number of items owned";                          // CondType:14
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ITEM_CALC:String         = "Number of items owned";                          // CondType:15
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ITEM_SET_CALC:String     = "Number of [__NAME__] owned";                     // CondType:16
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_QUEST_POINT:String       = "Quest Points";                                   // CondType:17
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_GET_WEAPON:String        = "Take equipment card";                            // CondType:18
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_QUEST_ADVANCE:String     = "Number of quests completed.";                    // CondType:19
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_FIND_PROFOUND:String     = "Number of vortex discovered";                    // CondType:20
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_RAID_BATTLE_CNT:String   = "Number of raids";                                // CondType:21
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_MULTI_QUEST_CLEAR:String = "Number of quests completed.";                    // CondType:22
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_INVITE_COUNT:String      = "Number of players invited";                      // CondType:23
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_RAID_BOSS_DEFEAT:String  = "Number of defeats";                              // CondType:24
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_RAID_ALL_DAMAGE:String   = "Damages dealt to the RAID-BOSS";                 // CondType:25
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CREATED_DAYS:String      = "The number of days after you created an avatar"; // CondType:26
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_EVENT_POINT:String       = "Event Point";                                    // CondType:27
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_EVENT_POINT_CNT:String   = "Event Point";                                    // CondType:28
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_GET_PART:String          = "Number of [__NAME__] owned";                     // CondType:28
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_OTHER_DUEL:String        = "Opponent number";                                       // CondType:34


        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_LEVEL:String             = "虛擬人物Lv";                                     // CondType:0
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DUEL_WIN:String          = "對戰勝利數";                                     // CondType:1
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_QUEST_CLEAR:String       = "「__NAME__」完成數";                             // CondType:2
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_FRIEND_NUM:String        = "好友人數";                                       // CondType:3
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ITEM_NUM:String          = "「__NAME__」持有數";                             // CondType:4
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_HALLOWEEN:String         = "萬聖節活動";                                     // CondType:5
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CHARA_CARD:String        = "「__NAME__」持有數";                             // CondType:6
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CHARA_CARD_DECK:String   = "「__NAME__」牌組使用數";                         // CondType:7
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_QUEST_NO_CLEAR:String    = "完成的任務數";                             // CondType:8
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_GET_RARE_CARD:String     = "稀有卡片取得次數";                               // CondType:9
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DUEL_CLEAR:String        = "對戰回數";                                       // CondType:10
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_QUEST_PRESENT:String     = "發送任務次數";                                   // CondType:11
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_RECORD_CLEAR:String      = "成就達成次數";                                   // CondType:12
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ITEM:String              = "道具持有數";                                     // CondType:13
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ITEM_COMPLETE:String     = "道具持有數";                                     // CondType:14
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ITEM_CALC:String         = "道具持有數";                                     // CondType:15
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ITEM_SET_CALC:String     = "「__NAME__」持有數";                             // CondType:16
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_QUEST_POINT:String       = "任務點數";                                       // CondType:17
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_GET_WEAPON:String        = "取得裝備卡";                                     // CondType:18
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_QUEST_ADVANCE:String     = "完成的任務數";                                   // CondType:19
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_FIND_PROFOUND:String     = "渦発見数";                                       // CondType:20
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_RAID_BATTLE_CNT:String   = "Raid戰鬥次數";                                   // CondType:21
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_MULTI_QUEST_CLEAR:String = "完成的任務數";                                   // CondType:22
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_INVITE_COUNT:String      = "邀請人數";                                       // CondType:23
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_RAID_BOSS_DEFEAT:String  = "討伐數";                                         // CondType:24
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_RAID_ALL_DAMAGE:String   = "對RAID-BOSS造成的傷害數";                       // CondType:25
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CREATED_DAYS:String      = "自從創造虛擬人物後的天數";                         // CondType:26
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_EVENT_POINT:String       = "活動點數";                               // CondType:27
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_EVENT_POINT_CNT:String   = "活動點數";                               // CondType:28
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_GET_PART:String          = "「__NAME__」取得数";                             // CondType:28
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_OTHER_DUEL:String        = "對戰者人數";                                       // CondType:34


        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_LEVEL:String             = "虚拟人物Lv";                                     // CondType:0
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DUEL_WIN:String          = "决斗胜利次数";                                 // CondType:1
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_QUEST_CLEAR:String       = "「__NAME__」完成数";                           // CondType:2
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_FRIEND_NUM:String        = "好友数";                                     // CondType:3
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ITEM_NUM:String          = "「__NAME__」持有数";                             // CondType:4
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_HALLOWEEN:String         = "万圣节活动";                           // CondType:5
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CHARA_CARD:String        = "「__NAME__」持有数";                             // CondType:6
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CHARA_CARD_DECK:String   = "「__NAME__」卡组使用数";                       // CondType:7
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_QUEST_NO_CLEAR:String    = "完成的任务数";                           // CondType:8
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_GET_RARE_CARD:String     = "稀有卡获得数";                               // CondType:9
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DUEL_CLEAR:String        = "决斗次数";                                   // CondType:10
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_QUEST_PRESENT:String     = "任务赠送次数";                         // CondType:11
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_RECORD_CLEAR:String      = "达成记录次数";                               // CondType:12
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ITEM:String              = "道具持有数";                                 // CondType:13
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ITEM_COMPLETE:String     = "道具持有数";                                 // CondType:14
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ITEM_CALC:String         = "道具持有数";                                 // CondType:15
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ITEM_SET_CALC:String     = "「__NAME__」持有数";                             // CondType:16
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_QUEST_POINT:String       = "任务点数";                               // CondType:17
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_GET_WEAPON:String        = "获得的装备卡";                                 // CondType:18
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_QUEST_ADVANCE:String     = "完成的任务数";                               // CondType:19
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_FIND_PROFOUND:String     = "发现漩涡的次数";                                       // CondType:20
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_RAID_BATTLE_CNT:String   = "Raid战斗次数";                                 // CondType:21
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_MULTI_QUEST_CLEAR:String = "完成的任务数";                               // CondType:22
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_INVITE_COUNT:String      = "邀请人数";                                         // CondType:23
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_RAID_BOSS_DEFEAT:String  = "邀请人数";                                         // CondType:24
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_RAID_ALL_DAMAGE:String   = "对RAID-BOSS造成的伤害数";                       // CondType:25
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CREATED_DAYS:String      = "自从创造虚拟人物后的天数";                         // CondType:26
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_EVENT_POINT:String       = "活动点数";                               // CondType:27
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_EVENT_POINT_CNT:String   = "活动点数";                               // CondType:28
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_GET_PART:String          = "「__NAME__」取得数";                             // CondType:28
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_OTHER_DUEL:String        = "对战者人数";                                       // CondType:34


        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_LEVEL:String             = "アバターLv";                                     // CondType:0
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DUEL_WIN:String          = "デュエル勝利数";                                 // CondType:1
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_QUEST_CLEAR:String       = "「__NAME__」クリア数";                           // CondType:2
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_FRIEND_NUM:String        = "フレンド数";                                     // CondType:3
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ITEM_NUM:String          = "「__NAME__」所持数";                             // CondType:4
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_HALLOWEEN:String         = "ハロウィーンイベント";                           // CondType:5
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CHARA_CARD:String        = "「__NAME__」所持数";                             // CondType:6
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CHARA_CARD_DECK:String   = "「__NAME__」デッキ配置数";                       // CondType:7
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_QUEST_NO_CLEAR:String    = "「__NAME__」クリア数";                           // CondType:8
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_GET_RARE_CARD:String     = "レアカード取得数";                               // CondType:9
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DUEL_CLEAR:String        = "デュエル回数";                                   // CondType:10
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_QUEST_PRESENT:String     = "クエストプレゼント回数";                         // CondType:11
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_RECORD_CLEAR:String      = "レコードクリア数";                               // CondType:12
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ITEM:String              = "アイテム所持数";                                 // CondType:13
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ITEM_COMPLETE:String     = "アイテム所持数";                                 // CondType:14
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ITEM_CALC:String         = "アイテム所持数";                                 // CondType:15
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ITEM_SET_CALC:String     = "「__NAME__」所持数";                             // CondType:16
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_QUEST_POINT:String       = "";                                               // CondType:17
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_GET_WEAPON:String        = "";                                               // CondType:18
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_QUEST_ADVANCE:String     = "クエストクリア数";                               // CondType:19
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_FIND_PROFOUND:String     = "渦発見数";                                       // CondType:20
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_RAID_BATTLE_CNT:String   = "レイド参加回数";                                 // CondType:21
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_MULTI_QUEST_CLEAR:String = "クエストクリア数";                               // CondType:22
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_INVITE_COUNT:String      = "招待数";                                         // CondType:23
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_RAID_BOSS_DEFEAT:String  = "討伐数";                                         // CondType:24
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_RAID_ALL_DAMAGE:String   = "レイドボスへのダメージ数";                       // CondType:25
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CREATED_DAYS:String      = "アバター作製からの日数";                         // CondType:26
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_EVENT_POINT:String       = "イベントポイント";                               // CondType:27
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_EVENT_POINT_CNT:String   = "イベントポイント";                               // CondType:28
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_GET_PART:String          = "「__NAME__」取得数";                             // CondType:28
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_OTHER_DUEL:String        = "対戦者数";                                       // CondType:34


        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_LEVEL:String             = "Avatar Niveau";                                  // CondType:0
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DUEL_WIN:String          = "Nombre de victoire Duel";                        // CondType:1
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_QUEST_CLEAR:String       = "Nombre de Accomplissement «__NAME__»";           // CondType:2
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_FRIEND_NUM:String        = "Nombre Fiend";                                   // CondType:3
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ITEM_NUM:String          = "Nombre de possession «__NAME__»";                // CondType:4
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_HALLOWEEN:String         = "événement d'Halloween";                          // CondType:5
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CHARA_CARD:String        = "Vous possédez «__NAME__»";                       // CondType:6
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CHARA_CARD_DECK:String   = "Nombre de dispositipn de pioche «__NAME__»";     // CondType:7
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_QUEST_NO_CLEAR:String    = "Nombre de Accomplissement «(__NAME__)»";         // CondType:8
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_GET_RARE_CARD:String     = "Nombre d'obtenir des Carte Rare";                // CondType:9
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DUEL_CLEAR:String        = "Nombre des Duel";                                // CondType:10
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_QUEST_PRESENT:String     = "Nombre de fois de Cadeau(x) de Quête(s)";        // CondType:11
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_RECORD_CLEAR:String      = "Nombre de Accomplissement du Record";            // CondType:12
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ITEM:String              = "Vous possédez des Articles ";                    // CondType:13
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ITEM_COMPLETE:String     = "Vous possédez des Articles ";                    // CondType:14
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ITEM_CALC:String         = "Vous possédez des Articles ";                    // CondType:15
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ITEM_SET_CALC:String     = "Nombre de possession «__NAME__»";                // CondType:16
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_QUEST_POINT:String       = "Quêtes Points";                                  // CondType:17
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_GET_WEAPON:String        = "Équipement carte d'acquisition";                 // CondType:18
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_QUEST_ADVANCE:String     = "Nombre de Quêtes réussies";                      // CondType:19
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_FIND_PROFOUND:String     = "Nombre de Vortex découverts";                    // CondType:20
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_RAID_BATTLE_CNT:String   = "Nombre de batailles Raid";                       // CondType:21
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_MULTI_QUEST_CLEAR:String = "Nombre de Réussit de Quête.";                    // CondType:22
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_INVITE_COUNT:String      = "Nombre d'invitation";                            // CondType:23
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_RAID_BOSS_DEFEAT:String  = "Nombre d'assujettissement(s)";                   // CondType:24
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_RAID_ALL_DAMAGE:String   = "Nombre de dommage(s) infligé(s) au RaidBoss.";   // CondType:25
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CREATED_DAYS:String      = "Nombre de jours depuis la création de l'Avatar"; // CondType:26
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_EVENT_POINT:String       = "Points événement";                               // CondType:27
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_EVENT_POINT_CNT:String   = "Points événement";                               // CondType:28
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_GET_PART:String          = "Vous obtenez un total de [__NAME__]";            // CondType:28
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_OTHER_DUEL:String        = "Nombre d'adversaires";                           // CondType:34


        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_LEVEL:String             = "アバターLv";                                     // CondType:0
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DUEL_WIN:String          = "デュエル勝利数";                                 // CondType:1
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_QUEST_CLEAR:String       = "「__NAME__」クリア数";                           // CondType:2
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_FRIEND_NUM:String        = "フレンド数";                                     // CondType:3
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ITEM_NUM:String          = "「__NAME__」所持数";                             // CondType:4
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_HALLOWEEN:String         = "ハロウィーンイベント";                           // CondType:5
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CHARA_CARD:String        = "「__NAME__」所持数";                             // CondType:6
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CHARA_CARD_DECK:String   = "「__NAME__」デッキ配置数";                       // CondType:7
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_QUEST_NO_CLEAR:String    = "「__NAME__」クリア数";                           // CondType:8
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_GET_RARE_CARD:String     = "レアカード取得数";                               // CondType:9
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DUEL_CLEAR:String        = "デュエル回数";                                   // CondType:10
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_QUEST_PRESENT:String     = "クエストプレゼント回数";                         // CondType:11
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_RECORD_CLEAR:String      = "レコードクリア数";                               // CondType:12
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ITEM:String              = "アイテム所持数";                                 // CondType:13
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ITEM_COMPLETE:String     = "アイテム所持数";                                 // CondType:14
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ITEM_CALC:String         = "アイテム所持数";                                 // CondType:15
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ITEM_SET_CALC:String     = "「__NAME__」所持数";                             // CondType:16
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_QUEST_POINT:String       = "";                                               // CondType:17
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_GET_WEAPON:String        = "";                                               // CondType:18
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_QUEST_ADVANCE:String     = "クエストクリア数";                               // CondType:19
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_FIND_PROFOUND:String     = "渦発見数";                                       // CondType:20
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_RAID_BATTLE_CNT:String   = "レイド参加回数";                                 // CondType:21
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_MULTI_QUEST_CLEAR:String = "クエストクリア数";                               // CondType:22
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_INVITE_COUNT:String      = "招待数";                                         // CondType:23
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_RAID_BOSS_DEFEAT:String  = "討伐数";                                         // CondType:24
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_RAID_ALL_DAMAGE:String   = "レイドボスへのダメージ数";                       // CondType:25
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CREATED_DAYS:String      = "アバター作製からの日数";                         // CondType:26
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_EVENT_POINT:String       = "イベントポイント";                               // CondType:27
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_EVENT_POINT_CNT:String   = "イベントポイント";                               // CondType:28
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_GET_PART:String          = "「__NAME__」取得数";                             // CondType:28
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_OTHER_DUEL:String        = "対戦者数";                                       // CondType:34


        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_LEVEL:String            = "เลวเลของอวาตาร์";//"アバターLv";                    // CondType:0
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DUEL_WIN:String         = "จำนวนครั้งที่ชนะการดูเอล";//"デュエル勝利数";                // CondType:1
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_QUEST_CLEAR:String      = "จำนวนครั้งที่เคลียร์　[__NAME__]";//"「__NAME__」クリア数";          // CondType:2
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_FRIEND_NUM:String       = "จำนวนเพื่อน";//"フレンド数";                    // CondType:3
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ITEM_NUM:String         = "จำนวน [__NAME__] ที่ครอบครองอยู่";//"「__NAME__」所持数";            // CondType:4
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_HALLOWEEN:String        = "อีเวนท์ ฮาโลวีน";//"ハロウィーンイベント";          // CondType:5
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CHARA_CARD:String       = "จำนวน [__NAME__] ที่ครอบครองอยู่";//"「__NAME__」所持数";            // CondType:6
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CHARA_CARD_DECK:String  = "จำนวนสำรับ [__NAME__] ที่เตรียมไว้";//"「__NAME__」デッキ配置数";      // CondType:7
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_QUEST_NO_CLEAR:String   = "จำนวนครั้งที่เคลียร์　[__NAME__]";//"「__NAME__」クリア数";          // CondType:8
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_GET_RARE_CARD:String    = "จำนวนแรร์การ์ดที่ได้รับ";//"レアカード取得数";              // CondType:9
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DUEL_CLEAR:String       = "จำนวนครั้งที่ทำการดูเอล";//"デュエル回数";                  // CondType:10
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_QUEST_PRESENT:String    = "จำนวนครั้งที่ทำเควสของขวัญ";//"クエストプレゼント回数";        // CondType:11
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_RECORD_CLEAR:String     = "จำนวนครั้งที่เคลียร์ record";//"レコードクリア数";              // CondType:12
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ITEM:String             = "จำนวนไอเท็มที่ครอบครอง";//"アイテム所持数";                // CondType:13
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ITEM_COMPLETE:String    = "จำนวนไอเท็มที่ครอบครอง";//"アイテム所持数";                // CondType:14
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ITEM_CALC:String        = "จำนวนไอเท็มที่ครอบครอง";//"アイテム所持数";                // CondType:15
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ITEM_SET_CALC:String    = "จำนวน [__NAME__] ที่ครอบครองอยู่";//"「__NAME__」所持数";            // CondType:16
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_QUEST_POINT:String      = "แต้มเควส";//"クエストポイント";              // CondType:17
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_GET_WEAPON:String       = "ได้รับการ์ดอุปกรณ์";//"取得装備カード";  // CondType:18
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_QUEST_ADVANCE:String    = "จำนวนภาระกิจที่ผ่าน";    // CondType:19 // クエストクリア数
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_FIND_PROFOUND:String     = ""; // CondType:20 // 渦発見数
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_RAID_BATTLE_CNT:String   = ""; // CondType:21 // レイド参加回数
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_MULTI_QUEST_CLEAR:String = ""; // CondType:22 // クエストクリア数
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_INVITE_COUNT:String      = ""; // CondType:23 //招待数
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_RAID_BOSS_DEFEAT:String  = ""; // CondType:24 //討伐数
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_RAID_ALL_DAMAGE:String   = ""; // CondType:25 // レイドボスへのダメージ数
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CREATED_DAYS:String      = ""; // CondType:26 // アバター作製からの日数
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_EVENT_POINT:String       = ""; // CondType:27 // イベントポイント
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_EVENT_POINT_CNT:String   = ""; // CondType:28 // イベントポイント
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_GET_PART:String          = "「__NAME__」取得数";                             // CondType:28
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_OTHER_DUEL:String        = "対戦者数";                                       // CondType:34



        public static const COND_MSG_SET:Array = [
            _TRANS_MSG_LEVEL,             // CondType:0
            _TRANS_MSG_DUEL_WIN,          // CondType:1
            _TRANS_MSG_QUEST_CLEAR,       // CondType:2
            _TRANS_MSG_FRIEND_NUM,        // CondType:3
            _TRANS_MSG_ITEM_NUM,          // CondType:4
            _TRANS_MSG_HALLOWEEN,         // CondType:5
            _TRANS_MSG_CHARA_CARD,        // CondType:6
            _TRANS_MSG_CHARA_CARD_DECK,   // CondType:7
            _TRANS_MSG_QUEST_NO_CLEAR,    // CondType:8
            _TRANS_MSG_GET_RARE_CARD,     // CondType:9
            _TRANS_MSG_DUEL_CLEAR,        // CondType:10
            _TRANS_MSG_QUEST_PRESENT,     // CondType:11
            _TRANS_MSG_RECORD_CLEAR,      // CondType:12
            _TRANS_MSG_ITEM,              // CondType:13
            _TRANS_MSG_ITEM_COMPLETE,     // CondType:14
            _TRANS_MSG_ITEM_CALC,         // CondType:15
            _TRANS_MSG_ITEM_SET_CALC,     // CondType:16
            _TRANS_MSG_QUEST_POINT,       // CondType:17
            _TRANS_MSG_GET_WEAPON,        // CondType:18
            _TRANS_MSG_QUEST_ADVANCE,     // CondType:19
            _TRANS_MSG_FIND_PROFOUND,     // CondType:20
            _TRANS_MSG_RAID_BATTLE_CNT,   // CondType:21
            _TRANS_MSG_MULTI_QUEST_CLEAR, // CondType:22
            _TRANS_MSG_INVITE_COUNT,      // CondType:23
            _TRANS_MSG_RAID_BOSS_DEFEAT,  // CondType:24
            _TRANS_MSG_RAID_ALL_DAMAGE,   // CondType:25
            _TRANS_MSG_CREATED_DAYS,      // CondType:26
            _TRANS_MSG_EVENT_POINT,       // CondType:27
            _TRANS_MSG_EVENT_POINT_CNT,   // CondType:28
            _TRANS_MSG_GET_PART,          // CondType:29
            "",          // CondType:30
            "",          // CondType:31
            "",          // CondType:32
            "",          // CondType:33
            _TRANS_MSG_OTHER_DUEL,        // CondType:34
            ];

        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        private static var __achievements:Object =[];        // ロード済みのクエスト
        private static var __loadings:Object ={};     // ロード中のクエスト
        private var _kind           :int;             // 種類
        private var _caption        :String = "";          //キャプション
        private var _successCond    :int;             // 達成条件
        private var _explanation    :String = "";     // 説明
        private var _version        :int;
        private var _endAtTime:Date;
        private var _endAtTimeStr:String = "";
        private var _treasures:Array = [];
        private var _condType:int = 0; // 達成条件タイプ
        private var _condInfo:String = ""; // 達成条件内容

        private static function getData(id:int):void
        {
            var a:Array; /* of ElementType */
            if (ConstData.getData(ConstData.ACHIEVEMENT, id) != null)
            {
                a = ConstData.getData(ConstData.ACHIEVEMENT, id);
                updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], a[7], 0, true);
            }
        }

        public static function clearData():void
        {
            __achievements.forEach(function(item:Achievement, index:int, array:Array):void{if (item != null){item._loaded = false}});
        }

        // IDのAchievementインスタンスを返す
        public static function ID(id:int):Achievement
        {
//            log.writeLog(log.LV_FATAL, "get feat id",id);
            if (__achievements[id] == null)
            {
                __achievements[id] = new Achievement(id);
                getData(id);
            }else{
                if (!(__achievements[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
            }
            return __achievements[id];
        }

        // ローダがAchievementのパラメータを更新する
        public static function updateParam(id:int, kind:int,  caption:String, endAt:String, successCond:int, condInfo:String, explanation:String, treasures:Array, version:int, cache:Boolean=false):void
        {

            //log.writeLog(log.LV_INFO, "static Achievement" ,"update id",id, kind, caption,successCond,condInfo);

            if (__achievements[id] == null)
            {
                __achievements[id] = new Achievement(id);
            }
            __achievements[id]._id        = id;
            __achievements[id]._caption   = caption;
            __achievements[id]._kind      = kind;
            __achievements[id]._successCond = successCond;
            __achievements[id]._explanation = explanation;
            __achievements[id]._treasures  = treasures;
            if (condInfo) {
                var condInfoArr:Array = condInfo.split(":");
                __achievements[id]._condType = int(condInfoArr[0]);
                __achievements[id]._condInfo = condInfoArr[1];
            }
            if (endAt != "")
            {
                __achievements[id]._endAtTime = new Date(endAt);
//                 log.writeLog(log.LV_FATAL, "ACHIEVEMENT DATE GET ",__achievements[id]._endAtTime.toString());
//                 log.writeLog(log.LV_FATAL, "ACHIEVEMENT DATE GET ",TimeFormat.transDateStr(__achievements[id]._endAtTime));
                __achievements[id]._endAtTimeStr = TimeFormat.transDateStr(__achievements[id]._endAtTime)
            }


//             if (!cache)
//             {
//                 Cache.setCache(Cache.ACHIEVEMENT, id, kind, caption);
//             }

            if (__achievements[id]._loaded)
            {
                __achievements[id].dispatchEvent(new Event(UPDATE));
            }
            else
            {
                __achievements[id]._loaded  = true;
                __achievements[id].notifyAll();
                __achievements[id].dispatchEvent(new Event(INIT));
            }
            __loadings[id] = false;

        }


        // コンストラクタ
        public function Achievement(id:int)
        {
            _id = id;
        }

        // 達成条件が複数のものか判定
        public function isMultiCond():Boolean
        {
            if ( _condType == COND_TYPE_HALLOWEEN ||
                 _condType == COND_TYPE_CHARA_CARD ||
                 _condType == COND_TYPE_CHARA_CARD_DECK ||
                 _condType == COND_TYPE_ITEM_SET_CALC
                )
            {
                return true;
            }
            return false;
        }

        // 変換が必要な文章が判定
        public function isRegCond():Boolean
        {
            if ( _condType == COND_TYPE_QUEST_CLEAR ||
                 _condType == COND_TYPE_ITEM_NUM ||
                 _condType == COND_TYPE_CHARA_CARD ||
                 _condType == COND_TYPE_CHARA_CARD_DECK ||
                 _condType == COND_TYPE_QUEST_NO_CLEAR ||
                 _condType == COND_TYPE_ITEM_SET_CALC ||
                 _condType == COND_TYPE_GET_PART
                )
            {
                return true;
            }
            return false;
        }


        public function get selectableTreasureSet():Array
        {
            log.writeLog(log.LV_FATAL, "selectableTreasureSet",_treasures);
            return _treasures;
        }

        public function get isViewCond():Boolean
        {
            return (_condInfo != "")
        }

        public function getCondTypeMsg(name:String=""):String
        {
            var ret:String = "";
            if ( name != "" ) {
                ret = COND_MSG_SET[_condType].replace("__NAME__",name);
            } else {
                ret = COND_MSG_SET[_condType];
            }
            return ret;
        }

        public function get caption():String
        {
            return _caption;
        }

        public function get kind():int
        {
            return _kind;
        }

        public function get successCond():int
        {
            return _successCond;
        }

        public function get explanation():String
        {
            return _explanation;
        }

        public function get condType():int
        {
            return _condType;
        }

        public function get condInfo():String
        {
            return _condInfo;
        }

        public function get endAtTimeStr():String
        {
            return _endAtTimeStr;
        }
        public function checkTimeOver():Boolean
        {
            if (_endAtTime !=null)
            {
                return _endAtTime > new Date();
            }else{
                return true;
            }
        }



    }
}
