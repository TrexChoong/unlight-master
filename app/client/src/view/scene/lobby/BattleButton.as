package view.scene.lobby
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;

    import view.scene.BaseScene;
    import view.image.lobby.*;

    /**
     * Lobby表示クラス
     *
     */


    public class BattleButton extends BaseScene
    {

        private var _battle_a:TestBattleA = new TestBattleA();
        private var _battle_b:TestBattleB = new TestBattleB();
        private var _battle_c:TestBattleC = new TestBattleC();
         private var _battle_d:TestBattleD = new TestBattleD();

        /**
         * コンストラクタ
         *
         */
        public function BattleButton()
        {
            _battle_a.getShowThread(this, 1).start();
            _battle_b.getShowThread(this, 2).start();
            _battle_c.getShowThread(this, 3).start();
            _battle_d.getShowThread(this, 4).start();
            buttonMode = true;
             super();
        }

        public override function init():void
        {
            addEventListener(MouseEvent.ROLL_OVER,mouseOverHandler);
        }

        private function mouseOverHandler(e:MouseEvent):void
        {
            _battle_a.play();
            _battle_b.play();
            _battle_c.play();
            _battle_d.play();
            removeEventListener(MouseEvent.ROLL_OVER,mouseOverHandler);
            addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);

        }

        private function mouseOutHandler(e:MouseEvent):void
        {
            _battle_a.stop();
            _battle_b.stop();
            _battle_c.stop();
             _battle_d.stop();
            addEventListener(MouseEvent.ROLL_OVER,mouseOverHandler);
            removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
        }

    }

}
