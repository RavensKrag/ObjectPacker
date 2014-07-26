---
FIELDS x y width height

OBJECT rectangle
---

rectangle = ThoughtTrace::Rectangle.new width, height

rectangle[:physics].body.p.x = x
rectangle[:physics].body.p.y = y
