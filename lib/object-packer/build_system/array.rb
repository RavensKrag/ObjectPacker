class Array
	# (assumes array is already sorted, and contain no duplicates)
	def to_range_list
		# src: http://stackoverflow.com/a/3728942
		# (modified a little bit)
		self.inject([]) do |spans, n|
			if spans.empty? || spans.last.last != n - 1
				spans + [n..n]
			else
				spans[0..-2] + [spans.last.first..n]
			end
		end
	end
	
	
	
	
	
	def find_and_replace!(regex, replacement)
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
	# (the name comes from String#strip! and similar)
	def strip_blank_lines!
		# algorithm: figure out what lines to remove - mark and execute
		# (flag undesirables, then remove them all in one pass)
		
		
		# work inwards from the outside until you fine lines that are not empty
		min_i = self.index{ |line| line != "" }
		max_i = self.rindex{ |line| line != "" }
		
		
		
		
		# need to keep everything in this range
		# and discard everything else
		# (min_i..max_i)
		# 
		# 
		# need to remove all things in these two ranges
		# (0..min_i) + (max_i..-1)
		# well, except the limits need to be moved outwards by one position,
		# because the initial search find the first non-empty lines
		# 
		# but, there might only be empty lines on one side or the other
		
		
		# --- figure out what to get rid of
		lower_range = (0..(min_i-1))
		upper_range = ((max_i+1)..(self.size-1))
		
		
		# delete ranges if malformed
		lower_range = nil unless lower_range.max
		upper_range = nil unless upper_range.max
		
		# delete lower range if it is the same as the upper one
		# (Don't want to try to delete things twice. That could get messy)
		upper_range = nil if upper_range == lower_range
		
		
		# --- mark and execute
		# flag unnecessary elements
		self[lower_range] = nil if lower_range
		self[upper_range] = nil if upper_range
		
		# condense array so only desirables remain
		self.compact!
		
		
		return self
	end
	
	# non in-place variant of the above method
	def strip_blank_lines
		# algorithm: keep only the non-blank lines
		
		
		# work inwards from the outside until you fine lines that are not empty
		min_i = self.index{ |line| line != "" }
		max_i = self.rindex{ |line| line != "" }
		
		
		# keep only the things inside the range
		range = (min_i..max_i)
		
		
		unless range.max < range.min # only on ascending
			return self.each_index.select {|i|  range.include? i }
		else
			return self.clone
		end
	end
	
	
	def indent_each_line(indent_sequence="\t")
		return self.collect{ |line|	"#{indent_sequence}#{line}" }
	end
	
	# in place version of above method
	def indent_each_line!(indent_sequence="\t")
		return self.collect!{ |line|	"#{indent_sequence}#{line}" }
	end
end