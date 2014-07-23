# wraps the string class, so I don't have to pollute String with monkey patches
# that only apply to the build system
# (I think it's more like just part of the system at that)

# Contains manipulations to turn the 'load' body into the 'dump' body

# All methods should take no arguments, manipulate @string, and return self
module ThoughtTrace



class StringWrapper
	attr_reader :string
	
	def initialize(string, obj, args)
		@string = string
		
		@object = obj
		@args = args
	end
	
	
	def strip_comments
		@string = @string.strip_comment
		
		return self
	end
	
	# x = a --> a = x
	def reverse_assignment
		@string = @string.split('=').collect{ |i| i.strip }.reverse.join(' = ')
		
		return self
	end
	
	# format: Class.new arg1, arg2, ..., argn = var
	# result: arg = var.arg
	def extraction_from_initialization
		if @string.include? '.new'
			
			parts = @string.split('=').collect{ |i| i.strip }
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
			@string = lines.join("\n")
				# WARNING: this means that the Array containing all lines will not necessarily have one array entry per line, as this blob could have multiple lines encoded into one string.
			
		end
		
		return self
	end
	
	# OBJECT is the thing being examined
	# this replaces it with a reference to self
	# but the replacement is not on the OBJECT tag,
	# but on variables within the BODY text that have the same name
	def replace_object_with_self
		# NOTE: be careful not to replace all instances of the OBJECT name, just the variable names
		
		# consider the case when there's an equals sign
		# foo = OBJECT.some.other.things		(not necessarily dot operator delineated)
		
		# has to just by the OBJECT string by itself
		# if it has anything around it, it can only be
		# an equal sign and some whitespace before,
		# or some sort of accessing operators after
			# dot operator
			# array-style access --> [] brackets (most likely brackets would have some contents)
		
		
		# exp = /(?:\=\s*)?(#{@object})(?:\[.*\])?(?:\..*)?/
		# puts @string.scan exp # DEBUG OUT
		# @string.sub!(exp, 'self')
		
		
		# # can't seem to get non-capturing groups working with #sub, so I'll do it this way
		# exp = /(\=\s*)?(#{@object})(\[.*\])?(\..*)?/
		# @string.sub!(exp, '\1self\3\4') # '\1\2\3\4' is orig string (replace second group only)
		
		
		# can't seem to get non-capturing groups working with #sub, so I'll do it this way
		exp = /(\=\s*)?(#{@object})((\[.*\])|(\..*))/
		@string.gsub!(exp, '\1self\4\5')
		# '\1\2\4\5' is orig string (replace second group only) (\3 wraps \4 and \5, so omit it)
		# NOTE: this expression no longer matches OBJECT by itself
		# but that's not really useful for the problem I'm trying to solve here
		
		
		
		return self
	end
	
	
	# blank out lines with bang commands
	def ignore_bang_commands
		if @string =~ /.*!(?:\(.*\))?/  # some_text!(foo) <-- parens and contents optional
			@string = ''
		end
		
		return self
	end
	
	
	def special_case_property_substitution
		[:width, :height, :radius].each do |property|
			@string.gsub! /self.#{property}/, "self[:physics].shape.#{property}"
		end
		
		return self
	end
	
	
	def process_bang_command_with_arguments
		# obj.some_text!(foo) --> foo = obj.foo
		# (similar pattern seen in extraction_from_initialization)
		
		str = @string.gsub /\s*?(.*)\.(.*)\!(\((.*)\))/, '\4 = \1.\4'
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
		
		@string = str
		
		return self
	end
end


end