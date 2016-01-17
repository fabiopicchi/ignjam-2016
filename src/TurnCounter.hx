import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;
import openfl.text.TextFormatAlign;

class TurnCounter extends Entity{

    private var text:Text;
    private var counter:Int = 1;
    
    public function new(){
        super();
        addGraphic(new Image("graphics/turns.png"));
        var textFormat = {
            font : "font/Dion.otf", 
            size : 120,
            color : 0x000000,
            align: TextFormatAlign.CENTER,
            wordWrap : true
        };

        text = new Text("1/5", 36, 20, 195, 0, textFormat);
        addGraphic(text);
    }

    public function updateCounter():Void{
        text.text = (++counter) + "/5";
    }
    
}
