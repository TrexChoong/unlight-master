package view.scene.library
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;
    import flash.utils.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.quest.*;
    import view.scene.BaseScene;
    import view.scene.common.StoryClip;

    import controller.QuestCtrl;
    import view.utils.*


    /**
     * キャラストーリーデッキ表示クラス
     *
     */
    public class CharaStoryListScene extends BaseScene
    {
        private static const X:int = 272;                     // タイトルのX基本位置
        private static const Y:int = 130;                     // タイトルのY基本位置
        private static const _TITLE_OFFSET_Y:int = 16;        // タイトルのYズレ

        private static const PAGE_NUM:int =30;
        private var _name:Label = new Label();

        private var _pageSet:Array = []; /* Array of UIComponent */
        private var _page:int =0;
        private var _storyListImageSet:Vector.<StoryListImage> = new Vector.<StoryListImage>();

        private var _storyClip:StoryClip;

        private var __searchStoryId:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function CharaStoryListScene(list:Array)
        {
            x  = X;
            y  = Y;
            width = 200;
            height = 300;
            var isTurn:Boolean = false;
            var setCnt:int = 0;
            list.forEach(function(item:CharaCard, index:int, array:Array):void{
                    var pn:int = int(setCnt/PAGE_NUM);
                    if ( _pageSet[pn] == null ) _pageSet[pn] = new UIComponent();
                    var si:StoryListImage;
                    si = getStoryListImage(item.storyId);
                    if (si == null) {
                        si = new StoryListImage(item,clickTitleAction,isTurn);
                        si.x = 0;
                        si.y = setCnt%PAGE_NUM*_TITLE_OFFSET_Y;

                        _pageSet[pn].addChild(si);
                        _storyListImageSet.push(si);
                        isTurn = !isTurn;
                        setCnt++;
                    } else {
                        // すでに作られている場合、書き換えるのみ
                        si.setCharaId(item);
                    }

                    // 次の時系列のタイトルを作ってしまう
                    si = null;
                    var storyData:Object = CharaCard.getNextAgeStoryCharaDataFromId(item.storyId);
                    if ( storyData != null ) {
                        if ( getStoryListImage(storyData.storyId) == null ) {
                            pn = int(setCnt/PAGE_NUM);
                            if ( _pageSet[pn] == null ) _pageSet[pn] = new UIComponent();

                            si = new StoryListImage(null,clickTitleAction,isTurn,storyData);
                            si.x = 0;
                            si.y = setCnt%PAGE_NUM*_TITLE_OFFSET_Y;

                            _pageSet[pn].addChild(si);
                            _storyListImageSet.push(si);
                            isTurn = !isTurn;
                            setCnt++;
                        }
                    }
                });

            setPage(0);
        }
        private function getStoryListImage(storyId:int):StoryListImage
        {
            __searchStoryId = storyId;
            var searchList:Vector.<StoryListImage> = _storyListImageSet.filter(getFromStoryID);
            return  (searchList.length > 0) ? searchList[0] : null;
        }
        private function getFromStoryID(item:*, index:int, vec:Vector.<StoryListImage>):Boolean
        {
            return item.storyId == __searchStoryId;
        }

        public function setPage(p:int):void
        {
            if (p>-1 && p < pageNum)
            {
                for(var i:int = 0; i < _pageSet.length; i++){
                    if (i == p)
                    {
                        addChild(_pageSet[i]);
                        _page = p;
                    }else{
                        RemoveChild.apply(_pageSet[i]);
                    }
                }
            }
        }

        override public  function final():void
        {
            for(var i:int = 0; i < _pageSet.length; i++)
            {
                RemoveChild.all(_pageSet[i]);
                RemoveChild.apply(_pageSet[i]);
            }
        }
        public function get pageNum():int
        {
            return  _pageSet.length;
        }

        public function get page():int
        {
            return  _page;
        }

        public function clickTitleAction(ccid:int):void
        {
            _storyClip = new StoryClip(CharaCard.ID(ccid).story);
            _storyClip.getShowThread(this.parent.parent.parent).start();
        }


    }
}

import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.filters.GlowFilter;
import flash.geom.*;

import mx.core.UIComponent;
import mx.controls.*;

import model.*;
import view.image.game.CharaCardStar;
import view.utils.*
import view.scene.BaseScene;
import view.image.library.*;

class StoryListImage extends BaseScene
{
    private static const W:int =28;
    private static const H:int =43;
    private static const STAR_X:int =9;
    private static const STAR_Y:int =16;
    private static const CT_DOWN:ColorTransform = new ColorTransform(0.3,0.3,0.3);// トーンを半分に
    private static const CT_ORIG:ColorTransform = new ColorTransform(1.0,1.0,1.0);// トーン元にに

    private var _name:Label = new Label();
    private var _title:StoryTitle;
    private var _cardId:int = 0;
    private var _storyId:int = 0;

    private static const _NAME_DIFF_X:int = 20;     // 板と名称のX座標の差異
    private static const _NAME_DIFF_Y:int = -10;    // 板と名称のY座標の差異
    private static const _NAME_H:int = 20;          // 名称の横幅
    private static const _NAME_W:int = 170;         // 名称の縦幅
    private static const _NAME_TURN_X:int = 200;    // 板反転時の板と名称のX座標の差異

    private var _clickFunc:Function;
    public function StoryListImage(card:CharaCard,clickFunc:Function,isTurn:Boolean=false,data:Object=null)
    {
        var charactor:int = 1000;
        var cardId:int = 0;
        var storyId:int = 0;
        var storyTitle:String = "";

        if (card) {
            charactor = card.parentID;
            cardId = card.id;
            storyId = card.storyId;
            storyTitle = card.storyTitle;
        } else {
            storyId = data.storyId;
            storyTitle = data.storyTitle;
        }
        _title = new StoryTitle(charactor);
        _title.x = 0;
        _title.y = 0;
        _title.addEventListener(MouseEvent.CLICK, mouseClickHandler);
        addChild(_title);

        _cardId = cardId;
        _storyId = storyId;

        var addNameXDiff:int = _NAME_DIFF_X;
        if ( isTurn ) {
            _title.scaleX = -1;
            addNameXDiff -= _NAME_TURN_X;
        }

        _name.x = _title.x+addNameXDiff;
        _name.y = _title.y+_NAME_DIFF_Y;
        _name.width = _NAME_W;
        _name.height = _NAME_H;

        _name.htmlText = storyTitle;
        _name.mouseEnabled = false;
        _name.mouseChildren = false;

        addChild(_name);
        _clickFunc = clickFunc;

        // カードID未設定ならトーンダウン
        if ( _cardId == 0 ) {
            _title.transform.colorTransform = CT_DOWN;
            _title.mouseEnabled = false;
            _title.mouseChildren = false;
        }
    }

    public function setCharaId(card:CharaCard):void
    {
        _cardId = card.id;
        _title.changeCharaFace(card.parentID);

        _title.transform.colorTransform = CT_ORIG;
        _title.mouseEnabled = true;
        _title.mouseChildren = true;
    }

    public override function final():void
    {
        _title.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
        _clickFunc = null;
    }

    public function get storyId():int
    {
        return _storyId;
    }

    private function mouseClickHandler(e:MouseEvent):void
    {
        if ( _clickFunc != null && _cardId != 0 ) {
            _clickFunc(_cardId);
        }
    }
}


