package net.command
{
    import flash.utils.ByteArray;
    import net.server.RaidchatServer;

    /**
     * サーバとのコマンドを管理するクラス
     * （自動生成される rake update_command）
     */

    public class RaidchatCommand extends Command
    {
       private var server:RaidchatServer;
       public function RaidchatCommand(s:RaidchatServer)
        {
            server =s;
            receiveCommands.push(negoCert);
            receiveCommands.push(loginCert);
            receiveCommands.push(loginFail);
            receiveCommands.push(scKeepAlive);
            receiveCommands.push(scUpdateComment);
            receiveCommands.push(scSendBossDamage);
            receiveCommands.push(scUpdateBossHp);

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

     public function csSetComment(prf_id:int, comment:String, last_id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(4);
            cmd.writeInt(prf_id);
            cmd.writeUTF(comment);
            cmd.writeInt(last_id);

            return cmd;
        }

     public function csRequestComment(prf_id:int, last_id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(5);
            cmd.writeInt(prf_id);
            cmd.writeInt(last_id);

            return cmd;
        }

     public function csUpdateBossHp(prf_id:int, now_dmg:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(6);
            cmd.writeInt(prf_id);
            cmd.writeInt(now_dmg);

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


     private function scUpdateComment(ba:ByteArray):void
     {
            ba.uncompress();
            var prf_id:int;
            prf_id = ba.readInt();
            var comment_length:int;
            comment_length = ba.readUnsignedInt();
            var comment:String;
            comment = ba.readUTFBytes(comment_length);
            var last_id:int;
            last_id = ba.readInt();
            server.scUpdateComment(prf_id, comment, last_id);
      }


     private function scSendBossDamage(ba:ByteArray):void
     {
            var prf_id:int;
            prf_id = ba.readInt();
            var damage:int;
            damage = ba.readInt();
            var str_data_length:int;
            str_data_length = ba.readUnsignedInt();
            var str_data:String;
            str_data = ba.readUTFBytes(str_data_length);
            var state:int;
            state = ba.readInt();
            var state_update:Boolean;
            state_update = ba.readBoolean();
            server.scSendBossDamage(prf_id, damage, str_data, state, state_update);
      }


     private function scUpdateBossHp(ba:ByteArray):void
     {
            var prf_id:int;
            prf_id = ba.readInt();
            var damage:int;
            damage = ba.readInt();
            server.scUpdateBossHp(prf_id, damage);
      }


    }
}
