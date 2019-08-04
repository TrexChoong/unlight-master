package view.image.option
{
 
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;

    import view.image.BaseImage;

    import controller.TitleCtrl;

    import model.Option;

    /**
     * ニュースパネルクラス
     *
     */

    public class SoundPanel extends Panel
    {

        private static const X:int = 580;
        private static const Y:int = 460;
        private static const BGM_ADJUST_Y:int = 0;
        private static const SE_ADJUST_Y:int = 10;
        private static const PANEL_ADJUST_HEIGHT:int = 50;

        private var _SEVolumeSlider:HSlider = new HSlider();
        private var _BGMVolumeSlider:HSlider = new HSlider();
        // タイトル表示
        private var _BGMLabel:Label = new Label();
        private var _SELabel:Label = new Label();
        private var _bgm_adjust_y:int = 0;
        private var _se_adjust_y:int = 0;
        private var _panel_adjust_height:int = 0;
        CONFIG::VOICE_ON
        {
            private var _CVVolumeSlider:HSlider = new HSlider();
            private var _CVLabel:Label = new Label();
        }

        private var _option:Option = Option.instance;


        /**
         * コンストラクタ
         *
         */
        public function SoundPanel()
        {
            super();
            x = 230;
            y = 210;
            width  = 300;
            height = 225;

            layout = "absolute"

            title = "Sound Option";

            addChild(_BGMVolumeSlider);
            addChild(_SEVolumeSlider);
            addChild(_BGMLabel);
            addChild(_SELabel);
            _BGMVolumeSlider.value = _option.BGMVolume;
            _SEVolumeSlider.value = _option.SEVolume;
            setSliderOption(_BGMVolumeSlider);
            setSliderOption(_SEVolumeSlider);
            _BGMVolumeSlider.addEventListener(SliderEvent.CHANGE, bgmHandler);
            _SEVolumeSlider.addEventListener(SliderEvent.CHANGE, seHandler);
            _BGMVolumeSlider.addEventListener(SliderEvent.THUMB_DRAG, bgmHandler);
            _SEVolumeSlider.addEventListener(SliderEvent.THUMB_DRAG, seHandler);
            _BGMLabel.text = "BGM";
            _SELabel.text = "SE";
            setLabelOption(_BGMLabel);
            setLabelOption(_SELabel);
            CONFIG::VOICE_ON
            {
                height += PANEL_ADJUST_HEIGHT;
                _bgm_adjust_y = BGM_ADJUST_Y;
                _se_adjust_y = SE_ADJUST_Y;
                addChild(_CVVolumeSlider);
                addChild(_CVLabel);
                _CVVolumeSlider.value = _option.CVVolume;
                setSliderOption(_CVVolumeSlider);
                _CVVolumeSlider.addEventListener(SliderEvent.CHANGE, cvHandler);
                _CVVolumeSlider.addEventListener(SliderEvent.THUMB_DRAG, cvHandler);
                _CVLabel.text = "VOICE";
                setLabelOption(_CVLabel);
                _CVVolumeSlider.x  = 50;
                _CVVolumeSlider.y  = 210;
                _CVLabel.y         = 185;
            }
            _BGMVolumeSlider.x = 50;
            _BGMVolumeSlider.y = 70 - _bgm_adjust_y;
            _BGMLabel.y        = 45 - _bgm_adjust_y;
            _SEVolumeSlider.x  = 50;
            _SEVolumeSlider.y  = 150 - _se_adjust_y;
            _SELabel.y         = 125 - _se_adjust_y;
        }

        private function setSliderOption(s:HSlider):void
        {
            s.styleName = "SoundSlider";
            s.width = 200;
            s.maximum = 100;
            s.labels = ["0","50","100"];
            s.tickInterval = 10;
        }

        private function setLabelOption(lb:Label):void
        {
            lb.styleName = "LoginLabel";
            lb.width = 200;
            lb.x = 50;
        }


        public function bgmHandler(e:SliderEvent):void
        {
//             _option.BGMVolume = _BGMVolumeSlider.value;
            _option.BGMVolume = e.value;
        }

        public function seHandler(e:SliderEvent):void
        {
//             _option.SEVolume = _SEVolumeSlider.value;
            _option.SEVolume = e.value;
        }

        public function cvHandler(e:SliderEvent):void
        {
            _option.CVVolume = e.value;
        }

        public function final():void
        {
            _BGMVolumeSlider.removeEventListener(SliderEvent.CHANGE, bgmHandler);
            _SEVolumeSlider.removeEventListener(SliderEvent.CHANGE, seHandler);
            _BGMVolumeSlider.removeEventListener(SliderEvent.THUMB_DRAG, bgmHandler);
            _SEVolumeSlider.removeEventListener(SliderEvent.THUMB_DRAG, seHandler);
            CONFIG::VOICE_ON
            {
                _CVVolumeSlider.removeEventListener(SliderEvent.CHANGE, cvHandler);
                _CVVolumeSlider.removeEventListener(SliderEvent.THUMB_DRAG, cvHandler);
            }
        }


    }

}
