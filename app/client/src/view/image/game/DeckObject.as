
package view.image.game
{
    import flash.display.*;

    import org.papervision3d.events.FileLoadEvent;
    import org.papervision3d.objects.parsers.DAE;
    import org.papervision3d.materials.BitmapMaterial;
    import org.papervision3d.materials.utils.MaterialsList;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseObject;

    // デッキオブジェクトのクラス
    public class DeckObject extends BaseObject
    {
        [Embed(source="../../../../public/image/tex/deck.png")]
        private var _tex:Class; // テクスチャ
        [Embed(source="../../../../public/image/deck.dae", mimeType="application/octet-stream")]
        private var _path:Class; // daeファイルパス

        // コンストラクタ
        public function DeckObject()
        {
            var matList:Object = new Object();
            matList = {_Default:new BitmapMaterial((new _tex()).bitmapData)};
            getObject.load(XML(new _path()), new MaterialsList(matList));
        }

        // ファイルの読み込みと初期値の設定
        override protected function initObject(event:FileLoadEvent):void
        {
            _object.x = 45;
            _object.z = 45;
            _object.rotationY = 140;
            log.writeLog(log.LV_INFO, this, "");
        }


        // 更新処理
        public function update(num:int):void
        {
            /* デッキの増減処理をここへ */
            _object.scaleY = num * 0.03;
            _object.scaleX = _object.scaleZ = Number(num > 0);
        }
    }

}
