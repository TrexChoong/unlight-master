package model
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;

    import mx.core.UIComponent;

    import view.scene.BaseScene;
    import view.scene.common.CharaCardClip;

    import model.CharaCardInventory;
    import model.CharaCard;
    import model.Player;

    /**
     * 同じIDのカードをまとめると同時にソートの結果を保存するクラス
     *
     */
    public class InventorySet extends EventDispatcher
    {
        public static const TYPE_CHARA:int   = 0;       // 最初に表示するページの番号
        public static const TYPE_WEAPON:int  = 1;       // 最初に表示するページの番号
        public static const TYPE_EQUIP:int   = 2;       // 最初に表示するページの番号
        public static const TYPE_EVENT:int   = 3;       // 最初に表示するページの番号
        public static const TYPE_MONSTER:int = 4;       // 最初に表示するページの番号
        public static const TYPE_OTHER:int   = 5;       // 最初に表示するページの番号

        private static var __inventories:Array = [[],[],[],[],[],[]];  // Array of InventorySet
        private  static var __type:int = 0;  // Array of InventorySet

        private var _invList:Array = [];           // Array of CharaCardInventory
        private var _card:ICard;

        // 初期化(ここにタイプをつける)
        public static function init(type:int):void
        {
            var cards:Array;
            __type = type;
            __inventories[__type] = [];
            switch (type)
            {
              case TYPE_CHARA:
                  CharaCardInventory.sortCharaCardId();
                  cards = CharaCardInventory.getTypeCards(CharaCardInventory.CHARA);
                  cards.forEach(function(cci:CharaCardInventory, index:int, array:Array):void{new InventorySet(cci)});
                  // CharaCardInventory.cards.forEach(function(cci:CharaCardInventory, index:int, array:Array):void{new InventorySet(cci)});
                  break;
              case TYPE_WEAPON:
                  WeaponCardInventory.sortWeaponCardId();
                  WeaponCardInventory.cards.forEach(function(cci:WeaponCardInventory, index:int, array:Array):void{new InventorySet(cci)});
                  break;
              case TYPE_EQUIP:
                  EquipCardInventory.sortEquipCardId();
                  EquipCardInventory.cards.forEach(function(cci:EquipCardInventory, index:int, array:Array):void{new InventorySet(cci)});
                  break;
              case TYPE_EVENT:
                  EventCardInventory.sortEventCardId();
                  EventCardInventory.cards.forEach(function(cci:EventCardInventory, index:int, array:Array):void{new InventorySet(cci)});
                  break;
              case TYPE_MONSTER:
                  CharaCardInventory.sortCharaCardId();
                  cards = CharaCardInventory.getTypeCards(CharaCardInventory.MONSTER);
                  cards.forEach(function(cci:CharaCardInventory, index:int, array:Array):void{new InventorySet(cci)});
                  // CharaCardInventory.cards.forEach(function(cci:CharaCardInventory, index:int, array:Array):void{new InventorySet(cci)});
                  break;
              case TYPE_OTHER:
                  CharaCardInventory.sortCharaCardId();
                  cards = CharaCardInventory.getTypeCards(CharaCardInventory.OTHER);
                  cards.forEach(function(cci:CharaCardInventory, index:int, array:Array):void{new InventorySet(cci)});
                  // CharaCardInventory.cards.forEach(function(cci:CharaCardInventory, index:int, array:Array):void{new InventorySet(cci)});
                  break;
              default:
            }
        }

        public static function set type(t:int):void
        {
            __type = t;
        }

        public static function get inventories():Array
        {
            return __inventories[__type];
        }

        // 後処理
        public static function final():void
        {
            inventories.splice(0);
        }

        // 指定したページのインベントリセットの配列を返す
        public static function getPageSet(pageSize:int, pageNo:int,type:int):Array
        {
            var start:int = pageNo * pageSize;
            var end:int = start + pageSize;
//            log.writeLog(log.LV_FATAL, type, "type is ", type, __inventories[t]);
            return __inventories[type].slice(start, end);
        }


        /**
         * コンストラクタ
         *
         */
        public function InventorySet(cci:ICardInventory)
        {
            _card =cci.card;

            if(inventories.length == 0 || cci.card.id != inventories[inventories.length-1].id)
            {
                inventories.push(this);
            }
            inventories[inventories.length-1].addCardInventory(cci);
        }

        // キャラカードを追加(ICardInvetoryに変更)
        public function addCardInventory(cci:ICardInventory):void
        {
            _invList.push(cci);
        }

        // ファイルの一番最初にあるインベントリを返す（ICardInventoryに変更）
        public function get cardInventory():ICardInventory
        {
            if(fileLength > 0)
            {
                return _invList.filter((function(item:*, index:int, ary:Array):Boolean{return item.index == 0}))[0];
            }
            else
            {
                return null;
            }
        }

        // 全体の枚数を返す
        public function get length():int
        {
            return _invList.length;
        }

        // ファイル内の枚数を返す
        public function get fileLength():int
        {
            return _invList.filter((function(item:*, index:int, ary:Array):Boolean{return item.index == 0})).length;
        }

        // デッキ内の枚数を返す
        public function get deckLength():int
        {
            return _invList.filter((function(item:*, index:int, ary:Array):Boolean{return item.index != 0})).length;
        }

        // カードのステータスを返す(ICardに変更)
        public function get card():ICard
        {
            return _card;
        }
        public function get id():int
        {
            return _card.id;
        }
        public function get name():String
        {
            return _card.name;
        }
        public function get abName():String
        {
            return _card.abName;
        }
        public function get level():int
        {
            return _card.level;
        }
        public function get hp():int
        {
            return _card.hp;
        }
        public function get ap():int
        {
            return _card.ap;
        }
        public function get dp():int
        {
            return _card.dp;
        }
        public function get cost():int
        {
            return _card.cost;
        }
        public function get rarity():int
        {
            return _card.rarity;
        }

    }
}