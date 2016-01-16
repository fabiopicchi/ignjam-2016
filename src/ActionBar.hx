import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

class ActionBar extends Entity
{
    private var _duration:Float;
    private var _timeLasting:Float;
    private var _running:Bool;
    private var _callback:Void -> Void;

    public function new(x:Int, y:Int){
        super(x, y);
        graphic = Image.createRect(400, 10, 0xFFFFFF);
    }

    public function start(duration:Float, callback:Void -> Void){
        _running = true;
        _duration = duration;
        _timeLasting = _duration;
        _callback = callback;
    }

    override public function update(){
        if(_running){
            _timeLasting -= HXP.elapsed;
            if(_timeLasting < 0){
                _running = false;      
                _callback(); 
                _timeLasting = 0;
            }
            cast(graphic, Image).scaleX = _timeLasting / _duration;
        }

        super.update();
    }

}
