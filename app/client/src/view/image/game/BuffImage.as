package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import model.Duel;
    import view.image.BaseImage;

    /**
     * 状態異常表示クラス
     *
     */


    public class BuffImage extends BaseImage
    {
        // buff表示元SWF
        [Embed(source="../../../../data/image/buff.swf")]
        private var _Source:Class;

        // インスタンス格納配列
        private var _buffMC:Array = [];

        // 実体
        private var _anime:int = 0;                // ステータス番号
        private var _value:int = 0;                // 影響値
        private var _turn:int = 0;                 // ターン数

        // 定数
        private static const BUFF_NAME:Array = ["turn", "poison", "movestop", "atk_up", "atk_down",
                                                "def_up", "def_down", "berserk", "don_act", "don_skl",
                                                "death", "armor", "terror", "mov_up", "mov_down", "regene",
                                                "bind", "chaos", "stigma", "weekness","rod", "curse", "bless",
                                                "armor2", "poison2", "death2", "target", "dark", "doll"];

        private static const TIMER:String = "time";
        private var _timerMC:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function BuffImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            for(var i:int = 0; i < BUFF_NAME.length; i++)
            {
                _buffMC.push(MovieClip(_root.getChildByName(BUFF_NAME[i])));
                _buffMC[i].visible = false;
            }
            _buffMC[0].visible = true;

            _timerMC = MovieClip(_root.getChildByName(TIMER));
            _timerMC.visible = false;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        // 状態変化の番号を入れる
        public function atAnime(a:int):void
        {
            _anime = a;
            waitComplete(setAnime);
        }

        // 状態変化を表示する
        public function setAnime():void
        {
            if(_buffMC[_anime])
            {
                _buffMC[_anime].visible = true;
            }
            else
            {
                log.writeLog(log.LV_INFO, this, "undefined MovieClip is", BUFF_NAME[_anime]);
            }
        }

        // 状態変化の影響値を入れる
        public function atValue(v:int=1):void
        {
            _value = v;
            waitComplete(setValue);
        }

        // 状態変化の影響値を設定する
        private function setValue():void
        {
            if(_buffMC[_anime] && _value != 0)
            {
                _buffMC[_anime].gotoAndStop(_value);
            }
            else
            {
                log.writeLog(log.LV_INFO, this, "undefined MovieClip is", BUFF_NAME[_anime]);
            }
        }

        // 有効ターンの影響値を入れる
        public function atTurn(t:int=1):void
        {
            _turn = t;
            waitComplete(setTurn);
        }

        // 有効ターンを設定する
        private function setTurn():void
        {
            if(_buffMC[0] && _value != 0)
            {
                _buffMC[0].gotoAndStop(_turn);
            }
            else
            {
                log.writeLog(log.LV_INFO, this, "undefined MovieClip is", BUFF_NAME[_anime]);
            }
        }

        // ターンの表示非表示設定
        public function set setTurnVisible(v:Boolean):void
        {
            _buffMC[0].visible = v;
        }
    }
}
