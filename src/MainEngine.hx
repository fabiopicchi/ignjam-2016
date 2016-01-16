import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import haxe.Json;
import haxe.ds.StringMap;
import openfl.Assets;
import openfl.Lib;

class MainEngine extends Engine
{
    public static var faceparts:StringMap<FacePartExpression>;
    public static var questions:Dynamic;
    public static var people:Dynamic;

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
    }

    public static function main() { Lib.current.addChild(new MainEngine()); }
}
