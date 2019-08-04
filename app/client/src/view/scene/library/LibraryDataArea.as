package view.scene.library
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    import mx.core.UIComponent;
    import mx.controls.Text;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.scene.BaseScene;
    import view.scene.common.*;
    import view.scene.edit.*;

    import model.*;
    import model.events.*;

    /**
     * エディット画面のデータ部分のクラス
     *
     */
    public class LibraryDataArea extends DataArea
    {

        /**
         * コンストラクタ
         *
         */
        public static function getCharaCardData():LibraryDataArea
        {
            log.writeLog(log.LV_INFO, "chara card data");
            return new LibraryDataArea(InventorySet.TYPE_CHARA);
        }

        public function LibraryDataArea(type:int)
        {
            super(type);
        }

        public function selectListCardHandler(e:EditCardEvent):void
        {
            selectCardHandler(e);
        }

        // カード選択
        protected override function selectCardHandler(e:EditCardEvent):void
        {
            super.selectCardHandler(e);
        }
    }
}

