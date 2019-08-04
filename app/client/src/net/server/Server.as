package net.server
{
    import flash.utils.ByteArray;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;

    import org.libspark.thread.Thread;

    import net.command.Command;
    import net.*;
    import model.Player;

    /**
     * サーバの情報を扱う基底クラス
     *
     */
    public class Server extends EventDispatcher
    {
        /**
         * サーバの接続イベント
         *
         */
        public static const CONNECT:String    = 'connect';

        /**
         * サーバと切断イベント
         *
         */
        public static const DISCONNECT:String = 'disconnect'; // サーバと切断イベント

        /**
         * サーバが無効な場合のイベント
         *
         */
        public static const INVALID:String    = 'invalid'; // サーバが無効イベント

        public var host:Host; // サーバからのイベントと情報受け渡すオブジェ

        protected static var __instance:Server; // シングルトン保存用

        protected var sessionId:ByteArray = new ByteArray();    // セッションID
        protected var address:String;
        protected var port:int;
        protected var player:Player = Player.instance;

        private var getedCommandArray:ByteArray; // 受信したコマンド
        private var _command:Command;

        private var _commands :Array = []; // 遅延評価表のコマンド列配
//        private var _commandExc: CommandExcuter;


        // コンストラクタ（シングルトン）
        public function Server(caller:Function=null)
        {
            host = new Host();
            host.addEventListener(Host.HEART_BEAT, heartBeatHandler);
            host.addEventListener(Host.GAME_HEART_BEAT, gameHeartBeatHandler);
        }


        /**
         * 接続（引数のない場合コンフィグから読み込む）
         *
         */
        public function connect(adr:String = null, prt:int = 0):void
        {
            if (adr==null)
            {
                    configLoad();
                    connectHost();
            }
            else
            {
                address =adr;
                port = prt;
                connectHost();
            }
        }

        /**
         * ホストとの接続を行う
         *
         */
         protected function connectHost():void
         {
           log.writeLog(log.LV_INFO, this,"host connect start","address",address, "port",port);
//            host = new Host(address, port, command);
           host.init(address, port, command);
           host.connect();
           setHostEventListener();
         }

        // オーバライド前提のゲッタ
        protected function get command():Command
        {
            return _command;
        }

        // 開始
        public function exit():void
        {
            host.close();
            log.writeLog(log.LV_DEBUG, this,"LogOut");
        }


        // オーバライド前提のコンフィグローダ
        protected  function configLoad():void
        {
        }

        // オーバライド前提のHeartBeatHandler
        protected function heartBeatHandler(e:Event):void
        {

        }

        // オーバライド前提のGameHeartBeatHandler
        protected function gameHeartBeatHandler(e:Event):void
        {

        }

        // ホストからのイベントを再発信する
        protected function setHostEventListener():void
        {

            host.addEventListener(Host.SERVER_OK,serverOKHandler);
            host.addEventListener(Host.SERVER_QUIT,serverQUITHandler);
        }

        protected function serverOKHandler (event:Event):void
        {
            dispatchEvent(new Event(Server.CONNECT));
        }

        protected function serverQUITHandler (event:Event):void
        {
            dispatchEvent(new Event(Server.DISCONNECT));
        }

        /**
         * サーバのステートを返す
         * @return 接続なし:-1,コネクトなし:0 ,認証なし:1,認証済み:2
         *
         */
        // サーバーステートを返す
        public function get state ():int
        {
            return host.serverState();
        }

        // 無効なサーバ
        private function invaid ():void
        {
            dispatchEvent(new Event(Server.INVALID));
        }

        // 再接続
        public function reconnect():void
        {
            host.connect();
        }

        // コマンドのスタックに積む（遅延評価が必要なコマンドはここにつまれる）
        public function commandPush(func:Function, arg:Array):void
        {
            _commands.push([func, arg])
        }

        // コマンドをクリアする
        public function commandClear():void
        {
            _commands = [];
        }

        // 遅延コマンドを評価する
        public function commandShift():Boolean
        {
            var a:Array = _commands.shift();
            if (a)
            {
                a[0].apply(this, a[1]);
                return true;
            }else
            {
                return false;
            }
        }

        // 
        protected function string2intArray(str:String):Array
        {
            if ((str != "")&&(str != null))
            {
                return str.split(",").map(function(item:*, index:int, array:Array):Object {
                        if (item.indexOf("|") < 0)
                        {
                            return int(item);
                        }
                        else
                        {
                            return item.split("|");
                        }
                    });
            }else{
                return [];
            }
        }

        protected function string2parseIntArray(str:String):Array
        {
            if ((str != "")&&(str != null))
            {
                return str.split(",").map(function(item:*, index:int, array:Array):int {return parseInt(item, 16)});
//               return str.split(",").map(function(item:*, index:int, array:Array):int {return parseInt(item)});
            }else{
                return [];
            }
        }

        protected function string2BooleanArray(str:String):Array
        {
            if ((str != "")&&(str != null))
            {
                return str.split(",").map(function(item:*, index:int, array:Array):Boolean {return (item=="true")? true:false});
            }else{
                return [];
            }
        }

        protected function int2BooleanArray(v:int, size:int):Array
        {
            var ret:Array = [];
            var j:int
            for(var i:int = 0; i < size; i++)
            {
                j = v >> i;
                ret.push (Boolean(1&j));
            }
            return ret;
        }

        protected function arraySeparateTwo(a:Array):Array
        {
            var ret:Array = [];
            for(var i:int = 0; i < a.length; i+=2)
            {
//                log.writeLog(log.LV_FATAL, this,"sepatrater", i,a[i], a[i+1]);
                ret.push ([a[i],a[i+1]]);
            }
            return ret;
        }

        protected function arraySeparateThree(a:Array):Array
        {
            var ret:Array = [];
            for(var i:int = 0; i < a.length; i+=3)
            {
//                log.writeLog(log.LV_FATAL, this,"sepatrater", i,a[i], a[i+1], a[i+2]);
                ret.push ([a[i],a[i+1],a[i+2]]);
            }
            return ret;
        }


        protected function arraySeparateNum(num:int, a:Array):Array
        {
            var ret:Array = [];
            for(var i:int = 0; i < a.length; i+=num)
            {
//                log.writeLog(log.LV_FATAL, this,"sepatrater", i,a[i], a[i+1], a[i+2]);
                var c:Array = [];
                for(var j:int = 0; j < num; j++){
                    c.push(a[j+i])
                }
                ret.push (c);
            }
            return ret;
        }


        // 受信

        

//         public function goCommand():void
//         {
//             _commandExc.go();
//         }
//         public function waitCommand():void
//         {
//             _commandExc.stop();
//         }
//         public function get commandExc():Thread
//         {
//             return _commandExc;
//         }


    }

}

// 以下削除予定
// 受信コマンドのスタック実行スレッド

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.tweener.TweenerThread;

import net.server.Server;

class CommandExcuter extends Thread
{
    private var _server:Server;
    private var _e:Boolean;

    public function CommandExcuter(srv:Server)
    {
        _server = srv;
    }

    protected override function run():void
    {
        if (_e)
        {
            if (!(_server.commandShift())) {notifyAll()};
        }
        next(run);
        interrupted(close);
    }

    private function close ():void
    {
    }

    public function go():void
    {
        _e =true;
    }
    public function stop():void
    {
        _e =false;
    }
}

