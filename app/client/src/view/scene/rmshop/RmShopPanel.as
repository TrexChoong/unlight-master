package view.scene.rmshop
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.*;
    import flash.net.URLRequest;

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
    import view.image.rmshop.*;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * ShopInventoryClipの表示クラス
     *
     */

    public class RmShopPanel extends BaseScene
    {
        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();
        public var BG:Shape = new Shape();
        private var _button:RealMoneyShopCloseButton = new RealMoneyShopCloseButton();



        // タイトル表示
        private var _title:Label = new Label();
        private var _titleJ:Label = new Label();

        // 定数
        private const _TITLE_X:int = 15;
        private const _TITLE_Y:int = 5;
        private const _TITLE_WIDTH:int = 100;
        private const _TITLE_HEIGHT:int = 25;

        /**
         * コンストラクタ
         *
         */
        public function RmShopPanel()
        {
            BG.graphics.beginFill(0x101010);
            BG.graphics.drawRect(0, 0, Unlight.WIDTH, 240);
            BG.graphics.endFill();
            BG.y = 250;
            BG.alpha = 0.9;
            BG.filters = [new GlowFilter(0x101010, 0.9, 0, 110, 4, 1),];
//            _button.label = "X";
            _button.width = 25;
            _button.height = 25;
            _button.x = 710;
            _button.y = 227;
            _button.addEventListener(MouseEvent.CLICK, clickHandler);
            addChild(BG);
            addChild(_button);
        }


        private function clickHandler(e:Event):void
        {
            RealMoneyShopView.hide();
        }

        private function setClipPayType():void
        {
        }

        public function get closeButton():UIComponent
        {
            return _button;
        }

    }
}
