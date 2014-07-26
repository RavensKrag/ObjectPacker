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
			
			# return multiple lines
			return lines
				# WARNING: this means that the Array containing all lines will not necessarily have one array entry per line, as this blob could have multiple lines encoded into one string.
		end
		
		# OBJECT is the thing being examined
		# this replaces it with a reference to self
		# but the replacement is not on the OBJECT tag,
		# but on variables within the BODY text that have the same name
		def replace_object_with_self(line, header_data)
			# NOTE: be careful not to replace all instances of the OBJECT name, just the variable names
			
			# consider the case when there's an equals sign
			# foo = OBJECT.some.other.things		(not necessarily dot operator delineated)
			
			# has to just by the OBJECT string by itself
			# if it has anything around it, it can only be
			# an equal sign and some whitespace before,
			# or some sort of accessing operators after
				# dot operator
				# array-style access --> [] brackets (most likely brackets would have some contents)
			
			
			# can't seem to get non-capturing groups working with #sub, so I'll do it this way
			exp = /(\=\s*)?(#{header_data['OBJECT']})((\[.*\])|(\..*))/
			line.gsub!(exp, '\1self\4\5')
			# '\1\2\4\5' is orig string (replace second group only) (\3 wraps \4 and \5, so omit it)
			# NOTE: this expression no longer matches OBJECT by itself
			# but that's not really useful for the problem I'm trying to solve here
			
			
			
			return line
		end
		
		# blank out lines with bang commands
		def process_bang_command_with_arguments(line, header_data)
			# obj.some_text!(foo) --> foo = obj.foo
			# (similar pattern seen in extraction_from_initialization)
			
			str = line.gsub /\s*?(.*)\.(.*)\!(\((.*)\))/, '\4 = \1.\4'
							# \4 is just \3 with the parentheses
			
			# remove any possible whitespace from within the original parentheses
			# can't have any of that when it gets turned into an accessor method
			str.split_and_rejoin do |lines|
				lines.collect! do |l|
					parts = l.split('=')
					parts.each{ |i| i.split.join }
					
					parts.join ' = '
				end
			end
			
			return str
		end
		
		# blank out lines with bang commands
		def ignore_bang_commands(line, header_data)
			regexp = /.*!(?:\(.*\))?/ # some_text!(foo) <-- parens and contents optional
			
			# blank out the line, or return it as-is
			line =~ regexp  ? '' : line
		end
		
		def special_case_property_substitution(line, header_data)
			[:width, :height, :radius].each do |property|
				line.gsub! /self.#{property}/, "self[:physics].shape.#{property}"
			end
			
			return line
		end
	end
	end
end