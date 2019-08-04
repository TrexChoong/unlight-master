package view
{
    import org.libspark.thread.Thread;

    public class BaseView extends Thread
    {

        private var _stage:Unlight;

        // コンストラクタ
        public function BaseView(stage:Unlight)
        {
            _stage = stage;
        }
    }

}
