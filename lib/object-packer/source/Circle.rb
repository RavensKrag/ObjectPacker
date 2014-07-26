---
FIELDS x y radius

OBJECT circle
---

circle = ThoughtTrace::Circle.new radius

circle[:physics].body.p.x = x
circle[:physics].body.p.y = y