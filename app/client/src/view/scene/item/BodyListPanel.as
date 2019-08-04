package view.scene.item
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import flash.utils.Dictionary;

    import flash.filters.DropShadowFilter;
    import flash.geom.*;
    import flash.events.TimerEvent;
    import flash.utils.*;

    import mx.core.UIComponent;
    import mx.core.ClassFactory;
    import mx.containers.*;
    import mx.controls.*;
    import mx.collections.ArrayCollection;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.common.AvatarItemImage;
    import view.image.item.*;

    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.*;
    import view.utils.*;
    import view.scene.common.*;

    import controller.LobbyCtrl;
    import controller.*;

    import view.image.common.*;
    /**
     * BodyListPanelの表示クラス
     *
     */

    public class BodyListPanel extends BaseItemListPanel
    {

        // 位置定数
        public static const _ITEM_LIST_X:int = 24;
        public static const _ITEM_LIST_Y:int = 104;

        private var _time:Timer;


        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MAX		:String = "アバターパーツが所持数の限界を超えています。　どれかのパーツを捨ててください";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAX_DIALOG	:String = "パーツMAX警告";
        CONFIG::LOCALE_JP
        private static const _TRANS_ITEMUSE		:String = "一度でも使用するとタイマーが作動して期限に達すると消滅します。\n使用しますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_ITEMUSE_DIALOG	:String = "期限付きアイテムの確認";
        CONFIG::LOCALE_JP
        private static const _TRANS_ITEMDEL		:String = "本当にこのアイテムを削除しますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_ITEMDEL_DIALOG	:String = "確認";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MAX		:String = "虛擬人物配件超過最大持有數量。請捨棄任一配件。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAX_DIALOG	:String = "警告：配件已滿";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ITEMUSE		:String = "一旦使用之後，就會開始倒數計時，在時間歸零之後將會自動消失。\n確定要使用嗎？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ITEMUSE_DIALOG	:String = "時效道具的確認";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ITEMDEL		:String = "真的要刪除這個道具嗎？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ITEMDEL_DIALOG	:String = "確認";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MAX		:String = "虚拟人物的配件数量超过上限。请舍弃其中的一个配件。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAX_DIALOG	:String = "配件超上限警告";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ITEMUSE		:String = "使用过一次后将开始计时，到期后配件失效。\n是否使用？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ITEMUSE_DIALOG	:String = "确认有时间限制的道具";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ITEMDEL		:String = "是否删除这个道具？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ITEMDEL_DIALOG	:String = "确认";

        CONFIG::LOCALE_EN
        private static const _TRANS_MAX		:String = "You have exceeded the maximum number of avatar parts.\nPlease choose a part to discard.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAX_DIALOG	:String = "Warning: parts full";
        CONFIG::LOCALE_EN
        private static const _TRANS_ITEMUSE		:String = "The first time you use this item, a timer will start. Even if you only use the item once, it will disappear when the timer elapses.\nDo you still want to use it now?";
        CONFIG::LOCALE_EN
        private static const _TRANS_ITEMUSE_DIALOG	:String = "Time limited item confirmation.";
        CONFIG::LOCALE_EN
        private static const _TRANS_ITEMDEL		:String = "Do you really want to delete this item?";
        CONFIG::LOCALE_EN
        private static const _TRANS_ITEMDEL_DIALOG	:String = "Confirm";

        CONFIG::LOCALE_KR
        private static const _TRANS_MAX		:String = "アバターパーツが所持数の限界を超えています。　どれかのパーツを捨ててください";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAX_DIALOG	:String = "パーツMAX警告";
        CONFIG::LOCALE_KR
        private static const _TRANS_ITEMUSE		:String = "一度でも使用するとタイマーが作動して期限に達すると消滅します。\n使用しますか？";
        CONFIG::LOCALE_KR
        private static const _TRANS_ITEMUSE_DIALOG	:String = "期限付きアイテムの確認";
        CONFIG::LOCALE_KR
        private static const _TRANS_ITEMDEL		:String = "本当にこのアイテムを削除しますか？";
        CONFIG::LOCALE_KR
        private static const _TRANS_ITEMDEL_DIALOG	:String = "確認";

        CONFIG::LOCALE_FR
        private static const _TRANS_MAX		:String = "Vous avez ajouté trop d'équipements. Veuillez en supprimer un.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAX_DIALOG	:String = "Attention";
        CONFIG::LOCALE_FR
        private static const _TRANS_ITEMUSE		:String = "Le temps commencera a être décompté à partir du moment où vous utiliserez l'objet. Ce dernier disparaîtra lorsque le temps sera écoulé.\nSouhaitez-vous l'utiliser ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_ITEMUSE_DIALOG	:String = "Confirmer";
        CONFIG::LOCALE_FR
        private static const _TRANS_ITEMDEL		:String = "Voulez-vous vraiment supprimer cet objet ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_ITEMDEL_DIALOG	:String = "Confirmer";

        CONFIG::LOCALE_ID
        private static const _TRANS_MAX		:String = "アバターパーツが所持数の限界を超えています。　どれかのパーツを捨ててください";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAX_DIALOG	:String = "パーツMAX警告";
        CONFIG::LOCALE_ID
        private static const _TRANS_ITEMUSE		:String = "一度でも使用するとタイマーが作動して期限に達すると消滅します。\n使用しますか？";
        CONFIG::LOCALE_ID
        private static const _TRANS_ITEMUSE_DIALOG	:String = "期限付きアイテムの確認";
        CONFIG::LOCALE_ID
        private static const _TRANS_ITEMDEL		:String = "本当にこのアイテムを削除しますか？";
        CONFIG::LOCALE_ID
        private static const _TRANS_ITEMDEL_DIALOG	:String = "確認";

        CONFIG::LOCALE_TH
        private static const _TRANS_MAX     :String = "มีชิ้นส่วนของอวาตาร์ครบตามจำนวนที่จำกัดแล้ว กรุณาเลือกทิ้งชิ้นส่วนชิ้นใดชิ้นหนึ่ง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MAX_DIALOG  :String = "คำเตือน จำนวนชิ้นส่วนถึงขีดจำกัดแล้ว";
        CONFIG::LOCALE_TH
        private static const _TRANS_ITEMUSE     :String = "จะทำการนับเวลาไอเท็มเมื่อใช้ และไอเท็มจะหายไปเมื่อครบเวลาที่กำหนด\nจะใช้ไอเท็มนี้ไหม?";
        CONFIG::LOCALE_TH
        private static const _TRANS_ITEMUSE_DIALOG  :String = "ยืนยันไอเท็มที่มีการจำกัดระยะเวลา";
        CONFIG::LOCALE_TH
        private static const _TRANS_ITEMDEL     :String = "จะลบไอเท็มนี้ไหม?";
        CONFIG::LOCALE_TH
        private static const _TRANS_ITEMDEL_DIALOG  :String = "ตกลง";


        /**
         * コンストラクタ
         *
         */
        public function BodyListPanel()
        {
            _time = new Timer(1000);
            _time.addEventListener(TimerEvent.TIMER, updateDuration);
            super();
        }

        protected  override function panelImageInit():void
        {
            _itemInventoryPanelImage = new ItemInventoryPanelImage(AvatarPart.PARTS_TYPE_SET[partsGenre]);
        }

        protected override function get itemInventoryPanelImage():BasePanelImage
        {
            return _itemInventoryPanelImage;
        }

        protected function get partsGenre():int
        {
            return  AvatarPart.GENRE_BODY;
        }

        // 初期化
        public override function init():void
        {
            _container.addChild(itemInventoryPanelImage);
            addChild(_container);
            var itemNum:int = 0; // アイテムの個数

            // アイテムをソートする
//            AvatarItemInventory.sortAvatarItemId();
//            log.writeLog(log.LV_FATAL, this, "sort by id!!!!");
            AvatarPartInventory.sortAvatarPartId();

            // データを空っぽにする
            _dpList = [];

            // データを格納するタブを作成
            for(var i:int = 0; i < AvatarPart.PARTS_TYPE_SET[partsGenre].length; i++)
            {
//                log.writeLog(log.LV_FATAL, this, "tab create !!!!");
                var dp:Array = [];
                _dpList.push(dp);
            }
            inventoryToData();
//                log.writeLog(log.LV_FATAL, this, "data tabcreate!!! ");


            // データを格納するタブを作成
            for(i = 0; i < tabTypes.length; i++)
            {
//                log.writeLog(log.LV_FATAL, this, "init tab create i=" ,i);
                createTileList(new ItemTileList());

//                log.writeLog(log.LV_FATAL, this, "set item inven", _itemList[i],_dpList[i]);
                _itemList[i].setItemInventoryData(_dpList[i]);
//                log.writeLog(log.LV_FATAL, this, "set item inven evnd", i);
            }
//                log.writeLog(log.LV_FATAL, this, "eventset ");

//            log.writeLog(log.LV_FATAL, this, "init add event");
            // イベントを設定
            for(i = 0; i < _itemList.length; i++)
            {
                _itemList[i].addEventListener(SelectItemEvent.ITEM_CHANGE, selectItemHandler);
            }

//            log.writeLog(log.LV_FATAL, this, "label init ");

            textLabelInit();

            itemInventoryPanelImage.addEventListener(SelectTabEvent.TAB_CHANGE, selectTabHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.USE_ITEM, useItemHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.REMOVE_PART, removePartHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.DROP_PART, dropPartHandler);

            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.PAGE_FIRST, pageFirstHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.PAGE_END, pageEndHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.PAGE_NEXT, pageNextHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.PAGE_BACK, pageBackHandler);



            ctrl.addEventListener(AvatarPartEvent.EQUIP_PART, equipPartSuccessHandler);
            ctrl.addEventListener(AvatarPartEvent.VANISH_PART, partVanishHandler);
//            ctrl.addEventListener(AvatarPartEvent.GET_PART, getPartSuccessHandler);

            selectTabHandler(new SelectTabEvent(SelectTabEvent.TAB_CHANGE, 0))

        }

        protected override function get tabTypes():Array
        {
            return AvatarPart.PARTS_TYPE_SET[partsGenre]
        }

        // インベントリからデータを生成する
        protected override function inventoryToData():void
        {
            var i:int;
//            log.writeLog(log.LV_FATAL, this, "invenory2data!!!!");
            var itemNum:int = 0; // アイテムの個数
            // データプロバイダーにタイプごとのアイテムを設定する
            var genreParts:Array = AvatarPartInventory.getGenreItems(partsGenre);
//            log.writeLog(log.LV_FATAL, this, "invenory2data!!!! parts len is ",genreParts.length);

            for(i = 0; i < genreParts.length; i++)
            {
//                log.writeLog(log.LV_FATAL, this, "inventory is ",genreParts[i], i ,genreParts[i].avatarPart.id);
                var avatarPart:AvatarPart = genreParts[i].avatarPart;
//                log.writeLog(log.LV_FATAL, this, "inventory is ",avatarPart);
                // アイテムのイメージを作成
                setItem(avatarPart);
//                log.writeLog(log.LV_FATAL, this, "set item end ");
                if(genreParts[i].equiped)
                {
                    _itemDic[avatarPart].onEquip();
                }else{
                    _itemDic[avatarPart].offEquip();

                }
//                log.writeLog(log.LV_FATAL, this, "set eq end ",_itemDic,_itemDic[avatarPart]);
                // アイテムの個数をインクリメント
                _itemDic[avatarPart].count = 1;
                // 次が違うアイテムなら個数と共に表示
//                log.writeLog(log.LV_FATAL, this, "set genre ",genreParts[i+1]);
                if(genreParts[i+1] == null || avatarPart != genreParts[i+1].avatarPart)
                {
                    _dpList[avatarPart.type-AvatarPart.PARTS_GENRE_ID[partsGenre]].push(_itemDic[avatarPart]);
                }
            }

        }

        // DicにAvatarItemを格納
        protected override function setItem(item:*):void
        {
//             log.writeLog(log.LV_FATAL, this, "setItem ",item);
//             log.writeLog(log.LV_FATAL, this, "setItem ",_itemDic);
            if (_itemDic == null){_itemDic = new Dictionary()};
            if (_itemDic[item] == null)
            {
                _itemDic[item] = new PartInventoryClip(item);
            }
        }




        // 後処理
        public override function final():void
        {
            if (!_finished)
            {
                resetSelectItem();
                // データを格納するタブの削除
                for(var i:int = 0; i < AvatarPart.PARTS_TYPE_SET[partsGenre].length; i++)
                {
                    if (_itemList !=null)
                    {
                        _itemList[i].removeEventListener(SelectItemEvent.ITEM_CHANGE, selectItemHandler);
                        RemoveChild.apply(_itemList[i]);
                    }
                    if (_dpList != null)
                    {
                        _dpList[i] = null;
                    }
                }

                itemInventoryPanelImage.removeEventListener(SelectTabEvent.TAB_CHANGE, selectTabHandler);
                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.USE_ITEM, useItemHandler);
                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.REMOVE_PART, removePartHandler);
                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.DROP_PART, dropPartHandler);

                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.PAGE_FIRST, pageFirstHandler);
                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.PAGE_END, pageEndHandler);
                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.PAGE_NEXT, pageNextHandler);
                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.PAGE_BACK, pageBackHandler);


                ctrl.removeEventListener(AvatarItemEvent.USE_ITEM, useItemSuccessHandler);
                ctrl.removeEventListener(AvatarItemEvent.GET_ITEM, getItemSuccessHandler);
                ctrl.removeEventListener(AvatarPartEvent.EQUIP_PART, equipPartSuccessHandler);
                ctrl.removeEventListener(AvatarPartEvent.VANISH_PART, partVanishHandler);

                RemoveChild.all(_container);

                RemoveChild.apply(_container);

                for (var key:Object in _itemDic) {
                    _itemDic[key].getHideThread().start();
                    delete  _itemDic[key];
                }


                itemInventoryPanelImage.final();
                RemoveChild.apply(itemInventoryPanelImage);
                RemoveChild.apply(_container);
                _itemDic = null;
                _itemList  =null;
                _dpList = null;
                _selectItem = null;
                RemoveChild.apply(this);
                _time.removeEventListener(TimerEvent.TIMER, updateDuration);
                super.final();
            }
        }

        protected override function textLabelInit():void
        {

            // 選択中のアイテムの名前
            _selectItemName.x = 106;
            _selectItemName.y = 424;
            _selectItemName.width = 200;
            _selectItemName.height = 30;
            _selectItemName.styleName = "ItemListNumericRight2";
            _container.addChild(_selectItemName);
            // 選択中のアイテムの説明
            _selectItemCount.x = -10;
            _selectItemCount.y = 526;
            _selectItemCount.width = 135;
            _selectItemCount.height = 30;
            _selectItemCount.styleName = "ItemListNumericRight2";
            _container.addChild(_selectItemCount);
            // 選択中のアイテムの効果時間
            _selectItemTime.x = -10;
            _selectItemTime.y = 462;
            _selectItemTime.width = 135;
            _selectItemTime.height = 30;
            _selectItemTime.styleName = "ItemListNumericRight2";
            _container.addChild(_selectItemTime);
            // 選択中のアイテムの使用場所
            _selectItemTiming.x = -10;
            _selectItemTiming.y = 494;
            _selectItemTiming.width = 135;
            _selectItemTiming.height = 30;
            _selectItemTiming.styleName = "ItemListNumericRight2";
            _container.addChild(_selectItemTiming);
            // 選択中のアイテムの説明
            _selectItemCaption.x = 145;
            _selectItemCaption.y = 463;
            _selectItemCaption.width = 165;
            _selectItemCaption.height = 100;
            _selectItemCaption.styleName = "ItemListNumericLeft";
            _container.addChild(_selectItemCaption);

        }

        protected override function createSelectItemImage():void
        {
            // 選択中のアイテムのイメージ
            _selectImage = new AvatarPartIcon(_selectItem.avatarPart);
            _selectImage.x = 320;
            _selectImage.y = 416;
            _selectImage.scaleX = _selectImage.scaleY = 1.0;
            _container.addChild(_selectImage);

            _selectItemName.text = _selectItem.avatarPart.name;
            _selectItemCount.text = _selectItem.count.toString();
            if (_selectItem.avatarPart.duration > 0 )
            {
                _selectItemTime.text = TimeFormat.toDateString(_selectItem.avatarPart.duration);
            }else{
                _selectItemTime.text = "-";
            }
            if(_selectItem.avatarPart.activeted)
            {
                _selectItemTime.text = _selectItemTime.text + " "+"["+TimeFormat.toString(_selectItem.avatarPart.remainTime)+"]"; ;
                _time.start();
                log.writeLog(log.LV_FATAL, this, "tiemrstart",_time.running);
            }else{
                _time.stop();
            }


            _selectItemTiming.text = "-";
            _selectItemCaption.text = _selectItem.avatarPart.caption;;

            setButton()
        }


        private function updateDuration(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "update duration");
            _selectItemTime.text =  TimeFormat.toDateString(_selectItem.avatarPart.duration);
            _selectItemTime.text = _selectItemTime.text + " "+"["+TimeFormat.toString(_selectItem.avatarPart.remainTime)+"]"; ;

        }

        protected function setButton():void
        {
            if (_itemDic[_selectItem.avatarPart].equiped)
            {
                itemInventoryPanelImage.offUse();
                ItemInventoryPanelImage(itemInventoryPanelImage).offDrop();
            }else{
                itemInventoryPanelImage.onUse();
                if(Player.instance.avatar.checkMaxPartInventory&&AvatarPartInventory.getTypeItems(_selectItem.avatarPart.type).length>1)
                {
                    log.writeLog(log.LV_FATAL, this, "set button drop on");
                    ItemInventoryPanelImage(itemInventoryPanelImage).onDrop();
                }else{
                    ItemInventoryPanelImage(itemInventoryPanelImage).offDrop();
                }
            }
        }


        // アイテムが使われた
        protected override function useItemHandler(e:Event):void
        {
            SE.playClick();
            if (Player.instance.avatar.checkMaxPartInventory)
            {
                Alerter.showWithSize(_TRANS_MAX, _TRANS_MAX_DIALOG);
            }else{

                // アクティベートされてなかったら確認ダイアログをだしてからおくる
                if(_selectItem.avatarPart.duration > 0 && _selectItem.avatarPart.activeted == false)
                {
                    ConfirmPanel.show(_TRANS_ITEMUSE_DIALOG, _TRANS_ITEMUSE,useItem,this)
                        }else{
                    useItem();
                }
            }
        }
        private function useItem():void
        {
            itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.USE_ITEM, useItemHandler);
            itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.REMOVE_PART, removePartHandler);
            itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.DROP_PART, dropPartHandler);
