package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;


    import flash.events.MouseEvent;

    import view.image.BaseLoadImage;

    /**
     * StandCharaFace表示クラス
     *
     */


    public class StandCharaFaceImage extends BaseLoadImage
    {

        // インスタンス名
        private static const FACE:String = "face"
        private static const URL:String = "/public/image/standchara/";
        private static const RESULT_SUFIX:RegExp = /_res\d/;

        private var _foe:Boolean = false;

        private var _distance:int = 2;

        private var _standMC:MovieClip;
        private var _shadowMC:MovieClip;
        private var _upMC:MovieClip;

        private var _offsetX:int = 0;
        private var _scaleX:int = 1;

        private var _in:Boolean =false;

        private var _faceMC:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function StandCharaFaceImage(player:Boolean, url:String)
        {
            visible = false;
            super(URL+url.replace(RESULT_SUFIX, "")+"_f.swf");
            if (player)
            {
            }else{
                _scaleX = -1;
//                x=940
            }
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _faceMC= MovieClip(_root.getChildByName(FACE));
            _faceMC.scaleX = _scaleX;

            visible = false;
            _faceMC.gotoAndPlay("face_out");
        }

        public function inFace():void
        {

            if (!_in)
            {
                _in = true;
                waitComplete(updateFace);
            }
        }


        public function outFace():void
        {

            if (_in)
            {
                _in = false;
                waitComplete(updateFace);
            }
        }


        private function updateFace():void
        {
            visible = true;
            if (_in)
            {
                _faceMC.gotoAndPlay("face_in");
            }else{
                _faceMC.gotoAndPlay("face_out");

            }
        }

    }
}
