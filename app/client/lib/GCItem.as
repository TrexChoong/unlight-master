/**
  * Unlight
  * Copyright(c)2019 CPA This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */

package {
    import flash.utils.Dictionary;

    public class GCItem {
        private var dict:Dictionary;

        public function GCItem(value:Object) {
            dict = new Dictionary(true);
            dict[value] = true;
        }

        public function get target():Object {
            for (var key:Object in dict) return key;
            return null;
        }

        public function assertGC():void {
            GC.start();
            if (target) {
                log.writeLog(log.LV_FATAL, this, "GC is not", target);
            }else{
                log.writeLog(log.LV_FATAL, this, "GCed!!", target);
            }
        }
    }
}
