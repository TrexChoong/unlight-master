package view.scene.regist
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;
    import flash.filters.*;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;
    import org.libspark.betweenas3.core.easing.IEasing;
    import org.libspark.betweenas3.events.TweenEvent;

    import view.scene.BaseScene;
    import view.ClousureThread;
    import view.image.regist.*;
    import view.scene.common.AvatarPartIcon;
    import view.scene.common.AvatarPartClip;

    import model.AvatarPart;



    /**
     *アバター編集クラス
     *
     */


    public class AvatarStyleEditor extends BaseScene
    {

        private static const NORMAL_SCALE:Number = 1;

        private var _bg:AvatarStyleEditorBG = new AvatarStyleEditorBG();
        private var _parts:AvatarPartsImage = new AvatarPartsImage();

        private static const TYPE_SHAPE_Y:int = 138;
        private static const AVATAR_IMAGE_X:int = 323;
        private static const AVATAR_IMAGE_Y:int = 516;
        // 選択済みなければならないタイプのリスト定数
        private static const AVATAR_MUST_TYPE_LIST:Array = [true,true,true,true]; /* of Boolean*/
        // アバターのタイプ名
        private var TYPE_LABEL_NAME:Array  = ["Body", "Eyes" ,"Mouth","Hair" ]; /* of String */
        // タイプとインデックスを一致させる配列
        private var TYPE_INDEX:Array  = [0,1,2,3];


        private var _selectedType:int = -1;
        private var _selectedTypeShape:Shape = new Shape();
        private var _selectedItemShape:Shape = new Shape();
        // タイプ定数から作るべきだが仮に決めうちで
        // 選択したタイプごとのパーツID
        private var _selectedList:Array = [1,-1,-1,-1]; /* of Int */
        private var _selectedIndexList:Array = [0,-1,-1,-1]; /* of Int */
        // 同上
        // 選択可能なタイプごとのパーツIDのリスト
        private var _registPartsList:Array =[[], [], [],[]]; /* of Array of Parts */ 
        // タイプ切り換え用のコンテナ
        private var _typeContainerList:Array =[new BaseScene(),new BaseScene(),new BaseScene(),new BaseScene()]; /* of Sprite */
        // アバターのイメージ保存用Array
        private var _avatarImageArray:Array = [[], [], [],[]]; /* of avatarClip */
        // タイプラベル
        private var _typeLabel:Label = new Label();
        // アバターコンテナ
        private var _avatarContainer:UIComponent = new UIComponent();

        // 選択済み枠の位置保存
        private var _selectedShapePointList:Array  = [new Point(468,232), new Point(0,0), new Point(0,0), new Point(0,0), new Point(0,0)]; /* of point */

        // 初期リストは登録済み？
        private var _registed:Boolean =false;


        /**
         * コンストラクタ
         *
         */

        public function AvatarStyleEditor()
        {
            // セレクト枠を足す
            addChild(_selectedTypeShape);
            addChild(_selectedItemShape);
//            addChild(_typeLabel);
            for(var i:int = 0; i < _typeContainerList.length; i++)
            {
                addChild(_typeContainerList[i]);
                _typeContainerList[i].visible = true;
                _typeContainerList[i].mouseEnabled =false;
                _typeContainerList[i].mouseChildren = false;
            }
            // タイプセレクタの描画
            _selectedTypeShape.graphics.lineStyle(2,0xFFFFFF);
            _selectedTypeShape.graphics.drawRoundRect(0,TYPE_SHAPE_Y,63,47,0);
            _selectedTypeShape.filters = [new GlowFilter(0xFFFFAA, 1.0, 5.0,5.0, 2)];
            _selectedTypeShape.visible = false;
            // アイテムセレクタの描画
            _selectedItemShape.graphics.lineStyle(2,0xFFFFFF);
            _selectedItemShape.graphics.drawRoundRect(0,0,80,111,0);
//             _selectedItemShape.graphics.drawRoundRect(-26,-7,80,111,0);
//             _selectedItemShape.x = -26;
//             _selectedItemShape.y = -7;

            _selectedItemShape.filters = [new GlowFilter(0xFFFFAA, 1.0, 5.0,5.0, 2)];
            _selectedItemShape.visible = false;
            alpha = 0.0;
            _typeLabel.x = 511;
            _typeLabel.y = 204;
            _typeLabel.width = 161;
            _typeLabel.height = 22;
            _typeLabel.styleName = "RegistStyleTypeLabel";
            _typeLabel.text = "none";
            addChild(_typeLabel)
            super();
        }

        // 初期化
        public override function init():void
        {
             _parts.typeListSetEventListener(typeButtonHandler);
             _parts.itemListSetEventListener(itemButtonHandler);
              if (_registed==false)
              {
                  AvatarPart.getRegistParts().forEach(registPartsLoad);
                  _registed = true;
              }
        }

        public override function final():void
        {
             _parts.typeListRemoveEventListener(typeButtonHandler);
             _parts.itemListRemoveEventListener(itemButtonHandler);
        }

        // パーツを登録する
        private function registPartsLoad(item:*, index:int, array:Array):void
        {
            // まずアイコンを全部登録する

//          log.writeLog(log.LV_FATAL, this, "index is ", index);
            var type:int = type2index(item.type);
            var a:AvatarPartIcon = new AvatarPartIcon(item);
//          log.writeLog(log.LV_FATAL, this, "icon create? ", a);
            _registPartsList[type].push(a);
            var p:Point = _parts.getItemPoint(_registPartsList[type].length-1);
            a.getShowThread(_typeContainerList[type]).start();
//          log.writeLog(log.LV_FATAL, this, "icon create2? ", a);
            a.x = p.x;
            a.y = p.y;
            a.visible = false;
//          log.writeLog(log.LV_FATAL, this, "item is ", item);
            // つぎにすべてのイメージを読み込む
            var image:AvatarPartClip = new AvatarPartClip(item);
            _avatarImageArray[type].push(image);
//          log.writeLog(log.LV_FATAL, this, "image is ", image);
//            image.getShowThread(this, AvatarPartClip.TYPE_PRIORITY[item.type]).start();
//             image.getAttachShowThread(container).start();
            addChild(_avatarContainer);
            updateAvatar();
        }

        // タイプをインデクスに変換する
        private function type2index(type:int):int
        {
            return TYPE_INDEX.indexOf(type);
        }

        private function updateTypeButton():void
        {
            if (_selectedType == -1)
            {
                _selectedItemShape.visible = false;
                _selectedTypeShape.visible = false;
                _parts.itemListAllHide();
                _typeLabel.text = "none"
            }else{
                _selectedTypeShape.visible = true;
                updateItemButton();
                _typeLabel.text = TYPE_LABEL_NAME[_selectedType];
            }
        }

        private function updateItemButton():void
        {
            // アイテムのページに表示と非表示
            for(var i:int = 0; i < _typeContainerList.length; i++)
            {
//                log.writeLog(log.LV_FATAL, this, "update item button ", i);
                if (i == _selectedType)
                {
                    _typeContainerList[i].visible = true;
                }else{
                    _typeContainerList[i].visible = false;
                }
            }

            // 必要なボタンだけ表示する
            var lastIndex :int = -1;
            _registPartsList[_selectedType].forEach(function(item:*, index:int, array:Array):void
                                                    {
                                                        item.visible = true;
                                                        _parts.itemListShow(index);
                                                        lastIndex = index;
                                                    });
            for(var j:int = lastIndex+1; j < 9; j++)
            {
                _parts.itemListHide(j);
            }

            // 選択済みなら枠を出す
            if (_selectedList[_selectedType] == -1)
            {
//                log.writeLog(log.LV_INFO, this, "aaaaaaa");
                _selectedItemShape.visible = false;
            }else{
//                log.writeLog(log.LV_INFO, this, "bbb");
                _selectedItemShape.x = _selectedShapePointList[_selectedType].x;
                _selectedItemShape.y = _selectedShapePointList[_selectedType].y;

                _selectedItemShape.visible = true;
            }

        }

        // 選択されたパーツの配列
        public function get avatarSelectedStyle():Array
        {
            var ret:Array = []
                _selectedList.forEach(function(item:*, index:int, array:Array):void
                                      {
                                          if (item != -1){ ret.push(item)}
                                      })
            return ret;
        }

        // パーツがきちんと選択されているかのチェック関数
        public function validateRegistParts():Boolean
        {
            var valid:Boolean  = true;
            for(var i:int = 0; i < AVATAR_MUST_TYPE_LIST.length; i++)
            {
                // 必須タイプアイテムならアイテムがセレクトされているかをチェック
                if (AVATAR_MUST_TYPE_LIST[i])
                {
                    // 必要タイプがセレクトされていない？
                    if (_selectedList[i]==-1)
                    {
                        // 失敗
                        valid = false;
                    }
                }
            }
            return valid;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
//            _bg.showAvatarBase();
            _depthAt = at;
            var pExec:ParallelExecutor = new ParallelExecutor();
            var sExec:SerialExecutor = new SerialExecutor();
            // BGとパーツ背景をすべて出す
            pExec.addThread(_bg.getShowThread(this, 0));
            pExec.addThread(_parts.getShowThread(this,1));
            sExec.addThread(pExec);
            sExec.addThread(super.getShowThread(stage,at,type));
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return sExec;
        }

        // 消去のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            _bg.hideAvatarBase();
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.15, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            sExec.addThread(super.getHideThread());
            return sExec;
        }
        // 

        private function typeButtonHandler(e:Event):void
        {
            _selectedType = _parts.getTypeIndex(SimpleButton(e.target));
            _selectedTypeShape.x = e.target.x;
            updateTypeButton();
        }


        private function itemButtonHandler(e:Event):void
        {
            var index:int =  _parts.getItemIndex(SimpleButton(e.target))
            _selectedList[_selectedType] = _registPartsList[_selectedType][index].partID;
            _selectedItemShape.x = e.target.x;
            _selectedItemShape.y = e.target.y;
            _selectedShapePointList[_selectedType].x = e.target.x;
            _selectedShapePointList[_selectedType].y = e.target.y;
//            log.writeLog(log.LV_FATAL, this, "item index and xy", _parts.getItemIndex(SimpleButton(e.target)), e.target.x, e.target.y);
            updateItemButton();
            if (_selectedIndexList[_selectedType] != index)
            {
                _selectedIndexList[_selectedType] = index;
                updateAvatar();
            }
        }

        private function updateAvatar():void
        {
//            log.writeLog(log.LV_FATAL, this, "updateAvatar");
            var sExec:SerialExecutor = new SerialExecutor();
            var container:UIComponent = new UIComponent();

            for(var i:int = 0; i < _typeContainerList.length; i++)
            {
//                log.writeLog(log.LV_FATAL, this, "updateAvatar",i );
                for(var j:int = 0; j < _avatarImageArray[i].length; j++)
                {
//                    log.writeLog(log.LV_FATAL, this, "updateAvatar",j );
                    if (_selectedIndexList[i] == j)
                    {
                        AvatarPartClip.getAttachShowThread(Vector.<AvatarPartClip>([_avatarImageArray[i][j]]), container).start();
                    }
                }
            }
            var thread:Thread = new BeTweenAS3Thread(_avatarContainer, {alpha:0}, null, 0.25, BeTweenAS3Thread.EASE_OUT_SINE, 0.28 ,false);
            sExec.addThread(thread);
            sExec.addThread(new ClousureThread(function():void{
                        removeChild(_avatarContainer);
                        _avatarContainer = container;
                    }));
            container.scaleX = NORMAL_SCALE;
            container.scaleY = NORMAL_SCALE;
            container.x = AVATAR_IMAGE_X;
            container.y = AVATAR_IMAGE_Y;

            addChild(container);
//            removeChild(_avatarContainer);
//            _avatarContainer = container;
//            addChild(_avatarContainer);
            sExec.start();
        }
    }

}

