package view.image.quest
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import view.image.BaseLoadImage;
    import view.utils.*;
    import model.Dialogue;
    import controller.TitleCtrl;

    /**
     * QuestListImage表示クラス
     *
     */
    public class QuestStoryBGImage extends BaseLoadImage
    {


        private var _obverse:Boolean = false;
        private var  _mapNo:int = 0;
        private static const SKIP_BUTTON:String  ="btn_skip";
        public  static const SKIP_EVENT:String  ="skip_event_story";
        private var _skipButton:SimpleButton;
        private var _totalFrames:int;

        private static const BG_URL_SET:Array =
            [
                "quest_story_a.swf", // プロローグ           0
                "quest_story_b.swf", // 魔女の谷 HexRealm    1
                "quest_story_c.swf", // 影の国  ShadowLand   2
                "quest_story_d.swf", // 月夜見の国 MoonLand  3
                "quest_story_e.swf", // 風の国 Anemonea      4
                "quest_story_f.swf", // 御使いの国 Angelland 5 欠番
                "quest_story_g.swf", // 聖女の玉座 The Throne6
                "quest_story_g.swf", // ラスボス撃破 Mia     7
                "eventstory_01_a.swf", // イベントa          8欠番
                "eventstory_01_b.swf", // イベントb          9
                "eventstory_01_c.swf", // イベントc          10
                "eventstory_01_d.swf", // イベントd          11
                "eventstory_00_a.swf", // 初心者地域1          12
                "eventstory_00_b.swf", // 初心者地域3          13
                "eventstory_00_c.swf", // 初心者地域5          14
                "eventstory_02_a.swf", // 2015/06イベントa     15
                "eventstory_02_b.swf", // 2015/06イベントb     16
                "eventstory_02_c.swf", // 2015/06イベントc     17
                "eventstory_03_a.swf", // 2015/10イベントa     18
                "eventstory_03_b.swf", // 2015/10イベントb     19
                "eventstory_03_c.swf", // 2015/10イベントc     20
                "eventstory_04_a.swf", // 2016/04イベントa     21
                "eventstory_04_b.swf", // 2016/04イベントb     22
                "eventstory_04_c.swf", // 2016/04イベントc     23
                "eventstory_05_a.swf", // 2016/10イベントb     24
                "eventstory_05_b.swf", // 2016/10イベントc     25
                "eventstory_06_a.swf", // 2017/04イベントa     26
                "eventstory_06_b.swf", // 2017/04イベントb     27
                "eventstory_06_c.swf", // 2017/04イベントc     28
            ]; /* of String */

        private static const URL:String = "./public/image/quest_story/"

        /**
         * コンストラクタ
         *
         */
        public function QuestStoryBGImage(mapNo:int)
        {
            _mapNo = mapNo;
            super(URL+BG_URL_SET[_mapNo]);
            alpha = 0.0;
        }

        public override function init():void
        {
            // _root.cacheAsBitmap = true;
            main.addEventListener("caption_end",test);
            _skipButton = SimpleButton(_root.getChildByName(SKIP_BUTTON));

            if (_skipButton)
            {
                _skipButton.addEventListener(MouseEvent.CLICK, skipButtonHandler);
            }

            _totalFrames = this.MCRoot.totalFrames;
        }

        override public function final():void
        {
            if (_skipButton)
            {
                _skipButton.removeEventListener(MouseEvent.CLICK, skipButtonHandler);
                _skipButton = null;
            }
        }

        private function skipButtonHandler(e:Event):void
        {
            _skipButton.enabled = false;
            _skipButton.mouseEnabled = false;
            TitleCtrl.instance.stopBGM();
            Dialogue.instance.clearData();
            dispatchEvent(new Event(SKIP_EVENT));
        }

        private function test(e:Event):void
        {
            if (e.target.currentFrame == _totalFrames)
            {
                log.writeLog(log.LV_FATAL, this, "test story BG fire",e.target.currentFrame);
                _root.removeEventListener(Event.ENTER_FRAME,test);
                dispatchEvent(new Event("caption_end"));
            }

        }

        public function play():void
        {
            if(_root != null)
            {
                // SwfNameInfo.toLog(main);
                // SwfNameInfo.toLog(_root);
            for(var i:int = 0; i < _root.numChildren; i++)
            {
                _root.getChildAt(i).addEventListener("caption_end",test);
            }
            _root.addEventListener(Event.ENTER_FRAME,test);
            log.writeLog(log.LV_FATAL, this, "story bg total flame",_root.totalFlames);
                // main.addEventListener("caption_end",test)
                _root.play();
            }
        }

    }

}
