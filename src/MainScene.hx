import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;

class MainScene extends Scene
{
    public override function begin()
    {
        var p = new FacePart(0, 0, 50, 50);
        p.addGraphic(Image.createRect(50, 50, 0xFF0000));
        p.addGraphic(Image.createRect(40, 50, 0x00FF00));
        p.addGraphic(Image.createRect(50, 40, 0x0000FF));
        p.addGraphic(Image.createRect(30, 50, 0x00FFFF));
        p.addGraphic(Image.createRect(50, 30, 0xFF00FF));
        p.addGraphic(Image.createRect(20, 50, 0xFFFF00));

        add(p);
    }
}
