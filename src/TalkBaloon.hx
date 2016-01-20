import com.haxepunk.Sfx;
import openfl.Assets;
import openfl.text.TextFormatAlign;
import com.haxepunk.utils.Input;
import com.haxepunk.Entity;
import com.haxepunk.Tween;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Graphiclist;

class TalkBaloon extends Entity{
    private var _running:Bool;
    private var _text:Text;
    private var _currentTextIndex:Int;
    private var _fullText:String;
    private var _letterTime:Float = 0;
    private var _letterTiming:Float = 0.05;
    private var _callback:Void->Void;
    private var baloon:Image;
    private var _currentEmoji:String;

    public function new (){
        super(); 

        var textFormat = {
            font : "font/Dion.otf", 
            size : 80,
            color : 0x000000,
            align: TextFormatAlign.CENTER,
            wordWrap : true};
        _text = new Text("", 70, 107, 724, 0, textFormat);

        addGraphic(baloon = new Image("graphics/balao.png"));
        addGraphic(_text);
    }

    public function animateTalk(text:String, emoji:String, callback:Void -> Void) {
        _fullText = text;
        _currentTextIndex = 0;
        _running = true;
        _text.text = _fullText;
        _text.y = baloon.height / 2 - _text.textHeight / 2 - 45;
        _text.text = "";
        _callback = callback;
        if(_currentEmoji != null) 
            cast(graphic, Graphiclist).removeAt(cast(graphic, Graphiclist).count - 1);
        _currentEmoji = emoji;

        if(text.length > 0){
            addLetterTween();
        } else {
            var image = new Image("graphics/emojis/" + _currentEmoji + "_big.png");
            image.x = baloon.width/2 - image.width/2;
            image.y = baloon.height / 2 - image.height / 2 - 45;
            addGraphic(image);

            addTween(new Tween(1.0, TweenType.OneShot, letterInsert)).start();
        }
    }

    private function addLetterTween() {
        addTween(new Tween(_letterTiming, TweenType.OneShot, letterInsert)).start();
    }

    private function letterInsert(?data:Dynamic):Void{
        if(_text.text.length < _fullText.length){
            _text.text = _text.text + _fullText.substr(_currentTextIndex++, 1);
            addLetterTween();
        } else {
            _running = false;
            var alarm = new Sfx("audio/clock_alarm.ogg");
            alarm.play(0.5);
            if(_callback != null) _callback();
            if(_fullText.length > 0){
                var image = new Image("graphics/emojis/" + _currentEmoji + ".png");
                image.x = baloon.width/2 - image.width/2;
                image.y = _text.y + _text.textHeight - 10;
                addGraphic(image);
            }
        }
        var click = new Sfx("audio/click_termometer_up.ogg");
        click.play(0.7);
    }

    public function pause():Void{
        clearTweens();
        _running = false;
    }

    public function resume():Void{
        letterInsert();
        _running = true;
    }
}
