package view.scene.rmshop
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import flash.utils.Dictionary;

    import flash.filters.DropShadowFilter;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.core.ClassFactory;
    import mx.containers.*;
    import mx.controls.*;
    import mx.collections.ArrayCollection;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.AvatarItemEvent;

    import view.*;
    import view.utils.*;
    import view.image.common.AvatarItemImage;
    import view.image.common.AvatarItemImage;
    import view.scene.common.IInventoryClip;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.image.rmshop.*;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * ShopInventoryClipの表示クラス
     * 
     */

    public class RmShopButton extends BaseScene
    {
        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();
//        private var _button:Button = new Button();
        private var _button:RealMoneyShopButton;
        private static const _BUTTON_SCALE_SET:Vector.<Number> = Vector.<Number>([1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0]);
        // 位置定数
        private static const _BUTTON_X_SET:Vector.<int> = Vector.<int>([-70,448,260,343,100,000,508,13,696,0]);
        private static const _BUTTON_Y_SET:Vector.<int> = Vector.<int>([-50,015,237,482,100,470,015,536,578,0]);
        private static const _LABEL_X_SET:Vector.<int> = Vector.<int>([606,428,210,343,100,000,488,0,667,0]);
        private static const _LABEL_Y_SET:Vector.<int> = Vector.<int>([645,065,505,482,100,470,065,590,622,0]);

        private var _type:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function RmShopButton(t:int)
        {
            _button = new RealMoneyShopButton(t);
//             _button.label = "SHOP!!";
//             _button.width = 50;
//             _button.height = 50;
//            log.writeLog(log.LV_FATAL, this, "++++++++++++++++++++");
            _type = t;
            x = _BUTTON_X_SET[t];
            y = _BUTTON_Y_SET[t];

            _button.labelX = _LABEL_X_SET[t];
            _button.labelY = _LABEL_Y_SET[t];

            scaleX = scaleY = _BUTTON_SCALE_SET[t];
            addEventListener(MouseEvent.CLICK, clickHandler);

            addChild(_button);

        }

        // ショップボタンのクリック
        private function clickHandler(e:Event):void
        {
            RealMoneyShopView.show(_type);
        }

        public function setViewSaleClipFlag(flag:Boolean=true):void
        {
            _button.setViewSaleClipFlag(flag);
        }

        public function getHideSaleMCThread():Thread
        {
            return _button.getHideSaleMCThread();
        }

        public function get sale():MovieClip
        {
            return _button.sale;
        }

        public function addMouseOverOutEvent():void
        {
            _button.addMouseOverOutEvent();
        }
        public function removeMouseOverOutEvent():void
        {
            _button.removeMouseOverOutEvent();
        }
    }
}

