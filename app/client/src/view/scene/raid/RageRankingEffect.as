package view.scene.raid
{

    import flash.display.*;
    import flash.filters.*;
    import flash.events.*;
    import flash.utils.*;

    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;

    import model.Profound;

    import view.WaitThread;
    import view.scene.BaseScene;
    import view.image.game.PassiveSkillBarImage;
    import view.image.quest.QuestCharaImage;

    /**
     * レイジパッシブのランキングエフェクト
     *
     */
    public class RageRankingEffect extends BaseScene
    {

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "Rage Ranking";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "Rage Ranking";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "Rage Ranking";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "Rage Ranking";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "Rage Ranking";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Rage Ranking";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "Rage Ranking";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG	:String = "Rage Ranking";

        private var _rankingCharaImageSet:Array = [];
        private var _currentRanking:Array = [];

        private var _charaImageCacheDic:Dictionary = new Dictionary();

        private const _X:int = 775;
        private const _Y:int = 175;
        private const _H:int = 34;
        private const _X2:int = 732;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                [_TRANS_MSG],     // 0
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _TIME_HELP:int   = 0;

        public function RageRankingEffect():void
        {
            initilizeToolTipOwners();
        }

        public override function init():void
        {
        }

        public override function final():void
        {
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  //
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

        public function updateRanking(rank:Array):void
        {
            _rankingCharaImageSet = []
            rank.forEach(function(item:int, index:int, array:Array):void
                         {
                             if (_charaImageCacheDic[item] != null)
                             {
                                 _rankingCharaImageSet.push(_charaImageCacheDic[item])
                             }else{
                                 _charaImageCacheDic[item] = new QuestCharaImage(item);
                                 _rankingCharaImageSet.push(_charaImageCacheDic[item])
                             }
                             _rankingCharaImageSet[index].x = _X;
                             _rankingCharaImageSet[index].y = _Y+_H*index;
                             addChild(_rankingCharaImageSet[index]);
                         });
        }

        public function showRanking():void
        {
            var iTweens:Array = [];
            _rankingCharaImageSet.forEach(function(item:QuestCharaImage, index:int, array:Array):void
                                          {
                                              iTweens.push(BetweenAS3.delay(
                                                               BetweenAS3.serial
                                                               (
                                                                   BetweenAS3.tween(item,
                                                                                    {x:_X2},
                                                                                    null,
                                                                                    0.2,
                                                                                    BeTweenAS3Thread.EASE_IN_QUAD
                                                                       ),
                                                                   BetweenAS3.tween(item,
                                                                                    {x:_X2},
                                                                                    null,
                                                                                    2.0,
                                                                                    BeTweenAS3Thread.EASE_IN_QUAD
                                                                       ),
                                                                   BetweenAS3.tween(item,
                                                                                    {x:_X},
                                                                                    null,
                                                                                    0.2,
                                                                                    BeTweenAS3Thread.EASE_IN_QUAD
                                                                       ),
                                                                   BetweenAS3.removeFromParent(item)
                                                                   ),
                                                               0.001+(0.2*index)));
                                          });
            BetweenAS3.parallelTweens(iTweens).play();

        }
    }

}