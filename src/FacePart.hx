import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.masks.Polygon;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

class FacePart extends Entity {
    private var _graphiclist:Graphiclist = new Graphiclist();
    private var _graphicIndex:Int = 0;
    private var _data:Dynamic;

    private var _partNames:Array<String>;

    public var index(get, null):Int;
    private function get_index() return _graphicIndex;

    public function new(data:Dynamic){
        _data = data;
        super(_data.h_x, _data.h_y, _graphiclist); 
        setHitbox(Math.floor(_data.h_width * HXP.engine.scaleX),
                Math.floor(_data.h_height * HXP.engine.scaleY));
        _partNames = new Array<String>();
    }

    public function addNamedGraphic(name:String, graphic:Graphic) {
        _partNames.push(name);
        addGraphic(graphic);
    }

    override public function addGraphic(graphic:Graphic):Graphic {	
        var image = cast(graphic, Image);

        _graphicIndex = _graphiclist.count;
        for(g in _graphiclist.children) g.visible = false;

        graphic.x = _data.x - x;
        graphic.y = _data.y - y;

        return super.addGraphic(graphic);
    }

    public function randomize(){
        if(_graphiclist.count > 1)
        {
            var randomizedIndex = _graphicIndex;
            do { 
                randomizedIndex = Math.floor(Math.random() * _graphiclist.count);
            } while(randomizedIndex == _graphicIndex);

            updateGraphic(randomizedIndex);
        }
    }

    private static inline function cycleValue(v:Int, min:Int, max:Int):Int{
        if(v > max) return min;
        else if(v < min) return max;
        else return v;
    }

    public function updateGraphic(index:Int):Void{
        for(g in _graphiclist.children) g.visible = false;
        _graphiclist.children[index].visible = true;
        _graphicIndex = index;
    }

    override public function update():Void{
        super.update();

        if(Input.mousePressed && collideMouseScale())
            updateGraphic(cycleValue(_graphicIndex + 1, 0, _graphiclist.count - 1));
    }

    public function collideMouseScale():Bool{
        return collidePoint(x * HXP.engine.scaleX, y * HXP.engine.scaleX, Input.mouseX, Input.mouseY);
    }

    public function getPartName(i:Int = -1) {
        if (i < 0) {
            return _partNames[index];
        }
        return _partNames[i];
    }
}
