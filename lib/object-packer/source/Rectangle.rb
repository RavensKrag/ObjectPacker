---
CLASS ThoughtTrace::Rectangle
ARGS x y width height

OBJECT rectangle(width, height)
---

rectangle[:physics].body.p.x = x
rectangle[:physics].body.p.y = y