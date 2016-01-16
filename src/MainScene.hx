import haxe.ds.StringMap;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

class MainScene extends Scene{
    private static var LEVEL_DURATION = 1.0;
    private static var NUM_LEVELS = 5;

    private var _numLevels:Int;
    private var _currentLevel:Int;

    private var _charConfig:Array<Int>;
    private var _interactiveFaceParts:Array<FacePartExpression>;
    private var _actionBar:ActionBar;
    private var _paused:Bool;
    private var _pausedMenu:Entity;

    private var _answers:Array<Array<Expression>>;

    private var _sfxMap:StringMap<Array<Sfx>> = new StringMap<Array<Sfx>>();

    public function new(charConfig:Array<Int>){
        super();
        _charConfig = charConfig;
        _paused = false;

        _numLevels = NUM_LEVELS;
        _answers = new Array<Array<Expression>>();
        _interactiveFaceParts = new Array<FacePartExpression>();

        _sfxMap.set("nose", new Array<Sfx>());
        _sfxMap.get("nose").push(new Sfx("audio/change_nose_01_a.wav"));
        _sfxMap.get("nose").push(new Sfx("audio/change_nose_01_b.wav"));
    }

    override public function begin(){
        var body = new Entity();
        body.addGraphic(new Image("graphics/hair02.png"));
        body.addGraphic(new Image("graphics/body.png"));
        body.addGraphic(new Image("graphics/body_dress.png"));
        body.addGraphic(new Image("graphics/face.png"));
        body.addGraphic(new Image("graphics/face_highlight.png"));
        add(body);

        var part = new FacePart(406, 800, 321, 182);
        part.addGraphic(new Image("graphics/mouthcenterclose.png"));
        part.addGraphic(new Image("graphics/mouthcenteropen.png"));
        add(part);

        for(f in Main.faceparts){
            add(f);
            _interactiveFaceParts.push(f);
        }

        _actionBar = new ActionBar(20, 20);
        add(_actionBar);
        _actionBar.start(LEVEL_DURATION, levelOver);

        add(new AnimatedText(100, 400, 
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry."));

        _pausedMenu = new Entity();
        _pausedMenu.graphic = Image.createRect(HXP.width, HXP.height, 0x000000, 0.4);
        _pausedMenu.visible = _paused;
        add(_pausedMenu);
    }

    private function levelOver(){
        var arExpressions = new Array<Expression>();

        for(fp in _interactiveFaceParts)
            arExpressions.push(fp.expression);

        _answers.push(arExpressions);
        if(_answers.length < _numLevels)
            _actionBar.start(LEVEL_DURATION, levelOver);
        else
            stageOver();
    }

    private function stageOver(){
        
    }

    override public function update(){
        if(Input.pressed(Key.ESCAPE))
            _pausedMenu.visible = _paused = !_paused;

        if(_paused) return;
        
        super.update();

        if(Input.mousePressed && collidePoint("nose", Input.mouseX, Input.mouseY) != null){
            var arSfx = _sfxMap.get("nose");
            arSfx[Math.floor(Math.random() * arSfx.length)].play();
        }
    }

}
