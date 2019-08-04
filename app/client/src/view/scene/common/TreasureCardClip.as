package view.scene.common
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;
    import mx.events.ToolTipEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import view.image.common.*;
    import view.image.quest.*;
    import view.utils.*;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.scene.common.*;
    import view.scene.game.BuffClip;
    import view.scene.ModelWaitShowThread;

    /**
     * TreasureCardClipのアイコン表示クラス
     * 全部ビットマップでキャッシュすべできか。同時に二つでることがない？
     */

    public class TreasureCardClip extends BaseScene
    {
        // イメージ
        private var _frame:TreasureCardFrame = new TreasureCardFrame();
        private var _card:BaseScene;
        private var _metaContainer:UIComponent = new UIComponent;
        private var _container:UIComponent = new UIComponent;
        private var _backContainer:UIComponent = new UIComponent;
        private var _obverse:Boolean = false;
        private var _numLabel:Label = new Label;
        private var _num:int = 0;
        private var _treasureName:String;

        private var _avatar:Avatar = Player.instance.avatar;
        /**
         * コンストラクタ
         *
         */
        public static function createNoticeTreasure(type:int, cType:int, cardID:int, num:int=1):TreasureCardClip
        {
            switch (type)
            {
            case Const.TG_CHARA_CARD: // 武器カード
                return new TreasureCardClip(type,cType,cardID,num);
                break;
            case Const.TG_SLOT_CARD: // スロットカード
                return new TreasureCardClip(type,cType,cardID,num);
                break;
            case Const.TG_AVATAR_ITEM: // あばたアイテム
                return new TreasureCardClip(type,cType,cardID,num);
                break;
            case Const.TG_AVATAR_PART: // あばたぱーつ
                return new TreasureCardClip(type,cType,cardID,num);
                break;
            case Const.TG_GEM: // ジェム
                return new TreasureCardClip(type,cType,num);
                break;
            case Const.TG_OWN_CARD: // 自カードLv1
                return new TreasureCardClip(type,cType,cardID,num);
                break;
            default:
                return new TreasureCardClip(type,cType,cardID,num);
            }
        }


        public function TreasureCardClip(type:int, cType:int, val:int,num:int = 1)
        {
            switch (type)
            {
            case Const.TG_CHARA_CARD: // 武器カード
                initCharaCardClip(val);
                break;
            case Const.TG_SLOT_CARD: // スロットカード
                initSlotCardClip(cType,val);
                break;
            case Const.TG_AVATAR_PART: // あばたアイテム
                initPartCardClip(val);
                break;
            case Const.TG_AVATAR_ITEM: // あばたアイテム
                initItemCardClip(val);
                break;
            case Const.TG_GEM: // ジェム
                initGemCardClip(val);
                break;
            case Const.TG_OWN_CARD: // 自カード val=chara_card_id
                initCharaCardClip(val)
                break;
            default:
            }
            _frame.getShowThread(_container).start();
            _card.getShowThread(_backContainer).start();

            _metaContainer.addChild(_container);
            _metaContainer.addChild(_backContainer);

            _frame.x = 84;
            _frame.y = 120;
            _container.x = -80;
            _container.y = -120;

            // 後ろ側反転させておく
            _backContainer.x =  80;
            _backContainer.y = -120;
            _backContainer.scaleX = -1;
            _backContainer.visible = false;

            addChild(_metaContainer);
            _num = num;
            _numLabel.x = 30;
            _numLabel.y = 80;
            _numLabel.width = 96;
            _numLabel.height = 48;
            _numLabel.styleName = "ResultCardNumLabel";
            _numLabel.htmlText = "x" + "<FONT SIZE =\"32\" FACE = \"minchoB\" >"+num.toString()+"</FONT>" ;
            _numLabel.filters = [ new GlowFilter(0x000000, 1, 2, 2, 16, 1) ];
            _numLabel.visible = false;
            addChild(_numLabel);
            if (_num > 1)
            {
                _treasureName += ("x"+_num.toString())
            }

        }
        private function initCharaCardClip(id:int):void
        {
            _card = new CharaCardClip(CharaCard.ID(id), true);
            _treasureName = CharaCard.ID(id).name;
            // キャラカードならレベルとレアかどうかをついか
            if (CharaCard.ID(id).kind == Const.CC_KIND_CHARA)
            {
                _treasureName += (" Lv."+CharaCard.ID(id).level.toString());
                if (CharaCard.ID(id).isRare())
                {
                    _treasureName += (" R");
                }
            }
        }

        private function initSlotCardClip(type:int, id:int):void
        {
            switch (type)
            {
            case Const.SCT_WEAPON: // 武器カード
                _card = new WeaponCardClip(WeaponCard.ID(id));
                _treasureName = WeaponCard.ID(id).name;
               break;
            case Const.SCT_EQUIP: // 装備カード
                _card = new EquipCardClip(EquipCard.ID(id));
                _treasureName = EquipCard.ID(id).name;
                break;
            case Const.SCT_EVENT: // イベントカード
                _card = new EventCardClip(EventCard.ID(id));
                _treasureName = EventCard.ID(id).name;
                break;
            default:
                }
        }
        private function initItemCardClip(id:int):void
        {
            _card = new ItemCardClip(AvatarItem.ID(id))
                _treasureName = AvatarItem.ID(id).name;
        }

        private function initPartCardClip(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "+++init partClip",id);
            _card = new PartCardClip(AvatarPart.ID(id))
                _treasureName = AvatarPart.ID(id).name;
        }

        private function initGemCardClip(val:int):void
        {
            _card = new GemCardClip(val, GemCardClip.TYPE_NUM);
            _treasureName =  val.toString()+"GEM";
        }
        public function isFlip():Boolean
        {
            return _backContainer.scaleX == -1;
        }


        public function flipReset(flip:Boolean):void
        {
            if (flip)
            {
                _backContainer.scaleX=-1;
                _backContainer.x=80;
            }
            else
            {
                _backContainer.scaleX=1;
                _backContainer.x=-80;
            }
        }

        public  override function set rotationY(arg:Number):void
        {
            _metaContainer.rotationY = arg;
            if (arg%360<94||arg%360>274)
            {
                _container.visible = true;
                _backContainer.visible = false;
                _obverse = false;
            }else{
                _container.visible = false;
                _backContainer.visible = true;
                _obverse = true;

            }

        }

        public  override function get rotationY():Number
        {
            return _metaContainer.rotationY;
        }

        public function get metaFrame():UIComponent
        {
            return _metaContainer;
        }


        // 初期化
        public override function init():void
        {
        }

        // 後処理
        public override function final():void
        {
            RemoveChild.apply(_frame);
            if(_card != null)
            {
                _card.getHideThread().start();
            }
        }


        public function getFlipThread(o:Boolean = false):Thread
        {
            return new FlipCardThread(this, o)
        }
        public function get treasureName():String
        {
            return _treasureName;
        }

        public function showNum():void
        {
            if(_num > 1)
            {
                _numLabel.visible = true;
            }else{
                _numLabel.visible = false;

            }

        }


    }

}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.geom.*;

