package view.image.raid
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;
    import flash.utils.*;

    import mx.core.UIComponent;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import controller.*;

    /**
     * RaidBoss状態異常表示パネル
     *
     */
    public class RaidBossBuffsButton extends Sprite
    {
        private var _upBase:BuffPanelButton = new BuffPanelButton(BuffPanelButton.TYPE_UP);
        private var _downBase:BuffPanelButton = new BuffPanelButton(BuffPanelButton.TYPE_DOWN);
        private var _overBase:BuffPanelButton = new BuffPanelButton(BuffPanelButton.TYPE_OVER);
        private var _hitBase:BuffPanelButton = new BuffPanelButton(BuffPanelButton.TYPE_HIT);

        private var _button:SimpleButton;

        // private static const _X:int = 520;
        // private static const _Y:int = 65;
        private static const _X:int = 620;
        private static const _Y:int = 85;

        /**
         * コンストラクタ
         *
         */
        public function RaidBossBuffsButton()
        {
            super();
            x = _X;
            y = _Y;
            initButton();
            addChild(_button);
        }

        private function initButton():void
        {
            _button = new SimpleButton(_upBase,_downBase,_overBase,_hitBase);
        }

        public function get button():SimpleButton
        {
            return _button;
        }

    }

}

import flash.display.*;
import flash.events.Event;
import flash.geom.*;
import flash.utils.*;
import flash.text.*;
import mx.controls.Label;

class BuffPanelButton extends Sprite
{
    public static const TYPE_UP:int = 0;
    public static const TYPE_DOWN:int = 1;
    public static const TYPE_OVER:int = 2;
    public static const TYPE_HIT:int = 3;

    private const _UP_CT:ColorTransform = new ColorTransform(1,1,1,1,112,128,144);
    private const _DOWN_CT:ColorTransform = new ColorTransform(1,1,1,1,112,128,144);
    private const _OVER_CT:ColorTransform = new ColorTransform(1,1,1,1,176,196,222);
    private const _HIT_CT:ColorTransform = new ColorTransform(1,1,1,1,112,128,144);

    private const _CT_SET:Array = [_UP_CT,_DOWN_CT,_OVER_CT,_HIT_CT];

    private const _W:int = 70;
    private const _H:int = 25;

    private var _type:int = TYPE_UP;
    private var _base:Shape = new Shape();

    private var _text:TextField = new TextField();


    /**
     * コンストラクタ
     *
     */
    public function BuffPanelButton(type:int)
    {
        super();
        _type = type;
        initBase();
        addChild(_base);

        initText();
        addChild(_text);
    }

    private function initBase():void
    {
        _base.graphics.clear();
        _base.graphics.lineStyle(0, 0x000000,1);
        _base.graphics.beginFill(0x000000);
        _base.graphics.drawRect(0,0,_W,_H);
        _base.transform.colorTransform = _CT_SET[_type];
    }

    private function initText():void
    {
        var tf:TextFormat = new TextFormat();
        tf.font = "_typeWiter";
        tf.size = 11;
        tf.color = 0x000000;
        tf.align = TextFormatAlign.CENTER;
        _text.defaultTextFormat = tf;
        _text.text = "BossBuffs";
        _text.autoSize = "center";
        _text.x = (this.width - _text.width) / 2;
        _text.y = (this.height - _text.height) / 2;
        _text.selectable = false;

    }
}