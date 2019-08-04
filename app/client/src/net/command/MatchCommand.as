package net.command
{
    import flash.utils.ByteArray;
    import net.server.MatchServer;

    /**
     * サーバとのコマンドを管理するクラス
     * （自動生成される rake update_command）
     */

    public class MatchCommand extends Command
    {
       private var server:MatchServer;
       public function MatchCommand(s:MatchServer)
        {
            server =s;
            receiveCommands.push(negoCert);
            receiveCommands.push(loginCert);
            receiveCommands.push(loginFail);
            receiveCommands.push(scChannelJoinSuccess);
            receiveCommands.push(scChannelExitSuccess);
            receiveCommands.push(scMatchingInfo);
            receiveCommands.push(scMatchingInfoUpdate);
            receiveCommands.push(scCreateRoomId);
            receiveCommands.push(scRoomExitSuccess);
            receiveCommands.push(scDeleteRoomId);
            receiveCommands.push(scErrorNo);
            receiveCommands.push(scMatchJoinOk);
            receiveCommands.push(scQuickmatchJoinOk);
            receiveCommands.push(scQuickmatchRegistOk);
            receiveCommands.push(scQuickmatchCancel);
            receiveCommands.push(scUpdateCount);
            receiveCommands.push(scKeepAlive);
            receiveCommands.push(scAchievementClear);
            receiveCommands.push(scAddNewAchievement);
            receiveCommands.push(scDeleteAchievement);
            receiveCommands.push(scUpdateAchievementInfo);
            receiveCommands.push(scRoomFriendInfo);

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

     public function csRequestMatchListInfo():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(4);

            return cmd;
        }

     public function csAddQuickmatchList(rule:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(5);
            cmd.writeByte(rule);

            return cmd;
        }

     public function csQuickmatchCancel():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(6);

            return cmd;
        }

     public function csCreateRoom(name:String, stage:int, rule:int, option:int, level:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(7);
            cmd.writeUTF(name);
            cmd.writeByte(stage);
            cmd.writeByte(rule);
            cmd.writeByte(option);
            cmd.writeByte(level);

            return cmd;
        }

     public function csRoomJoin(room_id:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(8);
            cmd.writeUTF(room_id);

            return cmd;
        }

     public function csRoomExit():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(9);

            return cmd;
        }

     public function csRoomDelete(room_id:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(10);
            cmd.writeUTF(room_id);

            return cmd;
        }

     public function csRequestMatchingInfo():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(11);

            return cmd;
        }

     public function csSelectGameSession(id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(12);
            cmd.writeInt(id);

            return cmd;
        }

     public function csMatchFinish():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(13);

            return cmd;
        }

     public function csAchievementClearCheck():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(14);

            return cmd;
        }

     public function csRoomFriendCheck(room_id:String, host_avatar_id:int, guest_pavatar_id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(15);
            cmd.writeUTF(room_id);
            cmd.writeInt(host_avatar_id);
            cmd.writeInt(guest_pavatar_id);

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


     private function scChannelJoinSuccess(ba:ByteArray):void
     {
            var channel_id:int;
            channel_id = ba.readInt();
            server.scChannelJoinSuccess(channel_id);
      }


     private function scChannelExitSuccess(ba:ByteArray):void
     {
            server.scChannelExitSuccess();
      }


     private function scMatchingInfo(ba:ByteArray):void
     {
            ba.uncompress();
            var info_length:int;
            info_length = ba.readUnsignedInt();
            var info:String;
            info = ba.readUTFBytes(info_length);
            server.scMatchingInfo(info);
      }


     private function scMatchingInfoUpdate(ba:ByteArray):void
     {
            var info_length:int;
            info_length = ba.readUnsignedInt();
            var info:String;
            info = ba.readUTFBytes(info_length);
            server.scMatchingInfoUpdate(info);
      }


     private function scCreateRoomId(ba:ByteArray):void
     {
            var id_length:int;
            id_length = ba.readUnsignedInt();
            var id:String;
            id = ba.readUTFBytes(id_length);
            server.scCreateRoomId(id);
      }


     private function scRoomExitSuccess(ba:ByteArray):void
     {
            server.scRoomExitSuccess();
      }


     private function scDeleteRoomId(ba:ByteArray):void
     {
            var id_length:int;
            id_length = ba.readUnsignedInt();
            var id:String;
            id = ba.readUTFBytes(id_length);
            server.scDeleteRoomId(id);
      }


     private function scErrorNo(ba:ByteArray):void
     {
            var error_type:int;
            error_type = ba.readInt();
            server.scErrorNo(error_type);
      }


     private function scMatchJoinOk(ba:ByteArray):void
     {
            var id_length:int;
            id_length = ba.readUnsignedInt();
            var id:String;
            id = ba.readUTFBytes(id_length);
            server.scMatchJoinOk(id);
      }


     private function scQuickmatchJoinOk(ba:ByteArray):void
     {
            var id_length:int;
            id_length = ba.readUnsignedInt();
            var id:String;
            id = ba.readUTFBytes(id_length);
            server.scQuickmatchJoinOk(id);
      }


     private function scQuickmatchRegistOk(ba:ByteArray):void
     {
            server.scQuickmatchRegistOk();
      }


     private function scQuickmatchCancel(ba:ByteArray):void
     {
            server.scQuickmatchCancel();
      }


     private function scUpdateCount(ba:ByteArray):void
     {
            var count:int;
            count = ba.readInt();
            server.scUpdateCount(count);
      }


     private function scKeepAlive(ba:ByteArray):void
     {
            server.scKeepAlive();
      }


     private function scAchievementClear(ba:ByteArray):void
     {
            var achi_id:int;
            achi_id = ba.readInt();
            var item_type:int;
            item_type = ba.readInt();
            var item_id:int;
            item_id = ba.readInt();
            var item_num:int;
            item_num = ba.readInt();
            var slot_type:int;
            slot_type = ba.readInt();
            server.scAchievementClear(achi_id, item_type, item_id, item_num, slot_type);
      }


     private function scAddNewAchievement(ba:ByteArray):void
     {
            var achi_id:int;
            achi_id = ba.readInt();
            server.scAddNewAchievement(achi_id);
      }


     private function scDeleteAchievement(ba:ByteArray):void
     {
            var achi_id:int;
            achi_id = ba.readInt();
            server.scDeleteAchievement(achi_id);
      }


     private function scUpdateAchievementInfo(ba:ByteArray):void
     {
            var achievements_length:int;
            achievements_length = ba.readUnsignedInt();
            var achievements:String;
            achievements = ba.readUTFBytes(achievements_length);
            var achievements_state_length:int;
            achievements_state_length = ba.readUnsignedInt();
            var achievements_state:String;
            achievements_state = ba.readUTFBytes(achievements_state_length);
            var achievements_progress_length:int;
            achievements_progress_length = ba.readUnsignedInt();
            var achievements_progress:String;
            achievements_progress = ba.readUTFBytes(achievements_progress_length);
            var achievements_end_at_length:int;
            achievements_end_at_length = ba.readUnsignedInt();
            var achievements_end_at:String;
            achievements_end_at = ba.readUTFBytes(achievements_end_at_length);
            var achievements_code_length:int;
            achievements_code_length = ba.readUnsignedInt();
            var achievements_code:String;
            achievements_code = ba.readUTFBytes(achievements_code_length);
            server.scUpdateAchievementInfo(achievements, achievements_state, achievements_progress, achievements_end_at, achievements_code);
      }


     private function scRoomFriendInfo(ba:ByteArray):void
     {
            var room_id_length:int;
            room_id_length = ba.readUnsignedInt();
            var room_id:String;
            room_id = ba.readUTFBytes(room_id_length);
            var host_is_friend:Boolean;
            host_is_friend = ba.readBoolean();
            var guest_is_friend:Boolean;
            guest_is_friend = ba.readBoolean();
            server.scRoomFriendInfo(room_id, host_is_friend, guest_is_friend);
      }


    }
}
