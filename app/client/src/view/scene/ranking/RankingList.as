package view.scene.ranking
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
     * マッチング画面のアバター表示部分のクラス
     *
     */
    public class RankingList extends BaseScene
    {

        // アバターインスタンス
        private var _avatar:Avatar = Player.instance.avatar;

//         private var _rank:Label = new Label();                        // ランク
//         private var _name:Label = new Label();                     // 名前
        private const _PAGE_NUM:int =10;
        private const _RANK_MAX:int =100;
        private const _PAGE_LENGTH:int =_RANK_MAX/_PAGE_NUM;

        private const _RANK_DEAULT_STR:String = "*"
        private const _NAME_DEAULT_STR:String = "------------------"

        private const _LABEL_WIDTH:int = 170;                     // ラベルの幅
        private const _LABEL_HEIGHT:int = 20;                     // ラベルの高さ

        private const _RANK_X:int  = 4;            // コメントエリアのX位置
        private const _ARROW_X:int = 28 + _RANK_X; // コメントエリアのX位置
        private const _NAME_X:int  = 50 + _RANK_X; // コメントエリアのX位置
        private const _RANK_Y:int  = 471;          // コメントエリアのY位置
        private const _RANK_H:int  = 16;           // コメントエリアのY位置

        //private const _RANK_Y:int = 103;                       // コメントエリアのY位置

        private var _rankListSet:Array  =[];  /* of Array */
        private var _nameListSet:Array  = []; /* of Array */
        private var _arrowListSet:Array = []; /* of Array */
        private var _pointListSet:Array = []; /* of Array */

        private var _myRank:Label = new Label();                        // ランク
        private var _myPoint:Label = new Label();                        // ランク
        private const _MY_RANK_X:int = 48;                       // コメントエリアのX位置
        private const _MY_RANK_Y:int = 635;                       // コメントエリアのY位
        private const _MY_RANK_W:int = 60;                     // ラベルの幅
        private const _MY_RANK_H:int = 32;                     // ラベルの高さ
        private const _MY_POINT_X:int = 115 + _MY_RANK_X;                       // コメントエリアのX位置
        private const _MY_POINT_Y:int = _MY_RANK_Y;                       // コメントエリアのY位
        private const _MY_POINT_W:int = 60;                     // ラベルの幅
        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _MATCH_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function RankingList()
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
                pointLabel.y = nameLabel.y = arrowImage.y= rankLabel.y = _RANK_Y+_RANK_H*i;
                pointLabel.width = nameLabel.width = _LABEL_WIDTH;
                pointLabel.height = rankLabel.height = nameLabel.height = _LABEL_HEIGHT;
                rankLabel.text = "*";
                nameLabel.text = "----------------";
                rankLabel.styleName = "RankingLabel";

                rankLabel.filters = [new GlowFilter(0xFFFFFF, 1, 1.5, 1.5, 16, 1),];
                rankLabel.width =32;
                _container.addChild(rankLabel);
                _container.addChild(arrowImage);
                _container.addChild(nameLabel);
                _container.addChild(pointLabel);
                nameLabel.setStyle("color","#CCCCCC");
                pointLabel.setStyle("color","#CCCCCC");
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
            _myRank.text = "123456";
            _myRank.styleName = "MyRankLabel";
            _myPoint.setStyle("fontSize",  "12");
            _myPoint.setStyle("textAlign",  "center");
            _myPoint.setStyle("color","#CCCCCC");
            _myRank.filters = [new GlowFilter(0xFFFFFF, 1, 1.8, 1.8, 16, 1),];
            _container.addChild(_myRank);
            _container.addChild(_myPoint);
        }

        public function pageChange(t:int, start:int):void
        {
            var a:Array = RankingData.getList()[t].getRanking(start*_PAGE_NUM,_PAGE_NUM);
            var nameList:Vector.<String> = a[0]; /* of String */
            var arrowList:Vector.<int> = a[1]; /* of int */
            var pointList:Vector.<int> = a[2]; /* of int */

            for(var i:int = 0; i < _PAGE_NUM; i++){
                if (nameList!=null && arrowList!=null && nameList[i] !=null && pointList!=null)
                {
//                 log.writeLog(log.LV_FATAL, this, "pageChange5", i, nameList[i], arrowList[i]);
                _rankListSet[i].text = (start*_PAGE_NUM+i+1).toString();
//                 log.writeLog(log.LV_FATAL, this, "pageChange6", _rankListSet[i], (start+i+1).toString());
                _arrowListSet[i].setDirection(arrowList[i]);
//                 log.writeLog(log.LV_FATAL, this, "pageChange7", _arrowListSet[i]);
                _nameListSet[i].text = nameList[i];
//                 log.writeLog(log.LV_FATAL, this, "pageChange8", _nameListSet[i]);
                
                _pointListSet[i].text = "["+pointList[i].toString()+"]";
                }
            }
        }

        public function updateMyRank(t:int):void
        {
            var rankType:int = RankingData.getRankType(t);
            var r:int = 0;
            var p:int = 0;
            switch (rankType)
            {
            case Const.RANK_TYPE_WD: // 週のデュエルランク
                r = RankingData.weeklyDuel.myRank;
                p = RankingData.weeklyDuel.myPoint;
                break;
            case Const.RANK_TYPE_WQ: //
                r = RankingData.weeklyQuest.myRank;
                p = RankingData.weeklyQuest.myPoint;
                break;
            case Const.RANK_TYPE_TD: //
                r = RankingData.totalDuel.myRank;
                p = RankingData.totalDuel.myPoint;
                break;
            case Const.RANK_TYPE_TQ: //
                r = RankingData.totalQuest.myRank;
                p = RankingData.totalQuest.myPoint;
                break;
            case Const.RANK_TYPE_TE: //
                r = RankingData.totalEvent.myRank;
                p = RankingData.totalEvent.myPoint;
                break;
            case Const.RANK_TYPE_TV: //
                r = RankingData.totalCharaVote.myRank;
                p = RankingData.totalCharaVote.myPoint;
                break;
            default:
            }
            if (rankType == Const.RANK_TYPE_TV) {
                _myRank.text = "--";
                _myPoint.text = "";
            } else {
                if (r==0)
                {
                    _myRank.text = "--";
                }else{
                    _myRank.text = r.toString();
                }
                if (p==0)
                {
                    _myPoint.text = "";
                }else{
                    _myPoint.text = p.toString();
                }
            }
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {

        }

        //
        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        // 初期化
        public override function init():void
        {
//            _avatarView.addEventListener(Avatar.ENERGY_MAX_UPDATE, _avatarView.avatarUpdateHandler);

            initilizeToolTipOwners();
            updateHelp(_MATCH_HELP);
            addChild(_container);
        }

        // 終了
        public override function final():void
        {
//            _avatarView.removeEventListener(Avatar.ENERGY_UPDATE, _avatarView.avatarUpdateHandler)
            RemoveChild.all(_container)
            RemoveChild.apply(_container);
        }


    }
}