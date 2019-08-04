# -*- coding: utf-8 -*-
$:.unshift(File.join(File.expand_path("../server"), "src"))
require 'find'
require 'pathname'
require 'optparse'
require "sequel"
require "sequel/extensions/inflector"
require "./script/rc4.rb"
require 'unlight'
require 'stringio'
require 'rocketamf'
require File::expand_path(__FILE__).gsub(/client\/script\/create_const_data.rb/, "")+"server/script/constdata_keys.rb"

filename = "./src/model/utils/ConstData.as"

#ENCRYPT_KEY = "ygnentkwpawk38575"
ENCRYPT_KEY = CONSTDATA_ENCRYPTKEY
OUTPUT = true
SEPARATOR = ","

$encryot_on = false
$add_chara_story = true

module Unlight
  opt = OptionParser.new
  # オプションがjの時日本語用のDBに接続L
  #
  opt.on('-j',"--japanese","日本語版で作る") do|v|
    if v
    end
    $encrypt_on = true
  end
  DB = Sequel.mysql2(nil,MYSQL_CONFIG)

  MYSQL_CONFIG =  {
    :host =>"db",
    :user => "unlight",
    :password =>"unlight",
    :database =>"unlight_db",
    :encoding => 'utf8',
    :max_connections => 5,
    :loggers => Logger.new(File.dirname(__FILE__).gsub("src","")+"/data/#{$SERVER_NAME}_mysqldb.log", 32, 10*1024*1024)
  }
  DB = Sequel.mysql2(nil,MYSQL_CONFIG)

  opt.on('-s',"--sandbox","sandboxを作る") do |v|
    if v
      # #mysql設定
      # SB_MYSQL_CONFIG =  {
      #   :host =>"db",
      #   :user => "unlight",
      #   :password =>"unlight",
      #   :database =>"unlight_db",
      #   :encoding => 'utf8',
      #   :max_connections => 5,
      # }
      # DB = Sequel.mysql2(nil,SB_MYSQL_CONFIG)
      puts "SBDBにした上書き."
    end
    $encrypt_on = true
  end

  opt.parse!(ARGV)
  CharaCard.db=DB
  CharaCardStory.db=DB
  CharaCardRequirement.db=DB
  ActionCard.db=DB
  Feat.db=DB
  AvatarItem.db=DB
  EventCard.db=DB
  Quest.db = DB
  QuestLand.db = DB
  QuestMap.db = DB
  TreasureData.db = DB
  FeatInventory.db = DB
  WeaponCard.db = DB
  RareCardLot.db = DB
  RealMoneyItem.db = DB
  AvatarPart.db = DB
  Shop.db =DB
  Achievement.db = DB
  ProfoundData.db = DB
  ProfoundTreasureData.db = DB
  PassiveSkill.db=DB
  PassiveSkillInventory.db=DB
  Feat::initialize_condition_method
  PassiveSkill::initialize_condition_method
end


def array_amf(dataset, col, zero_obj)
  n = dataset.naked
  data_arr = []
  data_arr << zero_obj if zero_obj != nil
  n.each do |r|
    a = []
    col.collect{ |c| r[c]}.each{|f|
      a << f
    }
    data_arr << a
  end
  amf = RocketAMF.serialize(data_arr, 3)
  encryptor = RC4.new(ENCRYPT_KEY)
  encrypted = encryptor.encrypt(amf)
  encrypted.gsub!("\n", '')
  ret = "\"" + encrypted + "\""
end

def get_array_csv_str_amf(dataset, zero_obj)
  n = dataset.naked
  data_arr = []
  data_arr << zero_obj if zero_obj != nil
  dataset.all.each do |d|
    a = "["
    a << d.get_data_csv_str
    a << "," << Unlight::CharaCardStory.get_data_csv_str(d.id) if $add_chara_story&&d.instance_of?(Unlight::CharaCard)
    a << "]"
    arr = []
    eval("arr = "+a)
    data_arr << arr
  end
  amf = RocketAMF.serialize(data_arr, 3)
  encryptor = RC4.new(ENCRYPT_KEY)
  encrypted = encryptor.encrypt(amf)
  encrypted.gsub!("\n", '')
  ret = "\"" + encrypted + "\""
end

