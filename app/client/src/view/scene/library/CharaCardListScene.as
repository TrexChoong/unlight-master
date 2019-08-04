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

    import view.image.library.*;
    import view.image.quest.*;
    import view.scene.BaseScene;

    import controller.LobbyCtrl;
    import controller.QuestCtrl;
    import view.utils.*


    /**
     * キャラカードデッキ表示クラス
     *
     */
    public class CharaCardListScene extends BaseScene
    {
        public static const LIST_TYPE_UNLIGHT:int = 0;
        public static const LIST_TYPE_REBORN:int  = 1;


        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR1	:String = "エヴァリスト";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR2	:String = "アイザック";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR3	:String = "グリュンワルド";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR4	:String = "アベル";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR5	:String = "レオン";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR6	:String = "クレーニヒ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR7	:String = "ジェッド";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR8	:String = "アーチボルト";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR9	:String = "マックス";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR9N	:String = "マキシマス";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR10	:String = "ブレイズ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR11	:String = "シェリ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR12	:String = "アイン";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR13	:String = "ベルンハルト";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR14	:String = "フリードリヒ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR15	:String = "マルグリッド";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR16	:String = "ドニタ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR17	:String = "スプラート";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR18	:String = "ベリンダ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR19	:String = "ロッソ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR20	:String = "エイダ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR21	:String = "メレン";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR22	:String = "サルガド";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR23	:String = "レッドグレイヴ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR24	:String = "リーズ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR25	:String = "ミリアン";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR26	:String = "ウォーケン";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR27	:String = "フロレンス";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR28	:String = "パルモ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR29	:String = "アスラ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR30	:String = "ブロウニング";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR31	:String = "マルセウス";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR32	:String = "ルート";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR33	:String = "リュカ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR34	:String = "ステイシア";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR35	:String = "ヴォランド";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR36	:String = "C.C.";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR37	:String = "コッブ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR38	:String = "イヴリン";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR39	:String = "ブラウ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR40	:String = "カレンベルク";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR41	:String = "ネネム";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR42	:String = "コンラッド";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR43	:String = "ビアギッテ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR44	:String = "クーン";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR45	:String = "シャーロット";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR46	:String = "タイレル";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR47	:String = "ルディア";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR48	:String = "ヴィルヘルム";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR49	:String = "メリー";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR50	:String = "ギュスターヴ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR51	:String = "ユーリカ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR52	:String = "リンナエウス";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR53	:String = "ナディーン";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR54	:String = "ディノ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR55	:String = "オウラン (茶色)";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR56	:String = "オウラン (白黒)";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR57	:String = "ノイクローム";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR58	:String = "イデリハ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR59	:String = "シラーリー";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR60	:String = "クロヴィス";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR61	:String = "アリステリア";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR62	:String = "ヒューゴ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR63	:String = "アリアーヌ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR64	:String = "グレゴール";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR65	:String = "レタ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR66	:String = "エプシロン";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR67	:String = "ポレット";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR68	:String = "ユハニ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR69	:String = "ノエラ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR70	:String = "ラウル";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR71	:String = "ジェミー";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR72	:String = "セルファース";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR73	:String = "ベロニカ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR74	:String = "リカルド";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR75	:String = "マリネラ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR76	:String = "モーガン";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHAR77	:String = "ジュディス";

        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR1	:String = "Evarist";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR2	:String = "Izac";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR3	:String = "Grunwald";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR4	:String = "Abel";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR5	:String = "Leon";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR6	:String = "Kronig";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR7	:String = "Jead";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR8	:String = "Archibald";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR9	:String = "Max";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR9N	:String = "マキシマス";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR10	:String = "Blaise";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR11	:String = "Sheri";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR12	:String = "Ayn";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR13	:String = "Bernhard";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR14	:String = "Friedrich";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR15	:String = "Marguerite";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR16	:String = "Donita";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR17	:String = "Sprout";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR18	:String = "Belinda";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR19	:String = "Rosso";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR20	:String = "Ada";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR21	:String = "Melen";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR22	:String = "Salgado";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR23	:String = "Redgrave";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR24	:String = "Riesz";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR25	:String = "Milian";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR26	:String = "Walken";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR27	:String = "Florence";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR28	:String = "Palmo";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR29	:String = "Asura";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR30	:String = "Browning";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR31	:String = "Marseus";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR32	:String = "Rood";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR33	:String = "Luka";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR34	:String = "Stacia";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR35	:String = "Voland";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR36	:String = "C.C.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR37	:String = "Cobb";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR38	:String = "Evelyn";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR39	:String = "Blau";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR40	:String = "Karenberg";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR41	:String = "Nenem";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR42	:String = "Konrad";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR43	:String = "Birgit";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR44	:String = "Kuhn";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR45	:String = "Shalott";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR46	:String = "Tyrrell";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR47	:String = "Rudia";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR48	:String = "Wilhelm";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR49	:String = "Mary";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR50	:String = "Gustave";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR51	:String = "Eureka";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR52	:String = "Linnaeus";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR53	:String = "Nadine";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR54	:String = "Dino";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR55	:String = "Orang (Brown)";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR56	:String = "Orang (Black and White)";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR57	:String = "Noichrome";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR58	:String = "Ideriha";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR59	:String = "Schillerlee";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR60	:String = "Clovis";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR61	:String = "Alicetaria";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR62	:String = "Hugo";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR63	:String = "Ariane";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR64	:String = "Gregor";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR65	:String = "Leta";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR66	:String = "Epsilon";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR67	:String = "Paulette";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR68	:String = "Juhani";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR69	:String = "Noella";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR70	:String = "Raul";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR71	:String = "Jamie";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR72	:String = "Servaas";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR73	:String = "Veronica";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR74	:String = "リカルド";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR75	:String = "マリネラ";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR76	:String = "モーガン";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHAR77	:String = "ジュディス";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR1	:String = "艾伯李斯特";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR2	:String = "艾依查庫";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR3	:String = "古魯瓦爾多";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR4	:String = "阿貝爾";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR5	:String = "利恩";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR6	:String = "庫勒尼西";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR7	:String = "傑多";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR8	:String = "阿奇波爾多";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR9	:String = "馬庫斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR9N	:String = "馬庫西瑪斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR10	:String = "布列依斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR11	:String = "雪莉";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR12	:String = "艾茵";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR13	:String = "伯恩哈德";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR14	:String = "弗雷特里西";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR15	:String = "瑪格莉特";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR16	:String = "多妮妲";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR17	:String = "史普拉多";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR18	:String = "貝琳達";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR19	:String = "羅索";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR20	:String = "艾妲";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR21	:String = "梅倫";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR22	:String = "薩爾卡多";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR23	:String = "蕾格烈芙";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR24	:String = "里斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR25	:String = "米利安";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR26	:String = "沃肯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR27	:String = "佛羅倫斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR28	:String = "帕茉";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR29	:String = "阿修羅";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR30	:String = "布朗寧";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR31	:String = "瑪爾瑟斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR32	:String = "路德";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR33	:String = "魯卡";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR34	:String = "史塔夏";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR35	:String = "沃蘭德";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR36	:String = "C.C.";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR37	:String = "柯布";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR38	:String = "伊芙琳";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR39	:String = "布勞";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR40	:String = "凱倫貝克";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR41	:String = "音音夢";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR42	:String = "康拉德";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR43	:String = "碧姬媞";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR44	:String = "庫恩";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR45	:String = "夏洛特";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR46	:String = "泰瑞爾";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR47	:String = "露緹亞";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR48	:String = "威廉";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR49	:String = "梅莉";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR50	:String = "古斯塔夫";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR51	:String = "尤莉卡";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR52	:String = "林奈烏斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR53	:String = "娜汀";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR54	:String = "迪諾";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR55	:String = "奧蘭(褐色)";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR56	:String = "奧蘭(黑白)";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR57	:String = "諾伊庫洛姆";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR58	:String = "出葉";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR59	:String = "希拉莉";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR60	:String = "克洛維斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR61	:String = "艾莉絲泰莉雅";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR62	:String = "雨果";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR63	:String = "艾莉亞娜";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR64	:String = "格雷高爾";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR65	:String = "蕾塔";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR66	:String = "伊普西隆";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR67	:String = "波蕾特";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR68	:String = "尤哈尼";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR69	:String = "諾艾菈";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR70	:String = "勞爾";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR71	:String = "潔米";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR72	:String = "瑟法斯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR73	:String = "維若妮卡";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR74	:String = "里卡多";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR75	:String = "瑪麗妮菈";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR76	:String = "摩根";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHAR77	:String = "茱蒂絲";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR1	:String = "艾伯李斯特";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR2	:String = "艾依查库";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR3	:String = "古鲁瓦尔多";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR4	:String = "阿贝尔";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR5	:String = "利恩";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR6	:String = "库勒尼西";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR7	:String = "杰多";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR8	:String = "阿奇波尔多";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR9	:String = "马库斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR9N	:String = "马库西玛斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR10	:String = "布列依斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR11	:String = "雪莉";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR12	:String = "艾茵";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR13	:String = "伯恩哈德";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR14	:String = "弗雷特里西";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR15	:String = "玛格莉特";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR16	:String = "多妮妲";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR17	:String = "史普拉多";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR18	:String = "贝琳达";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR19	:String = "罗索";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR20	:String = "艾妲";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR21	:String = "梅伦";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR22	:String = "萨尔卡多";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR23	:String = "蕾格烈芙";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR24	:String = "里斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR25	:String = "米利安";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR26	:String = "沃肯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR27	:String = "佛罗伦斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR28	:String = "帕茉";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR29	:String = "阿修罗";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR30	:String = "布朗宁";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR31	:String = "玛尔瑟斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR32	:String = "路德";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR33	:String = "鲁卡";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR34	:String = "史塔夏";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR35	:String = "沃兰德";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR36	:String = "C.C.";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR37	:String = "柯布";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR38	:String = "伊芙琳";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR39	:String = "布劳";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR40	:String = "凯伦贝克";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR41	:String = "音音梦";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR42	:String = "康拉德";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR43	:String = "碧姬媞";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR44	:String = "库恩";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR45	:String = "夏洛特";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR46	:String = "泰瑞尔";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR47	:String = "露缇亚";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR48	:String = "威廉";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR49	:String = "梅莉";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR50	:String = "古斯塔夫";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR51	:String = "尤莉卡";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR52	:String = "林奈乌斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR53	:String = "娜汀";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR54	:String = "迪诺";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR55	:String = "奥兰(褐色)";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR56	:String = "奥兰(黑白)";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR57	:String = "诺伊库洛姆";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR58	:String = "出叶";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR59	:String = "希拉莉";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR60	:String = "克洛维斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR61	:String = "艾莉丝泰莉雅";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR62	:String = "雨果";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR63	:String = "艾莉亚娜";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR64	:String = "格雷高尔";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR65	:String = "蕾塔";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR66	:String = "伊普西隆";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR67	:String = "波蕾特";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR68	:String = "尤哈尼";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR69	:String = "诺艾菈";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR70	:String = "劳尔";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR71	:String = "洁米";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR72	:String = "瑟法斯";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR73	:String = "维若妮卡";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR74	:String = "里卡多";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR75	:String = "玛丽妮菈";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR76	:String = "摩根";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHAR77	:String = "茱蒂丝";

        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR1	:String = "에바리스트";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR2	:String = "아이자크";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR3	:String = "그룬왈드";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR4	:String = "아벨";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR5	:String = "레온";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR6	:String = "크레니히";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR7	:String = "제드";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR8	:String = "아치볼드";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR9	:String = "맥스";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR9N	:String = "マキシマス";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR10	:String = "브레이즈";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR11	:String = "쉐리";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR12	:String = "아인";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR13	:String = "베른하드";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR14	:String = "프리드리히";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR15	:String = "마르그리드";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR16	:String = "도니타";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR17	:String = "스프라우트";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR18	:String = "벨린다";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR19	:String = "로쏘";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR20	:String = "에이다";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR21	:String = "메렌";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR22	:String = "살가드";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR23	:String = "레드그레이브";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR24	:String = "리즈";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR25	:String = "미리안";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR26	:String = "워켄";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR27	:String = "프로렌스";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR28	:String = "파르모";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR29	:String = "아스라";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR30	:String = "브라우닝";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR31	:String = "마르세우스";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR32	:String = "루드";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR33	:String = "루카";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR34	:String = "스테이시아";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR35	:String = "볼랜드";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR36	:String = "C.C.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR37	:String = "コッブ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR38	:String = "イヴリン";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR39	:String = "ブラウ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR40	:String = "カレンベルク";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR41	:String = "ネネム";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR42	:String = "コンラッド";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR43	:String = "ビアギッテ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR44	:String = "クーン";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR45	:String = "シャーロット";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR46	:String = "タイレル";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR47	:String = "ルディア";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR48	:String = "ヴィルヘルム";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR49	:String = "メリー";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR50	:String = "ギュスターヴ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR51	:String = "ユーリカ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR52	:String = "リンナエウス";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR53	:String = "ナディーン";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR54	:String = "ディノ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR55	:String = "オウラン (茶色)";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR56	:String = "オウラン (白黒)";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR57	:String = "ノイクローム";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR58	:String = "イデリハ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR59	:String = "シラーリー";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR60	:String = "クロヴィス";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR61	:String = "アリステリア";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR62	:String = "ヒューゴ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR63	:String = "アリアーヌ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR64	:String = "グレゴール";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR65	:String = "レタ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR66	:String = "エプシロン";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR67	:String = "ポレット";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR68	:String = "ユハニ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR69	:String = "ノエラ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR70	:String = "ラウル";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR71	:String = "ジェミー";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR72	:String = "セルファース";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR73	:String = "ベロニカ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR74	:String = "リカルド";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR75	:String = "マリネラ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR76	:String = "モーガン";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHAR77	:String = "ジュディス";

        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR1	:String = "Evarist";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR2	:String = "Isaac";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR3	:String = "Grunwald";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR4	:String = "Abel";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR5	:String = "Leon";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR6	:String = "Kronig";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR7	:String = "Jead";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR8	:String = "Archibald";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR9	:String = "Max";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR9N	:String = "マキシマス";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR10	:String = "Blaise";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR11	:String = "Sheri";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR12	:String = "Ayn";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR13	:String = "Bernhard";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR14	:String = "Friedrich";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR15	:String = "Marguerite";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR16	:String = "Donita";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR17	:String = "Sprout";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR18	:String = "Belinda";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR19	:String = "Rosso";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR20	:String = "Ada";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR21	:String = "Melen";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR22	:String = "Salgado";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR23	:String = "Redgrave";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR24	:String = "Riesz";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR25	:String = "Milian";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR26	:String = "Walken";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR27	:String = "Florence";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR28	:String = "Palmo";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR29	:String = "Asura";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR30	:String = "Browning";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR31	:String = "Marseus";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR32	:String = "Rood";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR33	:String = "Luka";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR34	:String = "Stacia";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR35	:String = "Vorand";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR36	:String = "C.C.";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR37	:String = "Cobb";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR38	:String = "Evelyn";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR39	:String = "Blau";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR40	:String = "Karenberg";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR41	:String = "Nenem";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR42	:String = "Konrad";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR43	:String = "Birgitte";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR44	:String = "Kuhn";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR45	:String = "Charlotte";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR46	:String = "Tyrrel";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR47	:String = "Rudia";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR48	:String = "Wilhelm";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR49	:String = "Mary";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR50	:String = "Gustave";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR51	:String = "Eureka";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR52	:String = "Linnaeus";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR53	:String = "Nadine";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR54	:String = "Dino";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR55	:String = "Orland (brun)";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR56	:String = "Orland (noir et blanc)";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR57	:String = "Noichrome";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR58	:String = "Ideriha";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR59	:String = "Schillerlee";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR60	:String = "Clovis";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR61	:String = "Astéria";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR62	:String = "Hugo";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR63	:String = "Ariane";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR64	:String = "Gregor";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR65	:String = "Leta";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR66	:String = "Epsilon";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR67	:String = "Paulette";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR68	:String = "Juhani";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR69	:String = "Noëlla";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR70	:String = "Raoul";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR71	:String = "Jamie";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR72	:String = "Servaas";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR73	:String = "Véronica";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR74	:String = "リカルド";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR75	:String = "マリネラ";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR76	:String = "モーガン";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHAR77	:String = "ジュディス";

        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR1	:String = "エヴァリスト";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR2	:String = "アイザック";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR3	:String = "グリュンワルド";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR4	:String = "アベル";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR5	:String = "レオン";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR6	:String = "クレーニヒ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR7	:String = "ジェッド";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR8	:String = "アーチボルト";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR9	:String = "マックス";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR9N	:String = "マキシマス";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR10	:String = "ブレイズ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR11	:String = "シェリ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR12	:String = "アイン";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR13	:String = "ベルンハルト";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR14	:String = "フリードリヒ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR15	:String = "マルグリッド";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR16	:String = "ドニタ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR17	:String = "スプラート";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR18	:String = "ベリンダ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR19	:String = "ロッソ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR20	:String = "エイダ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR21	:String = "メレン";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR22	:String = "サルガド";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR23	:String = "レッドグレイヴ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR24	:String = "リーズ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR25	:String = "ミリアン";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR26	:String = "ウォーケン";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR27	:String = "フロレンス";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR28	:String = "パルモ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR29	:String = "アスラ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR30	:String = "ブロウニング";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR31	:String = "マルセウス";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR32	:String = "ルート";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR33	:String = "リュカ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR34	:String = "ステイシア";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR35	:String = "ヴォランド";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR36	:String = "C.C.";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR37	:String = "コッブ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR38	:String = "イヴリン";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR39	:String = "ブラウ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR40	:String = "カレンベルク";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR41	:String = "ネネム";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR42	:String = "コンラッド";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR43	:String = "ビアギッテ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR44	:String = "クーン";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR45	:String = "シャーロット";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR46	:String = "タイレル";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR47	:String = "ルディア";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR48	:String = "ヴィルヘルム";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR49	:String = "メリー";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR50	:String = "ギュスターヴ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR51	:String = "ユーリカ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR52	:String = "リンナエウス";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR53	:String = "ナディーン";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR54	:String = "ディノ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR55	:String = "オウラン (茶色)";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR56	:String = "オウラン (白黒)";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR57	:String = "ノイクローム";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR58	:String = "イデリハ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR59	:String = "シラーリー";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR60	:String = "クロヴィス";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR61	:String = "アリステリア";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR62	:String = "ヒューゴ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR63	:String = "アリアーヌ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR64	:String = "グレゴール";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR65	:String = "レタ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR66	:String = "エプシロン";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR67	:String = "ポレット";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR68	:String = "ユハニ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR69	:String = "ノエラ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR70	:String = "ラウル";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR71	:String = "ジェミー";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR72	:String = "セルファース";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR73	:String = "ベロニカ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR74	:String = "リカルド";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR75	:String = "マリネラ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR76	:String = "モーガン";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHAR77	:String = "ジュディス";

        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR1   :String = "เอวาริสท์";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR2   :String = "ไอแซค";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR3   :String = "กรุนวัลด์";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR4   :String = "อาเบล";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR5   :String = "เลออน";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR6   :String = "โครนิก";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR7   :String = "เจด";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR8   :String = "อาร์ชิบัลท์";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR9   :String = "แม็กซ์";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR9N	:String = "マキシマス";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR10  :String = "เบลซ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR11  :String = "เชรี";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR12  :String = "ไอน์";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR13  :String = "เบิร์นฮาร์ท";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR14  :String = "ฟรีดริช";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR15  :String = "มาร์กรีต";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR16  :String = "โดนิต้า";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR17  :String = "สเปราท์";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR18  :String = "เบลินดา";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR19  :String = "รอสโซ่";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR20  :String = "เอด้า";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR21  :String = "เมเลน";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR22  :String = "ซัลกาโด";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR23  :String = "เรดเกรฟ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR24  :String = "รีซ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR25  :String = "มิเลียน";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR26  :String = "วอลเคน";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR27  :String = "ฟลอเรนซ์";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR28  :String = "พาลโม";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR29  :String = "อาซูร่า";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR30  :String = "บราวนิ่ง";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR31  :String = "มาร์เซอุส";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR32  :String = "รูท";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR33  :String = "ลูคา";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR34  :String = "สเตเชีย";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR35  :String = "โวรันด์";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR36  :String = "C.C.";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR37  :String = "คอบบ์";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR38  :String = "อีฟลิน";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR39  :String = "บลาว";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR40  :String = "คาเรนเบิร์ก";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR41  :String = "เนเนม";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR42  :String = "คอนราด";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR43  :String = "เบียกิตเต้";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR44  :String = "คูห์น";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR45  :String = "ชาร์ล็อต";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR46  :String = "ไทเรล";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR47  :String = "รูเดีย";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR48  :String = "วิลเฮล์ม";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR49  :String = "เมรี่";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR50	:String = "กุสตาฟ"; // ギュスターヴ
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR51	:String = "";//"ユーリカ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR52	:String = "";//リンナエウス
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR53	:String = "";//ナディーン
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR54	:String = "";//ディノ
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR55	:String = "";//オウラン (茶色)
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR56	:String = "";//オウラン (白黒)
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR57	:String = "";//ノイクローム
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR58	:String = "イデリハ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR59	:String = "シラーリー";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR60	:String = "クロヴィス";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR61	:String = "アリステリア";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR62	:String = "ヒューゴ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR63	:String = "アリアーヌ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR64	:String = "グレゴール";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR65	:String = "レタ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR66	:String = "エプシロン";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR67	:String = "ポレット";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR68	:String = "ユハニ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR69	:String = "ノエラ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR70	:String = "ラウル";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR71	:String = "ジェミー";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR72	:String = "セルファース";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR73	:String = "ベロニカ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR74	:String = "リカルド";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR75	:String = "マリネラ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR76	:String = "モーガン";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHAR77	:String = "ジュディス";

        public static const CARD_LIST:Array =
        [
            [1,_TRANS_CHAR1,11,0],	//エヴァリスト
            [2,_TRANS_CHAR2,10,0],	//アイザック
            [3,_TRANS_CHAR3,10,0],	//グリュンワルド
            [4,_TRANS_CHAR4,10,0],	//アベル
            [5,_TRANS_CHAR5,10,0],	//レオン
            [6,_TRANS_CHAR6,10,0],	//クレーニヒ
            [7,_TRANS_CHAR7,10,0],	//ジェッド
            [8,_TRANS_CHAR8,10,0],	//アーチボルト
            [9,_TRANS_CHAR9,10,0],	//マックス
            [10,_TRANS_CHAR10,10,0],	//ブレイズ
            [11,_TRANS_CHAR11,11,0],	//シェリ
            [12,_TRANS_CHAR12,10,0],	//アイン
            [13,_TRANS_CHAR13,10,0],	//ベルンハルト
            [14,_TRANS_CHAR14,10,0],	//フリードリヒ
            [15,_TRANS_CHAR15,10,0],	//マルグリッド
            [16,_TRANS_CHAR16,10,0],	//ドニタ
            [17,_TRANS_CHAR17,10,0],	//スプラート
            [18,_TRANS_CHAR18,10,0],	//ベリンダ
            [19,_TRANS_CHAR19,10,0],	//ロッソ
            [20,_TRANS_CHAR20,10,0],	//エイダ
            [21,_TRANS_CHAR21,10,0],	//メレン
            [22,_TRANS_CHAR22,10,0],	//サルガド
            [23,_TRANS_CHAR23,9,0],	//レッドグレイヴ
            [24,_TRANS_CHAR24,10,0],	//リーズ
            [25,_TRANS_CHAR25,10,0],	//ミリアン
            [26,_TRANS_CHAR26,10,0],	//ウォーケン
            [27,_TRANS_CHAR27,10,0],	//フロレンス
            [28,_TRANS_CHAR28,10,0],	//パルモ
            [29,_TRANS_CHAR29,10,0],	//アスラ
            [30,_TRANS_CHAR30,9,0],	//ブロウニング
            [31,_TRANS_CHAR31,10,0],	//マルセウス
            [32,_TRANS_CHAR32,9,0],	//ルート
            [33,_TRANS_CHAR33,9,0],	//リュカ
            [34,_TRANS_CHAR34,9,0],	//ステイシア
            [35,_TRANS_CHAR35,9,0],	//ヴォランド
            [36,_TRANS_CHAR36,10,0],	//C.C.
            [37,_TRANS_CHAR37,9,0],	//コッブ
            [38,_TRANS_CHAR38,9,0],	//イヴリン
            [39,_TRANS_CHAR39,9,0],	//ブラウ
            [40,_TRANS_CHAR40,9,0],	//カレンベルク
            [41,_TRANS_CHAR41,9,0],	//ネネム
            [42,_TRANS_CHAR42,8,0],	//コンラッド
            [43,_TRANS_CHAR43,8,0],	//ビアギッテ
            [44,_TRANS_CHAR44,8,0],	//クーン
            [45,_TRANS_CHAR45,9,0],	//シャーロット
            [46,_TRANS_CHAR46,9,0],	//タイレル
            [47,_TRANS_CHAR47,9,0],	//ルディア
            [48,_TRANS_CHAR48,9,0],	//ヴィルヘルム
            [49,_TRANS_CHAR49,8,0],	//メリー
            [50,_TRANS_CHAR50,8,0],	//ギュスターヴ
            [51,_TRANS_CHAR51,8,0],	//ユーリカ
            [52,_TRANS_CHAR52,7,0],	//リンナエウス
            [53,_TRANS_CHAR53,7,0],	//ナディーン
            [54,_TRANS_CHAR54,7,0],	//ディノ
            [55,_TRANS_CHAR55,5,0],	//オウラン(茶色)
            [56,_TRANS_CHAR56,5,0],	//オウラン(白黒)
            [57,_TRANS_CHAR57,7,0],	//ノイクローム
            [58,_TRANS_CHAR58,7,0],	//イデリハ
            [59,_TRANS_CHAR59,7,0],	//シラーリー
            [60,_TRANS_CHAR60,7,0],	//クロヴィス
            [61,_TRANS_CHAR61,7,0],	//アリステリア
            [62,_TRANS_CHAR62,7,0],	//ヒューゴ
            [63,_TRANS_CHAR63,7,0],	//アリアーヌ
            [64,_TRANS_CHAR64,7,0],	//グレゴール
            [65,_TRANS_CHAR65,7,0],	//レタ
            [66,_TRANS_CHAR66,6,0],	//エプシロン
            [67,_TRANS_CHAR67,6,0],	//ポレット
            [68,_TRANS_CHAR68,6,0],	//ユハニ
            [69,_TRANS_CHAR69,6,0],	//ノエラ
            [70,_TRANS_CHAR70,6,0],	//ラウル
            [71,_TRANS_CHAR71,6,0],	//ジェミー
            [72,_TRANS_CHAR72,6,0],	//セルファース
            [73,_TRANS_CHAR73,6,0],	//ベロニカ
            [74,_TRANS_CHAR74,6,0],	//リカルド
            [75,_TRANS_CHAR75,6,0],	//マリネラ
            [76,_TRANS_CHAR76,6,0],	//モーガン
            [77,_TRANS_CHAR77,6,0],	//ジュディス
            ];

        public static const REBORN_CARD_LIST:Array =
            [
                [4001,_TRANS_CHAR1,1,0],	//エヴァリスト
                [4002,_TRANS_CHAR2,1,0],	//アイザック
                [4003,_TRANS_CHAR3,1,0],	//グリュンワルド
                [4004,_TRANS_CHAR4,1,0],	//アベル
                [4005,_TRANS_CHAR5,1,0],	//レオン
                [4006,_TRANS_CHAR6,1,0],	//クレーニヒ
                [4007,_TRANS_CHAR7,1,0],	//ジェッド
                [4008,_TRANS_CHAR8,1,0],	//アーチボルト
                [4009,_TRANS_CHAR9N,1,0],	//マキシマス
                [4010,_TRANS_CHAR10,1,0],	//ブレイズ
                [4011,_TRANS_CHAR11,1,0],	//シェリ
                [4012,_TRANS_CHAR12,1,0],	//アイン
                [4013,_TRANS_CHAR13,1,0],	//ベルンハルト
                [4014,_TRANS_CHAR14,1,0],	//フリードリヒ
                [4015,_TRANS_CHAR15,1,0],	//マルグリット
                [4016,_TRANS_CHAR16,1,0],	//ドニタ
                [4017,_TRANS_CHAR17,1,0],	//スプラート
                [4018,_TRANS_CHAR18,1,0],	//ベリンダ
                [4019,_TRANS_CHAR19,1,0],	//ロッソ
                [4020,_TRANS_CHAR20,1,0],	//エイダ
                [4022,_TRANS_CHAR22,1,0],	//サルガド
                [4024,_TRANS_CHAR24,1,0],	//リーズ
                [4026,_TRANS_CHAR26,1,0],	//ウォーケン
                [4027,_TRANS_CHAR27,1,0],	//フロレンス
                [4028,_TRANS_CHAR28,1,0],	//パルモ
                ];

        public static const ALL_CARD_LIST:Array = [CARD_LIST,REBORN_CARD_LIST];

        private static const X:int = 20;                      // カードのX基本位置
        private static const Y:int = 132;                       // カードのY基本位置
        private static const _NAME_OFFSET_X:int = 24;                // カードのXズレ

        private static const PAGE_NUM:int =20;
        private var _name:Label = new Label();

        protected var _container:UIComponent = new UIComponent();
        private var _pageSet:Array = [];
        private var _page:int =0;
        private var _cardListImageSet:Vector.<CardListImage> = new Vector.<CardListImage>();

        private var _listType:int = LIST_TYPE_UNLIGHT;
        private static var _images:Object={};

        /**
         * コンストラクタ
         *
         */
        public function CharaCardListScene(list:Dictionary,type:int = LIST_TYPE_UNLIGHT)
        {
            x  = X;
            y  = Y;
            width = 200;
            height = 300;
            _listType = type;
            var listCounter:int = 0;
            for(var i:int = 0; i < cardList.length; i++)
            {
                var pn:int = int(i/PAGE_NUM);
                if (_pageSet[pn] == null)
                {
                    _pageSet[pn] = new UIComponent();
                }
//                  log.writeLog(log.LV_INFO, this, "pagenum",pn,cardList[i][0].toString());
//                  log.writeLog(log.LV_INFO, this, "pagenum",list[cardList[i][0].toString()]);
                if (type == LIST_TYPE_UNLIGHT) {
                    var ci:CardListImage = new CardListImage(cardList[i],list[cardList[i][0].toString()],clickMarkAction);
                    ci.x = 0;
                    ci.y = i%PAGE_NUM*_NAME_OFFSET_X;

                    _pageSet[pn].addChild(ci);

                    _cardListImageSet.push(ci);
                } else {
                    var rci:CardListImage = new RebornCardListImage(cardList[i],list[cardList[i][0].toString()],clickMarkAction);
                    rci.x = 0;
                    rci.y = i%PAGE_NUM*_NAME_OFFSET_X;

                    _pageSet[pn].addChild(rci);

                    _cardListImageSet.push(rci);
                }
            }

            LobbyCtrl.instance.addEventListener(LobbyCtrl.CHANGE_FAVORITE_CHARA,changeFavoriteHandler);
            setPage(0);
        }
        protected function get cardList():Array
        {
            return (_listType == LIST_TYPE_UNLIGHT) ? CARD_LIST.slice(0, Const.CARD_LENGTH) : REBORN_CARD_LIST.slice(0, Const.REBORN_CARD_LENGTH);
        }

        public function setPage(p:int):void
        {
            log.writeLog(log.LV_INFO, this, "setpage",p, _pageSet, pageNum);
            if (p>-1 && p < pageNum)
            {
//                log.writeLog(log.LV_INFO, this, "setpage ok");
                for(var i:int = 0; i < _pageSet.length; i++){
                    if (i == p)
                    {
//                        log.writeLog(log.LV_INFO, this, "i",i,_pageSet[i]);
                        addChild(_pageSet[i]);
                        _page = p;
                    }else{
//                        log.writeLog(log.LV_INFO, this, "i",i,_pageSet[i]);
                        RemoveChild.apply(_pageSet[i]);
                    }
                }
            }
            log.writeLog(log.LV_INFO, this, "end setpage");
        }

        override public function final():void
        {
            log.writeLog(log.LV_INFO, this, "start, final");
            LobbyCtrl.instance.removeEventListener(LobbyCtrl.CHANGE_FAVORITE_CHARA,changeFavoriteHandler);

            _cardListImageSet.forEach(function(item:CardListImage, index:int, array:Vector.<CardListImage>):void{item.final()})

            for(var i:int = 0; i < _pageSet.length; i++)
            {
                RemoveChild.all(_pageSet[i]);
                RemoveChild.apply(_pageSet[i]);
            }
            log.writeLog(log.LV_INFO, this, "start, end");

        }
        public function get pageNum():int
        {
            return  _pageSet.length;
        }

        public function get page():int
        {
            return  _page;
        }

        public function clickMarkAction(ccid:int):void
        {
            dispatchEvent(new EditCardEvent(EditCardEvent.SELECT_CARD, null, ccid));
        }

        private function changeFavoriteHandler(e:Event):void
        {
            var charaId:int = Player.instance.avatar.favoriteCharaId;
            _cardListImageSet.forEach(function(item:CardListImage, index:int, array:Vector.<CardListImage>):void{item.resetFavorite(charaId)})
        }

        public static function registImage():void
        {

        }

    }
}

