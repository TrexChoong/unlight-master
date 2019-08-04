package view.image.item
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.*;

    import mx.controls.*;

    import view.image.BaseImage;

    /**
     * ItemInventoryImage表示クラス
     *
     */


    public class ItemInventoryImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/item/item_inventory.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        // 定数
        private const _PARTSNUM_X:int = 449;
        private const _PARTSNUM_Y:int = 630;
        private const _PARTSNUM_WIDTH:int = 100;
        private const _PARTSNUM_HEIGHT:int = 25;


        private var _itemButton:SimpleButton;
        private var _bodyButton:SimpleButton;
        private var _clothButton:SimpleButton;
        private var _accButton:SimpleButton;
        private var _tabSet:Array = []; /* of SimpleButton */ 

        private var _switchFunc:Function;

        private var _partsNum:Label = new Label();


        /**
         * コンストラクタ
         *
         */
        public function ItemInventoryImage()
        {
            super();
            _partsNum.x = _PARTSNUM_X;
            _partsNum.y = _PARTSNUM_Y;
            _partsNum.width = _PARTSNUM_WIDTH;
            _partsNum.height = _PARTSNUM_HEIGHT;
            _partsNum.text = "0/0";
            _partsNum.styleName = "EditTitleLabel";
            _partsNum.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
            _partsNum.mouseChildren = false;
            _partsNum.mouseEnabled = false;
            addChild(_partsNum)
      }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _itemButton  = SimpleButton(_root.getChildByName("btn_a"));
            _bodyButton  = SimpleButton(_root.getChildByName("btn_b"));
            _clothButton = SimpleButton(_root.getChildByName("btn_c"));
            _accButton   = SimpleButton(_root.getChildByName("btn_d"));
            _itemButton.addEventListener(MouseEvent.CLICK, pushItemButtonHandler);
            _bodyButton.addEventListener(MouseEvent.CLICK, pushBodyButtonHandler);
            _clothButton.addEventListener(MouseEvent.CLICK, pushClothButtonHandler);
            _accButton.addEventListener(MouseEvent.CLICK, pushAccButtonHandler);
            _tabSet = [_itemButton, _bodyButton, _clothButton, _accButton];
            initializePos();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
            _itemButton.visible               = false;
//             _bodyButton.visible               = true;
//             _clothButton.visible              = true;
//             _accButton.visible                = true;
        }


        public override function final():void
        {
            _switchFunc = null;
        }


        public function setSwitchFunc(f:Function):void
        {
            _switchFunc = f;

        }

        public function setPartsNum(i:int, m:int):void
        {
            _partsNum.htmlText = i.toString()+"/"+m.toString();
            if (i>m)
            {
                _partsNum.setStyle("color", 0xFF0000);
            }else{
                 _partsNum.setStyle("color", 0xFFFFFF);
            }
        }
        
        // 終了
        private function pushItemButtonHandler(e:MouseEvent):void
        {
            if(_switchFunc!=null)
            {
                SE.playClick();
                _switchFunc(0);
                switchTabButton(0);
            }
        }

        // 終了
        private function pushBodyButtonHandler(e:MouseEvent):void
        {
            if(_switchFunc!=null)
            {
                SE.playClick();
                _switchFunc(1);
                switchTabButton(1);
            }
        }

        // 終了
        private function pushClothButtonHandler(e:MouseEvent):void
        {
            if(_switchFunc!=null)
            {
                SE.playClick();
                _switchFunc(2);
                switchTabButton(2);
             }
        }
        // 終了
        private function pushAccButtonHandler(e:MouseEvent):void
        {
            if(_switchFunc!=null)
            {
                SE.playClick();
                _switchFunc(3)
                switchTabButton(3);
            }
        }

        private function switchTabButton(i:int):void
        {
            _tabSet.forEach(function(item:*, index:int, array:Array):void{item.visible = !(index==i) })
        }


    }

}
