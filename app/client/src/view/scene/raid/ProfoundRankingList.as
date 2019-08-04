package view.scene.raid
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.utils.*;
    import view.image.ranking.*;
    import view.scene.BaseScene;
    import model.*;
    import model.events.*;

    /**
     * 渦情報のランキング表示クラス
     *
     */
    public class ProfoundRankingList extends BaseScene
    {
        private const _PAGE_NUM:int = 5;
        private const _RANK_MAX:int = 100;
        private const _PAGE_LENGTH:int =_RANK_MAX/_PAGE_NUM;

        private const _RANK_DEAULT_STR:String    = "*";
        private const _NAME_DEAULT_STR:String    = "---------";
        private const _MYRANK_DEAULT_STR:String  = "--";
        private const _MYPOINT_DEAULT_STR:String = "--";

        private const _LABEL_WIDTH:int = 165;     // ラベルの幅
        private const _LABEL_HEIGHT:int = 20;     // ラベルの高さ

        private const _RANK_X:int = 520;           // コメントエリアのX位置
        private const _ARROW_X:int = _RANK_X + 28;          // コメントエリアのX位置
        private const _NAME_X:int = _ARROW_X + 18;           // コメントエリアのX位置
        private const _RANK_Y:int = 5;          // コメントエリアのY位置
        private const _RANK_H:int = 16;           // コメントエリアのY位置
        private const _LIST_Y:int = _RANK_Y + 3;          // コメントエリアのY位置

        private var _rankListSet:Array  = []; /* of Array */
        private var _nameListSet:Array  = []; /* of Array */
        private var _arrowListSet:Array = []; /* of Array */
        private var _pointListSet:Array = []; /* of Array */

        private var _myRank:Label = new Label();  // ランク
        private var _myPoint:Label = new Label(); // ランク
        private const _MY_RANK_X:int = 325;        // コメントエリアのX位置
        private const _MY_RANK_Y:int = 23;       // コメントエリアのY位
        private const _MY_RANK_W:int = 60;        // ラベルの幅
        private const _MY_RANK_H:int = 22;        // ラベルの高さ
        private const _MY_POINT_X:int = _MY_RANK_X + 60;      // コメントエリアのX位置
        private const _MY_POINT_Y:int = _MY_RANK_Y + 2;      // コメントエリアのY位
        private const _MY_POINT_W:int = 100;       // ラベルの幅
        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

        /**
         * コンストラクタ
         *
         */
        public function ProfoundRankingList()
        {
            for(var i:int = 0; i < _PAGE_NUM; i++){
                var rankLabel:Label = new Label();
                var arrowImage:ArrowImage = new ArrowImage();
                var nameLabel:Label = new Label();
                var pointLabel:Label = new Label();
                rankLabel.x = _RANK_X;
                arrowImage.x = _ARROW_X;
                nameLabel.x = _NAME_X;
                pointLabel.x = _NAME_X;
                rankLabel.y = _RANK_Y+_RANK_H*i;
                pointLabel.y = nameLabel.y = arrowImage.y = _LIST_Y+_RANK_H*i;
                pointLabel.width = nameLabel.width = _LABEL_WIDTH;
                pointLabel.height = rankLabel.height = nameLabel.height = _LABEL_HEIGHT;
                rankLabel.text = (i+1).toString();
                rankLabel.styleName = "RankingLabel";
                arrowImage.setDirection(0);
                nameLabel.text = "------";
                pointLabel.text = "[0]";
                nameLabel.setStyle("color",0xFFFFFF);
                pointLabel.setStyle("color",0xFFFFFF);

                rankLabel.filters = [new GlowFilter(0xFFFFFF, 1, 1.5, 1.5, 16, 1),];
                rankLabel.width =32;
                _container.addChild(rankLabel);
                _container.addChild(arrowImage);
                _container.addChild(nameLabel);
                _container.addChild(pointLabel);
                pointLabel.setStyle("textAlign",  "right");

                _rankListSet.push(rankLabel);
                _arrowListSet.push(arrowImage);
                _nameListSet.push(nameLabel);
                _pointListSet.push(pointLabel);
            }
            _myRank.x = _MY_RANK_X;
            _myPoint.x = _MY_POINT_X;
            _myRank.y = _MY_RANK_Y;
            _myPoint.y =_MY_POINT_Y;
            _myRank.width = _MY_RANK_W;
            _myPoint.width = _MY_POINT_W;
            _myPoint.height = _myRank.height = _MY_RANK_H;
            _myRank.text = "100";
            _myPoint.text = "1200000003456";
            _myRank.styleName = "RaidMyRankLabel";
            _myPoint.styleName = "RaidMyRankLabel";
            _myRank.setStyle("fontSize", "18");
            _myPoint.setStyle("fontSize",  "14");
            _myPoint.setStyle("textAlign",  "center");
            _myRank.filters = [new GlowFilter(0xFFFFFF, 1, 1.8, 1.8, 16, 1),];
            _myPoint.filters = [new GlowFilter(0xFFFFFF, 1, 1.5, 1.5, 16, 1),];
            _container.addChild(_myRank);
            _container.addChild(_myPoint);
        }

        public function pageChange(prfId:int, start:int, clear:Boolean = false):void
        {
            log.writeLog(log.LV_FATAL, this, "pageChange", clear);
            var i:int;
            if (!clear) {
                var prfRank:ProfoundRanking = ProfoundRanking.getProfoundRanking(prfId);
                if (prfRank) {
                    var ranks:Array = prfRank.getRanking(start*_PAGE_NUM,_PAGE_NUM);
                    var nameList:Vector.<String> = ranks[0]; /* of String */
                    var arrowList:Vector.<int>   = ranks[1]; /* of int */
                    var pointList:Vector.<int>   = ranks[2]; /* of int */

                    for( i = 0; i < _PAGE_NUM; i++) {
                        _rankListSet[i].text = (start*_PAGE_NUM+i+1).toString();
                        _arrowListSet[i].setDirection(1);
                        //_arrowListSet[i].setDirection(arrowList[i]);
                        _nameListSet[i].text = nameList[i];
                        _pointListSet[i].text = "["+pointList[i].toString()+"]";
                    }
                }
            } else {
                for( i = 0; i < _PAGE_NUM; i++) {
                    _rankListSet[i].text = (i+1).toString();
                    _arrowListSet[i].setDirection(0);
                    _nameListSet[i].text = "------";
                    _pointListSet[i].text = "[0]";
                }
            }
        }

        public function updateMyRank(prfId:int,clear:Boolean=false):void
        {
            _myRank.text = _MYRANK_DEAULT_STR;
            _myPoint.text = "";
            if (!clear) {
                var r:int = 0;
                var p:int = 0;
                var prfRank:ProfoundRanking = ProfoundRanking.getProfoundRanking(prfId);
                if (prfRank) {
                    r = prfRank.myRank;
                    p = prfRank.myPoint;
                }
                if (r>0) _myRank.text = r.toString();
                if (p>0) _myPoint.text = p.toString();
            }
        }

        public function resetRanking(prfId:int):void
        {
            var prfRank:ProfoundRanking = ProfoundRanking.getProfoundRanking(prfId);
            if (prfRank) prfRank.resetRanking();
        }

        // 初期化
        public override function init():void
        {
            addChild(_container);
        }

        // 終了
        public override function final():void
        {
            RemoveChild.all(_container);
            RemoveChild.apply(_container);
        }


        public function get pageMax():int
        {
            return _PAGE_LENGTH;
        }

    }
}