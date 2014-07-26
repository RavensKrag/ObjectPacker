module ObjectPacker
	# All document transforms should modify the given array in-place
	module DocumentTransforms
	class << self
		def example_foo(body_lines, header_data)
			
		end
		
		
		
		def reverse!(body_lines, header_data)
			body_lines.reverse!
		end
		
		def strip_blank_lines!(body_lines, header_data)
			body_lines.strip_blank_lines!
		end
		
		def indent_each_line!(body_lines, header_data)
			indent_sequence = "\t"
			body_lines.collect!{ |line|	"#{indent_sequence}#{line}" }
		end
	end
	end
end