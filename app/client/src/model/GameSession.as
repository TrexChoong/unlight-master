package model
{
    import net.*;
    import net.events.*;
    import model.ActionCard;

    /**
     * ゲームセッションクラス
     * 情報を扱う
     *
     */
    public class GameSession  extends EventDispatcher
    {
        private var _id      :int;
        private var _foe     :String;
        private var _myCards :Array;

        // コンストラクタ
        public function GameSession(id,foe)
        {
            _id = id;
            _foe = foe;
            _myCards = [];
        }

    }
}
