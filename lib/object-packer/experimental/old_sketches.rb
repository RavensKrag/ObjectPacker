# this file defines an function that returns a function
# the contents of this file can thus be executed,
# yielding a function
->(*args){
	# Split argument array into necessary variables
	# (argument array is the data loaded from the disk, packed into an array)
	font_name, x, y, height, string = args

	font = ThoughtTrace::Font.new font_name # remove overlapping "font" to resolve
	text = ThoughtTrace::Text.new font

	text.string = string

	text[:physics].body.p.x = x
	text[:physics].body.p.y = y

	text[:style][:height] = height
	text.resize! # this only needs to be run when loading
	# need to figure out how to resize automatically on font size change ASAP

	return text # need more unique identifier for space
	# may not actually need to expose this to the script
	# might want to just add the returned object to the space instead

}








# Split argument array into necessary variables
# (argument array is the data loaded from the disk, packed into an array)
INPUT font_name, x, y, height, string

font = ThoughtTrace::Font.new font_name # remove overlapping "font" to resolve
text = ThoughtTrace::Text.new font

text.string = string

text[:physics].body.p.x = x
text[:physics].body.p.y = y

text[:style][:height] = height
text.resize! # this only needs to be run when loading
# need to figure out how to resize automatically on font size change ASAP

OUTPUT text # need more unique identifier for space
# may not actually need to expose this to the script
# might want to just add the returned object to the space instead













# Split argument array into necessary variables
# (argument array is the data loaded from the disk, packed into an array)
font_name, x, y, height, string = args

font = ThoughtTrace::Font.new font_name # remove overlapping "font" to resolve
text = ThoughtTrace::Text.new font

text.string = string

text[:physics].body.p.x = x
text[:physics].body.p.y = y

text[:style][:height] = height
text.resize! # this only needs to be run when loading
# need to figure out how to resize automatically on font size change ASAP

return text # need more unique identifier for space
# may not actually need to expose this to the script
# might want to just add the returned object to the space instead


class Foo
	def load(*args)
		# Split argument array into necessary variables
		# (argument array is the data loaded from the disk, packed into an array)
		font_name, x, y, height, string = args

		font = ThoughtTrace::Font.new font_name # remove overlapping "font" to resolve
		text = ThoughtTrace::Text.new font
		
		text.string = string

		text[:physics].body.p.x = x
		text[:physics].body.p.y = y

		text[:style][:height] = height
		text.resize! # this only needs to be run when loading
		# need to figure out how to resize automatically on font size change ASAP

		return text # need more unique identifier for space
		# may not actually need to expose this to the script
		# might want to just add the returned object to the space instead
	end
	
	class << self
		def dump(obj)
			text = obj
			
			# examining this object: text


			text.resize!
			height = text[:style][:height]

			y = text[:physics].body.p.y
			x = text[:physics].body.p.x

			string = text.string

			font = text.font
			font_name = font.font_name

			return font_name, x, y, height, string
		end
	end
end

# don't define the general case pattern when a 'good enough'
# pattern will suffice
# (I don't plan to ever end lines with semicolons, even though that's valid Ruby syntax)
class (.*\n)
	def (?:.*)\n
		
	end
end









# Ruby regexp for matching between outmost pairs of curly braces
re = %r{
  (?<re>
    \{
      (?:
        (?> [^\{\}]+ )
        |
        \g<re>
      )*
    \}
  )
}x

# this link shows the recursive regexp structure
# http://stackoverflow.com/questions/6331065/matching-balanced-parenthesis-in-ruby-using-recursive-regular-expressions-like-p

# this link shows how to search for curly braces
# (you need to escape them)
# http://stackoverflow.com/questions/2210755/regex-for-matching-all-words-between-a-set-of-curly-braces

# thought a bit of my own experimentation, I realized you need to specify the characters TWICE:
# once as the outer pair, and once as the inner pair

# thought really, as pointed out in this response to a similar question
# (http://stackoverflow.com/a/1952970/571592)
# you should not be using regular expressions for this sort of thing
# I'm not quite sure what sort of thing you should be using, though...
