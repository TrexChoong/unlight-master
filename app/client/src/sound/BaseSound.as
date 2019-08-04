package sound
{
    import flash.media.*;
    import flash.events.*;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.utils.Timer;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;

    import view.*;

    public class BaseSound
    {
        protected var _vol:int = 100;
        private static var _MASTER_VOL:Number = 1.0;
        protected var _ctrl:SoundCtrl = SoundCtrl.instance;
        protected var _trans:SoundTransform = new SoundTransform ();
        protected var _sound: Sound = new Sound();
        protected var _channel : SoundChannel;

        private static const URL:String = "/public/sound/ulbgm01.mp3";
        private var _loop:Boolean
        private var _tmpvol:int;
        private var _tarvol:int;
        private var _myTimer:Timer;
        private var _counter:int;
        private static var _playList:Vector.<String> = new Vector.<String>();

        private var _multiNum:int = 0; // 同時になっている数
        static private const _PERMIT_NUM:int = 3; // 同時になってもいい数
        static private const _DECAY:Number = 0.2; // 同時になっている場合減衰させる割合


        // コンストラクタ
        public function BaseSound()
        {
            if (url)
            {
                _sound.load(new URLRequest(url));
                _sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            }
        }

        private function errorHandler(errorEvent:IOErrorEvent):void {
            log.writeLog(log.LV_DEBUG,this,errorEvent.text);
            _sound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
        }

        public function PlayingMethod(url:String, method:int=0):void
        {
            switch (method)
            {
            case Const.VOICE_PLAYING_METHOD_ADDITIOAL:
                addPlay(url);
                break;
            case Const.VOICE_PLAYING_METHOD_INTERRUPT:
                interruptPlay(url);
                break;
            case Const.VOICE_PLAYING_METHOD_FORCED:
                forciblyPlay(url);
                break;
            case Const.VOICE_PLAYING_METHOD_EXCLUSIVE:
                exclusivePlay(url);
                break;
            }
        }

        // オーバライド前提
        protected function get url():String
        {
            return URL;
        }

        public function AddPlay(charaId:int, situation:Array, situationId:int=0, otherCharaId:int=0, method:int=0):void
        {
        }

        private function addPlay(url:String):void
        {
            _playList.unshift(url);
        }

        private function interruptPlay(url:String):void
        {
            _playList.push(url);
        }

        private function forciblyPlay(url:String):void
        {
            _playList.splice(0,_playList.length,url);
            stopSound();
        }

        private function exclusivePlay(url:String):void
        {
            if (playing) return;
            addPlay(url);
        }



        // ボリュームセット
        public function set vol(k:int):void
        {
            _vol = k;
            // 再生中なら
            if (_channel != null)
            {
                _trans.volume =  k/100;
                _channel.soundTransform = _trans;
                if(k == 0)
                {
                    stopSound();
                }
            }
        }

        // 一度だけならす
        public function playSound():void
        {
            setOptionVol();
            _trans.volume = _vol/100;
            _channel  = _sound.play(0,1,_trans);
            setChannelToCtrl(_channel);
        }

        // ボイス再生
        public function playVoice():void
        {
            setOptionVolVoice();
            _trans.volume = _vol/100;
            _channel  = _sound.play(0,1,_trans);
            if (_channel)
            {
                _channel.addEventListener(Event.SOUND_COMPLETE, playNextHandler);
                setVoiceChannelToCtrl(_channel);
            }
        }

        // 終わったら再生リストの最後を再生。
        private function playNextHandler (e:Event):void
        {
            if (_playList.length > 0)
            {
                _sound = new Sound();
                _sound.load(new URLRequest(_playList.pop()));
                _sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                playVoice();
            }
        }

        // 一度だけならす ※複数対応
        public function playMultiSound():void
        {
            setOptionVolMulti();
            _trans.volume = _vol/100 - decayPercent();
            _channel  = _sound.play(0,1,_trans);
            setMultiChannelToCtrl(_channel);
        }

        // 同時にならした場合の音をちいさくる割合。
        private function decayPercent():Number
        {
            var num:Number = decay * (_multiNum - permitNum);
            if (num < 0)
            {
                num = 0;
            }else if(num >1) {
                num = 1;
            }
            return num*_vol/100;

        }

        // ループでならす（0の時ずっとループ）
        public function loopSound(k:int):void
        {
            setOptionVol();
            _trans.volume = _vol/100;
            if(k == 0){
                _loop = true;
                playSound();
                if (_channel!=null)
                {
                    _channel.addEventListener(Event.SOUND_COMPLETE, repeatHandler);
                }

            }else{
                setOptionVol();
                _channel  = _sound.play(0,k,_trans);
                setChannelToCtrl(_channel);
            }
        }

        // ループでならす（0の時ずっとループ）
        public function loopMultiSound(k:int):void
        {
//            log.writeLog(log.LV_FATAL, this, "loop");
            setOptionVolMulti();
//          log.writeLog(log.LV_FATAL, this, "loop2",_trans);
            _trans.volume = _vol/100;
            if(k == 0){
//              log.writeLog(log.LV_FATAL, this, "repeat",_channel);
                _loop = true;
                playMultiSound();
                if (_channel!=null)
                {
                    _channel.addEventListener(Event.SOUND_COMPLETE, multiRepeatHandler);
                }

            }else{
                setOptionVolMulti();
                _channel  = _sound.play(0,k,_trans);
                setMultiChannelToCtrl(_channel);
            }
        }

        protected function setOptionVol():void
        {
            _vol = _ctrl.BGMVolume;
        }

        protected function setOptionVolVoice():void
        {
            _vol = _ctrl.CVVolume;
        }

        protected function setOptionVolMulti():void
        {
            _vol = _ctrl.SEVolume;
        }

        // 無限リピート用のハンドラ。終わったらもう一度ならす。
        private function repeatHandler (e:Event):void
        {
            if (_loop)
            {
                loopSound(0);
//                 playSound();
            }
        }

        // 無限リピート用のハンドラ。終わったらもう一度ならす。
        private function multiRepeatHandler(e:Event):void
        {
            if (_loop)
            {
                loopMultiSound(0);
            }
        }

        // 停止
        public function stopSound():void
        {
            if (_channel != null) {
                _loop = false;
                _channel.removeEventListener(Event.SOUND_COMPLETE, repeatHandler);
                _channel.stop();
                _channel.removeEventListener(Event.SOUND_COMPLETE, playNextHandler);
            }
        }

        // フェード
        public function fade(tvol:int,k:int):void
        {
            if (_channel != null) {
                _tarvol= tvol;
                _tmpvol = _vol;
                _counter = 0;
                _myTimer = new Timer(k*1000/10,10);
                _myTimer.addEventListener("timer", fadeTimerHandler);
                _myTimer.addEventListener("timerComplete", fadeComplereHandler);
                _myTimer.start();
            }
        }

        // フェード終了後、タイマーのイベントリスナーを取り除くハンドラ
        private function fadeComplereHandler(e:Event):void
        {
            vol = _tarvol;
            _myTimer.removeEventListener("timer", fadeTimerHandler);
            _myTimer.removeEventListener("timerComplete", fadeComplereHandler);
        }

        // フェードさせていくタイマーハンドラ
        private function fadeTimerHandler(e:TimerEvent):void
        {
            _counter++;
            _tmpvol =_counter/10*(_tarvol - _vol)+_vol;
            //trace(tmpvol);
//            log.writeLog(log.LV_INFO, this, "tmpvol", _tmpvol);
            _trans.volume =  _tmpvol/100;
            if (_channel != null)
            {
                _channel.soundTransform = _trans;
            }
        }

        // コントローラにチャンネルを追加する
        protected function setChannelToCtrl(sc:SoundChannel):void
        {
            if (sc!=null)
            {
                sc.addEventListener(Event.SOUND_COMPLETE, completeChannelHandler);
                _ctrl.addBGM(sc);
            }
        }

        // コントローラからチャンネルを取り除く
        protected function removeChannelToCtrl(sc:SoundChannel):void
        {
            if (sc!=null)
            {
                _ctrl.disposeBGM(sc);
            }
        }

        // コントローラにチャンネルを追加する
        protected function setVoiceChannelToCtrl(sc:SoundChannel):void
        {
            if (sc!=null)
            {
                sc.addEventListener(Event.SOUND_COMPLETE, completeVoiceChannelHandler);
                _ctrl.addCV(sc);
            }
        }

        // コントローラからチャンネルを取り除く
        protected function removeVoiceChannelToCtrl(sc:SoundChannel):void
        {
            if (sc!=null)
            {
                _ctrl.disposeCV(sc);
            }
        }

        // コントローラにチャンネルを追加する
        protected function setMultiChannelToCtrl(sc:SoundChannel):void
        {
            if (sc !=null)
            {
                sc.addEventListener(Event.SOUND_COMPLETE, completeMultiChannelHandler);
                _ctrl.addSE(sc);
                _multiNum++;
            }
        }

        // コントローラからチャンネルを取り除く
        protected function removeMultiChannelToCtrl(sc:SoundChannel):void
        {
            if (sc !=null)
            {
                _ctrl.disposeSE(sc);
                _multiNum--;
            }

        }

        // 終了時にコントローラからチャンネルと取り除くためのハンドラ
        protected function completeChannelHandler(e:Event):void
        {
            removeChannelToCtrl(SoundChannel(e.target));
            e.target.removeEventListener(Event.SOUND_COMPLETE, completeChannelHandler);
            _sound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            // 終わったチャンネルが最後に再生したチャンネルの時チャンネルをNULLにする
            if (SoundChannel(e.target)==_channel)
            {
                _channel =null;
            }
        }
        // 終了時にコントローラからチャンネルと取り除くためのハンドラ
        protected function completeVoiceChannelHandler(e:Event):void
        {
            removeChannelToCtrl(SoundChannel(e.target));
            e.target.removeEventListener(Event.SOUND_COMPLETE, completeVoiceChannelHandler);
            _sound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            // 終わったチャンネルが最後に再生したチャンネルの時チャンネルをNULLにする
            if (SoundChannel(e.target)==_channel)
            {
                _channel.removeEventListener(Event.SOUND_COMPLETE, playNextHandler);
                _channel =null;
            }
        }
        // 終了時にコントローラからチャンネルと取り除くためのハンドラ
        protected function completeMultiChannelHandler(e:Event):void
        {
            removeMultiChannelToCtrl(SoundChannel(e.target));
            e.target.removeEventListener(Event.SOUND_COMPLETE, completeMultiChannelHandler);
            _sound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            // 終わったチャンネルが最後に再生したチャンネルの時チャンネルをNULLにする
            if (SoundChannel(e.target)==_channel)
            {
                _channel =null;
            }
        }


        public function get playing():Boolean
        {
            if (_channel == null)
            {
                return false;
            }else{
                return true;
            }

        }

        protected function get permitNum():int
        {
            return _PERMIT_NUM;
        }
        protected function get decay():Number
        {
            return _DECAY;
        }

        // スレッドを返す
        public function getPlayThread(delay:Number = 0):Thread
        {
            var d:int = delay *1000; // msに変換
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new SleepThread(d));
            sExec.addThread(new ClousureThread(playSound));
            return sExec;
        }

        // スレッドを返す
        public function getPlayVoiceThread(delay:Number = 0):Thread
        {
            var d:int = delay *1000; // msに変換
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new SleepThread(d));
            sExec.addThread(new ClousureThread(playVoice));
            return sExec;
        }

        // スレッドを返す
        public function getMultiPlayThread(delay:Number = 0):Thread
        {
            var d:int = delay *1000; // msに変換
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new SleepThread(d));
            sExec.addThread(new ClousureThread(playMultiSound));
            return sExec;
        }

    }
}

