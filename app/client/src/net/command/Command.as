package net.command

{
    import flash.utils.ByteArray;
    import model.*;
    /**
     * コマンドのベースクラス
     */
    public class Command
    {
        protected var receiveCommands:Array /* of function */ = new Array(); // 受信コマンド
        /**
         * 受信情報をコマンドとして実行する（子クラスで受信コマンドは登録される）
         * @param cmd 受信したデータ
         */
        public function receiveCommand(cmd:Array):void
        {
            cmd.position = 0;
            var i:int;
            var ba:ByteArray;
            var ii:int;
            ii = 0;

            while (ii < cmd.length)
            {
                ba = new ByteArray();
                i = cmd[ii].readUnsignedShort();
//                log.writeLog(log.LV_INFO, this, "receive ", cmd[ii].length,i);
                // 命令の正当性のチェックだが今は無視（ソケットデクリプトのときにやっているため）
                // そもそもチェックのしかたが変（コマンドの最後が改行かをしらべるならばまだしも。旧コードか。）
//                 if (cmd[ii].readUTFBytes(1)!=('\n'))
//                 {
                    cmd[ii].position = 2;
                    cmd[ii].readBytes(ba);
//                 }
                log.writeLog(log.LV_INFO, this, "receive cmd No.", i);
                if (receiveCommands.length > i)
                {
                    receiveCommands[i](ba);
                }else
                {
                    log.writeLog(log.LV_ERROR, this, "Invalid cmd No" );
                }
                ii+=1
            }

        }

    }
}


