import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.tweens.sound.SfxFader;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Text;
import openfl.text.TextFormatAlign;

class SquickrScene extends Scene
{
    private var btBack:Entity;
    private var btNext:Entity;
    private var showNext:Bool = true;
    private var score:Float;

    public function new(showNext:Bool, score:Float){
        super();
        this.showNext = showNext;
        this.score = score;
    }

    override public function begin(){
        var bg = new Entity();
        bg.addGraphic(new Image("graphics/pregame/fundo.png"));
        bg.addGraphic(new Image("graphics/pregame/mobilebase.png"));

        var img = new Image("graphics/squickr/squickr_bg.png");
        img.x = 351; img.y = 247;
        bg.addGraphic(img);

        img = new Image("graphics/squickr/squickr_text_container.png");
        img.x = 379; img.y = 401;
        bg.addGraphic(img);

        img = new Image("graphics/squickr/squickr_avatar_bg.png");
        img.x = 399; img.y = 421;
        bg.addGraphic(img);

        var textFormat = {
            font : "font/Dion.otf", 
            size : 64,
            color : 0x5EA9DD,
            wordWrap : true};
        var text_1 = new Text("@" + MainEngine.mindlrProfiles[MainEngine.currentDate[5]].Name, 
                614, 421, 789, 0, textFormat);
        bg.addGraphic(text_1);
        
        var arSquicks:Array<Dynamic>;
        if(score > 150){
            arSquicks = MainEngine.squickrs.Perfect;
        } else if(score > 20){
            arSquicks = MainEngine.squickrs.Aprovado;
        } else{
            arSquicks = MainEngine.squickrs.Reprovado;
        }
        var squick:String = arSquicks[Math.floor(Math.random() * arSquicks.length)];
 
        var textFormat2 = {
            font : "font/Dion.otf", 
            size : 64,
            color : 0x000000,
            wordWrap : true};
        var text_2 = new Text(squick, 614, 484, 789, 0, textFormat2);
        bg.addGraphic(text_2);

        var mybody = new Entity(410, 425);
        var scale = 0.155;
        var skinColor = MainEngine.SKIN_COLORS[MainEngine.currentDate[3]];
        var hairColor = MainEngine.HAIR_COLORS[MainEngine.currentDate[2]];

        var img = new Image("graphics/hair0" + MainEngine.currentDate[1] + ".png");
        img.color = hairColor;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = new Image("graphics/body.png");
        img.color = skinColor;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = MainEngine.currentDate[0] == 0 ? new Image("graphics/body_dress.png") :
                new Image("graphics/body_suit.png");
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = new Image("graphics/face.png");
        img.color = skinColor;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = new Image("graphics/mouthcenterclose.png");
        img.x = 216 * scale; img.y = 709 * scale;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = new Image("graphics/mouthrightclosed01.png");
        img.x = 216 * scale; img.y = 709 * scale;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = new Image("graphics/mouthleftclosed01.png");
        img.x = 216 * scale; img.y = 709 * scale;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = new Image("graphics/nose01.png");
        img.x = 279 * scale; img.y = 447 * scale;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = new Image("graphics/eyeleft01.png");
        img.x = 134 * scale; img.y = 339 * scale;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = new Image("graphics/eyeright01.png");
        img.x = 388 * scale; img.y = 339 * scale;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = new Image("graphics/browleft01.png");
        img.x = 134 * scale; img.y = 339 * scale;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = new Image("graphics/browright01.png");
        img.x = 388 * scale; img.y = 339 * scale;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);

        var front = new Entity();
        img = new Image("graphics/squickr/squickr_avatar_mask.png");
        img.x = 397; img.y = 416;
        front.addGraphic(img);

        img = new Image("graphics/squickr/squickr_score_base.png");
        img.x = 562; img.y = 679;
        front.addGraphic(img);

        img = new Image("graphics/squickr/squickr_score_container.png");
        img.x = 674; img.y = 775;
        front.addGraphic(img);

        var fill = Image.createRect(605, 65, 0xFF0000);
        fill.x = 657; fill.y = 770;
        front.addGraphic(fill);

        img = new Image("graphics/squickr/squickr_score_mask.png");
        img.x = 681; img.y = 770;
        front.addGraphic(img);

        img = new Image("graphics/squickr/squickr_score_target.png");
        img.x = 919; img.y = 657;
        front.addGraphic(img);

        img = new Image("graphics/squickr/squickr_score_deco.png");
        img.x = 602; img.y = 738;
        front.addGraphic(img);

        fill.scaleX = 0;
        var vTween1 = new VarTween(result, TweenType.OneShot);
        addTween(vTween1);
        vTween1.tween(fill, "scaleX", (score + 200)/400, 5);

        add(bg);
        add(mybody);
        add(front);

        btBack = new Entity();
        btBack.addGraphic(new Image("graphics/squickr/squickr_bt_back.png"));
        btBack.x = 359;
        btBack.y = 760;
        btBack.setHitbox(Math.floor(166 * HXP.engine.scaleX), 
                Math.floor(166 * HXP.engine.scaleY));
        add(btBack); 

        if(showNext){
            btNext = new Entity();
            btNext.addGraphic(new Image("graphics/squickr/squickr_bt_next.png"));
            btNext.x = 1318;
            btNext.y = 760;
            btNext.setHitbox(Math.floor(166 * HXP.engine.scaleX), 
                    Math.floor(166 * HXP.engine.scaleY));
            add(btNext); 
        }
    }

    private function result(data:Dynamic){

    }

    override public function update(){
        if(Input.mousePressed){
            if(btBack.collidePoint(btBack.x * HXP.engine.scaleX,
                        btBack.y * HXP.engine.scaleY,
                        Input.mouseX,
                        Input.mouseY))
            {
                HXP.scene = new MinglrScene();
            }
            
            if(showNext && btNext.collidePoint(btNext.x * HXP.engine.scaleX,
                        btNext.y * HXP.engine.scaleY,
                        Input.mouseX,
                        Input.mouseY))
            {
                HXP.scene = new MainScene();
            }
        }
    }
}