import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.filters.GlowFilter;
import flash.geom.*;

import mx.core.UIComponent;
import mx.controls.*;

import model.*;
import view.image.game.CharaCardStar;
import view.utils.*
import view.scene.BaseScene;
import view.image.library.*;

import controller.LobbyCtrl;

class CardListImage extends BaseScene
{
    protected static const W:int =28;
    protected static const H:int =43;
    protected static const STAR_X:int =9;
    protected static const STAR_Y:int =16;
//     private var _stateImage:AchievementCrownImage = new AchievementCrownImage();
     protected var _ct:ColorTransform = new ColorTransform(0.3,0.3,0.3);// トーンを半分に
     protected var _ct2:ColorTransform = new ColorTransform(1.0,1.0,1.0);// トーン元にに


//     private var _shape:Shape = new Shape;
//     private var _star:CharaCardStar = CharaCardStar.instance;
//     private var _starBitmap:Bitmap;

    protected var _container:UIComponent;
    protected var _name:Label = new Label();

    protected static const _NAME_X:int = 35;
    protected static const _NAME_Y:int = 1;           // 名称のY
    protected static const _NAME_H:int = 20;           // カードの初期位置Y
    protected static const _NAME_W:int = 200;           // カードの初期位置Y

    protected static const _MARK_NUM:int = 10;

