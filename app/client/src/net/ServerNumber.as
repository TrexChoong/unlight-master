package net
{
    import flash.utils.ByteArray;
    import com.hurlant.crypto.hash.SHA1;

    /**
     * サーバナンバーを計算する関数
     * 
     * 
     */
    public class ServerNumber
    {

        public static function getNo(s:String,num:int):int
        {
            if (num == 0)
            {
                log.writeLog(log.LV_FATAL, "ServeNO", "wrong Server NUM");
                return 0;
            }else{
            var sha1:SHA1 = new SHA1();
            var src:ByteArray =new ByteArray;
            src.writeUTFBytes(s);
            src = sha1.hash(src);
            src.position = 0;
            var i:uint = src.readUnsignedInt();
            log.writeLog(log.LV_INFO, "ServeNo is", i%num,"num:",num,"id:",i);
            return i%num;
            }
        }
    }
}
