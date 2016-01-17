import openfl.display.BlendMode;
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
    private var content:Image;

    public function new(x:Int, y:Int){
        super(x, y);
        var img = new Image("graphics/timerbase.png");
        img.x = 40; img.y = 70;
        addGraphic(img);
 
        content = new Image("graphics/timercontent.png");
        content.x = 50; content.y = 116;
        content.scaleY = 0;
        addGraphic(content);

        addGraphic(new Image("graphics/timerdeco.png"));
    }

    public function start(duration:Float, callback:Void -> Void){
        _running = true;
        _timeLasting = _duration = duration;
        _callback = callback;
        content.y = 116 + 834;
    }

    override public function update(){
        if(_running){
            _timeLasting -= HXP.elapsed;
            if(_timeLasting < 0){
                _running = false;      
                _timeLasting = 0;
                _callback(); 
            }
            content.y = 116 + 834 * _timeLasting / _duration;
            content.scaleY = (1 - _timeLasting / _duration);
        }

        super.update();
    }

}
