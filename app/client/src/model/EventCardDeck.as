package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    import model.*;
    import net.*;

    /**
     * デッキクラス
     *
     *
     */
    public class EventCardDeck  extends EventDispatcher implements IDeck
    {
        public static const SLOT_UPDATE:String = "slot_update";
        public static const REMOVE_CHARA:String = "remove_chara";

        // エディットインスタンス
        private var _deckEdit:DeckEditor = DeckEditor.instance;

        public static const UPDATE:String = 'update';  // 情報がアップデート
        private var _name:String;                      // デッキ名
        private var _cardInventories:Array = [];       // インベントリ付きカード

        private static var __decks:Array = [];            // Array of EventCardDeck
        private var _slotDataSet:Vector.<SlotData> = new Vector.<SlotData>();

        public static function initializeDeck():void
        {
            __decks = [];

        }

        public static function get decks():Array
        {
            return __decks;
        }

        // デッキのカードインベントリを初期化
        public static function initEventCardInventory(cci:EventCardInventory):void
        {
            decks[cci.index].cardInventories.push(cci);
        }

        // バインダーからデッキにカードインベントリを移す
        public static function binderToDeck(cci:EventCardInventory, index:int, charPos:int):void
        {
            binder.removeEventCardInventory(cci,0);
            decks[index].addEventCardInventory(cci, charPos);
        }

        // デッキからバインダーにカードインベントリを移す
        public static function deckToBinder(cci:EventCardInventory):void
        {
//            log.writeLog(log.LV_FATAL, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
            decks[cci.index].removeEventCardInventory(cci,cci.index);
            binder.addEventCardInventory(cci);
        }

        // デッキを削除する
        public static function deleteDeck(index:int):void
        {
            // デッキ内の全てのカードをバインダーに移す
            var deckLength:int = decks[index].cardInventories.length;
            for(var i:int = 0; i < deckLength; i++)
            {
                DeckEditor.instance.deckToBinderEventCard(decks[index].cardInventories[0]);
            }
            // デッキを削除
            decks.splice(index, 1);
            // 後ろにあるデッキのカードインベントリを修正する
            for(i = index; i < decks.length; i++)
            {
                decks[i].cardInventories.forEach(function(cci:EventCardInventory, index:int, array:Array):void{cci.index = i});
            }
        }

        // デッキを削除する
        public static function allCardDeckToBinder(index:int):void
        {
            // デッキ内の全てのカードをバインダーに移す
            var deckLength:int = decks[index].cardInventories.length;
            for(var i:int = 0; i < deckLength; i++)
            {
                DeckEditor.instance.deckToBinderEventCard(decks[index].cardInventories[0]);
            }
        }

        // カードインベントリ一覧のゲッター
        public static function get binder():EventCardDeck
        {
            return decks[0];
        }

        // コンストラクタ
        public function EventCardDeck(name:String)
        {
            _name = name;
            decks.push(this);
            initSlot();
//             _slotDataSet.push(new SlotData());
//             _slotDataSet.push(new SlotData());
//             _slotDataSet.push(new SlotData());

        }

        public function initSlot():void
        {
            for(var i:int = 0; i < 3; i++){
                if (CharaCardDeck.decks[myIndex].cardInventories[i] != null)
                {
                    _slotDataSet[i] = new SlotData(CharaCardDeck.decks[myIndex].cardInventories[i].charaCard.slotValues);
                }else{
                    _slotDataSet[i] = new SlotData();
                };
            }
        }

        // デッキにカードインベントリを追加
        public function addEventCardInventory(cci:EventCardInventory, charPos:int=0):void
        {
//            cci.cardPosition = getPositionCard(charPos).length;
            cci.position = charPos;
            cci.index = EventCardDeck.decks.indexOf(this);
            _cardInventories.push(cci);
            updateSlot(cci.position);
//            cci.cardPosition = _slotDataSet[charPos].useSlot(0);
        }

        // バインダーのカードインベントリを削除
        public function removeEventCardInventoryId(invId:int):void
        {
            for(var i:int = 0; i < _cardInventories.length; i++)
            {
               if(_cardInventories[i].inventoryID == invId)
               {
                   _cardInventories.splice(i, 1);
                   i--;
               }
            }
        }

        // キャラカードが取り除かれたとき後ろのインベントリをずらす
        public static function removeCharaCard(index:int, pos:int, len:int):void
        {
            // デッキから無くなったキャラカード位置のインベントリを取り出す
            var a:Array = decks[index].getPositionCard(pos);
//            log.writeLog(log.LV_FATAL,   "EventCardDeck","remove card c pos", a,pos);
            // 当該ポジションのカードを取り除く
             for(var i:int = 0; i < a.length; i++){
//                 log.writeLog(log.LV_FATAL, "EventCardDeck", "remove card c pos remove inv", i);
                 DeckEditor.instance.deckToBinderEventCard(a[i]);
             }
             // 当該ポジション以降のカードを一つつめる
             for(var j:int = pos; j < 3; j++){
                 a = decks[index].getPositionCard(j);
//                 log.writeLog(log.LV_FATAL,   "EventCardDeck","remove card n pos", a);
                 a.forEach(function(item:EventCardInventory, index:int, array:Array):void{
                         item.position = item.position-1;
                         log.writeLog(log.LV_FATAL,  "EventCardDeck", "remove card pos",item.cardPosition,item.position);
                         DeckEditor.instance.deckToDeckEventCard(item,index,item.position);
                             });
             __decks[index].updateSlot(j);
             }

             __decks[index].dispatchEvent(new Event(REMOVE_CHARA));
//             __decks[index].updateCaseSlot();
        }


        public static function updateEventPos(index:int):void
        {
            __decks[index].dispatchEvent(new Event(REMOVE_CHARA));
        }

        // デッキからカードを消去
        public function removeEventCardInventory(cci:EventCardInventory,index:int):void
        {
            var position:int = _cardInventories.indexOf(cci);
            if(position != -1)
            {
                _cardInventories.splice(position, 1);

                // 取り除くのがバインダーでないのなら位置を修正する
                if (index!=0)
                {
                    updateSlot(cci.position);
                }
            }
            else
            {
                log.writeLog(log.LV_FATAL, this, "undefined position card");
            }
         }

        public function get myIndex():int
        {
            return EventCardDeck.decks.indexOf(this);
        }

        private function updateSlot(pos:int):void
        {
            if (CharaCardDeck.decks[myIndex].cardInventories[pos] != null)
            {
                _slotDataSet[pos] = new SlotData(CharaCardDeck.decks[myIndex].cardInventories[pos].charaCard.slotValues);
            }else{
                _slotDataSet[pos] = new SlotData();
            };
            var a:Array = getPositionCard(pos);
            // カードが抜けたポイントからのポジションを修正
            for(var i:int = 0; i < a.length; i++)
            {
                a[i].cardPosition = _slotDataSet[pos].useSlot(a[i].card.color);
            }

            // ここでDeckケースに向かってイベントを撃つ（色枠を表示するため
            dispatchEvent(new Event(SLOT_UPDATE));
        }

        public function updateCaseSlot():void
        {
            dispatchEvent(new Event(SLOT_UPDATE));
        }



        // デッキからカードを消去
        public function removePositionInventory(position:int):void
        {
            if(position < _cardInventories.length)
            {
                // Binderのデッキ番号(0)を代入
                _cardInventories[position].index = 0;

                // デッキからインベントリを消去
                _cardInventories.splice(position, 1);

//                 // カードが抜けたポイントからのポジションを修正
//                 for(var i:int = position; i < _cardInventories.length; i++)
//                 {
//                     _cardInventories[i].position = i;
//                 }
            }
        }

        // デッキ名のゲッター
        public function get name():String
        {
            return _name;
        }

        // デッキ名のセッター
        public function set name(n:String):void
        {
            _name = n;
        }

        // カードインベントリ一覧のゲッター
        public function get cardInventories():Array
        {
            return _cardInventories;
        }

        // カードインベントリにあるカードの枚数
        public function sortEventCardId(id:int):int
        {
            var count:int = 0;
            _cardInventories.forEach(function(item:*, index:int, array:Array):void{if(item.eventCard.id == id){count++}});
            return count;
        }

        // ポジションのカードを配列で返す
        public function getPositionCard(pos:int):Array
        {
            var ret:Array = [];
            var len:int = _cardInventories.length;
            for(var i:int = 0; i < len; i++){
                if (_cardInventories[i].position == pos)
                {ret.push(_cardInventories[i])}
            }
            return ret;
        }

        public function slotDataSet():Vector.<SlotData>
        {
            return _slotDataSet;
        }

        public function get slotsSet():Array
        {
            return [_slotDataSet[0].slots, _slotDataSet[1].slots, _slotDataSet[2].slots] ;
        }

        public function checkColorNum(pos:int, type:int):Boolean
        {
            updateSlot(pos);
//            log.writeLog(log.LV_FATAL, this, "Check color",type,pos,_slotDataSet[pos].getAvailableSlotNum(type));
            return _slotDataSet[pos].getAvailableSlotNum(type) > 0;
        }

        public function checkAllSlot():void
        {
            for(var i:int = 0; i < 3; i++){
                updateSlot(i);
            }
        }

        // 総コストのゲッター
        public function get cost():int
        {
            var calc:int = 0
            _cardInventories.forEach(function(item:*, index:int, array:Array):void{calc += item.card.cost});
            return calc;
        }


    }
}

