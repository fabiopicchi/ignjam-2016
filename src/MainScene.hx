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

    private var _interactiveFaceParts:StringMap<FacePart>;
    private var _actionBar:ActionBar;
    private var _paused:Bool;
    private var _pausedMenu:Entity;

    private var _answers:Array<Array<Expression>>;
    private var _sfxMap:StringMap<Sfx> = new StringMap<Sfx>();
	
	// Score
	private var stageScore:Float;
	private var expressionScores:Expression;
	private var variationScore:Float;
	private var lastFaceParts:Array<FacePart>;

    // Entities
    private var l_eyebrow:FacePart;
    private var r_eyebrow:FacePart;
    private var l_eye:FacePart;
    private var r_eye:FacePart;
    private var nose:FacePart;
    private var l_mouth:FacePart;
    private var r_mouth:FacePart;
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
        _interactiveFaceParts = new StringMap<FacePart>();
        _questions = [];

        _sfxMap.set("nose", new Sfx("audio/change_nose.ogg"));
		_sfxMap.set("mouth", new Sfx("audio/change_mouth.ogg"));
		_sfxMap.set("eye", new Sfx("audio/change_eye.ogg"));
		_sfxMap.set("eyebrow", new Sfx("audio/change_eyebrow.ogg"));
		_sfxMap.set("clock_tic_tac", new Sfx("audio/clock_tic_tac.ogg"));
		
		switch(MainEngine.currentStage) 
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
            case 1:
                bg.addGraphic(new Image("graphics/BG_Cafe_blur.png"));
            case 2:
                bg.addGraphic(new Image("graphics/BG_Balada01.png"));
            case 3:
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
                case "_nose":
                    nose = f;
                case "l_mouth":
                    l_mouth = f;
                case "r_mouth":
                    r_mouth = f;
            }
            _interactiveFaceParts.set(f.type, f);
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
        _sfxMap.get("song").loop();
        _sfxMap.get("amb").loop();    

        _baloon.animateTalk(_questions[_currentLevel].text, startLevel);
        date.startTalking();
    }

    private function startLevel(){
        _actionBar.start(_questions[_currentLevel++].duration, levelOver);
        // trocar para quando dispara uma nova question
        _sfxMap.get("clock_tic_tac").loop();
        date.stopTalking();
    }

    private function levelOver() {
		
        //_answers.push(0);
		
		var arCurrentFPData = new StringMap<Dynamic>();
		for (ifp in _interactiveFaceParts) {
			var id = ifp.getPartName();
			// busca todos os dados no json
			for (fpdata in MainEngine.facepartsRaw) {
				if (fpdata.name == ifp.getPartName()) {
					arCurrentFPData.set(fpdata.side+"_"+fpdata.slot, fpdata);
				}
			}
		}
		
		// eyebrow score
		var nL_eyebrow = _interactiveFaceParts.get("l_eyebrow").getPartName();
		
		var eyebrowScore = findFacePartExpression(
			"eyebrow",
			arCurrentFPData.get("l_eyebrow").state,
			arCurrentFPData.get("r_eyebrow").state);
		
		var eyeScore = findFacePartExpression(
			"eye",
			arCurrentFPData.get("l_eye").state,
			arCurrentFPData.get("r_eye").state);
			
		var noseScore = findFacePartExpression(
			"nose",
			arCurrentFPData.get("_nose").state,
			"");
			
		var mouthScore = findFacePartExpression(
			"mouth",
			arCurrentFPData.get("l_mouth").state,
			arCurrentFPData.get("r_mouth").state);
			
		// calcular score da expressao
		expressionScores = new Expression();
		
		/*
		for (ifp in _interactiveFaceParts) {
			var id = ifp.getPartName();
			for (fpdata in MainEngine.facepartsRaw) {
				if (fpdata.name == id) {
					
				}
			}
			
			
			/*
			expressionScores.swag += fp.expression.swag * _questions[_currentLevel].swag * MainEngine.currentPerson.swag;
			expressionScores.joy += fp.expression.joy * _questions[_currentLevel].joy * MainEngine.currentPerson.joy;
			expressionScores.sadness += fp.expression.sadness * _questions[_currentLevel].sadness * MainEngine.currentPerson.sadness;
			expressionScores.anger += fp.expression.anger * _questions[_currentLevel].anger * MainEngine.currentPerson.anger;
			expressionScores.excitement += fp.expression.excitement * _questions[_currentLevel].excitement * MainEngine.currentPerson.excitement;
			expressionScores.surprise += fp.expression.surprise * _questions[_currentLevel].surprise * MainEngine.currentPerson.surprise;
			expressionScores.disgust += fp.expression.disgust * _questions[_currentLevel].disgust * MainEngine.currentPerson.disgust;
			
		}
		
		/*
		// variacao
		if (_currentLevel > 0) {
			
		}
		*/
		
		
		
		// é final de fase?
        if(_answers.length < _numLevels){
            _baloon.animateTalk(_questions[_currentLevel].text, startLevel);
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
            _sfxMap.get("nose").play();
        }

        var l_mouthRes = l_mouth.collideMouseScale();
        if(Input.mousePressed && (l_mouthRes || r_mouth.collideMouseScale())){
	    _sfxMap.get("mouth").play();

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

        if(Input.mousePressed && (r_eye.collideMouseScale()|| l_eye.collideMouseScale()))
	    _sfxMap.get("eye").play();

        if(Input.mousePressed && (r_eyebrow.collideMouseScale()|| l_eyebrow.collideMouseScale()))
	    _sfxMap.get("eyebrow").play();
    }

    override public function end(){
        for(f in MainEngine.faceparts){
            remove(f);
        }
    }
	
	private function findFacePartExpression(slot:String, part1:String, part2:String):Expression
	{
		var result:Expression = new Expression();
		for (fps in MainEngine.facepartsScoreRaw) {
			if (fps.slot == slot) {
				if (part2 == "") {
					if (fps.part1 == part1) {
						return extractExpressionFromObj(fps);
					}
				}
				else if ((fps.part1 == part1 && fps.part2 == part2) ||
					(fps.part1 == part2 && fps.part2 == part1)) {
						return extractExpressionFromObj(fps);
				}
			}
		}
		return result;
	}
	
	private function extractExpressionFromObj(obj:Dynamic) {
		var e = new Expression();
		e.swag = obj.swag;
		e.joy = obj.joy;
		e.sadness = obj.sadness;
		e.anger = obj.anger;
		e.excitement = obj.excitement;
		e.surprise = obj.surprise;
		e.disgust = obj.disgust;
		return e;
	}
}
