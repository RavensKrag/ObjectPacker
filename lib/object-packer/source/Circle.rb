ARGS x y radius

BODY {

circle = ThoughtTrace::Circle.new radius

circle[:physics].body.p.x = x
circle[:physics].body.p.y = y

}

OBJECT circle