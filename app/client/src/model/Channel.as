package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    import org.libspark.thread.*;

    import model.events.*;

    /**
     * ゲームロビーのチャンネルクラス
     *
     */
    public class Channel extends BaseModel
    {
        public static const PNLY_TYPE_AI:int= 0;
        public static const PNLY_TYPE_ABORT:int= 1;

        public static const WATCH_MODE_OFF:int = 0;
        public static const WATCH_MODE_ON:int  = 1;

        private var _name:String;           // チャンネル名
        private var _rule:int;              // ルール
        private var _capacity:int;          // 許容人数
        private var _currentNum:int;        // 現在の人数
        private var _host:String;           // IP
        private var _port:int;              // port番号
        private var _duelHost:String;       // DuelServer_ip
        private var _duelPort:int;          // DuelServer_port
        private var _chatHost:String;       // ChatServer_ip
        private var _chatPort:int;          // ChatServer_port
        private var _watchHost:String;      // WatchServer_ip
        private var _watchPort:int;         // WatchServer_port
        private var _state:int;             // 状態
        private var _count:int;             // 現在の人数
        private var _penaltyType:int;      // ペナルティの種類
        private var _costLimitMin:int;    // コスト制限の最小値
        private var _costLimitMax:int;    // コスト制限の最大値
        private var _watchMode:int;        // 観戦ON/OFF

        private var _caption:String;        // 説明

        public static var current:int = -1;      // 選択中のチャンネル番号

        public static var list:Array = [];  // Array of Channel
        private static var __loaded:Boolean = false;

        private static var __currentChannelID:int;

        // コンストラクタ
        public function Channel(id:int, name:String, rule:int, capacity:int, host:String, port:int, duelHost:String, duelPort:int, chatHost:String, chatPort:int, watchHost:String, watchPort:int, state:int, caption:String, count:int, penaltyType:int, costLimitMin:int, costLimitMax:int, watchMode:int)
        {
            _id = id;
            _name = name;
            _rule = rule;
            _capacity = capacity;
            _host = host;
            _port = port;
            _chatHost = chatHost;
            _chatPort = chatPort;
            _duelHost = duelHost;
            _duelPort = duelPort;
            _watchHost = watchHost;
            _watchPort = watchPort;
            _state = state;
            _caption = caption;
            _count = count;
            _penaltyType = penaltyType;
            _costLimitMin = costLimitMin;
            _costLimitMax = costLimitMax;
            _watchMode = watchMode;
            Channel.list.push(this);
        }

        // チャンネルを初期化する
        public static function initChannelList(id:Array, name:Array, rule:Array, capacity:Array, host:Array, port:Array, duelHost:Array, duelPort:Array, chatHost:Array, chatPort:Array, watchHost:Array, watchPort:Array, state:Array, caption:Array,count:Array,penaltyType:Array,costLimitMin:Array,costLimitMax:Array, watchMode:Array ):void
        {
            Channel.list = [];
            id.forEach(function(item:*, idx:int, array:Array):void{ new Channel(id[idx], name[idx], rule[idx], capacity[idx], host[idx], port[idx], duelHost[idx], duelPort[idx], chatHost[idx], chatPort[idx], watchHost[idx], watchPort[idx], state[idx],caption[idx],count[idx],penaltyType[idx],costLimitMin[idx],costLimitMax[idx],watchMode[idx])});
            __loaded = true;
            current = -1;
        }

        // 特定ナンバーのチャンネルに入場する（IDでアクセスするのではないことに注意！）
        public static function joinChannel(no:int):void
        {
            log.writeLog(log.LV_FATAL, "CHANNEL", "joinChannel loaded?", Channel.loaded,"list",list,"call no",no);
            list[no].join();
            current = no;
        }

        // 特定ナンバーのチャンネルから退出する（IDアクセスするのではないことに注意！）
        public static function exitChannel(no:int):void
        {
            list[no].exit();
            current = -1;
        }

        // ローディングを待ってNotifiyを送るスレッドを返す
        public static function getLoadWaitingThread():Thread
        {
            return new LoadWaintngThread();
        }

        // チャンネルのロードが終了しているか？
        public static function get loaded():Boolean
        {
            return __loaded;
        }

        // チャンネルのロードが終了しているか？
        public static function get currentChannelID():int
        {
            return __currentChannelID;
        }

        // チャンネルのロードが終了しているか？
        public static function set currentChannelID(id:int):void
        {
            __currentChannelID = id;
        }

        // チャンネルに入場する
        public function join():void
        {
            dispatchEvent(new ChannelEvent(ChannelEvent.JOIN, _id));
        }

        // チャンネルに退出する
        public function exit():void
        {
            dispatchEvent(new ChannelEvent(ChannelEvent.EXIT, _id));
        }

        // チャンネル名を取得
        public function get name():String
        {
            return _name;
        }
        // ルールを取得
        public function get rule():int
        {
            return _rule;
        }
        // 許容人数を取得
        public function get capacity():int
        {
            return _capacity;
        }

        // 許容人数を取得
        public function get count():int
        {
            return _count;
        }
        // キャプション
        public function get caption():String
        {
            return _caption;
        }

        // IP
        public function get host():String
        {
            return _host;
        }

        // port
        public function get port():int
        {
            return _port;
        }

        // IP
        public function get duelHost():String
        {
            return _duelHost;
        }

        // port
        public function get duelPort():int
        {
            return _duelPort;
        }

        // IP
        public function get chatHost():String
        {
            return _chatHost;
        }

        // port
        public function get chatPort():int
        {
            return _chatPort;
        }

        // IP
        public function get watchHost():String
        {
            return _watchHost;
        }

        // port
        public function get watchPort():int
        {
            return _watchPort;
        }

        // 状態を取得
        public function get state():int
        {
            if (isCapacityOver)
            {
                return Const.CSTATE_OVER;
            }else{
                return _state;

            }
        }
        // ペナルティの種類を取得
        public function get penaltyType():int
        {
            return _penaltyType;
        }
        // コスト制限の最小値を取得
        public function get costLimitMin():int
        {
            return _costLimitMin;
        }
        // コスト制限の最大値を取得
        public function get costLimitMax():int
        {
            return _costLimitMax;
        }
        // 観戦ON/OFF
        public function get watchMode():int
        {
            return _watchMode;
        }

        // 許容人数を取得
        public function get isCapacityOver():Boolean
        {
            return _capacity<_count;
        }

        // コスト制限チェック trueなら条件を満たす
        public function costLimitCheck(cost:int=0):Boolean
        {
            // ルールコスト制限95or75の場合を先にチェック
            if (_rule == Const.CRULE_COST_A) {
                if (cost == 95) {
                    return true;
                } else {
                    return false;
                }
            }
            if (_rule == Const.CRULE_COST_B) {
                if (cost == 75) {
                    return true;
                } else {
                    return false;
                }
            }

            // minかmaxのどちらか1つでも0なら制限なし
            if ( _costLimitMin == 0 || _costLimitMax == 0 ) return true;

            var ret:Boolean = true;
            if ( cost < _costLimitMin ) {
                ret = false;
            } else if ( cost > _costLimitMax ) {
                ret = false;
            }
            return ret;
        }

        // クイックマッチかの判定
        public function get isRadder():Boolean
        {
            return (_rule == Const.CRULE_RADDER || _rule == Const.CRULE_HIGH || _rule == Const.CRULE_COST_A || _rule == Const.CRULE_COST_B);
        }

        // イベントハンドラの登録
        public static function registHandlers(j:Function, e:Function):void
        {
            list.forEach(function(item:*, index:int, array:Array):void
            {
                item.addEventListener(ChannelEvent.JOIN, j);
                item.addEventListener(ChannelEvent.EXIT, e);
            });
        }

        // 更新のためにロードをリセット
        public static function unload():void
        {
            __loaded = false;
        }
    }
}
// すべてのActionCard情報をロードするスレッド

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.tweener.TweenerThread;

import model.Channel;

class  LoadWaintngThread extends Thread
{
    protected override function run():void
    {

        next(waiting);
    }

    private function waiting():void
    {
        if (Channel.loaded)
        {
            next(close);
        }else{
            next(waiting);
        }
    }

    private function close():void
    {
        notifyAll();
    }
}
