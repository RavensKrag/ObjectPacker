ARGS x y width height

BODY {

rectangle = ThoughtTrace::Rectangle.new width, height

rectangle[:physics].body.p.x = x
rectangle[:physics].body.p.y = y

}

OBJECT rectangle