import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.sound.SfxFader;
import haxe.Json;
import haxe.ds.StringMap;
import openfl.Assets;
import openfl.Lib;

class MainEngine extends Engine
{
    public static var faceparts:StringMap<FacePartExpression>;
    public static var questions:Dynamic;
    public static var people:Dynamic;
	
	public static var currentLevel:Int = 1;

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

    override public function init()
    {
#if debug
        HXP.console.enable();
#end
        HXP.scene = new MenuScene();

        var data = Json.parse(Assets.getText("assets/faceparts.json"));
        var positionData = Json.parse(Assets.getText("assets/partspositions2.json"));

        var arFaceparts:Array<Dynamic> = cast(data, Array<Dynamic>);

        faceparts = new StringMap<FacePartExpression>();

        for(f in arFaceparts){
            var expression = new Expression();
            expression.swag = f.swag;
            expression.joy = f.joy;
            expression.sadness = f.sadness;
            expression.anger = f.anger;
            expression.excitement = f.excitement;
            expression.surprise = f.surprise;
            expression.disgust = f.disgust;

            if(!faceparts.exists(f.type)){
                var facepartExpression = 
                    new FacePartExpression(Reflect.field(positionData, f.type));
                facepartExpression.type = f.type;
                faceparts.set(f.type, facepartExpression);
            }

            faceparts.get(f.type).addExpression(new Image("graphics/" + f.name + ".png"),
                    expression);
        }

        questions = Json.parse(Assets.getText("assets/questions.json"));
        people = Json.parse(Assets.getText("assets/people.json"));

        charConfig = [
            Math.floor(Math.random() * HAIR_STYLES) + 1, 
            Math.floor(Math.random() * HAIR_COLORS.length), 
			Math.floor(Math.random() * SKIN_COLORS.length)
        ];

        currentDate = [
            Math.floor(Math.random() * HAIR_STYLES) + 1, 
        ];
		
		songFader = null;
    }

    public static function main() { Lib.current.addChild(new MainEngine()); }
}