import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import model.CharaCard;
import view.scene.common.TreasureCardClip;
import view.BaseShowThread;
import view.BaseHideThread;
import controller.LobbyCtrl;


// RotateThread
class FlipCardThread extends Thread
{
    private var _ccc:TreasureCardClip;
    private var _x:int;
    private var _y:int;
    private var _scaleX:Number;
    private var _scaleY:Number;

    private var _rot:Number;
    private var _flip:Boolean;

    public function FlipCardThread(ccc:TreasureCardClip, flip:Boolean)
    {
        _ccc = ccc;
        _flip = flip;
        if (_flip)
        {_rot = 360;}else{_rot = 180};
    }

    protected override function run():void
    {

//                (new TweenerThread (this, { z:-100, transition:"easeOutExpo", time: 0.15} )).start();
//                (new BeTweenAS3Thread(this, {z:-100}, null, 0.15, BeTweenAS3Thread.EASE_OUT_EXPO )).start();
//        var t:Thread = new TweenerThread (_ccc, { rotationY:_rot, transition:"easeOutExpo", time: 0.3} );
        var t:Thread = new BeTweenAS3Thread(_ccc, {rotationY:_rot}, null, 0.3, BeTweenAS3Thread.EASE_OUT_EXPO );
        SE.playCharaCardRotate();
        t.start();
        t.join();
        next(fin)

    }

    private function fin():void
    {
        // 3D変換によるボケをリセットする。
        // もっとスマートな方法があるかもしれないが、いまのところ。
        _x=_ccc.metaFrame.x;
        _y=_ccc.metaFrame.y;
        _scaleX=_ccc.metaFrame.scaleX;
        _scaleY=_ccc.metaFrame.scaleY;
        _ccc.metaFrame.transform.matrix3D = null;
        _ccc.metaFrame.x=_x;
        _ccc.metaFrame.y=_y;
        _ccc.metaFrame.scaleX=_scaleX;
        _ccc.metaFrame.scaleY=_scaleY;
        _ccc.flipReset(_flip);
        _ccc.showNum();

    }


    
}
