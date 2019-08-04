package net.command
{
    import flash.utils.ByteArray;
    import net.server.RaiddataServer;

    /**
     * サーバとのコマンドを管理するクラス
     * （自動生成される rake update_command）
     */

    public class RaiddataCommand extends Command
    {
       private var server:RaiddataServer;
       public function RaiddataCommand(s:RaiddataServer)
        {
            server =s;
            receiveCommands.push(negoCert);
            receiveCommands.push(loginCert);
            receiveCommands.push(loginFail);
            receiveCommands.push(scKeepAlive);
            receiveCommands.push(scErrorNo);
            receiveCommands.push(scResendProfoundInventory);
            receiveCommands.push(scResendProfoundInventoryFinish);
            receiveCommands.push(scUpdateCurrentDeckIndex);
            receiveCommands.push(scUpdateRankingList);
            receiveCommands.push(scUpdateRank);
            receiveCommands.push(scSendBossDamage);
            receiveCommands.push(scUpdateBossHp);
            receiveCommands.push(scUseItem);
            receiveCommands.push(scAddNotice);
            receiveCommands.push(scAchievementClear);
            receiveCommands.push(scAddNewAchievement);
            receiveCommands.push(scDeleteAchievement);
            receiveCommands.push(scUpdateAchievementInfo);
            receiveCommands.push(scGetProfoundHash);

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

     public function csAvatarUseItem(inv_id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(4);
            cmd.writeInt(inv_id);

            return cmd;
        }

     public function csRequestRankingList(inv_id:int, offset:int, count:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(5);
            cmd.writeInt(inv_id);
            cmd.writeByte(offset);
            cmd.writeByte(count);

            return cmd;
        }

     public function csRequestRankInfo(inv_id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(6);
            cmd.writeInt(inv_id);

            return cmd;
        }

     public function csRequestNotice():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(7);

            return cmd;
        }

     public function csRequestUpdateInventory(inv_id_list:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(8);
            cmd.writeUTF(inv_id_list);

            return cmd;
        }

     public function csGiveUpProfound(inv_id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(9);
            cmd.writeInt(inv_id);

            return cmd;
        }

     public function csCheckVanishProfound(inv_id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(10);
            cmd.writeInt(inv_id);

            return cmd;
        }

     public function csCheckProfoundReward():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(11);

            return cmd;
        }

     public function csUpdateBossHp(prf_id:int, now_dmg:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(12);
            cmd.writeInt(prf_id);
            cmd.writeInt(now_dmg);

            return cmd;
        }

     public function csUpdateCurrentDeckIndex(index:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(13);
            cmd.writeInt(index);

            return cmd;
        }

     public function csGetProfound(hash:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(14);
            cmd.writeUTF(hash);

            return cmd;
        }

     public function csRequestProfoundHash(id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(15);
            cmd.writeInt(id);

            return cmd;
        }

     public function csChangeProfoundConfig(id:int, type:int, set_defeat_reward:Boolean):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(16);
            cmd.writeInt(id);
            cmd.writeInt(type);
            cmd.writeBoolean(set_defeat_reward);

            return cmd;
        }

     public function csSendProfoundFriend(prf_id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(17);
            cmd.writeInt(prf_id);

            return cmd;
        }

     public function csProfoundNoticeClear(num:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(18);
            cmd.writeInt(num);

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


     private function scErrorNo(ba:ByteArray):void
     {
            var error_type:int;
            error_type = ba.readInt();
            server.scErrorNo(error_type);
      }


     private function scResendProfoundInventory(ba:ByteArray):void
     {
            var data_id:int;
            data_id = ba.readInt();
            var hash_length:int;
            hash_length = ba.readUnsignedInt();
            var hash:String;
            hash = ba.readUTFBytes(hash_length);
            var close_at_length:int;
            close_at_length = ba.readUnsignedInt();
            var close_at:String;
            close_at = ba.readUTFBytes(close_at_length);
            var created_at_length:int;
            created_at_length = ba.readUnsignedInt();
            var created_at:String;
            created_at = ba.readUTFBytes(created_at_length);
            var state:int;
            state = ba.readInt();
            var map_id:int;
            map_id = ba.readInt();
            var pos_idx:int;
            pos_idx = ba.readInt();
            var copy_type:int;
            copy_type = ba.readInt();
            var set_defeat_reward:Boolean;
            set_defeat_reward = ba.readBoolean();
            var now_damage:int;
            now_damage = ba.readInt();
            var finder_id:int;
            finder_id = ba.readInt();
            var finder_name_length:int;
            finder_name_length = ba.readUnsignedInt();
            var finder_name:String;
            finder_name = ba.readUTFBytes(finder_name_length);
            var inv_id:int;
            inv_id = ba.readInt();
            var profound_id:int;
            profound_id = ba.readInt();
            var deck_id:int;
            deck_id = ba.readInt();
            var chara_card_dmg_1:int;
            chara_card_dmg_1 = ba.readInt();
            var chara_card_dmg_2:int;
            chara_card_dmg_2 = ba.readInt();
            var chara_card_dmg_3:int;
            chara_card_dmg_3 = ba.readInt();
            var damage_count:int;
            damage_count = ba.readInt();
            var inv_state:int;
            inv_state = ba.readInt();
            var deck_status:int;
            deck_status = ba.readInt();
            server.scResendProfoundInventory(data_id, hash, close_at, created_at, state, map_id, pos_idx, copy_type, set_defeat_reward, now_damage, finder_id, finder_name, inv_id, profound_id, deck_id, chara_card_dmg_1, chara_card_dmg_2, chara_card_dmg_3, damage_count, inv_state, deck_status);
      }


     private function scResendProfoundInventoryFinish(ba:ByteArray):void
     {
            server.scResendProfoundInventoryFinish();
      }


     private function scUpdateCurrentDeckIndex(ba:ByteArray):void
     {
            var index:int;
            index = ba.readInt();
            server.scUpdateCurrentDeckIndex(index);
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


     private function scUseItem(ba:ByteArray):void
     {
            var inv_id:int;
            inv_id = ba.readInt();
            server.scUseItem(inv_id);
      }


     private function scAddNotice(ba:ByteArray):void
     {
            var body_length:int;
            body_length = ba.readUnsignedInt();
            var body:String;
            body = ba.readUTFBytes(body_length);
            server.scAddNotice(body);
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


     private function scGetProfoundHash(ba:ByteArray):void
     {
            var prf_id:int;
            prf_id = ba.readInt();
            var hash_length:int;
            hash_length = ba.readUnsignedInt();
            var hash:String;
            hash = ba.readUTFBytes(hash_length);
            var copy_type:int;
            copy_type = ba.readInt();
            var set_defeat_reward:Boolean;
            set_defeat_reward = ba.readBoolean();
            server.scGetProfoundHash(prf_id, hash, copy_type, set_defeat_reward);
      }


    }
}