    protected static const _MARK_X:int = 194;
    protected static const _MARK_Y:int = 3;
    protected static const _MARK_OFFSET_X:int = 16;
    protected static const _MARK_OFFSET_X2:int = 16;
    protected static const _MARK_OFFSET_X3:int = 32;

    protected static const _FAVORITE_X:int = 492;
    protected static const _FAVORITE_Y:int = 2;

    protected static const _RESULT_SELECT_BUTTON_BASE_X:int = 172;
    protected static const _RESULT_SELECT_BUTTON_BASE_Y:int = 3;

    protected var _clickFunc:Function;
    protected var _markSet:Vector.<GotCardMark> = new Vector.<GotCardMark>; /* of GorCardMark */
    protected var _ccSet:Array = []; /* of ElementType */
    protected var _charaId:int = 1;
    protected var _favorite:FavoriteMark = new FavoriteMark();
    protected var _resultSelectButton:ResultSelectButton = new ResultSelectButton();
    public function CardListImage(info:Array,card:Array,clickFunc:Function,setMark:Boolean=true)
    {
        _name.x = _NAME_X;
        _name.y = _NAME_Y;
        _name.width = _NAME_W;
        _name.height = _NAME_H;
        _name.setStyle('textAlign', 'left');
        if(info[4]!=null && Player.instance.avatar.questFlag < info[4])
        {
            _name.htmlText = "----------";
        }else{
            _name.htmlText = info[1];
        }
        _name.styleName = "CharaCardName";
        _name.filters = [
                new GlowFilter(0x111111, 1, 2, 2, 16, 1),
                ];
        log.writeLog(log.LV_INFO, this, "create",info);
        addChild(_name);
        _clickFunc = clickFunc;

        _favorite.x = _FAVORITE_X;
        _favorite.y = _FAVORITE_Y;
        _favorite.clickFunc = favoriteClickFunc;
        _favorite.visible = false;
        addChild(_favorite);

        if (setMark) {
            createMark(info[2],info[3]);
            if(card != null)
            {
                log.writeLog(log.LV_INFO, this, "create1",card);
                updateMark(card,info[3]);

                _charaId = card[0].charactor;


                if (card[0].kind == Const.CC_KIND_CHARA || card[0].kind == Const.CC_KIND_REBORN_CHARA) {
                    _favorite.visible = true;
                } else {
                    _favorite.visible = false;
                }
            } else {
                _favorite.visible = false;
            }

            if (Player.instance.avatar.favoriteCharaId == _charaId) {
                _favorite.buttonVisible = false;
            } else {
                _favorite.buttonVisible = true;
            }
        }

        _resultSelectButton.clickFunc = resultSerectClickFunc;
        if (card && AvatarItemInventory.resultImages.hasOwnProperty(card[0].charactor))
        {
            _resultSelectButton.x = _RESULT_SELECT_BUTTON_BASE_X;
            _resultSelectButton.y = _RESULT_SELECT_BUTTON_BASE_Y;
            var list:Object =  AvatarItemInventory.resultImages;
            _resultSelectButton.setButtonState(list[_charaId]);
            addChild(_resultSelectButton);
        }
    }

