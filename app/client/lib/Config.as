/**
  * Unlight
  * Copyright(c)2019 CPA This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */

package
{
    import flash.events.Event;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;


    /**
     * 設定ファイルの情報を扱うクラス
     * 各サーバーの情報や、ニュースのHTMLを読み込む
     */
    public class Config extends XMLData
    {
        private static const _TRANS_CONFIG_URL	:String = "/public/config.xml";
        private static const __URL:String = _TRANS_CONFIG_URL
        private static const __VERSION:String = "multi_servers_111003"

        /**
         * 設定のバージョン
         * @default 0
         *
         */

        // 認証サーバの数
        private  static  var __authServerNum:int =1;

        /**
         * 認証サーバ情報（address, port）
         *
         */
        private  static  var __authServerInfoSet:Array = [];;


        /**
         * ロビーサーバ情報（address, port）
         *
         */
        private static var __lobbyServerInfo:Object = {address:"", port:0};;

        /**
         * データサーバ情報（address, port）
         *
         */
        private static var __dataServerInfo:Object = {address:"", port:0};;

        /**
         * クエストサーバ情報（address, port）
         *
         */
       private  static var __questServerInfo:Object = {address:"", port:0};;

        /**
         * レイドサーバ情報（address, port）
         *
         */
       private  static var __raidServerInfo:Object = {address:"", port:0};;

        /**
         * レイドチャットサーバ情報（address, port）
         *
         */
       private  static var __raidChatServerInfo:Object = {address:"", port:0};;

        /**
         * レイドデータサーバ情報（address, port）
         *
         */
       private  static var __raidDataServerInfo:Object = {address:"", port:0};;

        /**
         * レイドランクサーバ情報（address, port）
         *
         */
       private  static var __raidRankServerInfo:Object = {address:"", port:0};;

        /**
         * グローバルチャットサーバ情報（address, port）
         *
         */
       private  static var __globalChatServerInfo:Object = {address:"", port:0};;

        /**
         * 現在序の状態(現在の状態（-1:不明,0:メンテ,1:O)
         * @default -1
         */
        private static var __server_state:int = -1;

        private static var __version:String;

        private static var __instance:Config = new Config;

        /**
         * コンストラクタ
         *
         */
        public static function init():void
        {
            __instance = new Config();
        }

        public static function get authServerNum():int
        {
            return __authServerNum;
        }

        public static function authServersInfo(no:int):Object
        {
            return __authServerInfoSet[no]
        }

        public static function get lobbyServerInfo():Object
        {
            return __lobbyServerInfo;
        }

        public static function get dataServerInfo():Object
        {
            return __dataServerInfo;
        }

        public static function get questServerInfo():Object
        {
            return __questServerInfo;
        }

        public static function get raidServerInfo():Object
        {
            return __raidServerInfo;
        }

        public static function get raidChatServerInfo():Object
         {
            return __raidChatServerInfo;
        }

        public static function get raidDataServerInfo():Object
         {
            return __raidDataServerInfo;
        }
        public static function get raidRankServerInfo():Object
         {
            return __raidRankServerInfo;
        }

        public static function get globalChatServerInfo():Object
         {
             return __globalChatServerInfo;
        }

        public static function get serverState():int
        {
            return __server_state;
        }

        public static function get instance():Config
        {
            return __instance;
        }

        public function Config()
        {
            super()
        }

        protected override function get url():String
        {
            return __URL
        }

        private function getServerNumWithWeight(wSet:Array):int
        {
            var now:Date = new Date();
            var rand:Number;
            var num:int = wSet.length;
            var base:int = 0;
            var baseSet:Array = [];
            var ret:int;
            var i:int;
            for(i = 0; i < num; i++){
                base += wSet[i];
                baseSet.push(base);
            }

           rand=(Math.random()*base);

           for(i = 0; i < num; i++){
               if (rand < baseSet[i])
               {
                   ret = i;
                   break;
               }
            }

           return ret;
        }

        private function getServerInfoSet(n:int,xml:Object):Array
        {
            var ret:Array = [[],[]]; /* of serveInfoObje,weight */
            var serverNum:int = 0;

            // ロビーサーバの情報を読み込む
            for(var i:int = 0; i < n; i++)
            {
                if (xml.child(i).ports.toString()!="")
                {
                    var portsStrSet:Array  = (xml.child(i).ports).toString().split("-");
                    var start:uint = uint(portsStrSet[0]);
                    var end:uint = uint(portsStrSet[1]);
                    var num:uint = end-start+1;
                    for(var j:int = 0; j < num; j++){
                        ret[0][serverNum] = {address:xml.child(i).name, port:start+j};
                        if(xml.child(i).weight == null)
                        {
                            ret[1][serverNum] = 1;
                        }else{
                            ret[1][serverNum] = int(xml.child(i).weight);
                        }
                        serverNum +=1;
                    }
                }else{
                    ret[0][serverNum] = {address:xml.child(i).name, port:uint(xml.child(i).port)};
                    if(xml.child(i).weight == null)
                    {
                        ret[1][serverNum] = 1;
                    }else{
                        ret[1][serverNum] = int(xml.child(i).weight);
                    }
                    serverNum +=1;

                }

            }
            return ret;
        }

        // 読み込み完了時に呼び出されるイベント
        protected override function setData (xml:XML):void
        {
            // 認証サーバの情報を読み込む
            var authNum :int = int(xml.host.auth_servers.child("*").length());
            var lobbyNum :int = int(xml.host.lobby_servers.child("*").length());
            var dataNum :int = int(xml.host.data_servers.child("*").length());
            var questNum :int = int(xml.host.quest_servers.child("*").length());
            var raidNum :int = int(xml.host.raid_servers.child("*").length());
            var raidChatNum :int = int(xml.host.raid_chat_servers.child("*").length());
            var raidDataNum :int = int(xml.host.raid_data_servers.child("*").length());
            var raidRankNum :int = int(xml.host.raid_rank_servers.child("*").length());
            var globalChatNum :int = int(xml.host.global_chat_servers.child("*").length());

            var lobbyServeSet:Array = [];
            var dataServeSet:Array = [];
            var questServeSet:Array = [];
            var raidServeSet:Array = [];
            var raidChatServeSet:Array = [];
            var raidDataServeSet:Array = [];
            var raidRankServeSet:Array = [];
            var globalChatServeSet:Array = [];
            var lobbyWeight:Array = []; /* of int */
            var dataWeight:Array = []; /* of int */
            var questWeight:Array = []; /* of int */
            var raidWeight:Array = []; /* of int */
            var raidChatWeight:Array = []; /* of int */
            var raidDataWeight:Array = []; /* of int */
            var raidRankWeight:Array = []; /* of int */
            var globalChatWeight:Array = []; /* of int */
            var i:int;

            if(__VERSION == xml.version)
            {
                for(i = 0; i < authNum; i++)
                {
                    __authServerInfoSet[i] = {address:xml.host.auth_servers.child(i).name, port:uint(xml.host.auth_servers.child(i).port)};
                }
                __authServerNum = authNum;
                lobbyServeSet = getServerInfoSet(lobbyNum,xml.host.lobby_servers);
                __lobbyServerInfo = lobbyServeSet[0][getServerNumWithWeight(lobbyServeSet[1])];
                dataServeSet = getServerInfoSet(dataNum,xml.host.data_servers);
                __dataServerInfo = dataServeSet[0][getServerNumWithWeight(dataServeSet[1])];
                questServeSet = getServerInfoSet(questNum,xml.host.quest_servers);
                __questServerInfo = questServeSet[0][getServerNumWithWeight(questServeSet[1])];
                raidServeSet = getServerInfoSet(raidNum,xml.host.raid_servers);
                __raidServerInfo = raidServeSet[0][getServerNumWithWeight(raidServeSet[1])];
                raidChatServeSet = getServerInfoSet(raidChatNum,xml.host.raid_chat_servers);
                __raidChatServerInfo = raidChatServeSet[0][getServerNumWithWeight(raidChatServeSet[1])];
                raidDataServeSet = getServerInfoSet(raidDataNum,xml.host.raid_data_servers);
                __raidDataServerInfo = raidDataServeSet[0][getServerNumWithWeight(raidDataServeSet[1])];
                raidRankServeSet = getServerInfoSet(raidRankNum,xml.host.raid_rank_servers);
                __raidRankServerInfo = raidRankServeSet[0][getServerNumWithWeight(raidRankServeSet[1])];
                globalChatServeSet = getServerInfoSet(globalChatNum,xml.host.global_chat_servers);
                __globalChatServerInfo = globalChatServeSet[0][getServerNumWithWeight(globalChatServeSet[1])];

                __server_state  = xml.host.state;
            }else{
                Alerter.showWithSize('正しいXML情報が読み取れませんでした。バージョンが異なります)', 'Error', 4, null, alertHandlr);
            }

        }

        private function alertHandlr(e:Event):void
        {
            update()
        }
    }
}
