import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.tweens.sound.SfxFader;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;

class MenuScene extends Scene
{
    private var _p:FacePart;
    private var _p2:FacePart;
    private var _btRand:Entity;
    private var _btBegin:Entity;
	
	private var _sfxSong = new Sfx("audio/song_title.ogg");
	

    override public function begin(){
        _btRand = new Entity();
        _btRand.setHitbox(Math.floor(50 * HXP.engine.scaleX), 
                Math.floor(20 * HXP.engine.scaleY));
        _btRand.addGraphic(Image.createRect(50, 20, 0xAAAAAA));
        _btRand.addGraphic(new Text("RAND"));
        add(_btRand);

        _btBegin = new Entity(HXP.width / 0.625 - 70, 0);
        _btBegin.setHitbox(Math.floor(70 * HXP.engine.scaleX), 
                Math.floor(20 * HXP.engine.scaleY));
        _btBegin.addGraphic(Image.createRect(70, 20, 0xAAAAAA));
        _btBegin.addGraphic(new Text("START"));
        add(_btBegin);
		
	_sfxSong.loop();
		//MainEngine.songFader = new SfxFader(_sfxSong);
		//HXP.world.addTween(MainEngine.songFader);
    }

    override public function update(){
        super.update();
		
        if(Input.mousePressed){
            if(_btBegin.collidePoint(_btBegin.x * HXP.engine.scaleX, _btBegin.y * HXP.engine.scaleX, Input.mouseX, Input.mouseY)){
                HXP.scene = new MainScene();
                // TODO - corrigir fade depois
                //MainEngine.songFader.fadeTo(0.0, 2.0);
                _sfxSong.stop();
                HXP.scene = new MainScene();
            }
        }
    }

}