    // このキャラクターの特殊リザルトが選択可能かどうか
    // 該当する変更チケットを持っていればtrueを返す
    private function canSelectResultImages():Boolean
    {

//        var images:Object = AvatarItemInventory.resultImages(); ?

        _charaId;

        return false;
    }

    protected function createMark(num:int,offset:int):void
    {
        // 枠は
        for(var i:int = offset; i < num+offset; i++){
            var mark:GotCardMark = new GotCardMark();
            _markSet.push(mark);
            mark.x = _MARK_X+_MARK_OFFSET_X*i;
            if(i < 5)
            {
                mark.x = _MARK_X+_MARK_OFFSET_X*i;
            }else if (i < 10) {
                mark.x = _MARK_X+_MARK_OFFSET_X*i+_MARK_OFFSET_X2;
            }else {
                mark.x = _MARK_X+_MARK_OFFSET_X*i+_MARK_OFFSET_X3;
            }
            mark.y = _MARK_Y;
            mark.mouseEnabled = false;
            mark.mouseChildren = false;
            mark.transform.colorTransform = _ct;
            mark.addEventListener(MouseEvent.CLICK, mouseClickHandler)
            addChild(mark);
        }
    }

    public function updateMark(cards:Array, offset:int):void
    {
        cards.forEach(function(item:CharaCard, index:int, array:Array):void{
                var episodeIndex:int = item.level-1+10-offset;
                var rareIndex:int = item.level-1+5-offset;
                var normalIndex:int = item.level-1-offset;
                if (item != null && item.kind == Const.CC_KIND_EPISODE && _markSet.length > episodeIndex&&_markSet[episodeIndex]!=null)
                {
                    _markSet[episodeIndex].mouseEnabled = true;
                    _markSet[episodeIndex].mouseChildren = true;
                    _markSet[episodeIndex].transform.colorTransform = _ct2;
                    _ccSet[episodeIndex] = item.id;
                }
                else if (item!=null && item.kind!=Const.CC_KIND_MONSTAR && item.isRare()&&_markSet.length > rareIndex&&_markSet[rareIndex]!=null)
                {
                    _markSet[rareIndex].mouseEnabled = true;
                    _markSet[rareIndex].mouseChildren = true;
                    _markSet[rareIndex].transform.colorTransform = _ct2;
                    _ccSet[rareIndex] = item.id;
                }else if (item!=null&&_markSet.length > normalIndex && normalIndex >= 0 &&_markSet[normalIndex]!=null)
                {
                    _markSet[normalIndex].mouseEnabled = true;
                    _markSet[normalIndex].mouseChildren = true;
                    _markSet[normalIndex].transform.colorTransform = _ct2;
                    _ccSet[normalIndex] = item.id;
                }
                    log.writeLog(log.LV_INFO, this, "updateMArck","end!!!!!!!!!!");
            });
    }
    protected function mouseClickHandler(e:MouseEvent):void
    {
        log.writeLog(log.LV_INFO, this, "CLICK!!!", _ccSet[_markSet.indexOf(e.currentTarget)]);
        _clickFunc.apply(this,[_ccSet[_markSet.indexOf(e.currentTarget)]]);
    }
    protected function favoriteClickFunc():void
    {
        log.writeLog(log.LV_DEBUG, this, "FAVORITE CLICK!!!", _charaId);
        LobbyCtrl.instance.changeFavoriteCharaId(_charaId);
    }

