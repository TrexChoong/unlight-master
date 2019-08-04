// TODO:indexがカード総数より変だったら例外で落とすべきか。

package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    import model.events.*;

    import view.scene.raid.RaidBossBuffList;

    /**
     * デュエル参加者クラス
     *
     *
     */
    public class FoeEntrant  extends Entrant
    {
        private var _bossBuffList:Vector.<RaidBossBuffList> = new Vector.<RaidBossBuffList>();

        public function FoeEntrant(charaCards:Array, damages:Array=null, cardMax:int = 5)
        {
            super(charaCards,damages);
        }


        // カードが配られる
        public override function dealed(aca:Array):void
        {
            var i:int =aca[0];
            var a:Array =[];
            for(var j:int = 0; j <  i; j++)
            {
                a.push(ActionCard.ID(0));
            }
            _cards =  _cards.concat(a);
        }


        // 移動カードを出す
        public override function moveCardAdd(ac:ActionCard, dir:Boolean = true, index:int = 0):void
        {
            ac = ActionCard.ID(0);
            replaceCard(ac, cards, _moveTable);
            dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.ADD_MOVE_TABLE, ac, index));
        }

        // 移動カードを引っ込める
        public override function moveCardRemove(ac:ActionCard, index:int= 0):void
        {
            ac = ActionCard.ID(0);
            replaceCard(ac, _moveTable, cards);
            dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.REMOVE_MOVE_TABLE, ac, index));
        }

        // 攻撃カードを出す
        public override function battleCardAdd(ac:ActionCard, dir:Boolean, index:int =0):void
        {
            ac = ActionCard.ID(0);
            replaceCard(ac, cards, _battleTable);
            dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.ADD_BATTLE_TABLE, ac, index));
        }

        // 攻撃カードを引っ込める
        public override function battleCardRemove(ac:ActionCard, index:int= 0):void
        {
            ac = ActionCard.ID(0);
            replaceCard(ac, _battleTable, cards);
            dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.REMOVE_BATTLE_TABLE, ac, index));
        }

        // 攻撃カードを回転させる
        public override function cardRotate(ac:ActionCard, dir:Boolean, table:int=0, index:int = 0):void
        {
            dispatchEvent(new ReplaceCardEvent(ReplaceCardEvent.ROTATE, ac, index, table));
        }

        // カードの入れ替え
        protected override function replaceCard(card:ActionCard, src:*, dist:*):void
        {
            src.pop();
            dist.push(card);
            log.writeLog(log.LV_TEST, this, "replce card",  src, cards);
        }

        // カードのオープン（テーブルカードを正しいに値を入れる）
        public function openMoveCards(acArray:Array, dir:Array, locked:Boolean):void
        {
            _moveTable = acArray.slice();
            dispatchEvent(new OpenTableCardsEvent(OpenTableCardsEvent.OPEN_MOVE_CARDS, acArray, dir, locked));
        }

        // カードのオープン（テーブルカードを正しいに値を入れる）
        public function openBattleCards(acArray:Array, dir:Array, locked:Boolean):void
        {
            _battleTable= acArray.slice();
            if (acArray.length > 0)
            {
                dispatchEvent(new OpenTableCardsEvent(OpenTableCardsEvent.OPEN_BATTLE_CARDS, acArray, dir, locked));
            }
        }

        // カードのオープン）
        public function openEventCard(ac:ActionCard):void
        {
            var acArray:Array = [ac]; /* of ActionCard */
            var dirArray:Array = [true]; /* of Boolean */
            dispatchEvent(new OpenTableCardsEvent(OpenTableCardsEvent.OPEN_EVENT_CARDS, acArray, dirArray));
        }

        // 破棄カードのオープン
        public function openDiscardCard(ac:ActionCard):void
        {
            var acArray:Array = [ac]; /* of ActionCard */
            var dirArray:Array = [true]; /* of Boolean */
            dispatchEvent(new OpenTableCardsEvent(OpenTableCardsEvent.OPEN_DISCARD_CARDS, acArray, dirArray));
        }

        // 破棄カード ※ 開かない
        public function closeDiscardCard(ac:ActionCard):void
        {
            var acArray:Array = [ac]; /* of ActionCard */
            var dirArray:Array = [true]; /* of Boolean */
            dispatchEvent(new OpenTableCardsEvent(OpenTableCardsEvent.CLOSE_DISCARD_CARDS, acArray, dirArray));
        }

        public function set bossBuffLists(l:Vector.<RaidBossBuffList>):void
        {
            _bossBuffList = l;
        }
        public function get bossBuffLists():Vector.<RaidBossBuffList>
        {
            return _bossBuffList;
        }
        public function get currentBossBuffLists():RaidBossBuffList
        {
            return _bossBuffList[currentCharaCardIndex];
        }

    }
}
