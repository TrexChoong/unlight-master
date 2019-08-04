package
{
  import flash.display.*;
  [SWF(width="945", height="715", backgroundColor="#ffffff")]

  import org.libspark.thread.Thread;
  import org.libspark.thread.EnterFrameThreadExecutor;
  import view.MainView;

    public class Unlight extends Sprite
    {

        public var mainView:MainView;
        private var _container:UIComponent = new UIComponent();

        public function Unlight() 
        {
            addChild(_container);
            if (!Thread.isReady)
            {
                Thread.initialize(new EnterFrameThreadExecutor());
            }
            mainView = new MainView(_container);
            mainView.start();
        }
    }
}