//             log.writeLog(log.LV_FATAL, this, "use button done");
            _lobbyCtrl.setPart(AvatarPartInventory.getPartsInventoryID(_selectItem.avatarPart));

        }


        // アイテムが外された
        protected override  function removePartHandler(e:Event):void
        {
            itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.USE_ITEM, useItemHandler);
            itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.REMOVE_PART, removePartHandler);
            itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.DROP_PART, dropPartHandler);
            SE.playClick();
//             log.writeLog(log.LV_FATAL, this, "remove part done");
            _lobbyCtrl.setPart(AvatarPartInventory.getPartsInventoryID(_selectItem.avatarPart));
        }



        // アイテムが使われた
        private function dropPartHandler(e:Event):void
        {
            SE.playClick();
            ConfirmPanel.show(_TRANS_ITEMDEL_DIALOG, _TRANS_ITEMDEL,dropPart,this)
        }

        private function dropPart():void
        {
            itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.USE_ITEM, useItemHandler);
            itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.REMOVE_PART, removePartHandler);
            itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.DROP_PART, dropPartHandler);
//             log.writeLog(log.LV_FATAL, this, "use button done");
//            _lobbyCtrl.setPart(AvatarPartInventory.getPartsInventoryID(_selectItem.avatarPart));
            _lobbyCtrl.partDrop(AvatarPartInventory.getPartsInventoryID(_selectItem.avatarPart));


        }


        // アイテム使用ハンドラ
        private function pushUseYesHandler(e:MouseEvent):void
        {
        }

        // アイテム購入キャンセル
        private function pushUseNoHandler(e:MouseEvent):void
        {
            SE.playClick();

            //            _useSendPanel.visible = false;
            _container.mouseChildren = true;
            _container.mouseEnabled = true;

        }
        // アイテム装備に成功した時のイベント
        private function equipPartSuccessHandler(e:AvatarPartEvent):void
        {
            itemInventoryPanelImage.offUse();
            itemInventoryPanelImage.offRemove();
            ItemInventoryPanelImage(itemInventoryPanelImage).offDrop();

            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.USE_ITEM, useItemHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.REMOVE_PART, removePartHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.DROP_PART, dropPartHandler);
            inventoryToData();
            resetSelectItem();
        }

        protected override function resetSelectItem():void
        {

            _time.stop();
            super.resetSelectItem();

        }

        // アイテム消失に成功した場合のハンドラ
        protected function partVanishHandler(e:AvatarPartEvent):void
        {
            var dp:Array;
            var deleteIndex:int = -1;
            log.writeLog(log.LV_FATAL, this, "0");

            for(var i:int = 0; i < AvatarPart.PARTS_TYPE_SET[partsGenre].length; i++)
            {
                log.writeLog(log.LV_FATAL, this, "1",i);
                dp = _dpList[i].slice();


                for(var j:int = 0; j < dp.length; j++)
                {
                    log.writeLog(log.LV_FATAL, this, "2", j, dp[j].avatarPart.id,e.id);
                    if(dp[j].avatarPart.id == e.id)
                    {
                        log.writeLog(log.LV_FATAL, this, "x",j);

                        // アイテムを減算した後、0個なら消去する
                        _itemList[_selectTabIndex].removeItemAt(j);
                        resetSelectItem();
                        // 使用できないようにする
                        itemInventoryPanelImage.offUse();
                        itemInventoryPanelImage.offRemove();
                        ItemInventoryPanelImage(itemInventoryPanelImage).offDrop();
                        deleteIndex  = j;

                        if (deleteIndex > -1)
                        {
                            _dpList[i].splice(deleteIndex,1);
                        }
                        break;
                    }
                }


            }

        }


    }






}

