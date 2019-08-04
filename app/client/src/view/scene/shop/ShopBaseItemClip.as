package view.scene.shop
{
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import org.libspark.thread.Thread;

    import model.BaseModel;
    import model.*;

    import view.BaseShowThread;
    import view.IViewThread;
    import view.image.common.AvatarItemImage;
    import view.scene.common.AvatarClip;
    import view.scene.common.AvatarPartIcon;
    import view.scene.common.CharaCardClip;
    import view.scene.common.WeaponCardClip;
    import view.scene.common.EquipCardClip;
    import view.scene.common.EventCardClip;
    import view.scene.common.IInventoryClip;

    /**
     * アイテムデータと画像クラス
     *
     */
    public class ShopBaseItemClip
    {
        public static const BASE_TYPE_ITEM:int = 0;
        public static const BASE_TYPE_PART:int = 1;
        public static const BASE_TYPE_CARD:int = 2;
        public static const BASE_TYPE_DECK:int = 3;

        private var _item:* = null;
        private var _image:* = null;
        private var _type:int = BASE_TYPE_ITEM;
        private var _isShop:Boolean = false;
        private var _url:String = "";
        private var _frame:int = 0;

        private const _ITEM_X:int = 44;
        private const _ITEM_Y:int = 44;
        private const _ITEM_SCALE:Number = 0.5;

        private const _PART_X:int = 4;
        private const _PART_Y:int = -8;
        private const _PART_SCALE:Number = 0.5;

        private const _CARD_X:int = 23;
        private const _CARD_Y:int = 13;
        private const _CARD_SCALE:Number = 0.25;

        private const _DECK_X:int = 44;
        private const _DECK_Y:int = 44;
        private const _DECK_SCALE:Number = 0.5;

        public function ShopBaseItemClip(item:*,type:int=BASE_TYPE_ITEM,isShop:Boolean=false,url:String="",frame:int=0):void
        {
            _item = item;
            _type = type;
            _isShop = isShop;
            _url = url;
            _frame = frame;

            switch (_type)
            {
            case BASE_TYPE_ITEM:
                initItemClip();
                break;
            case BASE_TYPE_PART:
                initPartClip();
                break;
            case BASE_TYPE_CARD:
                initCardClip();
                break;
            case BASE_TYPE_DECK:
                initDeckClip();
                break;
            default:
                break;
            }
        }

        private function initItemClip():void
        {
            // アイテムを作成
            // ショップでの表示フレーム指定がある場合、そちらで表示
            var imageFrame:int = 0;
            if ( _isShop && _item.shopImageFrame > 0 ) {
                imageFrame = _item.shopImageFrame;
            } else {
                imageFrame = _item.imageFrame;
            }
            _image = new AvatarItemImage(_item.image, imageFrame);
            _image.x = _ITEM_X;
            _image.y = _ITEM_Y;
            _image.scaleX = _image.scaleY = _ITEM_SCALE;
        }

        private function initPartClip():void
        {
            _image = new AvatarPartIcon(_item,false);
            _image.x = _PART_X;
            _image.y = _PART_Y;
            _image.scaleX = _image.scaleY = _PART_SCALE;
        }

        private function initCardClip():void
        {
            // アイテムを作成
            switch (_item.type)
            {
            case InventorySet.TYPE_CHARA:
                _image = new CharaCardClip(CharaCard(_item));
                break;
            case InventorySet.TYPE_WEAPON:
                _image = new WeaponCardClip(WeaponCard(_item));
                break;
            case InventorySet.TYPE_EQUIP:
                _image = new EquipCardClip(EquipCard(_item));
                break;
            case InventorySet.TYPE_EVENT:
                _image = new EventCardClip(EventCard(_item));
                break;
            }
            _image.x = _CARD_X;
            _image.y = _CARD_Y;
            _image.scaleX = _image.scaleY = _CARD_SCALE;
        }

        private function initDeckClip():void
        {
            // アイテムを作成
            _image = new AvatarItemImage(_url,_frame);
            _image.x = _DECK_X;
            _image.y = _DECK_Y;
            _image.scaleX = _image.scaleY = _DECK_SCALE;
        }

        public function get type():int
        {
            return _type;
        }
        public function get item():*
        {
            return _item;
        }
        public function get image():*
        {
            return _image;
        }

        public function get x():int
        {
            return _image.x;
        }
        public function get y():int
        {
            return _image.y;
        }
        public function get scaleX():Number
        {
            return _image.scaleX;
        }
        public function get scaleY():Number
        {
            return _image.scaleY;
        }
        public function get baseX():int
        {
            var ret:int = 0;
            switch (_type)
            {
            case BASE_TYPE_ITEM:
                ret = _ITEM_X;
                break;
            case BASE_TYPE_PART:
                ret = _PART_X;
                break;
            case BASE_TYPE_CARD:
                ret = _CARD_X;
                break;
            case BASE_TYPE_DECK:
                ret = _DECK_X;
                break;
            default:
                break;
            }
            return ret;
        }
        public function get baseY():int
        {
            var ret:int = 0;
            switch (_type)
            {
            case BASE_TYPE_ITEM:
                ret = _ITEM_Y;
                break;
            case BASE_TYPE_PART:
                ret = _PART_Y;
                break;
            case BASE_TYPE_CARD:
                ret = _CARD_Y;
                break;
            case BASE_TYPE_DECK:
                ret = _DECK_Y;
                break;
            default:
                break;
            }
            return ret;
        }
        public function get baseScale():Number
        {
            var ret:Number = 0.0;
            switch (_type)
            {
            case BASE_TYPE_ITEM:
                ret = _ITEM_SCALE;
                break;
            case BASE_TYPE_PART:
                ret = _PART_SCALE;
                break;
            case BASE_TYPE_CARD:
                ret = _CARD_SCALE;
                break;
            case BASE_TYPE_DECK:
                ret = _DECK_SCALE;
                break;
            default:
                break;
            }
            return ret;
        }

        public function set x(x:int):void
        {
            _image.x = x;
        }
        public function set y(y:int):void
        {
            _image.y = y;
        }
        public function set scale(scale:Number):void
        {
            _image.scaleX = _image.scaleY = scale;
        }

        // 表示用スレッドを返す
        public function getShowThread(stage:DisplayObjectContainer,at:int =-1):Thread
        {
            return _image.getShowThread(stage,at);
        }

        // 非表示用スレッドを返す
        public function getHideThread():Thread
        {
            return _image.getHideThread();
        }
    }
}


