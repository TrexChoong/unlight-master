package net.command
{
    import flash.utils.ByteArray;
    import net.server.DataServer;

    /**
     * サーバとのコマンドを管理するクラス
     * （自動生成される rake update_command）
     */

    public class DataCommand extends Command
    {
       private var server:DataServer;
       public function DataCommand(s:DataServer)
        {
            server =s;
            receiveCommands.push(negoCert);
            receiveCommands.push(loginCert);
            receiveCommands.push(loginFail);
            receiveCommands.push(scKeepAlive);
            receiveCommands.push(scErrorNo);
            receiveCommands.push(scDataVersionInfo);
            receiveCommands.push(scAvatarInfo);
            receiveCommands.push(scAchievementInfo);
            receiveCommands.push(scRegistInfo);
            receiveCommands.push(scOtherAvatarInfo);
            receiveCommands.push(scStoryInfo);
            receiveCommands.push(scFriendListInfo);
            receiveCommands.push(scFriendList);
            receiveCommands.push(scExistPlayerInfo);
            receiveCommands.push(scChannelListInfo);
            receiveCommands.push(scUpdateRank);
            receiveCommands.push(scUpdateTotalDuelRankingList);
            receiveCommands.push(scUpdateWeeklyDuelRankingList);
            receiveCommands.push(scUpdateTotalQuestRankingList);
            receiveCommands.push(scUpdateWeeklyQuestRankingList);
            receiveCommands.push(scUpdateTotalCharaVoteRankingList);
            receiveCommands.push(scUpdateTotalEventRankingList);
            receiveCommands.push(scAchievementClear);
            receiveCommands.push(scAddNewAchievement);
            receiveCommands.push(scDeleteAchievement);
            receiveCommands.push(scUpdateAchievementInfo);
            receiveCommands.push(scResultAvatarsList);

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

     public function csCreateAvatarSuccess():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(4);

            return cmd;
        }

     public function csRequestOtherAvatarInfo(id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(5);
            cmd.writeInt(id);

            return cmd;
        }

     public function csRequestStoryInfo(ok:String, id:int, crypted_sign:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(6);
            cmd.writeUTF(ok);
            cmd.writeInt(id);
            cmd.writeUTF(crypted_sign);

            return cmd;
        }

     public function csRequestFriendsInfo():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(7);

            return cmd;
        }

     public function csRequestFriendList(type:int, offset:int, count:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(8);
            cmd.writeInt(type);
            cmd.writeInt(offset);
            cmd.writeInt(count);

            return cmd;
        }

     public function csFriendInvite(uid:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(9);
            cmd.writeUTF(uid);

            return cmd;
        }

     public function csSendComebackFriend(uid:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(10);
            cmd.writeUTF(uid);

            return cmd;
        }

     public function csCheckExistPlayer(uid:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(11);
            cmd.writeUTF(uid);

            return cmd;
        }

     public function csRequestChannelListInfo():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(12);

            return cmd;
        }

     public function csRequestRankInfo(kind:int, server_type:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(13);
            cmd.writeByte(kind);
            cmd.writeInt(server_type);

            return cmd;
        }

     public function csRequestRankingList(kind:int, offset:int, count:int, server_type:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(14);
            cmd.writeByte(kind);
            cmd.writeByte(offset);
            cmd.writeByte(count);
            cmd.writeInt(server_type);

            return cmd;
        }

     public function csFindAvatar(avatar_name:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(15);
            cmd.writeUTF(avatar_name);

            return cmd;
        }

     public function csGetProfound(hash:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(16);
            cmd.writeUTF(hash);

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


     private function scDataVersionInfo(ba:ByteArray):void
     {
            var action_card:int;
            action_card = ba.readInt();
            var chara_card:int;
            chara_card = ba.readInt();
            var feat:int;
            feat = ba.readInt();
            var dialogue:int;
            dialogue = ba.readInt();
            var story:int;
            story = ba.readInt();
            var quest_log:int;
            quest_log = ba.readInt();
            var avatar_item:int;
            avatar_item = ba.readInt();
            var avatar_part:int;
            avatar_part = ba.readInt();
            var event_card:int;
            event_card = ba.readInt();
            var weapon_card:int;
            weapon_card = ba.readInt();
            var equip_card:int;
            equip_card = ba.readInt();
            var quest:int;
            quest = ba.readInt();
            var quest_map:int;
            quest_map = ba.readInt();
            var quest_land:int;
            quest_land = ba.readInt();
            var growth_tree:int;
            growth_tree = ba.readInt();
            server.scDataVersionInfo(action_card, chara_card, feat, dialogue, story, quest_log, avatar_item, avatar_part, event_card, weapon_card, equip_card, quest, quest_map, quest_land, growth_tree);
      }


     private function scAvatarInfo(ba:ByteArray):void
     {
            ba.uncompress();
            var id:int;
            id = ba.readInt();
            var name_length:int;
            name_length = ba.readUnsignedInt();
            var name:String;
            name = ba.readUTFBytes(name_length);
            var gems:int;
            gems = ba.readInt();
            var exp:int;
            exp = ba.readInt();
            var level:int;
            level = ba.readInt();
            var energy:int;
            energy = ba.readInt();
            var energy_max:int;
            energy_max = ba.readInt();
            var recov_inter:int;
            recov_inter = ba.readInt();
            var remain_time:int;
            remain_time = ba.readInt();
            var point:int;
            point = ba.readInt();
            var win:int;
            win = ba.readInt();
            var lose:int;
            lose = ba.readInt();
            var draw:int;
            draw = ba.readInt();
            var part_num:int;
            part_num = ba.readInt();
            var part_inv_id_length:int;
            part_inv_id_length = ba.readUnsignedInt();
            var part_inv_id:String;
            part_inv_id = ba.readUTFBytes(part_inv_id_length);
            var part_array_length:int;
            part_array_length = ba.readUnsignedInt();
            var part_array:String;
            part_array = ba.readUTFBytes(part_array_length);
            var part_used_length:int;
            part_used_length = ba.readUnsignedInt();
            var part_used:String;
            part_used = ba.readUTFBytes(part_used_length);
            var part_end_at_length:int;
            part_end_at_length = ba.readUnsignedInt();
            var part_end_at:String;
            part_end_at = ba.readUTFBytes(part_end_at_length);
            var item_num:int;
            item_num = ba.readInt();
            var item_inv_id_length:int;
            item_inv_id_length = ba.readUnsignedInt();
            var item_inv_id:String;
            item_inv_id = ba.readUTFBytes(item_inv_id_length);
            var item_array_length:int;
            item_array_length = ba.readUnsignedInt();
            var item_array:String;
            item_array = ba.readUTFBytes(item_array_length);
            var item_state_array_length:int;
            item_state_array_length = ba.readUnsignedInt();
            var item_state_array:String;
            item_state_array = ba.readUTFBytes(item_state_array_length);
            var deck_num:int;
            deck_num = ba.readInt();
            var deck_name_length:int;
            deck_name_length = ba.readUnsignedInt();
            var deck_name:String;
            deck_name = ba.readUTFBytes(deck_name_length);
            var deck_kind_length:int;
            deck_kind_length = ba.readUnsignedInt();
            var deck_kind:String;
            deck_kind = ba.readUTFBytes(deck_kind_length);
            var deck_level_length:int;
            deck_level_length = ba.readUnsignedInt();
            var deck_level:String;
            deck_level = ba.readUTFBytes(deck_level_length);
            var deck_exp_length:int;
            deck_exp_length = ba.readUnsignedInt();
            var deck_exp:String;
            deck_exp = ba.readUTFBytes(deck_exp_length);
            var deck_status_length:int;
            deck_status_length = ba.readUnsignedInt();
            var deck_status:String;
            deck_status = ba.readUTFBytes(deck_status_length);
            var deck_cost_length:int;
            deck_cost_length = ba.readUnsignedInt();
            var deck_cost:String;
            deck_cost = ba.readUTFBytes(deck_cost_length);
            var deck_max_cost_length:int;
            deck_max_cost_length = ba.readUnsignedInt();
            var deck_max_cost:String;
            deck_max_cost = ba.readUTFBytes(deck_max_cost_length);
            var card_num:int;
            card_num = ba.readInt();
            var card_inv_id_length:int;
            card_inv_id_length = ba.readUnsignedInt();
            var card_inv_id:String;
            card_inv_id = ba.readUTFBytes(card_inv_id_length);
            var card_array_length:int;
            card_array_length = ba.readUnsignedInt();
            var card_array:String;
            card_array = ba.readUTFBytes(card_array_length);
            var deck_index_length:int;
            deck_index_length = ba.readUnsignedInt();
            var deck_index:String;
            deck_index = ba.readUTFBytes(deck_index_length);
            var deck_position_length:int;
            deck_position_length = ba.readUnsignedInt();
            var deck_position:String;
            deck_position = ba.readUTFBytes(deck_position_length);
            var slots_num:int;
            slots_num = ba.readInt();
            var slot_inv_id_length:int;
            slot_inv_id_length = ba.readUnsignedInt();
            var slot_inv_id:String;
            slot_inv_id = ba.readUTFBytes(slot_inv_id_length);
            var slot_array_length:int;
            slot_array_length = ba.readUnsignedInt();
            var slot_array:String;
            slot_array = ba.readUTFBytes(slot_array_length);
            var slot_type_length:int;
            slot_type_length = ba.readUnsignedInt();
            var slot_type:String;
            slot_type = ba.readUTFBytes(slot_type_length);
            var slot_combined_length:int;
            slot_combined_length = ba.readUnsignedInt();
            var slot_combined:String;
            slot_combined = ba.readUTFBytes(slot_combined_length);
            var slot_combine_data_length:int;
            slot_combine_data_length = ba.readUnsignedInt();
            var slot_combine_data:String;
            slot_combine_data = ba.readUTFBytes(slot_combine_data_length);
            var slot_deck_index_length:int;
            slot_deck_index_length = ba.readUnsignedInt();
            var slot_deck_index:String;
            slot_deck_index = ba.readUTFBytes(slot_deck_index_length);
            var slot_deck_position_length:int;
            slot_deck_position_length = ba.readUnsignedInt();
            var slot_deck_position:String;
            slot_deck_position = ba.readUTFBytes(slot_deck_position_length);
            var slot_card_position_length:int;
            slot_card_position_length = ba.readUnsignedInt();
            var slot_card_position:String;
            slot_card_position = ba.readUTFBytes(slot_card_position_length);
            var quest_max:int;
            quest_max = ba.readByte();
            var quest_num:int;
            quest_num = ba.readByte();
            var quest_inv_id_length:int;
            quest_inv_id_length = ba.readUnsignedInt();
            var quest_inv_id:String;
            quest_inv_id = ba.readUTFBytes(quest_inv_id_length);
            var quest_array_length:int;
            quest_array_length = ba.readUnsignedInt();
            var quest_array:String;
            quest_array = ba.readUTFBytes(quest_array_length);
            var quest_status_length:int;
            quest_status_length = ba.readUnsignedInt();
            var quest_status:String;
            quest_status = ba.readUTFBytes(quest_status_length);
            var quest_find_time_length:int;
            quest_find_time_length = ba.readUnsignedInt();
            var quest_find_time:String;
            quest_find_time = ba.readUTFBytes(quest_find_time_length);
            var quest_ba_name_length:int;
            quest_ba_name_length = ba.readUnsignedInt();
            var quest_ba_name:String;
            quest_ba_name = ba.readUTFBytes(quest_ba_name_length);
            var quest_flag:int;
            quest_flag = ba.readInt();
            var quest_clear_num:int;
            quest_clear_num = ba.readInt();
            var friend_max:int;
            friend_max = ba.readInt();
            var part_max:int;
            part_max = ba.readInt();
            var free_duel_count:int;
            free_duel_count = ba.readByte();
            var exp_pow:int;
            exp_pow = ba.readInt();
            var gem_pow:int;
            gem_pow = ba.readInt();
            var quest_find_pow:int;
            quest_find_pow = ba.readInt();
            var current_deck:int;
            current_deck = ba.readByte();
            var sale_type:int;
            sale_type = ba.readByte();
            var sale_limit_rest_time:int;
            sale_limit_rest_time = ba.readInt();
            var favorite_chara_id:int;
            favorite_chara_id = ba.readInt();
            var floor_count:int;
            floor_count = ba.readInt();
            var event_quest_flag:int;
            event_quest_flag = ba.readInt();
            var event_quest_clear_num:int;
            event_quest_clear_num = ba.readInt();
            var tutorial_quest_flag:int;
            tutorial_quest_flag = ba.readInt();
            var tutorial_quest_clear_num:int;
            tutorial_quest_clear_num = ba.readInt();
            var chara_vote_quest_flag:int;
            chara_vote_quest_flag = ba.readInt();
            var chara_vote_quest_clear_num:int;
            chara_vote_quest_clear_num = ba.readInt();
            server.scAvatarInfo(id, name, gems, exp, level, energy, energy_max, recov_inter, remain_time, point, win, lose, draw, part_num, part_inv_id, part_array, part_used, part_end_at, item_num, item_inv_id, item_array, item_state_array, deck_num, deck_name, deck_kind, deck_level, deck_exp, deck_status, deck_cost, deck_max_cost, card_num, card_inv_id, card_array, deck_index, deck_position, slots_num, slot_inv_id, slot_array, slot_type, slot_combined, slot_combine_data, slot_deck_index, slot_deck_position, slot_card_position, quest_max, quest_num, quest_inv_id, quest_array, quest_status, quest_find_time, quest_ba_name, quest_flag, quest_clear_num, friend_max, part_max, free_duel_count, exp_pow, gem_pow, quest_find_pow, current_deck, sale_type, sale_limit_rest_time, favorite_chara_id, floor_count, event_quest_flag, event_quest_clear_num, tutorial_quest_flag, tutorial_quest_clear_num, chara_vote_quest_flag, chara_vote_quest_clear_num);
      }


     private function scAchievementInfo(ba:ByteArray):void
     {
            ba.uncompress();
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
            server.scAchievementInfo(achievements, achievements_state, achievements_progress, achievements_end_at, achievements_code);
      }


     private function scRegistInfo(ba:ByteArray):void
     {
            var parts_length:int;
            parts_length = ba.readUnsignedInt();
            var parts:String;
            parts = ba.readUTFBytes(parts_length);
            var cards_length:int;
            cards_length = ba.readUnsignedInt();
            var cards:String;
            cards = ba.readUTFBytes(cards_length);
            server.scRegistInfo(parts, cards);
      }


     private function scOtherAvatarInfo(ba:ByteArray):void
     {
            var id:int;
            id = ba.readInt();
            var name_length:int;
            name_length = ba.readUnsignedInt();
            var name:String;
            name = ba.readUTFBytes(name_length);
            var level:int;
            level = ba.readInt();
            var setted_part_array_length:int;
            setted_part_array_length = ba.readUnsignedInt();
            var setted_part_array:String;
            setted_part_array = ba.readUTFBytes(setted_part_array_length);
            var bp:int;
            bp = ba.readInt();
            server.scOtherAvatarInfo(id, name, level, setted_part_array, bp);
      }


     private function scStoryInfo(ba:ByteArray):void
     {
            ba.uncompress();
            var id:int;
            id = ba.readInt();
            var book_type:int;
            book_type = ba.readInt();
            var title_length:int;
            title_length = ba.readUnsignedInt();
            var title:String;
            title = ba.readUTFBytes(title_length);
            var content_length:int;
            content_length = ba.readUnsignedInt();
            var content:String;
            content = ba.readUTFBytes(content_length);
            var image_length:int;
            image_length = ba.readUnsignedInt();
            var image:String;
            image = ba.readUTFBytes(image_length);
            var age_no_length:int;
            age_no_length = ba.readUnsignedInt();
            var age_no:String;
            age_no = ba.readUTFBytes(age_no_length);
            var version:int;
            version = ba.readInt();
            server.scStoryInfo(id, book_type, title, content, image, age_no, version);
      }


     private function scFriendListInfo(ba:ByteArray):void
     {
            var id_length:int;
            id_length = ba.readUnsignedInt();
            var id:String;
            id = ba.readUTFBytes(id_length);
            var avatar_ids_length:int;
            avatar_ids_length = ba.readUnsignedInt();
            var avatar_ids:String;
            avatar_ids = ba.readUTFBytes(avatar_ids_length);
            var status_length:int;
            status_length = ba.readUnsignedInt();
            var status:String;
            status = ba.readUTFBytes(status_length);
            var sns_ids_length:int;
            sns_ids_length = ba.readUnsignedInt();
            var sns_ids:String;
            sns_ids = ba.readUTFBytes(sns_ids_length);
            server.scFriendListInfo(id, avatar_ids, status, sns_ids);
      }


     private function scFriendList(ba:ByteArray):void
     {
            var id_length:int;
            id_length = ba.readUnsignedInt();
            var id:String;
            id = ba.readUTFBytes(id_length);
            var avatar_ids_length:int;
            avatar_ids_length = ba.readUnsignedInt();
            var avatar_ids:String;
            avatar_ids = ba.readUTFBytes(avatar_ids_length);
            var status_length:int;
            status_length = ba.readUnsignedInt();
            var status:String;
            status = ba.readUTFBytes(status_length);
            var sns_ids_length:int;
            sns_ids_length = ba.readUnsignedInt();
            var sns_ids:String;
            sns_ids = ba.readUTFBytes(sns_ids_length);
            var type:int;
            type = ba.readInt();
            var offset:int;
            offset = ba.readInt();
            var fl_num:int;
            fl_num = ba.readInt();
            var bl_num:int;
            bl_num = ba.readInt();
            var rq_num:int;
            rq_num = ba.readInt();
            server.scFriendList(id, avatar_ids, status, sns_ids, type, offset, fl_num, bl_num, rq_num);
      }


     private function scExistPlayerInfo(ba:ByteArray):void
     {
            var uid_length:int;
            uid_length = ba.readUnsignedInt();
            var uid:String;
            uid = ba.readUTFBytes(uid_length);
            var id:int;
            id = ba.readInt();
            var av_id:int;
            av_id = ba.readInt();
            server.scExistPlayerInfo(uid, id, av_id);
      }


     private function scChannelListInfo(ba:ByteArray):void
     {
            ba.uncompress();
            var id_length:int;
            id_length = ba.readUnsignedInt();
            var id:String;
            id = ba.readUTFBytes(id_length);
            var name_length:int;
            name_length = ba.readUnsignedInt();
            var name:String;
            name = ba.readUTFBytes(name_length);
            var rule_length:int;
            rule_length = ba.readUnsignedInt();
            var rule:String;
            rule = ba.readUTFBytes(rule_length);
            var max_length:int;
            max_length = ba.readUnsignedInt();
            var max:String;
            max = ba.readUTFBytes(max_length);
            var host_length:int;
            host_length = ba.readUnsignedInt();
            var host:String;
            host = ba.readUTFBytes(host_length);
            var port_length:int;
            port_length = ba.readUnsignedInt();
            var port:String;
            port = ba.readUTFBytes(port_length);
            var duel_host_length:int;
            duel_host_length = ba.readUnsignedInt();
            var duel_host:String;
            duel_host = ba.readUTFBytes(duel_host_length);
            var duel_port_length:int;
            duel_port_length = ba.readUnsignedInt();
            var duel_port:String;
            duel_port = ba.readUTFBytes(duel_port_length);
            var chat_host_length:int;
            chat_host_length = ba.readUnsignedInt();
            var chat_host:String;
            chat_host = ba.readUTFBytes(chat_host_length);
            var chat_port_length:int;
            chat_port_length = ba.readUnsignedInt();
            var chat_port:String;
            chat_port = ba.readUTFBytes(chat_port_length);
            var watch_host_length:int;
            watch_host_length = ba.readUnsignedInt();
            var watch_host:String;
            watch_host = ba.readUTFBytes(watch_host_length);
            var watch_port_length:int;
            watch_port_length = ba.readUnsignedInt();
            var watch_port:String;
            watch_port = ba.readUTFBytes(watch_port_length);
            var state_length:int;
            state_length = ba.readUnsignedInt();
            var state:String;
            state = ba.readUTFBytes(state_length);
            var caption_length:int;
            caption_length = ba.readUnsignedInt();
            var caption:String;
            caption = ba.readUTFBytes(caption_length);
            var count_length:int;
            count_length = ba.readUnsignedInt();
            var count:String;
            count = ba.readUTFBytes(count_length);
            var penalty_type_length:int;
            penalty_type_length = ba.readUnsignedInt();
            var penalty_type:String;
            penalty_type = ba.readUTFBytes(penalty_type_length);
            var cost_limit_min_length:int;
            cost_limit_min_length = ba.readUnsignedInt();
            var cost_limit_min:String;
            cost_limit_min = ba.readUTFBytes(cost_limit_min_length);
            var cost_limit_max_length:int;
            cost_limit_max_length = ba.readUnsignedInt();
            var cost_limit_max:String;
            cost_limit_max = ba.readUTFBytes(cost_limit_max_length);
            var watch_mode_length:int;
            watch_mode_length = ba.readUnsignedInt();
            var watch_mode:String;
            watch_mode = ba.readUTFBytes(watch_mode_length);
            server.scChannelListInfo(id, name, rule, max, host, port, duel_host, duel_port, chat_host, chat_port, watch_host, watch_port, state, caption, count, penalty_type, cost_limit_min, cost_limit_max, watch_mode);
      }


     private function scUpdateRank(ba:ByteArray):void
     {
            var type:int;
            type = ba.readByte();
            var rank:int;
            rank = ba.readInt();
            var point:int;
            point = ba.readInt();
            server.scUpdateRank(type, rank, point);
      }


     private function scUpdateTotalDuelRankingList(ba:ByteArray):void
     {
            ba.uncompress();
            var start:int;
            start = ba.readByte();
            var name_list_length:int;
            name_list_length = ba.readUnsignedInt();
            var name_list:String;
            name_list = ba.readUTFBytes(name_list_length);
            server.scUpdateTotalDuelRankingList(start, name_list);
      }


     private function scUpdateWeeklyDuelRankingList(ba:ByteArray):void
     {
            ba.uncompress();
            var start:int;
            start = ba.readByte();
            var name_list_length:int;
            name_list_length = ba.readUnsignedInt();
            var name_list:String;
            name_list = ba.readUTFBytes(name_list_length);
            server.scUpdateWeeklyDuelRankingList(start, name_list);
      }


     private function scUpdateTotalQuestRankingList(ba:ByteArray):void
     {
            ba.uncompress();
            var start:int;
            start = ba.readByte();
            var name_list_length:int;
            name_list_length = ba.readUnsignedInt();
            var name_list:String;
            name_list = ba.readUTFBytes(name_list_length);
            server.scUpdateTotalQuestRankingList(start, name_list);
      }


     private function scUpdateWeeklyQuestRankingList(ba:ByteArray):void
     {
            ba.uncompress();
            var start:int;
            start = ba.readByte();
            var name_list_length:int;
            name_list_length = ba.readUnsignedInt();
            var name_list:String;
            name_list = ba.readUTFBytes(name_list_length);
            server.scUpdateWeeklyQuestRankingList(start, name_list);
      }


     private function scUpdateTotalCharaVoteRankingList(ba:ByteArray):void
     {
            ba.uncompress();
            var start:int;
            start = ba.readByte();
            var name_list_length:int;
            name_list_length = ba.readUnsignedInt();
            var name_list:String;
            name_list = ba.readUTFBytes(name_list_length);
            server.scUpdateTotalCharaVoteRankingList(start, name_list);
      }


     private function scUpdateTotalEventRankingList(ba:ByteArray):void
     {
            ba.uncompress();
            var start:int;
            start = ba.readByte();
            var name_list_length:int;
            name_list_length = ba.readUnsignedInt();
            var name_list:String;
            name_list = ba.readUTFBytes(name_list_length);
            server.scUpdateTotalEventRankingList(start, name_list);
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


     private function scResultAvatarsList(ba:ByteArray):void
     {
            var avatars_length:int;
            avatars_length = ba.readUnsignedInt();
            var avatars:String;
            avatars = ba.readUTFBytes(avatars_length);
            server.scResultAvatarsList(avatars);
      }


    }
}
