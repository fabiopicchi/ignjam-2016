import com.haxepunk.Tween;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.Entity;

class PlayerDate extends Entity {
    
    private var _imgArray:Array<Image>;
    private var _curIndex:Int = 0;
    private var _framerate:Int = 10;

    public function new(hair:Int){
        super(-160, 81);

        addGraphic(new Image("graphics/date_mouth_shut.png"));
        _imgArray = [];
        for(i in 1...5) {
            _imgArray.push(new Image("graphics/date_mouth_talk0" + i + ".png")); 
            addGraphic(_imgArray[i - 1]).visible = false;
        }
        addGraphic(new Image("graphics/date_head.png"));
        addGraphic(new Image("graphics/date_hair0" + hair + ".png"));
    }

    public function startTalking(){
        cast(graphic, Graphiclist).children[0].visible = false;
        _curIndex = 0;
        _imgArray[0].visible = true;
        addTween(new Tween(1/_framerate, TweenType.OneShot, switchFrames)).start();
    }

    public function stopTalking(){
        for(img in _imgArray) img.visible = false;
        cast(graphic, Graphiclist).children[0].visible = true;
        clearTweens();
    }

    private function switchFrames(d:Dynamic){
        _curIndex = (_curIndex + 1) % _imgArray.length; 
        for(img in _imgArray){
            img.visible = false;
        }

        _imgArray[_curIndex].visible = true;

        addTween(new Tween(1/_framerate, TweenType.OneShot, switchFrames)).start();
    }
}