def csv_output(dataset,col)
  n = dataset.naked
  tsv = ''
  n.each do  |r|
    a = "            ["
    col.collect{ |c| r[c]}.each{|f| a<<
      if f.class == String||f==nil||f.class == Time
        '"'+f.to_s+'"'+(SEPARATOR)
      else
        f.to_s+(SEPARATOR)
      end
    }
    a.chop!
    a << "],\n"
    tsv << a
  end
  tsv.chop!.chop!
end

def get_data_csv_str(dataset)
  tsv = ''
  dataset.all.each do |d|
    a = "            ["
    a << d.get_data_csv_str
    a << "," << Unlight::CharaCardStory.get_data_csv_str(d.id) if $add_chara_story&&d.instance_of?(Unlight::CharaCard)
    a << "],\n"
    tsv << a
  end
  tsv.chop!.chop!
end


if $encrypt_on
  cc_zero = [0,"","",0,0,0,0,0,0,0,"","","","","","",0,0,0, "", "", 0, ""]
  cc_zero << [] if $add_chara_story

  ac_data = array_amf(Unlight::ActionCard,[:id,:u_type,:u_value,:b_type,:b_value,:event_no,:image,:caption], [0,0,0,0,0,0,"",""]);
  feat_data = get_array_csv_str_amf(Unlight::Feat, [0,"","",""]);
  cc_data = get_array_csv_str_amf(Unlight::CharaCard, cc_zero);
  ai_data = array_amf(Unlight::AvatarItem,[:id,:name,:item_no,:kind,:sub_kind,:cond,:image,:image_frame,:effect_image,:caption], [0, "", 0, 0,"", "","",0,"",""]);
  ec_data = array_amf(Unlight::EventCard,[:id,:name,:event_no,:card_cost,:color,:max_in_deck,:restriction,:image,:caption], [0, "", 0, 0, 0, 0, "", "", ""]);
  quest_data = get_array_csv_str_amf(Unlight::Quest, [0, "", "", 0, 0, 0, 0, "", "", 0, 0]);
  quest_land_data = get_array_csv_str_amf(Unlight::QuestLand, [0, "",  0, 0, 0, 0, ""]);
  quest_map_data = array_amf(Unlight::QuestMap,[:id, :name, :caption, :region ,:level, :ap, :difficulty], [0, "", "", 0, 0, 0, 0]);
  wc_data = get_array_csv_str_amf(Unlight::WeaponCard, [0, "", 0, 0, [], "", "",0,0,0,0,0,0,[]])
  rare_card_lot_data = array_amf(Unlight::RareCardLot,[:id,:lot_kind,:article_kind,:article_id,:order,:visible,:description,:num], [0, 0, 0, 0, 0, 0, "", 0])
  real_money_item_data = array_amf(Unlight::RealMoneyItem,[:id,:name,:price,:rm_item_type,:item_id,:num,:order, :state,:image_url,:tab,:description,:view_frame,:extra_id,:sale_type,:deck_image_url], [0,"",0,0,0,0,0,0,"",0,"",0,0,0,""])
  ap_data = get_array_csv_str_amf(Unlight::AvatarPart, [0, "", "", 0, 0, 0, 0, 0,0,0,0,""]);
  shop_data = Unlight::Shop::get_sale_list_str
  achievement_data = get_array_csv_str_amf(Unlight::Achievement, [0, 0,"","",0,""])
  profound_data = get_array_csv_str_amf(Unlight::ProfoundData, [0, 0, "", 0, 0, 0, 0, 0, "", 0, "", "", 0])
  prf_trs_data = array_amf(Unlight::ProfoundTreasureData,[:id,:level,:prf_trs_type,:rank_min,:rank_max,:treasure_type,:treasure_id,:slot_type,:value],[0,0,0,0,0,0,0,0,0]);
  passive_skill_data = get_array_csv_str_amf(Unlight::PassiveSkill, [0,0,"","","",""]);
  chara_data = get_array_csv_str_amf(Unlight::Charactor, [0,"",""]);

  file = Pathname.new(filename)

  init_func_str = <<"EOS"
        public static function dataInit(msg:String):void
        {
            __dec_msg = msg;
            var cnt:int = 0;
            var i:int = 0;
            var cst_data_len:int = DATA.length;
            for ( i = 0; i < cst_data_len; i++ ) {
                __DATA[i] = [];
                if ( i != SHOP ) {
                    var temp:Array = decrypt(DATA[i]);
                    for ( cnt = 0; cnt < temp.length; cnt++ ) {
                        __DATA[i][cnt] = temp[cnt];
                    }
                } else {
                    __DATA[i] = DATA[i];
                }
            }
            log.writeLog(log.LV_INFO, "[ConstData] dataInit is Success.");
            __isInit = true;
        }

