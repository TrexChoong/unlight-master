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
    import view.utils.*;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.scene.game.BuffClip;
    import view.image.game.CharaCardStar;
    import view.scene.ModelWaitShowThread;
    import view.scene.game.ActionCardClip;

    /**
     * EventCardClipのアイコン表示クラス
     * 全部ビットマップでキャッシュすべできか。同時に二つでることがない？
     */

    public class EventCardClip extends BaseScene implements ICardClip
    {
        private static const AC_X:int = 10;
        private static const AC_Y:int = 20;
        private static const STAR_X:int = 10;
        private static const STAR_Y:int = 9;

        // イメージ
        private var _image:AvatarItemImage;
        private var _eventCard:EventCard;
        private var _cardFrame:CardFrame;
        private var _name:Label = new Label();
        private var _caption:Text = new Text();
        private var _eventCardInventory:ICardInventory;
        private var _actionCardClip:ActionCardClip;
        private var _deckEditor:DeckEditor = DeckEditor.instance;
        private  static var __charaCardStar:CharaCardStar =CharaCardStar.instance;
        private var _colorStarBitmap:Bitmap;



        /**
         * コンストラクタ
         *
         */
        public function EventCardClip(wc:EventCard)
        {
            _eventCard = wc;
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
            _name.text = _eventCard.name;
            _name.styleName = "ResultNameLabel";
            _name.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];

            _caption.x = 15;
            _caption.y = 180;
            _caption.width = 144;
            _caption.height = 60;
            _caption.text = _eventCard.caption;
            _caption.styleName = "ResultTextLabel";
            _caption.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];

            _actionCardClip = new ActionCardClip(ActionCard.ID(_eventCard.no));
            _actionCardClip.scaleX = _actionCardClip.scaleY = 1.0;
            _actionCardClip.x = 84;
            _actionCardClip.y = 100;
//            _image.getShowThread(this).start();
            addChild(_cardFrame);
            addChild(_name);
            addChild(_caption);
            addChild(_actionCardClip);

            //  カラーが存在するときにはそれをONにする
            if (_eventCard.color>EventCard.ECC_NONE)
            {
                __charaCardStar.setStar(function():void{
                    _colorStarBitmap = new Bitmap(__charaCardStar.getStarBitmapData(_eventCard.color));
                    _colorStarBitmap.x = STAR_X;
                    _colorStarBitmap.y = STAR_Y;
                    _colorStarBitmap.filters = [new GlowFilter(0x222222, 1, 2, 2, 3, 1)];
                    addChild(_colorStarBitmap);
//                    Unlight.GCW.watch(_colorStarBitmap);
                });
                _cardFrame.changeFrameEventColor(_eventCard.color)
            }
//               Unlight.GCW.watch(_cardFrame);
//               Unlight.GCW.watch(_actionCardClip);
             super.init();
        }



//         // 後処理
         public override function final():void
         {
//             log.writeLog(log.LV_FATAL, this, "--------- final",_eventCard.id);
//            _image.getHideThread().start();
             if (_actionCardClip != null)
             {
                 _actionCardClip.final();
             }
//            log.writeLog(log.LV_WARN, this, "final", itemID);
            removeEventListener(MouseEvent.CLICK, selectCardHandler);
            RemoveChild.apply(_cardFrame);
            RemoveChild.apply(_name);
            RemoveChild.apply(_caption);
            RemoveChild.apply(_actionCardClip);
            if(_colorStarBitmap != null)
            {
//                log.writeLog(log.LV_FATAL, this, "--------- final remove star?",_eventCard.id);
                __charaCardStar.clearSetStar();
                RemoveChild.apply(_colorStarBitmap);
            }
//            log.writeLog(log.LV_WARN, this, "final6");
            RemoveChild.all(this);
            _cardFrame = null;
            _caption = null;
            _colorStarBitmap = null;
            _actionCardClip =null;
            super.final();
//            log.writeLog(log.LV_FATAL, this, "--------- final end?",_eventCard.id,_finished);
         }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _finished = false;
            _depthAt = at;
            return new ModelWaitShowThread(this, stage,  _eventCard);
        }

        // エディット用表示スレッドを返す
        public function getEditShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _finished = false;
            addEventListener(MouseEvent.CLICK, selectCardHandler);
            return getShowThread(stage, at, type);
        }

        // エディット用表示スレッドを返す
        public function getDeckShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _finished = false;
            addEventListener(MouseEvent.CLICK, selectCardHandler);
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(getShowThread(stage, at, type));
            sExec.addThread(new ClousureThread(actionCardClipMode));
            return sExec;
        }

        public  function get itemID():int
        {
            return _eventCard.id;
        }

        public function set cardInventory(inv:ICardInventory):void
        {
            _eventCardInventory = inv;
        }

        public function get cardInventory():ICardInventory
        {
            return _eventCardInventory
        }

        private function actionCardClipMode():void
        {
            if(_actionCardClip != null)
            {
                _actionCardClip.x = AC_X;
                _actionCardClip.y = AC_Y;
                _actionCardClip.scaleX = _actionCardClip.scaleY = 1;
                RemoveChild.apply(_cardFrame);
                RemoveChild.apply(_name);
                RemoveChild.apply(_caption);
                RemoveChild.apply(_colorStarBitmap);
            }
        }

        public function addDeckUpdatedEventHandler():void
        {
        }

        public function removeDeckUpdatedEventHandler():void
        {
        }

        public function setCaution(co:Array, ch:Array, pa:Array):void
        {
        }

        // カード選択ハンドラ
        private function selectCardHandler(e:MouseEvent):void
        {
            _deckEditor.selectCard(_eventCard.id);
        }

    }

}
