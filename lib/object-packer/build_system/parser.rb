module Parser
	MATCHING_CURLY_BRACES = %r{
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

	class << self

		# extract the BODY definition from the source
		def extract_body(source_lines)
			# start on line that says BODY and then find the code between the curly braces
			
			# same code from 'basic replacement section'
			# or rather, similar
			# searching for the index in the source_lines array where the line is found
			# rather than the line itself
			marker = 'BODY'
			index = source_lines.index_of_line_containing marker
			
			# all lines as one string
			# starting from the line where BODY is declared, until the end
			source_blob = source_lines[index..-1].join
			
			# extract desired code from the blob
			body = source_blob.scan(MATCHING_CURLY_BRACES)
			body = body.first.first # get the string out of the nested array structure
			
			# strip the brace characters off the found string
			# (take off the first and last characters)
			body = body[1..-2]
			
			return body
		end

		# Extract the BODY transform information from the template
		# 
		# find BODY line in template, and figure out what the transforms are
		# take the transforms off the line,
		# but leave the BODY marker in place, so you know where the body should go
		def extract_transforms(template_lines)
			marker = 'BODY'
			
			# TODO: store 'curly-brace finding' part of regex in variable, because it ends up being used at least twice
			
			expression = /\s*#{marker}\s*\{\s*/ # '   BODY { ' <-- any amount of whitespace anywhere
			
				
			index = template_lines.index_of_line_containing marker
			
			
			if template_lines[index].starts_with? expression
				return extract_multi_line_transforms(template_lines, index)
			else
				return extract_single_line_transforms(template_lines, index)
			end
		end


		# --- curly-brace (multi-line) format
		def extract_multi_line_transforms(template_lines, index)
			# statements listed between curly braces, one statement per line
			# - these statements should be applied to every line in the BODY
			# 
			# additional statements listed as in one-line format, after the ending brace
			# - these statements apply to the Array of lines as a whole
			
			# find the first line that contains a closing curly brace
			# which comes after the line with the body marker
			# the index of that line, is the ending index for the scan
			
			stop_index =	(index..(template_lines.size-1)).find do |i|
								template_lines[i].include? '}'
							end
			
			
			# assuming the 'first line' never contains transforms
			# (maybe that's weird considering how the last line could? I don't think so...)
			lines = template_lines[(index+1)..stop_index]
			line_transforms = lines[0..-2] # ignore last line
			# last line may or may not be a line transform (is '}' on a new line?)
			
			
			# figure out if there's a each-line transform on the last line or not
			parts = lines.last.split('}')
			if parts.size != 1
				p = parts.shift # take off the first element (pop is the last element)
				
				line_transforms << p unless p.whitespace_only?
			end
			
			
			raise "should only be one element left in parts" unless parts.size == 1
			array_transforms_string = parts.first
			
			
			
			
			# --- refine each-line transforms
			line_transforms.each do |line|
				line.strip!
			end
			
			line_transforms.collect! { |line| line.strip_comment }
			line_transforms.reject! { |line| line.whitespace_only? }
			
			
			# --- refine array-wide transforms
			array_transforms = array_transforms_string.strip!.split('.')
			array_transforms.shift # first element is always empty string; discard it
			
			
			
			# --- clean up ---
			# take the opening curly-brace off, along with any whitespace around it
			# (leaves the indentation intact, though)
			template_lines[index].sub! /\s*\{\s*/, ''
			
			# remove lines associated with transforms
			template_lines[(index+1)..stop_index] = nil
			template_lines.compact!
			
			
			
			return {:each_line => line_transforms, :whole_array => array_transforms}
		end

		# --- one-line format
		def extract_single_line_transforms(template_lines, index)
			line = template_lines[index]
			
			# take the transform declarations off the original line
			# "BODY.one.two.three" -> "BODY", ["one", "two", "three"]
			# (preserve any indentation on the original line)
			
			line.chomp! # strip newline so it doesn't end up in the parts array
				parts = line.split('.')
			line = parts.shift + "\n" # reintroduce the newline that was stripped
			
			
			template_lines[index] = line
			
			
			transforms = parts
			
			return {:each_line => transforms, :whole_array => []}
		end




		def transform_each_line(body_lines, transforms, obj, args)
			return if transforms.empty?
			
			
			body_lines.collect! do |line|
				line = ThoughtTrace::StringWrapper.new line, obj, args
				
				transforms.inject(line) do |line, method|
					unless line.is_a? ThoughtTrace::StringWrapper
						raise "Some transform did not return self"
					end
					
					unless line.respond_to? method
						raise "Transform undefined: '#{method}' (create method with that name in ThoughtTrace::StringWrapper)"
					end
					
					line.send method
				end
				
				# puts line.string # DEBUG OUT
				
				
				line.string # <-- this is the collected value
			end
		end

		def transform_whole_array(body_lines, transforms, obj, args)
			transforms.each do |t|
				body_lines.send t
			end
		end


	end
end