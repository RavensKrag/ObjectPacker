# This code is listed as if it's agnostic,
# but it's really just loading code

# it's not really strictly Ruby though
# and it doesn't have enough stuff to be strongly associated with text loading
# although that information is clear from the name of this file



# DEPENDENCIES [
# 	font_name => font => font.name
# 	font_name => font.name
# ]


ARGS font_name x y height string

BODY {

font = ThoughtTrace::Font.new font_name
text = ThoughtTrace::Text.new font

text.string = string

text[:physics].body.p.x = x
text[:physics].body.p.y = y

text.resize!(height) # this only needs to be run when loading
# TODO: figure out how to resize automatically on font size change ASAP

}

OBJECT text # need more unique identifier for space
# may not actually need to expose this to the script
# might want to just add the returned object to the space instead