package view.image.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.ClousureThread;
    import view.image.BaseImage;
    import controller.*;

    /**
     * 結果表示枠クラス
     *
     */
    public class CharaCardChain extends BaseImage
    {
        // result表示元SWF
        [Embed(source="../../../../data/image/compo/compo_chain.swf")]
        private var _Source:Class;

        // インスタンス定数
        private static const INS_NAME:Array = ["chain_a","chain_b","chain_c","chain_d","chain_e"];

        // 鍵の数
        private var _num:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function CharaCardChain(num:int)
        {
            _num = num;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            waitComplete(setChainComplete);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        // データをセット
        public function setChainComplete():void
        {
            for(var i:int = 0; i < INS_NAME.length; i++)
            {
                if(i < _num)
                {
                    MovieClip(_root.getChildByName(INS_NAME[i])).gotoAndStop("lock");
                    _root.getChildByName(INS_NAME[i]).visible = true;
                }
                else
                {
                    _root.getChildByName(INS_NAME[i]).visible = false;
                }
            }
        }

        // 鎖を外す
        public function unlockChain():void
        {
            waitComplete(unlockChainComplete);
        }

        // 鎖を外す
        public function unlockChainComplete():void
        {
            for(var i:int = 0; i < INS_NAME.length; i++)
            {
                if(i < _num)
                {
                    MovieClip(_root.getChildByName(INS_NAME[i])).gotoAndPlay("open");
                    _root.getChildByName(INS_NAME[i]).visible = true;
                }
                else
                {
                    _root.getChildByName(INS_NAME[i]).visible = false;
                }
            }
        }

    }
}
