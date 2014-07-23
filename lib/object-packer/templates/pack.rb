# extract Entity class constant for a particular entity
# add a new instance method to that class


# have to do this with metaprogramming
# so that way you don't have to know class hierarchy
# of the thing you're trying to add methods to

# defining instance method
	# class_eval code is like writing something inside a class definition
	# instance_eval evaluates within the caller's scope
	
	# defining methods on an object attaches them to the meta of that object
	# because an object can't have methods,
	# only a class can have methods

klass = ThoughtTrace.const_get(:CLASS_NAME)
klass.class_eval do

def pack
	BODY {
		strip_comments
		reverse_assignment
		extraction_from_initialization
		
		replace_object_with_self
		
		process_bang_command_with_arguments
		ignore_bang_commands
		
		special_case_property_substitution
	}.reverse!.strip_blank_lines!

	return ARGS

end
end