EOS

  file.open('w') {|f| f.puts DATA.read.force_encoding("ASCII-8BIT")
    .gsub('__actioncard_zero__', "")
    .gsub('__feat_zero__', "")
    .gsub('__passive_skill_zero__', "")
    .gsub('__cc_zero__', "")
    .gsub('__avatritem_zero__', "")
    .gsub('__eventcard_zero__', "")
    .gsub('__quest_zero__', "")
    .gsub('__questland_zero__', "")
    .gsub('__questmap_zero__', "")
    .gsub('__weapon_zero__', "")
    .gsub('__rmi_zero__', "")
    .gsub('__lot_zero__', "")
    .gsub('__ap_zero__', "")
    .gsub('__achievement_zero__', "")
    .gsub('__profound_data_zero__', "")
    .gsub('__prf_trs_data_zero__', "")
    .gsub('__chara_zero__', "")
    .gsub!('__actioncarddata__'.force_encoding("ASCII-8BIT"), ac_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__featdata__'.force_encoding("ASCII-8BIT"), feat_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__passiveskilldata__'.force_encoding("ASCII-8BIT"), passive_skill_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__ccdata__'.force_encoding("ASCII-8BIT"), cc_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__avatritemdata__'.force_encoding("ASCII-8BIT"), ai_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__eventcarddata__'.force_encoding("ASCII-8BIT"), ec_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__questdata__'.force_encoding("ASCII-8BIT"), quest_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__questlanddata__'.force_encoding("ASCII-8BIT"), quest_land_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__questmapdata__'.force_encoding("ASCII-8BIT"), quest_map_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__weapondata__'.force_encoding("ASCII-8BIT"), wc_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__lotdata__'.force_encoding("ASCII-8BIT"), rare_card_lot_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__rmidata__'.force_encoding("ASCII-8BIT"), real_money_item_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__apdata__'.force_encoding("ASCII-8BIT"), ap_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__shopdata__'.force_encoding("ASCII-8BIT"), shop_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__achidata__'.force_encoding("ASCII-8BIT"), achievement_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__prfdata__'.force_encoding("ASCII-8BIT"), profound_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__prf_trs_data__'.force_encoding("ASCII-8BIT"), prf_trs_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__charadata__'.force_encoding("ASCII-8BIT"), chara_data.force_encoding("ASCII-8BIT").gsub("\\", "\\\\\\"))
    .gsub!('__init_func__'.force_encoding("ASCII-8BIT"), init_func_str.force_encoding("ASCII-8BIT"))
  }
else
  cc_data = get_data_csv_str(Unlight::CharaCard);
  ac_data = csv_output(Unlight::ActionCard,[:id,:u_type,:u_value,:b_type,:b_value,:event_no,:image,:caption]);
  wc_data = get_data_csv_str(Unlight::WeaponCard)
  feat_data = get_data_csv_str(Unlight::Feat);
  passive_skill_data = get_data_csv_str(Unlight::PassiveSkill);
  ai_data = csv_output(Unlight::AvatarItem,[:id,:name,:item_no,:kind,:sub_kind,:cond,:image,:image_frame,:effect_image,:caption]);
  ec_data = csv_output(Unlight::EventCard,[:id,:name,:event_no,:card_cost,:color,:max_in_deck,:restriction,:image,:caption]);
  quest_data = get_data_csv_str(Unlight::Quest);
  quest_land_data = get_data_csv_str(Unlight::QuestLand);
  quest_map_data = csv_output(Unlight::QuestMap,[:id, :name, :caption, :region ,:level, :ap, :difficulty]);
  rare_card_lot_data = csv_output(Unlight::RareCardLot,[:id,:lot_kind,:article_kind,:article_id,:order,:visible,:description,:num])
  real_money_item_data = csv_output(Unlight::RealMoneyItem,[:id,:name,:price,:rm_item_type,:item_id,:num,:order, :state,:image_url,:tab,:description,:view_frame,:extra_id,:sale_type,:deck_image_url])
  ap_data = get_data_csv_str(Unlight::AvatarPart);
  shop_data = Unlight::Shop::get_sale_list_str
  achievement_data = get_data_csv_str(Unlight::Achievement)
  profound_data = get_data_csv_str(Unlight::ProfoundData)
  prf_trs_data = csv_output(Unlight::ProfoundTreasureData,[:id,:level,:prf_trs_type,:rank_min,:rank_max,:treasure_type,:treasure_id,:slot_type,:value]);
  chara_data = get_data_csv_str(Unlight::Charactor)

  file = Pathname.new(filename)

  init_func_str = <<"EOS"
        public static function dataInit(msg:String):void
        {
            __dec_msg = msg;
            var i:int = 0;
            var cst_data_len:int = DATA.length;
            for ( i = 0; i < cst_data_len; i++ ) {
                 __DATA[i] = DATA[i];
            }
            log.writeLog(log.LV_INFO, "[ConstData] dataInit is Success.");
            __isInit = true;
        }

EOS

  cc_zero_str = "[0,\"\",\"\",0,0,0,0,0,0,0,\"\",\"\",\"\",\"\",\"\",\"\",0,0,0, \"\", \"\",0,\"\","
  cc_zero_str << ",[]" if $add_chara_story
  cc_zero_str << "],"

  file.open('w') {|f| f.puts DATA.read
    .gsub('__actioncard_zero__', "            [0,0,0,0,0,0,\"\",\"\"],")
    .gsub('__feat_zero__', "            [0,\"\",\"\",\"\"],")
    .gsub('__passive_skill_zero__', "            [0,0,\"\",\"\",\"\",\"\"],")
    .gsub('__cc_zero__', "            #{cc_zero_str}")
    .gsub('__avatritem_zero__', "            [0, \"\", 0, 0, \"\", \"\", \"\",0,\"\",\"\"],")
    .gsub('__eventcard_zero__', "            [0, \"\", 0, 0, 0, 0, \"\", \"\", \"\"],")
    .gsub('__quest_zero__', "            [0, \"\", \"\", 0, 0, 0, 0, \"\", \"\", 0, 0],")
    .gsub('__questland_zero__', "            [0, \"\",  0, 0, 0, 0, \"\"],")
    .gsub('__questmap_zero__', "            [0, \"\", \"\", 0, 0, 0, 0],")
    .gsub('__weapon_zero__', "            [0, \"\", 0, 0, [], \"\", \"\",0,0,0,0,0,0,[]],")
    .gsub('__rmi_zero__', "            [0,\"\",0,0,0,0,0,0,\"\",0,\"\",0,0,0,\"\"],")
    .gsub('__lot_zero__', "            [0, 0, 0, 0, 0, 0, \"\"],")
    .gsub('__ap_zero__', "            [0, \"\", \"\", 0, 0, 0, 0, 0,0,0,0,\"\"],")
    .gsub('__achievement_zero__', "            [0, 0,\"\",\"\",0,\"\"],")
    .gsub('__profound_data_zero__', "            [0, 0,\"\",0,0,0,0,0,\"\",0,\"\",\"\",0],")
    .gsub('__prf_trs_data_zero__', "            [0,0,0,0,0,0,0,0,0],")
    .gsub('__chara_zero__', "            [0, \"\",\"\"],")
    .gsub('__actioncarddata__', ac_data.force_encoding("UTF-8"))
    .gsub('__featdata__', feat_data.force_encoding("UTF-8"))
    .gsub('__passiveskilldata__', passive_skill_data.force_encoding("UTF-8"))
    .gsub('__ccdata__', cc_data.force_encoding("UTF-8"))
    .gsub('__avatritemdata__', ai_data.force_encoding("UTF-8"))
    .gsub('__eventcarddata__', ec_data.force_encoding("UTF-8"))
    .gsub('__questdata__', quest_data.force_encoding("UTF-8"))
    .gsub('__questlanddata__', quest_land_data.force_encoding("UTF-8"))
    .gsub('__questmapdata__', quest_map_data.force_encoding("UTF-8"))
    .gsub('__weapondata__', wc_data.force_encoding("UTF-8"))
    .gsub('__lotdata__', rare_card_lot_data.force_encoding("UTF-8"))
    .gsub('__rmidata__', real_money_item_data.force_encoding("UTF-8"))
    .gsub('__apdata__', ap_data.force_encoding("UTF-8"))
    .gsub('__shopdata__', shop_data.force_encoding("UTF-8"))
    .gsub('__achidata__', achievement_data.force_encoding("UTF-8"))
    .gsub('__prfdata__', profound_data.force_encoding("UTF-8"))
    .gsub('__prf_trs_data__', prf_trs_data.force_encoding("UTF-8"))
    .gsub('__charadata__', chara_data.force_encoding("UTF-8"))
    .gsub('__init_func__', init_func_str.force_encoding("UTF-8"))
  }
end



__END__
package model.utils
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.net.SharedObject;
    import com.hurlant.crypto.symmetric.ICipher;
    import com.hurlant.crypto.symmetric.IVMode;
    import com.hurlant.crypto.symmetric.IMode;
    import com.hurlant.crypto.symmetric.NullPad;
    import com.hurlant.crypto.symmetric.PKCS5;
    import com.hurlant.crypto.symmetric.IPad;
    import com.hurlant.crypto.prng.Random;
    import com.hurlant.crypto.hash.HMAC;
    import com.hurlant.util.Base64;
    import com.hurlant.util.Hex;
    import com.hurlant.crypto.Crypto;
    import com.hurlant.crypto.hash.IHash;
    /**
     * モデルの定義済み数値ファイル
     *
     *
     */
    public class ConstData
    {
        public static const ACTION_CARD:int     = 0;
        public static const FEAT:int            = 1;
        public static const PASSIVE_SKILL:int   = 2;
        public static const CHARA_CARD:int      = 3;
        public static const AVATAR_ITEM:int     = 4;
        public static const EVENT_CARD:int      = 5;
        public static const QUEST:int           = 6;
        public static const QUEST_LAND:int      = 7;
        public static const QUEST_MAP:int       = 8;
        public static const WEAPON_CARD:int     = 9;
        public static const RARE_CARD_LOT:int   = 10;
        public static const REAL_MONEY_ITEM:int = 11;
        public static const AVATAR_PART:int     = 12;
        public static const SHOP:int            = 13;
        public static const ACHIEVEMENT:int     = 14;
        public static const PROFOUND_DATA:int   = 15;
        public static const PRF_TRS_DATA:int    = 16;
        public static const CHARACTOR:int       = 17;
        private static var __id:int;

        public static const ACTION_CARD_DATA:Array = [
__actioncard_zero__
__actioncarddata__
            ];

       public static const FEAT_DATA:Array = [
__feat_zero__
__featdata__
     ];
       public static const CHARA_CARD_DATA:Array = [
__cc_zero__
__ccdata__
     ];
        public static const AVATAR_ITEM_DATA:Array = [
__avatritem_zero__
__avatritemdata__
            ];

        public static const EVENT_CARD_DATA:Array = [
__eventcard_zero__
__eventcarddata__
            ];

        public static const QUEST_DATA:Array = [
__quest_zero__
__questdata__
            ];

//   0       1      2    3    4    5    6
//  :int, :String,:int,:int,:int, :int,:String,

        public static const QUEST_LAND_DATA:Array = [
__questland_zero__
__questlanddata__
            ];
//      0        1         2    3     4     5     6
    // :int,:String, :String, :int, :int, :int, :int,
        public static const QUEST_MAP_DATA:Array = [
__questmap_zero__
__questmapdata__
            ];
//      0    1       2     3     4       5       6
     // :int,:String :int, :int, :Array,:String,:String,
        public static const WEAPON_CARD_DATA:Array = [
__weapon_zero__
__weapondata__
            ];

//      0     1     2     3     4     5        6
     // :int, :int, :int, :int, :int, :String, :int
        public static const RARE_CARD_LOT_DATA:Array = [
__lot_zero__
__lotdata__
            ];

//      0     1       2     3     4     5     6    7    8       9    10
     // :int, :String,:int, :int, :int, :int, :int,:int,:String,:int,:String
        public static const REAL_MONEY_ITEM_DATA:Array = [
__rmi_zero__
__rmidata__
            ];

      //[:id,:name,:image,:parts_type,:color,:offset_x,:offset_y,:offset_scale,:power_type,:power,:duration,:caption]);
//      0     1       2       3     4     5     6     7
     // :int, :String,:String,:int, :int, :int, :int, :int,:int,:int,:int,:String
        public static const AVATAR_PART_DATA:Array = [
__ap_zero__
__apdata__
            ];

      //[:id,:name,:image,:parts_type,:color,:offset_x,:offset_y,:offset_scale,:power_type,:power,:duration,:caption]);
//      0     1       2       3     4     5     6     7
     // :int, :String,:String,:int, :int, :int, :int, :int,:int,:int,:int,:String
        public static const SHOP_DATA:Array = [
__shopdata__
            ];


      //[:id,:kind,:caption,:exp,]);
//      0     1    2      ,3      ,4      ,5    ,6
     // :int, :int,:String,:String,:String
        public static const ACHIEVEMENT_DATA:Array = [
__achievement_zero__
__achidata__
            ];

        // [:id,:prf_type,:name,:rarity,:level,:ttl,:quest_map_id,:treasure_data,:stage,:boss_name,:boss_max_hp,:caption,:allItems]
        public static const PROFOUND_DATAS:Array = [
__profound_data_zero__
__prfdata__
            ];

        // [:id,:level,:prf_trs_type,:rank_min,:rank_max,:treasure_type,:treasure_id,:slot_type,:value]
        public static const PRF_TRS_DATAS:Array = [
__prf_trs_data_zero__
__prf_trs_data__
            ];

         public static const PASSIVE_SKILL_DATA:Array = [
                                                         __passive_skill_zero__
                                                         __passiveskilldata__
                                                        ];

      //[:id,:name,:lobby_image]);
      // 0     1
      // :int,:String,:String
        public static const CHARACTOR_DATA:Array = [
__chara_zero__
__charadata__
            ];

      public static const DATA:Array = [
                                        ACTION_CARD_DATA,
                                        FEAT_DATA,
                                        PASSIVE_SKILL_DATA,
                                        CHARA_CARD_DATA,
                                        AVATAR_ITEM_DATA,
                                        EVENT_CARD_DATA,
                                        QUEST_DATA,
                                        QUEST_LAND_DATA,
                                        QUEST_MAP_DATA,
                                        WEAPON_CARD_DATA,
                                        RARE_CARD_LOT_DATA,
                                        REAL_MONEY_ITEM_DATA,
                                        AVATAR_PART_DATA,
                                        SHOP_DATA,
                                        ACHIEVEMENT_DATA,
                                        PROFOUND_DATAS,
                                        PRF_TRS_DATAS,
                                        CHARACTOR_DATA,
                                       ];

        private static var __DATA:Array = [];
        private static var __dec_msg:String = "";
        private static var __isInit:Boolean = false;

__init_func__

        public static function isInited():Boolean
        {
            return __isInit;
        }

        public static function getData(type:int, id:int):Array
        {
            __id = id;
            return  __DATA[type].filter(getID)[0];
        }

        public static function getDataList(type:int):Array
        {
            return __DATA[type];
        }

        private static function getID(item:*, index:int, array:Array):Boolean
        {
           return item[0] == __id;
        }

        private static function decrypt(text:String):Array
        {
           var kdata:ByteArray;
           kdata = Hex.toArray(Hex.fromString(__dec_msg));

           var data:ByteArray;
           data =  Base64.decodeToByteArray(text);

           var name:String;
           name = "rc4-cbc";

           var pad:IPad = new PKCS5;
           var mode:ICipher = Crypto.getCipher( name, kdata, pad );
           pad.setBlockSize(mode.getBlockSize());
           if ( mode is IVMode ) {
               var ivmode:IVMode = mode as IVMode;
               ivmode.IV = Hex.toArray(text);
           }
           mode.decrypt(data);
           data.position = 0;
           var data_arr:Array = data.readObject();
           return data_arr;
        }
    }
}
