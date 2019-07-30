/**
  * Unlight
  * Copyright(c)2019 CPA This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */

package
 {
    public class ReplaceNGWord
    {
        static private var __patArray:Array  = [
            []
        ];

        static public function init():Array
        {
            var ret:Array = []; /* of  */
            for(var i:int = 0; i < __patArray.length; i++){
                ret.push(new RegExp(__patArray[i].join("|"),"g"))
                         };
                return ret
        }

        static private var __regExpSet:Array = init(); /* of Regxp */

        static public function replace(txt:String):String
        {
            for(var i:int = 0; i < __regExpSet.length; i++){
                txt = txt.replace(__regExpSet[i], "***")
            }
            return txt
        }


    }
 }