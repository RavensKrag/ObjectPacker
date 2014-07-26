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
			return line unless line.include? '.new'
			
			
			
			parts = line.split('=').collect{ |i| i.strip }
			# ['Class.new arg1, arg2, ..., argn', 'var']
			
			# split up into three segments
			class_name = parts[0].split('.new')[0].strip # 'Class'
			arg_blob   = parts[0].split('.new')[1].strip # 'arg1, arg2, ..., argn'
			var_name   = parts[1]                        # 'var'
			
			
			# take all arguments,
			# create one line for each argument that needs to be extracted from the object
			lines =	arg_blob.split(/,\s*/).collect do |arg|
						# accessor should not repeat the name of the variable
						accessor =	arg.sub(/#{var_name}_/, '')
						
						"#{arg} = #{var_name}.#{accessor}"
					end
			
			# merge the lines into one blob that will be appended to file
			return lines.join("\n")
				# WARNING: this means that the Array containing all lines will not necessarily have one array entry per line, as this blob could have multiple lines encoded into one string.
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