package view.scene.game
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;

    import mx.core.UIComponent;
    import mx.containers.Box;
    import mx.controls.Label;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;

    import model.PassiveSkill;
    import controller.QuestCtrl;
    import view.image.game.*;
    import view.scene.BaseScene;
    import view.utils.*;
    import view.*;

    /**
     * Feat表示クラス
     *
     */


    public class PassiveSkillClip extends BaseScene
    {
        private var _container:UIComponent = new UIComponent(); // 表示コンテナ
        private var _passiveSkill:PassiveSkill;
        private var _image:PassiveSkillImage;

        private var _box:Box = new Box();
        private var _name:Label = new Label();

        private static var __passiveSkills:Array = []; /* of PassiveSkill Clip */ 
        private var _id:int;
        private static const URL:String = "/public/image/";

        private static const  LAST_BOSS_ID:int = 7; // ラスボスの特殊パッシブか？


        // 必殺技のIDからクリップを作って返す。作成済みならそれを返す。
        public static function getInstance(id:int):PassiveSkillClip
        {
            if (__passiveSkills[id] == null)
            {
                __passiveSkills[id] =  new PassiveSkillClip(PassiveSkill.ID(id));
            }
            return __passiveSkills[id];
        }

        public static function clearCache():void
        {
            for (var key:Object in __passiveSkills)
            {
                RemoveChild.apply(__passiveSkills[key]);
                __passiveSkills[key].final();
                delete __passiveSkills[key];
            }
        }

        /**
         * コンストラクタ
         *
         */
        public function PassiveSkillClip(passiveSkill:PassiveSkill)
        {
            _passiveSkill = passiveSkill;
            if (_passiveSkill.loaded)
            {
                _image = new PassiveSkillImage(URL+_passiveSkill.image);
            }
            else
            {
                _passiveSkill.addEventListener(PassiveSkill.INIT, passiveSkillInitHandler);
            }
        }

        private function passiveSkillInitHandler(e:Event):void
        {
            _image = new PassiveSkillImage(URL+_passiveSkill.image);
        }

        public override function final():void
        {
                _passiveSkill.removeEventListener(PassiveSkill.INIT, passiveSkillInitHandler);
        }

        public function clipInitialize():Thread
        {
//            var plThread:ParallelExecutor = new ParallelExecutor();
//            plThread.addThread(_image.getShowThread(this));
            return _image.getShowThread(this);
        }

        public function labelInitialize():void
        {
//             _name.x = 30;
//             _name.y = 8;
//             _name.styleName = "PassiveSkillInfoLabelFlash"
//             _name.width = 200;
//             _name.height = 40;
//             _name.text = _passiveSkill.name;

//             //_container.addChild(_name);
//             addChild(_container);
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new ShowThread(_passiveSkill, this, stage));
            if (LAST_BOSS_ID == _passiveSkill.id)
            {
                sExec.addThread(new SleepThread(3000));
                sExec.addThread(QuestCtrl.instance.questViewDuelAvatarHideThread);
                sExec.addThread(QuestCtrl.instance.getQuestViewBGExcnahgeThread(16)); // 王座2へ変える

            }
            return sExec;
        }

        // 非表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }

        // 左右反転
        public function setAnime(player:Boolean):void
        {
            if(player)
            {
                _image.plAnime();
            }
            else
            {
                _image.foeAnime();
            }
        }

        public function get passiveSkill():PassiveSkill
        {
            return _passiveSkill;
        }

        public override function get name():String
        {
            return _name.text;
        }

    }

}

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import org.libspark.thread.Thread;

import model.PassiveSkill;
import view.scene.game.PassiveSkillClip;
import view.BaseShowThread;
import view.utils.*;

class ShowThread extends BaseShowThread
{
    private var _passiveSkill:PassiveSkill;
    private var _passiveSkillClip:PassiveSkillClip;

    public function ShowThread(passiveSkill:PassiveSkill, passiveSkillClip:PassiveSkillClip, stage:DisplayObjectContainer)
    {
        _passiveSkill = passiveSkill;
        _passiveSkillClip = passiveSkillClip;
        super(passiveSkillClip,stage)
    }

    protected override function run():void
    {
        // 必殺技の準備を待つ
        if (_passiveSkill.loaded == false)
        {
            _passiveSkill.wait();
        }
        next(init);
    }

    private function init ():void
    {
        var thread:Thread;
        thread = _passiveSkillClip.clipInitialize();
        thread.start();
        thread.join();
        next(waiting);
    }

    private function waiting():void
    {
        next(close);
    }

    protected override function close ():void
    {
        _passiveSkillClip.labelInitialize();
        addStageAt();
    }
}

// 非表示用のスレッド
class HideThread extends Thread
{
    private var _passiveSkillClip:PassiveSkillClip;

    public function HideThread(passiveSkillClip:PassiveSkillClip)
    {
        _passiveSkillClip = passiveSkillClip;
        name = "passive cli"
    }

    protected override function run():void
    {
//         // ステージに追加されてたらデータを消す
//         if(_passiveSkillClip.parent != null)
//         {
//             next(hide);
//         }
//         else
//         {
//             next(run);
//         }
        next(exit)
    }

    private function hide():void
    {
        next(exit);
    }

    private function exit():void
    {
        RemoveChild.apply(_passiveSkillClip);
        PassiveSkillClip.clearCache();
    }
}
