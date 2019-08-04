package view.image.shop
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;

    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;

    import view.RaidHelpView;
    import view.image.BaseImage;
    import view.utils.RemoveChild;

    import controller.TitleCtrl;

    import model.Option;

    /**
     *  購入パネル
     *
     */

    public class BuySendPanel extends Panel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "このアイテムを購入しますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "個";

        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM	:String = "Confirm";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "Buy this item?";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = " pieces";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "確定要購買這個道具？";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "個";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM	:String = "确认";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "是否购买这个道具？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "个";

        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM	:String = "확인";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "이 아이템을 구입하겠습니까?";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "個";

        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM	:String = "Confirmer";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "Souhaitez-vous acheter cet objet ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = " pièce";

        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "このアイテムを購入しますか？";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "個";

        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM :String = "ตกลง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG     :String = "จะซื้อไอเท็มนี้หรือไม่?";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "ชิ้น";


        // タイトル表示
        private var _text:Label = new Label();

        // 決定ボタン
        private var _yesButton:Button = new Button();
        private var _noButton:Button = new Button();

        // 個数選択
        private var _amountSelecter:AmountSelectComboBox = new AmountSelectComboBox();

        // 個数選択のありなし
        private var _selecterSet:Boolean = true;

        // アイテム名
        private var _itemName:Label = new Label();
        private var _itemNumLabel1:Label = new Label();
        private var _itemNumLabel2:Label = new Label();

        // 購入時データバー
        private var _buyDataBar:ShopBuyParamBar = new ShopBuyParamBar();

        // 所持と値段データ
        private var _priceData:PossessionAndPriceData;

        // ジェム表示
        protected var _beforeGems:Label = new Label();
        protected var _afterGems:Label = new Label();

        // コイン表示
        protected var _beforeCoins:Array = [new Label(), new Label(), new Label(), new Label(), new Label(), new Label()];
        protected var _afterCoins:Array = [new Label(), new Label(), new Label(), new Label(), new Label(), new Label()];

        private const _ON_X:int      = 110;
        private const _ON_Y:int      = 230;
        private const _ON_WIDTH:int  = 550;
        private const _ON_HEIGHT:int = 250;
        private const _ON_TEXT_W:int = 228;
        private const _ON_TEXT_H:int = 50;
        private const _ON_TEXT_X:int = _ON_WIDTH / 2 - (_ON_TEXT_W / 2);
        private const _ON_TEXT_Y:int = 160;
        private const _ON_YES_X:int  = _ON_TEXT_X + 25;
        private const _ON_YES_Y:int  = _ON_TEXT_Y + 40;
        private const _ON_YES_W:int  = 60;
        private const _ON_YES_H:int  = 23;
        private const _ON_NO_X:int   = _ON_YES_X + 110;
        private const _ON_NO_Y:int   = _ON_YES_Y;
        private const _ON_NO_W:int   = 60;
        private const _ON_NO_H:int   = 23;

        private const _OFF_X:int      = 255;
        private const _OFF_Y:int      = 230;
        private const _OFF_WIDTH:int  = 250;
        private const _OFF_HEIGHT:int = 150;
        private const _OFF_TEXT_X:int = 13;
        private const _OFF_TEXT_Y:int = 60;
        private const _OFF_TEXT_W:int = 228;
        private const _OFF_TEXT_H:int = 50;
        private const _OFF_YES_X:int  = 40;
        private const _OFF_YES_Y:int  = 100;
        private const _OFF_YES_W:int  = 60;
        private const _OFF_YES_H:int  = 23;
        private const _OFF_NO_X:int   = 150;
        private const _OFF_NO_Y:int   = 100;
        private const _OFF_NO_W:int   = 60;
        private const _OFF_NO_H:int   = 23;

        private const _ITEM_NAME_X:int = 35;
        private const _ITEM_NAME_Y:int = 50;
        private const _ITEM_NAME_W:int = 230;
        private const _ITEM_NAME_H:int = 50;

        private const _ITEM_NUM_LABEL1_X:int = _ITEM_NAME_X + _ITEM_NAME_W + 20;
        private const _ITEM_NUM_LABEL1_Y:int = _ITEM_NAME_Y;
        private const _ITEM_NUM_LABEL2_X:int = _ITEM_NUM_LABEL1_X + 60;
        private const _ITEM_NUM_LABEL2_Y:int = _ITEM_NAME_Y;
        private const _ITEM_NUM_LABEL_W:int  = 20;
        private const _ITEM_NUM_LABEL_H:int  = 20;

        private const _BUY_DATA_BAR_X:int = 55;
        private const _BUY_DATA_BAR_Y:int = 90;

        private const _GEMS_X:int         = _BUY_DATA_BAR_X + 100;
        private const _GEMS_Y:int         = _BUY_DATA_BAR_Y - 1;
        private const _GEMS_WIDTH:int     = 100;
        private const _GEMS_HEIGHT:int    = 20;
        private const _GEMS_OFFSET_X:int  = 115;

        private const _COINS_A_X:int      = _BUY_DATA_BAR_X + 89;
        private const _COINS_B_X:int      = _COINS_A_X + 30;
        private const _COINS_Y:int        = _BUY_DATA_BAR_Y + 27;
        private const _COINS_WIDTH:int    = 40;
        private const _COINS_HEIGHT:int   = 20;
        private const _COINS_OFFSET_X:int = 72;

        /**
         * コンストラクタ
         *
         */
        public function BuySendPanel()
        {
            super();

            layout = "absolute"
            title = _TRANS_CONFIRM;

            _text.text = _TRANS_MSG;
            _text.styleName = "BuySendPanelLabel";
            _text.setStyle("textAlign", "center");

            _yesButton.label = "Yes";

            _noButton.label = "No";

            // NameLabel
            _itemName.x = _ITEM_NAME_X;
            _itemName.y = _ITEM_NAME_Y;
            _itemName.width  = _ITEM_NAME_W;
            _itemName.height = _ITEM_NAME_H;
            _itemName.text = "";
            _itemName.styleName = "BuySendPanelLabel";
            _itemName.setStyle("textAlign", "right");
            _itemName.visible = false;

            // ItemNumLabel
            _itemNumLabel1.x = _ITEM_NUM_LABEL1_X;
            _itemNumLabel1.y = _ITEM_NUM_LABEL1_Y;
            _itemNumLabel1.text = "×";
            _itemNumLabel2.x = _ITEM_NUM_LABEL2_X;
            _itemNumLabel2.y = _ITEM_NUM_LABEL2_Y;
            _itemNumLabel2.text = _TRANS_MSG2;
            _itemNumLabel1.width  = _itemNumLabel2.width  = _ITEM_NUM_LABEL_W;
            _itemNumLabel1.height = _itemNumLabel2.height = _ITEM_NUM_LABEL_H;
            _itemNumLabel1.styleName = _itemNumLabel2.styleName = "BuySendPanelLabel";
            _itemNumLabel1.setStyle("textAlign", "left");
            _itemNumLabel2.setStyle("textAlign", "left");
            _itemNumLabel1.visible = false;
            _itemNumLabel2.visible = false;

            // NumSelector
            _amountSelecter.x = _ITEM_NUM_LABEL2_X - 40;
            _amountSelecter.y = _ITEM_NUM_LABEL2_Y;

            // GemLabel
            _beforeGems.text = "";
            _beforeGems.styleName = "ShopGemsNumeric";
            _afterGems.text = "";
            _afterGems.styleName = "ShopGemsNumeric";

            // bar
            _buyDataBar.x = _BUY_DATA_BAR_X;
            _buyDataBar.y = _BUY_DATA_BAR_Y;
            addChild(_buyDataBar);

            setPos();

            addChild(_text);
            addChild(_yesButton);
            addChild(_noButton);
            addChild(_beforeGems);
            addChild(_afterGems);

            // コイン
            _beforeCoins.forEach(function(label:Label, index:int, array:Array):void{
                    label.text = "";
                    label.styleName = "ShopCoinsNumeric";
                    addChild(label);
                        });
            _afterCoins.forEach(function(label:Label, index:int, array:Array):void{
                    label.text = "";
                    label.styleName = "ShopCoinsNumeric";
                    addChild(label);
                        });

        }

        //
        public function get yesButton():Button
        {
            return _yesButton;
        }

        //
        public function get noButton():Button
        {
            return _noButton;
        }

        //
        public function get amount():int
        {
            return int(_amountSelecter.selectedItem);
        }

        public function setSelecterItems(avatarGems:int, gemPrice:int, avatarCoin:Array, coinPrice:Array, itemName:String):void
        {
            _priceData = new PossessionAndPriceData(avatarGems,gemPrice,avatarCoin,coinPrice);
            _amountSelecter.setDatas(_priceData.buyPossibleCnt);
            _amountSelecter.selectedIndex = 0;
            _itemName.text = itemName;
            selectVisible = true;
            RaidHelpView.instance.isUpdate = false;
        }

        public function set selectVisible(f:Boolean):void
        {
            _selecterSet = f;
            setPos();
            setPriceText();
        }

        private function set itemNameVisible(f:Boolean):void
        {
            _itemName.visible = _itemNumLabel1.visible = _itemNumLabel2.visible = f;
            if (f) {
                addChild(_itemName);
                addChild(_itemNumLabel1);
                addChild(_itemNumLabel2);
            }else {
                RemoveChild.apply(_itemName);
                RemoveChild.apply(_itemNumLabel1);
                RemoveChild.apply(_itemNumLabel2);
            }
        }

        private function setPos():void
        {
            if (_selecterSet) {
                itemNameVisible = true;
                _buyDataBar.visible = true;

                // Panel
                x = _ON_X;
                y = _ON_Y;
                width  = _ON_WIDTH;
                height = _ON_HEIGHT;

                // Text
                _text.x = _ON_TEXT_X;
                _text.y = _ON_TEXT_Y;
                _text.width = _ON_TEXT_W;
                _text.height = _ON_TEXT_H;

                // YesButton
                _yesButton.x = _ON_YES_X;
                _yesButton.y = _ON_YES_Y;
                _yesButton.width = _ON_YES_W;
                _yesButton.height = _ON_YES_H;

                // NoButton
                _noButton.x = _ON_NO_X;
                _noButton.y = _ON_NO_Y;
                _noButton.width = _ON_NO_W;
                _noButton.height = _ON_NO_H;

                // 所持&結果Gem
                _beforeGems.x = _GEMS_X;
                _afterGems.x = _GEMS_X + _GEMS_OFFSET_X;
                _beforeGems.y = _afterGems.y = _GEMS_Y;
                _beforeGems.width = _afterGems.width = _GEMS_WIDTH;
                _beforeGems.height = _afterGems.height = _GEMS_HEIGHT;

                // コイン
                _beforeCoins.forEach(function(item:*, index:int, array:Array):void{setCoinLabelPos(item, index, false)});
                _afterCoins.forEach(function(item:*, index:int, array:Array):void{setCoinLabelPos(item, index, true)});

                _amountSelecter.visible       = true;
                _amountSelecter.mouseEnabled  = true;
                _amountSelecter.mouseChildren = true;
                _amountSelecter.addEventListener(ListEvent.CHANGE, amountSelectHandler);
                addChild(_amountSelecter);
            } else {
                itemNameVisible = false;
                _buyDataBar.visible = false;

                // Panel
                x = _OFF_X;
                y = _OFF_Y;
                width  = _OFF_WIDTH;
                height = _OFF_HEIGHT;

                // Text
                _text.x = _OFF_TEXT_X;
                _text.y = _OFF_TEXT_Y;
                _text.width = _OFF_TEXT_W;
                _text.height = _OFF_TEXT_H;

                // YesButton
                _yesButton.x = _OFF_YES_X;
                _yesButton.y = _OFF_YES_Y;
                _yesButton.width = _OFF_YES_W;
                _yesButton.height = _OFF_YES_H;

                // NoButton
                _noButton.x = _OFF_NO_X;
                _noButton.y = _OFF_NO_Y;
                _noButton.width = _OFF_NO_W;
                _noButton.height = _OFF_NO_H;

                // 所持&結果Gem
                _beforeGems.x = _afterGems.x = 0;
                _beforeGems.y = _afterGems.y = 0;
                _beforeGems.width = _afterGems.width = 0;
                _beforeGems.height = _afterGems.height = 0;

                // コイン
                _beforeCoins.forEach(function(item:*, index:int, array:Array):void{setCoinLabelPos(item, index, false)});
                _afterCoins.forEach(function(item:*, index:int, array:Array):void{setCoinLabelPos(item, index, true)});

                _amountSelecter.visible       = false;
                _amountSelecter.mouseEnabled  = false;
                _amountSelecter.mouseChildren = false;
                _amountSelecter.removeEventListener(ListEvent.CHANGE, amountSelectHandler);
                RemoveChild.apply(_amountSelecter);
            }
        }

        private function setCoinLabelPos(label:Label, num:int, t:Boolean):void
        {
            if (_selecterSet) {
                if(t)
                {
                    label.x = _COINS_B_X + _COINS_OFFSET_X * num;
                }
                else
                {
                    label.x = _COINS_A_X + _COINS_OFFSET_X * num;
                }
                // exコイン
                if(num >= 5)
                {
                    label.x -= _COINS_OFFSET_X * (num+1);
                }
                label.y = _COINS_Y;
                label.width = _COINS_WIDTH;
                label.height = _COINS_HEIGHT;
            } else {
                label.x = label.y = label.width = label.height = 0
            }
        }

        private function amountSelectHandler(e:ListEvent):void
        {
            setPriceText();
        }

        private function setPriceText():void
        {
            if (_selecterSet) {
                // 所持&結果Gem
                _beforeGems.text = _priceData.avatarGems.toString();
                var resultGems:int = _priceData.avatarGems - (_priceData.gemPrice * amount);
                _afterGems.text = (resultGems < 0) ? String(resultGems) : resultGems.toString();
                _afterGems.styleName = (resultGems < 0) ? "ShopGemsNumericRed" : (_priceData.gemPrice > 0) ? "ShopGemsNumericYellow" : "ShopGemsNumeric";

                // モンスターコイン
                for(var i:int = 0; i < _priceData.coinPrice.length; i++)
                {
                        coinCalc(_beforeCoins[i], _afterCoins[i], _priceData.avatarCoin[i], _priceData.coinPrice[i] * amount);
                }

            } else {
                // 所持&結果Gem
                _beforeGems.text = _afterGems.text = "";
                // コイン
                _beforeCoins.forEach(function(label:Label, index:int, array:Array):void{label.text = "";});
                _afterCoins.forEach(function(label:Label, index:int, array:Array):void{label.text = "";});
            }
        }

        // コイン計算用の関数
        private function coinCalc(l0:Label, l1:Label, c0:int, c1:int):void
        {
            l0.text = c0.toString();
            l1.text = c0 - c1 < 0 ? String(c0 - c1) : (c0 - c1).toString();
            l1.styleName = c0 - c1 < 0 ? "ShopCoinsNumericRed" : c1 > 0 ? "ShopCoinsNumericYellow" : "ShopCoinsNumeric";
        }

        override public function set visible(value:Boolean):void
        {
            super.visible = value;
            RaidHelpView.instance.isUpdate = (value) ? false : true;
        }
    }
}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import mx.controls.ComboBox;
import org.libspark.thread.Thread;

