class Array
	def find_and_replace(regex, replacement)
		return if replacement.nil?
		
		self.each do |line|
			line.gsub! regex, replacement
		end
	end
	
	
	
	def find_line_containing(marker)
		return self.find{|line| line.include? marker}
	end
	
	def index_of_line_containing(marker)
		# same code from 'basic replacement section'
		# or rather, similar
		# searching for the index in the array where the line is found
		# rather than the line itself
		
		return self.index{|line| line.include? marker}
	end
	
	
	
	
	# remove leading and trailing empty lines
	def strip_blank_lines
		first_content_line = self.index{ |line| line != "" }
		last_content_line = self.rindex{ |line| line != "" }
		return self[first_content_line..last_content_line]
	end
	
	# in-place version of above method
	def strip_blank_lines!
		start_index = self.index{ |line| line != "" }
		end_index = self.rindex{ |line| line != "" }
		
		# move markers towards the outside, but make sure they do not exceed string boundaries
		# ie. lower end should not go before the start, high end should not go beyond the end
		min = 0
		max = self.size - 1
		
		start_index -= 1
		end_index += 1
		
		
		# clear all values outside of the good range
		# skip clearing a side it's associated ranges are malformed
		# (ie. high end is lower than low end)
		if start_index < end_index
			unless start_index < min
				# clear from start to first good line
				self[0..start_index] = nil
			end
			unless end_index > max
				# clear from last good line to end
				self[end_index..-1] = nil
			end
			
			
			self.compact! # remove the 'nil's from the last two statements
		end
		
		# what do you do if the first and last lines are the same line?
			# I mean, this sort of implies that the body is blank, which would be weird, but...
		
		
		
		return self
	end
	
	def indent_each_line(indent_sequence="\t")
		return self.collect{ |line|	"#{indent_sequence}#{line}" }
	end
	
	# in place version of above method
	def indent_each_line!(indent_sequence="\t")
		return self.collect!{ |line|	"#{indent_sequence}#{line}" }
	end
end