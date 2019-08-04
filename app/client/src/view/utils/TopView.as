package view.utils
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;

    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;

    import view.image.BaseImage;

    import controller.TitleCtrl;

    import model.Option;

    /**
     *  取得確認パネル
     *
     */

    public class TopView extends Object
    {



        public static function enable(e:Boolean):void
        {
            Unlight.INS.topContainer.mouseEnabled = e;
            Unlight.INS.topContainer.mouseChildren = e;
        }


        

    }
}