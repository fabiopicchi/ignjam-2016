import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;

class MenuScene extends Scene
{
    private var _p:FacePart;
    private var _p2:FacePart;
    private var _btRand:Entity;
    private var _btBegin:Entity;

    override public function begin(){
        _p = new FacePart(100, 100, 50, 50);
        _p.addGraphic(Image.createRect(50, 50, 0xFF0000));
        _p.addGraphic(Image.createRect(40, 50, 0x00FF00));
        _p.addGraphic(Image.createRect(50, 40, 0x0000FF));
        _p.addGraphic(Image.createRect(30, 50, 0x00FFFF));
        _p.addGraphic(Image.createRect(50, 30, 0xFF00FF));
        _p.addGraphic(Image.createRect(20, 50, 0xFFFF00));
        add(_p);

        _p2 = new FacePart(100, 200, 50, 50);
        _p2.addGraphic(Image.createRect(50, 50, 0xFF0000));
        _p2.addGraphic(Image.createRect(40, 50, 0x00FF00));
        _p2.addGraphic(Image.createRect(50, 40, 0x0000FF));
        _p2.addGraphic(Image.createRect(30, 50, 0x00FFFF));
        _p2.addGraphic(Image.createRect(50, 30, 0xFF00FF));
        _p2.addGraphic(Image.createRect(20, 50, 0xFFFF00));
        add(_p2);

        _btRand = new Entity();
        _btRand.setHitbox(50, 20);
        _btRand.addGraphic(Image.createRect(50, 20, 0xAAAAAA));
        _btRand.addGraphic(new Text("RAND"));
        add(_btRand);

        _btBegin = new Entity(HXP.width - 70, 0);
        _btBegin.setHitbox(70, 20);
        _btBegin.addGraphic(Image.createRect(70, 20, 0xAAAAAA));
        _btBegin.addGraphic(new Text("START"));
        add(_btBegin);

    }

    override public function update(){
        super.update();
        
        if(Input.mousePressed){
            if(_btRand.collidePoint(_btRand.x, _btRand.y, Input.mouseX, Input.mouseY)){
                _p.randomize();
                _p2.randomize();
            }
            if(_btRand.collidePoint(_btBegin.x, _btBegin.y, Input.mouseX, Input.mouseY)){
                HXP.scene = new MainScene([_p.index, _p2.index]);
            }
        }
    }

}
