module ObjectPacker
	# applies line transforms
	module LineTransforms
	class << self
		def example_foo(line, header_data)
			line
		end
		
		
		
		def strip_comments(line, header_data)
			line.strip_comment
		end
		
		# x = a --> a = x
		def reverse_assignment(line, header_data)
			line.split('=').collect{ |i| i.strip }.reverse.join(' = ')
		end
		
		# format: Class.new arg1, arg2, ..., argn = var
		# result: arg = var.arg
		def extraction_from_initialization(line, header_data)
			line
		end
		
		# OBJECT is the thing being examined
		# this replaces it with a reference to self
		# but the replacement is not on the OBJECT tag,
		# but on variables within the BODY text that have the same name
		def replace_object_with_self(line, header_data)
			line
		end
		
		# blank out lines with bang commands
		def process_bang_command_with_arguments(line, header_data)
			line
		end
		
		# blank out lines with bang commands
		def ignore_bang_commands(line, header_data)
			regexp = /.*!(?:\(.*\))?/ # some_text!(foo) <-- parens and contents optional
			
			# blank out the line, or return it as-is
			line =~ regexp  ? '' : line
		end
		
		def special_case_property_substitution(line, header_data)
			line
		end
	end
	end
end