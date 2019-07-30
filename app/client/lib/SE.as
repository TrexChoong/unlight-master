/**
  * Unlight
  * Copyright(c)2019 CPA This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */

package
{

    import org.libspark.thread.Thread;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;

    import view.*;

    import sound.se.*;
    import sound.BaseSound;

    /**
     * SEの音管理クラスまとめて静的に管理する
     *
     */
    public class SE
    {
        // ロビークリックSE
        static private var __lobbyClickSE:BaseSound      = new Click2SE();
        // デッキセットSE
        static private var __deckSetSE:BaseSound         = new DeckSetSE();
        // デッキカード選択音
        static private var __deckCardClickSE:BaseSound   = new DeckCardClickSE();
        // デッキタブクリックSE
        static private var __deckTabClickSE:BaseSound    = new DeckTabClickSE();
        // キャラカード回転音
        static private var __charaCardRotateSE:BaseSound = new CharaCardRotateSE();
        // キャラカード解除音
        static private var __chainSE:BaseSound           = new ChainSE();
        // デッキのカードセット
        static private var __cardSetSE:BaseSound          = new CardSetSE();
        static private var __cardSetASE:BaseSound         = new CardSetASE();
        static private var __cardSetBSE:BaseSound         = new CardSetBSE();
        static private var __cardSetCSE:BaseSound         = new CardSetCSE();
        // カード配布音
        static private var __throwCardSE:BaseSound        = new ThrowCardSE();
        // サイコロ音
        static private var __throwDiceSE:BaseSound        = new ThrowDiceSE();
        // カード回転音
        static private var __rotateCardSE:BaseSound       = new RotateCardSE();
        // 剣ダメージ音
        static private var __damageSwordSE:BaseSound      = new DamageSwordSE();
        // 銃ダメージ音
        static private var __damageGunSE:BaseSound        = new DamageGunSE();
        // イベントカード提出
        static private var __chanceCardSE:BaseSound       = new ChanceCardSE();
        // フェイズ変更時SE
        static private var __phaseSE:BaseSound            = new PhaseSE();
        // 必殺技基本SE
        static private var __featInsertSE:BaseSound       = new FeatInsertSE();
        // トラップ発動音
        static private var __trapActionSE:BaseSound       = new TrapActionSE();
        // WINSE
        static private var __winSE:BaseSound              = new WinSE();
        // LOSESE
        static private var __loseSE:BaseSound             = new LoseSE();
        // GemSE
        static private var __gemSE:BaseSound              = new GemSE();
        // GemSE
        static private var __bonusClickSE:BaseSound       = new BonusClickSE();
        // GemSE
        static private var __bonusWinSE:BaseSound         = new BonusWinSE();
        static private var __bonusLoseSE:BaseSound        = new BonusLoseSE();

        // ***************** new ***************************
        static private var __clickSE:BaseSound = new ClickSE();
        static private var __alertSE:BaseSound = new Click2SE();
        static private var __channnelClickSE:BaseSound    = new DeckTabClickSE();
        static private var __cardSetTableSE:BaseSound = new CardSetTableSE();
        static private var __openActionCardSE:BaseSound = new OpenActionCardSE();


        static public  function playClick():void
        {
            __clickSE.playMultiSound();
        }
        static public  function playAlert():void
        {
            __alertSE.playMultiSound();
        }
        static public  function playLobbyClick():void
        {
            __lobbyClickSE.playMultiSound();
        }
        static public function playDeckSet():void
        {
            __deckSetSE.playMultiSound();
        }

        static public function playDeckCardClick():void
        {
            __deckCardClickSE.playMultiSound();
        }

        static public function playDeckTabClick():void
        {
            __deckTabClickSE.playMultiSound();
        }

        static public function playCharaCardRotate():void
        {
            __charaCardRotateSE.playMultiSound();
        }

        static public function playChain():void
        {
            __chainSE.playMultiSound();
        }
         // マッチ画面のクリック
        static public function playChannelClickSE():void
        {
            __channnelClickSE.playMultiSound();
        }

        // カードセット音（繰り返し部分）
        static public function playCardSetSE(t:int = 5):void
        {
            __cardSetBSE.loopMultiSound(t);
        }

        // カードセット音（繰り返し部分）
        static public function playCardSetTable():void
        {
            __cardSetTableSE.playMultiSound();
        }

        // カードセット音（繰り返し部分）
        static public function playOpenActionCard():void
        {
            __openActionCardSE.playMultiSound();
        }

        // トラップ発動音
        static public function playTrapAction():void
        {
            __trapActionSE.playMultiSound();
        }

        // カードセット音（はじめと終わりあり）
        static public function getCardSetSEThread(num:int):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new SleepThread(100));
            sExec.addThread(new ClousureThread(function():void{__cardSetASE.playMultiSound();}));
            sExec.addThread(new ClousureThread(playCardSetSE,[num]));
            sExec.addThread(new SleepThread(100 * num));
            return sExec;
        }

        // カード配布音（同期用のDelayあり）
        static public function getThrowCardSEThread(delay:Number):Thread
        {
            return __throwCardSE.getMultiPlayThread(delay);
        }

        // ダイス転がり音音（同期用のDelayあり）
        static public function getThrowDiceSEThread(delay:Number):Thread
        {
             return __throwDiceSE.getMultiPlayThread(delay);
        }

       // カード回転音
        static public function getRotateCardSEThread(delay:Number):Thread
        {
            return __rotateCardSE.getMultiPlayThread(delay)
        }

       // 剣ダメージ音
        static public function getDamageSwordSEThread(delay:Number):Thread
        {
            return __damageSwordSE.getMultiPlayThread(delay)
        }

       // 銃ダメージ音
        static public function getDamageGunSEThread(delay:Number):Thread
        {
            return __damageGunSE.getMultiPlayThread(delay)
        }

       // チャンスカード提出音
        static public function getChanceCardSEThread(delay:Number):Thread
        {
            return __chanceCardSE.getMultiPlayThread(delay)
        }

       // フェイズ変更音音
        static public function getPhaseSEThread(delay:Number):Thread
        {
            return __phaseSE.getMultiPlayThread(delay)
        }

       // フェイズ変更音音
        static public function getFeatInsertSEThread(delay:Number):Thread
        {
            return __featInsertSE.getMultiPlayThread(delay)
        }

       // 勝利音
        static public function getWinSEThread(delay:Number):Thread
        {
            return __winSE.getMultiPlayThread(delay)
        }


       // 敗北音
        static public function getLoseSEThread(delay:Number):Thread
        {
            return __loseSE.getMultiPlayThread(delay)
        }

      // GEM音
        static public function getGemSEThread(delay:Number):Thread
        {
            return __gemSE.getMultiPlayThread(delay);
        }

      // ボーナスクリック音
        static public function playBonusClickSE():void
        {
            __bonusClickSE.playMultiSound();
        }


       // 勝利音
        static public function getBonusWinSEThread(delay:Number):Thread
        {
            return __bonusWinSE.getMultiPlayThread(delay)
        }


       // 敗北音
        static public function getBonusLoseSEThread(delay:Number):Thread
        {
            return __bonusLoseSE.getMultiPlayThread(delay);
        }

   }
}