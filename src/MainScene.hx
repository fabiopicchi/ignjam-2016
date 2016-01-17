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

    private var _questions:Array<Dynamic>;
    private var _numLevels:Int;
    private var _currentLevel:Int = 0;

    private var _interactiveFaceParts:Array<FacePartExpression>;
    private var _actionBar:ActionBar;
    private var _paused:Bool;
    private var _pausedMenu:Entity;

    private var _answers:Array<Array<Expression>>;
    private var _sfxMap:StringMap<Array<Sfx>> = new StringMap<Array<Sfx>>();

    // Entities
    private var l_eyebrow:FacePartExpression;
    private var r_eyebrow:FacePartExpression;
    private var l_eye:FacePartExpression;
    private var r_eye:FacePartExpression;
    private var nose:FacePartExpression;
    private var l_mouth:FacePartExpression;
    private var r_mouth:FacePartExpression;
    private var _mouthCenter:FacePart;
    private var date:PlayerDate;
    
    //HUD
    private var _btPause:Entity;
    private var _baloon:TalkBaloon;
    private var _turnCounter:TurnCounter;

    public function new(){
        super();
        _paused = false;

        _numLevels = NUM_LEVELS;
        _answers = new Array<Array<Expression>>();
        _interactiveFaceParts = new Array<FacePartExpression>();
        _questions = [];

        _sfxMap.set("nose", new Array<Sfx>());
        _sfxMap.get("nose").push(new Sfx("audio/change_nose_01_a.wav"));
        _sfxMap.get("nose").push(new Sfx("audio/change_nose_01_b.wav"));
    }

    override public function begin(){
        var index = Math.floor(MainEngine.questions.length * Math.random());
        var arIndexes = [index];
        _questions.push(MainEngine.questions[index]);
        for(i in 0...(_numLevels - 1)){
            do { 
                index = Math.floor(MainEngine.questions.length * Math.random());
            } while (arIndexes.indexOf(index) != -1);

            arIndexes.push(index);
            _questions.push(MainEngine.questions[index]);
        }

        trace(arIndexes);

        var bg = new Entity();
        switch(MainEngine.currentStage){
            case 0:
                bg.addGraphic(new Image("graphics/BG_Cafe_blur.png"));
            case 1:
                bg.addGraphic(new Image("graphics/BG_Balada01.png"));
            case 2:
                bg.addGraphic(new Image("graphics/BG_Casa.png"));
        }
        add(bg);

        var body = new Entity(966, 21);
        var img = new Image("graphics/hair0" + MainEngine.charConfig[1] + ".png");
        img.color = MainEngine.HAIR_COLORS[MainEngine.charConfig[2]];
        body.addGraphic(img);
        img = new Image("graphics/body.png");
        img.color = MainEngine.SKIN_COLORS[MainEngine.charConfig[3]];
        body.addGraphic(img);
        body.addGraphic(MainEngine.charConfig[0] == 0 ? new Image("graphics/body_dress.png") :
                new Image("graphics/body_suit.png"));
        img = new Image("graphics/face.png");
        img.color = MainEngine.SKIN_COLORS[MainEngine.charConfig[3]];
        body.addGraphic(img);
        body.addGraphic(new Image("graphics/face_highlight.png"));
        add(body);

        date = new PlayerDate(MainEngine.currentDate[0]);
        add(date);

        _mouthCenter = new FacePart({x: 1212, y: 730, h_width: 0, h_height: 0});
        _mouthCenter.addGraphic(new Image("graphics/mouthcenterclose.png"));
        _mouthCenter.addGraphic(new Image("graphics/mouthcenterclosetoopen.png"));
        _mouthCenter.addGraphic(new Image("graphics/mouthcenteropen.png"));
        _mouthCenter.addGraphic(new Image("graphics/mouthcenteropentoclosed.png"));
        _mouthCenter.updateGraphic(2);
        add(_mouthCenter);

        for(f in MainEngine.faceparts){
            add(f);
            switch(f.type){
                case "l_eyebrow":
                    l_eyebrow = f;
                case "r_eyebrow":
                    r_eyebrow = f;
                case "l_eye":
                    l_eye = f;
                case "r_eye":
                    r_eye = f;
                case "nose":
                    nose = f;
                case "l_mouth":
                    l_mouth = f;
                case "r_mouth":
                    r_mouth = f;
            }
            _interactiveFaceParts.push(f);
        }

        _turnCounter = new TurnCounter();
        _turnCounter.x = 1646;
        _turnCounter.y = 18;
        add(_turnCounter);

        _baloon = new TalkBaloon();
        _baloon.x = 199;
        _baloon.y = 51;
        add(_baloon);

        _actionBar = new ActionBar(1754, 195);
        add(_actionBar);

        _btPause = new Entity();
        _btPause.addGraphic(new Image("graphics/btpause.png"));
        _btPause.x = 10; _btPause.y = 18;
        _btPause.setHitbox(Math.floor(166 * HXP.engine.scaleX), 
                Math.floor(166 * HXP.engine.scaleY));
        add(_btPause);

        _pausedMenu = new Entity();
        _pausedMenu.graphic = Image.createRect(Math.floor(HXP.width / HXP.engine.scaleX), 
                Math.floor(HXP.height / HXP.engine.scaleY), 0x000000, 0.4);
        _pausedMenu.visible = _paused;
        add(_pausedMenu);

        _baloon.animateTalk(_questions[_currentLevel++].text, startLevel);
        date.startTalking();
    }

    private function startLevel(){
        _actionBar.start(_questions[_currentLevel].duration, levelOver);
        date.stopTalking();
    }

    private function levelOver(){
        var arExpressions = new Array<Expression>();

        for(fp in _interactiveFaceParts)
            arExpressions.push(fp.expression);

        _answers.push(arExpressions);

        if(_answers.length < _numLevels){
            _baloon.animateTalk(_questions[_currentLevel++].text, startLevel);
            date.startTalking();
            _turnCounter.updateCounter();
        }
        else
            stageOver();
    }

    private function stageOver(){
        MainEngine.nextStage();
    }

    override public function update(){
        if(Input.pressed(Key.ESCAPE))
            _pausedMenu.visible = _paused = !_paused;

        if(Input.mousePressed && _btPause.collidePoint(_btPause.x * HXP.engine.scaleX,
                    _btPause.y * HXP.engine.scaleY, Input.mouseX, Input.mouseY))
            _pausedMenu.visible = _paused = !_paused;

        if(_paused) return;
        
        super.update();

        if(Input.mousePressed && nose.collideMouseScale()){
            var arSfx = _sfxMap.get("nose");
            arSfx[Math.floor(Math.random() * arSfx.length)].play();
        }

        var l_mouthRes = l_mouth.collideMouseScale();
        if(Input.mousePressed && (l_mouthRes || r_mouth.collideMouseScale())){
            var sideStatus = 0;
            var sideEntity = (l_mouthRes ? l_mouth : r_mouth);
            sideStatus = Math.floor(sideEntity.index / 2);

            if(sideStatus == 0) { //closed
                if(l_mouthRes){
                    if(_mouthCenter.index == 2)
                        _mouthCenter.updateGraphic(1);
                    else if(_mouthCenter.index == 3)
                        _mouthCenter.updateGraphic(0);
                    
                }
                else {
                    if(_mouthCenter.index == 1)
                        _mouthCenter.updateGraphic(0);
                    else if(_mouthCenter.index == 2)
                        _mouthCenter.updateGraphic(3);
                }
            } else { //openned
                if(l_mouthRes){
                    if(_mouthCenter.index == 0)
                        _mouthCenter.updateGraphic(3);
                    else if(_mouthCenter.index == 1)
                        _mouthCenter.updateGraphic(2);
                } else {
                    if(_mouthCenter.index == 0)
                        _mouthCenter.updateGraphic(1);
                    else if(_mouthCenter.index == 3)
                        _mouthCenter.updateGraphic(2);
                }
            }
        }
    }

    override public function end(){
        for(f in MainEngine.faceparts){
            remove(f);
        }
    }

}
