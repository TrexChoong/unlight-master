package view.scene.shop
{
    import flash.utils.IDataInput;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.controls.Label;
    import mx.controls.Text;
    import mx.controls.Button;
    import mx.core.UIComponent;
    import mx.containers.Canvas;
    import mx.core.IDataRenderer;
    import mx.controls.listClasses.IListItemRenderer;
    import mx.events.FlexEvent;

    import view.scene.common.*;
    import model.events.*;


    public class ShopInventoryRenderer extends UIComponent implements IDataRenderer, IListItemRenderer
    {
        private var _data:Object;
        private var _container:UIComponent = new UIComponent();
//        private var _container:Canvas = new Canvas();
        private var _shopInventoryClip:ShopInventoryClip;

        public function ShopInventoryRenderer()
        {
            super();
        }

        protected override function createChildren():void
        {
            super.createChildren();
            _container.height = 400;
            _container.width = 500;
            addChild(_container);
        }

        protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        }

        protected override function commitProperties():void
        {
            super.commitProperties();

            _shopInventoryClip = data.shopInventoryClip;
            _shopInventoryClip.x = 4;
            _shopInventoryClip.y = 2;
            _shopInventoryClip.mouseChildren = false;
            _shopInventoryClip.mouseEnabled = false;
            _shopInventoryClip.getShowThread(_container).start();

            _container.addEventListener(MouseEvent.CLICK, clickHandler);
        }
        protected override function measure():void
        {
            super.measure();
        }

        public function get data():Object
        {
            return _data;
        }
        public function set data(value:Object):void
        {
            _data = value;
        }

        public function clickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "click!");
            log.writeLog(log.LV_INFO, this, "data", _data.shopInventoryClip);
            dispatchEvent(new SelectShopEvent(SelectShopEvent.ITEM_CHANGE, _shopInventoryClip, true, true));
        }
    }
}