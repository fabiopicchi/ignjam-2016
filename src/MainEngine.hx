import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.sound.SfxFader;
import haxe.Json;
import haxe.ds.StringMap;
import openfl.Assets;
import openfl.Lib;
import openfl.events.Event;
import openfl.display.StageScaleMode;

class MainEngine extends Engine
{
	public static var peopleFlavorText:Dynamic;
    public static var faceparts:StringMap<FacePart>;
    public static var facepartsRaw:Array<Dynamic>;
    public static var facepartsScoreRaw:Array<Dynamic>;
    public static var questions:Array<Dynamic>;
    public static var people:Array<Dynamic>;
    public static var mindlrProfiles:Array<Dynamic>;
    public static var squickrs:Dynamic;

    public static var currentStage:Int = 1;

    public static var SKIN_COLORS:Array<Int> = [
        0xFFd282, 0xe68650, 0xb46e32, 0x965028
    ];
    public static var HAIR_COLORS:Array<Int> = [
        0x1E1E28, 0x8C3C0A, 0xC85014, 0xC8A01E, 0xFAC85A
    ];
    public static var HAIR_STYLES:Int = 4;

    public static var charConfig:Array<Int>;
    public static var currentDate:Array<Int>;
    public static var songFader:SfxFader;

    public static var currentPerson:Dynamic;
	
	public static var firstTime:Bool = true;

	private function e_resize(e:Event){

	var scale = 1.0;
	var stage = Lib.current.stage;	
	var wScale = stage.width / 1920;
	var hScale = stage.height / 1200;
	scale = Math.min(wScale, hScale);	

	trace(stage.width);
	trace(stage.height);
	trace(scale);
		
        scaleX = scaleY = scale;


	}

    override public function init()
    {
#if debug
        HXP.console.enable();
#end

        HXP.scene = new MainMenuScene();

	var scale = 1.0;
	var stage = Lib.current.stage;	
	var wScale = stage.width / 1920;
	var hScale = stage.height / 1200;
	scale = Math.min(wScale, hScale);	

	stage.scaleMode = StageScaleMode.NO_SCALE;
	Lib.current.stage.addEventListener(Event.RESIZE, e_resize);

trace(stage.width);
trace(stage.height);
	trace(scale);
		
        scaleX = scaleY = scale;

        var positionData = Json.parse(Assets.getText("assets/partspositions2.json"));

        var dataFPScore = Json.parse(Assets.getText("assets/facepartsscore.json"));
        facepartsScoreRaw = cast(dataFPScore, Array<Dynamic>);

        var dataFP = Json.parse(Assets.getText("assets/faceparts.json"));		
        facepartsRaw = cast(dataFP, Array<Dynamic>);
        faceparts = new StringMap<FacePart>();

        for (f in facepartsRaw) {
            var key:String = f.side + "_" + f.slot;
            if(!faceparts.exists(key)){
                var fp = new FacePart(Reflect.field(positionData, key));
                fp.type = key;
                faceparts.set(key, fp);
            }
	    // score
            faceparts.get(key).addNamedGraphic(f.name, new Image("graphics/" + f.name + ".png"));
        }

		
		peopleFlavorText = Json.parse(Assets.getText("assets/peopleflavor.json"));
        questions = Json.parse(Assets.getText("assets/questions.json"));
        people = Json.parse(Assets.getText("assets/people.json"));
        mindlrProfiles = Json.parse(Assets.getText("assets/mindlr-profiles.json"));
        squickrs = Json.parse(Assets.getText("assets/squickrs.json"));

        charConfig = [
            Math.floor(Math.random() * 2), 
            Math.floor(Math.random() * HAIR_STYLES) + 1, 
            Math.floor(Math.random() * HAIR_COLORS.length),
            Math.floor(Math.random() * SKIN_COLORS.length)
        ];

        currentDate = [
            Math.floor(Math.random() * 2), 
            Math.floor(Math.random() * HAIR_STYLES) + 1, 
            Math.floor(Math.random() * HAIR_COLORS.length),
            Math.floor(Math.random() * SKIN_COLORS.length),
            Math.floor(Math.random() * people.length),
            Math.floor(Math.random() * mindlrProfiles.length)
        ];

        // isso daqui vai virar o resultado do minglr 
        currentPerson = people[currentDate[4]];

        songFader = null;
    }

    public static function main() { Lib.current.addChild(new MainEngine()); }

    public static function nextStage() {
        if(currentStage < 3)
        {
            currentStage++;
            HXP.scene = new MainScene();
        } else {
            currentStage = 1;
            HXP.scene = new MinglrScene();
        }
    }
}