import model.DeckEditor;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.edit.SortArea;

class AmountSelectComboBox extends ComboBox
{
    private static const _DATAS:Array = [1,2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100];

    public function AmountSelectComboBox():void
    {
        setDatas(45);
        dropdownWidth = 50;
        // x = 450;
        // y = 75;
        width = 35;
        height =18;
    }

    public function setDatas(num:int=0):void
    {
        if (num > 0) {
            var setDatas:Array = [];
            var i:int = 0;
            while ( i < _DATAS.length  && _DATAS[i] <= num) {
                setDatas.push(_DATAS[i]);
                i++;
            }
            dataProvider = setDatas;
        } else {
            // 購入出来ない場合は、1だけ選択できる状態にする
            dataProvider = [1];
        }
    }
}

class PossessionAndPriceData
{
    private var _avatarGems:int = 0;
    private var _gemPrice:int = 0;
    private var _avatarCoin:Array = [];
    private var _coinPrice:Array = [];

    private var _buyPossibleCnt:int = 0;

    public function PossessionAndPriceData(avatarGems:int, gemPrice:int, avatarCoin:Array, coinPrice:Array):void
    {
        _avatarGems = avatarGems;
        _gemPrice   = gemPrice;
        _avatarCoin = avatarCoin;
        _coinPrice  = coinPrice;

        calcBuyPossibleCnt();
    }

