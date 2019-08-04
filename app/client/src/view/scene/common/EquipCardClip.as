package view.scene.common
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;
    import mx.events.ToolTipEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import view.image.common.*;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.scene.game.BuffClip;
    import view.scene.ModelWaitShowThread;

    /**
     * EquipCardClipのアイコン表示クラス
     * 全部ビットマップでキャッシュすべできか。同時に二つでることがない？
     */

    public class EquipCardClip extends BaseScene implements ICardClip
    {
        // イメージ
        private var _image:AvatarItemImage;
        private var _equipCard:EquipCard;
        private var _cardFrame:CardFrame;
        private var _name:Label = new Label();
        private var _caption:Text = new Text();
        private var _equipCardInventory:ICardInventory;
        private var _deckEditor:DeckEditor = DeckEditor.instance;

        /**
         * コンストラクタ
         *
         */
        public function EquipCardClip(wc:EquipCard)
        {
            _equipCard = wc;
        }

        // 初期化
        public override function init():void
        {
            _cardFrame = new CardFrame(CardFrame.FRAME_GREEN);
//             _image = new AvatarItemImage(_avatarItem.image, _avatarItem.imageFrame);

//             _image.x = 83;
//             _image.y = 100;

            _name.x = 0;
            _name.y = 5;
            _name.width = 164;
            _name.height = 100;
            _name.text = _equipCard.name;
            _name.styleName = "ResultNameLabel";
            _name.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];

            _caption.x = 15;
            _caption.y = 180;
            _caption.width = 144;
            _caption.height = 90;
            _caption.text = _equipCard.caption;
            _caption.styleName = "ResultTextLabel";
            _caption.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];

//            _image.getShowThread(this).start();
            addChild(_cardFrame);
            addChild(_name);
            addChild(_caption);
        }

        // 後処理
        public override function final():void
        {
            removeEventListener(MouseEvent.CLICK, selectCardHandler);

//            _image.getHideThread().start();
            if (_cardFrame.parent ==this){ removeChild(_cardFrame)};
            if (_name.parent == this){ removeChild(_name)};
            if (_caption.parent == this){ removeChild(_caption)};
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ModelWaitShowThread(this, stage,  _equipCard);
        }

        // エディット用表示スレッドを返す
        public function getEditShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            addEventListener(MouseEvent.CLICK, selectCardHandler);
            return getShowThread(stage, at, type);
        }

        public  function get itemID():int
        {
            return _equipCard.id;
        }

        public function set cardInventory(inv:ICardInventory):void
        {
            _equipCardInventory = inv;
        }

        public function get cardInventory():ICardInventory
        {
            return _equipCardInventory
        }

        // カード選択ハンドラ
        private function selectCardHandler(e:MouseEvent):void
        {
            _deckEditor.selectCard(_equipCard.id);
        }


    }

}
