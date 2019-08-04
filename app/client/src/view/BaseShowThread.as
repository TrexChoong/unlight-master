package view
{
    import flash.display.DisplayObjectContainer;
    import flash.utils.getQualifiedClassName;
    import org.libspark.thread.*;

// 基本的なShowスレッド
    public class BaseShowThread extends Thread
    {
        protected var _view:IViewThread;
        protected var _stage:DisplayObjectContainer;

        CONFIG::DEBUG
        public function  BaseShowThread(view:IViewThread, stage:DisplayObjectContainer)
        {
            
            name = getQualifiedClassName(view); // debug用
            _view = view;
            _stage = stage;
        }
        CONFIG::RELEASE
        public function  BaseShowThread(view:IViewThread, stage:DisplayObjectContainer)
        {
            _view = view;
            _stage = stage;
        }

        protected function close ():void
        {
            _view.init();
            addStageAt();
        }

        // Depthの震度に配置する
        protected function addStageAt():void
        {
            var i:int;
            var at:int = _view.depthAt;
            var num:int = _stage.numChildren;
//            log.writeLog(log.LV_TEST, this,"at & num", at, num,name)
            if ((at == -1)||(num == 0))
            {
                _stage.addChild(DisplayObjectContainer(_view));
//                log.writeLog(log.LV_TEST, this, "addChild 0",name);
            }
            else
            {
                i = (num >= at + 1)? at:num;
//                log.writeLog(log.LV_TEST, this, "i is", i);
                var j:int = i;
                while(j>=0)
                {
                    if (j == 0)
                    {
//                        log.writeLog(log.LV_TEST, this, "add at",j);
                        _stage.addChildAt(DisplayObjectContainer(_view), 0);
                       break;
                    }
                    // ステージのアイテムがIView継承してないのなら無視する
                    else if (_stage.getChildAt(j-1) is IViewThread)
                    {
                        if (IViewThread(_stage.getChildAt(j-1)).depthAt < at)
                        {
//                        log.writeLog(log.LV_TEST, this, "add at",j);
                            _stage.addChildAt(DisplayObjectContainer(_view), j);
                            break;
                        }
                    }
                    j--;
                }

            }
        }



    }

}

