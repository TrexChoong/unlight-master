package view.scene.lobby
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;

    import mx.core.UIComponent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import view.scene.BaseScene;
    import view.image.lobby.*;
    import view.ItemListView;


    /**
     * イベント情報パネル表示クラス
     *
     */

    public class EventInfoPanel extends BaseScene
    {
        private var _panel:EventInfoPanelImage = new EventInfoPanelImage();

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        private static const _START_X:int = Unlight.WIDTH / 2;
        private static const _START_Y:int = Unlight.HEIGHT / 2;

        /**
         * コンストラクタ
         *
         */
        public function EventInfoPanel()
        {
            _panel.x = _START_X;
            _panel.y = _START_Y;
            _panel.scaleX = 0.0;
            _panel.alpha = 0.0;
            _panel.scaleX = 0.0;
            _panel.scaleY = 0.0;

            super();
        }

        public override function init():void
        {
            log.writeLog (log.LV_DEBUG,this,"!!!Set Close Func!");
            _panel.setCloseFunc(hide);
            // _container.addChild(_panel);
            // addChild(_container);

        }

        public function show():void
        {
            // アイテムリスト排他になければいけないので閉じる
            ItemListView.hide();

            // 作ったVIEWをトップビューに突っ込んで背景はクリックできなくする
            BetweenAS3.serial(
                BetweenAS3.addChild(_panel, Unlight.INS.topContainer.parent),
                BetweenAS3.to(_panel,{x:0,y:0,scaleX:1.0,scaleY:1.0,alpha:1.0},0.15, Quad.easeOut)
                ).play();
            Unlight.INS.topContainer.mouseEnabled = false;
            Unlight.INS.topContainer.mouseChildren = false;
            _panel.setCloseFunc(hide);
        }

        private function hide():void
        {
            log.writeLog (log.LV_DEBUG,this,"Info Close Click!");
            BetweenAS3.serial(
                BetweenAS3.tween(_panel, {x:_START_X,y:_START_Y,scaleX:0.0,scaleY:0.0,alpha:0.0}, null, 0.15, Sine.easeOut),
                BetweenAS3.removeFromParent(_panel)
                ).play()
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
        }

    }
}
