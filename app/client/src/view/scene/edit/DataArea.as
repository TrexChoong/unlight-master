package view.scene.edit
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import flash.filters.GlowFilter;

    import mx.core.UIComponent;
    import mx.controls.Text;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.scene.BaseScene;
    import view.scene.common.*;
    import view.utils.*;

    import controller.LobbyCtrl;

    import model.*;
    import model.events.*;
    import model.utils.*;

    /**
     * エディット画面のデータ部分のクラス
     *
     */
    public class DataArea extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_NAME		:String = "カードの名前です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_ENAME		:String = "カードの英名です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_ONAME		:String = "カードの異名です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_CVNAME		:String = "キャラクターのボイスを担当した声優名です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_LV		:String = "カードのレベルです。\nカードの成長度を表します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_HP		:String = "カードのヒットポイントです。\nカードの耐久力に影響します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_ATK		:String = "カードの攻撃力です。\n攻撃ダイスの数に影響します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_DEF		:String = "カードの防御力です。\n防御ダイスの数に影響します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_RARE		:String = "カードのレアリティです。\n数値が大きいほど入手が困難です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_MSG		:String = "カードの説明です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_STAT		:String = "カードの属性です。\nデッキ編集に影響します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_COST		:String = "カードのデッキコストです。\nデッキ編集に影響します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_TIMING		:String = "";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_POW		:String = "カードの耐久度です。\n0になると消滅します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_LIMITC		:String = "カードのキャラ制限です。\nデッキ編集に影響します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD_LIMITLV	:String = "カードのレベル制限です。\nレベル条件をクリアしたキャラカードに装備できます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_DUPE_COUNT		:String = "所持数";

        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_NAME		:String = "The name of the card.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_ENAME		:String = "";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_ONAME		:String = "The card's nickname.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_CVNAME		:String = "The name of the voice actor playing one character.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_LV		:String = "The card's level, indicating the degree of growth and development of the card.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_HP		:String = "The card's hit points, it influences the stamina of this card.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_ATK		:String = "The card's attack power.\nAttack power is used to calculate the number of attack dice contributed by this card.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_DEF		:String = "The card's defensive power.\nDefensive power is used to calculate the number of defensive dice contributed by this card.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_RARE		:String = "The card's rarity.\nThe higher the number the harder the card is to obtain.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_MSG		:String = "The card's description.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_STAT		:String = "The card's attributes.\nCard attributes influence the deck editing process.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_COST		:String = "The cost of your deck.\nDeck cost is determined by the contents of your deck, and affects which battle rooms you can enter.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_TIMING		:String = "";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_POW		:String = "The character card's durability.\nThe card will disappear forever if this reaches zero.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_LIMITC		:String = "The card's character requirement.\nCharacter requirements influence the deck editing process.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD_LIMITLV	:String = "The card's level requirement.\nYou can only equip this card on a character which meets this requirement.";
        CONFIG::LOCALE_EN
        private static const _TRANS_DUPE_COUNT		:String = "Owned";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_NAME		:String = "卡片的名稱";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_ENAME		:String = "卡片的英文名稱";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_ONAME		:String = "卡片的稱號";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_CVNAME		:String = "擔任角色配音的聲優名。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_LV		:String = "卡片的等級。\n卡片的成長度";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_HP		:String = "卡片的生命值。\n影響卡片的耐久力。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_ATK		:String = "卡片的攻擊力。\n影響攻擊骰的數量。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_DEF		:String = "卡片的防禦力。\n影響防禦骰的數量。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_RARE		:String = "卡片的稀有度。\n數值越大越難獲得。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_MSG		:String = "卡片的說明。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_STAT		:String = "卡片屬性。\n影響牌組編輯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_COST		:String = "卡片的牌組需求值。\n影響牌組編輯。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_TIMING		:String = "";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_POW		:String = "卡片的耐久力。\n變成0的時消滅。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_LIMITC		:String = "卡片的角色限制。\n影響牌組編輯";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD_LIMITLV	:String = "卡片的等級限制。\n滿足條件的角色卡才能裝備。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DUPE_COUNT		:String = "持有數";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_NAME		:String = "卡片的名称。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_ENAME		:String = "卡片的英文名称。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_ONAME		:String = "卡片的别名。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_CVNAME		:String = "担任角色配音的声优名。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_LV		:String = "卡片的等级。\n显示卡片的成长度。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_HP		:String = "卡片的体力值。\n对卡片的耐久力有影响。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_ATK		:String = "卡片的攻击力。\n对攻击骰子的数值有影响。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_DEF		:String = "卡片的防御力。\n对防御骰子的数值有影响。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_RARE		:String = "卡片的稀有度。\n数值越大就越难获得。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_MSG		:String = "卡片的说明。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_STAT		:String = "卡片的属性。\n对卡组编辑有影响。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_COST		:String = "卡片的卡组成本。\n对卡组编辑有影响。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_TIMING		:String = "";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_POW		:String = "卡片的耐久度。\n耐久度为0时无效。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_LIMITC		:String = "卡片的角色限制。\n对卡组编辑有影响。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD_LIMITLV	:String = "卡片的等级限制。\n可用于满足等级条件的角色卡。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DUPE_COUNT		:String = "持有数";

        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_NAME		:String = "카드의 이름 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_ENAME		:String = "카드의 영문 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_ONAME		:String = "카드의 이명 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_CVNAME		:String = "キャラクターのボイスを担当した声優名です。";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_LV		:String = "카드의 레벨 입니다.\n카드의 성장도를 표시합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_HP		:String = "카드의 히트 포인트  입니다.\n카드의 내구력에 영향을 미칩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_ATK		:String = "카드의 공격력 입니다.\n공격 주사위의 수에 영향을 미칩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_DEF		:String = "카드의 방어력 입니다.\n방어 주사위의 수에 영향을 미칩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_RARE		:String = "카드의 레어도 입니다.\n수치가 높을 수록 입수가 곤란합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_MSG		:String = "카드의 설명 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_STAT		:String = "카드의 속성 입니다.\n덱 편집에 영향을 미칩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_COST		:String = "카드의 덱 코스트입니다.\n덱 편집에 영향을 미칩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_TIMING		:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_POW		:String = "카드의 내구도 입니다.\n0이 되면 소멸합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_LIMITC		:String = "카드의 캐릭 제한 입니다.\n덱 편집에 영향을 미칩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD_LIMITLV	:String = "카드의 레벨 제한 입니다.\n레벨 조건을 클리어한 캐릭 카드를 장비할 수 있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_DUPE_COUNT		:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_NAME		:String = "Nom de la Carte";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_ENAME		:String = "Nom de la Carte";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_ONAME		:String = "Surnom de la Carte";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_CVNAME		:String = "キャラクターのボイスを担当した声優名です。";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_LV		:String = "Niveau\nafficher le niveau de la Carte";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_HP		:String = "HP\nindique l'endurance de la Carte";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_ATK		:String = "Point d'Attaque du Personnage.\nDétermine le nombre de fois que vous pouvez lancer les dés pendant la Phase d'Attaque.";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_DEF		:String = "Point de Défense du Personnage.\nDétermine le nombre de fois que vous pouvez lancer les dés pendant la Phase de Défense.";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_RARE		:String = "Rareté\nplus le chiffre est élevé et plus la carte est difficile à trouver.";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_MSG		:String = "Explications de la Carte";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_STAT		:String = "Statistiques\ndétermine la modification de votre pioche";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_COST		:String = "Coût de la pioche\ninfluence vos possibilités de modification de votre pioche";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_TIMING		:String = "";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_POW		:String = "HP d'une carte personnage\nle personnage disparaît lorsqu'il n'a plus d'HP";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_LIMITC		:String = "Limites du personnage\ninfluence vos possiblités de modification de votre pioche";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD_LIMITLV	:String = "Condition requise pour mise à niveau\nvous pouvez combiner cette carte à votre personnage seulement si le niveau de ce dernier remplit les conditions de l'objet..";
        CONFIG::LOCALE_FR
        private static const _TRANS_DUPE_COUNT		:String = "";

        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_NAME		:String = "カードの名前です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_ENAME		:String = "カードの英名です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_ONAME		:String = "カードの異名です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_CVNAME		:String = "キャラクターのボイスを担当した声優名です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_LV		:String = "カードのレベルです。\nカードの成長度を表します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_HP		:String = "カードのヒットポイントです。\nカードの耐久力に影響します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_ATK		:String = "カードの攻撃力です。\n攻撃ダイスの数に影響します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_DEF		:String = "カードの防御力です。\n防御ダイスの数に影響します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_RARE		:String = "カードのレアリティです。\n数値が大きいほど入手が困難です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_MSG		:String = "カードの説明です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_STAT		:String = "カードの属性です。\nデッキ編集に影響します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_COST		:String = "カードのデッキコストです。\nデッキ編集に影響します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_TIMING		:String = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_POW		:String = "カードの耐久度です。\n0になると消滅します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_LIMITC		:String = "カードのキャラ制限です。\nデッキ編集に影響します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD_LIMITLV	:String = "カードのレベル制限です。\nレベル条件をクリアしたキャラカードに装備できます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_DUPE_COUNT		:String = "所持数";

        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_NAME       :String = "ชื่อการ์ด";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_ENAME      :String = "ชื่อภาษาอังกฤษ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_ONAME      :String = "ชื่ออื่นๆ ของการ์ด";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_CVNAME     :String = ""; // キャラクターのボイスを担当した声優名です。
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_LV         :String = "เลเวลของการ์ด ";//"カードのレベルです。\nカードの成長度を表します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_HP         :String = "HP ของการ์ด\nแสดงค่าพลังชีวิตของการ์ดตัวละคร";//"カードのヒットポイントです。\nカードの耐久力に影響します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_ATK        :String = "พลังโจมตีของการ์ด\nจะมีผลในการทอยลูกเต๋าโจมตี";//"カードの攻撃力です。\n攻撃ダイスの数に影響します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_DEF        :String = "พลังป้องกันของการ์ด\nจะมีผลในการทอยลูกเต๋าป้องกัน";//"カードの防御力です。\n防御ダイスの数に影響します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_RARE       :String = "ระดับความหายากของการ์ด\nยิ่งตัวเลขมากก็จะยิ่งหายากตามไปด้วย";//"カードのレアリティです。\n数値が大きいほど入手が困難です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_MSG        :String = "อธิบายการ์ด";//"カードの説明です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_STAT       :String = "ธาตุของการ์ด\nจะมีผลกับการจัดสำรับการ์ด";//"カードの属性です。\nデッキ編集に影響します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_COST       :String = "Deck Cost\nจะมีผลในการจัดสำรับ";//"カードのデッキコストです。\nデッキ編集に影響します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_TIMING     :String = "เวลาที่ควรใช้การ์ด";//"カードの使用タイミングです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_POW        :String = "พลังชีวิตของการ์ด\nหากเป็น 0 แล้วจะหายไป";//"カードの耐久度です。\n0になると消滅します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_LIMITC     :String = "ขีดจำกัดของคาแรกเตอร์การ์ด\nมีผลในการจัดสำรับ";//"カードのキャラ制限です。\nデッキ編集に影響します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD_LIMITLV    :String = "เลวลที่ต้องการของการ์ด\nติดตั้งกับการ์ดที่เคลียร์เงื่อนไขเลเวลผ่านแล้ว";//"カードのレベル制限です。\nレベル条件をクリアしたキャラカードに装備できます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_DUPE_COUNT      :String = "จำนวนที่ครอบครองอยู่";


        // model
        private var _deckEditor:DeckEditor = DeckEditor.instance;

        // 実体
        private var _ccc:*;                       // 選択中のカード
        private var _textSet:Array = [];          // Array of String
        private var _status:Array = [];           // Array of Text

        // 定数
        private static const _CARD_X:int = 580;          // カードの初期位置X
        private static const _CARD_Y:int = 38;           // カードの初期位置Y
        private static const _STATE_WIDTH:int = 125;     // テキストの縦幅
        private static const _STATE_HEIGHT:int = 170;    // テキストの横幅

        private static const _DUPE_COUNT_X:int = 553;     // 複製チケット数表示
        private static const _DUPE_COUNT_Y:int = 639;     // 複製チケット数表示
        private static const _DUPE_COUNT_WIDTH:int = 128; // 複製チケット幅
        private static const _DUPE_COUNT_HEIGHT:int = 32; // 複製チケット高さ

        // コントローラ
        private var _ctrl:LobbyCtrl = LobbyCtrl.instance;

        private var _cccDic:Dictionary;                  // Dictionary of CCC Key:CharaCard
        private var _selectCardInventory:ICardInventory;  // 選択したカードのインベントリ

