package net.command
{
    import flash.utils.ByteArray;
    import net.server.GlobalchatServer;

    /**
     * サーバとのコマンドを管理するクラス
     * （自動生成される rake update_command）
     */

    public class GlobalchatCommand extends Command
    {
       private var server:GlobalchatServer;
       public function GlobalchatCommand(s:GlobalchatServer)
        {
            server =s;
            receiveCommands.push(negoCert);
            receiveCommands.push(loginCert);
            receiveCommands.push(loginFail);
            receiveCommands.push(scKeepAlive);
            receiveCommands.push(scSendHelp);

        }
// 送信コマンド

     public function negotiation(uid:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(0);
            cmd.writeInt(uid);

            return cmd;
        }

     public function login(ok:String, crypted_sign:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(1);
            cmd.writeUTF(ok);
            cmd.writeUTF(crypted_sign);

            return cmd;
        }

     public function logout():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(2);

            return cmd;
        }

     public function csKeepAlive():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(3);

            return cmd;
        }

     public function csAddHelpList(key:String, help:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(4);
            cmd.writeUTF(key);
            cmd.writeUTF(help);

            return cmd;
        }

// 受信コマンド

     private function negoCert(ba:ByteArray):void
     {
            var crypted_sign_length:int;
            crypted_sign_length = ba.readUnsignedInt();
            var crypted_sign:String;
            crypted_sign = ba.readUTFBytes(crypted_sign_length);
            var ok_length:int;
            ok_length = ba.readUnsignedInt();
            var ok:String;
            ok = ba.readUTFBytes(ok_length);
            server.negoCert(crypted_sign, ok);
      }


     private function loginCert(ba:ByteArray):void
     {
            var msg_length:int;
            msg_length = ba.readUnsignedInt();
            var msg:String;
            msg = ba.readUTFBytes(msg_length);
            var hash_key_length:int;
            hash_key_length = ba.readUnsignedInt();
            var hash_key:String;
            hash_key = ba.readUTFBytes(hash_key_length);
            server.loginCert(msg, hash_key);
      }


     private function loginFail(ba:ByteArray):void
     {
            server.loginFail();
      }


     private function scKeepAlive(ba:ByteArray):void
     {
            server.scKeepAlive();
      }


     private function scSendHelp(ba:ByteArray):void
     {
            var key_length:int;
            key_length = ba.readUnsignedInt();
            var key:String;
            key = ba.readUTFBytes(key_length);
            var avatar_name_length:int;
            avatar_name_length = ba.readUnsignedInt();
            var avatar_name:String;
            avatar_name = ba.readUTFBytes(avatar_name_length);
            var help_length:int;
            help_length = ba.readUnsignedInt();
            var help:String;
            help = ba.readUTFBytes(help_length);
            server.scSendHelp(key, avatar_name, help);
      }


    }
}