    protected function resultSerectClickFunc():void
    {
        log.writeLog(log.LV_DEBUG, this, "RESULT CLICK!!!", _charaId);
        var nextImageNo:int = _resultSelectButton.setNextImage();
        AvatarItemInventory.changeResultImage(_charaId, nextImageNo);
        LobbyCtrl.instance.changeResultImage(_charaId, nextImageNo);
    }

    public function resetFavorite(charaId:int):void
    {
        log.writeLog(log.LV_DEBUG, this, "reset favorite",_charaId,charaId);
        if (_ccSet.length <= 0) {
            _favorite.visible = false;
        } else if (charaId == _charaId) {
            _favorite.buttonVisible = false;
        } else {
            _favorite.buttonVisible = true;
        }
    }

    public function clearType():void
    {
//         _shape.graphics.clear();
//         _shape.graphics.lineStyle(1, 0x666666);
//         _shape.graphics.beginFill(0xFFFFFF, 0.0);
//         _shape.graphics.drawRect(0,0,W,H);
    }

    public override function final():void
    {
        for(var i:int = 0; i < _markSet.length; i++)
        {
            var x:Object = _markSet[i];
            x.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
        }
        _clickFunc = null;
    }

}

// 復活キャラカードリストイメージ
class RebornCardListImage extends CardListImage
{
    private static const _MARK_OFFSET_X3:int = 16;

