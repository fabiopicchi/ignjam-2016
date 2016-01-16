import openfl.Assets;
import com.haxepunk.utils.Input;
import com.haxepunk.Entity;
import com.haxepunk.Tween;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;
import haxe.Utf8;

class AnimatedText extends Entity{
    private var _running:Bool;
    private var _text:Text;
    private var _currentTextIndex:Int;
    private var _fullText:String;
    private var _letterTime:Float = 0;
    private var _letterTiming:Float = 0.05;

    public function new (x:Int, y:Int, text:String){
        super(x, y); 

        var textFormat = {font : "font/OpenSans-Regular.ttf", 
                    wordWrap : true};

        _text = new Text("", 0, 0, 400, 0, textFormat);
        _fullText = text;
        _currentTextIndex = 0;
        _running = true;
        graphic = _text;
        
        addLetterTween();
    }

    private inline function addLetterTween() {
        addTween(new Tween(_letterTiming, TweenType.OneShot, letterInsert)).start();
    }

    private function letterInsert(?data:Dynamic):Void{
        if(_text.text.length < _fullText.length){
            _text.text = _text.text + _fullText.substr(_currentTextIndex++, 1);
            addLetterTween();
        } else {
            _running = false;
            var image = Image.createRect(10, 10, 0xFFFFFF);
            image.x = 3;
            image.y = _text.textHeight + 3;
            addGraphic(image);
        }
    }

    public function pause():Void{
        clearTweens();
        _running = false;
    }

    public function resume():Void{
        letterInsert();
        _running = true;
    }

    override public function update(){
        if(Input.middleMousePressed) {
            if(_running) pause();
            else resume();
        }
    }
}
