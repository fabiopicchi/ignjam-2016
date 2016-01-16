import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

class MainScene extends Scene
{
    private var _charConfig:Array<Int>;
    private var _interactiveFaceParts:Array<FacePart>;
    private var _actionBar:ActionBar;
    private var _paused:Bool;
    private var _pausedMenu:Entity;

    public function new(charConfig:Array<Int>){
        super();
        _charConfig = charConfig;
        _paused = false;
    }

    override public function begin(){
        _interactiveFaceParts = new Array<FacePart>();

        var p = new FacePart(100, 100, 50, 50);

        p.addGraphic(Image.createRect(50, 50, 0xFF0000));
        p.addGraphic(Image.createRect(40, 50, 0x00FF00));
        p.addGraphic(Image.createRect(50, 40, 0x0000FF));
        p.addGraphic(Image.createRect(30, 50, 0x00FFFF));
        p.addGraphic(Image.createRect(50, 30, 0xFF00FF));
        p.addGraphic(Image.createRect(20, 50, 0xFFFF00));

        add(p);
        _interactiveFaceParts.push(p);

        p = new FacePart(200, 100, 50, 50);

        p.addGraphic(Image.createRect(50, 50, 0xFF0000));
        p.addGraphic(Image.createRect(40, 50, 0x00FF00));
        p.addGraphic(Image.createRect(50, 40, 0x0000FF));
        p.addGraphic(Image.createRect(30, 50, 0x00FFFF));
        p.addGraphic(Image.createRect(50, 30, 0xFF00FF));
        p.addGraphic(Image.createRect(20, 50, 0xFFFF00));

        add(p);
        _interactiveFaceParts.push(p);

        p = new FacePart(300, 100, 50, 50);

        p.addGraphic(Image.createRect(50, 50, 0xFF0000));
        p.addGraphic(Image.createRect(40, 50, 0x00FF00));
        p.addGraphic(Image.createRect(50, 40, 0x0000FF));
        p.addGraphic(Image.createRect(30, 50, 0x00FFFF));
        p.addGraphic(Image.createRect(50, 30, 0xFF00FF));
        p.addGraphic(Image.createRect(20, 50, 0xFFFF00));

        add(p);
        _interactiveFaceParts.push(p);

        _actionBar = new ActionBar(20, 20);
        add(_actionBar);
        _actionBar.start(15.0, checkScore);

        add(new AnimatedText(100, 400, 
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry."));

        _pausedMenu = new Entity();
        _pausedMenu.graphic = Image.createRect(HXP.width, HXP.height, 0x000000, 0.4);
        _pausedMenu.visible = _paused;
        add(_pausedMenu);
    }

    public function checkScore(){
        for(fp in _interactiveFaceParts){
            if(fp.index == 1)
                trace("score");
        }

        _actionBar.start(15.0, checkScore);
    }

    override public function update(){
        if(Input.pressed(Key.ESCAPE))
            _pausedMenu.visible = _paused = !_paused;

        if(_paused) return;
        
        super.update();
    }

}
