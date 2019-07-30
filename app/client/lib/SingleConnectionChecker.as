
/**
  * Unlight
  * Copyright(c)2019 CPA This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */

package
 {
     import flash.net.LocalConnection


     public  class SingleConnectionChecker extends LocalConnection
     {

         private var _isExistOther:Boolean = false;

         public function SingleConnectionChecker(connectionName:String):void
         {
         }

         public function ping():void
         {
             log.writeLog(log.LV_FATAL, this, "ping!");
         }

         public function isExitsO():Boolean
         {
             return _isExistOther;
         }


     }
 }