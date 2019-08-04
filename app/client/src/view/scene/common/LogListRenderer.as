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

    import view.scene.common.*;

    public class LogListRenderer extends UIComponent implements IDataRenderer, IListItemRenderer
    {
        private var _data:Object;
        private var _container:UIComponent = new UIComponent();
//        private var _container:Canvas = new Canvas();
        private var _logClip:SocialLogClip;

        public function LogListRenderer()
        {
            super();
        }

        protected override function createChildren():void
        {
            super.createChildren();
            _container.height = 100;
            _container.width = 300;
            addChild(_container);
        }

        protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        }
        protected override function commitProperties():void
        {
            super.commitProperties();

            _logClip = data.logClip;
            _logClip.getShowThread(_container).start();
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

    }
}