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

    private var _interactiveFaceParts:Array<FacePartExpression>;
    private var _actionBar:ActionBar;
    private var _paused:Bool;
    private var _pausedMenu:Entity;

    private var _answers:Array<Array<Expression>>;
    private var _sfxMap:StringMap<Array<Sfx>> = new StringMap<Array<Sfx>>();

    // Entities
    private var _mouthCenter:FacePart;

    public function new(charConfig:Array<Int>){
        super();
        _paused = false;

        _numLevels = NUM_LEVELS;
        _answers = new Array<Array<Expression>>();
        _interactiveFaceParts = new Array<FacePartExpression>();

        _sfxMap.set("nose", new Array<Sfx>());
        _sfxMap.get("nose").push(new Sfx("audio/change_nose_01_a.wav"));
        _sfxMap.get("nose").push(new Sfx("audio/change_nose_01_b.wav"));
    }



    override public function begin(){
        var body = new Entity(966, 21);
        var img = new Image("graphics/hair0" + MainEngine.charConfig[0] + ".png");
        img.color = MainEngine.HAIR_COLORS[MainEngine.charConfig[1]];
        body.addGraphic(img);
        img = new Image("graphics/body.png");
        img.color = MainEngine.SKIN_COLORS[MainEngine.charConfig[2]];
        body.addGraphic(img);
        body.addGraphic(new Image("graphics/body_dress.png"));
        img = new Image("graphics/face.png");
        img.color = MainEngine.SKIN_COLORS[MainEngine.charConfig[2]];
        body.addGraphic(img);
        body.addGraphic(new Image("graphics/face_highlight.png"));
        add(body);

        var date = new PlayerDate([
            new Image("graphics/date_mouth_talk01.png"),
            new Image("graphics/date_mouth_talk02.png"),                
            new Image("graphics/date_mouth_talk03.png"),                
            new Image("graphics/date_mouth_talk04.png")                
        ], 1);
        add(date);

        _mouthCenter = new FacePart({x: 1212, y: 730, h_width: 0, h_height: 0});
        _mouthCenter.addGraphic(new Image("graphics/mouthcenterclose.png"));
        _mouthCenter.addGraphic(new Image("graphics/mouthcenteropen.png"));
        add(_mouthCenter);

        for(f in MainEngine.faceparts){
            add(f);
            _interactiveFaceParts.push(f);
        }

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

        var colResult = collidePoint("nose", Input.mouseX, Input.mouseY);
        if(Input.mousePressed && colResult != null){
            var arSfx = _sfxMap.get("nose");
            arSfx[Math.floor(Math.random() * arSfx.length)].play();
        }

        colResult = collidePoint("l_mouth", Input.mouseX, Input.mouseY);
        if(Input.mousePressed && colResult != null){
           _mouthCenter.updateGraphic(Math.floor(cast(colResult, FacePart).index / 2));
        }
    }

}