    public function RebornCardListImage(info:Array,card:Array,clickFunc:Function)
    {
        super(info,card,clickFunc,false);
        createMark(info[2],info[3]);
        if(card != null)
        {
            log.writeLog(log.LV_INFO, this, "create1",card);
            updateMark(card,info[3]);
            _charaId = card[0].charactor;

            if (card[0].kind == Const.CC_KIND_CHARA || card[0].kind == Const.CC_KIND_MONSTAR || card[0].kind == Const.CC_KIND_REBORN_CHARA) {
                _favorite.visible = true;
            } else {
                _favorite.visible = false;
            }

            if (Player.instance.avatar.favoriteCharaId == _charaId) {
                _favorite.buttonVisible = false;
            } else {
                _favorite.buttonVisible = true;
            }
        }
    }

    protected override function createMark(num:int,offset:int):void
    {
        // 枠は
        for(var i:int = offset; i < num+offset; i++){
            var mark:GotCardMark = new GotCardMark();
            _markSet.push(mark);
            mark.x = _MARK_X+_MARK_OFFSET_X*i;
            if(i < 1)
            {
                mark.x = _MARK_X+_MARK_OFFSET_X*i;
            }else if(i > 0&&i<4){
                mark.x = _MARK_X+_MARK_OFFSET_X*i+_MARK_OFFSET_X2;
            }else{
                mark.x = _MARK_X+_MARK_OFFSET_X*i+_MARK_OFFSET_X2+_MARK_OFFSET_X3;
            }
            mark.y = _MARK_Y;
            mark.mouseEnabled = false;
            mark.mouseChildren = false;
            mark.transform.colorTransform = _ct;
            mark.addEventListener(MouseEvent.CLICK, mouseClickHandler)
            addChild(mark);
        }
    }

    public override function updateMark(cards:Array, offset:int):void
    {
        cards.forEach(function(item:CharaCard, index:int, array:Array):void{
                var typeIndex:int = item.level-1-offset;
                // log.writeLog(log.LV_INFO, this, "updateMArck",item.id,item.level,offset,typeIndex);
                if(item!=null && _markSet.length > typeIndex&&_markSet[typeIndex]!=null)
                {
                    _markSet[typeIndex].mouseEnabled = true;
                    _markSet[typeIndex].mouseChildren = true;
                    _markSet[typeIndex].transform.colorTransform = _ct2;
                    _ccSet[typeIndex] = item.id;
                }
                // log.writeLog(log.LV_INFO, this, "updateMArck","end!!!!!!!!!!");
            });
    }

}


