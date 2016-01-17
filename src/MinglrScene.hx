import com.haxepunk.HXP;
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

class MinglrScene extends Scene
{
    private var _sfxSong = new Sfx("audio/song_title.ogg");

    private var minglrSearch:Entity;
    private var body:Entity;
    private var mybody:Entity;
    private var text:Text;
    private var btno:Entity;
    private var btbytes:Entity;
    private var gotoDate:Entity;
    private var matchFlag:Bool = false;

    override public function begin(){
        //MainEngine.songFader = new SfxFader(_sfxSong);
        //HXP.world.addTween(MainEngine.songFader);
        var bg = new Entity();
        bg.addGraphic(new Image("graphics/pregame/fundo.png"));
        bg.addGraphic(new Image("graphics/pregame/mobilebase.png"));
        add(bg);
        
        var minglrBg = new Image("graphics/pregame/minglr_bg.png");
        minglrBg.x = 351; minglrBg.y = 241;
        bg.addGraphic(minglrBg);

        minglrSearch = new Entity();
        var img = new Image("graphics/pregame/minglr_search_container.png");
        img.x = 729; img.y = 382;
        minglrSearch.addGraphic(img);
        img = new Image("graphics/pregame/minglr_search_text_container.png");
        img.x = 374; img.y = 738;
        minglrSearch.addGraphic(img);

        var textFormat = {
            font : "font/Dion.otf", 
            size : 64,
            color : 0x000000,
            align: TextFormatAlign.CENTER,
            wordWrap : true};
        text = new Text("sjdaoksjdoasjd aosijdaisd aosjd iajs oaijsdaisj", 399, 755, 1087, 0, textFormat);
        minglrSearch.addGraphic(text);
        add(minglrSearch);

        createMinglr();

        btno = new Entity();
        btno.addGraphic(new Image("graphics/pregame/minglr_search_btno.png"));
        btno.x = 483;
        btno.y = 509;
        btno.setHitbox(Math.floor(166 * HXP.engine.scaleX), 
                Math.floor(166 * HXP.engine.scaleY));
        add(btno); 

        btbytes = new Entity();
        btbytes.addGraphic(new Image("graphics/pregame/minglr_search_btyes.png"));
        btbytes.x = 1237;
        btbytes.y = 509;
        btbytes.setHitbox(Math.floor(166 * HXP.engine.scaleX), 
                Math.floor(166 * HXP.engine.scaleY));
        add(btbytes); 
    }

    private function createMinglr(){
        if(body != null) remove(body);

        body = new Entity(786, 390);
        var scale = 0.3;
        var skinColor = MainEngine.SKIN_COLORS[Math.floor(Math.random() * MainEngine.SKIN_COLORS.length)];
        var hairColor = MainEngine.HAIR_COLORS[Math.floor(Math.random() * MainEngine.HAIR_COLORS.length)];
        var img = new Image("graphics/hair0" + 
                (Math.floor(Math.random() * MainEngine.HAIR_STYLES) + 1) + ".png");
        img.color = hairColor;
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        img = new Image("graphics/body.png");
        img.color = skinColor;
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        img = Math.random() > 0.5 ? new Image("graphics/body_dress.png") :
                new Image("graphics/body_suit.png");
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        img = new Image("graphics/face.png");
        img.color = skinColor;
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        img = new Image("graphics/mouthcenterclose.png");
        img.x = 216 * scale; img.y = 709 * scale;
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        img = new Image("graphics/mouthrightclosed01.png");
        img.x = 216 * scale; img.y = 709 * scale;
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        img = new Image("graphics/mouthleftclosed01.png");
        img.x = 216 * scale; img.y = 709 * scale;
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        img = new Image("graphics/nose01.png");
        img.x = 279 * scale; img.y = 447 * scale;
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        img = new Image("graphics/eyeleft01.png");
        img.x = 134 * scale; img.y = 339 * scale;
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        img = new Image("graphics/eyeright01.png");
        img.x = 388 * scale; img.y = 339 * scale;
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        img = new Image("graphics/browleft01.png");
        img.x = 134 * scale; img.y = 339 * scale;
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        img = new Image("graphics/browright01.png");
        img.x = 388 * scale; img.y = 339 * scale;
        img.scaleX = img.scaleY = scale;
        body.addGraphic(img);
        add(body);
    }

    private function itsAMatch(){
        remove(body);
        remove(minglrSearch);
        remove(btno);
        remove(btbytes);
        matchFlag = true;

        mybody = new Entity(0, 0);
        var scale = 0.22;
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

        var match = new Entity();
        var img = new Image("graphics/pregame/minglr_match_bg.png");
        img.x = 592; img.y = 407;
        match.addGraphic(img);

        img = new Image("graphics/pregame/minglr_match_container.png");
        img.x = 640; img.y = 452;
        match.addGraphic(img);

        img = new Image("graphics/pregame/minglr_match_container.png");
        img.x = 1001; img.y = 452;
        match.addGraphic(img);

        img = new Image("graphics/pregame/minglr_match_text_container.png");
        img.x = 628; img.y = 696;
        match.addGraphic(img);

        img = new Image("graphics/pregame/minglr_match_title.png");
        img.x = 780; img.y = 376;
        match.addGraphic(img);

        var matchFront = new Entity();
        img = new Image("graphics/pregame/minglr_match_text_container.png");
        img.x = 989; img.y = 696;
        matchFront.addGraphic(img);

        img = new Image("graphics/pregame/minglr_match_text_container.png");
        img.x = 628; img.y = 696;
        matchFront.addGraphic(img);

        for(g in cast(body.graphic, Graphiclist).children){
            var img = cast(g, Image);
            img.x = img.x / img.scaleX * scale;
            img.y = img.y / img.scaleY * scale;
            img.scaleX = img.scaleY = scale;
        }

        add(match);

        mybody.x = 675;
        mybody.y = 465;
        add(mybody);

        body.x = 1028;
        body.y = 465;
        add(body);

        add(matchFront);

        gotoDate = new Entity();
        gotoDate.addGraphic(new Image("graphics/pregame/minglr_match_bt.png"));
        gotoDate.x = 575; gotoDate.y = 807;
        gotoDate.setHitbox(Math.floor(756 * HXP.engine.scaleX), 
                Math.floor(145 * HXP.engine.scaleY));
        add(gotoDate);
    }

    override public function update(){
        super.update();

        if(Input.mousePressed){
            if(!matchFlag){
                if(btno.collidePoint(btno.x * HXP.engine.scaleX,
                            btno.y * HXP.engine.scaleY, Input.mouseX, Input.mouseY)){
                    createMinglr();
                } 
                if(btbytes.collidePoint(btbytes.x * HXP.engine.scaleX,
                            btbytes.y * HXP.engine.scaleY, Input.mouseX, Input.mouseY)) {
                    itsAMatch();
                }
            } else if(gotoDate.collidePoint(gotoDate.x * HXP.engine.scaleX,
                    gotoDate.y * HXP.engine.scaleY, Input.mouseX, Input.mouseY)) {
                HXP.scene = new MainScene();
            }
        }
        // TODO - corrigir fade depois
        //MainEngine.songFader.fadeTo(0.0, 2.0);
        //_sfxSong.stop();
        //HXP.scene = new MainScene();
    }
}