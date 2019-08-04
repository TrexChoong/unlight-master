package net.command
{
    import flash.utils.ByteArray;
    import net.server.RaidrankServer;

    /**
     * サーバとのコマンドを管理するクラス
     * （自動生成される rake update_command）
     */

    public class RaidrankCommand extends Command
    {
       private var server:RaidrankServer;
       public function RaidrankCommand(s:RaidrankServer)
        {
            server =s;
            receiveCommands.push(negoCert);
            receiveCommands.push(loginCert);
            receiveCommands.push(loginFail);
            receiveCommands.push(scKeepAlive);
            receiveCommands.push(scUpdateRankingList);
            receiveCommands.push(scUpdateRank);
            receiveCommands.push(scProfoundResultRanking);

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

     public function csRequestRankingList(inv_id:int, offset:int, count:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(4);
            cmd.writeInt(inv_id);
            cmd.writeByte(offset);
            cmd.writeByte(count);

            return cmd;
        }

     public function csRequestRankInfo(inv_id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(5);
            cmd.writeInt(inv_id);

            return cmd;
        }

     public function csGetProfoundResultRanking(prf_id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(6);
            cmd.writeInt(prf_id);

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


     private function scUpdateRankingList(ba:ByteArray):void
     {
            ba.uncompress();
            var prf_id:int;
            prf_id = ba.readInt();
            var start:int;
            start = ba.readByte();
            var rank_list_length:int;
            rank_list_length = ba.readUnsignedInt();
            var rank_list:String;
            rank_list = ba.readUTFBytes(rank_list_length);
            server.scUpdateRankingList(prf_id, start, rank_list);
      }


     private function scUpdateRank(ba:ByteArray):void
     {
            var prf_id:int;
            prf_id = ba.readInt();
            var rank:int;
            rank = ba.readInt();
            var point:int;
            point = ba.readInt();
            server.scUpdateRank(prf_id, rank, point);
      }


     private function scProfoundResultRanking(ba:ByteArray):void
     {
            ba.uncompress();
            var result_ranking_length:int;
            result_ranking_length = ba.readUnsignedInt();
            var result_ranking:String;
            result_ranking = ba.readUTFBytes(result_ranking_length);
            server.scProfoundResultRanking(result_ranking);
      }


    }
}
