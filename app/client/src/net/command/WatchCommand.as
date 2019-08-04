package net.command
{
    import flash.utils.ByteArray;
    import net.server.WatchServer;

    /**
     * サーバとのコマンドを管理するクラス
     * （自動生成される rake update_command）
     */

    public class WatchCommand extends Command
    {
       private var server:WatchServer;
       public function WatchCommand(s:WatchServer)
        {
            server =s;
            receiveCommands.push(negoCert);
            receiveCommands.push(loginCert);
            receiveCommands.push(loginFail);
            receiveCommands.push(scKeepAlive);
            receiveCommands.push(scErrorNo);
            receiveCommands.push(scWatchCancel);
            receiveCommands.push(scMessage);
            receiveCommands.push(scMessageStrData);
            receiveCommands.push(scDetermineSession);
            receiveCommands.push(scCharaCardInventoryInfo);
            receiveCommands.push(scOneToOneDuelStart);
            receiveCommands.push(scThreeToThreeDuelStart);
            receiveCommands.push(scOneToOneDuelFinish);
            receiveCommands.push(scThreeToThreeDuelFinish);
            receiveCommands.push(scDuelStartTurnPhase);
            receiveCommands.push(scDuelRefillPhase);
            receiveCommands.push(scDuelRefillEventPhase);
            receiveCommands.push(scDuelMoveCardDropPhaseStart);
            receiveCommands.push(scDuelMoveCardDropPhaseFinish);
            receiveCommands.push(scDuelDetermineMovePhase);
            receiveCommands.push(scDuelCharaChangePhaseStart);
            receiveCommands.push(scDuelCharaChangePhaseFinish);
            receiveCommands.push(scDuelAttackCardDropPhaseStart);
            receiveCommands.push(scDuelAttackCardDropPhaseFinish);
            receiveCommands.push(scDuelDeffenceCardDropPhaseStart);
            receiveCommands.push(scDuelDeffenceCardDropPhaseFinish);
            receiveCommands.push(scDuelDetermineBattlePointPhase);
            receiveCommands.push(scDuelBattleResultPhase);
            receiveCommands.push(scDuelDeadCharaChangePhaseStart);
            receiveCommands.push(scDuelDeadCharaChangePhaseFinish);
            receiveCommands.push(scDuelFinishTurnPhase);
            receiveCommands.push(scEntrantSetDirectionAction);
            receiveCommands.push(scEntrantMoveCardAddAction);
            receiveCommands.push(scEntrantMoveCardRemoveAction);
            receiveCommands.push(scEntrantCardRotateAction);
            receiveCommands.push(scEntrantEventCardRotateAction);
            receiveCommands.push(scEntrantBattleCardAddAction);
            receiveCommands.push(scEntrantBattleCardRemoveAction);
            receiveCommands.push(scEntrantInitDoneAction);
            receiveCommands.push(scEntrantAttackDoneAction);
            receiveCommands.push(scEntrantDeffenceDoneAction);
            receiveCommands.push(scEntrantMoveAction);
            receiveCommands.push(scEntrantHideMoveAction);
            receiveCommands.push(scEntrantCharaChangeAction);
            receiveCommands.push(scEntrantDamagedEvent);
            receiveCommands.push(scEntrantPartyDamagedEvent);
            receiveCommands.push(scEntrantReviveEvent);
            receiveCommands.push(scEntrantConstraintEvent);
            receiveCommands.push(scEntrantHealedEvent);
            receiveCommands.push(scEntrantPartyHealedEvent);
            receiveCommands.push(scEntrantHitPointChangedEvent);
            receiveCommands.push(scEntrantCuredEvent);
            receiveCommands.push(scEntrantPointUpdateEvent);
            receiveCommands.push(scEntrantPointRewriteEvent);
            receiveCommands.push(scEntrantUseActionCardEvent);
            receiveCommands.push(scEntrantDiscardEvent);
            receiveCommands.push(scEntrantDiscardTableEvent);
            receiveCommands.push(scEntrantSpecialDealedEvent);
            receiveCommands.push(scEntrantGraveDealedEvent);
            receiveCommands.push(scEntrantStealDealedEvent);
            receiveCommands.push(scEntrantSpecialEventCardDealedEvent);
            receiveCommands.push(scEntrantUpdateCardValueEvent);
            receiveCommands.push(scEntrantUpdateWeaponEvent);
            receiveCommands.push(scEntrantCardsMaxUpdateEvent);
            receiveCommands.push(scEntrantTrapActionEvent);
            receiveCommands.push(scEntrantTrapUpdateEvent);
            receiveCommands.push(scSetFieldStatusEvent);
            receiveCommands.push(scDuelBonusEvent);
            receiveCommands.push(scSetTurnEvent);
            receiveCommands.push(scCardLockEvent);
            receiveCommands.push(scClearCardLocksEvent);
            receiveCommands.push(scDeckInitEvent);
            receiveCommands.push(scActioncardChanceEvent);
            receiveCommands.push(scBuffOnEvent);
            receiveCommands.push(scBuffOffEvent);
            receiveCommands.push(scBuffUpdateEvent);
            receiveCommands.push(scCatStateUpdateEvent);
            receiveCommands.push(scPlFeatOnEvent);
            receiveCommands.push(scPlFeatOffEvent);
            receiveCommands.push(scEntrantChangeFeatEvent);
            receiveCommands.push(scEntrantUseFeatEvent);
            receiveCommands.push(scEntrantUsePassiveEvent);
            receiveCommands.push(scEntrantChangeCharaCardEvent);
            receiveCommands.push(scEntrantOnTransformEvent);
            receiveCommands.push(scEntrantOffTransformEvent);
            receiveCommands.push(scEntrantOnPassiveEvent);
            receiveCommands.push(scEntrantOffPassiveEvent);
            receiveCommands.push(scEntrantOnLostInTheFogEvent);
            receiveCommands.push(scEntrantOffLostInTheFogEvent);
            receiveCommands.push(scEntrantInTheFogEvent);
            receiveCommands.push(scEntrantUpdateFeatConditionEvent);
            receiveCommands.push(scEntrantStuffedToysSetEvent);
            receiveCommands.push(scWatchDuelFinishEvent);
            receiveCommands.push(scSetCharaBuffEvent);
            receiveCommands.push(scResetDeckNumEvent);
            receiveCommands.push(scSetInitiAndDistEvent);
            receiveCommands.push(scWatchDuelRoomOut);

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

     public function csWatchStart(u_id:String):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(4);
            cmd.writeUTF(u_id);

            return cmd;
        }

     public function csWatchCommandGetStart():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(5);

            return cmd;
        }

     public function csWatchFinish():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(6);

            return cmd;
        }

     public function csStartOk():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(7);

            return cmd;
        }

     public function csAvatarUseItem(inv_id:int):ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(8);
            cmd.writeInt(inv_id);

            return cmd;
        }

     public function csWatchCancel():ByteArray
     {
        var cmd:ByteArray = new ByteArray();
            cmd.writeShort(9);

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


     private function scWatchCancel(ba:ByteArray):void
     {
            server.scWatchCancel();
      }


     private function scMessage(ba:ByteArray):void
     {
            var msg_length:int;
            msg_length = ba.readUnsignedInt();
            var msg:String;
            msg = ba.readUTFBytes(msg_length);
            server.scMessage(msg);
      }


     private function scMessageStrData(ba:ByteArray):void
     {
            var str_length:int;
            str_length = ba.readUnsignedInt();
            var str:String;
            str = ba.readUTFBytes(str_length);
            server.scMessageStrData(str);
      }


     private function scDetermineSession(ba:ByteArray):void
     {
            var id:int;
            id = ba.readInt();
            var foe_length:int;
            foe_length = ba.readUnsignedInt();
            var foe:String;
            foe = ba.readUTFBytes(foe_length);
            var player_chara_card_id_length:int;
            player_chara_card_id_length = ba.readUnsignedInt();
            var player_chara_card_id:String;
            player_chara_card_id = ba.readUTFBytes(player_chara_card_id_length);
            var foe_chara_card_id_length:int;
            foe_chara_card_id_length = ba.readUnsignedInt();
            var foe_chara_card_id:String;
            foe_chara_card_id = ba.readUTFBytes(foe_chara_card_id_length);
            var start_dialogue_length:int;
            start_dialogue_length = ba.readUnsignedInt();
            var start_dialogue:String;
            start_dialogue = ba.readUTFBytes(start_dialogue_length);
            var start_dialogue_id:int;
            start_dialogue_id = ba.readInt();
            var stage:int;
            stage = ba.readByte();
            var pl_hp_length:int;
            pl_hp_length = ba.readUnsignedInt();
            var pl_hp:String;
            pl_hp = ba.readUTFBytes(pl_hp_length);
            var foe_hp_length:int;
            foe_hp_length = ba.readUnsignedInt();
            var foe_hp:String;
            foe_hp = ba.readUTFBytes(foe_hp_length);
            server.scDetermineSession(id, foe, player_chara_card_id, foe_chara_card_id, start_dialogue, start_dialogue_id, stage, pl_hp, foe_hp);
      }


     private function scCharaCardInventoryInfo(ba:ByteArray):void
     {
            var inv_id_length:int;
            inv_id_length = ba.readUnsignedInt();
            var inv_id:String;
            inv_id = ba.readUTFBytes(inv_id_length);
            var card_id_length:int;
            card_id_length = ba.readUnsignedInt();
            var card_id:String;
            card_id = ba.readUTFBytes(card_id_length);
            server.scCharaCardInventoryInfo(inv_id, card_id);
      }


     private function scOneToOneDuelStart(ba:ByteArray):void
     {
            var deck_size:int;
            deck_size = ba.readByte();
            var player_event_deck_size:int;
            player_event_deck_size = ba.readByte();
            var foe_deck_size:int;
            foe_deck_size = ba.readByte();
            var distance:int;
            distance = ba.readByte();
            server.scOneToOneDuelStart(deck_size, player_event_deck_size, foe_deck_size, distance);
      }


     private function scThreeToThreeDuelStart(ba:ByteArray):void
     {
            var deck_size:int;
            deck_size = ba.readByte();
            var player_event_deck_size:int;
            player_event_deck_size = ba.readByte();
            var foe_event_deck_size:int;
            foe_event_deck_size = ba.readByte();
            var distance:int;
            distance = ba.readByte();
            var multi:Boolean;
            multi = ba.readBoolean();
            server.scThreeToThreeDuelStart(deck_size, player_event_deck_size, foe_event_deck_size, distance, multi);
      }


     private function scOneToOneDuelFinish(ba:ByteArray):void
     {
            var result:int;
            result = ba.readByte();
            var gems:int;
            gems = ba.readInt();
            var exp:int;
            exp = ba.readInt();
            var gems_pow:int;
            gems_pow = ba.readInt();
            var exp_pow:int;
            exp_pow = ba.readInt();
            var bonus:Boolean;
            bonus = ba.readBoolean();
            server.scOneToOneDuelFinish(result, gems, exp, gems_pow, exp_pow, bonus);
      }


     private function scThreeToThreeDuelFinish(ba:ByteArray):void
     {
            var result:int;
            result = ba.readByte();
            var gems:int;
            gems = ba.readInt();
            var exp:int;
            exp = ba.readInt();
            var bonus:Boolean;
            bonus = ba.readBoolean();
            server.scThreeToThreeDuelFinish(result, gems, exp, bonus);
      }


     private function scDuelStartTurnPhase(ba:ByteArray):void
     {
            var turn_count:int;
            turn_count = ba.readByte();
            server.scDuelStartTurnPhase(turn_count);
      }


     private function scDuelRefillPhase(ba:ByteArray):void
     {
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir:int;
            dir = ba.readInt();
            var foe_size:int;
            foe_size = ba.readByte();
            server.scDuelRefillPhase(list, dir, foe_size);
      }


     private function scDuelRefillEventPhase(ba:ByteArray):void
     {
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir:int;
            dir = ba.readInt();
            var foe_size:int;
            foe_size = ba.readByte();
            server.scDuelRefillEventPhase(list, dir, foe_size);
      }


     private function scDuelMoveCardDropPhaseStart(ba:ByteArray):void
     {
            server.scDuelMoveCardDropPhaseStart();
      }


     private function scDuelMoveCardDropPhaseFinish(ba:ByteArray):void
     {
            server.scDuelMoveCardDropPhaseFinish();
      }


     private function scDuelDetermineMovePhase(ba:ByteArray):void
     {
            var init:Boolean;
            init = ba.readBoolean();
            var dist:int;
            dist = ba.readByte();
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir_length:int;
            dir_length = ba.readUnsignedInt();
            var dir:String;
            dir = ba.readUTFBytes(dir_length);
            var foe_list_length:int;
            foe_list_length = ba.readUnsignedInt();
            var foe_list:String;
            foe_list = ba.readUTFBytes(foe_list_length);
            var foe_dir_length:int;
            foe_dir_length = ba.readUnsignedInt();
            var foe_dir:String;
            foe_dir = ba.readUTFBytes(foe_dir_length);
            var pow:int;
            pow = ba.readByte();
            var foe_pow:int;
            foe_pow = ba.readByte();
            var lock:Boolean;
            lock = ba.readBoolean();
            var foe_lock:Boolean;
            foe_lock = ba.readBoolean();
            server.scDuelDetermineMovePhase(init, dist, list, dir, foe_list, foe_dir, pow, foe_pow, lock, foe_lock);
      }


     private function scDuelCharaChangePhaseStart(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var foe:Boolean;
            foe = ba.readBoolean();
            server.scDuelCharaChangePhaseStart(player, foe);
      }


     private function scDuelCharaChangePhaseFinish(ba:ByteArray):void
     {
            server.scDuelCharaChangePhaseFinish();
      }


     private function scDuelAttackCardDropPhaseStart(ba:ByteArray):void
     {
            var attack:Boolean;
            attack = ba.readBoolean();
            server.scDuelAttackCardDropPhaseStart(attack);
      }


     private function scDuelAttackCardDropPhaseFinish(ba:ByteArray):void
     {
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir_length:int;
            dir_length = ba.readUnsignedInt();
            var dir:String;
            dir = ba.readUTFBytes(dir_length);
            var foe_list_length:int;
            foe_list_length = ba.readUnsignedInt();
            var foe_list:String;
            foe_list = ba.readUTFBytes(foe_list_length);
            var foe_dir_length:int;
            foe_dir_length = ba.readUnsignedInt();
            var foe_dir:String;
            foe_dir = ba.readUTFBytes(foe_dir_length);
            var lock:Boolean;
            lock = ba.readBoolean();
            var foe_lock:Boolean;
            foe_lock = ba.readBoolean();
            server.scDuelAttackCardDropPhaseFinish(list, dir, foe_list, foe_dir, lock, foe_lock);
      }


     private function scDuelDeffenceCardDropPhaseStart(ba:ByteArray):void
     {
            var deffence:Boolean;
            deffence = ba.readBoolean();
            server.scDuelDeffenceCardDropPhaseStart(deffence);
      }


     private function scDuelDeffenceCardDropPhaseFinish(ba:ByteArray):void
     {
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir_length:int;
            dir_length = ba.readUnsignedInt();
            var dir:String;
            dir = ba.readUTFBytes(dir_length);
            var foe_list_length:int;
            foe_list_length = ba.readUnsignedInt();
            var foe_list:String;
            foe_list = ba.readUTFBytes(foe_list_length);
            var foe_dir_length:int;
            foe_dir_length = ba.readUnsignedInt();
            var foe_dir:String;
            foe_dir = ba.readUTFBytes(foe_dir_length);
            var lock:Boolean;
            lock = ba.readBoolean();
            var foe_lock:Boolean;
            foe_lock = ba.readBoolean();
            server.scDuelDeffenceCardDropPhaseFinish(list, dir, foe_list, foe_dir, lock, foe_lock);
      }


     private function scDuelDetermineBattlePointPhase(ba:ByteArray):void
     {
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir_length:int;
            dir_length = ba.readUnsignedInt();
            var dir:String;
            dir = ba.readUTFBytes(dir_length);
            var foe_list_length:int;
            foe_list_length = ba.readUnsignedInt();
            var foe_list:String;
            foe_list = ba.readUTFBytes(foe_list_length);
            var foe_dir_length:int;
            foe_dir_length = ba.readUnsignedInt();
            var foe_dir:String;
            foe_dir = ba.readUTFBytes(foe_dir_length);
            var lock:Boolean;
            lock = ba.readBoolean();
            var foe_lock:Boolean;
            foe_lock = ba.readBoolean();
            server.scDuelDetermineBattlePointPhase(list, dir, foe_list, foe_dir, lock, foe_lock);
      }


     private function scDuelBattleResultPhase(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var attack_dice_length:int;
            attack_dice_length = ba.readUnsignedInt();
            var attack_dice:String;
            attack_dice = ba.readUTFBytes(attack_dice_length);
            var deffence_dice_length:int;
            deffence_dice_length = ba.readUnsignedInt();
            var deffence_dice:String;
            deffence_dice = ba.readUTFBytes(deffence_dice_length);
            server.scDuelBattleResultPhase(player, attack_dice, deffence_dice);
      }


     private function scDuelDeadCharaChangePhaseStart(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var foe:Boolean;
            foe = ba.readBoolean();
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var foe_list_length:int;
            foe_list_length = ba.readUnsignedInt();
            var foe_list:String;
            foe_list = ba.readUTFBytes(foe_list_length);
            server.scDuelDeadCharaChangePhaseStart(player, foe, list, foe_list);
      }


     private function scDuelDeadCharaChangePhaseFinish(ba:ByteArray):void
     {
            server.scDuelDeadCharaChangePhaseFinish();
      }


     private function scDuelFinishTurnPhase(ba:ByteArray):void
     {
            server.scDuelFinishTurnPhase();
      }


     private function scEntrantSetDirectionAction(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var dir:int;
            dir = ba.readByte();
            server.scEntrantSetDirectionAction(player, dir);
      }


     private function scEntrantMoveCardAddAction(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var index:int;
            index = ba.readByte();
            var id:int;
            id = ba.readInt();
            server.scEntrantMoveCardAddAction(player, index, id);
      }


     private function scEntrantMoveCardRemoveAction(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var index:int;
            index = ba.readByte();
            var id:int;
            id = ba.readInt();
            server.scEntrantMoveCardRemoveAction(player, index, id);
      }


     private function scEntrantCardRotateAction(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var table:int;
            table = ba.readByte();
            var index:int;
            index = ba.readByte();
            var id:int;
            id = ba.readInt();
            var dir:Boolean;
            dir = ba.readBoolean();
            server.scEntrantCardRotateAction(player, table, index, id, dir);
      }


     private function scEntrantEventCardRotateAction(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var table:int;
            table = ba.readByte();
            var index:int;
            index = ba.readByte();
            var id:int;
            id = ba.readInt();
            var dir:Boolean;
            dir = ba.readBoolean();
            server.scEntrantEventCardRotateAction(player, table, index, id, dir);
      }


     private function scEntrantBattleCardAddAction(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var index:int;
            index = ba.readByte();
            var id:int;
            id = ba.readInt();
            server.scEntrantBattleCardAddAction(player, index, id);
      }


     private function scEntrantBattleCardRemoveAction(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var index:int;
            index = ba.readByte();
            var id:int;
            id = ba.readInt();
            server.scEntrantBattleCardRemoveAction(player, index, id);
      }


     private function scEntrantInitDoneAction(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            server.scEntrantInitDoneAction(player);
      }


     private function scEntrantAttackDoneAction(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            server.scEntrantAttackDoneAction(player);
      }


     private function scEntrantDeffenceDoneAction(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            server.scEntrantDeffenceDoneAction(player);
      }


     private function scEntrantMoveAction(ba:ByteArray):void
     {
            var dist:int;
            dist = ba.readByte();
            server.scEntrantMoveAction(dist);
      }


     private function scEntrantHideMoveAction(ba:ByteArray):void
     {
            var dist:int;
            dist = ba.readByte();
            server.scEntrantHideMoveAction(dist);
      }


     private function scEntrantCharaChangeAction(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var index:int;
            index = ba.readByte();
            var card_id:int;
            card_id = ba.readInt();
            var weapon_bonus_length:int;
            weapon_bonus_length = ba.readUnsignedInt();
            var weapon_bonus:String;
            weapon_bonus = ba.readUTFBytes(weapon_bonus_length);
            server.scEntrantCharaChangeAction(player, index, card_id, weapon_bonus);
      }


     private function scEntrantDamagedEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var damage:int;
            damage = ba.readByte();
            var is_not_hostile:Boolean;
            is_not_hostile = ba.readBoolean();
            server.scEntrantDamagedEvent(player, damage, is_not_hostile);
      }


     private function scEntrantPartyDamagedEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var index:int;
            index = ba.readInt();
            var damage:int;
            damage = ba.readByte();
            var is_not_hostile:Boolean;
            is_not_hostile = ba.readBoolean();
            server.scEntrantPartyDamagedEvent(player, index, damage, is_not_hostile);
      }


     private function scEntrantReviveEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var index:int;
            index = ba.readInt();
            var rhp:int;
            rhp = ba.readInt();
            server.scEntrantReviveEvent(player, index, rhp);
      }


     private function scEntrantConstraintEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var flag:int;
            flag = ba.readInt();
            server.scEntrantConstraintEvent(player, flag);
      }


     private function scEntrantHealedEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var heal:int;
            heal = ba.readByte();
            server.scEntrantHealedEvent(player, heal);
      }


     private function scEntrantPartyHealedEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var index:int;
            index = ba.readInt();
            var heal:int;
            heal = ba.readByte();
            server.scEntrantPartyHealedEvent(player, index, heal);
      }


     private function scEntrantHitPointChangedEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var hp:int;
            hp = ba.readInt();
            server.scEntrantHitPointChangedEvent(player, hp);
      }


     private function scEntrantCuredEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            server.scEntrantCuredEvent(player);
      }


     private function scEntrantPointUpdateEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir:int;
            dir = ba.readInt();
            var point:int;
            point = ba.readInt();
            server.scEntrantPointUpdateEvent(player, list, dir, point);
      }


     private function scEntrantPointRewriteEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var point:int;
            point = ba.readInt();
            server.scEntrantPointRewriteEvent(player, point);
      }


     private function scEntrantUseActionCardEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var used_card_id:int;
            used_card_id = ba.readInt();
            server.scEntrantUseActionCardEvent(player, used_card_id);
      }


     private function scEntrantDiscardEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var discard_id:int;
            discard_id = ba.readInt();
            server.scEntrantDiscardEvent(player, discard_id);
      }


     private function scEntrantDiscardTableEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var discard_id:int;
            discard_id = ba.readInt();
            server.scEntrantDiscardTableEvent(player, discard_id);
      }


     private function scEntrantSpecialDealedEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir:int;
            dir = ba.readInt();
            var size:int;
            size = ba.readInt();
            server.scEntrantSpecialDealedEvent(player, list, dir, size);
      }


     private function scEntrantGraveDealedEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir:int;
            dir = ba.readInt();
            var size:int;
            size = ba.readInt();
            server.scEntrantGraveDealedEvent(player, list, dir, size);
      }


     private function scEntrantStealDealedEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir:int;
            dir = ba.readInt();
            var size:int;
            size = ba.readInt();
            server.scEntrantStealDealedEvent(player, list, dir, size);
      }


     private function scEntrantSpecialEventCardDealedEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir:int;
            dir = ba.readInt();
            var size:int;
            size = ba.readInt();
            server.scEntrantSpecialEventCardDealedEvent(player, list, dir, size);
      }


     private function scEntrantUpdateCardValueEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var id:int;
            id = ba.readInt();
            var u_value:int;
            u_value = ba.readInt();
            var b_value:int;
            b_value = ba.readInt();
            var reset:Boolean;
            reset = ba.readBoolean();
            server.scEntrantUpdateCardValueEvent(player, id, u_value, b_value, reset);
      }


     private function scEntrantUpdateWeaponEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var pl_bonus_length:int;
            pl_bonus_length = ba.readUnsignedInt();
            var pl_bonus:String;
            pl_bonus = ba.readUTFBytes(pl_bonus_length);
            var foe_bonus_length:int;
            foe_bonus_length = ba.readUnsignedInt();
            var foe_bonus:String;
            foe_bonus = ba.readUTFBytes(foe_bonus_length);
            server.scEntrantUpdateWeaponEvent(player, pl_bonus, foe_bonus);
      }


     private function scEntrantCardsMaxUpdateEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var cards_max:int;
            cards_max = ba.readByte();
            server.scEntrantCardsMaxUpdateEvent(player, cards_max);
      }


     private function scEntrantTrapActionEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var kind:int;
            kind = ba.readInt();
            var distance:int;
            distance = ba.readInt();
            server.scEntrantTrapActionEvent(player, kind, distance);
      }


     private function scEntrantTrapUpdateEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var kind:int;
            kind = ba.readInt();
            var distance:int;
            distance = ba.readInt();
            var turn:int;
            turn = ba.readInt();
            var visible:Boolean;
            visible = ba.readBoolean();
            server.scEntrantTrapUpdateEvent(player, kind, distance, turn, visible);
      }


     private function scSetFieldStatusEvent(ba:ByteArray):void
     {
            var kind:int;
            kind = ba.readInt();
            var pow:int;
            pow = ba.readInt();
            var turn:int;
            turn = ba.readInt();
            server.scSetFieldStatusEvent(kind, pow, turn);
      }


     private function scDuelBonusEvent(ba:ByteArray):void
     {
            var bonus_type:int;
            bonus_type = ba.readByte();
            var value:int;
            value = ba.readByte();
            server.scDuelBonusEvent(bonus_type, value);
      }


     private function scSetTurnEvent(ba:ByteArray):void
     {
            var turn:int;
            turn = ba.readInt();
            server.scSetTurnEvent(turn);
      }


     private function scCardLockEvent(ba:ByteArray):void
     {
            var id:int;
            id = ba.readInt();
            server.scCardLockEvent(id);
      }


     private function scClearCardLocksEvent(ba:ByteArray):void
     {
            server.scClearCardLocksEvent();
      }


     private function scDeckInitEvent(ba:ByteArray):void
     {
            var deck_size:int;
            deck_size = ba.readByte();
            server.scDeckInitEvent(deck_size);
      }


     private function scActioncardChanceEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var list_length:int;
            list_length = ba.readUnsignedInt();
            var list:String;
            list = ba.readUTFBytes(list_length);
            var dir:int;
            dir = ba.readInt();
            var size:int;
            size = ba.readInt();
            server.scActioncardChanceEvent(player, list, dir, size);
      }


     private function scBuffOnEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var index:int;
            index = ba.readInt();
            var buff_id:int;
            buff_id = ba.readInt();
            var value:int;
            value = ba.readInt();
            var turn:int;
            turn = ba.readInt();
            server.scBuffOnEvent(player, index, buff_id, value, turn);
      }


     private function scBuffOffEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var index:int;
            index = ba.readInt();
            var buff_id:int;
            buff_id = ba.readInt();
            var value:int;
            value = ba.readInt();
            server.scBuffOffEvent(player, index, buff_id, value);
      }


     private function scBuffUpdateEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var buff_id:int;
            buff_id = ba.readInt();
            var value:int;
            value = ba.readInt();
            var index:int;
            index = ba.readInt();
            var turn:int;
            turn = ba.readInt();
            server.scBuffUpdateEvent(player, buff_id, value, index, turn);
      }


     private function scCatStateUpdateEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var index:int;
            index = ba.readInt();
            var value:Boolean;
            value = ba.readBoolean();
            server.scCatStateUpdateEvent(player, index, value);
      }


     private function scPlFeatOnEvent(ba:ByteArray):void
     {
            var feat_id:int;
            feat_id = ba.readInt();
            server.scPlFeatOnEvent(feat_id);
      }


     private function scPlFeatOffEvent(ba:ByteArray):void
     {
            var feat_id:int;
            feat_id = ba.readInt();
            server.scPlFeatOffEvent(feat_id);
      }


     private function scEntrantChangeFeatEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var chara_index:int;
            chara_index = ba.readInt();
            var feat_index:int;
            feat_index = ba.readInt();
            var feat_id:int;
            feat_id = ba.readInt();
            var feat_no:int;
            feat_no = ba.readInt();
            server.scEntrantChangeFeatEvent(player, chara_index, feat_index, feat_id, feat_no);
      }


     private function scEntrantUseFeatEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var used_feat_id:int;
            used_feat_id = ba.readInt();
            server.scEntrantUseFeatEvent(player, used_feat_id);
      }


     private function scEntrantUsePassiveEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var used_passive_id:int;
            used_passive_id = ba.readInt();
            server.scEntrantUsePassiveEvent(player, used_passive_id);
      }


     private function scEntrantChangeCharaCardEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var chara_card_id:int;
            chara_card_id = ba.readInt();
            server.scEntrantChangeCharaCardEvent(player, chara_card_id);
      }


     private function scEntrantOnTransformEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var transform_type:int;
            transform_type = ba.readInt();
            server.scEntrantOnTransformEvent(player, transform_type);
      }


     private function scEntrantOffTransformEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            server.scEntrantOffTransformEvent(player);
      }


     private function scEntrantOnPassiveEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var skill_id:int;
            skill_id = ba.readInt();
            server.scEntrantOnPassiveEvent(player, skill_id);
      }


     private function scEntrantOffPassiveEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var skill_id:int;
            skill_id = ba.readInt();
            server.scEntrantOffPassiveEvent(player, skill_id);
      }


     private function scEntrantOnLostInTheFogEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var distance:int;
            distance = ba.readInt();
            var truth_distance:int;
            truth_distance = ba.readInt();
            server.scEntrantOnLostInTheFogEvent(player, distance, truth_distance);
      }


     private function scEntrantOffLostInTheFogEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var distance:int;
            distance = ba.readInt();
            server.scEntrantOffLostInTheFogEvent(player, distance);
      }


     private function scEntrantInTheFogEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var range_length:int;
            range_length = ba.readUnsignedInt();
            var range:String;
            range = ba.readUTFBytes(range_length);
            server.scEntrantInTheFogEvent(player, range);
      }


     private function scEntrantUpdateFeatConditionEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var chara_index:int;
            chara_index = ba.readInt();
            var feat_index:int;
            feat_index = ba.readInt();
            var condition_length:int;
            condition_length = ba.readUnsignedInt();
            var condition:String;
            condition = ba.readUTFBytes(condition_length);
            server.scEntrantUpdateFeatConditionEvent(player, chara_index, feat_index, condition);
      }


     private function scEntrantStuffedToysSetEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var num:int;
            num = ba.readInt();
            server.scEntrantStuffedToysSetEvent(player, num);
      }


     private function scWatchDuelFinishEvent(ba:ByteArray):void
     {
            var is_end:Boolean;
            is_end = ba.readBoolean();
            var winner_name_length:int;
            winner_name_length = ba.readUnsignedInt();
            var winner_name:String;
            winner_name = ba.readUTFBytes(winner_name_length);
            server.scWatchDuelFinishEvent(is_end, winner_name);
      }


     private function scSetCharaBuffEvent(ba:ByteArray):void
     {
            var player:Boolean;
            player = ba.readBoolean();
            var buff_str_length:int;
            buff_str_length = ba.readUnsignedInt();
            var buff_str:String;
            buff_str = ba.readUTFBytes(buff_str_length);
            server.scSetCharaBuffEvent(player, buff_str);
      }


     private function scResetDeckNumEvent(ba:ByteArray):void
     {
            var deck_size:int;
            deck_size = ba.readInt();
            server.scResetDeckNumEvent(deck_size);
      }


     private function scSetInitiAndDistEvent(ba:ByteArray):void
     {
            var initi:Boolean;
            initi = ba.readBoolean();
            var dist:int;
            dist = ba.readInt();
            server.scSetInitiAndDistEvent(initi, dist);
      }


     private function scWatchDuelRoomOut(ba:ByteArray):void
     {
            server.scWatchDuelRoomOut();
      }


    }
}
