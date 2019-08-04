package net.command
{
    import flash.utils.ByteArray;
    import net.server.ChatServer;

    /**
     * サーバとのコマンドを管理するクラス
     * （自動生成される rake update_command）
     */

    public class ChatCommand extends Command
    {
       private var server:ChatServer;
       public function ChatCommand(s:ChatServer)
        {
            server =s;
            receiveCommands.push(negoCert);
            receiveCommands.push(loginCert);
            receiveCommands.push(loginFail);
            receiveCommands.push(scSendMessage);
            receiveCommands.push(scSendDuelMessage);
            receiveCommands.push(scSendChannelMessage);
            receiveCommands.push(scSendAudienceMessage);
            receiveCommands.push(scKeepAlive);

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

     public function csMessage(msg:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(4);
            cmd.writeUTF(msg);

            return cmd;
        }

     public function csMessageRoom(msg:String, room:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(5);
            cmd.writeUTF(msg);
            cmd.writeInt(room);

            return cmd;
        }

     public function csMessageDuel(msg:String, room:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(6);
            cmd.writeUTF(msg);
            cmd.writeInt(room);

            return cmd;
        }

     public function csMessageChannel(msg:String, channel:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(7);
            cmd.writeUTF(msg);
            cmd.writeInt(channel);

            return cmd;
        }

     public function csMessageAudience(msg:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(8);
            cmd.writeUTF(msg);

            return cmd;
        }

     public function csChannelIn(channel:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(9);
            cmd.writeInt(channel);

            return cmd;
        }

     public function csChannelOut(channel:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(10);
            cmd.writeInt(channel);

            return cmd;
        }

     public function csAudienceChannelIn(room_id:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(11);
            cmd.writeUTF(room_id);

            return cmd;
        }

     public function csAudienceChannelOut():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(12);

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


     private function scSendMessage(ba:ByteArray):void
     {
            var msg_length:int;
            msg_length = ba.readUnsignedInt();
            var msg:String;
            msg = ba.readUTFBytes(msg_length);
            var type:int;
            type = ba.readInt();
            server.scSendMessage(msg, type);
      }


     private function scSendDuelMessage(ba:ByteArray):void
     {
            var avatar_id:int;
            avatar_id = ba.readInt();
            var msg_length:int;
            msg_length = ba.readUnsignedInt();
            var msg:String;
            msg = ba.readUTFBytes(msg_length);
            server.scSendDuelMessage(avatar_id, msg);
      }


     private function scSendChannelMessage(ba:ByteArray):void
     {
            var channel_id:int;
            channel_id = ba.readInt();
            var msg_length:int;
            msg_length = ba.readUnsignedInt();
            var msg:String;
            msg = ba.readUTFBytes(msg_length);
            server.scSendChannelMessage(channel_id, msg);
      }


     private function scSendAudienceMessage(ba:ByteArray):void
     {
            var channel_id:int;
            channel_id = ba.readInt();
            var msg_length:int;
            msg_length = ba.readUnsignedInt();
            var msg:String;
            msg = ba.readUTFBytes(msg_length);
            server.scSendAudienceMessage(channel_id, msg);
      }


     private function scKeepAlive(ba:ByteArray):void
     {
            server.scKeepAlive();
      }


    }
}
