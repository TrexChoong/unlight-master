package view
{
    import flash.display.*;
    import org.libspark.thread.*;

// MCを特定フレームまで移動するだけのスレッド
    public class FramePlayThread extends Thread
    {
        private var _mc:MovieClip;
        private var _distFrame:int;
        private var _currentFrame:int;

        public function FramePlayThread(mc:MovieClip, distFrame:int)
        {
            _mc = mc;
            _distFrame = distFrame;
        }

        protected override function run():void
        {
            _currentFrame = _mc.currentFrame;

            var f:int = _distFrame- _currentFrame;
//          log.writeLog(log.LV_FATAL, this, "run", f);
            // フレームが移動済みなら抜ける
            if (f == 0)
            {
                return;
            }
            // 移動フレームへ進むのか巻き戻すか決めて実行する
            if (f>0)
            {
                next(nextFrame);
            }else{
                next(prevFrame);
            }

        }

        private function nextFrame():void
        {
            if (_mc.currentFrame>=_distFrame)
            {
                return;
            }else{
//              log.writeLog(log.LV_FATAL, this, "nextframe", _mc.currentFrame ,_distFrame);
                _mc.nextFrame();
//                _mc.gotoAndStop(_mc.currentFrame+1)
                if(checkInterrupted())
                {
                    return;
                }

                next(nextFrame);
            }

        }

        private function prevFrame():void
        {
//            log.writeLog(log.LV_FATAL, this, "prevframe", _mc.currentFrame);
            if (_mc.currentFrame<=_distFrame)
            {
                return;
            }else{
                _mc.prevFrame();
                if(checkInterrupted())
                {
                    return;
                }
                next(prevFrame);
            }
        }

    }

}

