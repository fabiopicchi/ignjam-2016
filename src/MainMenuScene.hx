import haxe.ds.StringMap;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.Sfx;
import com.haxepunk.Tween;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

class MainMenuScene extends Scene{

    private var front:Entity;
    private var mybody:Entity;
    private var btStart:Entity;
    private var btCredits:Entity;
    private var btRandom:Entity;

    override public function begin(){
        super.begin();

        var bg = new Entity();
        bg.addGraphic(new Image("graphics/pregame/fundo.png"));

        var img = new Image("graphics/mainmenu/title.png");
        img.x = 1019; img.y = 102;
        bg.addGraphic(img);

        img = new Image("graphics/mainmenu/mirror.png");
        img.x = 22; img.y = 13;
        bg.addGraphic(img);

        front = new Entity();
        img = new Image("graphics/mainmenu/mirror_mask.png");
        img.x = 22; img.y = 13;
        front.addGraphic(img);

        img = new Image("graphics/mainmenu/mirror_over.png");
        img.x = 361; img.y = 70;
        front.addGraphic(img);

        add(bg);
        randomize();
        add(mybody);
        add(front);

        btStart = new Entity();
        btStart.addGraphic(new Image("graphics/mainmenu/bt_comecar.png"));
        btStart.x = 1068; btStart.y = 680;
        btStart.setHitbox(Math.floor(776 * HXP.engine.scaleX), Math.floor(173 * HXP.engine.scaleY));
        add(btStart);

        btCredits = new Entity();
        btCredits.addGraphic(new Image("graphics/mainmenu/bt_creditos.png"));
        btCredits.x = 1088; btCredits.y = 878;
        btCredits.setHitbox(Math.floor(776 * HXP.engine.scaleX), Math.floor(173 * HXP.engine.scaleY));
        add(btCredits);

        btRandom = new Entity();
        btRandom.addGraphic(new Image("graphics/mainmenu/bt_random.png"));
        btRandom.x = 407; btRandom.y = 973;
        btRandom.setHitbox(Math.floor(220 * HXP.engine.scaleX), Math.floor(220 * HXP.engine.scaleY));
        add(btRandom);
    }

    override public function update(){
        super.update();
        if(Input.mousePressed){
            if(btStart.collidePoint(btStart.x * HXP.engine.scaleX,
                        btStart.y * HXP.engine.scaleY,
                        Input.mouseX,
                        Input.mouseY))
            {
                HXP.scene = new MinglrScene();
            }
            
            if(btCredits.collidePoint(btCredits.x * HXP.engine.scaleX,
                        btCredits.y * HXP.engine.scaleY,
                        Input.mouseX,
                        Input.mouseY))
            {
                MainEngine.nextStage();
            }

            if(btRandom.collidePoint(btRandom.x * HXP.engine.scaleX,
                        btRandom.y * HXP.engine.scaleY,
                        Input.mouseX,
                        Input.mouseY))
            {
                randomize();
            }
        }
    }

    private function randomize(){
        MainEngine.charConfig = [
            Math.floor(Math.random() * 2), 
            Math.floor(Math.random() * MainEngine.HAIR_STYLES) + 1, 
            Math.floor(Math.random() * MainEngine.HAIR_COLORS.length),
            Math.floor(Math.random() * MainEngine.SKIN_COLORS.length)
        ];

        if(mybody != null){
            remove(front);
            remove(mybody);
            remove(btRandom);
        }

        mybody = new Entity(22, 13);
        var scale = 0.94;
        var skinColor = MainEngine.SKIN_COLORS[MainEngine.charConfig[3]];
        var hairColor = MainEngine.HAIR_COLORS[MainEngine.charConfig[2]];

        var img = new Image("graphics/hair0" + MainEngine.charConfig[1] + ".png");
        img.color = hairColor;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = new Image("graphics/body.png");
        img.color = skinColor;
        img.scaleX = img.scaleY = scale;
        mybody.addGraphic(img);
        img = MainEngine.charConfig[0] == 0 ? new Image("graphics/body_dress.png") :
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

        if(btStart != null){
            add(mybody);
            add(front);
            add(btRandom);
        }
    }
}
