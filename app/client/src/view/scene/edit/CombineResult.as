package view.scene.edit
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Text;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.SerialExecutor;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.common.WeaponCardImage;
    import view.scene.common.WeaponCardClip;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.image.requirements.CombineResultImage;
    import view.image.requirements.CombineResultMarkImage;
    import view.utils.RemoveChild;

    /**
     * 合成結果表示クラス
     *
     */
    public class CombineResult extends BaseScene
    {
        CONFIG::LOCALE_JP
        private static const _TRANS_RESTRICTION:String = "専用武器";
        CONFIG::LOCALE_EN
        private static const _TRANS_RESTRICTION:String = "Exclusive weapon";
        CONFIG::LOCALE_TCN
        private static const _TRANS_RESTRICTION:String = "專用武器";
        CONFIG::LOCALE_SCN
        private static const _TRANS_RESTRICTION:String = "专用武器";
        CONFIG::LOCALE_KR
        private static const _TRANS_RESTRICTION:String = "専用武器";
        CONFIG::LOCALE_FR
        private static const _TRANS_RESTRICTION:String = "Arme spéciale";
        CONFIG::LOCALE_ID
        private static const _TRANS_RESTRICTION:String = "専用武器";
        CONFIG::LOCALE_TH
        private static const _TRANS_RESTRICTION:String = "専用武器";

        CONFIG::LOCALE_JP
        private static const _TRANS_CHANGE_TITLE:String   = "ParameterUp!!";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHANGE_EXPL:String    = "__TXT__になりました！";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHANGE_PARAM:String   = "\n全合成パラメータが__PRM__上昇しました！";
        CONFIG::LOCALE_JP
        private static const _TRANS_CHANGE_PRM_MAX:String = "\n合成パラメータの最大値が__PRM__上昇しました！";
        CONFIG::LOCALE_JP
        private static const _TRANS_LVUP_TITLE:String   = "LevelUp!!";
        CONFIG::LOCALE_JP
        private static const _TRANS_LVUP_LEVEL:String   = "武器Lvが__LV__上がりました！";
        CONFIG::LOCALE_JP
        private static const _TRANS_LVUP_PARAM:String   = "\n合成パラメータの最大値が__PRM__上昇しました！";
        CONFIG::LOCALE_JP
        private static const _TRANS_LVUP_PSV_NUM:String = "\n追加パッシブスキル数が__NUM__上昇しました！";

        CONFIG::LOCALE_EN
        private static const _TRANS_CHANGE_TITLE:String   = "Parameter Up!!";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHANGE_EXPL:String    = "Modified into __TXT__";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHANGE_PARAM:String   = "\nAll crafting attributes increased by __PRM__!";
        CONFIG::LOCALE_EN
        private static const _TRANS_CHANGE_PRM_MAX:String = "\nThe max crafting attributes increased by __PRM__!";
        CONFIG::LOCALE_EN
        private static const _TRANS_LVUP_TITLE:String   = "Level Up!!";
        CONFIG::LOCALE_EN
        private static const _TRANS_LVUP_LEVEL:String   = "Weapon Lv increased by __LV__!";
        CONFIG::LOCALE_EN
        private static const _TRANS_LVUP_PARAM:String   = "\nThe max crafting attributes increased by __PRM__!";
        CONFIG::LOCALE_EN
        private static const _TRANS_LVUP_PSV_NUM:String = "\nPassive abilities increased by __NUM__!";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CHANGE_TITLE:String   = "Parameter Up!!";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHANGE_EXPL:String    = "變成__TXT__了！";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHANGE_PARAM:String   = "\n全合成參數提昇了__PRM__！";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CHANGE_PRM_MAX:String = "\n合成參數的最大值提昇了__PRM__！";
        CONFIG::LOCALE_TCN
        private static const _TRANS_LVUP_TITLE:String   = "Level Up!!";
        CONFIG::LOCALE_TCN
        private static const _TRANS_LVUP_LEVEL:String   = "武器Lv提昇了__LV__！";
        CONFIG::LOCALE_TCN
        private static const _TRANS_LVUP_PARAM:String   = "\n合成參數的最大值提昇了__PRM__！";
        CONFIG::LOCALE_TCN
        private static const _TRANS_LVUP_PSV_NUM:String = "\n追加被動技能數提昇了__NUM__！";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CHANGE_TITLE:String   = "Parameter Up!!";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHANGE_EXPL:String    = "变成__TXT__了！";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHANGE_PARAM:String   = "\n全合成参数提昇了__PRM__！";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CHANGE_PRM_MAX:String = "\n合成参数的最大值提昇了__PRM__！";
        CONFIG::LOCALE_SCN
        private static const _TRANS_LVUP_TITLE:String   = "Level Up!!";
        CONFIG::LOCALE_SCN
        private static const _TRANS_LVUP_LEVEL:String   = "武器Lv提昇了__LV__！";
        CONFIG::LOCALE_SCN
        private static const _TRANS_LVUP_PARAM:String   = "\n合成参数的最大值提昇了__PRM__！";
        CONFIG::LOCALE_SCN
        private static const _TRANS_LVUP_PSV_NUM:String = "\n追加被动技能数提昇了__NUM__！";

        CONFIG::LOCALE_KR
        private static const _TRANS_CHANGE_TITLE:String   = "ParameterUp!!";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHANGE_EXPL:String    = "__TXT__になりました！";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHANGE_PARAM:String   = "\n全合成パラメータが__PRM__上昇しました！";
        CONFIG::LOCALE_KR
        private static const _TRANS_CHANGE_PRM_MAX:String = "\n合成パラメータの最大値が__PRM__上昇しました！";
        CONFIG::LOCALE_KR
        private static const _TRANS_LVUP_TITLE:String   = "LevelUp!!";
        CONFIG::LOCALE_KR
        private static const _TRANS_LVUP_LEVEL:String   = "武器Lvが__LV__上がりました！";
        CONFIG::LOCALE_KR
        private static const _TRANS_LVUP_PARAM:String   = "\n合成パラメータの最大値が__PRM__上昇しました！";
        CONFIG::LOCALE_KR
        private static const _TRANS_LVUP_PSV_NUM:String = "\n追加パッシブスキル数が__NUM__上昇しました！";

        CONFIG::LOCALE_FR
        private static const _TRANS_CHANGE_TITLE:String   = "Paramètres up!!";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHANGE_EXPL:String    = "Est devenu __TXT__ !";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHANGE_PARAM:String   = "\nVos paramètres combinés atteignent __PRM__ !";
        CONFIG::LOCALE_FR
        private static const _TRANS_CHANGE_PRM_MAX:String = "\nLa valeur total de vos paramètres combinés atteignent __PRM__ !";
        CONFIG::LOCALE_FR
        private static const _TRANS_LVUP_TITLE:String   = "Level up !!";
        CONFIG::LOCALE_FR
        private static const _TRANS_LVUP_LEVEL:String   = "Votre ArmeLv est passé à __LV__ !";
        CONFIG::LOCALE_FR
        private static const _TRANS_LVUP_PARAM:String   = "\nLa valeur total de vos paramètres combinés atteignent __PRM__ !";
        CONFIG::LOCALE_FR
        private static const _TRANS_LVUP_PSV_NUM:String = "\nVotre nombre de passive skills supplémentaires est monté à __NUM__ !";

        CONFIG::LOCALE_ID
        private static const _TRANS_CHANGE_TITLE:String   = "ParameterUp!!";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHANGE_EXPL:String    = "__TXT__になりました！";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHANGE_PARAM:String   = "\n全合成パラメータが__PRM__上昇しました！";
        CONFIG::LOCALE_ID
        private static const _TRANS_CHANGE_PRM_MAX:String = "\n合成パラメータの最大値が__PRM__上昇しました！";
        CONFIG::LOCALE_ID
        private static const _TRANS_LVUP_TITLE:String   = "LevelUp!!";
        CONFIG::LOCALE_ID
        private static const _TRANS_LVUP_LEVEL:String   = "武器Lvが__LV__上がりました！";
        CONFIG::LOCALE_ID
        private static const _TRANS_LVUP_PARAM:String   = "\n合成パラメータの最大値が__PRM__上昇しました！";
        CONFIG::LOCALE_ID
        private static const _TRANS_LVUP_PSV_NUM:String = "\n追加パッシブスキル数が__NUM__上昇しました！";

        CONFIG::LOCALE_TH
        private static const _TRANS_CHANGE_TITLE:String   = "ParameterUp!!";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHANGE_EXPL:String    = "__TXT__になりました！";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHANGE_PARAM:String   = "\n全合成パラメータが__PRM__上昇しました！";
        CONFIG::LOCALE_TH
        private static const _TRANS_CHANGE_PRM_MAX:String = "\n合成パラメータの最大値が__PRM__上昇しました！";
        CONFIG::LOCALE_TH
        private static const _TRANS_LVUP_TITLE:String   = "LevelUp!!";
        CONFIG::LOCALE_TH
        private static const _TRANS_LVUP_LEVEL:String   = "武器Lvが__LV__上がりました！";
        CONFIG::LOCALE_TH
        private static const _TRANS_LVUP_PARAM:String   = "\n合成パラメータの最大値が__PRM__上昇しました！";
        CONFIG::LOCALE_TH
        private static const _TRANS_LVUP_PSV_NUM:String = "\n追加パッシブスキル数が__NUM__上昇しました！";

        private var _combine:Combine = Combine.instance;

        private var _container:UIComponent = new UIComponent();
        private var _expContainer:UIComponent = new UIComponent();

        private var _resultImage:CombineResultImage = new CombineResultImage();

        private var _name:Label = new Label();
        private var _restriction:Label = new Label();

        // 結果画像
        private var _weaponImage:WeaponCardImage;

        // ベースパラメータ
        private var _baseMax:Label = new Label();
        private var _baseMaxMark:CombineResultMarkImage = new CombineResultMarkImage();
        private var _newBaseSap:Label = new Label();
        private var _newBaseSdp:Label = new Label();
        private var _newBaseAap:Label = new Label();
        private var _newBaseAdp:Label = new Label();
        private var _newBaseParams:Array = [_newBaseSap,_newBaseSdp,_newBaseAap,_newBaseAdp];
        private var _diffBaseSap:Label = new Label();
        private var _diffBaseSdp:Label = new Label();
        private var _diffBaseAap:Label = new Label();
        private var _diffBaseAdp:Label = new Label();
        private var _diffBaseParams:Array = [_diffBaseSap,_diffBaseSdp,_diffBaseAap,_diffBaseAdp];
        private var _diffBaseParamMarks:Array = [new CombineResultMarkImage(),new CombineResultMarkImage(),new CombineResultMarkImage(),new CombineResultMarkImage()];
        // モンスパラメータ
        private var _addMax:Label = new Label();
        private var _newAddSap:Label = new Label();
        private var _newAddSdp:Label = new Label();
        private var _newAddAap:Label = new Label();
        private var _newAddAdp:Label = new Label();
        private var _newAddParams:Array = [_newAddSap,_newAddSdp,_newAddAap,_newAddAdp];
        private var _diffAddSap:Label = new Label();
        private var _diffAddSdp:Label = new Label();
        private var _diffAddAap:Label = new Label();
        private var _diffAddAdp:Label = new Label();
        private var _diffAddParams:Array = [_diffAddSap,_diffAddSdp,_diffAddAap,_diffAddAdp];
        private var _diffAddParamMarks:Array = [new CombineResultMarkImage(),new CombineResultMarkImage(),new CombineResultMarkImage(),new CombineResultMarkImage()];
        private var _maxAddSap:Label = new Label();
        private var _maxAddSdp:Label = new Label();
        private var _maxAddAap:Label = new Label();
        private var _maxAddAdp:Label = new Label();
        private var _maxAddParams:Array = [_maxAddSap,_maxAddSdp,_maxAddAap,_maxAddAdp];
        private var _maxDiffAddSap:Label = new Label();
        private var _maxDiffAddSdp:Label = new Label();
        private var _maxDiffAddAap:Label = new Label();
        private var _maxDiffAddAdp:Label = new Label();
        private var _maxDiffAddParams:Array = [_maxDiffAddSap,_maxDiffAddSdp,_maxDiffAddAap,_maxDiffAddAdp];
        private var _maxDiffAddParamMarks:Array = [new CombineResultMarkImage(),new CombineResultMarkImage(),new CombineResultMarkImage(),new CombineResultMarkImage()];

        // 合計パラ
        private var _totalSap:Label = new Label();
        private var _totalSdp:Label = new Label();
        private var _totalAap:Label = new Label();
        private var _totalAdp:Label = new Label();
        private var _totalParams:Array = [_totalSap,_totalSdp,_totalAap,_totalAdp];

        // パッシブ
        private var _passiveName:Array = [new Label(),new Label(),new Label()];
        private var _passiveCnt:Array = [new Label(),new Label(),new Label()];
        private var _passiveCntUp:Array = [new Label(),new Label(),new Label()];
        private var _passiveCntUpMarks:Array = [new CombineResultMarkImage(),new CombineResultMarkImage(),new CombineResultMarkImage()];
        private var _passiveCaption:Array = [new Text(),new Text(),new Text()];

        // レベル＆EXP
        private var _resultExp:CombineResultExp = new CombineResultExp();

        // CardClip
        private var _prevClip:WeaponCardClip;
        private var _newClip:WeaponCardClip;

        private const _NAME_X:int    = 20;
        private const _NAME_Y:int    = 60;
        private const _NAME_W:int    = 350;
        private const _NAME_H:int    = 70;
        private const _NAME_SIZE:int = 24;

        private const _REST_X:int    = 350;
        private const _REST_Y:int    = 75;
        private const _REST_W:int    = 200;
        private const _REST_H:int    = 40;
        private const _REST_SIZE:int = 12;

        private const _MAX_BASE_X:int = 75;
        private const _MAX_BASE_Y:int = 288;

        private const _BASE_NEW_X:int  = 42;
        private const _BASE_NEW_Y:int  = 174;
        private const _BASE_DIFF_X:int = 75;
        private const _BASE_DIFF_Y:int = _BASE_NEW_Y+8;
        private const _ADD_NEW_X:int   = _BASE_DIFF_X+50;
        private const _ADD_NEW_Y:int   = _BASE_DIFF_Y;
        private const _ADD_DIFF_X:int  = _ADD_NEW_X+30;
        private const _ADD_DIFF_Y:int  = _ADD_NEW_Y;
        private const _ADD_MAX_X:int  = _ADD_DIFF_X+40;
        private const _ADD_MAX_Y:int  = _ADD_NEW_Y;
        private const _ADD_MAX_DIFF_X:int  = _ADD_MAX_X+30;
        private const _ADD_MAX_DIFF_Y:int  = _ADD_NEW_Y;
        private const _TOTAL_X:int   = _BASE_NEW_X+260;
        private const _TOTAL_Y:int   = _BASE_NEW_Y;

        private const _PARA_BIG_SIZE:int  = 32;
        private const _PARA_MIN_SIZE:int  = 20;

        private const _BASE_Y_LIST:Array = [174,230,202,258];
        private const _BASE_DIFF_Y_LIST:Array = [182,238,210,266];
        private const _ADD_Y_LIST:Array = [182,238,210,266];
        private const _ADD_DIFF_Y_LIST:Array = [182,238,210,266];
        private const _ADD_MAX_Y_LIST:Array = [182,238,210,266];
        private const _ADD_MAX_DIFF_Y_LIST:Array = [182,238,210,266];
        private const _TOTAL_Y_LIST:Array = [174,230,202,258];

        private const _PARAM_Y:int        = 150;
        private const _PARAM_W:int        = 100;
        private const _PARAM_H:int        = 60;
        private const _PARAM_SIZE:int     = 24;
        private const _PARAM_INTERVAL:int = 28;

        private const _PSV_NAME_X:int    = 25;
        private const _PSV_NAME_W:int    = 390;
        private const _PSV_NAME_H:int    = 60;
        private const _PSV_NAME_SIZE:int = 16;

        private const _PSV_CNT_X:int     = 344;
        private const _PSV_CNT_UP_X:int  = 384;

        private const _PSV_Y:int    = 367;
        private const _PSV_INTERVAL:int = 72;

        private const _PSV_CAPTION_X:int    = 16;
        private const _PSV_CAPTION_Y:int    = _PSV_Y + 29;
        private const _PSV_CAPTION_W:int    = 530;
        private const _PSV_CAPTION_H:int    = 60;
        private const _PSV_CAPTION_SIZE:int = 11;

        private const _MARK_X_INTERVAL:int = 65;
        private const _MARK_Y_INTERVAL:int = 5;

        private const _IMAGE_X:int = 481;
        private const _IMAGE_Y:int = 225;

        private const _CLIP_X:int = 580;
        private const _PREV_CLIP_Y:int = 38;
        private const _NEW_CLIP_Y:int = 304;

        /**
         * コンストラクタ
         *
         */
        public function CombineResult()
        {
            super();
        }

        public override function init():void
        {
            _container.addChild(_resultImage);
            allLabelInit();
            Unlight.INS.topContainer.parent.addChild(_container);
            Unlight.INS.topContainer.parent.addChild(_expContainer);
        }

        private function allLabelInit():void
        {
            var _filter:Array = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            var _revFilter:Array = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];


            labelInit(_name,_NAME_X,_NAME_Y,_NAME_W,_NAME_H,"left",_NAME_SIZE,"ResultNameLabel",_filter);

            labelInit(_restriction,_REST_X,_REST_Y,_REST_W,_REST_H,"right",_REST_SIZE,"ResultNameLabel",_revFilter,"#FFFFFF");

            labelInit(_baseMax,_MAX_BASE_X,_MAX_BASE_Y,_PARAM_W,_PARAM_H,"right",_PARA_MIN_SIZE,"ResultLabel");
            markInit(_baseMaxMark,_MAX_BASE_X+_MARK_X_INTERVAL,_MAX_BASE_Y+_MARK_Y_INTERVAL);

            // labelInit(_addMax,_MAX_ADD_X,_MAX_ADD_Y,_PARAM_W,_PARAM_H,"right",_PARAM_SIZE,"ResultLabel");

            var i:int;
            for ( i = 0; i < WeaponCard.PARAM_NUM; i++) {
                labelInit(_newBaseParams[i],_BASE_NEW_X,_BASE_Y_LIST[i],_PARAM_W,_PARAM_H,"right",_PARA_BIG_SIZE,"ResultLabel");

                labelInit(_diffBaseParams[i],_BASE_DIFF_X,_BASE_DIFF_Y_LIST[i],_PARAM_W,_PARAM_H,"right",_PARA_MIN_SIZE,"ResultLabel");
                markInit(_diffBaseParamMarks[i],_BASE_DIFF_X+_MARK_X_INTERVAL,_BASE_DIFF_Y_LIST[i]+_MARK_Y_INTERVAL);

                labelInit(_newAddParams[i],_ADD_NEW_X,_ADD_Y_LIST[i],_PARAM_W,_PARAM_H,"right",_PARA_MIN_SIZE,"ResultLabel");
                labelInit(_diffAddParams[i],_ADD_DIFF_X,_ADD_DIFF_Y_LIST[i],_PARAM_W,_PARAM_H,"right",_PARA_MIN_SIZE,"ResultLabel");
                markInit(_diffAddParamMarks[i],_ADD_DIFF_X+_MARK_X_INTERVAL,_ADD_DIFF_Y_LIST[i]+_MARK_Y_INTERVAL);

                labelInit(_maxAddParams[i],_ADD_MAX_X,_ADD_MAX_Y_LIST[i],_PARAM_W,_PARAM_H,"right",_PARA_MIN_SIZE,"ResultLabel");
                labelInit(_maxDiffAddParams[i],_ADD_MAX_DIFF_X,_ADD_MAX_DIFF_Y_LIST[i],_PARAM_W,_PARAM_H,"right",_PARA_MIN_SIZE,"ResultLabel");
                markInit(_maxDiffAddParamMarks[i],_ADD_MAX_DIFF_X+_MARK_X_INTERVAL,_ADD_MAX_DIFF_Y_LIST[i]+_MARK_Y_INTERVAL);

                labelInit(_totalParams[i],_TOTAL_X,_TOTAL_Y_LIST[i],_PARAM_W,_PARAM_H,"right",_PARA_BIG_SIZE,"ResultLabel");
            }

            for (i = 0; i < _passiveName.length; i++) {
                labelInit(_passiveName[i],_PSV_NAME_X,_PSV_Y+i*_PSV_INTERVAL,_PSV_NAME_W,_PSV_NAME_H,"left",_PSV_NAME_SIZE,"ResultNameLabel",_revFilter,"#FFFFFF");

                labelInit(_passiveCnt[i],_PSV_CNT_X,_PSV_Y+i*_PSV_INTERVAL,_PARAM_W,_PARAM_H,"right",_PARAM_SIZE,"ResultLabel");

                labelInit(_passiveCntUp[i],_PSV_CNT_UP_X,_PSV_Y+i*_PSV_INTERVAL,_PARAM_W,_PARAM_H,"right",_PARAM_SIZE,"ResultLabel");
                markInit(_passiveCntUpMarks[i],_PSV_CNT_UP_X+_MARK_X_INTERVAL,_PSV_Y+i*_PSV_INTERVAL+_MARK_Y_INTERVAL);

                textInit(_passiveCaption[i],_PSV_CAPTION_X,_PSV_CAPTION_Y+i*_PSV_INTERVAL,_PSV_CAPTION_W,_PSV_CAPTION_H,"left",_PSV_CAPTION_SIZE,"CharaCardFeatInfoLabel");
            }
        }

        private function labelInit(l:Label,x:int,y:int,w:int,h:int,align:String,size:int,style:String,filters:Array=null,color:String=""):void
        {
            l.x = x;
            l.y = y;
            l.width = w;
            l.height = h;
            if (style != "") {
                l.styleName = style;
            }
            if (filters) {
                l.filters = filters;
            }
            l.setStyle("textAlign",align);
            l.setStyle("fontSize",size);
            if (color != "") {
                l.setStyle("color",color);
            }
            l.mouseEnabled = false;
            l.mouseChildren = false;
            _container.addChild(l);
        }
        private function textInit(t:Text,x:int,y:int,w:int,h:int,align:String,size:int,style:String,filters:Array=null):void
        {
            t.x = x;
            t.y = y;
            t.width = w;
            t.height = h;
            if (style != "") {
                t.styleName = style;
            }
            if (filters) {
                t.filters = filters;
            }
            t.setStyle("textAlign",align);
            t.setStyle("fontSize",size);
            t.mouseEnabled = false;
            t.mouseChildren = false;
            _container.addChild(t);
        }
        private function markInit(mark:CombineResultMarkImage,x:int,y:int):void
        {
            mark.x = x;
            mark.y = y;
            mark.visible = false;
            mark.mouseEnabled = false;
            mark.mouseChildren = false;
            _container.addChild(mark);
        }

        // 後始末処理
        public override function final():void
        {
            RemoveChild.all(_container);
            RemoveChild.apply(_container);
            RemoveChild.all(_expContainer);
            RemoveChild.apply(_expContainer);
        }

        // 表示設定
        public function setLabel():void
        {
            var wc:WeaponCard = WeaponCard(WeaponCardInventory.getInventory(Combine.instance.resultCardInvId).card);

            _name.text = wc.name;

            if (Const.CHARA_GROUP_NAME.hasOwnProperty(wc.restriction[0]))
            {
                _restriction.text = Const.CHARA_GROUP_NAME[wc.restriction[0]] + _TRANS_RESTRICTION;
            }
            else if (wc.restriction[0].split("|")[0] != "")
            {
                var names:Array = [];
                var name_tmp:String = "";
                wc.restriction.forEach(function(item:*, index:int, ary:Array):void{
                        name_tmp = Const.CHARACTOR_NAME[item].replace(/\s*\(.+\)$/, "");
                        if (names.indexOf(name_tmp) < 0)
                        {
                            names.push(name_tmp);
                        }
                    });
                _restriction.text = names.join() + _TRANS_RESTRICTION;
            } else {
                _restriction.text = "";
            }

            weaponImageInit(wc.image);

            _baseMax.text = wc.baseMax.toString();
            markCheck(_baseMaxMark,_combine.prevBaseMax,wc.baseMax);

            _addMax.text = wc.addMax.toString();

            var i:int;
            var diff:int;
            for ( i = 0; i < WeaponCard.PARAM_NUM; i++) {
                _newBaseParams[i].text = wc.getBaseParamIdx(i).toString();
                diff = Math.abs(wc.getBaseParamIdx(i) - _combine.getPrevBaseParamIdx(i));
                _diffBaseParams[i].text = (diff > 0) ? diff.toString() : "";
                markCheck(_diffBaseParamMarks[i],_combine.getPrevBaseParamIdx(i),wc.getBaseParamIdx(i));

                _newAddParams[i].text = wc.getAddParamIdx(i);
                diff = Math.abs(wc.getAddParamIdx(i) - _combine.getPrevAddParamIdx(i));
                _diffAddParams[i].text = (diff > 0) ? diff.toString() : "";
                markCheck(_diffAddParamMarks[i],_combine.getPrevAddParamIdx(i),wc.getAddParamIdx(i));

                _maxAddParams[i].text = wc.addMaxParam;
                diff = Math.abs(wc.addMaxParam - _combine.prevAddMax);
                _maxDiffAddParams[i].text = (diff > 0) ? diff.toString() : "";
                markCheck(_maxDiffAddParamMarks[i],_combine.prevAddMax,wc.addMaxParam);

                _totalParams[i].text = wc.getBaseParamIdx(i) + wc.getAddParamIdx(i);
            }

            _resultExp.setLabel();

            var weaponPassiveNum:int = wc.weaponPassiveNum;
            var passiveList:Array = [];
            var passiveNum:int = wc.passiveNum;
            var prevPassiveSkills:Vector.<Object> = _combine.prevPassiveSkills;

            // スロット枠を先に設定
            for (i = 0; i < CombineResultImage.SKILL_SLOT_NUM; i++) {
                if (i < weaponPassiveNum) {
                    _resultImage.uniqSkillSlotShow();
                } else if (i < wc.passiveNumMax + weaponPassiveNum) {
                    _resultImage.skillSlotShow(i);
                }
            }

            for (i = 0; i < wc.passiveId.length; i++) {
                var prevUseCnt:int = 0;
                for (var j:int =0; j < prevPassiveSkills.length; j++) {
                    if (wc.passiveId[i] == prevPassiveSkills[j]["id"]) {
                        prevUseCnt = prevPassiveSkills[j]["cnt"];
                        //break;
                    }
                }
                var passive:PassiveSkill = PassiveSkill.ID(wc.passiveId[i]);
                var newUseCnt:int = 0;
                if (i < weaponPassiveNum) {
                    newUseCnt = 0;
                } else {
                    var psvIdx:int = i - weaponPassiveNum;
                    newUseCnt = (wc.getUseCnt(psvIdx)>0) ? wc.getUseCnt(psvIdx) : 0;
                }
                passiveList.push({"name":passive.name,"caption":passive.caption,"newCnt":newUseCnt,"prevCnt":prevUseCnt});
            }

            for (i = 0; i < _passiveName.length; i++) {
                if (passiveList[i]) {
                    _passiveName[i].text = passiveList[i]["name"];

                    if (i < weaponPassiveNum) {
                        _passiveCnt[i].text = Const.OVER_HP_STR;
                        _passiveCntUp[i].text = "";
                    } else {
                        if (passiveList[i]["newCnt"] > 0) {
                            _passiveCnt[i].text = passiveList[i]["newCnt"];
                            var cntUp:int = Math.abs(passiveList[i]["newCnt"] - passiveList[i]["prevCnt"]);
                            _passiveCntUp[i].text = (cntUp > 0) ? cntUp.toString() : "";
                            markCheck(_passiveCntUpMarks[i],passiveList[i]["prevCnt"],passiveList[i]["newCnt"],true);
                        } else {
                            _passiveCnt[i].text = "";
                            _passiveCntUp[i].text = "";
                        }
                    }

                    _passiveCaption[i].text = passiveList[i]["caption"].slice(getCaptionStartIndex(passiveList[i]["caption"])).replace(/\|/, "\n");
                } else {
                    _passiveName[i].text = "";
                    _passiveCnt[i].text = "";
                    _passiveCntUp[i].text = "";
                    _passiveCaption[i].text = "";
                }
            }

            _prevClip = new WeaponCardClip(_combine.prevWeaponCard);
            _prevClip.x = _CLIP_X;
            _prevClip.y = _PREV_CLIP_Y;
            _newClip = new WeaponCardClip(wc);
            _newClip.x = _CLIP_X;
            _newClip.y = _NEW_CLIP_Y;
        }
        // キャプション本文の開始インデックスを返す
        private function getCaptionStartIndex(s:String):int
        {
            if (s.charAt(0) != "[") return 0;

            var cnt:int = 0;
            for (var i:int = 0; i < s.length; i++) {
                if (s.charAt(i) == "[")
                {
                    cnt += 1;
                }
                else if (s.charAt(i) == "]")
                {
                    cnt -= 1;
                    if (cnt == 0 && i < s.length - 1) return i + 1;
                }
            }

            return 0;
        }
        private function markCheck(mark:CombineResultMarkImage,prevParam:int,newParam:int,isPassive:Boolean=false):void
        {
            var diff:int = newParam - prevParam;
            mark.visible = true;
            if (isPassive) {
                if (diff > 0) {
                    mark.type = CombineResultMarkImage.MARK_TYPE_PLUS;
                } else {
                    mark.visible = false;
                }
            } else {
                if (diff > 0) {
                    mark.type = CombineResultMarkImage.MARK_TYPE_UP;
                } else if (diff < 0) {
                    mark.type = CombineResultMarkImage.MARK_TYPE_DOWN;
                } else {
                    mark.visible = false;
                }
            }
        }
        private function weaponImageInit(image:String):void
        {
            log.writeLog(log.LV_DEBUG, this, "imageinitialize", image);
            if (_weaponImage) {
                _weaponImage.getHideThread().start();
                _weaponImage = null;
            }
            _weaponImage = new WeaponCardImage(image);
            _weaponImage.x = _IMAGE_X;
            _weaponImage.y = _IMAGE_Y;
            _weaponImage.getShowThread(_container).start();
        }

        // リセット
        private function resetAll():void
        {
            log.writeLog (log.LV_DEBUG,this,"resetAll");
            _name.text = "";

            _restriction.text = "";

            if (_weaponImage) {
                _weaponImage.getHideThread().start();
                _weaponImage = null;
            }

            _baseMax.text = "";
            _baseMaxMark.visible = false;

            _addMax.text = "";

            var i:int;
            for ( i = 0; i < WeaponCard.PARAM_NUM; i++) {
                _newBaseParams[i].text = "";

                _diffBaseParams[i].text = "";
                _diffBaseParamMarks[i].visible = false;

                _newAddParams[i].text = "";

                _diffAddParams[i].text = "";
                _diffAddParamMarks[i].visible = false;

                _maxAddParams[i].text = "";
                _maxDiffAddParams[i].text = "";
                _maxDiffAddParamMarks[i].visible = false;

                _totalParams[i].text = "";
            }

            for (i = 0; i < _passiveName.length; i++) {
                _passiveName[i].text = "";
                _passiveCnt[i].text = "";
                _passiveCntUp[i].text = "";
                _passiveCntUpMarks[i].visible = false;
                _passiveCaption[i].text = "";
            }

            _resultImage.skillSlotAllHide();

            if (_prevClip) {
                _prevClip.getHideThread().start();
                _prevClip = null;
            }
            if (_newClip) {
                _newClip.getHideThread().start();
                _newClip = null;
            }
        }

        private function levelUpAndChangePrm(wc:WeaponCard):void
        {
            log.writeLog(log.LV_FATAL, this, "levelUpAndChangePrm");
            var title:String = _TRANS_LVUP_TITLE + "&" + _TRANS_CHANGE_TITLE;
            var text:String = _TRANS_LVUP_LEVEL.replace("__LV__",(wc.level - _combine.prevLevel).toString());
            text += "\n" + _TRANS_CHANGE_EXPL.replace("__TXT__",_restriction.text);
            text += _TRANS_LVUP_PARAM.replace("__PRM__",((wc.level - _combine.prevLevel)+WeaponCard.RESTRICTION_SET_ADD_PARAM).toString());
            text += _TRANS_CHANGE_PARAM.replace("__PRM__",WeaponCard.RESTRICTION_SET_ADD_PARAM.toString());
            // パッシブセット数が変化
            if (wc.passiveNumMax > _combine.prevPassiveNumMax) {
                text += _TRANS_LVUP_PSV_NUM.replace("__NUM__",(wc.passiveNumMax - _combine.prevPassiveNumMax).toString());
            }
            Alerter.showWithSize(text,title,0x4,null,clickHandler,150,500);
        }
        private function levelUp(wc:WeaponCard):void
        {
            log.writeLog(log.LV_FATAL, this, "levelUp");
            var title:String = _TRANS_LVUP_TITLE;
            var text:String = _TRANS_LVUP_LEVEL.replace("__LV__",(wc.level - _combine.prevLevel).toString());
            text += _TRANS_LVUP_PARAM.replace("__PRM__",(wc.level - _combine.prevLevel).toString());
            // パッシブセット数が変化
            if (wc.passiveNumMax > _combine.prevPassiveNumMax) {
                text += _TRANS_LVUP_PSV_NUM.replace("__NUM__",(wc.passiveNumMax - _combine.prevPassiveNumMax).toString());
            }
            Alerter.showWithSize(text,title,0x4,null,clickHandler,150,500);
        }
        private function changeParam(wc:WeaponCard):void
        {
            log.writeLog(log.LV_FATAL, this, "changeParam");
            var title:String = _TRANS_CHANGE_TITLE;
            var text:String = _TRANS_CHANGE_EXPL.replace("__TXT__",_restriction.text);
            text += _TRANS_CHANGE_PARAM.replace("__PRM__",WeaponCard.RESTRICTION_SET_ADD_PARAM.toString());
            text += _TRANS_CHANGE_PRM_MAX.replace("__PRM__",WeaponCard.RESTRICTION_SET_ADD_PARAM.toString());
            Alerter.showWithSize(text,title,0x4,null,clickHandler,150,500);
        }
        private function clickHandler(e:Event):void
        {
            _resultExp.hideLvUpImage();
            setMouse(true);
        }

        private function getLevelUpThread():Thread
        {
            var wc:WeaponCard = WeaponCard(WeaponCardInventory.getInventory(Combine.instance.resultCardInvId).card);
            var sExec:SerialExecutor = new SerialExecutor();
            if ((!_combine.prevIsCharaSpecial && wc.isCharaSpecial) && wc.level > _combine.prevLevel) {
                sExec.addThread(new ClousureThread(levelUpAndChangePrm,[wc]));
            } else if (wc.level > _combine.prevLevel) {
                sExec.addThread(new ClousureThread(levelUp,[wc]));
            } else if (!_combine.prevIsCharaSpecial && wc.isCharaSpecial) {
                sExec.addThread(new ClousureThread(changeParam,[wc]));
            } else {
                sExec.addThread(new ClousureThread(setMouse,[true]));
            }
            return sExec;
        }

        // 表示処理
        public function show():Thread
        {
            setLabel();
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_prevClip.getShowThread(_container));
            pExec.addThread(_newClip.getShowThread(_container));
            sExec.addThread(pExec);
            sExec.addThread(new BeTweenAS3Thread(_container, {alpha:1.0}, {alpha:0.0}, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE));
            sExec.addThread(_resultExp.getShowThread(_expContainer));
            sExec.addThread(_resultExp.getMoveThread());
            sExec.addThread(getLevelUpThread());
            return sExec;
        }

        // 非表示処理
        public function hide():void
        {
            _resultExp.getHideThread().start();
            mouseEnabled = false;
            resetAll();
            _container.alpha = 0.0;
            _container.visible = false;
        }

        // okButton
        public function get okBtn():SimpleButton
        {
            return _resultImage.ok;
        }

        public override function set alpha(a:Number):void
        {
            _container.alpha = a;
        }

        public override function set visible(f:Boolean):void
        {
            _container.visible = f;
        }

        private function setMouse(f:Boolean):void
        {
            mouseEnabled = f;
        }

        public override function set mouseEnabled(f:Boolean):void
        {
            _container.mouseEnabled = f;
            _container.mouseChildren = f;
        }

    }
}


