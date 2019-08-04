package view.scene.game
{

    import flash.events.*;

    import model.MessageLog;
    import model.ProfoundLogs;
    import model.events.ConstraintEvent;

    /**
     * ゲーム中のダイアログ
     *
     */

    public class DuelMessage
    {
        // MsgDlgId
        public static const DUEL_MSGDLG_START            :int = 0;   // XXXさんとの対戦を開始します
        public static const DUEL_MSGDLG_WATCH_START      :int = 1;   // XXXさん対ZZZさんのバトル観戦をします
        public static const DUEL_MSGDLG_DUEL_START       :int = 2;   // Duel スタート
        public static const DUEL_MSGDLG_M_DUEL_START     :int = 3;   // Multi Duel スタート
        public static const DUEL_MSGDLG_INITIATIVE       :int = 4;   // XXXがイニシアチブをとりました
        public static const DUEL_MSGDLG_DISTANCE         :int = 5;   // 距離がXになりました
        public static const DUEL_MSGDLG_CHANGE_CHARA     :int = 6;   // 戦闘キャラを変更しました
        public static const DUEL_MSGDLG_BTL_POINT        :int = 7;   // 攻撃はなし or 攻撃力決定 X
        public static const DUEL_MSGDLG_BTL_RESULT       :int = 8;   // XXXの攻撃はキャンセル
        public static const DUEL_MSGDLG_TURN_END         :int = 9;   // ターン X の終了
        public static const DUEL_MSGDLG_SPECIAL          :int = 10;  // (赤い柘榴の発動内容)
        public static const DUEL_MSGDLG_STATE            :int = 11;  // (付加される状態内容)
        public static const DUEL_MSGDLG_DMG_FOR_BOSS     :int = 12;  // XXXさんがZZZにxダメージ
        public static const DUEL_MSGDLG_HEAL_BOSS        :int = 13;  // ZZZがx回復
        public static const DUEL_MSGDLG_SUM_DMG_FOR_BOSS :int = 14;  // 皆さんの攻撃でZZZに合計xダメージを与えました
        public static const DUEL_MSGDLG_RAID_SCORE       :int = 15;  // Score:x
        public static const DUEL_MSGDLG_TRAP             :int = 16;  // XXXにトラップ効果発動
        public static const DUEL_MSGDLG_TRAP_ARLE        :int = 17;  // XXXにトラップ効果発動, 手札を破棄
        public static const DUEL_MSGDLG_TRAP_INSC        :int = 18;  // 結界の効果により、XXXはダメージ無効化状態になりました
        public static const DUEL_MSGDLG_LITTLE_PRINCESS  :int = 19;  // リトルプリンセスの効果により、ダメージが無効化された
        public static const DUEL_MSGDLG_CRIMSON_WITCH    :int = 20;  // 深紅の魔女の効果により、ダメージが2倍になった
        public static const DUEL_MSGDLG_AVOID_DAMAGE     :int = 21;  // XXXはYのダメージを回避しました
        public static const DUEL_MSGDLG_CONSTRAINT       :int = 22;  // XXXは A,B,C禁止状態になりました
        public static const DUEL_MSGDLG_WEAPON_STATUS_UP :int = 23;  // XXXの武器ステータスが向上しました
        public static const DUEL_MSGDLG_SWORD_DEF_UP     :int = 24;  // XXX の近距離における防御性能が向上しました
        public static const DUEL_MSGDLG_ARROW_DEF_UP     :int = 25;  // XXX の遠距離における防御性能が向上しました
        public static const DUEL_MSGDLG_DOLL_ATK         :int = 26;  // ヌイグルミによる追加攻撃
        public static const DUEL_MSGDLG_DOLL_CRASH       :int = 27;  // ヌイグルミ破壊
        public static const DUEL_MSGDLG_MAX              :int = 28;  //

        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_START            :String = "__NAME__さんとの対戦を開始します";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_WATCH_START      :String = "__PL_NAME__さん対__FOE_NAME__さんのバトル観戦をします";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DUEL_START       :String = "Duel スタート";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_M_DUEL_START     :String = "Multi Duel スタート";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_INITIATIVE       :String = "__NAME__がイニシアチブをとりました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DISTANCE         :String = "距離が __POINT__ になりました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DISTANCE_MISSING :String = "距離が 不明 になりました\n実際の距離とマッチングしない行動は無効化されます\nこの状態は、一方が相手にダメージを与えることで解除されます";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CHANGE_CHARA     :String = "戦闘キャラを変更しました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_BTL_POINT_1      :String = "攻撃はなし";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_BTL_POINT_2      :String = "攻撃力決定 __POINT__";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_BTL_RESULT       :String = "__NAME__の攻撃はキャンセル";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_TURN_END         :String = "ターン __POINT__ の終了";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DMG_FOR_BOSS     :String = "__PL_NAME__さんが__BOSS_NAME__に__POINT__ダメージ";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_HEAL_BOSS        :String = "__BOSS_NAME__が__POINT__回復";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_SUM_DMG_FOR_BOSS :String = "他の参加者によって__BOSS_NAME__は合計__POINT__のダメージを受けました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_RAID_SCORE       :String = "SCORE:__POINT__";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_TRAP             :String = "__NAME__にトラップ効果発動";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_TRAP_ARLE        :String = "__NAME__にトラップ効果発動, 手札を破棄";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_TRAP_INSC        :String = "結界の効果により，__NAME__はダメージ無効化状態になりました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_LITTLE_PRINCESS  :String = "リトルプリンセスの効果により、ダメージが無効化されました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CRIMSON_WITCH    :String = "深紅の魔女の効果により、ダメージが2倍になりました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_AVOID_DAMAGE     :String = "__NAME__は__POINT__のダメージを回避しました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CONSTRAINT       :String = "__NAME__は、__ACTIONS__禁止状態になりました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_WEAPON_STATUS_UP :String = "__NAME__の武器ステータスが向上しました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_SWORD_DEF_UP     :String = "__NAME__の近距離における防御性能が向上しました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ARROW_DEF_UP     :String = "__NAME__の遠距離における防御性能が向上しました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DOLL_ATK         :String = "ヌイグルミによる追加攻撃";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DOLL_CRASH       :String = "ヌイグルミ破壊";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_FORWARD          :String = "前進";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_BACKWARD         :String = "後退";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_STAY             :String = "待機";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CHANGE           :String = "交代";

        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_STATE_SET:Array = [
            "",                                        // 0
            "__NAME__は「毒」になった",                // 1
            "__NAME__は「麻痺」になった",              // 2
            "__NAME__は「ATK増加」になった",           // 3
            "__NAME__は「ATK低下」になった",           // 4
            "__NAME__は「DEF増加」になった",           // 5
            "__NAME__は「DEF低下」になった",           // 6
            "__NAME__は「バーサーク」になった",        // 7
            "__NAME__は「スタン」になった",            // 8
            "__NAME__は「封印」になった",              // 9
            "__NAME__は「自壊」になった",              // 10
            "__NAME__は「不死」になった",              // 11
            "__NAME__は「恐怖」になった",              // 12
            "__NAME__は「MOV増加」になった",           // 13
            "__NAME__は「MOV低下」になった",           // 14
            "__NAME__は「リジェネレート」になった",    // 15
            "__NAME__は「呪縛」になった",              // 16
            "__NAME__は「混沌」になった",              // 17
            "__NAME__は「聖痕」になった",              // 18
            "__NAME__は「能力低下」になった",          // 19
            "__NAME__は「棍術」になった",              // 20
            "__NAME__は「詛呪」になった",              // 21
            "__NAME__は「臨界」になった",              // 22
            "__NAME__は「不死Ⅱ」になった",             // 23
            "__NAME__は「猛毒」になった",              // 24
            "__NAME__は「操想」になった",              // 25
            "__NAME__は「正鵠」になった",              // 26
            "__NAME__は「断絶」になった",              // 27
            "__NAME__は「人形」になった",              // 28
            ];

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_START            :String = "Start battle with __NAME__.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_WATCH_START      :String = "Watch __PL_NAME__ battle against __FOE_NAME__.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DUEL_START       :String = "Start Duel";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_M_DUEL_START     :String = "Start Multi Duel";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_INITIATIVE       :String = "__NAME__ took the initiative.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DISTANCE         :String = "The distance is __POINT__.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DISTANCE_MISSING :String = "The distance from your opponent can not be calculated.\nActions that do not match your distance will not be taken into account.\nThis disappears as soon as you deal damage to your opponent.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CHANGE_CHARA     :String = "Battle character changed.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_BTL_POINT_1      :String = "No attack";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_BTL_POINT_2      :String = "Total attack __POINT__";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_BTL_RESULT       :String = "__NAME__ canceled their attack.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_TURN_END         :String = "End of turn __POINT__.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DMG_FOR_BOSS     :String = "__PL_NAME__ dealt __POINT__ damage to __BOSS_NAME__.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_HEAL_BOSS        :String = "__BOSS_NAME__ recovered __POINT__ HP.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_SUM_DMG_FOR_BOSS :String = "__BOSS_NAME__ took a total of __POINT__ damage from everyone's attacks.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_RAID_SCORE       :String = "SCORE:__POINT__";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_TRAP             :String = "__NAME__ is caught in a trap.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_TRAP_ARLE        :String = "__NAME__ is caught in a trap and his cards are destroyed.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_TRAP_INSC        :String = "A ward takes effect and __NAME__ becomes invincible.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_LITTLE_PRINCESS  :String = "Due to Little Princess's effect, the damages are nullified.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CRIMSON_WITCH    :String = "Due to Scarlet Sorceress's effect, the damages are doubled.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_AVOID_DAMAGE     :String = "__NAME__ was to avoid __POINT__ damages.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CONSTRAINT       :String = "__NAME__ is now under the status of not being able to __ACTIONS__.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_WEAPON_STATUS_UP :String = "The weapon ability of __NAME__ has been increased.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_SWORD_DEF_UP     :String = "__NAME__'s short range defense has been increased";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ARROW_DEF_UP     :String = "__NAME__'s long range defense has been increased";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DOLL_ATK         :String = "Puppet follow-up attack";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DOLL_CRASH       :String = "Puppet damage";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_FORWARD          :String = "Go forward";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_BACKWARD         :String = "Go backward";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_STAY             :String = "Not moving, revive";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CHANGE           :String = "Character replacement";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_STATE_SET:Array = [
            "",                                        // 0
            "__NAME__ have gained [POISONED]",                    // 1
            "__NAME__ have gained [PARALYZED]",                   // 2
            "__NAME__ have gained [Increased ATK]",              // 3
            "__NAME__ have gained [Reduced ATK]",                // 4
            "__NAME__ have gained [Increased DEF]",              // 5
            "__NAME__ have gained [Reduced DEF]",                // 6
            "__NAME__ have gained [BERSERK]",                  // 7
            "__NAME__ have gained [STUN]",                     // 8
            "__NAME__ have gained [SEAL]",                      // 9
            "__NAME__ have gained [DISINTEGRATE]",              // 10
            "__NAME__ have gained [IMMORTAL]",                // 11
            "__NAME__ have gained [AFRAID]",                      // 12
            "__NAME__ have gained [Increased MOV]",              // 13
            "__NAME__ have gained [Reduced MOV]",                // 14
            "__NAME__ have gained [REGENERATING]",                // 15
            "__NAME__ have gained [CURSED]",                      // 16
            "__NAME__ have gained [EMPOWERED BY CHAOS]",          // 17
            "__NAME__ have gained [STIGMATA]",                   // 18
            "__NAME__ have gained [Reduced ABILITIES]",          // 19
            "__NAME__ have gained [BO STAFF SKILLS]",            // 20
            "__NAME__ have gained [CURSED]",                      // 21
            "__NAME__ have gained [LIMIT BREAK]",              // 22
            "__NAME__ have gained [IMMORTAL 2]",            // 23
            "__NAME__ have gained [POISONED]",              // 24
            "__NAME__ have gained [CURSE OF DEATH]",              // 25
            "__NAME__ have gained [BULLSEYE]",              // 26
            "__NAME__ have gained [SEVER]",              // 27
            "__NAME__ have gained [DOLL]",              // 28
            ];

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_START	:String = "開始遊戲與 __NAME__";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_WATCH_START	:String = "觀看 __PL_NAME__ 對 __FOE_NAME__ 的對戰";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DUEL_START	:String = "開始Duel";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_M_DUEL_START:String = "開始Multi Duel";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_INITIATIVE	:String = "__NAME__ 取得主動權";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DISTANCE	:String = "現在的距離 __POINT__";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DISTANCE_MISSING :String = "距離變成不明了。\n與實際距離不符的行動將被無效化。\n這個狀態，將在其中一方對對手造成傷害後解除。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CHANGE_CHARA:String = "變換戰鬥角色";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_BTL_POINT_1	:String = "沒有攻擊";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_BTL_POINT_2	:String = " 決定攻擊力 __POINT__ 點";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_BTL_RESULT	:String = "__NAME__ 放棄攻擊";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_TURN_END	:String = "__POINT__回合結束";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DMG_FOR_BOSS:String = "__PL_NAME__對__BOSS_NAME__造成__POINT__傷害";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_HEAL_BOSS   :String = "__BOSS_NAME__回復__POINT__";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_SUM_DMG_FOR_BOSS :String = "所有玩家的攻擊給予__BOSS_NAME__合計__POINT__傷害";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_RAID_SCORE    :String = "SCORE:__POINT__";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_TRAP             :String = "__NAME__中陷阱";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_TRAP_ARLE        :String = "__NAME__中陷阱，銷毀手牌";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_TRAP_INSC        :String = "結界發揮效果，__NAME__成為無敵狀態";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_LITTLE_PRINCESS   :String = "因為小公主的效果，傷害被無效了。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CRIMSON_WITCH    :String = "因為深紅的魔女的效果，傷害變成2倍了。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_AVOID_DAMAGE     :String = "__NAME__迴避了__POINT__點的傷害。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CONSTRAINT       :String = "__NAME__目前為禁止 __ACTIONS__状態";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_WEAPON_STATUS_UP :String = "__NAME__的武器能力已提昇";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_SWORD_DEF_UP     :String = "__NAME__在近距離時的防禦性能提升了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ARROW_DEF_UP     :String = "__NAME__在遠距離時的防禦性能提升了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DOLL_ATK         :String = "布偶追加攻擊";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DOLL_CRASH       :String = "布偶破壞";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_FORWARD          :String = "前進";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_BACKWARD         :String = "後退";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_STAY             :String = "不移動、回復";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CHANGE           :String = "換角";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_STATE_SET:Array = [
            "",					 // 0
            "__NAME__ 得到「毒」狀態",		 // 1
            "__NAME__ 得到「麻痺」狀態",		 // 2
            "__NAME__ 得到「攻擊力增加」狀態",	 // 3
            "__NAME__ 得到「攻擊力減少」狀態",	 // 4
            "__NAME__ 得到「防禦力增加」狀態",	 // 5
            "__NAME__ 得到「防禦力減少」狀態",	 // 6
            "__NAME__ 得到「狂戰士」狀態",		 // 7
            "__NAME__ 得到「暈眩」狀態",		 // 8
            "__NAME__ 得到「封印」狀態",		 // 9
            "__NAME__ 得到「自壞」狀態",		 // 10
            "__NAME__ 得到「不死」狀態",		 // 11
            "__NAME__ 得到「恐怖」狀態",		 // 12
            "__NAME__ 得到「增加移動力」狀態",	 // 13
            "__NAME__ 得到「減少移動力」狀態",	 // 14
            "__NAME__ 得到「再生」狀態",		 // 15
            "__NAME__ 得到「咒縛」狀態",		 // 16
            "__NAME__ 得到「混沌」狀態",		 // 17
            "__NAME__ 得到「聖痕」狀態",		 // 18
            "__NAME__ 得到「能力降低」狀態",	 // 19
            "__NAME__ 得到「棍術」狀態",		 // 20
            "__NAME__ 得到「詛咒」狀態",		 // 21
            "__NAME__ 得到「臨界」狀態",              // 22
            "__NAME__ 得到「不死II」狀態",             // 23
            "__NAME__ 得到「猛毒」狀態",              // 24
            "__NAME__ 得到「操想」狀態。",              // 25
            "__NAME__ 得到「標靶」狀態。",              // 26
            "__NAME__ 得到「斷絕」狀態。",              // 27
            "__NAME__ 得到「傀儡」狀態",              // 28
            ];

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_START            :String = "开始与__NAME__对战。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_WATCH_START      :String = "观看__PL_NAME__与__FOE_NAME__的战斗。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DUEL_START       :String = "决斗开始";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_M_DUEL_START     :String = "多人决斗开始";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_INITIATIVE       :String = "__NAME__取得先攻权";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DISTANCE         :String = "现在的距离为 [__POINT__]";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DISTANCE_MISSING :String = "距离变成不明了。\n与实际距离不符的行动将被无效化。\n这个状态将在其中一方对对手造成伤害后解除。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CHANGE_CHARA     :String = "变更战斗角色";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_BTL_POINT_1      :String = "没有攻击";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_BTL_POINT_2      :String = "攻击力决定 __POINT__点数";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_BTL_RESULT       :String = "取消__NAME__的攻击";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_TURN_END         :String = "第__POINT__回合结束";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DMG_FOR_BOSS     :String = "__PL_NAME__对__BOSS_NAME__造成__POINT__伤害";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_HEAL_BOSS        :String = "__BOSS_NAME__恢复__POINT__";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_SUM_DMG_FOR_BOSS :String = "所有玩家的攻击对__BOSS_NAME__造成合计__POINT__的伤害";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_RAID_SCORE       :String = "SCORE:__POINT__";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_TRAP             :String = "__NAME__中了陷阱攻击";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_TRAP_ARLE        :String = "__NAME__中了陷阱攻击，放弃手中的卡片";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_TRAP_INSC        :String = "结界效果的发挥，让__NAME__进入无敌状态";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_LITTLE_PRINCESS   :String = "因为小公主的效果，伤害被无效化了。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CRIMSON_WITCH    :String = "因为深红的魔女的效果，伤害变成2倍了。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_AVOID_DAMAGE     :String = "__NAME__回避了__POINT__点的伤害。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CONSTRAINT       :String = "__NAME__目前为禁止__ACTIONS__状态。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_WEAPON_STATUS_UP :String = "__NAME__的武器能力已提升";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_SWORD_DEF_UP     :String = "__NAME__在近距离时的防禦性能提升了";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ARROW_DEF_UP     :String = "__NAME__の在远距离时的防禦性能提升了";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DOLL_ATK         :String = "布偶追加攻击";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DOLL_CRASH       :String = "布偶破坏";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_FORWARD          :String = "前进";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_BACKWARD         :String = "后退";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_STAY             :String = "待机";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CHANGE           :String = "更换";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_STATE_SET:Array = [
            "",                                    // 0
            "__NAME__进入「毒」状态",              // 1
            "__NAME__进入「麻痹」状态",            // 2
            "__NAME__进入「攻击力增加」状态",      // 3
            "__NAME__进入「攻击力降低」状态",      // 4
            "__NAME__进入「防御力增加」状态",      // 5
            "__NAME__进入「防御力降低」状态",      // 6
            "__NAME__进入「疯狂战士」状态",        // 7
            "__NAME__进入「晕眩」状态",            // 8
            "__NAME__进入「封印」状态",            // 9
            "__NAME__进入「自坏」状态",            // 10
            "__NAME__进入「不死」状态",            // 11
            "__NAME__进入「恐怖」状态",            // 12
            "__NAME__进入「移动力增加」状态",      // 13
            "__NAME__进入「移动力降低」状态",      // 14
            "__NAME__进入「重生」状态",            // 15
            "__NAME__进入「咒语束缚」状态",        // 16
            "__NAME__进入「混沌」状态",            // 17
            "__NAME__进入「圣痕」状态",            // 18
            "__NAME__进入「能力降低」状态",        // 19
            "__NAME__进入「棒术」状态",            // 20
            "__NAME__进入「诅咒」状态",            // 21
            "__NAME__进入「临界」状态",            // 22
            "__NAME__进入「不死II」状态",          // 23
            "__NAME__进入「猛毒」状态",              // 24
            "__NAME__进入「操想」状态",              // 25
            "__NAME__进入「标靶」状态",              // 26
            "__NAME__进入「断绝」状态",              // 27
            "__NAME__进入「傀儡」状态",              // 28
            ];

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_START	:String = "__NAME__さんとの対戦を開始します";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_WATCH_START	:String = "__PL_NAME__さん対__FOE_NAME__さんのバトル観戦をします";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DUEL_START	:String = "Duel スタート";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_M_DUEL_START:String = "Multi Duel スタート";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_INITIATIVE	:String = "__NAME__がイニシアチブをとりました";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DISTANCE	:String = "距離が __POINT__ になりました";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DISTANCE_MISSING :String = "距離が 不明 になりました\n実際の距離とマッチングしない行動は無効化されます\nこの状態は、一方が相手にダメージを与えることで解除されます";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CHANGE_CHARA:String = "戦闘キャラを変更しました";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_BTL_POINT_1	:String = "攻撃はなし";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_BTL_POINT_2	:String = "攻撃力決定 __POINT__";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_BTL_RESULT	:String = "__NAME__の攻撃はキャンセル";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_TURN_END	:String = "ターン __POINT__ の終了";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DMG_FOR_BOSS:String = "__PL_NAME__さんが__BOSS_NAME__に__POINT__ダメージ";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_HEAL_BOSS   :String = "__BOSS_NAME__が__POINT__回復";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_SUM_DMG_FOR_BOSS :String = "皆さんの攻撃で__BOSS_NAME__に合計__POINT__ダメージを与えた";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_RAID_SCORE    :String = "SCORE:__POINT__";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_TRAP             :String = "__NAME__にトラップ効果発動";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_TRAP_ARLE        :String = "__NAME__にトラップ効果発動, 手札を破棄";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_TRAP_INSC        :String = "結界の効果により、__NAME__はダメージ無効化状態になりました";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_LITTLE_PRINCESS   :String = "リトルプリンセスの効果により、ダメージが無効化された";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CRIMSON_WITCH    :String = "深紅の魔女の効果により、ダメージが2倍になった";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_AVOID_DAMAGE     :String = "__NAME__は__POINT__のダメージを回避しました";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CONSTRAINT       :String = "__NAME__は __ACTIONS__禁止状態になりました";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_WEAPON_STATUS_UP :String = "__NAME__の武器ステータスが向上しました";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_SWORD_DEF_UP     :String = "__NAME__の近距離における防御性能が向上しました";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ARROW_DEF_UP     :String = "__NAME__の遠距離における防御性能が向上しました";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DOLL_ATK         :String = "ヌイグルミによる追加攻撃";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DOLL_CRASH       :String = "ヌイグルミ破壊";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_FORWARD          :String = "前進";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_BACKWARD         :String = "後退";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_STAY             :String = "待機";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CHANGE           :String = "交代";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_STATE_SET:Array = [
            "",                                        // 0
            "__NAME__は「毒」になった",                // 1
            "__NAME__は「麻痺」になった",              // 2
            "__NAME__は「ATK増加」になった",           // 3
            "__NAME__は「ATK低下」になった",           // 4
            "__NAME__は「DEF増加」になった",           // 5
            "__NAME__は「DEF低下」になった",           // 6
            "__NAME__は「バーサーク」になった",        // 7
            "__NAME__は「スタン」になった",            // 8
            "__NAME__は「封印」になった",              // 9
            "__NAME__は「自壊」になった",              // 10
            "__NAME__は「不死」になった",              // 11
            "__NAME__は「恐怖」になった",              // 12
            "__NAME__は「MOV増加」になった",           // 13
            "__NAME__は「MOV低下」になった",           // 14
            "__NAME__は「リジェネレート」になった",    // 15
            "__NAME__は「呪縛」になった",              // 16
            "__NAME__は「混沌」になった",              // 17
            "__NAME__は「聖痕」になった",              // 18
            "__NAME__は「能力低下」になった",          // 19
            "__NAME__は「棍術」になった",              // 20
            "__NAME__は「詛呪」になった",              // 21
            "__NAME__は「臨界」になった",              // 22
            "__NAME__は「不死Ⅱ」になった",             // 2
            "__NAME__は「猛毒」になった",              // 243
            "__NAME__は「操想」になった",              // 25
            "__NAME__は「正鵠」になった",              // 26
            "__NAME__は「断絶」になった",              // 27
            "__NAME__は「人形」になった",              // 28
            ];

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_START	:String = "Duel contre __NAME__.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_WATCH_START	:String = "Vous assistez à un match de __PL_NAME__ contre __FOE_NAME__.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DUEL_START	:String = "Début du Duel.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_M_DUEL_START:String = "Début du Duel en mode multijoueur. ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_INITIATIVE	:String = "__NAME__ a l'Initiative.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DISTANCE	:String = "Vous êtes maintenant en __POINT__.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DISTANCE_MISSING :String = "La distance d'avec votre adversaire ne peut être calculée.\nLes actions qui ne correspondent pas à votre distance ne seront pas prises en compte.\nCette situation disparaît à partir du moment où vous infligez un dommage à votre adversaire.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CHANGE_CHARA:String = "Changement de personnage.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_BTL_POINT_1	:String = "Pas d'attaque.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_BTL_POINT_2	:String = "Attaque __POINT__";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_BTL_RESULT	:String = "__NAME__ a annulé l'attaque.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_TURN_END	:String = "Fin du Tour __POINT__.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DMG_FOR_BOSS:String = "__PL_NAME__ a donné __POINT__dommages à __BOSS_NAME__.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_HEAL_BOSS   :String = "__BOSS_NAME__ a repend __POINT__.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_SUM_DMG_FOR_BOSS :String = "Infligez __POINT__dommages à __BOSS_NAME__ grâce à vos attaques.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_RAID_SCORE    :String = "SCORE:__POINT__";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_TRAP             :String = "Piège posé sur __NAME__";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_TRAP_ARLE        :String = "Piège posé sur __NAME__, destruction de la main";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_TRAP_INSC        :String = "Après résultat, __NAME__ est invincible";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_LITTLE_PRINCESS   :String = "Grâce à l'effet Little Princess, vous ne subissez aucun dommage.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CRIMSON_WITCH    :String = "Grâce à l'effet Sorcière Pourpre, les dommages que vous infligez à votre adversaire sont doublés.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_AVOID_DAMAGE     :String = "__NAME__ évite __POINT__ dommages.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CONSTRAINT       :String = "__NAME__ ne peut plus effectuer __ACTIONS__.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_WEAPON_STATUS_UP :String = "L'efficacité de l'arme de __NAME__ s'est améliorée.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_SWORD_DEF_UP     :String = "La capacité de défense de __NAME__ en situation de courte distance a augmenté.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ARROW_DEF_UP     :String = "La capacité de défense de __NAME__ en situation de longue distance a augmenté.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DOLL_ATK         :String = "Attaque supplémentaire de la Peluche";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DOLL_CRASH       :String = "Destruction de la Peluche";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_FORWARD          :String = "Avancer";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_BACKWARD         :String = "Reculer";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_STAY             :String = "Attente";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CHANGE           :String = "Échange";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_STATE_SET:Array = [
            "",					                        // 0
            "__NAME__ s'empoisonne.",                                   // 1
            "__NAME__ est «paralysé».",                                 // 2
            "__NAME__ a «plus de ATK».",                                // 3
            "__NAME__ a «moins de ATK».",                               // 4
            "__NAME__ a «plus de DEF».",                                // 5
            "__NAME__ a «moins de DEF».",                               // 6
            "__NAME__ «se déchaîne».",                                  // 7
            "__NAME__ est «évanoui».",                                  // 8
            "__NAME__ est «scellé».",                                   // 9
            "__NAME__ se «suicide».",                                   // 10
            "__NAME__ est «immortel».",                                 // 11
            "__NAME__ est «paniqué».",                                  // 12
            "__NAME__ a «plus de MOV».",                                // 13
            "__NAME__ a «moins de MOV».",                               // 14
            "__NAME__ est «régénéré».",                                 // 15
            "__NAME__ souffre d'un «sortilège».",                       // 16
            "__NAME__ est sous l'emprise du «chaos».",                  // 17
            "__NAME__ a eu un «stigmate».",                             // 18
            "__NAME__ a «moins de capacité».",                          // 19
            "__NAME__ est sous l'emprise du «chaos».",                  // 20
            "__NAME__ est maintenant sous l'emprise d'un «Maléfice»",   // 21
            "__NAME__ est maintenant en état «Critique».",              // 22
            "__NAME__ est «immortel II»",                               // 23
            "__NAME__ est «dangereusement empoisonné»",                 // 24
            "__NAME__ est désormais «Chaste»",                          // 25
            "__NAME__ est en état «Cible».",                            // 26
            "__NAME__ est «Extinction».",                               // 27
            "__NAME__ est transformé en «Poupée».",                     // 28
            ];

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_START	:String = "__NAME__さんとの対戦を開始します";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_WATCH_START	:String = "__PL_NAME__さん対__FOE_NAME__さんのバトル観戦をします";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DUEL_START	:String = "Duel スタート";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_M_DUEL_START:String = "Multi Duel スタート";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_INITIATIVE	:String = "__NAME__がイニシアチブをとりました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DISTANCE	:String = "距離が __POINT__ になりました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DISTANCE_MISSING :String = "距離が 不明 になりました\n実際の距離とマッチングしない行動は無効化されます\nこの状態は、一方が相手にダメージを与えることで解除されます";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CHANGE_CHARA:String = "戦闘キャラを変更しました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_BTL_POINT_1	:String = "攻撃はなし";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_BTL_POINT_2	:String = "攻撃力決定 __POINT__";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_BTL_RESULT	:String = "__NAME__の攻撃はキャンセル";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_TURN_END	:String = "ターン __POINT__ の終了";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DMG_FOR_BOSS:String = "__PL_NAME__さんが__BOSS_NAME__に__POINT__ダメージ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_HEAL_BOSS   :String = "__BOSS_NAME__が__POINT__回復";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_SUM_DMG_FOR_BOSS :String = "皆さんの攻撃で__BOSS_NAME__に合計__POINT__ダメージを与えた";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_RAID_SCORE    :String = "SCORE:__POINT__";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_TRAP             :String = "__NAME__にトラップ効果発動";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_TRAP_ARLE        :String = "__NAME__にトラップ効果発動, 手札を破棄";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_TRAP_INSC        :String = "結界の効果により、__NAME__はダメージ無効化状態になりました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_LITTLE_PRINCESS   :String = "リトルプリンセスの効果により、ダメージが無効化された";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CRIMSON_WITCH    :String = "深紅の魔女の効果により、ダメージが2倍になった";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_AVOID_DAMAGE     :String = "__NAME__は__POINT__のダメージを回避しました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CONSTRAINT       :String = "__NAME__は __ACTIONS__禁止状態になりました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_WEAPON_STATUS_UP :String = "__NAME__の武器ステータスが向上しました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_SWORD_DEF_UP     :String = "__NAME__の近距離における防御性能が向上しました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ARROW_DEF_UP     :String = "__NAME__の遠距離における防御性能が向上しました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DOLL_ATK         :String = "ヌイグルミによる追加攻撃";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DOLL_CRASH       :String = "ヌイグルミ破壊";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_FORWARD          :String = "前進";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_BACKWARD         :String = "後退";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_STAY             :String = "待機";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CHANGE           :String = "交代";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_STATE_SET:Array = [
            "",                                        // 0
            "__NAME__は「毒」になった",                // 1
            "__NAME__は「麻痺」になった",              // 2
            "__NAME__は「ATK増加」になった",           // 3
            "__NAME__は「ATK低下」になった",           // 4
            "__NAME__は「DEF増加」になった",           // 5
            "__NAME__は「DEF低下」になった",           // 6
            "__NAME__は「バーサーク」になった",        // 7
            "__NAME__は「スタン」になった",            // 8
            "__NAME__は「封印」になった",              // 9
            "__NAME__は「自壊」になった",              // 10
            "__NAME__は「不死」になった",              // 11
            "__NAME__は「恐怖」になった",              // 12
            "__NAME__は「MOV増加」になった",           // 13
            "__NAME__は「MOV低下」になった",           // 14
            "__NAME__は「リジェネレート」になった",    // 15
            "__NAME__は「呪縛」になった",              // 16
            "__NAME__は「混沌」になった",              // 17
            "__NAME__は「聖痕」になった",              // 18
            "__NAME__は「能力低下」になった",          // 19
            "__NAME__は「棍術」になった",              // 20
            "__NAME__は「詛呪」になった",              // 21
            "__NAME__は「臨界」になった",              // 22
            "__NAME__は「不死Ⅱ」になった",             // 2
            "__NAME__は「猛毒」になった",              // 243
            "__NAME__は「操想」になった",              // 25
            "__NAME__は「正鵠」になった",              // 26
            "__NAME__は「断絶」になった",              // 27
            "__NAME__は「人形」になった",              // 28
            ];

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_START   :String = "เริ่มการประลองกับคุณ __NAME__";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_WATCH_START :String = "ดูการประลองของคุณ __PL_NAME__ กับคุณ __FOE_NAME__";//"__PL_NAME__さん対__FOE_NAME__さんのバトル観戦をします";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DUEL_START  :String = "เริ่มการดูเอล";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_M_DUEL_START:String = "เริ่มมัลติแบทเทิล";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_INITIATIVE  :String = "คุณ __NAME__ ได้สิทธิ์ก่อน";//"__NAME__がイニシアチブをとりました";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DISTANCE    :String = "เปลี่ยนเป็นระยะ  __POINT__";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DISTANCE_MISSING :String = "距離が 不明 になりました\n実際の距離とマッチングしない行動は無効化されます\nこの状態は、一方が相手にダメージを与えることで解除されます";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CHANGE_CHARA:String = "เปลี่ยนตัวละครที่ใช้ต่อสู้แล้ว";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_BTL_POINT_1 :String = "ไม่มีการโจมตี";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_BTL_POINT_2 :String = "พลังการโจมตี __POINT__ แต้ม";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_BTL_RESULT  :String = "ยกเลิกการโจมตีของคุณ __NAME__";//"__NAME__の攻撃はキャンセル";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_TURN_END    :String = "จบเทิร์นที่ __POINT__";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DMG_FOR_BOSS:String = "คุณ__PL_NAME__โจมตี__BOSS_NAME__เป็นจำนวน__POINT__แต้ม";//"__PL_NAME__さんが__BOSS_NAME__に__POINT__ダメージ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_HEAL_BOSS   :String = "__BOSS_NAME__ฟื้นพลัง__POINT__แต้ม";//"__BOSS_NAME__が__POINT__回復";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_SUM_DMG_FOR_BOSS :String = "การโจมตีของทุกคนสร้างความเสียหายแก่__BOSS_NAME__รวม__POINT__แต้ม";//"皆さんの攻撃で__BOSS_NAME__に合計__POINT__ダメージを与えた";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_RAID_SCORE    :String = "SCORE:__POINT__";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_TRAP             :String = ""; // __NAME__にトラップ効果発動
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_TRAP_ARLE        :String = ""; // __NAME__にトラップ効果発動, 手札を破棄
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_TRAP_INSC        :String = ""; // 結界の効果により、__NAME__はダメージ無効化状態になりました
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_LITTLE_PRINCESS   :String = ""; // リトルプリンセスの効果により、ダメージが無効化された
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CRIMSON_WITCH    :String = ""; // 深紅の魔女の効果により、ダメージが2倍になった

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_STATE_SET:Array = [
            "",                                        // 0
            "คุณ __NAME__ อยู่ในสถานะ [ติดพิษ]", // "__NAME__は「毒」になった",                // 1
            "คุณ __NAME__ อยู่ในสถานะ [อัมพาต]", // "__NAME__は「麻痺」になった",              // 2
            "คุณ __NAME__ อยู่ในสถานะ [พลังโจมตีเพิ่มขึ้น]", // "__NAME__は「ATK増加」になった",           // 3
            "คุณ __NAME__ อยู่ในสถานะ [พลังโจมตีลดลง]", // "__NAME__は「ATK低下」になった",           // 4
            "คุณ __NAME__ อยู่ในสถานะ [พลังป้องกันเพิ่มขึ้น]", // "__NAME__は「DEF増加」になった",           // 5
            "คุณ __NAME__ อยู่ในสถานะ [พลังป้องกันลดลง]", // "__NAME__は「DEF低下」になった",           // 6
            "คุณ __NAME__ อยู่ในสถานะ [บ้าคลั่ง]", // "__NAME__は「バーサーク」になった",        // 7
            "คุณ __NAME__ อยู่ในสถานะ [มึนงง]", // "__NAME__は「スタン」になった",            // 8
            "คุณ __NAME__ อยู่ในสถานะ [ถูกผนึก]", // "__NAME__は「封印」になった",              // 9
            "คุณ __NAME__ อยู่ในสถานะ [ทำลายตัวเอง]", // "__NAME__は「自壊」になった",              // 10
            "คุณ __NAME__ อยู่ในสถานะ [อมตะ]", // "__NAME__は「不死」になった",              // 11
            "คุณ __NAME__ อยู่ในสถานะ [หวาดกลัว]", // "__NAME__は「恐怖」になった",              // 12
            "คุณ __NAME__ อยู่ในสถานะ [การเคลื่อนไหวเพิ่มขึ้น]", // "__NAME__は「MOV増加」になった",           // 13
            "คุณ __NAME__ อยู่ในสถานะ [การเคลื่อนไหวลดลง]", // "__NAME__は「MOV低下」になった",           // 14
            "คุณ __NAME__ อยู่ในสถานะ [คืนชีวิต]", // "__NAME__は「リジェネレート」になった",    // 15
            "คุณ __NAME__ อยู่ในสถานะ [ต้องสาป]", // "__NAME__は「呪縛」になった",              // 16
            "คุณ __NAME__ อยู่ในสถานะ [สับสน]", // "__NAME__は「混沌」になった",              // 17
            "คุณ __NAME__ อยู่ในสถานะ [แผลศักดิ์สิทธิ์]", // "__NAME__は「聖痕」になった",              // 18
            "คุณ __NAME__ อยู่ในสถานะ [ความสามารถลดลง]", // "__NAME__は「能力低下」になった",          // 19
            "__NAME__ใช้ [ศาสตร์ไม้เท้า]", // "__NAME__は「棍術」になった",              // 20
            "", // "__NAME__は「詛呪」になった",              // 21
            "", // "__NAME__は「臨界」になった",              // 22
            "", // __NAME__は「不死Ⅱ」になった             // 23
            "", // __NAME__は「猛毒」になった              // 24
            "", // __NAME__は「操想」になった              // 25
            "", // __NAME__は「正鵠」になった              // 26
            "__NAME__は「断絶」になった",              // 27
            "__NAME__は「人形」になった",              // 28
            ];

        // singleton
        private static var __instance:DuelMessage = null;

        // MessageLog
        private var _gameLog:MessageLog = MessageLog.getMessageLog(MessageLog.GAME_LOG);
        // ProfoundLogs
        private var _prfGameLog:ProfoundLogs = ProfoundLogs.getInstance();

        public static function setMessage(str:String):void
        {
            if (__instance == null) {initDuelMessage();}
            log.writeLog(log.LV_FATAL, "", "DuelMessage", str);
            var strData:Array = str.split(":");
            var msgDlgId:int = parseInt(strData.shift());
            var msgData:Array = (strData.length > 0 ) ? strData[0].split(",") : null;
            log.writeLog(log.LV_FATAL, "", "DuelMessage", str);

            __instance.setLogMessage(msgDlgId,msgData);
        }

        private static function initDuelMessage():void
        {
            __instance = new DuelMessage();
        }

        /**
         * コンストラクタ
         *
         */
        public function DuelMessage()
        {
        }

        private function setLogMessage(msgDlgId:int,msgData:Array):void
        {
            if (msgDlgId >= 0 && msgDlgId < DUEL_MSGDLG_MAX)
            {
                var msg:String = null;
                log.writeLog(log.LV_DEBUG,this, "mid="+msgDlgId);
                switch (msgDlgId)
                {
                case DUEL_MSGDLG_START:
                    msg = _TRANS_MSG_START.replace("__NAME__",msgData[0]);
                    break;
                case DUEL_MSGDLG_WATCH_START:
                    msg = _TRANS_MSG_WATCH_START.replace("__PL_NAME__",msgData[0]).replace("__FOE_NAME__",msgData[1]);
                    break;
                case DUEL_MSGDLG_DUEL_START:
                    msg = _TRANS_MSG_DUEL_START;
                    break;
                case DUEL_MSGDLG_M_DUEL_START:
                    msg = _TRANS_MSG_M_DUEL_START;
                    break;
                case DUEL_MSGDLG_INITIATIVE:
                    msg = _TRANS_MSG_INITIATIVE.replace("__NAME__",msgData[0]);
                    break;
                case DUEL_MSGDLG_DISTANCE:
                    if (msgData[0] == 4)
                    {
                        msg = _TRANS_MSG_DISTANCE_MISSING;
                    }
                    else
                    {
                        msg = _TRANS_MSG_DISTANCE.replace("__POINT__",msgData[0]);
                    }
                    break;
                case DUEL_MSGDLG_CHANGE_CHARA:
                    msg = _TRANS_MSG_CHANGE_CHARA;
                    break;
                case DUEL_MSGDLG_BTL_POINT:
                    var point:int = parseInt(msgData[0]);
                    if (point > 0) {
                        msg = _TRANS_MSG_BTL_POINT_2.replace("__POINT__",point);
                    } else {
                        msg = _TRANS_MSG_BTL_POINT_1;
                    }
                    break;
                case DUEL_MSGDLG_BTL_RESULT:
                    msg = _TRANS_MSG_BTL_RESULT.replace("__NAME__",msgData[0]);
                    break;
                case DUEL_MSGDLG_TURN_END:
                    msg = _TRANS_MSG_TURN_END.replace("__POINT__",parseInt(msgData[0]));
                    break;
                case DUEL_MSGDLG_SPECIAL:
                    // msg = _TRANS_MSG_START.replace("__NAME__",msgStr);
                    break;
                case DUEL_MSGDLG_STATE:
                    var state:int = parseInt(msgData[0]);
                    var name:String = msgData[1];
                    msg = _TRANS_MSG_STATE_SET[state].replace("__NAME__",name);
                    break;
                case DUEL_MSGDLG_DMG_FOR_BOSS:
                    msg = _TRANS_MSG_DMG_FOR_BOSS.replace("__PL_NAME__",msgData[0]).replace("__BOSS_NAME__",msgData[1]).replace("__POINT__",msgData[2]);
                    break;
                case DUEL_MSGDLG_HEAL_BOSS:
                    msg = _TRANS_MSG_HEAL_BOSS.replace("__BOSS_NAME__",msgData[0]).replace("__POINT__",msgData[1]);
                    break;
                case DUEL_MSGDLG_SUM_DMG_FOR_BOSS:
                    msg = _TRANS_MSG_SUM_DMG_FOR_BOSS.replace("__BOSS_NAME__",msgData[0]).replace("__POINT__",msgData[1]);
                    break;
                case DUEL_MSGDLG_RAID_SCORE:
                    msg = _TRANS_MSG_RAID_SCORE.replace("__POINT__",msgData[0]);
                    break;
                case DUEL_MSGDLG_TRAP:
                    msg = _TRANS_MSG_TRAP.replace("__NAME__",msgData[0]);
                    break;
                case DUEL_MSGDLG_TRAP_ARLE:
                    msg = _TRANS_MSG_TRAP_ARLE.replace("__NAME__",msgData[0]);
                    break;
                case DUEL_MSGDLG_TRAP_INSC:
                    msg = _TRANS_MSG_TRAP_INSC.replace("__NAME__",msgData[0]);
                    break;
                case DUEL_MSGDLG_LITTLE_PRINCESS:
                    msg = _TRANS_MSG_LITTLE_PRINCESS;
                    break;
                case DUEL_MSGDLG_CRIMSON_WITCH:
                    msg = _TRANS_MSG_CRIMSON_WITCH;
                    break;
                case DUEL_MSGDLG_AVOID_DAMAGE:
                    msg = _TRANS_MSG_AVOID_DAMAGE.replace("__NAME__",msgData[1]).replace("__POINT__",msgData[0]);
                    break;
                case DUEL_MSGDLG_CONSTRAINT:
                    msg = _TRANS_MSG_CONSTRAINT.replace("__NAME__",msgData[1]).replace("__ACTIONS__",getActionsStr(msgData[0]));
                    break;
                case DUEL_MSGDLG_WEAPON_STATUS_UP:
                    msg = _TRANS_MSG_WEAPON_STATUS_UP.replace("__NAME__",msgData[0]);
                    break;
                case DUEL_MSGDLG_SWORD_DEF_UP:
                    msg = _TRANS_MSG_SWORD_DEF_UP.replace("__NAME__",msgData[0]);
                    break;
                case DUEL_MSGDLG_ARROW_DEF_UP:
                    msg = _TRANS_MSG_ARROW_DEF_UP.replace("__NAME__",msgData[0]);
                    break;
                case DUEL_MSGDLG_DOLL_ATK:
                    msg = _TRANS_MSG_DOLL_ATK;
                    break;
                case DUEL_MSGDLG_DOLL_CRASH:
                    msg = _TRANS_MSG_DOLL_CRASH;
                    break;
                default:
                }
                if (_gameLog&&msg){_gameLog.setMessage(msg)}
                if (_prfGameLog&&msg&&_prfGameLog.prfId!=0){_prfGameLog.setGameLogPrfId(_prfGameLog.prfId,msg)}
            }
        }

        private function getActionsStr(flag:int):String
        {
            var actions:Array = [];
            if ((flag & ConstraintEvent.CONSTRAINT_FORWARD) == ConstraintEvent.CONSTRAINT_FORWARD) actions.push(_TRANS_MSG_FORWARD);
            if ((flag & ConstraintEvent.CONSTRAINT_BACKWARD) == ConstraintEvent.CONSTRAINT_BACKWARD) actions.push(_TRANS_MSG_BACKWARD);
            if ((flag & ConstraintEvent.CONSTRAINT_STAY) == ConstraintEvent.CONSTRAINT_STAY) actions.push(_TRANS_MSG_STAY);
            if ((flag & ConstraintEvent.CONSTRAINT_CHARA_CHANGE) == ConstraintEvent.CONSTRAINT_CHARA_CHANGE) actions.push(_TRANS_MSG_CHANGE);
            return actions.join(", ");
        }

    }

}
