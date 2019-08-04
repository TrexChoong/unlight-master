package view.scene.game
{
    import mx.core.UIComponent;

    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Duel;
    import model.Entrant;
    import model.events.BuffEvent;
    import view.ClousureThread;
    import view.utils.RemoveChild;
    import view.image.game.BuffImage;
    import view.scene.BaseScene;
    import view.scene.common.CharaCardClip;

    /**
     * キャラ状態異常テーブル
     *
     */

    public class CharaBuffsTable extends BaseScene
    {

        private var _container:UIComponent = new UIComponent();
        private var _buffClips:Array = [];
        private var _stage:Sprite;
        private var _enemy:Boolean = false;
        private var _startX:int;
        private var _viewBuffs:Array = [];

        private var _setBuffTurn:Boolean = true;

        private const _SHOW_NUM:int = 4;
        private const _PL_BUFF_START_X:int = 310;

        private const _FOE_BUFF_START_X:int = 410;
        private const _X_DIFF:int = 44;
        private const _BUFF_Y:int = 314;

        private const _STATE_HIDE:int = 0;
        private const _STATE_SHOW:int = 1;
        private var _state:int = _STATE_HIDE;

        public function CharaBuffsTable(stage:Sprite,enemy:Boolean=false,raidBoss:Boolean=false)
        {
            _stage = stage;
            _enemy = enemy;
            _setBuffTurn = !raidBoss;
            if (enemy) {
                _startX = _FOE_BUFF_START_X;
            } else {
                _startX = _PL_BUFF_START_X;
            }
        }

        public override function init():void
        {
            alpha = 0.0;
            addChild(_container);
        }
        public override function final():void
        {
            removeBuffStatusAll();
            RemoveChild.apply(_container);
        }

        // ステータス状態を付与する
        public function addBuffStatus(id:int, value:int, turn:int):void
        {
            var index:int = _buffClips.length;
            var clipIndex:int = -1;

            // 既に同じ効果が存在するかをソートする
            for(var i:int = 0; i < index; i++)
            {
                if(_buffClips[i].no == id)
                {
                    clipIndex = i;
                }
            }

            // 新しい効果なら
            if(clipIndex == -1)
            {
                // ステータスを追加する
                var setTurn:Boolean = (id != Const.BUFF_STIGMATA && id != Const.BUFF_CURSE && id != Const.BUFF_TARGET) ? _setBuffTurn : true;
                _buffClips.push(new BuffClip(id, value, turn, setTurn));
                _buffClips[index].getShowThread(_stage,26).start();
                if (_state == _STATE_HIDE) {
                    _buffClips[index].visible = false;
                    _buffClips[index].alpha = 0.0;
                }
            }
            else
            {
                // 既に同じステータスが存在するならターン数とValueを加算する
                _buffClips[clipIndex].turn = turn;
                _buffClips[clipIndex].value = value;
            }
            updateBuffPosition();
        }
        // ステータス状態解除
        public function removeBuffStatus(id:int, value:int):void
        {
            var tmpArray:Array;

            // 既に同じ効果が存在するかをソートする
            for(var i:int = 0; i < _buffClips.length; i++)
           {
                if(_buffClips[i].no == id && _buffClips[i].value == value)
                {
                    tmpArray = _buffClips.splice(_buffClips.indexOf(_buffClips[i]),1);
                    tmpArray[0].visible = false;
                    tmpArray[0].getHideThread().start();
                    i -= 1;
                }
            }
            updateBuffPosition();
        }

        

        // ステータス状態解除
        public function removeBuffStatusAll():void
        {
            hideViewList();
            var tmpArray:Array;
            // 全てのbuffを1つずつ外す
            for(var i:int = 0; i < _buffClips.length; i++)
            {
                if (_buffClips[i].no == Const.BUFF_CONTROL) continue;
                tmpArray = _buffClips.splice(_buffClips.indexOf(_buffClips[i]),1);
                tmpArray[0].visible = false;
                tmpArray[0].getHideThread().start();
                i -= 1;
            }
            updateBuffPosition();
        }
        // ステータスを進行させる
        public function updateBuffStatus(id:int, value:int, turn:int):void
        {
            if (!_setBuffTurn) return;
            var tmpArray:Array;

            for(var i:int = 0; i < _buffClips.length; i++)
            {
                if(_buffClips[i].no == id && _buffClips[i].value == value)
                {
                    // ターン数を変動
                    if (_buffClips[i].turn + turn > 9)
                    {
                        _buffClips[i].turn = 9;
                    }
                    else
                    {
                        _buffClips[i].turn += turn;
                    }
                    // ターンが０以下なら消失させる
                    if(_buffClips[i].turn <= 0)
                    {
                        tmpArray = _buffClips.splice(_buffClips.indexOf(_buffClips[i]),1);
                        tmpArray[0].visible = false;
                        tmpArray[0].getHideThread().start();
                        i -= 1;
                    }
                }
            }
            updateBuffPosition();
        }

        private function compare(x:BuffClip,y:BuffClip):int
        {
            var ret:Number = 0;
            if(x.turn == y.turn)
            {
                if(x.no > y.no)
                {
                    ret = 1;
                }else{
                    ret = -1;
                }
            }else{
                if(x.turn > y.turn)
                {
                    ret = 1;
                }else{
                    ret = -1;
                }
            }
            return ret;
        }

        private function hideViewList():void
        {
            var temp:BuffClip;
            while (_viewBuffs.length > 0)
            {
                temp = _viewBuffs.pop();
                temp.visible = false;
            }
        }

        private function updateBuffPosition():void
        {
            hideViewList();
            var vec:int = (_enemy) ? 1 : -1;
            _buffClips.sort(compare);
            for(var i:int = 0; i < _buffClips.length; i++)
            {
                if (i < _SHOW_NUM) {
                    _buffClips[i].x = _startX + (_X_DIFF * i * vec);
                    _buffClips[i].y = _BUFF_Y;
                    if (_state == _STATE_SHOW) _buffClips[i].visible = true;
                    _viewBuffs.push(_buffClips[i]);
                } else {
                    _buffClips[i].visible = false;
                }
            }
        }

        public function getBringOnThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            for(var i:int = 0; i < _viewBuffs.length; i++)
            {
                pExec.addThread(new BeTweenAS3Thread(_viewBuffs[i], {alpha:1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            }
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(function():void{_state = _STATE_SHOW;}));
            return sExec;
        }
        public function getBringOffThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            for(var i:int = 0; i < _viewBuffs.length; i++)
            {
                pExec.addThread(new BeTweenAS3Thread(_viewBuffs[i], {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            }
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(function():void{_state = _STATE_HIDE;}));
            return sExec;
        }
        private function setBuffVisible(f:Boolean):void
        {
            for(var i:int = 0; i < _viewBuffs.length; i++)
            {
                _viewBuffs[i].visible = f;
            }
        }

    }
}