    private function calcBuyPossibleCnt():void
    {
        var checkArray:Array = [];
        var checkNum:int = 0;
        checkNum = (_gemPrice > 0) ? _avatarGems/_gemPrice : 0;

        var isBuyPossible:Boolean = true;
        // Gem
        if (checkNum > 0) {
            checkArray.push(checkNum);
        } else if (_gemPrice > 0) {
            isBuyPossible = false;
        }

        // モンスターコイン
        for(var i:int = 0; i < _coinPrice.length; i++)
        {
            if (_coinPrice[i] > 0) {
                if (i < 5)
                {
                    checkNum = _avatarCoin[i]/_coinPrice[i];
                }
                else if (i >= 5)
                {
                    checkNum = _avatarCoin[i]/_coinPrice[i];
                }

                if (checkNum > 0) {
                    checkArray.push(checkNum);
                } else {
                    isBuyPossible = false;
                }
            }
        }

        // 個数配列をソート
        checkArray.sort(asc);

        // 最小のものを返す
        if (isBuyPossible) {
            _buyPossibleCnt = checkArray[0];
        }else {
            _buyPossibleCnt = 0; // 0以下なら購入不可
        }
    }
    private function asc(a:int,b:int):int
    {
        return (int(a>b)-int(a<b));
    }

    public function get avatarGems():int
    {
        return _avatarGems;
    }
    public function get gemPrice():int
    {
        return _gemPrice;
    }
    public function get avatarCoin():Array
    {
        return _avatarCoin;
    }
    public function get coinPrice():Array
    {
        return _coinPrice;
    }
    public function get buyPossibleCnt():int
    {
        return _buyPossibleCnt;
    }

}

