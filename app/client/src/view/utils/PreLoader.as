package view.utils
{
     import flash.events.*;

     import mx.containers.*;
     import mx.controls.*;
     import mx.events.*;

     import model.events.*;
     import model.*;

     import view.image.common.*;
     import view.scene.common.*;

     public class PreLoader extends Object
     {
         private static var _load_001:AvatarPartImage = new AvatarPartImage("base_a000_p27");
         private static var _load_002:AvatarPartImage = new AvatarPartImage("base_a000_p31");
         private static var _load_003:AvatarPartImage = new AvatarPartImage("base_a000_p33");
         private static var _load_004:AvatarPartImage = new AvatarPartImage("base_a000_p44");
         private static var _load_005:AvatarPartImage = new AvatarPartImage("base_a000_p48");
         private static var _load_006:AvatarPartImage = new AvatarPartImage("base_a000_p51");
         private static var _load_007:AvatarPartImage = new AvatarPartImage("base_a000_p53");
         private static var _load_008:AvatarPartImage = new AvatarPartImage("base_a000_p55");
         private static var _load_009:AvatarPartImage = new AvatarPartImage("base_a000_p59");
         private static var _load_010:AvatarPartImage = new AvatarPartImage("base_a000_p62");
         private static var _load_011:AvatarPartImage = new AvatarPartImage("base_a000_p67");
         private static var _load_012:AvatarPartImage = new AvatarPartImage("base_a000_p81");
         private static var _load_013:AvatarPartImage = new AvatarPartImage("base_a000_p85");
         private static var _load_014:AvatarPartImage = new AvatarPartImage("base_a000_p87");
         private static var _load_015:AvatarPartImage = new AvatarPartImage("base_a000_p97");
         private static var _load_016:AvatarPartImage = new AvatarPartImage("blouse_a000a_p31");
         private static var _load_017:AvatarPartImage = new AvatarPartImage("blouse_a000a_p33");
         private static var _load_018:AvatarPartImage = new AvatarPartImage("blouse_a000a_p67");
         private static var _load_019:AvatarPartImage = new AvatarPartImage("blouse_a000a_p85");
         private static var _load_020:AvatarPartImage = new AvatarPartImage("blouse_a000a_p87");
         private static var _load_021:AvatarPartImage = new AvatarPartImage("eye_a000a_p102");
         private static var _load_022:AvatarPartImage = new AvatarPartImage("eye_a000b_p102");
         private static var _load_023:AvatarPartImage = new AvatarPartImage("eye_a000c_p102");
         private static var _load_024:AvatarPartImage = new AvatarPartImage("eye_a000d_p102");
         private static var _load_025:AvatarPartImage = new AvatarPartImage("eye_a000e_p102");
         private static var _load_026:AvatarPartImage = new AvatarPartImage("eye_a001a_p102");
         private static var _load_027:AvatarPartImage = new AvatarPartImage("eye_a001b_p102");
         private static var _load_028:AvatarPartImage = new AvatarPartImage("eye_a001c_p102");
         private static var _load_029:AvatarPartImage = new AvatarPartImage("eye_a001d_p102");
         private static var _load_030:AvatarPartImage = new AvatarPartImage("eye_a001e_p102");
         private static var _load_031:AvatarPartImage = new AvatarPartImage("eye_a002a_p102");
         private static var _load_032:AvatarPartImage = new AvatarPartImage("eye_a002b_p102");
         private static var _load_033:AvatarPartImage = new AvatarPartImage("eye_a002c_p102");
         private static var _load_034:AvatarPartImage = new AvatarPartImage("eye_a002d_p102");
         private static var _load_035:AvatarPartImage = new AvatarPartImage("eye_a002e_p102");
         private static var _load_036:AvatarPartImage = new AvatarPartImage("hair_a000a_p108");
         private static var _load_037:AvatarPartImage = new AvatarPartImage("hair_a000a_p18");
         private static var _load_038:AvatarPartImage = new AvatarPartImage("hair_a000b_p108");
         private static var _load_039:AvatarPartImage = new AvatarPartImage("hair_a000b_p18");
         private static var _load_040:AvatarPartImage = new AvatarPartImage("hair_a000c_p108");
         private static var _load_041:AvatarPartImage = new AvatarPartImage("hair_a000c_p18");
         private static var _load_042:AvatarPartImage = new AvatarPartImage("hair_b000a_p108");
         private static var _load_043:AvatarPartImage = new AvatarPartImage("hair_b000a_p18");
         private static var _load_044:AvatarPartImage = new AvatarPartImage("hair_b000b_p108");
         private static var _load_045:AvatarPartImage = new AvatarPartImage("hair_b000b_p18");
         private static var _load_046:AvatarPartImage = new AvatarPartImage("hair_b000c_p108");
         private static var _load_047:AvatarPartImage = new AvatarPartImage("hair_b000c_p18");
         private static var _load_048:AvatarPartImage = new AvatarPartImage("hair_d000a_p108");
         private static var _load_049:AvatarPartImage = new AvatarPartImage("hair_d000a_p18");
         private static var _load_050:AvatarPartImage = new AvatarPartImage("hair_d000a_p94");
         private static var _load_051:AvatarPartImage = new AvatarPartImage("hair_d000b_p108");
         private static var _load_052:AvatarPartImage = new AvatarPartImage("hair_d000b_p18");
         private static var _load_053:AvatarPartImage = new AvatarPartImage("hair_d000b_p94");
         private static var _load_054:AvatarPartImage = new AvatarPartImage("hair_d000c_p108");
         private static var _load_055:AvatarPartImage = new AvatarPartImage("hair_d000c_p18");
         private static var _load_056:AvatarPartImage = new AvatarPartImage("hair_d000c_p94");
         private static var _load_057:AvatarPartImage = new AvatarPartImage("skirt_a000a_p69");
         private static var _load_058:AvatarPartImage = new AvatarPartImage("shoes_a000a_p48");
         private static var _load_059:AvatarPartImage = new AvatarPartImage("shoes_a000a_p51");
         private static var _load_060:AvatarPartImage = new AvatarPartImage("shoes_a000a_p59");
         private static var _load_061:AvatarPartImage = new AvatarPartImage("shoes_a000a_p62");
         private static var _load_062:AvatarPartImage = new AvatarPartImage("dress_a004a_p31");
         private static var _load_063:AvatarPartImage = new AvatarPartImage("dress_a004a_p33");
         private static var _load_064:AvatarPartImage = new AvatarPartImage("dress_a004a_p64");
         private static var _load_065:AvatarPartImage = new AvatarPartImage("dress_a004a_p67");
         private static var _load_066:AvatarPartImage = new AvatarPartImage("dress_a004a_p85");
         private static var _load_067:AvatarPartImage = new AvatarPartImage("dress_a004a_p87");
         private static var _load_068:AvatarPartImage = new AvatarPartImage("dress_a004b_p31");
         private static var _load_069:AvatarPartImage = new AvatarPartImage("dress_a004b_p33");
         private static var _load_070:AvatarPartImage = new AvatarPartImage("dress_a004b_p64");
         private static var _load_071:AvatarPartImage = new AvatarPartImage("dress_a004b_p67");
         private static var _load_072:AvatarPartImage = new AvatarPartImage("dress_a004b_p85");
         private static var _load_073:AvatarPartImage = new AvatarPartImage("dress_a004b_p87");
         private static var _load_074:AvatarPartImage = new AvatarPartImage("dress_a004c_p31");
         private static var _load_075:AvatarPartImage = new AvatarPartImage("dress_a004c_p33");
         private static var _load_076:AvatarPartImage = new AvatarPartImage("dress_a004c_p64");
         private static var _load_077:AvatarPartImage = new AvatarPartImage("dress_a004c_p67");
         private static var _load_078:AvatarPartImage = new AvatarPartImage("dress_a004c_p85");
         private static var _load_079:AvatarPartImage = new AvatarPartImage("dress_a004c_p87");
         private static var _load_080:AvatarPartImage = new AvatarPartImage("dress_b000a_p67");
         private static var _load_081:AvatarPartImage = new AvatarPartImage("dress_b000b_p67");
         private static var _load_082:AvatarPartImage = new AvatarPartImage("ribbon_a000a_p112");
         private static var _load_083:AvatarPartImage = new AvatarPartImage("ribbon_a001a_p112");
         private static var _load_084:AvatarPartImage = new AvatarPartImage("ribbon_a001b_p112");
         private static var _load_085:AvatarPartImage = new AvatarPartImage("hairpin_a000a_p117");
         private static var _load_086:AvatarPartImage = new AvatarPartImage("hairpin_a000b_p117");
         private static var _load_087:AvatarPartImage = new AvatarPartImage("shoes_c000a_p51");
         private static var _load_088:AvatarPartImage = new AvatarPartImage("shoes_c000a_p62");
         private static var _load_089:AvatarPartImage = new AvatarPartImage("shoes_c000b_p51");
         private static var _load_090:AvatarPartImage = new AvatarPartImage("shoes_c000b_p62");

         private static var _loadIcon44:AvatarPartIconImage = new AvatarPartIconImage(44);
         private static var _loadIcon45:AvatarPartIconImage = new AvatarPartIconImage(45);
         private static var _loadIcon46:AvatarPartIconImage = new AvatarPartIconImage(46);
         private static var _loadIcon47:AvatarPartIconImage = new AvatarPartIconImage(47);
         private static var _loadIcon48:AvatarPartIconImage = new AvatarPartIconImage(48);
         private static var _loadIcon49:AvatarPartIconImage = new AvatarPartIconImage(49);
         private static var _loadIcon50:AvatarPartIconImage = new AvatarPartIconImage(50);
         private static var _loadIcon51:AvatarPartIconImage = new AvatarPartIconImage(51);
         private static var _loadIcon52:AvatarPartIconImage = new AvatarPartIconImage(52);
         private static var _loadIcon53:AvatarPartIconImage = new AvatarPartIconImage(53);
         private static var _loadIcon54:AvatarPartIconImage = new AvatarPartIconImage(54);
         private static var _loadIcon55:AvatarPartIconImage = new AvatarPartIconImage(55);
         private static var _loadIcon56:AvatarPartIconImage = new AvatarPartIconImage(56);

         public function PreLoader(enterCheck:Boolean = true)
         {

         }

         public static function rePreLoader():void
         {
             _load_001 = new AvatarPartImage("base_a000_p27");
             _load_002 = new AvatarPartImage("base_a000_p31");
             _load_003 = new AvatarPartImage("base_a000_p33");
             _load_004 = new AvatarPartImage("base_a000_p44");
             _load_005 = new AvatarPartImage("base_a000_p48");
             _load_006 = new AvatarPartImage("base_a000_p51");
             _load_007 = new AvatarPartImage("base_a000_p53");
             _load_008 = new AvatarPartImage("base_a000_p55");
             _load_009 = new AvatarPartImage("base_a000_p59");
             _load_010 = new AvatarPartImage("base_a000_p62");
             _load_011 = new AvatarPartImage("base_a000_p67");
             _load_012 = new AvatarPartImage("base_a000_p81");
             _load_013 = new AvatarPartImage("base_a000_p85");
             _load_014 = new AvatarPartImage("base_a000_p87");
             _load_015 = new AvatarPartImage("base_a000_p97");
             _load_016 = new AvatarPartImage("blouse_a000a_p31");
             _load_017 = new AvatarPartImage("blouse_a000a_p33");
             _load_018 = new AvatarPartImage("blouse_a000a_p67");
             _load_019 = new AvatarPartImage("blouse_a000a_p85");
             _load_020 = new AvatarPartImage("blouse_a000a_p87");
             _load_021 = new AvatarPartImage("eye_a000a_p102");
             _load_022 = new AvatarPartImage("eye_a000b_p102");
             _load_023 = new AvatarPartImage("eye_a000c_p102");
             _load_024 = new AvatarPartImage("eye_a000d_p102");
             _load_025 = new AvatarPartImage("eye_a000e_p102");
             _load_026 = new AvatarPartImage("eye_a001a_p102");
             _load_027 = new AvatarPartImage("eye_a001b_p102");
             _load_028 = new AvatarPartImage("eye_a001c_p102");
             _load_029 = new AvatarPartImage("eye_a001d_p102");
             _load_030 = new AvatarPartImage("eye_a001e_p102");
             _load_031 = new AvatarPartImage("eye_a002a_p102");
             _load_032 = new AvatarPartImage("eye_a002b_p102");
             _load_033 = new AvatarPartImage("eye_a002c_p102");
             _load_034 = new AvatarPartImage("eye_a002d_p102");
             _load_035 = new AvatarPartImage("eye_a002e_p102");
             _load_036 = new AvatarPartImage("hair_a000a_p108");
             _load_037 = new AvatarPartImage("hair_a000a_p18");
             _load_038 = new AvatarPartImage("hair_a000b_p108");
             _load_039 = new AvatarPartImage("hair_a000b_p18");
             _load_040 = new AvatarPartImage("hair_a000c_p108");
             _load_041 = new AvatarPartImage("hair_a000c_p18");
             _load_042 = new AvatarPartImage("hair_b000a_p108");
             _load_043 = new AvatarPartImage("hair_b000a_p18");
             _load_044 = new AvatarPartImage("hair_b000b_p108");
             _load_045 = new AvatarPartImage("hair_b000b_p18");
             _load_046 = new AvatarPartImage("hair_b000c_p108");
             _load_047 = new AvatarPartImage("hair_b000c_p18");
             _load_048 = new AvatarPartImage("hair_d000a_p108");
             _load_049 = new AvatarPartImage("hair_d000a_p18");
             _load_050 = new AvatarPartImage("hair_d000a_p94");
             _load_051 = new AvatarPartImage("hair_d000b_p108");
             _load_052 = new AvatarPartImage("hair_d000b_p18");
             _load_053 = new AvatarPartImage("hair_d000b_p94");
             _load_054 = new AvatarPartImage("hair_d000c_p108");
             _load_055 = new AvatarPartImage("hair_d000c_p18");
             _load_056 = new AvatarPartImage("hair_d000c_p94");
             _load_057 = new AvatarPartImage("skirt_a000a_p69");
             _load_058 = new AvatarPartImage("shoes_a000a_p48");
             _load_059 = new AvatarPartImage("shoes_a000a_p51");
             _load_060 = new AvatarPartImage("shoes_a000a_p59");
             _load_061 = new AvatarPartImage("shoes_a000a_p62");
             _load_062 = new AvatarPartImage("dress_a004a_p31");
             _load_063 = new AvatarPartImage("dress_a004a_p33");
             _load_064 = new AvatarPartImage("dress_a004a_p64");
             _load_065 = new AvatarPartImage("dress_a004a_p67");
             _load_066 = new AvatarPartImage("dress_a004a_p85");
             _load_067 = new AvatarPartImage("dress_a004a_p87");
             _load_068 = new AvatarPartImage("dress_a004b_p31");
             _load_069 = new AvatarPartImage("dress_a004b_p33");
             _load_070 = new AvatarPartImage("dress_a004b_p64");
             _load_071 = new AvatarPartImage("dress_a004b_p67");
             _load_072 = new AvatarPartImage("dress_a004b_p85");
             _load_073 = new AvatarPartImage("dress_a004b_p87");
             _load_074 = new AvatarPartImage("dress_a004c_p31");
             _load_075 = new AvatarPartImage("dress_a004c_p33");
             _load_076 = new AvatarPartImage("dress_a004c_p64");
             _load_077 = new AvatarPartImage("dress_a004c_p67");
             _load_078 = new AvatarPartImage("dress_a004c_p85");
             _load_079 = new AvatarPartImage("dress_a004c_p87");
             _load_080 = new AvatarPartImage("dress_b000a_p67");
             _load_081 = new AvatarPartImage("dress_b000b_p67");
             _load_082 = new AvatarPartImage("ribbon_a000a_p112");
             _load_083 = new AvatarPartImage("ribbon_a001a_p112");
             _load_084 = new AvatarPartImage("ribbon_a001b_p112");
             _load_085 = new AvatarPartImage("hairpin_a000a_p117");
             _load_086 = new AvatarPartImage("hairpin_a000b_p117");
             _load_087 = new AvatarPartImage("shoes_c000a_p51");
             _load_088 = new AvatarPartImage("shoes_c000a_p62");
             _load_089 = new AvatarPartImage("shoes_c000b_p51");
             _load_090 = new AvatarPartImage("shoes_c000b_p62");
             _loadIcon44 = new AvatarPartIconImage(44);
             _loadIcon45 = new AvatarPartIconImage(45);
             _loadIcon46 = new AvatarPartIconImage(46);
             _loadIcon47 = new AvatarPartIconImage(47);
             _loadIcon48 = new AvatarPartIconImage(48);
             _loadIcon49 = new AvatarPartIconImage(49);
             _loadIcon50 = new AvatarPartIconImage(50);
             _loadIcon51 = new AvatarPartIconImage(51);
             _loadIcon52 = new AvatarPartIconImage(52);
             _loadIcon53 = new AvatarPartIconImage(53);
             _loadIcon54 = new AvatarPartIconImage(54);
             _loadIcon55 = new AvatarPartIconImage(55);
             _loadIcon56 = new AvatarPartIconImage(56);
         }







     }
}