// Position管理クラス
// カラー総数を指定して作る
// カラーを指定するともっとも近いカラーを返す

class SlotData
{
    private var _slots:Array= [];
    private var _values:Array =[];
    private var _none:int;
    private var _originalSlots:Array= []; // 使用状況を保存しないSlot

    private var _white:int = 1;
    private var _black:int =2;
    private var _red:int = 3;
    private var _green:int =4;
    private var _blue:int =5;
    private var _yellow:int =6;
    private var _purple:int =7;
    private static const MAX:int = 6;

    private static const  _USED:int = 16;

    public function SlotData(v:Array =null ):void
    {
        if (v==null)
        {
            _values = [0, 0, 0, 0, 0, 0, 0, 6];
        }else{
            _values = [v[1],v[2],v[3],v[4],v[5],v[6],v[7],v[0]];
        }
        slotInit();
    }

    // 特定のスロット種の数を返す
    public function getValue(type:int = 0):int
    {
        if (type == 0){type = 8}
        return _values[type-1];
    }

    // 特定のスロット種の数を返す
    public function getAvailableSlotNum(type:int = 0):int
    {
        var ret:int = 0;
        // 無属性の場合使われていないスロットの数を返す
        if (type ==0)
        {
            for(var i:int = 0; i < MAX; i++){
                if (_slots[i] < _USED)
                {
                    ret++;
                }
            }
        }else{
            for(var j:int = 0; j < MAX; j++){
                if (type == _slots[j])
                {ret ++}
            }
        }
        return ret;
    }

