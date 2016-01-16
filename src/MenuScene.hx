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
                HXP.scene = new MainScene([]);
            }
        }
    }

}
