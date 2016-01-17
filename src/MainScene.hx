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
    private var _sfxMap:StringMap<Sfx> = new StringMap<Sfx>();

    // Entities
    private var _mouthCenter:FacePart;

    public function new(charConfig:Array<Int>){
        super();
        _paused = false;

        _numLevels = NUM_LEVELS;
        _answers = new Array<Array<Expression>>();
        _interactiveFaceParts = new Array<FacePartExpression>();

        _sfxMap.set("nose", new Sfx("audio/change_nose.ogg"));
		_sfxMap.set("mouth", new Sfx("audio/change_mouth.ogg"));
		_sfxMap.set("eye", new Sfx("audio/change_eye.ogg"));
		_sfxMap.set("eyebrow", new Sfx("audio/change_eyebrow.ogg"));
		_sfxMap.set("clock_tic_tac", new Sfx("audio/clock_tic_tac.ogg"));
		
		switch (MainEngine.currentLevel) 
		{
			case 1: {
				_sfxMap.set("song", new Sfx("audio/song_coffeeshop.ogg"));
				_sfxMap.set("amb", new Sfx("audio/amb_coffeeshop.ogg"));
			}
				
			case 2: {
				_sfxMap.set("song", new Sfx("audio/song_bar.ogg"));
				_sfxMap.set("amb", new Sfx("audio/amb_bar.ogg"));
			}
			case 3: {
				_sfxMap.set("song", new Sfx("audio/song_night.ogg"));
				_sfxMap.set("amb", new Sfx("audio/amb_night.ogg"));
			}
		}
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
		
		_sfxMap.get("song").loop();
		_sfxMap.get("amb").loop();    
		// trocar para quando dispara uma nova question
		_sfxMap.get("clock_tic_tac").loop();
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
            _sfxMap.get("nose").play();
        }

        colResult = collidePoint("l_mouth", Input.mouseX, Input.mouseY);
        if(Input.mousePressed && colResult != null){
           _mouthCenter.updateGraphic(Math.floor(cast(colResult, FacePart).index / 2));
		   _sfxMap.get("mouth").play();
        }
		
		colResult = collidePoint("r_mouth", Input.mouseX, Input.mouseY);
        if(Input.mousePressed && colResult != null){
           _mouthCenter.updateGraphic(Math.floor(cast(colResult, FacePart).index / 2));
		   _sfxMap.get("mouth").play();
        }
		
		colResult = collidePoint("l_eye", Input.mouseX, Input.mouseY);
        if(Input.mousePressed && colResult != null){
		   _sfxMap.get("eye").play();
        }
		
		colResult = collidePoint("r_eye", Input.mouseX, Input.mouseY);
        if(Input.mousePressed && colResult != null){
		   _sfxMap.get("eye").play();
        }
		
		colResult = collidePoint("l_eyebrow", Input.mouseX, Input.mouseY);
        if(Input.mousePressed && colResult != null){
		   _sfxMap.get("eyebrow").play();
        }
		
		colResult = collidePoint("r_eyebrow", Input.mouseX, Input.mouseY);
        if(Input.mousePressed && colResult != null){
		   _sfxMap.get("eyebrow").play();
        }
    }

}
