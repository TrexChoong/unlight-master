package view.image.match
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */

    public class RoomJoinButton extends BaseImage
    {
        // 入室ボタン表示元SWF
        [Embed(source="../../../../data/image/match/roomin.swf")]
        private var _in:Class;

        // 退室ボタン表示元SWF
        [Embed(source="../../../../data/image/match/roomout.swf")]
        private var _out:Class;

        // 観戦ボタン表示元SWF
        [Embed(source="../../../../data/image/match/watch_btl.swf")]
        private var _watch:Class;


        // swfの配列
        private var _Source:Array = [_in, _out, _watch];

        // 表示タイプ
        private var _type:int;

        // 定数
        public static const IN:int    = 0;
        public static const OUT:int   = 1;
        public static const WATCH:int = 2;

        /**
         * コンストラクタ
         *
         */
        public function RoomJoinButton(type:int)
        {
            _type = type;
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return _Source[_type];
        }
    }

}
