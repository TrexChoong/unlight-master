package view.scene.library
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;
    import flash.utils.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.quest.*;
    import view.scene.BaseScene;

    import controller.QuestCtrl;
    import view.utils.*


    /**
     * キャラカードデッキ表示クラス
     *
     */
    public class MonsterCardListScene extends CharaCardListScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS101	:String = "森の小人";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS102	:String = "蝙蝠";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS103	:String = "大蛙";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS104	:String = "鬼火";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS105	:String = "茸兎";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS106	:String = "吊り男";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS107	:String = "食屍鬼";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS108	:String = "人狼";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS109	:String = "黒き哨兵";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS110	:String = "狂狼";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS111	:String = "鋼鉄の男";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS112	:String = "幽霊騎士";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS113	:String = "炎鬼";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS114	:String = "影斬り森の夢魔";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS115	:String = "毒鼠";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS116	:String = "骸骨兵";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS117	:String = "透明な布";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS118	:String = "呪われし剣";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS119	:String = "バフォメット";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS120	:String = "ナイチンゲール";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS121	:String = "双頭犬オルトス";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS122	:String = "吸血鬼";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS123	:String = "白蜘蛛";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS124	:String = "夜鬼";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS125	:String = "妖蛇";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS126	:String = "白の織者";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS127	:String = "機械兵";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS128	:String = "ウボスの爪";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS129	:String = "ルビオナ偵察機";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS130	:String = "妖花";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS131	:String = "白魔";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS132	:String = "ハルピュイア";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS133	:String = "竜人";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS134	:String = "ドラゴンパピー";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS135	:String = "天使";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS136	:String = "餓鬼";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS137	:String = "掟の箱";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS138	:String = "死の歯車";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS139	:String = "イービルアイ";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS140	:String = "母子像";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS141	:String = "虚無";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS142	:String = "聖女の猫";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS143	:String = "夢馬";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS144	:String = "リリス";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS145	:String = "魂の器";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS1000	:String = "モンスターコイン";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS1001	:String = "カードのかけら";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2001	:String = "月光姫レミア";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2002	:String = "ウボス";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2003	:String = "飛竜王メリュジーヌ";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2004	:String = "クランプス";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2005	:String = "丘王";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2006	:String = "巨大蛙";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2007	:String = "アスタロト";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2008	:String = "ブレンダン";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2009	:String = "アリス";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2010	:String = "ベアトリス";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2011	:String = "炎の聖女";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2012	:String = "幼生ウボス";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2013	:String = "幼生ウボス";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2014	:String = "パンプキング";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2015	:String = "クランプス2012";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2016	:String = "聖域の凱旋門";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2017	:String = "おたま王子";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2018	:String = "おたま王子";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2019	:String = "陸水母";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2020	:String = "クランプス2013";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2021	:String = "クランプス2013";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2022	:String = "フラム";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2023	:String = "陽気な妖精";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2024	:String = "クランプス2014";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2030	:String = "ヴィレア";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2036	:String = "クランプス2015";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2045	:String = "グリュンワルドの影";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2046	:String = "タイレルの影";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2047	:String = "ヴィルヘルムの影";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS9001	:String = "リリィ";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2051	:String = "クランプス2016";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2052	:String = "人気者の妖精";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2055	:String = "シェリの影";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2056	:String = "フリードリヒの影";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2057	:String = "スプラートの影";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2058	:String = "リーズの影";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2059	:String = "C.C.の影";
        CONFIG::LOCALE_JP
        private static const _TRANS_MONS2062	:String = "ギュスターヴの影";

        CONFIG::LOCALE_EN
        private static const _TRANS_MONS101	:String = "Zwerge";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS102	:String = "Cave Bat";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS103	:String = "Giant Toad";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS104	:String = "Will o' the Wisp";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS105	:String = "Mushroom Beast";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS106	:String = "Hanged Man";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS107	:String = "Ghoul";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS108	:String = "Werewolf";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS109	:String = "Black Sentinel";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS110	:String = "Mad Wolf";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS111	:String = "Man of Steel";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS112	:String = "Dullahan";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS113	:String = "Flame Daemon of Beoboros";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS114	:String = "Lilit";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS115	:String = "Poison Rat";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS116	:String = "Skeleton Soldier";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS117	:String = "Invisible Cloth";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS118	:String = "Cursed Sword";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS119	:String = "Baphomet";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS120	:String = "Nightingale";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS121	:String = "Orthrus";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS122	:String = "Vampire";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS123	:String = "White Spider";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS124	:String = "Night Ogre";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS125	:String = "Evil Snake";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS126	:String = "White Seeker";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS127	:String = "Mechanical Soldiers";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS128	:String = "Four Limbs of Ubos";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS129	:String = "Scout Machine";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS130	:String = "Demonic Flower";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS131	:String = "Pale People";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS132	:String = "Harpy";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS133	:String = "Dragon People";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS134	:String = "Dragon Pup";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS135	:String = "Angel";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS136	:String = "Preta";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS137	:String = "The Ark";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS138	:String = "Gear of Death";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS139	:String = "Evil Eye";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS140	:String = "Stone Idol";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS141	:String = "Zero";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS142	:String = "Avatar Cat";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS143	:String = "Nightmare";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS144	:String = "Lilith";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS145	:String = "Soul Link";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS1000	:String = "Monster Coin";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS1001	:String = "Card Fragment";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2001	:String = "Lamia";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2002	:String = "Ubos";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2003	:String = "Melusine";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2004	:String = "Krampus";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2005	:String = "Zwerge King";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2006	:String = "Giant Toad";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2007	:String = "Astaroth";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2008	:String = "Brendan";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2009	:String = "Alice";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2010	:String = "Beatrice";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2011	:String = "Goddess of Fire";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2012	:String = "Ubos' Larvae";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2013	:String = "Ubos' Larvae";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2014	:String = "Pumpking";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2015	:String = "Krampus 2012";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2016	:String = "Heaven's Sacred Arches";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2017	:String = "Tadpole Prince";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2018	:String = "Tadpole Prince";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2019	:String = "Land Jelly";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2020	:String = "Krampus 2013";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2021	:String = "Krampus 2013";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2022	:String = "Frum";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2023	:String = "Tooth Fairy";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2024	:String = "Krampus 2014";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2030	:String = "Vihreä";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2036	:String = "Krampus 2015";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2045	:String = "";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2046	:String = "";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2047	:String = "";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS9001	:String = "Lily";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2051	:String = "Krampus 2016";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2052	:String = "人気者の妖精";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2055	:String = "シェリの影";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2056	:String = "フリードリヒの影";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2057	:String = "スプラートの影";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2058	:String = "リーズの影";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2059	:String = "C.C.の影";
        CONFIG::LOCALE_EN
        private static const _TRANS_MONS2062	:String = "ギュスターヴの影";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS101	:String = "森林侏儒";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS102	:String = "蝙蝠";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS103	:String = "大蛙";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS104	:String = "鬼火";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS105	:String = "茸兔";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS106	:String = "吊死者";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS107	:String = "食屍鬼";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS108	:String = "狼人";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS109	:String = "黑哨兵";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS110	:String = "狂狼";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS111	:String = "鋼鐵男";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS112	:String = "幽靈騎士";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS113	:String = "炎鬼";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS114	:String = "斬影夢魔";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS115	:String = "毒鼠";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS116	:String = "骸骨兵";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS117	:String = "透明布";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS118	:String = "咒怨劍";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS119	:String = "巴風特";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS120	:String = "夜光鳥";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS121	:String = "雙頭犬歐爾多斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS122	:String = "吸血鬼";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS123	:String = "白蜘蛛";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS124	:String = "夜鬼";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS125	:String = "妖蛇";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS126	:String = "白色引者";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS127	:String = "機械兵";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS128	:String = "烏波斯的四肢";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS129	:String = "偵察機器";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS130	:String = "妖魔草";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS131	:String = "白魔";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS132	:String = "哈耳庇厄";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS133	:String = "龍人";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS134	:String = "飛龍";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS135	:String = "天使";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS136	:String = "餓鬼";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS137	:String = "律法之箱";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS138	:String = "死之齒輪";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS139	:String = "邪惡之眼";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS140	:String = "母子像";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS141	:String = "虛無";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS142	:String = "聖女的貓";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS143	:String = "夢魘馬";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS144	:String = "莉莉絲";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS145	:String = "靈魂容器";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS1000	:String = "怪物硬幣";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS1001	:String = "卡片碎片";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2001	:String = "月光姬蕾米雅";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2002	:String = "烏波斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2003	:String = "飛龍王梅爾基努";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2004	:String = "羊角獸";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2005	:String = "丘王";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2006	:String = "巨大蛙";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2007	:String = "亞斯塔祿";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2008	:String = "布蘭登";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2009	:String = "艾莉絲";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2010	:String = "貝阿朵莉絲";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2011	:String = "炎之聖女";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2012	:String = "幼生烏波斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2013	:String = "幼生烏波斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2014	:String = "南瓜王";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2015	:String = "羊角獸2012";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2016	:String = "聖域的凱旋門";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2017	:String = "蝌蚪王子";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2018	:String = "蝌蚪王子";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2019	:String = "陸水母";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2020	:String = "羊角獸2013";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2021	:String = "羊角獸2013";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2022	:String = "弗拉姆";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2023	:String = "開朗的妖精";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2024	:String = "羊角獸2014";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2030	:String = "畢雷亞";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2036	:String = "羊角獸2015";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2045	:String = "古魯瓦爾多的影子";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2046	:String = "泰瑞爾的影子";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2047	:String = "威廉的影子";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS9001	:String = "莉莉";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2051	:String = "羊角獸2016";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2052	:String = "人氣者的妖精";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2055	:String = "雪莉的影子";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2056	:String = "弗雷特里西的影子";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2057	:String = "史普拉多的影子";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2058	:String = "里斯的影子";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2059	:String = "C.C.的影子";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MONS2062	:String = "古斯塔夫的影子";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS101	:String = "森林侏儒";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS102	:String = "蝙蝠";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS103	:String = "大蛙";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS104	:String = "鬼火";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS105	:String = "茸兔";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS106	:String = "吊死者";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS107	:String = "食尸鬼";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS108	:String = "狼人";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS109	:String = "黑哨兵";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS110	:String = "狂狼";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS111	:String = "钢铁男";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS112	:String = "幽灵骑士";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS113	:String = "炎鬼";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS114	:String = "斩影梦魔";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS115	:String = "毒鼠";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS116	:String = "骸骨兵";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS117	:String = "透明布";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS118	:String = "咒怨剑";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS119	:String = "巴风特";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS120	:String = "夜光鸟";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS121	:String = "双头犬欧尔多斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS122	:String = "吸血鬼";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS123	:String = "白蜘蛛";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS124	:String = "夜鬼";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS125	:String = "妖蛇";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS126	:String = "白色引者";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS127	:String = "机械兵";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS128	:String = "乌波斯的四肢";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS129	:String = "侦察机器";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS130	:String = "妖魔草";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS131	:String = "白魔";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS132	:String = "哈耳庇厄";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS133	:String = "龙人";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS134	:String = "初生龙";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS135	:String = "天使";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS136	:String = "饿鬼";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS137	:String = "律法之箱";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS138	:String = "死之齿轮";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS139	:String = "邪恶之眼";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS140	:String = "母子像";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS141	:String = "虚无";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS142	:String = "圣女的猫";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS143	:String = "梦魇马";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS144	:String = "莉莉丝";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS145	:String = "灵魂容器";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS1000	:String = "怪物硬币";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS1001	:String = "卡片碎片";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2001	:String = "月光姬蕾米雅";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2002	:String = "乌波斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2003	:String = "飞龙王梅尔基努";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2004	:String = "羊角兽";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2005	:String = "丘王";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2006	:String = "巨大蛙";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2007	:String = "守护者亚斯塔禄";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2008	:String = "冰魔布兰登";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2009	:String = "艾莉丝";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2010	:String = "贝阿朵莉丝";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2011	:String = "炎之圣女";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2012	:String = "幼生乌波斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2013	:String = "幼生乌波斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2014	:String = "南瓜王";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2015	:String = "南瓜王2012";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2016	:String = "圣域的凯旋门";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2017	:String = "蝌蚪王子";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2018	:String = "蝌蚪王子";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2019	:String = "陆水母";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2020	:String = "羊角兽2013";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2021	:String = "羊角兽2013";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2022	:String = "弗拉姆";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2023	:String = "开朗的妖精";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2024	:String = "羊角兽2014";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2030	:String = "毕雷亚";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2036	:String = "羊角兽2015";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2045	:String = "古鲁瓦尔多的影子";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2046	:String = "泰瑞尔的影子";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2047	:String = "威廉的影子";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS9001	:String = "莉莉";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2051	:String = "羊角兽2016";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2052	:String = "人気者的妖精";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2055	:String = "雪莉的影子";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2056	:String = "弗雷特里西的影子";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2057	:String = "史普拉多的影子";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2058	:String = "里斯的影子";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2059	:String = "C.C.的影子";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MONS2062	:String = "古斯塔夫的影子";

        CONFIG::LOCALE_KR
        private static const _TRANS_MONS101	:String = "숲의 난쟁이";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS102	:String = "박쥐";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS103	:String = "큰개구리";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS104	:String = "귀화";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS105	:String = "버섯토끼";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS106	:String = "억울하게 죽은 자";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS107	:String = "식시귀";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS108	:String = "인랑";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS109	:String = "흑초병";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS110	:String = "광기의 늑대";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS111	:String = "강철거인";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS112	:String = "유령기사";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS113	:String = "염혼";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS114	:String = "그림자 숲의 몽마";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS115	:String = "독 쥐";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS116	:String = "해골병사";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS117	:String = "투명한 천";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS118	:String = "저주의 검";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS119	:String = "바포메트";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS120	:String = "나이팅게일";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS121	:String = "오로토스";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS122	:String = "흡혈귀";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS123	:String = "백색 거미";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS124	:String = "야귀";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS125	:String = "나가";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS126	:String = "백색의 인도자";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS127	:String = "기계병";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS128	:String = "우보스의 사지";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS129	:String = "정찰기계";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS130	:String = "요마의 풀";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS131	:String = "백마";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS132	:String = "하피";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS133	:String = "용인";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS134	:String = "비룡";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS135	:String = "천사";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS136	:String = "아귀";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS137	:String = "악마의 상자";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS138	:String = "죽음의 톱니바퀴";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS139	:String = "이블 아이";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS140	:String = "모자의 상";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS141	:String = "공허의 망령";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS142	:String = "성녀의 고양이";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS143	:String = "몽마";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS144	:String = "릴리스";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS145	:String = "영혼의 그릇";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS1000	:String = "몬스터 코인";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS1001	:String = "카드의 조각";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2001	:String = "달빛공주 레미아";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2002	:String = "우보스";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2003	:String = "비룡왕 메류지누";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2004	:String = "크램프스";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2005	:String = "언덕의 왕";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2006	:String = "거대개구리";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2007	:String = "아스타로스";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2008	:String = "브렌다";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2009	:String = "앨리스";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2010	:String = "베아트리체";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2011	:String = "화염의 성녀";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2012	:String = "유충우보스";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2013	:String = "유충우보스";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2014	:String = "펌프킨";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2015	:String = "크램프스2012";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2016	:String = "聖域の凱旋門";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2017	:String = "おたま王子";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2018	:String = "おたま王子";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2019	:String = "陸水母";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2020	:String = "クランプス2013";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2021	:String = "クランプス2013";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2022	:String = "フラム";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2023	:String = "陽気な妖精";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2024	:String = "クランプス2014";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2030	:String = "ヴィレア";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2036	:String = "クランプス2015";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2045	:String = "グリュンワルドの影";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2046	:String = "タイレルの影";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2047	:String = "ヴィルヘルムの影";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS9001	:String = "リリィ";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2051	:String = "クランプス2016";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2052	:String = "人気者の妖精";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2055	:String = "シェリの影";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2056	:String = "フリードリヒの影";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2057	:String = "スプラートの影";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2058	:String = "リーズの影";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2059	:String = "C.C.の影";
        CONFIG::LOCALE_KR
        private static const _TRANS_MONS2062	:String = "ギュスターヴの影";

        CONFIG::LOCALE_FR
        private static const _TRANS_MONS101	:String = "Zwerge";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS102	:String = "Chauve-souris";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS103	:String = "Crapaud Géant";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS104	:String = "Feufollet";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS105	:String = "Lapin Fongique";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS106	:String = "Pendu";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS107	:String = "Goule";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS108	:String = "Loup-garou";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS109	:String = "Sentinelle Noire";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS110	:String = "Loup Enragé";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS111	:String = "Homme d'Acier";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS112	:String = "Dullahan";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS113	:String = "Démon de Béoboros";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS114	:String = "Lilith";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS115	:String = "Rat Toxique";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS116	:String = "Squelette Guerrier";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS117	:String = "Vêtement Invisible";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS118	:String = "Epée Maudite";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS119	:String = "Baphomet";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS120	:String = "Nachtigall";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS121	:String = "Orthos";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS122	:String = "Vampire";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS123	:String = "Araignée Laiteuse";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS124	:String = "Ogre des Ténèbres";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS125	:String = "Serpent Maléfique";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS126	:String = "Savant Immaculé";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS127	:String = "Machine a soldat";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS128	:String = "Ongle d'Ubos";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS129	:String = "Eclaireur";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS130	:String = "Fleur Démoniaque";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS131	:String = "Gentes Opalines";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS132	:String = "Harpie";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS133	:String = "Peuple du Dragon";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS134	:String = "Dragon-Chiot";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS135	:String = "Ange";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS136	:String = "Preta";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS137	:String = "Arche";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS138	:String = "Roue de la Mort";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS139	:String = "Evil Eye";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS140	:String = "Statue de pierre";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS141	:String = "Zéro";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS142	:String = "Chat de l'Avatar";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS143	:String = "Cheval des Enfers";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS144	:String = "Lilith";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS145	:String = "Vase aux Âmes";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS1000	:String = "Pièce Monstre";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS1001	:String = "Fragment de Carte";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2001	:String = "Lamia";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2002	:String = "Ubos";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2003	:String = "Mélusine";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2004	:String = "Cramps";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2005	:String = "Roi de Zwerge";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2006	:String = "Crapaud Titanesque";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2007	:String = "Astaroth";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2008	:String = "Brendan";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2009	:String = "Alice";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2010	:String = "Béatrice";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2011	:String = "Vesta";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2012	:String = "Larve Ubos";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2013	:String = "Larve Ubos";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2014	:String = "Pumpking";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2015	:String = "Cramps2012";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2016	:String = "Arche Sacrée";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2017	:String = "Prince Têtard";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2018	:String = "Prince Têtard";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2019	:String = "Méduse Terrestre";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2020	:String = "Crumps2013";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2021	:String = "Crumps2013";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2022	:String = "Frum";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2023	:String = "Fée Joyeuse";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2024	:String = "Crumps2014";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2030	:String = "Viléa";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2036	:String = "Crumps2015";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2045	:String = "";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2046	:String = "";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2047	:String = "";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS9001	:String = "Lily";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2051	:String = "Crumps 2016";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2052	:String = "人気者の妖精";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2055	:String = "シェリの影";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2056	:String = "フリードリヒの影";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2057	:String = "スプラートの影";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2058	:String = "リーズの影";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2059	:String = "C.C.の影";
        CONFIG::LOCALE_FR
        private static const _TRANS_MONS2062	:String = "ギュスターヴの影";

        CONFIG::LOCALE_ID
        private static const _TRANS_MONS101	:String = "森の小人";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS102	:String = "蝙蝠";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS103	:String = "大蛙";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS104	:String = "鬼火";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS105	:String = "茸兎";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS106	:String = "吊り男";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS107	:String = "食屍鬼";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS108	:String = "人狼";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS109	:String = "黒き哨兵";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS110	:String = "狂狼";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS111	:String = "鋼鉄の男";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS112	:String = "幽霊騎士";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS113	:String = "炎鬼";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS114	:String = "影斬り森の夢魔";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS115	:String = "毒鼠";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS116	:String = "骸骨兵";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS117	:String = "透明な布";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS118	:String = "呪われし剣";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS119	:String = "バフォメット";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS120	:String = "ナイチンゲール";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS121	:String = "双頭犬オルトス";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS122	:String = "吸血鬼";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS123	:String = "白蜘蛛";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS124	:String = "夜鬼";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS125	:String = "妖蛇";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS126	:String = "白の織者";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS127	:String = "機械兵";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS128	:String = "ウボスの爪";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS129	:String = "ルビオナ偵察機";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS130	:String = "妖花";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS131	:String = "白魔";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS132	:String = "ハルピュイア";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS133	:String = "竜人";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS134	:String = "ドラゴンパピー";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS135	:String = "天使";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS136	:String = "餓鬼";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS137	:String = "掟の箱";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS138	:String = "死の歯車";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS139	:String = "イービルアイ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS140	:String = "母子像";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS141	:String = "虚無";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS142	:String = "聖女の猫";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS143	:String = "夢馬";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS144	:String = "リリス";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS145	:String = "魂の器";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS1000	:String = "モンスターコイン";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS1001	:String = "カードのかけら";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2001	:String = "月光姫レミア";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2002	:String = "ウボス";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2003	:String = "飛竜王メリュジーヌ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2004	:String = "クランプス";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2005	:String = "丘王";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2006	:String = "巨大蛙";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2007	:String = "アスタロト";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2008	:String = "ブレンダン";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2009	:String = "アリス";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2010	:String = "ベアトリス";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2011	:String = "炎の聖女";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2012	:String = "幼生ウボス";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2013	:String = "幼生ウボス";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2014	:String = "パンプキング";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2015	:String = "クランプス2012";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2016	:String = "聖域の凱旋門";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2017	:String = "おたま王子";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2018	:String = "おたま王子";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2019	:String = "陸水母";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2020	:String = "クランプス2013";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2021	:String = "クランプス2013";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2022	:String = "フラム";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2023	:String = "陽気な妖精";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2024	:String = "クランプス2014";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2030	:String = "ヴィレア";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2036	:String = "クランプス2015";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2045	:String = "グリュンワルドの影";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2046	:String = "タイレルの影";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2047	:String = "ヴィルヘルムの影";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS9001	:String = "リリィ";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2051	:String = "クランプス2016";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2052	:String = "人気者の妖精";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2055	:String = "シェリの影";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2056	:String = "フリードリヒの影";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2057	:String = "スプラートの影";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2058	:String = "リーズの影";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2059	:String = "C.C.の影";
        CONFIG::LOCALE_ID
        private static const _TRANS_MONS2062	:String = "ギュスターヴの影";

        CONFIG::LOCALE_TH
        private static const _TRANS_MONS101 :String = "คนแคระป่า";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS102 :String = "ค้างคาว";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS103 :String = "กบยักษ์";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS104 :String = "ดวงไฟยักษ์";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS105 :String = "ภูตเห็ด";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS106 :String = "ชายห้อยหัว";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS107 :String = "ผีกินศพ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS108 :String = "มนุษย์หมาป่า";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS109 :String = "องครักษ์สีดำ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS110 :String = "หมาป่าคลั่ง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS111 :String = "มนุษย์เหล็ก";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS112 :String = "อัศวินวิญญาณ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS113 :String = "ยักษ์เพลิง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS114 :String = "ลิลิธ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS115 :String = "หนูพิษ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS116 :String = "ทหารโครงกระดูก";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS117 :String = "ผ้าคลุมปิศาจ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS118 :String = "ดาบต้องสาป";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS119 :String = "บาโฟเมท";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS120 :String = "ไนติงเกล";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS121 :String = "ออร์โธรส สุนัขสองหัว";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS122 :String = "ผีดูดเลือด";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS123 :String = "แมงมุมขาว";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS124 :String = "ยักษ์ราตรี";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS125 :String = "ภูตอสรพิษ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS126 :String = "ผู้รับใช้สีขาว";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS127 :String = "ทหารจักรกล";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS128 :String = "หนวดของอูโบส";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS129 :String = "หุ่นยนต์สอดแนม";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS130 :String = "บุปผาเวท";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS131 :String = "ปิศาจขาว";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS132 :String = "ฮาร์พี";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS133 :String = "มนุษย์มังกร";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS134 :String = "มังกรบิน";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS135 :String = "ทูตสวรรค์";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS136 :String = "เปรตา";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS137 :String = "หีบแห่งกฎ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS138 :String = "ฟันเฟืองแห่งความตาย";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS139 :String = "อีวิล อาย";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS140 :String = "ประติมากรรมหิน";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS141 :String = "สูญ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS142 :String = "แมวจำแลง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS143 :String = "อาชาแห่งฝัน";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS144 :String = "เดวิล เกิร์ล";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS145 :String = "ภาชนะวิญญาณ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS1000    :String = "มอนสเตอร์ คอยน์";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS1001    :String = "เศษการ์ด";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2001    :String = "เลเมีย เจ้าหญิงแสงจันทร์";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2002    :String = "อูโบส";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2003    :String = "เมลูซีน";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2004    :String = "แครมปส์";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2005    :String = "ราชาคนแคระ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2006    :String = "ราชากบยักษ์";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2007    :String = "แอสทารอธ ผู้พิทักษ์";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2008    :String = "เบรนดัน ปิศาจน้ำแข็ง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2009    :String = "อลิซ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2010    :String = "เบียทริซ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2011    :String = "นักบุญหญิงแห่งไฟ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2012    :String = "ตัวอ่อนอูโบส (ซ้าย)";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2013    :String = "ตัวอ่อนอูโบส (ขวา)";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2014    :String = "พัมพ์คิง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2015    :String = "ครัมปส์ 2012 (ซานตาคลอสแห่งความมืด)";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2016    :String = "ประตูแห่งปราสาทศักดิ์สิทธิ์";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2017    :String = "เจ้าชายลูกอ๊อด (แดง)";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2018    :String = "เจ้าชายลูกอ๊อด (น้ำเงิน)";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2019	:String = "แมงกระพรุนดิน"; // 陸水母
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2020	:String = "ครัมป์ส2013"; // クランプス2013
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2021	:String = "ครัมป์ส2013"; // クランプス2013
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2022	:String = "ฟลัม"; // フラム
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2023	:String = ""; // 陽気な妖精
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2024	:String = "ครัมป์ส2014";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2030	:String = "ヴィレア";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2036	:String = "ครัมป์ส2015";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2045	:String = "グリュンワルドの影";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2046	:String = "タイレルの影";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2047	:String = "ヴィルヘルムの影";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS9001	:String = ""; //リリィ
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2051	:String = "ครัมป์ส2016";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2052	:String = "人気者の妖精";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2055	:String = "シェリの影";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2056	:String = "フリードリヒの影";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2057	:String = "スプラートの影";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2058	:String = "リーズの影";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2059	:String = "C.C.の影";
        CONFIG::LOCALE_TH
        private static const _TRANS_MONS2062	:String = "ギュスターヴの影";


        public static const CARD_LIST:Array =
        [
            // キャラ番号,名前,種類数（手に入れられる枚数）,スタートレベルのオフセット,最初にそのモンスター種が出現するマップの進行度
            [101,_TRANS_MONS101,3,0,1],		//森の小人
            [102,_TRANS_MONS102,3,0,0],		//蝙蝠
            [103,_TRANS_MONS103,3,0,2],		//大蛙
            [104,_TRANS_MONS104,3,0,3],		//鬼火
            [105,_TRANS_MONS105,3,0,3],		//茸兎
            [106,_TRANS_MONS106,3,0,6],		//吊り男
            [107,_TRANS_MONS107,3,0,4],		//食屍鬼
            [108,_TRANS_MONS108,3,0,3],		//人狼
            [109,_TRANS_MONS109,3,0,6],		//黒き哨兵
            [110,_TRANS_MONS110,3,0,4],		//狂狼
            [111,_TRANS_MONS111,3,0,6],		//鋼鉄の男
            [112,_TRANS_MONS112,3,0,5],		//幽霊騎士
            [113,_TRANS_MONS113,3,0,10],	//炎鬼
            [114,_TRANS_MONS114,3,0,10],	//影斬り森の夢魔
            [115,_TRANS_MONS115,3,0,11],	//毒鼠
            [116,_TRANS_MONS116,3,0,11],	//骸骨兵
            [117,_TRANS_MONS117,3,0,11],	//透明な布
            [118,_TRANS_MONS118,3,0,13],	//呪われし剣
            [119,_TRANS_MONS119,3,0,13],	//バフォメット
            [120,_TRANS_MONS120,3,0,14],	//ナイチンゲール
            [121,_TRANS_MONS121,3,0,17],	//双頭犬オルトス
            [122,_TRANS_MONS122,3,0,18],	//吸血鬼
            [123,_TRANS_MONS123,3,0,13],	//白蜘蛛
            [124,_TRANS_MONS124,3,0,14],	//夜鬼
            [125,_TRANS_MONS125,3,0,19],	//妖蛇
            [126,_TRANS_MONS126,3,0,19],	//白の織者
            [127,_TRANS_MONS127,3,0,20],	//機械兵
            [128,_TRANS_MONS128,3,0,22],	//ウボスの爪
            [129,_TRANS_MONS129,3,0,21],	//ルビオナ偵察機
            [130,_TRANS_MONS130,3,0,23],	//妖花
            [131,_TRANS_MONS131,3,0,24],	//白魔
            [132,_TRANS_MONS132,3,0,26],	//ハルピュイア
            [133,_TRANS_MONS133,3,0,25],	//竜人
            [134,_TRANS_MONS134,3,0,26],	//ドラゴンパピー
            [135,_TRANS_MONS135,3,0,27],	//天使
            [136,_TRANS_MONS136,3,0,27],	//餓鬼
            [137,_TRANS_MONS137,3,0,28],	//掟の箱
            [138,_TRANS_MONS138,3,0,29],	//死の歯車
            [139,_TRANS_MONS139,3,0,30],	//イービルアイ
            [140,_TRANS_MONS140,3,0,31],	//母子像
            [141,_TRANS_MONS141,3,0,32],	//虚無
            [142,_TRANS_MONS142,3,0,33],	//聖女の猫
            [143,_TRANS_MONS143,3,0,27],	//夢馬
            [144,_TRANS_MONS144,3,0,27],	//リリス
            [145,_TRANS_MONS145,3,0,27],	//魂の器
//             [1000,_TRANS_MONS1000,10,0],	//コイン
//             [1001,_TRANS_MONS1001,10,0],	//かけら
//             [2001,_TRANS_MONS2001,1,0],	//月光姫レミア
//             [2002,_TRANS_MONS2002,1,0],	//ウボス
//             [2003,_TRANS_MONS2003,1,0],	//飛竜王メリュジーヌ
            [2004,_TRANS_MONS2004,1,9,0],	//クランプス
            [2005,_TRANS_MONS2005,1,9,0],	//丘王
//             [2006,_TRANS_MONS2006,1,0],	//巨大蛙
            [2007,_TRANS_MONS2007,1,9,0],	//アスタロト
//             [2008,_TRANS_MONS2008,1,0],	//ブレンダン
//             [2009,_TRANS_MONS2009,1,0],	//アリス
//             [2010,_TRANS_MONS2010,1,0],	//ベアトリス
//             [2011,_TRANS_MONS2011,1,0],	//炎の聖女
             [2012,_TRANS_MONS2012,1,9,0],	//幼生ウボス（アインストーリー付き）
             [2013,_TRANS_MONS2013,1,9,0],	//幼生ウボス（ベルンハルトストーリー付き）
//             [2014,_TRANS_MONS2014,1,9,0],	//パンプキング
             [2015,_TRANS_MONS2015,1,9,0],	//クランプス2012
//             [2016,_TRANS_MONS2016,1,9,0],	//聖域の凱旋門
             [2017,_TRANS_MONS2017,1,9,0],	//おたま王子Red（ステイシア・ネネムストーリー付き）
             [2018,_TRANS_MONS2018,1,9,0],	//おたま王子Blue（ブレイズ・メリアストーリー付き）
//             [2019,_TRANS_MONS2019,1,9,0],	//陸水母
             [2020,_TRANS_MONS2020,1,9,0],	//クランプス2013
             [2021,_TRANS_MONS2021,1,9,0],	//クランプス2013
             [2022,_TRANS_MONS2022,1,0,0],	//フラム（アコライツストーリー付き）
             [2023,_TRANS_MONS2023,5,0,0],	//陽気な妖精（ストーリー付き）
             [2024,_TRANS_MONS2024,1,9,0],	//クランプス2014
//             [2029,_TRANS_MONS2029,6,0,0],	//影
             [2030,_TRANS_MONS2030,1,2,0],	//ヴィレア
             [2036,_TRANS_MONS2036,1,9,0],	//クランプス2014
             [2045,_TRANS_MONS2045,1,9,0],	//グリュンワルドの影
             [2046,_TRANS_MONS2046,1,9,0],	//タイレルの影
             [2047,_TRANS_MONS2047,1,9,0],	//ヴィルヘルムの影
             [9001,_TRANS_MONS9001,1,0,0],	//リリィ
             [2051,_TRANS_MONS2051,1,9,0],	//クランプス2016
             [2052,_TRANS_MONS2052,4,0,0],	//人気者の妖精（ストーリー付き）
             [2055,_TRANS_MONS2055,1,9,0],	//シェリの影
             [2056,_TRANS_MONS2056,1,9,0],	//フリードリヒの影
             [2057,_TRANS_MONS2057,1,9,0],	//スプラートの影
             [2058,_TRANS_MONS2058,1,9,0],	//リーズの影
             [2059,_TRANS_MONS2059,1,9,0],	//C.C.の影
             [2062,_TRANS_MONS2062,1,9,0],	//ギュスターヴの影


            ];
        /**
         * コンストラクタ
         *
         */
        public function MonsterCardListScene(list:Dictionary)
        {
            super(list);
        }
        protected override function get cardList():Array
        {
            return CARD_LIST;
        }
    }
}