//         // 名前、英名、異名、レベル、HP、攻撃力、防御力、レアリティ、ID、プロフ
//         private static const _STATE_X_SET:Vector.<int> = Vector.<int>([799, 799, 799, 799, 884, 799, 884, 811, 811, 774]); // テキストのX位置
//         private static const _STATE_Y_SET:Vector.<int> = Vector.<int>([353, 371, 389, 413, 413, 431, 431, 449, 467, 498]); // テキストのY位置
//         private static const _STATE_W_SET:Vector.<int> = Vector.<int>([125, 125, 125,  40,  40,  40,  40, 112, 112, 136]); // テキストのX位置
//         private static const _STATE_H_SET:Vector.<int> = Vector.<int>([ 16,  16,  16,  16,  16,  16,  16,  16,  49, 62]); // テキストのY位置

        // // 名前、英名、異名、レベル、HP、攻撃力、防御力、レアリティ、ID、プロフ
        CONFIG::CHARA_COST_DRAW_OFF
        private static const _STATE_X_SET:Array = [ [622, 622, 622, 622, 707, 622, 707, 634, 634, 597],
                                                    [636, 636, 636, 636, 636, 636, 636, 597],
                                                    [636, 636, 636, 636, 636, 636, 636, 597],
                                                    [636, 636, 636, 636, 636, 636, 636, 597],
                                                    [622, 622, 622, 622, 707, 622, 707, 634, 634, 597],
                                                    [622, 622, 622, 622, 707, 622, 707, 634, 634, 597],]; // テキストのX位置
        CONFIG::CHARA_COST_DRAW_OFF
        private static const _STATE_Y_SET:Array = [ [342, 360, 389, 418, 418, 436, 436, 454, 472, 498],
                                                    [342, 360, 389, 407, 425, 443, 461, 498],
                                                    [342, 360, 389, 407, 425, 443, 461, 498],
                                                    [342, 360, 389, 407, 425, 443, 461, 498],
                                                    [342, 360, 389, 418, 413, 436, 436, 454, 472, 498],
                                                    [342, 360, 389, 418, 418, 436, 436, 454, 472, 498], ]; // テキストのY位置
        CONFIG::CHARA_COST_DRAW_OFF
        private static const _STATE_W_SET:Array = [ [125, 125, 125,  40,  40,  40,  40, 112, 112, 136],
                                                    [125, 125, 125, 125, 125, 125, 125, 136],
                                                    [125, 125, 125, 125, 125, 125, 125, 136],
                                                    [125, 125, 125, 125, 125, 125, 125, 136],
                                                    [125, 125, 125,  40,  40,  40,  40, 112, 112, 136],
                                                    [125, 125, 125,  40,  40,  40,  40, 112, 112, 136], ]; // テキストのX位置
        CONFIG::CHARA_COST_DRAW_OFF
        private static const _STATE_H_SET:Array = [ [ 16,  16,  16,  16,  16,  16,  16,  16,  49, 62],
                                                    [ 16,  16,  16,  16,  16,  16,  16,  62],
                                                    [ 16,  16,  16,  16,  16,  16,  16,  62],
                                                    [ 16,  16,  16,  16,  16,  16,  16,  62],
                                                    [ 16,  16,  16,  16,  16,  16,  16,  16,  49, 62],
                                                    [ 16,  16,  16,  16,  16,  16,  16,  16,  49, 62], ]; // テキストのY位置

        // 名前、英名、異名、CV、レベル、HP、攻撃力、防御力、レアリティ、コスト、ID、プロフ
        CONFIG::CHARA_COST_DRAW_ON
        private static const _STATE_X_SET:Array = [ [622, 622, 622, 622, 622, 707, 622, 707, 622, 707, 630, 597],
                                                    [636, 636, 636, 636, 636, 636, 636, 597],
                                                    [636, 636, 636, 636, 636, 636, 636, 597],
                                                    [636, 636, 636, 636, 636, 636, 636, 597],
                                                    [622, 622, 622, 622, 622, 707, 622, 707, 622, 707, 630, 597],
                                                    [622, 622, 622, 622, 622, 707, 622, 707, 622, 707, 630, 597],]; // テキストのX位置
        CONFIG::CHARA_COST_DRAW_ON
        private static const _STATE_Y_SET:Array = [ [342, 360, 378, 396, 418, 418, 436, 436, 454, 454, 472, 508],
                                                    [342, 360, 378, 450, 396, 414, 432, 490],
                                                    [342, 360, 378, 450, 396, 414, 432, 498],
                                                    [342, 360, 378, 450, 396, 414, 432, 498],
                                                    [342, 360, 378, 396, 418, 418, 436, 436, 454, 454, 472, 508],
                                                    [342, 360, 378, 396, 418, 418, 436, 436, 454, 454, 472, 508], ]; // テキストのY位置
        CONFIG::CHARA_COST_DRAW_ON
        private static const _STATE_W_SET:Array = [ [125, 125, 125, 125,  40,  40,  40,  40, 40, 40, 112, 136],
                                                    [125, 125, 125, 125, 125, 125, 125, 136],
                                                    [125, 125, 125, 125, 125, 125, 125, 136],
                                                    [125, 125, 125, 125, 125, 125, 125, 136],
                                                    [125, 125, 125, 125,  40,  40,  40,  40, 40, 40, 112, 136],
                                                    [125, 125, 125, 125,  40,  40,  40,  40, 40, 40, 112, 136], ]; // テキストのX位置
        CONFIG::CHARA_COST_DRAW_ON
        private static const _STATE_H_SET:Array = [ [ 16,  16,  16,  16,  16,  16,  16,  16,  16, 16, 49, 62],
                                                    [ 16,  16,  16,  16,  16,  16,  16,  62],
                                                    [ 16,  16,  16,  16,  16,  16,  16,  62],
                                                    [ 16,  16,  16,  16,  16,  16,  16,  62],
                                                    [ 16,  16,  16,  16,  16,  16,  16,  16,  16, 16, 49, 62],
                                                    [ 16,  16,  16,  16,  16,  16,  16,  16,  16, 16, 49, 62], ]; // テキストのY位置

        private var _storyButton:SimpleButton;
        private var _compoButton:SimpleButton;
        private var _dupeButton:SimpleButton;

        // 所持数表示
        private var _dupeCount:Text = new Text();

        // チップヘルプの設定（上記HELPステート分必要）
        CONFIG::CHARA_COST_DRAW_OFF
        private var  _helpTextArray:Array =
            [
//                ["カードの名前です。",
//                 "カードの英名です。",
//                 "カードの異名です。",
//                 "キャラクターのボイスを担当した声優名です。",
//                 "カードのレベルです。\nカードの成長度を表します。",
//                 "カードのヒットポイントです。\nカードの耐久力に影響します。",
//                 "カードの攻撃力です。\n攻撃ダイスの数に影響します。",
//                 "カードの防御力です。\n防御ダイスの数に影響します。",
//                 "カードのレアリティです。\n数値が大きいほど入手が困難です。",
//                 "カードの説明です。",
                [_TRANS_CARD_NAME,
                 _TRANS_CARD_ENAME,
                 _TRANS_CARD_ONAME,
                 _TRANS_CARD_CVNAME,
                 _TRANS_CARD_LV,
                 _TRANS_CARD_HP,
                 _TRANS_CARD_ATK,
                 _TRANS_CARD_DEF,
                 _TRANS_CARD_RARE,
                 _TRANS_CARD_MSG,
                 ],
//                ["カードの名前です。",
//                 "カードの属性です。\nデッキ編集に影響します。",
//                 "カードのデッキコストです。\nデッキ編集に影響します。",
//                 "カードの使用タイミングです。",
//                 "カードの耐久度です。\n0になると消滅します。",
//                 "カードのキャラ制限です。\nデッキ編集に影響します。",
//                 "カードのレベル制限です。\nレベル条件をクリアしたキャラカードに装備できます。",
//                 "カードの説明です。",
                [_TRANS_CARD_NAME,
                 _TRANS_CARD_STAT,
                 _TRANS_CARD_COST,
                 _TRANS_CARD_TIMING,
                 _TRANS_CARD_POW,
                 _TRANS_CARD_LIMITC,
                 _TRANS_CARD_LIMITLV,
                 _TRANS_CARD_MSG,
                 ],
            ];
        CONFIG::CHARA_COST_DRAW_ON
        private var  _helpTextArray:Array =
            [
//                ["カードの名前です。",
//                 "カードの英名です。",
//                 "カードの異名です。",
//                 "キャラクターのボイスを担当した声優名です。",
//                 "カードのレベルです。\nカードの成長度を表します。",
//                 "カードのヒットポイントです。\nカードの耐久力に影響します。",
//                 "カードの攻撃力です。\n攻撃ダイスの数に影響します。",
//                 "カードの防御力です。\n防御ダイスの数に影響します。",
//                 "カードのレアリティです。\n数値が大きいほど入手が困難です。",
//                 "カードの説明です。",
                [_TRANS_CARD_NAME,
                 _TRANS_CARD_ENAME,
                 _TRANS_CARD_ONAME,
                 _TRANS_CARD_CVNAME,
                 _TRANS_CARD_LV,
                 _TRANS_CARD_HP,
                 _TRANS_CARD_ATK,
                 _TRANS_CARD_DEF,
                 _TRANS_CARD_RARE,
                 _TRANS_CARD_COST,
                 _TRANS_CARD_MSG,
                 ],
//                ["カードの名前です。",
//                 "カードの属性です。\nデッキ編集に影響します。",
//                 "カードのデッキコストです。\nデッキ編集に影響します。",
//                 "カードの使用タイミングです。",
//                 "カードの耐久度です。\n0になると消滅します。",
//                 "カードのキャラ制限です。\nデッキ編集に影響します。",
//                 "カードのレベル制限です。\nレベル条件をクリアしたキャラカードに装備できます。",
//                 "カードの説明です。",
                [_TRANS_CARD_NAME,
                 _TRANS_CARD_STAT,
                 _TRANS_CARD_COST,
                 _TRANS_CARD_TIMING,
                 _TRANS_CARD_POW,
                 _TRANS_CARD_LIMITC,
                 _TRANS_CARD_LIMITLV,
                 _TRANS_CARD_MSG,
                 ],
            ];

        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _EDIT_HELP:int = 0;
        private const _WEAPON_HELP:int = 1;
        private const _EVENT_HELP:int = 2;

        // デッキエリアのタイプ
        private var _type:int;

        public static function getCharaCardData():DataArea
        {
            log.writeLog(log.LV_INFO, "chara card data");
            return new DataArea(InventorySet.TYPE_CHARA);
        }
        public static function getWeaponCardData():DataArea
        {
            log.writeLog(log.LV_INFO, "weapon card data");
            return new DataArea(InventorySet.TYPE_WEAPON);
        }
        public static function getEquipCardData():DataArea
        {
            log.writeLog(log.LV_INFO,  "equip card data");
            return new DataArea(InventorySet.TYPE_EQUIP);
        }
        public static function getEventCardData():DataArea
        {
            log.writeLog(log.LV_INFO,  "equip card data");
            return new DataArea(InventorySet.TYPE_EVENT);
        }
        public static function getMonsterCardData():DataArea
        {
            log.writeLog(log.LV_INFO, "monster card data");
            return new DataArea(InventorySet.TYPE_MONSTER);
        }
        public static function getOtherCardData():DataArea
        {
            log.writeLog(log.LV_INFO, "other card data");
            return new DataArea(InventorySet.TYPE_OTHER);
        }


        /**
         * コンストラクタ
         *
         */
        public function DataArea(type:int)
        {
            _type = type;

//             var cc:ICard = CharaCard.ID(0);
//             setCCC(cc);
//             _ccc = _cccDic[cc];
//             _ccc.visible = false;
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray = []
            _toolTipOwnerArray.push([0,_status[0]]);   //
            _toolTipOwnerArray.push([1,_status[1]]);   //
            _toolTipOwnerArray.push([2,_status[2]]);   //
            _toolTipOwnerArray.push([3,_status[3]]);   //
            _toolTipOwnerArray.push([4,_status[4]]);   //
            _toolTipOwnerArray.push([5,_status[5]]);   //
            _toolTipOwnerArray.push([6,_status[6]]);   //
            _toolTipOwnerArray.push([7,_status[7]]);   //
        }

        //
        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        // 初期化
        public override function init():void
        {
            _cccDic = new Dictionary();
//            Unlight.GCW.watch(_cccDic);
            visible = false;
            _deckEditor.addEventListener(EditCardEvent.SELECT_CARD, selectCardHandler);
//            _ctrl.addEventListener(CharaCardEvent.COPY_CHARA_CARD, reloadHandler);
            Combine.instance.addEventListener(CombineEvent.COMBINE_SUCCESS, combineSuccessHandler);

            log.writeLog(log.LV_INFO, this, "Data Area init!!");
            initDupeCount();
            addChild(_dupeCount);
        }

        // 後処理
        public override function final():void
        {
//            _ctrl.removeEventListener(CharaCardEvent.COPY_CHARA_CARD, reloadHandler);
            _deckEditor.removeEventListener(EditCardEvent.SELECT_CARD, selectCardHandler);
            Combine.instance.removeEventListener(CombineEvent.COMBINE_SUCCESS, combineSuccessHandler);

            if (_ccc != null && _type == InventorySet.TYPE_CHARA)
            {
                // ストーリーボタン設定済みなら
                if (_storyButton != null)
                {
                    _storyButton.removeEventListener(MouseEvent.CLICK, ccc.pushStoryHandler);
                }
                // 合成ボタン設定済みなら
                if (_compoButton != null)
                {
                    _compoButton.removeEventListener(MouseEvent.CLICK, pushRequirementsHandler);
                }
                // dupeボタン設定済みなら
                if (_dupeButton != null)
                {
                    _dupeButton.removeEventListener(MouseEvent.CLICK, pushDupeHandler);
                }
            }
            for (var key:Object in _cccDic)
            {
                _cccDic[key].getHideThread().start();
                delete _cccDic[key];
            }
            _cccDic = null;

            log.writeLog(log.LV_INFO, this, "Data Area final!!");
            removeChild(_dupeCount);
        }

        // カウント表示を初期化する
        private function initDupeCount():void
        {
            _dupeCount.x = _DUPE_COUNT_X;
            _dupeCount.y = _DUPE_COUNT_Y;
            _dupeCount.width = _DUPE_COUNT_WIDTH;
            _dupeCount.height = _DUPE_COUNT_HEIGHT;
            _dupeCount.text = _TRANS_DUPE_COUNT+AvatarItemInventory.getItemsNum(Const.COPY_CARD_TICKET);
            _dupeCount.styleName = "EditCharaCardParam";
            _dupeCount.filters = [new GlowFilter(0x111111, 1, 2, 2, 16, 1)];

            _dupeCount.visible = false;
        }


        private function pushRequirementsHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "requirements !!",_ccc,_deckEditor.editType,_type);
            if (_deckEditor.editType == InventorySet.TYPE_WEAPON) {
                // 武器の場合は、タイプが同一の時のみ対応
                if (_type == _deckEditor.editType) {
                    _deckEditor.save();
                    _ccc.pushRequirementsHandler(e);
                    SE.playClick();
                }
            } else {
                _deckEditor.save();
                _ccc.pushRequirementsHandler(e);
                SE.playClick();
            }
        }

        private function pushDupeHandler(e:MouseEvent):void
        {
            _ctrl.requestCopyCard();
//            _dupeButton.removeEventListener(MouseEvent.CLICK, pushDupeHandler);
            SE.playClick();
        }

        // 複製チケット更新
        public function reloadHandler(e:Event):void
        {
            _dupeCount.text = _TRANS_DUPE_COUNT+AvatarItemInventory.getItemsNum(Const.COPY_CARD_TICKET);
            dupeVisibleUpdate();
//            _dupeButton.addEventListener(MouseEvent.CLICK, pushDupeHandler);
        }
        // 複製チケット更新
        public function reloadDupeCount():void
        {
            _dupeCount.text = _TRANS_DUPE_COUNT+AvatarItemInventory.getItemsNum(Const.COPY_CARD_TICKET);
            dupeVisibleUpdate();
//            _dupeButton.addEventListener(MouseEvent.CLICK, pushDupeHandler);
        }
        private function dupeVisibleUpdate():void
        {
            if ( checkTypeChara() && _dupeButton != null && _ccc.charaCard.rarity < 6 && _ccc.charaCard.kind != Const.CC_KIND_RENTAL)
            {
                if (AvatarItemInventory.getItemsNum(Const.COPY_CARD_TICKET) == 0)
                {
                    _dupeCount.visible = false;
                    _dupeButton.visible = false;
                }
                else
                {
                    _dupeCount.visible = true;
                    _dupeButton.visible = true;
                }
            }
        }

        // DicにCharaCardClipを格納
        // ICardに変更
        private function setCCC(cc:ICard):void
        {
            var forceReload:Boolean = false;
            if (_type == InventorySet.TYPE_WEAPON) {
                forceReload = WeaponCard(cc).forceReload;
            }
            if (_cccDic[cc] ==null || forceReload)
            {
                // ここはタイプで分ける
                switch (_type)
                {
                case InventorySet.TYPE_CHARA:
                case InventorySet.TYPE_MONSTER:
                case InventorySet.TYPE_OTHER:
                    _cccDic[cc] = new CharaCardClip(CharaCard(cc));
                    break;
                case InventorySet.TYPE_WEAPON:
                    _cccDic[cc] = new WeaponCardClip(WeaponCard(cc));
                    break;
                case InventorySet.TYPE_EQUIP:
                    _cccDic[cc] = new EquipCardClip(EquipCard(cc));
                    break;
                case InventorySet.TYPE_EVENT:
                    _cccDic[cc] = new EventCardClip(EventCard(cc));
                    break;
                }
                _cccDic[cc].getShowThread(this).start();
                _cccDic[cc].visible = true;
//                 Unlight.GCW.watch(_cccDic[cc]);
            }
            else
            {
                _cccDic[cc].visible = false;
            }
        }

        // カード選択
        protected function selectCardHandler(e:EditCardEvent):void
        {
            if(_deckEditor.substanceEditType() == _type)
            {
                if(_ccc !=null)
                {
                    hideCard();
                }
                // ここはタイプで分ける
                switch (_type)
                {
                case InventorySet.TYPE_CHARA:
                case InventorySet.TYPE_MONSTER:
                case InventorySet.TYPE_OTHER:
                    loadCard(CharaCard.ID(e.index));
                    break;
                case InventorySet.TYPE_WEAPON:
                    loadCard(WeaponCard.ID(e.index));
                    break;
                case InventorySet.TYPE_EQUIP:
                    loadCard(EquipCard.ID(e.index));
                    break;
                case InventorySet.TYPE_EVENT:
                    loadCard(EventCard.ID(e.index));
                    break;
                }
                // 選択したインベントリを保持
                _selectCardInventory = e.cci;
                showCard();
            }
        }

        private function checkTypeChara(not:Boolean=false):Boolean
        {
            var check:Boolean = false;
            if (not) {
                check = (_type != InventorySet.TYPE_CHARA && _type != InventorySet.TYPE_MONSTER && _type != InventorySet.TYPE_OTHER);
            } else {
                check = (_type == InventorySet.TYPE_CHARA || _type == InventorySet.TYPE_MONSTER || _type == InventorySet.TYPE_OTHER);
            }
            return check;
        }

        // カードをロードする
        private function loadCard(cc:ICard):void
        {

            var cname:String = "";
            if (_dupeButton != null)
            {
                _dupeButton.visible = false;
                _dupeCount.visible = false;
            }

//             _ccc = new CharaCardClip(cc);
            setCCC(cc);
            _ccc = _cccDic[cc];
            _ccc.x = _CARD_X;
            _ccc.y = _CARD_Y;

            _status = [];

            log.writeLog(log.LV_DEBUG, this ,"loadCard",cc);
            log.writeLog(log.LV_DEBUG, this ,"loadCard",cc.id,cc.restriction);
            if (checkTypeChara(true))
            {
                if (Const.CHARA_GROUP_NAME.hasOwnProperty(cc.restriction[0]))
                {
                    cname = Const.CHARA_GROUP_NAME[cc.restriction[0]]
                }
                else if (cc.restriction[0].split("|")[0] != "")
                {
                    var names:Array = [];
                    var name_tmp:String = "";
                    cc.restriction.forEach(function(item:*, index:int, ary:Array):void{
                            name_tmp = Const.CHARACTOR_NAME[item].replace(/\s*\(.+\)$/, "");
                            if (names.indexOf(name_tmp) < 0)
                            {
                                names.push(name_tmp);
                            }
                        });
                    cname = names.join();
                }
            }
            else
            {
                cname = "-";
            }

            // ここはタイプで分ける
            switch (_type)
            {
            case InventorySet.TYPE_CHARA:
            case InventorySet.TYPE_MONSTER:
            case InventorySet.TYPE_OTHER:
                // 名前、英名、異名、レベル、HP、攻撃力、防御力、レアリティ、ID、プロフ
                CONFIG::CHARA_COST_DRAW_OFF {
                    _textSet = [cc.name, CharaCard(cc).englishName, CharaCard(cc).titleName, cc.level, cc.hp, cc.ap, cc.dp, cc.rarity, cc.id, cc.caption ];
                }
                // 名前、英名、異名、CV、レベル、HP、攻撃力、防御力、レアリティ、コスト、ID、プロフ
                CONFIG::CHARA_COST_DRAW_ON {
                    var cv:String = "";
                    if ((cc.kind == Const.CC_KIND_CHARA && cc.rarity > 5) || cc.kind == Const.CC_KIND_EPISODE)
                    {
                        cv = ConstData.getData(ConstData.CHARACTOR, CharaCard(cc).charactor)[3];
                    }
                    _textSet = [cc.name, CharaCard(cc).englishName, CharaCard(cc).titleName, cv, cc.level, cc.hp, cc.ap, cc.dp, cc.rarity, cc.cost, cc.id, cc.caption ];
                }
                break;
            case InventorySet.TYPE_WEAPON:
                // 名前、属性、コスト、タイミング、耐久度、キャラ制限、LV制限、効果
                _textSet = [cc.name, cc.color, cc.cost, "-", "-", cname, "-", cc.caption ];
                break;
            case InventorySet.TYPE_EQUIP:
                // 名前、属性、コスト、タイミング、耐久度、キャラ制限、LV制限、効果
                _textSet = [cc.name, cc.color, cc.cost, "-", "-", cname, "-", cc.caption ];
                break;
            case InventorySet.TYPE_EVENT:
                // 名前、属性、コスト、タイミング、耐久度、キャラ制限、LV制限、効果
                _textSet = [cc.name, cc.color, cc.cost, "-", "-", cname, "-", cc.caption ];
                break;
            }

            _textSet.forEach(function(item:*, index:int, array:Array):void{initState(item, index)});

            if (checkTypeChara(true))
//            if (_type != InventorySet.TYPE_CHARA)
            {
                _status.forEach(function(item:*, index:int, array:Array):void{if(index == 1){initColorString(item)}});
            }

            initilizeToolTipOwners();
            // ここはタイプで分ける
            switch (_type)
            {
            case InventorySet.TYPE_CHARA:
            case InventorySet.TYPE_MONSTER:
            case InventorySet.TYPE_OTHER:
                updateHelp(_EDIT_HELP);
                break;
            case InventorySet.TYPE_WEAPON:
                updateHelp(_WEAPON_HELP);
                break;
            case InventorySet.TYPE_EQUIP:
                updateHelp(_WEAPON_HELP);
                break;
            case InventorySet.TYPE_EVENT:
                updateHelp(_WEAPON_HELP);
                break;
            }

            // ストーリーボタンが設定済みのとき
            if (checkTypeChara() && _storyButton != null)
            {
                // ストーリボタンを見せる
                _storyButton.visible = cc.bookExist;
            }
            // 合成ボタンが設定済みのとき
            if (checkTypeChara() && _compoButton != null)
            {
                _compoButton.visible  = CharaCard(cc).isCompositable
            }
            // dupeボタンが設定済みのとき
            if (checkTypeChara() && _dupeButton != null)
            {
                // dupeボタンを見せる
                if (cc.rarity <= 5)
                {
                    dupeVisibleUpdate();
                }
                else
                {
                    _dupeButton.visible = false;
                    _dupeCount.visible = false;
                }
            }
        }

        // 表示ステートを初期化する
        private function initState(str:String, index:int):void
        {
            _status.push(new Text());
            _status[index].x = _STATE_X_SET[_type][index];
            _status[index].y = _STATE_Y_SET[_type][index];
            _status[index].width = _STATE_W_SET[_type][index];
            _status[index].height = _STATE_H_SET[_type][index];
            _status[index].text = str;
            if (index > 3 || str.length <= 15)
            {
                _status[index].styleName = "EditCharaCardParam";
            }
            else
            {
                _status[index].styleName = "EditCharaCardParamSmall";
            }
        }

        // 表示ステートを初期化する
        private function initColorString(text:Text):void
        {
            switch (text.text)
            {
            case "0":
                text.text = "NONE"
                break;
            case "1":
                text.text = "WHITE"
                break;
            case "2":
                text.text = "BLACK"
                break;
            case "3":
                text.text = "RED"
                break;
            case "4":
                text.text = "GREEN"
                break;
            case "5":
                text.text = "BLUE"
                break;
            case "6":
                text.text = "YELLOW"
                break;
            case "7":
                text.text = "PURPLE"
                break;
            }
        }

        // カードの表示を隠す
        public function hideCard():void
        {
            if(_ccc!=null)
            {
                _ccc.visible = false;
                _status.forEach(function(item:*, index:int, array:Array):void{RemoveChild.apply(item)});
                // ストーリーボタン設定済みなら
                if ( _storyButton != null)
                {
                    _storyButton.removeEventListener(MouseEvent.CLICK, _ccc.pushStoryHandler);
                }
                // 合成ボタン設定済みなら
                if ( _compoButton != null)
                {
                    _compoButton.removeEventListener(MouseEvent.CLICK, pushRequirementsHandler);
                }
                // dupeボタン設定済みなら
                if ( _dupeButton != null)
                {
                    _dupeButton.removeEventListener(MouseEvent.CLICK, pushDupeHandler);
                }

                log.writeLog(log.LV_INFO, this, "HIDE CARD",_type);
            }
            if(_storyButton != null) {_storyButton.visible = false;};
            if(_dupeButton != null) {_dupeButton.visible = false;};
            if(_compoButton != null) {_compoButton.visible = false;};
        }

        // カードを表示する
        public function showCard():void
        {
            if(_ccc!=null)
            {
                log.writeLog(log.LV_INFO, this, "SHOW CARD",checkTypeChara());
                _ccc.visible = true;
                _status.forEach(function(item:*, index:int, array:Array):void{addChild(item)});
                // ストーリーボタン設定済みなら
                if (checkTypeChara() && _storyButton != null)
                {
                    _storyButton.visible = ccc.charaCard.bookExist;
                    _storyButton.addEventListener(MouseEvent.CLICK, _ccc.pushStoryHandler);
                }
                // 合成ボタン設定済みなら
                if (_compoButton != null)
                {
                    if ( checkTypeChara() ) {
                        _compoButton.visible = ccc.charaCard.isCompositable;
                    } else if ( usefulCompoBaseWeaponCard() ) {
                        _compoButton.visible = true;
                    }
                    _compoButton.addEventListener(MouseEvent.CLICK, pushRequirementsHandler);
                }
                // if (checkTypeChara() && _compoButton != null)
                // {
                //     _compoButton.visible = ccc.charaCard.isCompositable;
                //     _compoButton.addEventListener(MouseEvent.CLICK, pushRequirementsHandler);
                // }
                // dupeボタン設定済みなら
                if (checkTypeChara() && _dupeButton != null)
                {
                    dupeVisibleUpdate();
                    _dupeButton.addEventListener(MouseEvent.CLICK, pushDupeHandler);
                }
            }
        }

        // 選択中のカードは合成のベースに使用できるか
        private function usefulCompoBaseWeaponCard():Boolean
        {
            // 選択したインベントリがないなら不可
            if (_selectCardInventory == null) {
                return false;
            }

            // バインダーのカードじゃない場合、不可
            if (_selectCardInventory.index != 0) {
                return false;
            }

            // 選択したカードが素材なら不可
            if (WeaponCard(_selectCardInventory.card).weaponType == Const.WEAPON_TYPE_MATERIAL) {
                return false;
            }

            // 選択したカードが基本専用武器なら不可
            if (WeaponCard(_selectCardInventory.card).isNormalCharaSpecial) {
                return false;
            }

            return true;
        }

        private function combineSuccessHandler(e:CombineEvent):void
        {
            // 武器の場合のみ処理
            if (InventorySet.TYPE_WEAPON == _type) {
                hideCard();
                var wci:WeaponCardInventory = WeaponCardInventory.getInventory(Combine.instance.resultCardInvId);
                // 一度削除する
                if (_cccDic[wci.card]) {
                    _cccDic[wci.card].getHideThread().start();
                    delete _cccDic[wci.card];
                }
                setCCC(wci.card);
                _ccc = _cccDic[wci.card];
                _ccc.x = _CARD_X;
                _ccc.y = _CARD_Y;
            }
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage);
        }

        public function set compoButton(b:SimpleButton):void
        {
            _compoButton = b;
        }
        public function set storyButton(b:SimpleButton):void
        {
            _storyButton = b;
        }
        public function set dupeButton(b:SimpleButton):void
        {
            _dupeButton = b;
        }

        public function get ccc():CharaCardClip
        {
            return _ccc;
        }
        public function get dupeCount():Text
        {
            return _dupeCount;
        }

        public function clearCard():void
        {
            _ccc.getEditHideThread().start();
            _ccc = new CharaCardClip(CharaCard.ID(0));
            _ccc.visible = false;
            _compoButton.visible = false;
//            _selectCardInventory = null;
            for(var i:int = 0; i < _status.length; i++)
            {
              var x:Object = _status[i];
                x.text = ""
            }

//            Unlight.GCW.watch(_ccc);
        }

        public function resetCard():void
        {
            _ccc.visible = false;
            for(var i:int = 0; i < _status.length; i++)
            {
              var x:Object = _status[i];
                x.text = ""
            }
            _storyButton.visible = false;
            // dupeボタン設定済みなら
            if ( _dupeButton != null)
            {
                _dupeButton.visible = false;
            }
//            _selectCardInventory = null;
            _dupeCount.visible = false;
//            hideCard();
        }

        public function get selectInventory():ICardInventory
        {
            return _selectCardInventory;
        }

    }
}



import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.scene.edit.DataArea;
import view.BaseShowThread;
import view.BaseHideThread;

// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{

    public function ShowThread(da:DataArea, stage:DisplayObjectContainer)
    {
        super(da, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(da:DataArea)
    {
        super(da);
    }
}
