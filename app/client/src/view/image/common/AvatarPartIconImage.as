package view.image.common
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;

    import view.image.BaseLoadImage;

    /**
     * AvatarItemImage表示クラス
     *
     */


    public class AvatarPartIconImage extends BaseLoadImage
    {
        private static const URL:String = "/public/image/avatar_parts/icon/";
        private var _frame:int;
        private static const URLSet:Object = {
            0:"",		
            1:"icon_skin_a000a.swf",		// 1 ボディ（ノーマル）
            2:"icon_skin_a000b.swf",		// 2 ボディ（ダーク）
            3:"icon_skin_a000c.swf",		// 3 ボディ（ブライト）
            4:"icon_eye_a000a.swf",		// 4 赤1
            5:"icon_eye_a000b.swf",		// 5 黄1
            6:"icon_eye_a000c.swf",		// 6 緑1
            7:"icon_eye_a000d.swf",		// 7 青1
            8:"icon_eye_a000e.swf",		// 8 紫1
            9:"icon_eye_a001a.swf",		// 9 じと目赤
            10:"icon_eye_a001b.swf",		// 10 じと目黄
            11:"icon_eye_a001c.swf",		// 11 じと目緑
            12:"icon_eye_a001d.swf",		// 12 じと目青
            13:"icon_eye_a001e.swf",		// 13 じと目紫
            14:"icon_eye_a002a.swf",		// 14 赤2
            15:"icon_eye_a002b.swf",		// 15 黄2
            16:"icon_eye_a002c.swf",		// 16 緑2
            17:"icon_eye_a002d.swf",		// 17 青2
            18:"icon_eye_a002e.swf",		// 18 紫2
            19:"icon_eye_a002e.swf",		// 19 赤3
            20:"icon_eye_a002e.swf",		// 20 黄3
            21:"icon_eye_a002e.swf",		// 21 緑3
            22:"icon_eye_a002e.swf",		// 22 青3
            23:"icon_eye_a002e.swf",		// 23 紫3
            24:"icon_mouth_a000a.swf",		// 24 口0
            25:"icon_mouth_a001a.swf",		// 25 口1
            26:"icon_mouth_b000a.swf",		// 26 口2
            27:"icon_hair_a000a.swf",		// 27 ショート（金）
            28:"icon_hair_a000b.swf",		// 28 ショート（茶）
            29:"icon_hair_a000c.swf",		// 29 ショート（青）
            30:"icon_hair_a000b.swf",		// 30 ショート（赤）_old
            31:"icon_hair_a000c.swf",		// 31 ショート（黒）_old
            32:"icon_hair_b000a.swf",		// 32 ベリーショート（金）
            33:"icon_hair_b000b.swf",		// 33 ベリーショート（茶）
            34:"icon_hair_b000c.swf",		// 34 ベリーショート（青）
            35:"icon_hair_b000c.swf",		// 35 ベリーショート（赤）_old
            36:"icon_hair_b000c.swf",		// 36 ベリーショート（黒）_old
            37:"icon_hair_d000a.swf",		// 37 ロングカール（金）
            38:"icon_hair_d000b.swf",		// 38 ロングカール（茶）
            39:"icon_hair_d000c.swf",		// 39 ロングカール（青）
            40:"icon_hair_d000c.swf",		// 40 ロングカール（赤）_old
            41:"icon_hair_d000c.swf",		// 41 ロングカール（黒）_old
            42:"icon_blouse_a000a.swf",		// 42 人形のブラウス
            43:"icon_skirt_a000a.swf",		// 43 人形のスカート
            44:"icon_shoes_a000a.swf",		// 44 人形の靴
            45:"icon_dress_a004a.swf",		// 45 アメジスト・ドレス
            46:"icon_dress_a004b.swf",		// 46 ブルー・ドレス
            47:"icon_dress_a004c.swf",		// 47 ルビー・ドレス
            48:"icon_ribbon_a000a.swf",		// 48 ヘアリボン
            49:"icon_hairpin_a000a.swf",	// 49 銀星のヘアピン
            50:"icon_hairpin_a000b.swf",	// 50 金星のヘアピン
            51:"icon_dress_a005a.swf",		// 51 サマー・ホワイト
            52:"icon_dress_a005b.swf",		// 52 サマー・ブラック
            53:"icon_ribbon_a001a.swf",		// 53 マリン・リボン
            54:"icon_ribbon_a001b.swf",		// 54 オブシディアン・リボン
            55:"icon_shoes_c000a.swf",		// 55 マリン・サンダル
            56:"icon_shoes_c000b.swf",		// 56 オブシディアン・サンダル
            57:"icon_tiara_m000a.swf",		// 57 神秘のティアラ I
            58:"icon_tiara_m000b.swf",		// 58 神秘のティアラ II
            59:"icon_tiara_m000c.swf",		// 59 神秘のティアラ III
            60:"icon_fairy_m000a.swf",		// 60 使い魔のフェアリー I
            61:"icon_fairy_m000b.swf",		// 61 使い魔のフェアリー II
            62:"icon_fairy_m000c.swf",		// 62 使い魔のフェアリー III
            63:"icon_earring_m000a.swf",	// 63 魔女のイヤリング I
            64:"icon_earring_m000b.swf",	// 64 魔女のイヤリング II
            65:"icon_earring_m000c.swf",	// 65 魔女のイヤリング III
            66:"icon_wand_m000a.swf",		// 66 幸運のワンド I
            67:"icon_wand_m000b.swf",		// 67 幸運のワンド II
            68:"icon_wand_m000c.swf",		// 68 幸運のワンド III
            69:"icon_blouse_a000b.swf",		// 69 人形のブラウス（黒）
            70:"icon_skirt_a000b.swf",		// 70 人形のスカート（青）
            71:"icon_skirt_a000c.swf",		// 71 人形のスカート（黒）
            72:"icon_hair_b001b.swf",		// 72 マッシュ（茶）
            73:"icon_hair_b001d.swf",		// 73 マッシュ（白）
            74:"icon_hair_b001e.swf",		// 74 マッシュ（緑）
            75:"icon_hair_c000a.swf",		// 75 ツインテールドリル（金）
            76:"icon_hair_c000b.swf",		// 76 ツインテールドリル（茶）
            77:"icon_hair_c000d.swf",		// 77 ツインテールドリル（白）
            78:"icon_eyepatch_m000a.swf",	// 78 アイパッチ（黒）
            79:"icon_eyepatch_m000b.swf",	// 79 アイパッチ（白）
            80:"icon_tiara_a000a.swf",		// 80 月桂樹の冠（銅）
            81:"icon_tiara_a000b.swf",		// 81 月桂樹の冠（銀）
            82:"icon_tiara_a000c.swf",		// 82 月桂樹の冠（金）
            83:"icon_eyemask_a000a.swf",	// 83 アイマスク（黒）
            84:"icon_eyemask_a000b.swf",	// 84 アイマスク（赤）
            85:"icon_eyemask_a000c.swf",	// 85 アイマスク（青）
            86:"icon_dress_a006a.swf",		// 86 見習い魔女の服
            87:"icon_dress_a007a.swf",		// 87 影世界の服
            88:"icon_dress_b001a.swf",		// 88 月世界の服
            89:"icon_hair_d001a.swf",		// 89 ワンレンロング（金）
            90:"icon_hair_d001d.swf",		// 90 ワンレンロング（白）
            91:"icon_hair_d001h.swf",		// 91 ワンレンロング（黒）
            92:"icon_eyewear_m000a.swf",	// 92 眼鏡（青）
            93:"icon_eyewear_m000b.swf",	// 93 眼鏡（赤）
            94:"icon_dress_a008a.swf",		// 94 アニバーサリードレス
            95:"icon_ribbon_a002a.swf",		// 95 アニバーサリーリボン
            96:"icon_shoes_a001a.swf",		// 96 アニバーサリーシューズ
            97:"icon_swim_t_a000a.swf",		// 97 漆の水着（上）
            98:"icon_swim_u_a000a.swf",		// 98 漆の水着（下）
            99:"icon_fairy_a000a.swf",		// 99 アニバーサリーエンジェル
            100:"icon_hair_x000a.swf",		// 100 ハロウィンパンプキン
            101:"icon_hat_x000a.swf",		// 101 ハロウィンハット
            102:"icon_mant_x000a.swf",		// 102 ハロウィンマント
            103:"icon_hair_a001a.swf",		// 103 カジュアルショート（金）
            104:"icon_hair_a001c.swf",		// 104 カジュアルショート（青）
            105:"icon_hair_a001g.swf",		// 105 カジュアルショート（赤）
            106:"icon_hair_x001a.swf",		// 106 赤ずきん
            107:"icon_eye_x000a.swf",		// 107 ぐるぐる
            108:"icon_mouth_x000a.swf",		// 108 あわわ
            109:"icon_other_x000a.swf",		// 109 パラサイトキノコ
            110:"icon_basket_x000a.swf",	// 110 バスケット
            111:"icon_hat_x001a.swf",		// 111 サンタキャップ
            112:"icon_shoes_x000a.swf",		// 112 サンタブーツ
            113:"icon_dress_x000a.swf",		// 113 サンタウェア
            114:"icon_basket_x001a.swf",	// 114 サンタ袋
            115:"icon_hair_b002c.swf",		// 115 ノーブルロング（青）
            116:"icon_hair_b002d.swf",		// 116 ノーブルロング（桃）
            117:"icon_hair_b002h.swf",		// 117 ノーブルロング（黒）
            118:"icon_hair_b003a.swf",		// 118 ロング（金）
            119:"icon_hair_b003g.swf",		// 119 ロング（赤）
            120:"icon_hair_b003i.swf",		// 120 ロング（茶）
            121:"icon_dress_a009a.swf",		// 121 ニューイヤードレス（赤）
            122:"icon_dress_a009b.swf",		// 122 ニューイヤードレス（緑）
            123:"icon_dress_a009c.swf",		// 123 ニューイヤードレス（紫）
            124:"icon_shoes_b000a.swf",		// 124 ニューイヤーシューズ
            125:"icon_tiara_a000d.swf",		// 125 月桂樹の冠（白金）
            126:"icon_shoes_z011a.swf",		// 126 シェリのブーツ
            127:"icon_hat_z011a.swf",		// 127 シェリのヘッドドレス
            128:"icon_dress_z011a.swf",		// 128 シェリのドレス
            129:"icon_shoes_z012a.swf",		// 129 アインのブーツ
            130:"icon_skirt_z012a.swf",		// 130 アインのスカート
            131:"icon_blouse_z012a.swf",	// 131 アインの上着
            132:"icon_shoes_z015a.swf",		// 132 マルグリッドの靴
            133:"icon_skirt_z015a.swf",		// 133 マルグリッドのパンツ
            134:"icon_blouse_z015a.swf",	// 134 マルグリッドの上着
            135:"icon_shoes_z016a.swf",		// 135 ドニタのブーツ
            136:"icon_hat_z016a.swf",		// 136 ドニタのヘッドドレス
            137:"icon_dress_z016a.swf",		// 137 ドニタのドレス
            138:"icon_dress_b002a.swf",		// 138 風世界の服
            139:"icon_shoes_z001a.swf",		// 139 エヴァリストのブーツ
            140:"icon_skirt_z001a.swf",		// 140 エヴァリストのパンツ
            141:"icon_blouse_z001a.swf",	// 141 エヴァリストの上着
            142:"icon_shoes_z003a.swf",		// 142 グリュンワルドのブーツ
            143:"icon_skirt_z003a.swf",		// 143 グリュンワルドのパンツ
            144:"icon_blouse_z003a.swf",	// 144 グリュンワルドの上着
            145:"icon_shoes_z004a.swf",		// 145 アベルのブーツ
            146:"icon_blouse_z004a.swf",	// 146 さらし
            147:"icon_skirt_z004a.swf",		// 147 アベルのトラウザー
            148:"icon_mask_z009a.swf",		// 148 マックスの仮面
            149:"icon_mask_z022a.swf",		// 149 サルガドの仮面
            150:"icon_hat_z021a.swf",		// 150 メレンのシルクハット
            151:"icon_fairy_z006a.swf",		// 151 深淵くん
            152:"icon_blouse_z014a.swf",	// 152 フリードリヒの上着
            153:"icon_skirt_z014a.swf",		// 153 フリードリヒのパンツ
            154:"icon_shoes_z014a.swf",		// 154 フリードリヒのロングブーツ
            155:"icon_fairy_z011a.swf",		// 155 ロブ
            156:"icon_skirt_z011a.swf",		// 156 シェリのドロワーズ
            157:"icon_dress_z011b.swf",		// 157 シェリのキャミソール
            158:"icon_ring_m000a.swf",		// 158 秘術の指輪
            159:"icon_tiara_x000a.swf",		// 159 丘王の冠
            160:"icon_tiara_x000b.swf",		// 160 丘王の冠
            161:"icon_tiara_x000c.swf",		// 161 丘王の冠
            162:"icon_shoes_z023a.swf",		// 162 レッドグレイヴのブーツ
            163:"icon_dress_z023a.swf",		// 163 レッドグレイヴのドレス
            164:"icon_hair_z023a.swf",		// 164 レッドグレイヴの髪型
            165:"icon_shoes_z019a.swf",		// 165 ロッソのブーツ
            166:"icon_skirt_z019a.swf",		// 166 ロッソのパンツ
            167:"icon_blouse_z019a.swf",	// 167 ロッソのコート
            168:"icon_eyewear_z019a.swf",	// 168 ロッソの眼鏡
            169:"icon_dress_x001a.swf",		// 169 レインコート（黄）
            170:"icon_shoes_x001a.swf",		// 170 長靴（黄）
            171:"icon_shoes_z300a.swf",		// 171 アコライトの靴（紫）
            172:"icon_skirt_z300a.swf",		// 172 アコライトのパンツ（紫）
            173:"icon_blouse_z300a.swf",	// 173 アコライトの服（紫）
            174:"icon_shoes_z032a.swf",		// 174 アコライトの靴（赤）
            175:"icon_skirt_z032a.swf",		// 175 アコライトのパンツ（赤）
            176:"icon_blouse_z032a.swf",	// 176 アコライトの服（赤）
            177:"icon_hat_x002a.swf",		// 177 麦わら帽子
            178:"icon_shoes_x002a.swf",		// 178 ビーチサンダル
            179:"icon_swim_o_a000a.swf",	// 179 ワンピ水着
            180:"icon_mask_x000a.swf",		// 180 ホッケーマスク
            181:"icon_hat_x003a.swf",		// 181 看護帽
            182:"icon_dress_x002a.swf",		// 182 看護服
            183:"icon_ring_m001a.swf",		// 183 緋色の指輪
            184:"icon_eye_x001a.swf",		// 184 うるうる
            185:"icon_mouth_x001a.swf",		// 185 ぽかーん
            186:"icon_ribbon_x000a.swf",	// 186 小悪魔の角
            187:"icon_blouse_x000a.swf",	// 187 パンプキンチュニック
            188:"icon_shoes_x003a.swf",		// 188 パンプキンブーツ
            189:"icon_mask_z005a.swf",		// 189 レオンのバンダナ
            190:"icon_hat_z008a.swf",		// 190 アーチボルトの帽子
            191:"icon_eyewear_z001a.swf",	// 191 エヴァリストの眼鏡
            192:"icon_shoes_z013a.swf",		// 192 ベルンハルトのブーツ
            193:"icon_skirt_z013a.swf",		// 193 ベルンハルトのパンツ
            194:"icon_blouse_z013a.swf",	// 194 ベルンハルトの上着
            195:"icon_shoes_z024a.swf",		// 195 リーズのブーツ
            196:"icon_skirt_z024a.swf",		// 196 リーズのトラウザー
            197:"icon_blouse_z024a.swf",	// 197 リーズの上着
            198:"icon_hat_m000a.swf",		// 198 ミニハット黒
            199:"icon_hat_m000b.swf",		// 199 ミニハット白
            200:"icon_mask_x001a.swf",		// 200 サンタの髭
            201:"icon_hat_x004a.swf",		// 201 牡丹の髪飾り（赤）
            202:"icon_hat_x004b.swf",		// 202 牡丹の髪飾り（青）
            203:"icon_hat_x004c.swf",		// 203 牡丹の髪飾り（白）
            204:"icon_dress_x003a.swf",		// 204 ロングシルクドレス（赤）
            205:"icon_dress_x003b.swf",		// 205 ロングシルクドレス（青）
            206:"icon_dress_x003c.swf",		// 206 ロングシルクドレス（黒）
            207:"icon_shoes_x004a.swf",		// 207 シルクパンプス（赤）
            208:"icon_shoes_x004b.swf",		// 208 シルクパンプス（青）
            209:"icon_shoes_x004c.swf",		// 209 シルクパンプス（黒）
            210:"icon_dress_a010a.swf",		// 210 シルクドレス（赤）
            211:"icon_dress_a010b.swf",		// 211 シルクドレス（青）
            212:"icon_dress_a010c.swf",		// 212 シルクドレス（黒）
            213:"icon_blouse_a001a.swf",	// 213 ベーシックセーラー（青）
            214:"icon_blouse_a001b.swf",	// 214 ベーシックセーラー（緑）
            215:"icon_skirt_a001a.swf",		// 215 ベーシックパンツ（青）
            216:"icon_skirt_a001b.swf",		// 216 ベーシックパンツ（緑）
            217:"icon_shoes_z002a.swf",		// 217 アイザックのブーツ
            218:"icon_skirt_z002a.swf",		// 218 アイザックのトラウザー
            219:"icon_blouse_z002a.swf",	// 219 アイザックの上着
            220:"icon_shoes_z007a.swf",		// 220 ジェッドのサンダル
            221:"icon_skirt_z007a.swf",		// 221 ジェッドのハーフパンツ
            222:"icon_blouse_z007a.swf",	// 222 ジェッドの上着
            223:"icon_shoes_z022a.swf",		// 223 サルガドのブーツ
            224:"icon_skirt_z022a.swf",		// 224 サルガドのパンツ
            225:"icon_blouse_z022a.swf",	// 225 サルガドの上着
            226:"icon_hair_z009a.swf",		// 226 マックスのフード
            227:"icon_hair_z022a.swf",		// 227 サルガドのフード
            228:"icon_basket_z030a.swf",	// 228 ブロウニングのアタッシュケース
            229:"icon_fairy_z026a.swf",		// 229 ウォーケンの棺桶
            230:"icon_wing_a000a.swf",		// 230 天使の羽
            231:"icon_dress_b003a.swf",		// 231 天界の服
            232:"icon_blouse_z001b.swf",	// 232 エヴァリストの礼服（上）
            233:"icon_skirt_z001b.swf",		// 233 エヴァリストの礼服（下）
            234:"icon_blouse_z003b.swf",	// 234 グリュンワルドの上着（R）
            235:"icon_skirt_z003b.swf",		// 235 グリュンワルドのトラウザー（R）
            236:"icon_blouse_z010b.swf",	// 236 ブレイズの上着（R）
            237:"icon_skirt_z010b.swf",		// 237 ブレイズのパンツ（R）
            238:"icon_blouse_z024b.swf",	// 238 リーズの上着（R）
            239:"icon_skirt_z024b.swf",		// 239 リーズのトラウザー（R）
            240:"icon_shoes_z024b.swf",		// 240 リーズのブーツ（R）
            241:"icon_blouse_z030b.swf",	// 241 ブロウニングのベスト
            242:"icon_dress_z010b.swf",		// 242 メリアのワンピース
            243:"icon_dress_z011c.swf",		// 243 暗殺者のドレス
            244:"icon_mant_z001a.swf",		// 244 逃亡者のマント
            245:"icon_hair_z011b.swf",		// 245 シェリの髪型（R）
            246:"icon_eyemask_z030a.swf",	// 246 ブロウニングのアイマスク
            247:"icon_hat_z030b.swf",		// 247 ブロウニングの帽子
            248:"icon_basket_z011a.swf",	// 248 シェリの傘
            249:"icon_basket_z101a.swf",	// 249 エヴァリストの手提げ人形
            250:"icon_basket_z103a.swf",	// 250 グリュンワルドの手提げ人形
            251:"icon_basket_z110a.swf",	// 251 ブレイズの手提げ人形
            252:"icon_basket_z113a.swf",	// 252 ベルンハルトの手提げ人形
            253:"icon_basket_z124a.swf",	// 253 リーズの手提げ人形
            254:"icon_fairy_z013a.swf",		// 254 幼生ウボス
            255:"icon_fairy_z003a.swf",		// 255 タナトス
            256:"icon_hat_m001a.swf",		// 256 ミニクラウン（赤）
            257:"icon_hat_m001b.swf",		// 257 ミニクラウン（青）
            258:"icon_hat_m001c.swf",		// 258 ミニクラウン（緑）
            259:"icon_blouse_x001a.swf",	// 259 王子の服（赤）
            260:"icon_blouse_x001b.swf",	// 260 王子の服（青）
            261:"icon_blouse_x001c.swf",	// 261 王子の服（緑）
            262:"icon_skirt_x000a.swf",		// 262 王子のパンツ（赤）
            263:"icon_skirt_x000b.swf",		// 263 王子のパンツ（青）
            264:"icon_skirt_x000c.swf",		// 264 王子のパンツ（緑）
            265:"icon_shoes_x005a.swf",		// 265 王子の靴
            266:"icon_wand_x000a.swf",		// 266 カエル王子の剣（赤）
            267:"icon_wand_x000b.swf",		// 267 カエル王子の剣（青）
            268:"icon_wand_x000c.swf",		// 268 カエル王子の剣（緑）
            269:"icon_basket_z104a.swf",	// 269 アベルの手提げ人形
            270:"icon_basket_z140a.swf",	// 270 カレンベルクの手提げ人形
            271:"icon_basket_z118a.swf",	// 271 ベリンダの手提げ人形
            272:"icon_basket_z111a.swf",	// 272 シェリの手提げ人形
            273:"icon_basket_z122a.swf",	// 273 サルガドの手提げ人形
            274:"icon_basket_z102a.swf",	// 274 アイザックの手提げ人形
            275:"icon_basket_z141a.swf",	// 275 ネネムの手提げ人形
            276:"icon_hat_m001d.swf",		// 276 ミニクラウン（黒）
            277:"icon_shoes_x006a.swf",		// 277 ビーチサンダル（黒）
            278:"icon_hat_x005a.swf",		// 278 サングラス（黒）
            279:"icon_swim_u_a001a.swf",	// 279 タンキニアンダー（黒）
            280:"icon_swim_t_a001a.swf",	// 280 タンキニトップ（黒）
            281:"icon_mant_z010a.swf",		// 281 協定審問官のマント
            282:"icon_basket_z112a.swf",	// 282 アインの手提げ人形
            283:"icon_basket_z137a.swf",	// 283 コッブの手提げ人形
            284:"icon_basket_z128a.swf",	// 284 パルモの手提げ人形
            285:"icon_basket_z143a.swf",	// 285 ビアギッテの手提げ人形
            286:"icon_blouse_z018a.swf",	// 286 ベリンダの上着
            287:"icon_skirt_z018a.swf",		// 287 ベリンダのスカート
            288:"icon_mant_z018a.swf",		// 288 ベリンダのケープ
            289:"icon_shoes_z018a.swf",		// 289 ベリンダのブーツ
            290:"icon_basket_z119a.swf",	// 290 ロッソの手提げ人形
            291:"icon_basket_z145a.swf",	// 291 シャーロットの手提げ人形
            292:"icon_basket_z108a.swf",	// 292 アーチボルトの手提げ人形
            293:"icon_basket_z127a.swf",	// 293 フロレンスの手提げ人形
            294:"icon_basket_z121a.swf",	// 294 メレンの手提げ人形
            295:"icon_basket_z123a.swf",	// 295 レッドグレイヴの手提げ人形
            296:"icon_basket_z130a.swf",	// 296 ブロウニングの手提げ人形
            297:"icon_basket_z131a.swf",	// 297 マルセウスの手提げ人形
            298:"icon_ribbon_x001a.swf",	// 298 ネジ 
            299:"icon_mask_x002a.swf",		// 299 ミイラマスク 
            300:"icon_dress_x004a.swf",		// 300 ミイラスーツ 
            301:"icon_mant_x001a.swf",		// 301 スプーキーマント 
            302:"icon_basket_z106a.swf",	// 302 クレーニヒの手提げ人形
            303:"icon_basket_z114a.swf",	// 303 フリードリヒの手提げ人形
            304:"icon_blouse_z005a.swf",	// 304 レオンの上着
            305:"icon_skirt_z005a.swf",		// 305 レオンのパンツ
            306:"icon_shoes_z005a.swf",		// 306 レオンのブーツ
            307:"icon_blouse_z008b.swf",	// 307 アーチボルトのコート
            308:"icon_skirt_z008a.swf",		// 308 アーチボルトのパンツ
            309:"icon_shoes_z008a.swf",		// 309 アーチボルトのブーツ
            310:"icon_basket_z111b.swf",	// 310 シェリの手提げ人形（R）
            311:"icon_basket_z138a.swf",	// 311 イヴリンの手提げ人形
            312:"icon_basket_z147a.swf",	// 312 ルディアの手提げ人形
            313:"icon_basket_z142a.swf",	// 313 コンラッドの手提げ人形
            314:"icon_shoes_z021a.swf",		// 314 アコライトの靴（茶） 
            315:"icon_skirt_z021a.swf",		// 315 アコライトのパンツ（茶) 
            316:"icon_blouse_z021a.swf",	// 316 アコライトの上着（茶） 
            317:"icon_hair_x002a.swf",		// 317 綿帽子（金） 
            318:"icon_hair_x002b.swf",		// 318 綿帽子（茶） 
            319:"icon_hair_x002c.swf",		// 319 綿帽子（青） 
            320:"icon_dress_a011a.swf",		// 320 白無垢
            321:"icon_basket_z125a.swf",	// 321 ミリアンの手提げ人形
            322:"icon_basket_z129a.swf",	// 322 アスラの手提げ人形
            323:"icon_tiara_m000a.swf",		// 323 不思議なティアラ I
            324:"icon_tiara_m000b.swf",		// 324 不思議なティアラ II
            325:"icon_tiara_m000c.swf",		// 325 不思議なティアラ III
            326:"icon_fairy_m000a.swf",		// 326 気まぐれフェアリー I
            327:"icon_fairy_m000b.swf",		// 327 気まぐれフェアリー II
            328:"icon_fairy_m000c.swf",		// 328 気まぐれフェアリー III
            329:"icon_earring_m000a.swf",	// 329 妖しいイヤリング I
            330:"icon_earring_m000b.swf",	// 330 妖しいイヤリング II
            331:"icon_earring_m000c.swf",	// 331 妖しいイヤリング III
            332:"icon_wand_m000a.swf",		// 332 儚きワンド I
            333:"icon_wand_m000b.swf",		// 333 儚きワンド II
            334:"icon_wand_m000c.swf",		// 334 儚きワンド III
            335:"icon_tiara_m000a.swf",		// 335 幻惑のティアラ I
            336:"icon_tiara_m000b.swf",		// 336 幻惑のティアラ II
            337:"icon_tiara_m000c.swf",		// 337 幻惑のティアラ III
            338:"icon_fairy_m000a.swf",		// 338 陽気なフェアリー I
            339:"icon_fairy_m000b.swf",		// 339 陽気なフェアリー II
            340:"icon_fairy_m000c.swf",		// 340 陽気なフェアリー III
            341:"icon_earring_m000a.swf",	// 341 魔性のイヤリング I
            342:"icon_earring_m000b.swf",	// 342 魔性のイヤリング II
            343:"icon_earring_m000c.swf",	// 343 魔性のイヤリング III
            344:"icon_wand_m000a.swf",		// 344 強欲のワンド I
            345:"icon_wand_m000b.swf",		// 345 強欲のワンド II
            346:"icon_wand_m000c.swf",		// 346 強欲のワンド III
            347:"icon_basket_z115a.swf",	// 347 マルグリッドの手提げ人形
            348:"icon_basket_z148a.swf",	// 348 ヴィルヘルムの手提げ人形
            349:"icon_basket_z109a.swf",	// 349 マックスの手提げ人形
            350:"icon_basket_z144a.swf",	// 350 クーンの手提げ人形
            351:"icon_blouse_x002a.swf",	// 351 レジメント制服4式上着
            352:"icon_skirt_x001a.swf",		// 352 レジメント制服4式パンツ
            353:"icon_shoes_x007a.swf",		// 353 レジメントブーツ4式
            354:"icon_basket_z105a.swf",	// 354 レオンの手提げ人形
            355:"icon_basket_z134a.swf",	// 355 ステイシアの手提げ人形
            356:"icon_basket_z126a.swf",	// 356 ウォーケンの手提げ人形 
            357:"icon_basket_z136a.swf",	// 357 C.C.の手提げ人形 
            358:"icon_blouse_z036a.swf",	// 358 C.C.の上着 
            359:"icon_skirt_z036a.swf",		// 359 C.C.のホットパンツ 
            360:"icon_shoes_z036a.swf",		// 360 C.C.のブーツ 
            361:"icon_blouse_z046a.swf",	// 361 タイレルの上着 
            362:"icon_skirt_z046a.swf",		// 362 タイレルのパンツ 
            363:"icon_shoes_z046a.swf",		// 363 タイレルの靴 
            364:"icon_fairy_z046a.swf",		// 364 超電磁ボール 
            365:"icon_fairy_z015a.swf",		// 365 ドローン 
            366:"icon_basket_z116a.swf",	// 366 ドニタの手提げ人形
            367:"icon_basket_z117a.swf",	// 367 スプラートの手提げ人形 
            368:"icon_basket_z107a.swf",	// 368 ジェッドの手提げ人形
            369:"icon_basket_z135a.swf",	// 369 ヴォランドの手提げ人形 
            370:"icon_hair_a000d.swf",		// 370 ショート（白）
            371:"icon_hair_a000f.swf",		// 371 ショート（銀）
            372:"icon_hair_a000h.swf",		// 372 ショート（黒）
            373:"icon_hair_a000i.swf",		// 373 ショート（焦茶）
            374:"icon_hair_b000d.swf",		// 374 ベリーショート（白）
            375:"icon_hair_b000g.swf",		// 375 ベリーショート（赤）
            376:"icon_hair_b000h.swf",		// 376 ベリーショート（黒）
            377:"icon_hair_b000m.swf",		// 377 ベリーショート（藍）
            378:"icon_hair_c001a.swf",		// 378 ピッグテール（金）
            379:"icon_hair_c001c.swf",		// 379 ピッグテール（青）
            380:"icon_hair_c001d.swf",		// 380 ピッグテール（白）
            381:"icon_hair_c001h.swf",		// 381 ピッグテール（黒）
            382:"icon_hair_c001i.swf",		// 382 ピッグテール（焦茶）
            383:"icon_hair_c002a.swf",		// 383 ツーサイドアップ（金）
            384:"icon_hair_c002d.swf",		// 384 ツーサイドアップ（白）
            385:"icon_hair_c002i.swf",		// 385 ツーサイドアップ（焦茶）
            386:"icon_hair_c002l.swf",		// 386 ツーサイドアップ（桃）
            387:"icon_hair_c002m.swf",		// 387 ツーサイドアップ（藍）
            388:"icon_hair_d000d.swf",		// 388 ロングカール（白）
            389:"icon_hair_d000i.swf",		// 389 ロングカール（焦茶）
            390:"icon_hair_d000k.swf",		// 390 ロングカール（紫）
            391:"icon_hair_d000l.swf",		// 391 ロングカール（桃）
            392:"icon_basket_z120a.swf",	// 392 エイダの手提げ人形
            393:"icon_basket_z132a.swf",	// 393 ルートの手提げ人形 
            394:"icon_basket_z133a.swf",	// 394 リュカの手提げ人形
            395:"icon_basket_z139a.swf",	// 395 ブラウの手提げ人形 
            396:"icon_shoes_z006a.swf",		// 396 クレーニヒの靴
            397:"icon_skirt_z006a.swf",		// 397 クレーニヒの袴
            398:"icon_blouse_z006a.swf",	// 398 クレーニヒの上着
            399:"icon_fairy_z006b.swf",		// 399 深淵くん（復活）
            400:"icon_hair_z007a.swf",		// 400 ジェッドの髪型
            401:"icon_hair_z016a.swf",		// 401 ドニタの髪型
            402:"icon_hair_z038a.swf",		// 402 イヴリンの髪型
            403:"icon_hat_z101a.swf",		// 403 エヴァリストの頭のせ人形
            404:"icon_hat_z107a.swf",		// 404 ジェッドの頭のせ人形
            405:"icon_hat_z110a.swf",		// 405 ブレイズの頭のせ人形
            406:"icon_hat_z111a.swf",		// 406 シェリの頭のせ人形
            407:"icon_hat_z116a.swf",		// 407 ドニタの頭のせ人形
            408:"icon_hat_z124a.swf",		// 408 リーズの頭のせ人形
            409:"icon_hat_z138a.swf",		// 409 イヴリンの頭のせ人形
            410:"icon_hat_z141a.swf",		// 410 ネネムの頭のせ人形
            411:"icon_basket_z146a.swf",	// 411 タイレルの手提げ人形 
            412:"icon_basket_z150a.swf",	// 412 ギュスターヴの手提げ人形 
            413:"icon_shoes_z017a.swf",		// 413 スプラートのサンダル
            414:"icon_skirt_z017a.swf",		// 414 スプラートのパンツ
            415:"icon_blouse_z017a.swf",	// 415 スプラートの上着
            416:"icon_shoes_z028a.swf",		// 416 パルモのブーツ
            417:"icon_skirt_z028a.swf",		// 417 パルモのスカート
            418:"icon_blouse_z028a.swf",	// 418 パルモの上着
            419:"icon_fairy_z028a.swf",		// 419 神獣ちゃん
            420:"icon_mant_z012a.swf",		// 420 アインのコート
            421:"icon_basket_z151a.swf",	// 421 ユーリカの手提げ人形
            422:"icon_shoes_z045a.swf",		// 422 シャーロットのサンダル
            423:"icon_skirt_z045a.swf",		// 423 シャーロットのレギンス
            424:"icon_dress_z045a.swf",		// 424 シャーロットの服
            425:"icon_hair_z034a.swf",		// 425 ステイシアの髪型
            426:"icon_hat_z118a.swf",		// 426 ベリンダの頭のせ人形
            427:"icon_hat_z134a.swf",		// 427 ステイシアの頭のせ人形
            428:"icon_basket_x002a.swf",	// 428 リリィの手提げ人形
            429:"icon_hat_x006a.swf",		// 429 加油高雄サンバイザー
            430:"icon_hat_z104a.swf",		// 430 アベルの頭のせ人形
            431:"icon_hat_z130a.swf",		// 431 ブロウニングの頭のせ人形
            432:"icon_hat_x007a.swf",		// 432 フラムのお面
            433:"icon_hat_x008a.swf",		// 433 白狐のお面
            434:"icon_hat_x008b.swf",		// 434 黒狐のお面
            435:"icon_basket_x003a.swf",	// 435 チョコバナナ
            436:"icon_basket_x004a.swf",	// 436 巾着（白）
            437:"icon_basket_x004b.swf",	// 437 巾着（赤）
            438:"icon_basket_x004c.swf",	// 438 巾着（紫）
            439:"icon_fairy_x000a.swf",		// 439 蚊遣り豚
            440:"icon_dress_x005a.swf",		// 440 浴衣（梅）
            441:"icon_dress_x005b.swf",		// 441 浴衣（蝶）
            442:"icon_dress_x005c.swf",		// 442 浴衣（朝顔）
            443:"icon_shoes_x008a.swf",		// 443 下駄（紫）
            444:"icon_shoes_x008b.swf",		// 444 下駄（赤）
            445:"icon_shoes_x008c.swf",		// 445 下駄（白）
            446:"icon_shoes_z026a.swf",		// 446 ウォーケンのブーツ
            447:"icon_skirt_z026a.swf",		// 447 ウォーケンのパンツ
            448:"icon_blouse_z026a.swf",	// 448 ウォーケンの上着
            449:"icon_hat_z103a.swf",		// 449 グリュンワルドの頭のせ人形
            450:"icon_hat_z136a.swf",		// 450 C.C.の頭のせ人形
            451:"icon_hat_z105a.swf",		// 451 レオンの頭のせ人形
            452:"icon_hat_z140a.swf",		// 452 カレンベルクの頭のせ人形
            453:"icon_shoes_z035a.swf",		// 453 ヴォランドのブーツ
            454:"icon_skirt_z035a.swf",		// 454 ヴォランドのパンツ
            455:"icon_blouse_z035a.swf",	// 455 ヴォランドの上着
            456:"icon_shoes_z037a.swf",		// 456 コッブの靴
            457:"icon_skirt_z037a.swf",		// 457 コッブのスラックス
            458:"icon_blouse_z037a.swf",	// 458 コッブのスーツ
            459:"icon_paint_z037a.swf",		// 459 コッブの刺青
            460:"icon_basket_z149a.swf",	// 460 メリーの手提げ人形
            461:"icon_hat_z122a.swf",		// 461 サルガドの頭のせ人形
            462:"icon_hat_z152a.swf",		// 462 リンナエウスの頭のせ人形
            463:"icon_fairy_z035a.swf",		// 463 セレスシャル
            464:"icon_fairy_z037a.swf",		// 464 深海くん
            465:"icon_hat_z132a.swf",		// 465 ルートの頭のせ人形
            466:"icon_hat_z139a.swf",		// 466 ブラウの頭のせ人形
            467:"icon_shoes_x009a.swf",		// 467 ピエロシューズ
            468:"icon_skirt_x002a.swf",		// 468 ピエロタイツ
            469:"icon_dress_x006a.swf",		// 469 ピエロドレス
            470:"icon_fairy_a001a.swf",		// 470 4thアニバーサリーエンジェル
            471:"icon_hat_z125a.swf",		// 471 ミリアンの頭のせ人形
            472:"icon_shoes_z009a.swf",		// 472 マックスのグリーヴ
            473:"icon_dress_z009a.swf",		// 473 マックスの鎧
            474:"icon_shoes_z010a.swf",		// 474 ブレイズのグリーヴ
            475:"icon_dress_z010a.swf",		// 475 ブレイズの鎧
            476:"icon_hat_z117a.swf",		// 476 スプラートの頭のせ人形
            477:"icon_hat_z150a.swf",		// 477 ギュスターヴの頭のせ人形
            478:"icon_hat_z102a.swf",		// 478 アイザックの頭のせ人形
            479:"icon_hat_z133a.swf",		// 479 リュカの頭のせ人形
            480:"icon_shoes_x010a.swf",		// 480 レインディアブーツ
            481:"icon_hair_x003a.swf",		// 481 レインディアフード（金）
            482:"icon_hair_x003c.swf",		// 482 レインディアフード（青）
            483:"icon_hair_x003f.swf",		// 483 レインディアフード（銀）
            484:"icon_dress_x007a.swf",		// 484 レインディアコート
            485:"icon_fairy_x001a.swf",		// 485 スノーマン
            486:"icon_hat_z101b.swf",		// 486 エヴァリストサンタの頭のせ人形
            487:"icon_hat_z108a.swf",		// 487 アーチボルトの頭のせ人形
            488:"icon_hat_z128a.swf",		// 488 パルモの頭のせ人形
            489:"icon_basket_z153a.swf",	// 489 ナディーンの手提げ人形
            490:"icon_hat_z119a.swf",		// 490 ロッソの頭のせ人形
            491:"icon_hat_z143a.swf",		// 491 ビアギッテの頭のせ人形
            492:"icon_hair_c003a.swf",		// 492 チャイナシニヨン（金）
            493:"icon_hair_c003b.swf",		// 493 チャイナシニヨン（茶）
            494:"icon_hair_c003c.swf",		// 494 チャイナシニヨン（青）
            495:"icon_hair_c003f.swf",		// 495 チャイナシニヨン（銀）
            496:"icon_hair_c003h.swf",		// 496 チャイナシニヨン（黒）
            497:"icon_dress_x008a.swf",		// 497 チャイナゴシック（白）
            498:"icon_dress_x008b.swf",		// 498 チャイナゴシック（赤）
            499:"icon_dress_x008c.swf",		// 499 チャイナゴシック（緑）
            500:"icon_hair_z055a.swf",		// 500 オウラン(茶)のフード
            501:"icon_hair_z055b.swf",		// 501 オウラン(茶)のかぶりもの
            502:"icon_dress_z055a.swf",		// 502 オウラン(茶)のスーツ
            503:"icon_hat_z155a.swf",		// 503 オウラン(茶)の頭のせ人形
            504:"icon_hat_z127a.swf",		// 504 フロレンスの頭のせ人形
            505:"icon_hat_z131a.swf",		// 505 マルセウスの頭のせ人形
            506:"icon_basket_z154a.swf",	// 506 ディノの手提げ人形
            507:"icon_basket_z152a.swf",	// 507 リンナエウスの手提げ人形
            508:"icon_hat_x009a.swf",		// 508 ナイトキャップ
            509:"icon_lefthand_x001a.swf",	// 509 枕
            510:"icon_dress_x009a.swf",		// 510 ネグリジェ
            511:"icon_hat_z126a.swf",		// 511 ウォーケンの頭のせ人形
            512:"icon_hat_z135a.swf",		// 512 ヴォランドの頭のせ人形
            513:"icon_hat_x010a.swf",		// 513 名前入り帽子
            514:"icon_shoes_z029a.swf",		// 514 アスラのブーツ
            515:"icon_skirt_z029a.swf",		// 515 アスラの忍装束（下）
            516:"icon_blouse_z029a.swf",	// 516 アスラの忍装束（上）
            517:"icon_shoes_z033a.swf",		// 517 リュカのブーツ
            518:"icon_skirt_z033a.swf",		// 518 リュカの袴
            519:"icon_blouse_z033a.swf",	// 519 リュカの上着
            520:"icon_mant_z033a.swf",		// 520 リュカのケープ
            521:"icon_hat_z106a.swf",		// 521 クレーニヒの頭のせ人形
            522:"icon_hat_z145a.swf",		// 522 シャーロットの頭のせ人形
            523:"icon_lefthand_z003a.swf",	// 523 グリュンワルド柄の枕
            524:"icon_tail_z029a.swf",		// 524 アスラの忍者刀
            525:"icon_hat_z142a.swf",		// 525 コンラッドの頭のせ人形
            526:"icon_hat_z146a.swf",		// 526 タイレルの頭のせ人形
            527:"icon_shoes_z034a.swf",		// 527 ステイシアのブーツ
            528:"icon_skirt_z034a.swf",		// 528 ステイシアのスカート
            529:"icon_blouse_z034a.swf",	// 529 ステイシアの上着
            530:"icon_hair_z034b.swf",		// 530 ステイシアの髪型（殺戮A）
            531:"icon_hair_z034c.swf",		// 531 ステイシアの髪型（殺戮B）
            532:"icon_hat_z113a.swf",		// 532 ベルンハルトの頭のせ人形
            533:"icon_hat_z151a.swf",		// 533 ユーリカの頭のせ人形
            534:"icon_basket_z157a.swf",	// 534 ノイクロームの手提げ人形
            535:"icon_hat_z149a.swf",		// 535 メリーの頭のせ人形
            536:"icon_hat_z147a.swf",		// 536 ルディアの頭のせ人形
            537:"icon_hat_z137a.swf",		// 537 コッブの頭のせ人形
            538:"icon_hat_z159a.swf",		// 538 シラーリーの頭のせ人形
            539:"icon_shoes_x011a.swf",		// 539 スリッパ
            540:"icon_hat_x011a.swf",		// 540 キャップ
            541:"icon_dress_x010a.swf", 	// 541 ネグリジェ
            542:"icon_shoes_z041a.swf",		// 542 ネネム靴
            543:"icon_hat_z041a.swf",		// 543 ネネムキャップ
            544:"icon_dress_z041a.swf", 	// 544 ネネム服
            545:"icon_bag_a041a.swf",   	// 545 ネネムバッグ
            546:"icon_hair_z041a.swf",  	// 546 ネネム髪型
            547:"icon_hat_z112a.swf",		// 547 アインの頭のせ人形
            548:"icon_hat_z144a.swf",		// 548 クーンの頭のせ人形
            549:"icon_hat_z129a.swf",		// 549 アスラの頭のせ人形
            550:"icon_shoes_z030a.swf",		// 550 ブロウニングの靴
            551:"icon_skirt_z030a.swf",		// 551 ブロウニングのスラックス
            552:"icon_blouse_z030a.swf", 	// 552 ブロウニングのコート
            553:"icon_hat_z030a.swf",		// 553 ブロウニングの帽子（新）
            554:"icon_mask_z030a.swf",		// 554 ブロウニングのあご髭
            555:"icon_hair_z030a.swf",		// 555 ブロウニングの髪型
            556:"icon_hair_z030b.swf",		// 556 ブロウニングの髪型（帽子）
            557:"icon_shoes_z031a.swf", 	// 557 マルセウスのブーツ
            558:"icon_skirt_z031a.swf",		// 558 マルセウスのスカート
            559:"icon_blouse_z031a.swf",	// 559 マルセウスの上着
            560:"icon_hair_z031a.swf",		// 560 マルセウスの髪型
            561:"icon_basket_z156a.swf",	// 561 オウラン（白黒）の手提げ人形
            562:"icon_hat_z120a.swf",		// 562 エイダの頭のせ人形
            563:"icon_hat_z148a.swf",		// 563 ヴィルヘルムの頭のせ人形
            564:"icon_hat_z109a.swf",		// 564 マックスの頭のせ人形
            565:"icon_hat_z123a.swf",		// 565 レッドグレイヴの頭のせ人形
            566:"icon_hat_x012a.swf",		// 566	ハイビスカス（赤）
            567:"icon_hat_x012b.swf",		// 567	ハイビスカス（白）
            568:"icon_hat_x012c.swf",		// 568	ハイビスカス（青）
            569:"icon_lefthand_x002a.swf",	// 569	浮輪（ゴシック）
            570:"icon_lefthand_x002b.swf",	// 570	浮輪（ドーナツ）
            571:"icon_fairy_x002a.swf",		// 571	ビーチパラソル（白）
            572:"icon_fairy_x002b.swf",		// 572	ビーチパラソル（黒）
            573:"icon_swim_t_a002a.swf",	// 573	セーラースイムトップ（紺）
            574:"icon_swim_t_a002b.swf",	// 574	セーラースイムトップ（翡翠）
            575:"icon_swim_t_a002c.swf",	// 575	セーラースイムトップ（黒）
            576:"icon_swim_u_a002a.swf",	// 576	セーラースイムアンダー（紺）
            577:"icon_swim_u_a002b.swf",	// 577	セーラースイムアンダー（翡翠）
            578:"icon_swim_u_a002c.swf",	// 578	セーラースイムアンダー（黒）
            579:"icon_shoes_x012a.swf",		// 579	リボンビーチサンダル（紺）
            580:"icon_shoes_x012b.swf",		// 580	リボンビーチサンダル（翡翠）
            581:"icon_shoes_x012c.swf",		// 581	リボンビーチサンダル（黒）
            582:"icon_basket_z158a.swf",	// 582	イデリハの手提げ人形
            583:"icon_hat_z160a.swf",		// 583 クロヴィスの頭のせ人形
            584:"icon_hat_z156a.swf",		// 584 オウラン白黒の頭のせ人形
            585:"icon_hat_z163a.swf",		// 585 アリアーヌの頭のせ人形
            586:"icon_shoes_z047a.swf",		// 586 ルディアのブーツ
            587:"icon_dress_z047a.swf",		// 587 ルディアの服
            588:"icon_mant_z047a.swf",		// 588 ルディアのマフラー
            589:"icon_shoes_z048a.swf",		// 589 ヴィルヘルムのブーツ
            590:"icon_skirt_z048a.swf",		// 590 ヴィルヘルムのトラウザ
            591:"icon_blouse_z048a.swf",	// 591 ヴィルヘルムの上着
            592:"icon_shoes_z049a.swf",		// 592 メリーの靴
            593:"icon_dress_z049a.swf",		// 593 メリーの服
            594:"icon_hat_z049a.swf",		// 594 メリーの帽子
            595:"icon_hat_z121a.swf",		// 595 メレンの頭のせ人形
            596:"icon_hat_z153a.swf",		// 596 ナディーンの頭のせ人形
            597:"icon_hat_z114a.swf",		// 597 フリードリヒの頭のせ人形
            598:"icon_hat_z161a.swf",		// 598 アリステリアの頭のせ人形
            599:"icon_basket_z159a.swf",	// 599 シラーリーの手提げ人形
            600:"icon_shoes_z038a.swf",	// 600 イヴリン衣装1
            601:"icon_mant_z038a.swf",	// 601 イヴリン衣装2
            602:"icon_dress_z038a.swf",	// 602 イヴリン衣装3
            603:"icon_shoes_z042a.swf",	// 603 コンラッド衣装1
            604:"icon_skirt_z042a.swf",	// 604 コンラッド衣装2
            605:"icon_blouse_z042a.swf",	// 605 コンラッド衣装3
            606:"icon_hair_z042a.swf",	// 606 コンラッドの髪型
            607:"icon_hat_z157a.swf",		// 607 ノイクロームの頭のせ人形
            608:"icon_hat_z158a.swf",		// 608 イデリハの頭のせ人形
            609:"icon_hat_z115a.swf",		// 609 頭のせ人形
            610:"icon_hat_z154a.swf",		// 610 頭のせ人形
            611:"icon_shoes_a000b.swf",		// 611 人形の靴
            612:"icon_shoes_a000c.swf",		// 612 人形の靴
            613:"icon_basket_z160a.swf",	// 613 手提げ人形
            614:"icon_ribbon_x002a.swf",	// 614	コウモリの羽飾り
            615:"icon_dress_x012a.swf",	// 615	ヴァンパイアドレス
            616:"icon_paint_z021a.swf",	// 616	メレンのペイント
            617:"icon_hair_z021a.swf",	// 617	メレンの髪型
            618:"icon_hair_z032a.swf",	// 618	ルートの髪型
            619:"icon_hair_z039a.swf",	// 619	ブラウの髪型
            620:"icon_hat_z162a.swf",	// 620	ヒューゴの頭のせ人形
            621:"icon_fairy_x003a.swf",	// 621	ダイス（黒）
            622:"icon_fairy_x003b.swf",	// 622	ダイス（白）
            623:"icon_hat_z164a.swf",	// 623	グレゴールの頭のせ人形
            624:"icon_lefthand_z124k.swf",	// 613 手提げ人形
            625:"icon_lefthand_z139k.swf",	// 613 手提げ人形
            626:"icon_lefthand_z152k.swf",	// 613 手提げ人形
            627:"icon_basket_z162a.swf",	// 613 手提げ人形
            628:"icon_shoes_z020a.swf",	// 628 オーロール隊ブーツ
            629:"icon_skirt_z020a.swf",	// 629 オーロール隊パンツ
            630:"icon_blouse_z020a.swf",	// 630 オーロール隊上着
            631:"icon_hair_z020a.swf",	// 631 エイダの髪型
            632:"icon_hair_z048a.swf",	// 632 ヴィルヘルムの髪型
            633:"icon_lefthand_z101p.swf",	// 633 手提げ人形
            634:"icon_lefthand_z119p.swf",	// 634 手提げ人形
            635:"icon_lefthand_z103p.swf",	// 635 手提げ人形
            636:"icon_lefthand_z124p.swf",	// 636 手提げ人形
            637:"icon_lefthand_z131p.swf",	// 637 手提げ人形
            638:"icon_lefthand_z115p.swf",	// 638 手提げ人形
            639:"icon_lefthand_z140p.swf",	// 639 手提げ人形
            640:"icon_hair_z036a.swf",	// 640	C.C.の髪型
            641:"icon_hair_z046a.swf",	// 641	タイレルの髪型
            642:"icon_shoes_x013a.swf",	// 642	ウィンターブーツ
            643:"icon_hat_x013a.swf",	// 643	ウィンターハット
            644:"icon_dress_x013b.swf",	// 644	ウィンターコート（赤）
            645:"icon_dress_x013a.swf",	// 645	ウィンターコート（灰）
            646:"icon_dress_x013c.swf",	// 646	ウィンターコート（黒）
            647:"icon_shoes_z061a.swf",	// 647	アリステリアの靴
            648:"icon_skirt_z061a.swf",	// 648	アリステリアのパンスト
            649:"icon_blouse_z061a.swf",	// 649	アリステリアのドレス
            650:"icon_basket_z161a.swf",	// 650 手提げ人形
            651:"icon_lefthand_z111p.swf",	// 651 手提げ人形
            652:"icon_lefthand_z146p.swf",	// 652 手提げ人形
            653:"icon_lefthand_z148p.swf",	// 653 手提げ人形
            654:"icon_basket_z163a.swf",	// 654 アリアーヌの手提げ人形
            655:"icon_basket_z052a.swf",	// 655 リンナエウスの杖
            656:"icon_fairy_z052a.swf",	// 656 機械蝶
            657:"icon_shoes_z052a.swf",	// 657 リンナエウスの靴
            658:"icon_skirt_z052a.swf",	// 658 リンナエウスのパンツ
            659:"icon_blouse_z052a.swf",	// 659 リンナエウスの上着
            660:"icon_hair_z052a.swf",	// 660 リンナエウスの髪型
            661:"icon_hair_z047a.swf",	// 661 ルディアの髪型
            662:"icon_lefthand_z148b.swf",	// 662 ヴィルヘルム手提げ（右）
            663:"icon_shoes_z069a.swf",	// 663 ノエルのサイハイブーツ
            664:"icon_skirt_z069a.swf",	// 664 ノエルのホットパンツ
            665:"icon_blouse_z069a.swf",	// 665 ノエルの服
            666:"icon_shoes_z016b.swf",	// 666 ドニタの靴(R)
            667:"icon_dress_z016b.swf",	// 667 ドニタのドレス(R)
            668:"icon_hair_z016b.swf",	// 668 ドニタの髪型（R）
            669:"icon_basket_z164a.swf",	// 669 グレゴールの手提げ人形
            670:"icon_lefthand_z101b.swf",	// 670 手提げ人形（右）
            671:"icon_lefthand_z119b.swf",	// 671 手提げ人形（右）
            672:"icon_lefthand_z103b.swf",	// 672 手提げ人形（右）
            673:"icon_lefthand_z124b.swf",	// 673 手提げ人形（右）
            674:"icon_lefthand_z131b.swf",	// 674 手提げ人形（右）
            675:"icon_lefthand_z115b.swf",	// 675 手提げ人形（右）
            676:"icon_lefthand_z140b.swf",	// 676 手提げ人形（右）
            677:"icon_lefthand_z111b.swf",	// 677 手提げ人形（右）
            678:"icon_lefthand_z146b.swf",	// 678 手提げ人形（右）
            679:"icon_shoes_z054a.swf",	// 679 ディノのブーツ
            680:"icon_skirt_z054a.swf",	// 680 ディノのトラウザ
            681:"icon_blouse_z054a.swf",	// 681 ディノの上着
            682:"icon_shoes_z058a.swf",	// 682 イデリハのブーツ
            683:"icon_skirt_z058a.swf",	// 683 イデリハのトラウザ
            684:"icon_blouse_z058a.swf",	// 684 イデリハの上着
            685:"icon_mant_z058a.swf",	// 685 イデリハのコート
            686:"icon_hat_z168a.swf",		// 686 ユハニの頭のせ人形
            687:"icon_basket_z165a.swf",	// 687 レタの手提げ人形
            688:"icon_basket_z166a.swf",	// 688 エプシロンの手提げ人形
            689:"icon_lefthand_z001a.swf",	// 689 エヴァリスト柄の枕
            690:"icon_hat_z170a.swf",		// 690 ラウルの頭のせ人形
            691:"icon_shoes_z040a.swf",	// 691 カレンベルクのブーツ 
            692:"icon_skirt_z040a.swf",	// 692 カレンベルクのパンツ 
            693:"icon_blouse_z040a.swf",		// 693 カレンベルクの上着 
            694:"icon_shoes_z051a.swf",	// 694 ユーリカのブーツ 
            695:"icon_dress_z051a.swf",	// 695 ユーリカの修道服 
            696:"icon_hat_z051a.swf",		// 696 ユーリカのウィンプル 
            697:"icon_hair_z003a.swf",	// 697 グリュンワルドの髪型
            698:"icon_hair_z040a.swf",	// 698 カレンベルクの髪型 
            699:"icon_basket_z040a.swf",	// 699 ヴァイオリンケース（左手
            700:"icon_lefthand_z040b.swf",		// 700 ヴァイオリンケース（右手
            701:"icon_hat_z171a.swf",		// 701 ジェミーの頭のせ人形
            702:"icon_basket_z167a.swf",	// 702 ポレットの手提げ人形
            703:"icon_shoes_z057a.swf",	// 703ノイクロームのブーツ 
            704:"icon_dress_z057a.swf",	// 704ノイクロームの服
            705:"icon_hat_z057a.swf",	// 705ノイクロームのシルクハット
            706:"icon_shoes_z059a.swf",		// 706シラーリーのブーツ
            707:"icon_skirt_z059a.swf",		// 707シラーリーのスカート
            708:"icon_blouse_z059a.swf",	// 708シラーリーの上着
            709:"icon_eyepatch_z002a.swf",	// 709 アイザック眼帯
            710:"icon_hat_z172a.swf",	// 710 セルファース頭のせ
            711:"icon_hat_z169a.swf",	// 711 ノエラ頭のせ
            712:"icon_hat_z166a.swf",	// 712 エプシロンの頭のせ人形
            713:"icon_hair_z018a.swf",	// 713 ベリンダの髪型 
            714:"icon_hat_z018a.swf",	// 714 ベリンダの帽子
            715:"icon_shoes_z050a.swf",	// 715 ギュスターヴの靴
            716:"icon_skirt_z050a.swf",	// 716 ギュスターヴのパンツ
            717:"icon_blouse_z050a.swf",	// 717 ギュスターヴの服 
            718:"icon_mant_z050a.swf",	// 718 ギュスターヴのマント 
            719:"icon_hair_z050a.swf",	// 719 ギュスターヴの髪型 
            720:"icon_paint_z050a.swf",	// 720 ギュスターヴの印
            721:"icon_basket_z168a.swf",	// 721 ユハニの手提げ人形
            722:"icon_hairpin_a000c.swf",	// 722星の髪飾り
            723:"icon_hairpin_a000d.swf",	// 723星の髪飾り
            724:"icon_hair_z035a.swf",	// 724 ヴォランドの髪型
            725:"icon_shoes_x014a.swf",	// 725 金魚草履（赤） 
            726:"icon_dress_x014a.swf",	// 726 金魚和服（赤）
            727:"icon_hat_x014a.swf",	// 727 金魚の髪飾り（赤）
            728:"icon_shoes_x014b.swf",	// 728 金魚草履（黒） 
            729:"icon_dress_x014b.swf",	// 729 金魚和服（黒） 
            730:"icon_hat_x014b.swf",	// 730 金魚の髪飾り（黒）
            731:"icon_hat_z173a.swf",	// 731 ベロニカの頭のせ人形
            732:"icon_basket_z170a.swf",	// 732 ラウルの手提げ人形
            733:"icon_hair_z013a.swf",	// 733 ベルンハルトの髪型
            734:"icon_hair_z014a.swf",	// 734 フリードリヒの髪型
            735:"icon_shoes_z062a.swf",	// 735 ヒューゴのブーツ
            736:"skirt_z062a.swf",	// 736 ヒューゴのトラウザ
            737:"icon_blouse_z062a.swf",	// 737 ヒューゴの上着
            738:"icon_shoes_z066a.swf",	// 738 エプシロンのブーツ
            739:"skirt_z066a.swf",	// 739 エプシロンのパンツ
            740:"icon_blouse_z066a.swf",	// 740 エプシロンの上着
            741:"icon_blouse_z066b.swf",	// 741 エプシロンの上着（マント付
            742:"icon_mant_z066a.swf",	// 742 エプシロンのマント
            743:"icon_paint_z014a.swf",	// 743 フリードリヒの傷
            744:"icon_shoes_z068a.swf",	// 744 ユハニのサンダル
            745:"icon_skirt_z068a.swf",	// 745 ユハニのパンツ
            746:"icon_blouse_z068a.swf",	// 746 ユハニの上着
            747:"icon_hair_z068a.swf",	// 747 ユハニの髪型
            748:"icon_hair_z010a.swf",	// 748 ブレイズの髪型
            749:"icon_basket_z171a.swf",	// 749 ジェミーの手提げ人形
            750:"icon_bag_a068a.swf",	// 750 ユハニの光剣（腰）
            751:"icon_lefthand_z068b.swf",	// 751 ユハニの光剣（右手） 
            752:"icon_lefthand_z004a.swf",	// 752 アベル柄の枕
            753:"icon_hat_z174a.swf",	// 753 リカルドの頭のせ人形
            754:"icon_basket_z172a.swf",	// 754 セルファースの手提げ人形
            755:"icon_hat_z176a.swf",	// 755 モーガンの頭のせ人形
            756:"icon_shoes_x015a.swf",	// 756 パンプス（黒）
            757:"icon_dress_x015a.swf",	// 757 喪服
            758:"icon_hat_x015a.swf",	// 758 トークハット
            759:"icon_hat_z055a.swf",	// 759 オウランの帽子（赤）
            760:"icon_dress_z055b.swf",	// 760 オウランのスーツ（白黒）
            761:"icon_hair_z055c.swf",	// 761 オウランのフード（白黒）
            762:"icon_hair_z001a.swf",	// 762 エヴァリストの髪型
            763:"icon_hair_z004a.swf",	// 763 アベルの髪型
            764:"icon_basket_z103b.swf",	// 764 グリュンワルドの手提げ人形（ハロウィン）
            765:"icon_hat_z101a.swf",	// 765 ダイス（金）
            766:"icon_hat_z175a.swf",	// 766 マリネラの頭のせ人形
            767:"icon_shoes_z053a.swf",	// 767 ナディーンのブーツ 
            768:"icon_skirt_z053a.swf",	// 768 ナディーンのパンツ 
            769:"icon_blouse_z053a.swf",	// 769 ナディーンの上着 
            770:"icon_hair_z053a.swf",	// 770 ナディーンの髪型 
            771:"icon_hair_z012a.swf",	// 771 アインの髪型 
            772:"icon_hat_z165a.swf",	// 772 レタの頭のせ人形
            773:"icon_basket_z173a.swf",	// 773 ベロニカの手提げ人形
            774:"icon_shoes_z064a.swf",		// 774 グレゴールの靴
            775:"icon_skirt_z064a.swf",		// 775 グレゴールのパンツ
            776:"icon_blouse_z064a.swf",		// 776 グレゴールの上着
            777:"icon_hair_z064a.swf",		// 777 グレゴールの髪型
            778:"icon_hair_z041b.swf",		// 778 ネネムの髪型（セミロング）
            779:"icon_basket_z174a.swf",	// 779 リカルドの手提げ人形
            780:"icon_shoes_z075a.swf",		// 780 マリネラの靴
            781:"icon_skirt_z075a.swf",		// 781 マリネラのパンツ
            782:"icon_blouse_z075a.swf",		// 782 マリネラの上着
            783:"icon_hair_z075a.swf",		// 783 マリネラの髪型
            784:"icon_hair_z006a.swf",		// 784 クレーニヒの髪型
            785:"icon_basket_z176a.swf",	// 785 モーガンの手提げ人形
            786:"icon_basket_z175a.swf",	// 786 マリネラの手提げ人形
            787:"icon_shoes_z071a.swf",		// 787 ジェミーの靴
            788:"icon_skirt_z071a.swf",		// 788 ジェミーのパンツ
            789:"icon_blouse_z071a.swf",	// 789 ジェミーの上着
            790:"icon_hair_z071a.swf",		// 790 ジェミーの髪型
            791:"icon_hair_z015a.swf",		// 791 マルグリッド髪型
            792:"icon_paint_z071a.swf",		// 792 ジェミーの縫合痕
            793:"icon_hat_z167a.swf",		// 793 ポレット頭のせ人形
            794:"icon_basket_z177a.swf",	// 794 ジュディスの手提げ人形
            795:"icon_hair_z037a.swf",		// 795 コッブの髪型
            796:"icon_hair_z074a.swf",		// 796 リカルド髪型
            797:"icon_shoes_z074a.swf",		// 797 リカルドの靴
            798:"icon_skirt_z074a.swf",		// 798 リカルドのスラックス
            799:"icon_blouse_z074a.swf",	// 799 リカルドのベスト
            800:"icon_hat_z205b.swf",		// 800 レオン座り
            801:"icon_hat_z177a.swf",		// 801 ジュディスの頭のせ人形
            802:"icon_hat_z204b.swf",		// 802 アベルの座り人形
            803:"icon_blouse_z036b.swf",		// 803 C.C.の部屋着
            804:"icon_skirt_z050b.swf",		// 804 ギュスターヴの礼服（下）
            805:"icon_blouse_z050b.swf",		// 805 ギュスターヴの礼服（上）
            806:"icon_hair_z011a.swf",		// 806 シェリ髪型
            807:"icon_hair_z024a.swf",		// 807 リーズ髪型
            1000:"icon_fairy_m000c.swf",	// 1000 デバッグ用
            1001:"icon_fairy_m000c.swf",	// 1001 デバッグ用
            1002:"icon_fairy_m000c.swf",	// 1002 デバッグ用
            1003:"icon_fairy_m000c.swf",	// 1003 デバッグ用
            1004:"icon_fairy_m000c.swf",	// 1004 デバッグ用
            1005:"icon_fairy_m000c.swf",	// 1005 デバッグ用
            2000:"icon_fairy_m000c.swf",	// 2000 韓国UL用
            2001:"icon_fairy_m000c.swf",	// 2001 韓国UL用
            2002:"icon_fairy_m000c.swf",	// 2002 韓国UL用
            2003:"icon_fairy_m000c.swf",	// 2003 韓国UL用
            2004:"icon_fairy_m000c.swf",	// 2004 韓国UL用
            2005:"icon_fairy_m000c.swf",	// 2005 韓国UL用
            2006:"icon_fairy_m000c.swf",	// 2006 韓国UL用
            2007:"icon_fairy_m000c.swf",	// 2007 韓国UL用
            2008:"icon_fairy_m000c.swf",	// 2008 韓国UL用
            2009:"icon_fairy_m000c.swf",		// 2009 韓国UL用
            2014:"kr_icon_hat_z002a.swf"		// 2009 韓国UL用
        };
        /**
         * コンストラクタ
         *
         */
        public function AvatarPartIconImage(id:int = 0)
        {
            var u:String;
            if (URLSet[id]!=null&&URLSet[id]!="")
            {
//                log.writeLog(log.LV_WARN, this, "exist part icon.", id);
                u = URL+URLSet[id];
            }else{
//                log.writeLog(log.LV_WARN, this, "not exist part icon.", id);
                u = URL+URLSet[1];
            }
            super(u);
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
//            log.writeLog(log.LV_WARN, this, "load icon.");
        }

    }
}
