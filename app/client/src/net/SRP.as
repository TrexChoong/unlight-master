package net
{
    import flash.utils.ByteArray;
    import com.hurlant.crypto.hash.SHA1;
    import com.hurlant.math.BigInteger;
    import com.hurlant.util.Hex;
    /**
     * SRP(Secure Remote Password protocol)のクラス
     * ->http://srp.stanford.edu/index.html
     */
    public class SRP
    {
        private var N:BigInteger;
        private var g:BigInteger;
        private var salt:String;
        private var x:BigInteger = null;
        private var v:BigInteger = null;
        private var a:BigInteger = null;
        private var b:BigInteger = null;
        private var A:BigInteger = null;
        private var B:BigInteger = null;
        private var u:BigInteger = null;
        private var k:BigInteger = null;
        private var Sc:BigInteger = null;
        private var Ss:BigInteger = null;
        private var one:BigInteger = new BigInteger('1');
        private var two:BigInteger = new BigInteger('2');
        private var three:BigInteger = new BigInteger('3');
        private var proto:String  ;// 3 or 6 or 6a
        private static const LARGE_PRIME:String = '115b8b692e0e045692cf280b436735c77a5a9e8a9e7ed56c965f87db5b2a2ece3';
        private var sha1:SHA1 = new SHA1();
        /**
         * コンストラクタ
         * @param nn 十分に大きな素数
         * @param gg 基数
         * @param pp プロトコルのバージョン
         *
         */
        public function SRP(nn:String = LARGE_PRIME, gg:int = 2, pp:String = '6a')
        {
            N = new BigInteger(nn);
            validate_N();
            g = BigInteger.nbv(gg);
            validate_g();
            k = compute_k(N,g)
                proto = pp;
        }

        /**
         * クライアント公開鍵の取得
         * @param randNum ランダムな数（HEX）
         *
         */
        public function getClientPublicKey (randNum:String) :String
        {
            return compute_A(new BigInteger(randNum)).toString();
        }

        /**
         * ランダムな数を返す
         * @return HEXで返す
         *
         */
        public function genRndBigNum () :String
        {
            var now:Date = new Date();
            var s:String;
            var src:ByteArray = new ByteArray;
            s=(now.milliseconds+Math.random()).toString();
            src.writeUTFBytes(s+"oraora");
            return Hex.fromArray(sha1.hash(src));
//            return("38fab1387185519574947b527c985c1644f68bb4")

        }


        /**
         * プライベートキーの取得
         * @param username ＩＤとなる文字列
         * @param password パスワード
         * @param salt salt
         * @return プライベートキーとなる文字列
         *
         */
        public function getPrivateKey (username:String, password:String, salt:String) :String
        {
            return compute_x(username, password, salt).toString();
        }


        /**
         * Verifireの取得
         *
         */
        public function getVerifire (username:String, password:String, salt:String) :String
        {
            return compute_v(new BigInteger(getPrivateKey(username,password,salt))).toString();
        }


        // セッションキーの取得
        public function getSessionKey (clientPkey:String, serverPkey:String, privatekey:String, randNum:String) :String
        {
            return compute_client_S(
                new BigInteger(serverPkey),
                new BigInteger(privatekey),
                compute_u(new BigInteger(clientPkey),
                          new BigInteger(serverPkey)),
                new BigInteger(randNum)).toString();
        }

        // ストロングキーの取得
        public function getStrongKey (sessionkey:String) :String
        {
            var src:ByteArray =new ByteArray;
            src.writeBytes(alignHexToArray(sessionkey));
            return Hex.fromArray(sha1.hash(src));
        }

        // 認証
        public function getMatcher (clientPkey:String, serverPkey:String, username:String, salt:String, strongkey:String ) :String
        {
            var src1:ByteArray = new ByteArray;
            var src2:ByteArray = new ByteArray;
            var src3:ByteArray = new ByteArray;
            src1.writeBytes(Hex.toArray(N.toString()));
            src2.writeBytes(alignHexToArray(g.toString()));
            src3.writeUTFBytes(username);
            var tmp1:String =  Hex.fromArray(xor(sha1.hash(src1),sha1.hash(src2)));
            var tmp2:String =  Hex.fromArray(sha1.hash(src3));
            var src:ByteArray =new ByteArray;

            src.writeBytes(alignHexToArray(tmp1+tmp2+salt+clientPkey+serverPkey+strongkey));
            return Hex.fromArray(sha1.hash(src));
        }

        // 証明
        public function getCert (clientPkey:String, matcher:String, strongkey:String ) :String
        {
            var src:ByteArray =new ByteArray;
            src.writeBytes(alignHexToArray(clientPkey+matcher+strongkey));
            return Hex.fromArray(sha1.hash(src));
        }


        public function genSalt():String
        {
            return genRndBigNum();
        }


/* Returns a string with n zeroes in it */
        private function nzero(n:int) :String
        {
            if(n < 1)
            {
                return "";
            }
            var t:String = nzero(n >> 1);
            if((n & 1) == 0)
            {
                return t + t;
            }
            else
            {
                return t + t + "0";
            }
        }

/* 奇数のHexをalignしてArrayに */
        private function alignHexToArray(hex:String) :ByteArray
        {
            var r:String;
            var len:int;
            len = hex.length;
            if (len &1)//||(len ==268))
            { r= hex.slice(0,len-1)+"0"+hex.charAt(len-1)}
            else
            {r = hex}
            return Hex.toArray(r);

        }

/*
 * SRP client/server helper functions.
 * Most of the "nuts and bolts" of computing the various intermediate
 * SRP values are in these functions.
 */

/* x = H(salt || H(username || ":" || password)) */
        private function compute_x(username:String, password:String, s:String):BigInteger
        {
            // Inner hash: SHA-1(username || ":" || password)
            var src1:ByteArray = new ByteArray;
            src1.writeUTFBytes(username + ":" + password);
            var ih:ByteArray = sha1.hash(src1);
//            log.writeLog(log.LV_DEBUG, "SRP","x ih is "+Hex.fromArray(ih));
            // Outer hash: SHA-1(salt || inner_hash)
            // This assumes that the hex salt string has an even number of characters...
            var src2:ByteArray = new ByteArray;
            src2 = alignHexToArray(s+Hex.fromArray(ih));
            var oh:ByteArray = sha1.hash(src2);
//            log.writeLog(log.LV_DEBUG, "SRP","x oh is "+Hex.fromArray(oh));
            oh.position=0;
            var xtmp:BigInteger = new BigInteger(oh); // test用ログ

//             log.writeLog(log.LV_DEBUG, "SRP","x xtmp is "+xtmp.toString());
//             log.writeLog(log.LV_DEBUG, "SRP","x xtmdebug "+log.LV_DEBUG);
            if(xtmp.compareTo(N) < 0) {
                return xtmp;
            }
            else {
                return xtmp.mod(N.subtract(one));
            }
        }
/*
 * SRP-3: u = first 32 bits (MSB) of SHA-1(B)
 * SRP-6(a): u = SHA-1(A || B)
 */
        private function compute_u(av:BigInteger, bv:BigInteger):BigInteger
        {
            var ahex:String;
            var bhex:String = bv.toString();
            var hashin:String = "";
            var utmp:BigInteger;
            var nlen:int;
            var src:ByteArray = new ByteArray;
            var tmp:ByteArray = new ByteArray;
            if(proto != "3") {
                ahex = av.toString();
                if(proto == "6") {
                    if((ahex.length & 1) == 0) {
                        hashin += ahex;
                    }
                    else {
                        hashin += "0" + ahex;
                    }
                }
                else { /* 6a requires left-padding */
                    nlen = 2 * ((N.bitLength() + 7) >> 3);
                    hashin += nzero(nlen - ahex.length) + ahex;
                }
            }
            if(proto == "3" || proto == "6") {
                if((bhex.length & 1) == 0) {
                    hashin += bhex;
                }
                else {
                    hashin += "0" + bhex;
                }
            }
            else { /* 6a requires left-padding; nlen already set above */
                hashin += nzero(nlen - bhex.length) + bhex;
            }
            if(proto == "3") {
                src.writeBytes(alignHexToArray(hashin));
                tmp = alignHexToArray(Hex.fromArray(sha1.hash(src)).substr(0, 8));
                tmp.position=0;
                utmp = new BigInteger(tmp);
            }
            else {
                src.writeBytes(alignHexToArray(hashin));
                tmp = sha1.hash(src);
                tmp.position=0;
                utmp = new BigInteger(tmp);
            }
            if(utmp.compareTo(N) < 0) {
                return utmp;
             }
             else {
                 return utmp.mod(N.subtract(one));
             }
         }


        private function compute_k(NN:BigInteger, gg:BigInteger) :BigInteger
        {
            var nhex:String;
            var ghex:String;
            var hashin:String = "";
            var ktmp:BigInteger;
            var src:ByteArray = new ByteArray;
            var tmp:ByteArray = new ByteArray;

            if(proto == "3")
                return one;
            else if(proto == "6")
                return three;
            else {
                /* SRP-6a: k = H(N || g) */
                nhex = NN.toString();
                if((nhex.length & 1) == 0) {
                    hashin += nhex;
                }
                else {
                    hashin += "0" + nhex;
                }
                ghex = gg.toString();
                src.writeBytes(alignHexToArray(hashin));
                src.writeBytes(alignHexToArray(nzero(nhex.length - ghex.length)+ghex)) ;
                tmp = sha1.hash(src);
                tmp.position=1;
                ktmp = new BigInteger(Hex.fromArray(tmp));
                if(ktmp.compareTo(NN) < 0) {
                    return ktmp;
                }
                else {
                    return ktmp.mod(NN);
                }
            }
        }

/* S = (B - kg^x) ^ (a + ux) (mod N) */
        private function compute_client_S(BB:BigInteger, xx:BigInteger, uu:BigInteger, aa:BigInteger):BigInteger
        {
            var bx:BigInteger = g.modPow(xx, N);
            var btmp:BigInteger = BB.add(N.multiply(k)).subtract(bx.multiply(k)).mod(N);
            return btmp.modPow(xx.multiply(uu).add(aa), N);
        }

        private function compute_v(xx:BigInteger):BigInteger
        {
            v = g.modPow(xx, N);
            return v;
        }

        private function compute_A(aa:BigInteger) :BigInteger
        {
            A = g.modPow(aa, N);
            return A;
        }

        private function compute_B (b:BigInteger,vv:BigInteger) :BigInteger
        {
            var bb:BigInteger = g.modPow(b, N);
            B = bb.add(vv.multiply(k)).mod(N);
            return B;
        }

        private function validate_N():void
        {
            if(!N.isProbablePrime(10)) 
            {
                log.writeLog(log.LV_WARN, "SRP", "N is not prime.");
                throw new Error("Warning: N is not prime.");
            }
            else if(!N.subtract(one).divide(two).isProbablePrime(10)) {
                log.writeLog(log.LV_WARN,  "SRP", "(N-1)/2 is not prime.");
                throw new Error("Warning: (N-1)/2 is not prime.");
            }
        }

        private function validate_g():void
        {
            if(g.modPow(N.subtract(one).divide(two), N).add(one).compareTo(N) != 0) {
                log.writeLog(log.LV_WARN, "SRP","g is not a primitive root.");
                throw new Error("Warning: g is not a primitive root.");
            }
        }

        private function xor(str_a:ByteArray,cryp_a:ByteArray):ByteArray
        {
            var des_a:ByteArray = new ByteArray;
            var ln:uint = cryp_a.length;
            var i:uint;
            str_a.position = 0;
            cryp_a.position = 0;
            for (i = 0 ;i < str_a.length; i++)
            {
                des_a[i] = str_a[i]^cryp_a[i%ln];
            }
            des_a.position = 0;
//            log.writeLog(log.LV_TEST, "xor result", des_a)
            return des_a;
        }


    }
}