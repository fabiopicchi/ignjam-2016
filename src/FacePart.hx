import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

class FacePart extends Entity{
    private var _graphiclist:Graphiclist = new Graphiclist();
    private var _graphicIndex:Int = 0;

    public var index(get, null):Int;
    private function get_index() return _graphicIndex;

    public function new(x:Int, y:Int, width:Int, height:Int){
        super(x, y, _graphiclist); 
        setHitbox(width, height);
        centerOrigin();
    }

    override public function addGraphic(graphic:Graphic):Graphic{
        var image = cast(graphic, Image);

        _graphicIndex = _graphiclist.count;
        for(g in _graphiclist.children) g.visible = false;

        graphic.x = -image.width >> 1;
        graphic.y = -image.height >> 1;

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

    private function updateGraphic(index:Int):Void{
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
