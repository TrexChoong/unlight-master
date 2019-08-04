package model
{
    import model.events.*;

    import flash.events.EventDispatcher;
    import flash.events.Event;

    /**
     * 系統樹クラス
     *
     *
     */
    public class Growth extends BaseModel
    {
        // シングルトンインスタンス
        private static var __instance:Growth;

        // イベント
        public static const START:String = 'start';                              // 開始
        public static const REQUIREMENTS:String = 'requirements';                // 系統樹を表示
        public static const SELECT_CARD:String = 'select_card';                  // カードを選択
        public static const UNSELECT_CARD:String = 'unselect_card';              // カードを非選択
        public static const WAITING:String = 'waiting';                          // 待機状態にする
        public static const END:String = 'end';                                  // 開始

        // カード関連
        private var _requirementsCardId:int = 1;                                 // 系統樹カードID
        private var _selectCardId:int = -1;                                      // 成長させるカードのID

        // ステータス
        private var _state:String = '';

        /**
         * シングルトンインスタンスを返すクラス関数
         *
         *
         */
        public static function get instance():Growth
        {
            if( __instance == null )
            {
                __instance = createInstance();
            }
            return __instance;
        }

        // 本当のコンストラクタ
        private static function createInstance():Growth
        {
            return new Growth(arguments.callee);
        }

        // コンストラクタ
        public function Growth(caller:Function)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
        }

        // カレントのカードIDを取得する
        public function get requirementsCardId():int
        {
            return _requirementsCardId;
        }

        // ステートを取得する
        public function get state():String
        {
            return _state;
        }

        // 選択中のカードを取得する
        public function get selectCardId():int
        {
            return _selectCardId;
        }

        // 初期化
        public function initialize():void
        {
            _requirementsCardId = 0;
            dispatchEvent(new Event(START));
        }

        // 系統樹の表示
        public function requirements(charaCardId:int):void
        {
            _requirementsCardId = charaCardId;
            _selectCardId = -1;
            _state = REQUIREMENTS;
            dispatchEvent(new Event(REQUIREMENTS));
        }

        // カードの合成
        public function exchange(id:int, cid:int):void
        {
            dispatchEvent(new ExchangeEvent(ExchangeEvent.EXCHANGE, id, cid));
        }

        // カードの合成に成功
        public function exchangeSuccess():void
        {
            _state = WAITING;
            dispatchEvent(new ExchangeEvent(ExchangeEvent.EXCHANGE_SUCCESS, 0));
        }

        // 待つ
        public function waiting():void
        {
            _state = WAITING;
            dispatchEvent(new Event(WAITING));
        }

        // カードを選択
        public function selectCard(id:int):void
        {
            _selectCardId = id;
            dispatchEvent(new Event(SELECT_CARD));
        }

        // カードを非選択
        public function unselectCard():void
        {
            _selectCardId = -1;
            dispatchEvent(new Event(UNSELECT_CARD));
        }

        // 終了時
        public function finalize():void
        {
            dispatchEvent(new Event(END));
        }
    }
}