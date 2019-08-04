package view
{
    import flash.display.Sprite;

    import org.libspark.thread.*;

// ただスリープさせるだけのスレッド
    public class SleepThread extends Thread
    {
        private var _sleepTime:int;
        // millsecond
        public function SleepThread(sleepTime:int)
        {
            _sleepTime = sleepTime;
        }

        protected override function run():void
        {
            //sleep(_sleepTime);
            sleep(_sleepTime / Unlight.SPEED);		// By_K2 (대기시간 1/2 로 조정)
        }

    }

}

