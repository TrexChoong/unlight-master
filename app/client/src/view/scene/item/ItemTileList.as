package view.scene.item
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import flash.utils.Dictionary;

    import flash.filters.DropShadowFilter;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.core.ClassFactory;
    import mx.containers.*;
    import mx.controls.*;
    import mx.collections.ArrayCollection;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import view.scene.common.*;
    import model.events.*;

    import view.image.common.AvatarItemImage;
    import view.image.item.*;

    import view.scene.BaseScene;
    import view.image.BaseImage;
    import view.scene.ModelWaitShowThread;
    import view.*;
    import view.utils.*;
    import view.image.common.*;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * ItemInventoryClipを自前でタイル表示する
     * 
     */

    public class ItemTileList extends UIComponent
    {
        // 描画コンテナ
        protected var _containerSet:Vector.<UIComponent> = Vector.<UIComponent>([new UIComponent()]);

        private var _itemInventoryClipSet:Vector.<BaseInventoryClip> = new Vector.<BaseInventoryClip>();

        private var _columnCount:int = 3;
        private var _rawCount:int = 3;
        private var _currentPage:int =0;
        private var _maxPage:int =0;

        private var _itemWidth:int = 95;
        private var _itemHeight:int = 95;

        // ページ数ラベル
        private var _pageNum:Label = new Label();


        /**
         * コンストラクタ
         *
         */
        public function ItemTileList()
        {
            _pageNum.x = 218;
            _pageNum.y = 288;
            _pageNum.width = 30;
            _pageNum.height = 20;
            _pageNum.styleName = "ItemListNumericRight2";
        }

        public function setItemInventoryData(a:Array):void
        {
//            log.writeLog(log.LV_FATAL, this, "set item inventory data",a);
            _itemInventoryClipSet = Vector.<BaseInventoryClip>(a);
            updateData();
        }
        public  function  final():void
        {
            var len:int = _itemInventoryClipSet.length;

            for(var i:int = 0; i < len; i++)
            {
                RemoveChild.apply(_itemInventoryClipSet[i]);
                _itemInventoryClipSet[i].removeEventListener(MouseEvent.CLICK, clickHandler);
            }
            removeChild(_pageNum);
        }

        public function set columnCount(i:int):void
        {
            _columnCount = i;
        }

        public function set rawCount(i:int):void
        {
            _rawCount= i;
        }

        public function set itemWidth(i:int):void
        {
            _itemWidth = i;
        }

        public function set itemHeight(i:int):void
        {
            _itemHeight= i;
        }

        private function get pageNum():int
        {
            return _columnCount * _rawCount;
        }
        public function setPagePositon(nx:int ,ny:int):void
        {
            _pageNum.x = nx;
            _pageNum.y = ny;

        }

        public function changePage(i:int):void
        {
//            log.writeLog(log.LV_FATAL, this, "change page",i );
             _currentPage = i;
             RemoveChild.all(this);
             if (_containerSet[i]!=null)
             {
                 addChild(_containerSet[i]);
             }
             pageNumUpdate();

            addChild(_pageNum);
        }

        public function clickHandler(e:MouseEvent):void
        {
            unselectPage();
            dispatchEvent(new SelectItemEvent(SelectItemEvent.ITEM_CHANGE, e.target, true, true));
        }

        public function unselectPage():void
        {
//             log.writeLog(log.LV_FATAL, this, "inselect page ",pageNum<_itemInventoryClipSet.length ? pageNum:_itemInventoryClipSet.length);
//             log.writeLog(log.LV_FATAL, this, "inselect page ",pageNum,_itemInventoryClipSet.length, pageNum,_itemInventoryClipSet.length);
//             log.writeLog(log.LV_FATAL, this, "current page ",_currentPage);
            var len:int =_itemInventoryClipSet.length;
            var pNum:int = pageNum;

            for(var i:int = 0; i < pNum; i++)
            {
                if (len > (i+(_currentPage*pNum)))
                {
                    if (_itemInventoryClipSet[i+(_currentPage*pNum)]!=null)
                    {
                        _itemInventoryClipSet[i+(_currentPage*pNum)].offSelect();
                    }
                }
            }
        }

        public function updateData():void
        {

            var len:int = _itemInventoryClipSet.length;
            var pNum:int = pageNum;
            var cNum:int = -1;
            _maxPage = -1

//            log.writeLog(log.LV_FATAL, this, "update data",len);
            for(var i:int = 0; i < len; i++)
            {
                // ページMAXに到達したならば現在ページをインクリメントして新ページのコンテナを作る
                if(i%pNum == 0)
                {
                    _maxPage++;
                    cNum++;
                    _containerSet[cNum] = new UIComponent();
                }
                // 特定ページの特定の場所に配置する。
                addChild(_itemInventoryClipSet[i]);
                _itemInventoryClipSet[i].getShowThread(_containerSet[cNum]).start();
                _itemInventoryClipSet[i].x = i%pNum%_columnCount*_itemWidth ;
                _itemInventoryClipSet[i].y = int(i%pNum/_columnCount)*_itemHeight ;
                _itemInventoryClipSet[i].addEventListener(MouseEvent.CLICK, clickHandler);
                addChild(_containerSet[cNum]);
            }
            changePage(_currentPage);

        }


        public function removeItemAt(at:int):void
        {
            log.writeLog(log.LV_FATAL, this, "delete at ", at);
            _itemInventoryClipSet[at].getHideThread().start();
            _itemInventoryClipSet.splice(at,1);
            updateData();
        }

        public function addItem(ic:ItemInventoryClip):void
        {
            log.writeLog(log.LV_FATAL, this, "add item ", ic);
            _itemInventoryClipSet.push(ic);
            updateData();
        }



        public function nextPage():void
        {
            log.writeLog(log.LV_FATAL, this, "next ");
            if (_maxPage > 0 && _maxPage == _currentPage)
            {
                changePage(0);
            }
            else if (_maxPage > 0)
            {
                changePage(_currentPage+1>_maxPage ? _maxPage:_currentPage+1);
            }
        }

        public function backPage():void
        {
            if (_maxPage > 0 && _currentPage == 0)
            {
                changePage(_maxPage);
            }
            else
            {
                changePage(_currentPage-1<1 ? 0:_currentPage-1);
            }
        }

        public function firstPage():void
        {
            changePage(0);
        }

        public function endPage():void
        {
            if (_maxPage > 0)
            {
                changePage(_maxPage);
            }

        }

        public function pageNumUpdate():void
        {
            if (_maxPage > 0)
            {
                _pageNum.text = (_currentPage+1).toString()+"/"+(_maxPage+1).toString();
            }else{
                _pageNum.text = ""
            }
        }

        public function isNextButtonExist():Boolean
        {
            if (_maxPage > 0) return true;

            return (_currentPage<_maxPage)
        }
        public function isBackButtonExist():Boolean
        {
            if (_maxPage > 0) return true;

            return (_currentPage > 0)
        }


    }
}