    // スロットを使う
    public function useSlot(type:int):int
    {
        // 適応したスロットを探す
        var pos:int = _slots.indexOf(type);
        // 適応したスロットを使用済みにする
        if (pos != -1)
        {
            _slots[pos] = _slots[pos]+_USED;
        }else if (type == 0)
            // 0が無くなった場合色スロットをつぶす
        {
            for(var i:int = 0; i < 6; i++){
                if (_slots[i] < _USED)
                {
                    pos = i;
                    _slots[pos] = _slots[pos]+_USED;
                    break;
                }
            }
        }
        // そのポジションを返す
        return pos;
    }
    // スロットを使う
    public function resetSlot():void
    {
        slotInit();
    }

    // 現在のカラーにそってスロットを初期化
    public function slotInit():void
    {
        _slots =[];
        _values.forEach(function(item:*, index:int, array:Array):void
                        {
//                             log.writeLog(log.LV_FATAL, this, "SLOT INDEX", item,index);
                            for(var i:int = 0; i < item; i++){
//                             log.writeLog(log.LV_FATAL, this, "SLOT INDEX2", item,index);
                                if (index != 7){_slots.push(index+1);}
                            }
                        });
        for(var j:int = 0; j < MAX; j++){
            if(_slots[j]==null)
            {
                _slots[j]=0;
            }
        }
        _originalSlots = _slots.slice()
//         log.writeLog(log.LV_FATAL, this, "SLOT INIT", _slots, _values);
    }

    public function get slots():Array
    {
        return _originalSlots;
    }

}
