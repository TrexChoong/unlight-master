package net.command
{
    import flash.utils.ByteArray;
    import net.server.AuthServer;

    /**
     * サーバとのコマンドを管理するクラス
     * （自動生成される rake update_command）
     */

    public class AuthCommand extends Command
    {
       private var server:AuthServer;
       public function AuthCommand(s:AuthServer)
        {
            server =s;
            receiveCommands.push(registResult);
            receiveCommands.push(authReturn);
            receiveCommands.push(authCert);
            receiveCommands.push(authFail);
            receiveCommands.push(authUserLimit);
            receiveCommands.push(lobbyInfo);
            receiveCommands.push(scOpenSocialNotRegist);
            receiveCommands.push(scKeepAlive);
            receiveCommands.push(scErrorNo);
            receiveCommands.push(scRequestReregist);

        }
// 送信コマンド

     public function register(name:String, email:String, salt:String, verifire:String, server_type:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(0);
            cmd.writeUTF(name);
            cmd.writeUTF(email);
            cmd.writeUTF(salt);
            cmd.writeUTF(verifire);
            cmd.writeInt(server_type);

            return cmd;
        }

     public function authStart(name:String, client_pub_key:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(1);
            cmd.writeUTF(name);
            cmd.writeUTF(client_pub_key);

            return cmd;
        }

     public function authGetMatcher(matcher:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(2);
            cmd.writeUTF(matcher);

            return cmd;
        }

     public function logout():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(3);

            return cmd;
        }

     public function csOpenSocialAuth(user_id:String, client_pub_key:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(4);
            cmd.writeUTF(user_id);
            cmd.writeUTF(client_pub_key);

            return cmd;
        }

     public function csOpenSocialRegister(use_id:String, salt:String, verifire:String, server_type:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(5);
            cmd.writeUTF(use_id);
            cmd.writeUTF(salt);
            cmd.writeUTF(verifire);
            cmd.writeInt(server_type);

            return cmd;
        }

     public function csKeepAlive():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(6);

            return cmd;
        }

     public function csReregister(use_id:String, salt:String, verifire:String, server_type:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(7);
            cmd.writeUTF(use_id);
            cmd.writeUTF(salt);
            cmd.writeUTF(verifire);
            cmd.writeInt(server_type);

            return cmd;
        }

     public function csUpdateInvitedUser(users:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(8);
            cmd.writeUTF(users);

            return cmd;
        }

     public function csUpdateTutoPlay(type:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(9);
            cmd.writeByte(type);

            return cmd;
        }

// 受信コマンド

     private function registResult(ba:ByteArray):void
     {
            var result:int;
            result = ba.readInt();
            server.registResult(result);
      }


     private function authReturn(ba:ByteArray):void
     {
            var salt_length:int;
            salt_length = ba.readUnsignedInt();
            var salt:String;
            salt = ba.readUTFBytes(salt_length);
            var server_pub_key_length:int;
            server_pub_key_length = ba.readUnsignedInt();
            var server_pub_key:String;
            server_pub_key = ba.readUTFBytes(server_pub_key_length);
            server.authReturn(salt, server_pub_key);
      }


     private function authCert(ba:ByteArray):void
     {
            var cert_length:int;
            cert_length = ba.readUnsignedInt();
            var cert:String;
            cert = ba.readUTFBytes(cert_length);
            var uid:int;
            uid = ba.readInt();
            server.authCert(cert, uid);
      }


     private function authFail(ba:ByteArray):void
     {
            server.authFail();
      }


     private function authUserLimit(ba:ByteArray):void
     {
            server.authUserLimit();
      }


     private function lobbyInfo(ba:ByteArray):void
     {
            var ip_length:int;
            ip_length = ba.readUnsignedInt();
            var ip:String;
            ip = ba.readUTFBytes(ip_length);
            var port:int;
            port = ba.readInt();
            server.lobbyInfo(ip, port);
      }


     private function scOpenSocialNotRegist(ba:ByteArray):void
     {
            server.scOpenSocialNotRegist();
      }


     private function scKeepAlive(ba:ByteArray):void
     {
            server.scKeepAlive();
      }


     private function scErrorNo(ba:ByteArray):void
     {
            var error_type:int;
            error_type = ba.readInt();
            server.scErrorNo(error_type);
      }


     private function scRequestReregist(ba:ByteArray):void
     {
            server.scRequestReregist();
      }


    }
}
