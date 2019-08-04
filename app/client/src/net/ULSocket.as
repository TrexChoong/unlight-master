package net
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.ByteArray;
    import flash.system.Security
    
    /**
      * ソケットクラス
      * 接続・暗号・復号・圧縮・展開を行う
      */
      public class ULSocket extends Socket
    {
        /**
         * 受信イベント
         */
        public static const GET_COMMAND:String = 'get command';
        /**
         * 暗号化済みか？
         */
        public  var crypted:Boolean = false;
        private var commpless:Boolean = false;                  // 圧縮するか？
        private var commandlist:Array;                          // ストアされるコマンド
        private var cipher:Crypt;                               // 暗号化関数
        // 中断パケットのVector
        private var _haltPacketSet:Vector.<ByteArray > = new Vector.<ByteArray >();
        private var init:Boolean = false;                       // 初期化

        private static var pocliyFileloaded:Boolean = false;

        /**
         * ソケットのコンストラクタ
         * @param h 接続先のhostname
         * @param p 接続先のPort
         */
        // ソケットの初期化
        public function ULSocket(h:String = null, p:int = 0)
        {
             var policyHost:String = "xmlsocket://"+h+":11999"
//             log.writeLog(log.LV_FATAL, this, "|||||||||||||||||||||| pocliy get ||||||||||||||||",policyHost);
//             Security.loadPolicyFile(policyHost);
//                        Security.loadPolicyFile("xmlsocket://note-ubuntu:11999");
            super(h,p);
            cipher = new Crypt();
        }

        public override function connect(h:String, p:int):void
        {
            var policyHost:String = "xmlsocket://"+h+":11999"
                log.writeLog(log.LV_FATAL, this, "|||||||||||||||||||||| pocliy get ||||||||||||||||",policyHost);
//             if (pocliyFileloaded == false)
//             {
                Security.loadPolicyFile(policyHost);
                pocliyFileloaded = true;
//             }
            super.connect(h,p);
        }


        /**
        * セッションキーを設定して、暗号化をONにする。
        * @param k セッションキー
        */
       public function setSessionKey(k:String):void
        {
            cipher.setSessionKey(k);
//            log.writeLog(log.LV_INFO, "ULSocket.as","set session",k);
            crypted = true;
        }

        /**
         * セッションキーをクリアして暗号化をOFFにする
         *
         */
       public function clearSessionKey():void
        {
            cipher.clearSessionKey();
            crypted = false;
        }

        /**
         * コマンドを送信
         * @param data 送信するデータ
         */
        public function send(data:ByteArray):void
        {
            var ba:ByteArray = new ByteArray();
            ba.writeShort (data.length);
            // 圧縮がここに入る。data.compress
//            log.writeLog(log.LV_INFO, this, "data len",ba);

            writeShort (data.length);
            writeBytes (cipher.encrypt(data));
            writeUTFBytes ("\n");
            flush();     // 送信
//            log.writeLog(log.LV_DEBUG, this,"Send",data);
        }


        /**
         * 受信データを取り出す（暗号化部分は複合化する）
         * @return 複合化済みデータ（バイナリ）
         */
        public function receive():Array
       {
           var tmp:ByteArray = new ByteArray();
           readBytes(tmp);
//           log.writeLog(log.LV_DEBUG, this, "get",tmp);
           tmp.position = tmp.length -1;
           if (tmp.readUTFBytes(1)==('\n'))
           {
               if (_haltPacketSet.length == 0)
               {
                   return decode(tmp);
               }else{
                   var haltPacket:ByteArray = new ByteArray;
                   var len:int = _haltPacketSet.length
                       for(var i:int = 0; i < len; i++){
                           haltPacket.writeBytes(_haltPacketSet.shift());
                       }
                   haltPacket.writeBytes(tmp);
                   log.writeLog(log.LV_FATAL, this, "halt! resolve");
                   return decode(haltPacket);
               }
           }else{ 
               log.writeLog(log.LV_FATAL, this, "halt!");
               _haltPacketSet.push(tmp);
               return [];
           }

       }

       // 暗号化部分をデコード
       private function decode(data:ByteArray):Array
       {
//           log.writeLog(log.LV_DEBUG, this,"decrypt start",data);
           var i:int;
           var len:int;
           var ret:Array = new Array();
           var retData:ByteArray;
           var tmp:ByteArray = new ByteArray();
           i = 0;
           data.position =i;

           while (i < data.length)
           {
               retData = new ByteArray();
               len = data.readUnsignedInt();
               // log.writeLog(log.LV_FATAL, this, "socket decode data", len, data.length);
               try{
                   data.readBytes(tmp,0,len);
                   // log.writeLog(log.LV_FATAL, this, "tmp", tmp);
               }
               catch(e:Error)
               {
                   log.writeLog(log.LV_FATAL, this, "!!!!!! error !!!!!!", e.message);
                   log.writeLog(log.LV_FATAL, this, "!!!!!! error !!!!!!", len,data.length);
                   log.writeLog(log.LV_FATAL, this, "!!!!!! error !!!!!!", tmp);
               }
               if (data.readUTFBytes(1)==('\n'))
               {
                   // 解凍 tmp.uncompress
                   retData.writeBytes(cipher.decrypt(tmp));
                   // これいらないかも
                   retData.writeUTFBytes("\n");
               }
               tmp.length = 0;
               // int（32bit）+改行で5バイト
               i+=(len+5);
               retData.position = 0;
               ret.push(retData);
           }
//           log.writeLog(log.LV_DEBUG, this,"decode decrypt",ret);
           return ret;
       }


    }
}
