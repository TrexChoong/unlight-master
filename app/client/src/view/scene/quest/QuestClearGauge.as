package view.scene.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;
    import flash.filters.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import controller.*;
    import model.events.*;

    import view.image.quest.*;
    import view.scene.*;


    /**
     * クリアのゲージ
     *
     */
    public class QuestClearGauge extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "現在、攻略している地域のクエスト達成度です";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "Progress of quests in the current area.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "當前攻略地區的任務完成度。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "现在正在攻略的区域的任务达成率。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "현재 공략중인 지역의 퀘스트 달성도 입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Progression de votre Quête";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "現在、攻略中している地域のクエスト達成度です";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "ระดับความสำเร็จของเควสที่กำลังสำรวจในพื้นที่ปัจจุบัน";


        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ
        //                                                       0     1    2    3    4    5    6    7    8    9    10   11   12   13   14   15   16   17   18
        private static const __N_X_SET:Vector.<int> = Vector.<int>([333, 134, 153,
                                                                  100, 278, 285, 152, 280, 390, 312, 99 ,
                                                                  305, 117, 104, 279, 314, 115, 231, 82 ,
                                                                  127, 295, 128, 225, 72 , 177, 322, 384,
                                                                  117, 97,  217, 366, 229, 166, 330, 382,
                                                                  215]);                         // 地形のX位置
        private static const __N_Y_SET:Vector.<int> = Vector.<int>([338, 334, 176,
                                                                  320, 408, 333, 230, 270, 198, 110, 154,
                                                                  78 , 113, 207, 170, 260, 307, 374, 427,
                                                                  104, 111, 211, 283, 364, 444, 368, 252,
                                                                  194, 369, 430, 323, 295,  98,  88, 200,
                                                                  255]);              // 地形のY基本位置
        private static const __E_X_SET:Vector.<int> = Vector.<int>([330,150,130,295,300]);                         // 地形のX位置
        private static const __E_Y_SET:Vector.<int> = Vector.<int>([155,150,355,385,270]);              // 地形のY基本位置
        private static const __T_X_SET:Vector.<int> = Vector.<int>([330,150,130,295,300]);                         // 地形のX位置
        private static const __T_Y_SET:Vector.<int> = Vector.<int>([155,150,355,385,270]);              // 地形のY基本位置
        private static const __C_X_SET:Vector.<int> = Vector.<int>([330,150,130,295,300,330,150,130,295,300]);                         // 地形のX位置
        private static const __C_Y_SET:Vector.<int> = Vector.<int>([155,150,355,385,270,330,150,130,295,300]);              // 地形のY基本位置
        private static const __X_SET:Vector.<Vector.<int>> = Vector.<Vector.<int>>([__N_X_SET,__E_X_SET,__T_X_SET,__C_X_SET]);
        private static const __Y_SET:Vector.<Vector.<int>> = Vector.<Vector.<int>>([__N_Y_SET,__E_Y_SET,__T_Y_SET,__C_Y_SET]);

        private var _avatar:Avatar;
        private var _numLabel:Label = new Label();
        private var _ct:ColorTransform = new ColorTransform(0.3,0.3,0.3);// トーンを半分に
        private var _ct2:ColorTransform = new ColorTransform(1.0,1.0,1.0);// トーンを半分に

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["現在、攻略中している地域のクエスト達成度です"],
                [_TRANS_MSG],
                [""]
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _QUEST_HELP:int = 0;

        private var _gauge:QuestGauge;
        private var _num:int;
        private var _diff:int;
        private var _questType:int = Const.QUEST_NORMAL;
        /**
         * コンストラクタ
         *
         */
        public function QuestClearGauge()
        {
            visible = false;
            _gauge = new QuestGauge();
            addChild(_gauge);

//            _num.text = "5/10"
            _numLabel.x = -20
            _numLabel.y = 9;
            _numLabel.width = 60;
            _numLabel.height = 30;
            _numLabel.styleName = "ClearGaugeLabel";
            _numLabel.filters = [new GlowFilter(0x000000, 1.0, 4, 4, 3, 1),];
            addChild(_numLabel);

        }

        private function  labelInit():void
        {
            var n:int = (_num>_diff) ? _diff:_num;
            _numLabel.htmlText = n.toString()+"/"+_diff.toString();

            // クエスト達成度が限界突破してるなら表示しない
            if(_avatar.questCap)
            {
                visible = false;
            }
            else
            {
                Player.instance.avatar.questFlag == QuestCtrl.instance.currentMapNo ? visible = true : visible = false ;
            }
        }
        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            toolTipOwnerArray.push([0,this]);  //
            toolTipOwnerArray.push([0,_numLabel]);  //
        }

        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }
        public override function init():void
        {
            _avatar = Player.instance.avatar;
//             x = __X_SET[_avatar.questFlag];
//             y = __Y_SET[_avatar.questFlag];
            new ModelWaitThread(QuestMap.ID(_avatar.questFlag+1), updateMap).start();
            _avatar.addEventListener(Avatar.QUEST_FLAG_UPDATE, mapUpdateHandler);
            _avatar.addEventListener(Avatar.QUEST_CLEAR_NUM_UPDATE, numUpdateHandler);
            initilizeToolTipOwners();
            updateHelp(_QUEST_HELP);
        }

        // 後始末処理
        public override function final():void
        {
            _avatar.removeEventListener(Avatar.QUEST_FLAG_UPDATE, mapUpdateHandler);
            _avatar.removeEventListener(Avatar.QUEST_CLEAR_NUM_UPDATE, numUpdateHandler);

        }

        // マップのアップデート
        private function mapUpdateHandler(e:Event):void
        {
            new ModelWaitThread(QuestMap.ID(_avatar.questFlag+1), updateMap).start();
        }

        // 達成度のアップデート
        private function numUpdateHandler(e:Event):void
        {
            // 大きさを達成度を変える
            _num = _avatar.questClearNum;
            _gauge.updateQuestClearNum(_num);
            // ラベルも更新
            labelInit();
        }
        private function updateMap():void
        {
//            visible = true;
            Player.instance.avatar.questFlag == QuestCtrl.instance.currentMapNo ? visible = true : visible = false ;

            _diff = QuestMap.ID(_avatar.questFlag+1).difficulty;
            _num = _avatar.questClearNum;;
            log.writeLog(log.LV_FATAL, this, "diff is",_diff,_avatar.questFlag+1);
            // ゲージを正しい位置において
            var mapStartNo:int = 0;
            if (_avatar.questType == Const.QUEST_EVENT) {
                mapStartNo = QuestMap.EVENT_QUEST_START_ID;
            } else if (_avatar.questType == Const.QUEST_TUTORIAL) {
                mapStartNo = QuestMap.TUTORIAL_QUEST_START_ID;
            } else if (_avatar.questType == Const.QUEST_CHARA_VOTE) {
                mapStartNo = QuestMap.CHARA_VOTE_QUEST_START_ID;
            }
            x = __X_SET[_questType][_avatar.questFlag-mapStartNo];
            y = __Y_SET[_questType][_avatar.questFlag-mapStartNo];
            _gauge.setQuestMap(_diff);
            _gauge.updateQuestClearNum(_num);

            // ラベルも更新
            labelInit();
        }
        public function set questType(type:int):void
        {
            _questType = type;
        }

        public function setFade(fade:Boolean):void
        {
            if (fade)
            {
                this.transform.colorTransform = _ct;

            }else{
                this.transform.colorTransform = _ct2;
            }
        }




    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.events.*;
import org.libspark.thread.Thread;

import model.BaseModel;

import view.BaseShowThread;
import view.IViewThread;
import view.scene.common.AvatarClip;

class ModelWaitThread extends Thread
{
    private var _func:Function;
    private var _args:Array;
    private var _m:BaseModel;

    public function ModelWaitThread(m:BaseModel,func:Function, args:Array =null)
    {
        _m = m;
        _func = func;
        _args = args;

    }

    protected override function run():void
    {
//            log.writeLog(log.LV_INFO, this, "run?");
        if (_m.loaded == false)
        {
            log.writeLog(log.LV_INFO, this, "waiting?",_m,_m.id);
            _m.wait();
        }
        next(callFunc);
    }

    private function callFunc():void
    {
        _func.apply(this, _args);
    }
}
