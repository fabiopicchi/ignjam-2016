import com.haxepunk.graphics.Image;

class FacePartExpression extends FacePart{
    private var _expressions:Array<Expression>;

    public function new(x:Int, y:Int, width:Int, height:Int){
        super(x, y, width, height); 
        _expressions = new Array<Expression>();
    }

    public function addExpression(image:Image, expression:Expression){
        addGraphic(image);
        _expressions.push(expression);
    }

    public var expression(get,null):Expression;
    private function get_expression() return _expressions[_graphicIndex];
}
