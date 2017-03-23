package {


    import flash.utils.getTimer;

    import starling.utils.AssetManager;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.media.AudioPlaybackMode;
    import flash.media.SoundMixer;
    import flash.events.Event;
    import flash.events.SampleDataEvent;
    import flash.utils.ByteArray;


    public class SoundsControl
    {

        private static var currentSound:Array;
        private static var soundVolumeSystem:SoundTransform;
        private static var sAssets:AssetManager;
        static public const DEFAULT_VOLUME:Number = 0.8;

        private var i:Number;
        private var l:Number;
        private var obj:Object;
        private var chkLoop:Boolean;


        private var sndTemp:Sound;
        private var snd:Sound;
        private var sndCh:SoundChannel;
        private var shortEffectSndCh:SoundChannel;



        public function SoundsControl(){
            //trace("Sound Start!!!");
        }
        public function initialize(assets:AssetManager):void{

            currentSound = [];
            sAssets = assets;
            SoundMixer.audioPlaybackMode  =  AudioPlaybackMode.AMBIENT;
            soundVolumeSystem = new SoundTransform();
            shortEffectSndCh = new SoundChannel();
            setVolume(DEFAULT_VOLUME);
        }
        public function setVolume(volume:Number):void{
            soundVolumeSystem.volume = volume;
        }
        public function playSound(soundObject:Object):void {

            if(soundObject == null) return;

            if(soundObject.soundName == undefined || soundObject.soundName == null) return;

            trace(soundObject.soundName, soundObject.loops, soundObject.volume);

            var sndVol:SoundTransform = new SoundTransform();
//            var sndLoop:Number = (soundObject.loops != undefined && soundObject.loops == true ) ? 999 : 1;
            var sndLoop:Boolean = soundObject.loops;
            var soundObj:Object = {};

            if(chkSound(soundObject.soundName) == true){
                stopSound(soundObject.soundName);
            }

            sndTemp = new Sound();
            snd = new Sound();
            sndCh = new SoundChannel();
            snd = sndTemp = sAssets.getSound(soundObject.soundName);
            sndTemp = sAssets.getSound(soundObject.soundName);
            sndVol.volume = soundObject.volume != undefined ? soundObject.volume : DEFAULT_VOLUME;

//            trace("Checking sound have created ? .....  ---------------------------------------------------");

            if(snd == null) return;

//            trace("Checking sound have created ? -->>  ### DONE ! ### ----------------------------------------");
//            trace("-------------------------------------------------------------------------------------------");

            snd.addEventListener(SampleDataEvent.SAMPLE_DATA, processSound);

            sndCh = snd.play(0, 1, sndVol);

            soundObj.snd = snd;
            soundObj.sndCh = sndCh;
            soundObj.sndName = soundObject.soundName;
            soundObj.sndVolume = sndVol;
            soundObj.sndLoop = sndLoop;
            soundObj.sndID = getTimer();
            soundObj.startPosition = 0;
            soundObj.finishPosition = snd.length;
            soundObj.lastPosition = 0;
            soundObj.sndStatus = "play";
            currentSound.push(soundObj);

            sndCh.addEventListener(Event.SOUND_COMPLETE, function (e:Event):void {
                try {
                    sndCh.removeEventListener(Event.SOUND_COMPLETE, arguments.callee);
//                    trace(soundObj.sndName+" ----->> finished !");
                    if(soundObj.sndLoop == true){
//                        trace(soundObj.sndName+" ----->> repeat !");
                        repeatSound(soundObj);
                    }
                    else{
                        removeSound(soundObj);
                    }

                } catch(e:Error){trace(e.message);}
            });
        }

        public static function chkSound(soundType:String):Boolean {
            var isPlaying:Boolean = false;
            var chkRound:Number = 0;

            if (currentSound.length == 0){
//                trace("Sound Not Found!!!-----------------");
                return isPlaying;
            }
            try {
                while (currentSound[chkRound].sndName == soundType && chkRound < currentSound.length) {
//                    trace("Sound Detected!!!-------------------");
                    isPlaying = true;
                    chkRound++;
                }
            }
            catch (err:Error){
                trace(err.message);
            }

            return isPlaying;
        }

        public function stopSound(soundType:String):void{
            if (currentSound.length > 0) {
//                trace("stop and remove sound");
                for (i = 0, l = currentSound.length; i < l; ++i) {
                    if (currentSound[i].sndName == soundType) {
                        currentSound[i].sndCh.removeEventListener(Event.SOUND_COMPLETE, arguments.callee);
                        currentSound[i].sndCh.stop();
                        removeSound(currentSound[i]);
//                        currentSound.splice(i, 1);
                        return;
                    }
                }
            }
        }
        public function pauseSound(soundType:String):void {
//            trace("Sound Paused !");
            if (currentSound.length > 0) {
                for (i = 0, l = currentSound.length; i < l; ++i) {
                    if (currentSound[i].sndName == soundType) {
                        var lastPosition:Number = currentSound[i].sndCh.position;
                        currentSound[i].sndStatus = "pause";
                        currentSound[i].sndCh.stop();
                        currentSound[i].lastPosition = lastPosition;
//                        trace("sound last position = "+lastPosition);
                        return;
                    }
                }
            }

        }
        public function resumeSound(soundType:String):void {
//            trace("Sound Resumed !");
            if (currentSound.length > 0) {
                for (i = 0, l = currentSound.length; i < l; ++i) {
                    if (currentSound[i].sndName == soundType && currentSound[i].sndStatus == "pause") {
                        obj = currentSound[i];
                        obj.sndCh = obj.snd.play(obj.lastPosition, 1, obj.sndVol);
                        obj.sndStatus = "play";
                        chkLoop = obj.sndLoop;
                        currentSound.push(obj);
                        removeSound(currentSound[i]);
                        obj.sndCh.addEventListener(Event.SOUND_COMPLETE, function (e:Event):void {
                            try {
                                obj.sndCh.removeEventListener(Event.SOUND_COMPLETE, arguments.callee);
//                                trace(obj.sndName+" -------------------------->>(resume) finished !");

                                if(chkLoop == true){
//                                    trace(obj.sndName+" ------------------------------------>> repeat !");
                                    repeatSound(obj);
                                }
                                else{
                                    removeSound(obj);
                                }
                            } catch(e:Error){trace(e.message);}

                        });
                        return;
                    }
                }
            }
        }
        private function repeatSound(soundObj:Object):void {
            if (currentSound.length > 0) {
                for (i = 0, l = currentSound.length; i < l; ++i) {
                    if (currentSound[i] === soundObj) {
                        obj = currentSound[i];
                        obj.sndCh = obj.snd.play(obj.startPosition, 1, obj.sndVol);
                        currentSound.push(obj);
                        removeSound(currentSound[i]);
                        obj.sndCh.addEventListener(Event.SOUND_COMPLETE, function (e:Event):void {
                            try {
                                obj.sndCh.removeEventListener(Event.SOUND_COMPLETE, arguments.callee);
//                                trace(obj.sndName+" -------------------------->>(resume) finished !");
//                                trace(obj.sndName+" ------------------------------------>> repeat !");
                                repeatSound(obj);
                            } catch(e:Error){trace(e.message);}

//                            trace("Amount of  playing sound = " + currentSound.length);
                        });
                        return;
                    }
                }
            }
        }

        private function removeSound(soundObj:Object):void{
            if (currentSound.length > 0) {
                for (i = 0, l = currentSound.length; i < l; ++i) {
                    if (currentSound[i] === soundObj) {
                        var obj:Object = currentSound[i];
//                        trace("remove sound "+obj.sndName);
                        currentSound.splice(i, 1);
//                        trace("Amount of  playing sound = " + currentSound.length);
                        return;
                    }
                }
            }
        }

        //Trim space sound areas
        private function processSound(event:SampleDataEvent):void
        {
            var bytes:ByteArray = new ByteArray();
            sndTemp.extract(bytes, 8192);
            event.data.writeBytes(upOctave(bytes));
        }
        private function upOctave(bytes:ByteArray):ByteArray
        {
            var returnBytes:ByteArray = new ByteArray();
            bytes.position = 0;
            while(bytes.bytesAvailable > 0)
            {
                returnBytes.writeFloat(bytes.readFloat());
                returnBytes.writeFloat(bytes.readFloat());
                if (bytes.bytesAvailable > 0)
                {
                    bytes.position += 8;
                }
            }
            return returnBytes;
        }
    }
}