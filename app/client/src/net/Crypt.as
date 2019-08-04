package net
{
    import flash.utils.ByteArray;
    import com.hurlant.util.Hex;

    /**
     * 暗号化クラス
     *
     */
    public class Crypt
    {
        /**
         * 暗号化関数
         * ByteArrayを渡す
         */
        public var encrypt:Function;                      // 暗号化
        /**
         * 複合化関数
         * ByteArrayを返す
         */
        public var decrypt:Function;                      // 複合化

        private var sessionID:ByteArray= new ByteArray(); // セッションID

        /**
         * コンストラクタ
         *
         */
        public function Crypt()
        {
            encrypt = toNonCryptedCmd;
            decrypt = fromNonCryptedCmd;
        }

        /**
         * セッションキーを設定して暗号化関数に暗号ありに切り換える
         * @param sID セッションキー
         *
         */
        public function setSessionKey(sID:String):void
        {
            log.writeLog(log.LV_INFO , "Crypt.as","sessionID id",sID);
            var s:ByteArray;
            s = Hex.toArray(sID)
//             if (s.length!=20)
//             {
//                 log.writeLog(log.LV_ERROR , "Crypt.as","Invalid SessinoID. not length 20. get length " + s.length);
//                 throw new Error("Invalid SessinoID. not length 20. get length " + s.length);
//             }
            sessionID = s
            encrypt = toCryptedCmd;
            decrypt = fromCryptedCmd;
        }

        /**
         * セッションキーをクリアして暗号化関数を「暗号化なし」に切り換える
         *
         */
        public function clearSessionKey():void
        {
            log.writeLog(log.LV_INFO , "Crypt.as","Clear SessionKey");
            sessionID = null;
            encrypt = toNonCryptedCmd;
            decrypt = fromNonCryptedCmd;
        }

        // 暗号化
        private function toCryptedCmd(data:ByteArray):ByteArray
        {
            return xor(data, sessionID)
        }

        // 複合化
        private function fromCryptedCmd(data:ByteArray):ByteArray
        {
            return xor(data, sessionID)
        }
        // 暗号化なし
        private function toNonCryptedCmd(data:ByteArray):ByteArray
        {
            return data;
        }

        // 暗号化なし
        private function fromNonCryptedCmd(data:ByteArray):ByteArray
        {
            return data;
        }

        // XOR処理
        private function xor(str_a:ByteArray,cryp_a:ByteArray):ByteArray
        {
            var des_a:ByteArray = new ByteArray;
            var ln:int = cryp_a.length;
            var i:int;
            str_a.position = 0;
            cryp_a.position = 0;
            for (i = 0 ;i < str_a.length; i++)
            {
                str_a[i] = str_a[i]^cryp_a[i%ln];
            }
            str_a.position = 0;
            return str_a;
        }
    }
}