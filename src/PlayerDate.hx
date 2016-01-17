import com.haxepunk.Tween;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.Entity;

class PlayerDate extends Entity {
    
    private var _imgArray:Array<Image>;
    private var _curIndex:Int = 0;
    private var _framerate:Int = 15;

    public function new(imgArray:Array<Image>, hair:Int){
        super(-160, 81, imgArray[0]);

        addGraphic(new Image("graphics/date_head.png"));
        addGraphic(new Image("graphics/date_mouth_shut.png"));
        _imgArray = [];
        for(i in 1...4) {
            _imgArray.push(new Image("graphics/date_mouth_talk0" + i + ".png")); 
            //addGraphic(_imgArray[i - 1]).visible = false;
        }
        addGraphic(new Image("graphics/date_hair0" + hair + ".png"));

        _imgArray = imgArray;
    }

    public function startTalking(){
        cast(graphic, Graphiclist).children[1].visible = false;
        addTween(new Tween(1/_framerate, TweenType.Looping, switchFrames));
    }

    public function stopTalking(){
        for(img in _imgArray)
            img.visible = false;
        cast(graphic, Graphiclist).children[1].visible = true;
        clearTweens();
    }

    private function switchFrames(d:Dynamic){
        _curIndex = (_curIndex + 1) % _imgArray.length; 
        for(img in _imgArray)
            img.visible = false;

        _imgArray[_curIndex].visible = true;

        addTween(new Tween(1/_framerate, TweenType.Looping, switchFrames));
    }
}
