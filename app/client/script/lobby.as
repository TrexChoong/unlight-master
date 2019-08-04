package net.command
{
    import flash.utils.ByteArray;
    import model.server.AuthServer;

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
            receiveCommands.push(sendAvaterinfo);
            receiveCommands.push(sendFriendlist);

        }


     public function login(name,:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(#{i});
            cmd.writeShort(name,.length);
            cmd.writeUTFBytes(name,);

            return cmd;
        }

     public function logout():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(#{i});

            return cmd;
        }

     public function requestAvaterinfo():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(#{i});

            return cmd;
        }

     public function setAvaterinfo():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(#{i});

            return cmd;
        }

     public function requestAvaterinfo():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(#{i});

            return cmd;
        }

     public function requestAvaterinfo():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(#{i});

            return cmd;
        }

     public function requestAvaterinfo():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(#{i});

            return cmd;
        }

// 受信コマンド

          private function sendAvaterinfo(ba:ByteArray):void
          {
            server.sendAvaterinfo();
          }


          private function sendFriendlist(ba:ByteArray):void
          {
            server.sendFriendlist();
          }


    }
}
