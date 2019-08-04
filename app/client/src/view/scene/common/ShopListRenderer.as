package view.scene.common
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

    import view.image.common.AvatarItemImage;

    public class ShopListRenderer extends UIComponent implements IDataRenderer, IListItemRenderer
    {
        private var _data:Object;
        private var _container:UIComponent = new UIComponent();
//        private var _container:Canvas = new Canvas();
        private var _title:Label = new Label();
        private var _num:Label = new Label();
        private var _caption:Text = new Text();
        private var _useButton:Button = new Button();
        private var _buyButton:Button = new Button();
        private var _image:AvatarItemImage;

        public static const USE_ITEM:String = "use_item";
        public static const BUY_ITEM:String = "buy_item";

        public function ShopListRenderer()
        {
            super();
        }
        protected override function createChildren():void
        {
            super.createChildren();
            _container.height = 120;
            _container.width = 120;
//            _container.styleName = "ItemList";
            addChild(_container);
        }

//         override protected function commitProperties():void
//         {
//             super.commitProperties();
//         }


        protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        }
        protected override function commitProperties():void
        {
            super.commitProperties();
            _title.text = data.name;
            _title.width = 110;
            _title.height = 20;

            _num.text = data.num.toString()+"gem";
            _num.width = 100;
            _num.height = 20;
            _num.x = 10;
            _num.y = 12;

            _image = data.image;
            _image.x = 35;
            _image.y = 52;
            _image.scaleX = 0.3;
            _image.scaleY = 0.3;
            _image.width = 38;
            _image.height = 38;

            _caption.text = data.caption;
            _caption.y = 74;
            _caption.width = 110;
            _caption.height = 44;
//            caption.styleName = "CharaCardName";

            _useButton.x = 80;
            _useButton.y = 30;
            _useButton.width = 35;
            _useButton.height = 35;
            _useButton.label = "use";
            _useButton.addEventListener(MouseEvent.CLICK, clickUseHandler);

            _buyButton.x = 80;
            _buyButton.y = 30;
            _buyButton.width = 35;
            _buyButton.height = 35;
            _buyButton.label = "buy";
            _buyButton.addEventListener(MouseEvent.CLICK, clickBuyHandler);

//            _container.addChild(_useButton);
            _image.getShowThread(_container).start();
            _container.addChild(_buyButton);
            _container.addChild(_num);
            _container.addChild(_title);
            _container.addChild(_caption);
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
//            _num.text = "x" + data.num;
//            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
        }

        private function clickUseHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "click use!");
            dispatchEvent(new Event(USE_ITEM, true, true));
        }

        private function clickBuyHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "click buy!");
            dispatchEvent(new Event(BUY_ITEM, true, true));
        }
    }
}