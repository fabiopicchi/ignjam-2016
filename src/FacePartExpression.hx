import com.haxepunk.graphics.Image;

class FacePartExpression extends FacePart{
    private var _expressions:Array<Expression>;

    public function new(data:Dynamic){
        super(data); 
        _expressions = new Array<Expression>();
    }

    public function addExpression(image:Image, expression:Expression){
        addGraphic(image);
        _expressions.push(expression);
    }

    public var expression(get,null):Expression;
    private function get_expression() return _expressions[_graphicIndex];
}
