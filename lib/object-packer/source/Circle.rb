---
FIELDS x y radius

OBJECT circle
---

circle = ThoughtTrace::Circle.new

circle[:physics].body.p.x = x
circle[:physics].body.p.y = y