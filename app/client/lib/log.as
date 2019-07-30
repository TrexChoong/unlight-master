/**
  * Unlight
  * Copyright(c)2019 CPA This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */

package
 {
    import flash.external.ExternalInterface;
    import flash.utils.getQualifiedClassName;

    /**
     * ログを管理するクラス
     * 基本的にFireBugのコンソール出力に吐く
     */
    public class log
    {
        /**
         * ログのフィルタ設定
         *
         */
        public static const LOG_FILTER:String = null; // フィルタの設定
        /**
         * ログレベル：テスト
         */
        public static const LV_TEST:int       = 0;   // ログレベル：テスト
        /**
         * ログレベル：致命的
         */
        public static const LV_FATAL:int      = 1;    // ログレベル：致命的
        /**
         * ログレベル：エラー
         */
        public static const LV_ERROR:int      = 3;    // ログレベル：エラー
        /**
         * ログレベル：警告
         */
        public static const LV_WARN:int       = 5;    // ログレベル：警告
        /**
         * ログレベル：情報
         */
        public static const LV_INFO:int       = 7;    // ログレベル：情報
        /**
         * ログレベル：デバッグ
         */
        public static const LV_DEBUG:int      = 9;    // ログレベル：デバッグ

        private static var log_level:int       = 10;    // 以下のレベルを出す
        private static var testing:Boolean    = false;    // テストフラグ、強制的にログを-1に設定し変更を不可にする
        private static const LV:Array = new Array("[TEST]", "[FATAL]", "", "[ERROR]", "", "[WARN]", "", "[INFO]", "", "[DEBUG]");

        private static function rec(level:int, type:String, ... args):void {
            var inspect:Function = function(arg:*, bracket:Boolean = true):String {
                var className:String = getQualifiedClassName(arg);
                var str:String;

                switch(getQualifiedClassName(arg)) {
                case 'Array':
                    var results:Array = [];
                for (var i:uint = 0; i < arg.length; i++) {
                    results.push(inspect(arg[i]));
                }
                if (bracket) {
                    str = '[' + results.join(', ') + ']';
                } else {
                    str = results.join(', ');
                }
                break;
                case 'int':
                case 'uint':
                case 'Number':
                    str = arg.toString();
                    break;
                case 'String':
                    str = arg;
                    break;

                case 'flash.utils::ByteArray':
                    str ="[";
                    for (var j:uint = 0; j < arg.length; j++)
                    {
                        str=str+arg[j]+", "
                            }
                    str =str + "]";

                break;

                default:
                    str = '#<' + className + ':' + String(arg) + '>';
                }
                return str;
            }
            var date:Date = new Date();

            var r:String = type + ": " + inspect(args, false);
            switch (level){
            case LV_FATAL:
            case LV_ERROR:
                ExternalInterface.call('console.error', r);
                break;
            case LV_WARN:
                ExternalInterface.call('console.warn', r);
                break;
            case LV_INFO:
                ExternalInterface.call('console.info', r);
                break;
            case LV_DEBUG:
                ExternalInterface.call('console.debug', r);
                break;
            case LV_TEST:
            default:
                ExternalInterface.call('console.log', r);
            }

        }

        /**
         * ログの出力
         * @param level ログレベル
         * @param caller 呼び出しもとクラス
         * @param ... 書き込む内容
         */
        CONFIG::DEBUG
        public static function writeLog(level:int, caller:*, ... args):void
        {
            var type:String;

            if (typeof(caller)=="string")
            {
                type = String(caller);
            }else{
                type =getQualifiedClassName(caller);            }

            if (level <= log_level)
            {
                if ((LOG_FILTER == null) || ( LOG_FILTER == type))
                {
                    rec(level, LV[level]+type, args);
                }
            }
        }

        CONFIG::RELEASE
        public static function writeLog(level:int, caller:*, ... args):void
        {
        }

        /**
         * 出力ログレベルのセット
         * @param level 出力したいログレベル
         *
         */
        public static function set_log_level(level:int):void
        {
            if (!testing)
            {
                log.writeLog(log.LV_TEST,"LOG", "set LEVEL ",testing, level);
                log_level=level;
            }
        }
        /**
         * テストモードに切り換える
         * テストのログしか出さなくなる
         *
         */

        public static function onTestMode():void
        {
            testing = true;
            log.writeLog(log.LV_TEST,"LOG", "set TEST Mode");
            log_level = LV_ERROR;
        }

    }
}