package view.image.regist
{

    import flash.events.*;
    import flash.geom.*;
    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.Thread;
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;

    /**
     * アバターパーツイメージ
     *
     */

    public class AvatarPartsImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/regist/make_2avatar_item.swf")]
        private var _Source:Class;
        private static const SCALE:Number = 1.0;
        private static const X:int = 0;
        private static const Y:int = 0;

        private static const NAME_ITEM_TYPE:Array = ["category_a","category_b","category_c","category_d"];
        private static const NAME_ITEM_LIST:Array = ["list_a","list_b","list_c","list_d","list_e","list_f","list_g","list_h","list_i"];
        private static const LABEL_ITEM_NORMAL:String = "normal";
        private static const LABEL_ITEM_OVER:String = "over";
        private static const LABEL_ITEM_ON:String = "on";


        private var _itemType:Array = []; /* of SimpleButton */ ;
        public var _itemList:Array = []; /* of SimpleButton */ ;


        private var _firstArrow:SimpleButton;
        private var _prevArrow:SimpleButton;
        private var _nextArrow:SimpleButton;
        private var _lastArrow:SimpleButton;

        private var _test:MovieClip;
        /**
         * コンストラクタ
         *
         */
        public function AvatarPartsImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            NAME_ITEM_TYPE.forEach(function(item:*, index:int, array:Array):void{_itemType.push(SimpleButton(_root.getChildByName(item)))});
            NAME_ITEM_LIST.forEach(function(item:*, index:int, array:Array):void{_itemList.push(SimpleButton(_root.getChildByName(item)))});
            _itemType.forEach(function(item:*, index:int, array:Array):void{
                });
            _itemList.forEach(function(item:*, index:int, array:Array):void{
                    item.visible = false;
//                    item.mouseChildren = false;
                });
            initializePos();
        }


        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {

            scaleX = SCALE;
            scaleY = SCALE;
            x = X;
            y = Y;
            alpha = 1.0;
        }

        public function itemListShow(index:int):void
        {
            if ((_itemList.length > index)&&(index > -1))
            {
                _itemList[index].visible = true;
            }
        }

        public function itemListHide(index:int):void
        {
            if ((_itemList.length > index)&&(index > -1))
            {
                _itemList[index].visible = false;
            }
        }

        public function itemListAllHide():void
        {
            _itemList.forEach(function(item:*, index:int, array:Array):void{
                    item.visible = false;
                });
        }



        public function typeListSetEventListener(func:Function):void
        {
            _itemType.forEach(function(item:*, index:int, array:Array):void{
                    item.addEventListener(MouseEvent.CLICK,func);
                });

        }
        public function typeListRemoveEventListener(func:Function):void
        {
            _itemType.forEach(function(item:*, index:int, array:Array):void{
                    item.removeEventListener(MouseEvent.CLICK,func);
                });

        }

        public function getTypeIndex(item:SimpleButton):int
        {
            return _itemType.indexOf(item);
        }


        public function itemListSetEventListener(func:Function):void
        {
            _itemList.forEach(function(item:*, index:int, array:Array):void{
                    item.addEventListener(MouseEvent.CLICK,func);
                });

        }

        public function itemListRemoveEventListener(func:Function):void
        {
            _itemList.forEach(function(item:*, index:int, array:Array):void{
                    item.removeEventListener(MouseEvent.CLICK,func);
                });

        }

        public function getItemIndex(item:SimpleButton):int
        {
            return _itemList.indexOf(item);
        }

        public function getItemPoint(index:int):Point
        {
            return new Point(_itemList[index].x, _itemList[index].y);
        }

    }

        
}

