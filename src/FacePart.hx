import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.masks.Polygon;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

class FacePart extends Entity{
    private var _graphiclist:Graphiclist = new Graphiclist();
    private var _graphicIndex:Int = 0;
    private var _data:Dynamic;

    public var index(get, null):Int;
    private function get_index() return _graphicIndex;

    public function new(data:Dynamic){
        _data = data;
        super(_data.h_x, _data.h_y, _graphiclist); 
        setHitbox(_data.h_width, _data.h_height);
    }

    override public function added(){
        super.added();
        
        var e = new Entity(x, y);
        e.addGraphic(Image.createPolygon(Polygon.createFromArray([
                        0, 0, width, 0, width, height, 0, height]), 0xFF0000, 1, false));
        HXP.scene.add(e);
    }

    override public function addGraphic(graphic:Graphic):Graphic{
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

        if(Input.mousePressed && collidePoint(x, y, Input.mouseX, Input.mouseY))
            updateGraphic(cycleValue(_graphicIndex + 1, 0, _graphiclist.count - 1));

//        if(Input.rightMousePressed && collidePoint(x, y, Input.mouseX, Input.mouseY))
//            updateGraphic(cycleValue(_graphicIndex - 1, 0, _graphiclist.count - 1));
    }
}
