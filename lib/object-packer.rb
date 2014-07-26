# require 'object-packer/object-packer' # Load c extension files

require 'pathname'
require 'find'

require 'rubygems'
require 'require_all'


path_to_file = File.expand_path(File.dirname(__FILE__))
Dir.chdir path_to_file do
	require_all './object-packer/build_system/'
end



module ObjectPacker
class << self
	def process(input_filepath, template_filepath, output_filepath)
		output_filename = Pathname.new(output_filepath).basename.to_s
		template_name = Pathname.new(template_filepath).basename.to_s
		input_name = Pathname.new(input_filepath).basename.to_s
		
		puts "Generating #{output_filename} based on #{input_name} and #{template_name}"
		
		
		
		
		
		# === deal with source file
		# --- load file
		source_lines = File.readlines(input_filepath)
		source_lines.each{ |line|  line.chomp! }
		
		# --- preprocessing on all lines
		source_lines
			.collect!{|l| l.strip_comment }
			.strip_blank_lines!
		
		# --- parse source
		header, body = split_header_from_body(source_lines)
		
		header_data = parse_header(header)
		body_data   = parse_body(body, header_data)
		
		# contains: 'OBJECT', 'FIELDS', 'CLASS', 'ARGS'
		data = header_data.merge body_data
		
		
		# === deal with template -> final complied output
		make_from_template template_filepath, output_filepath do |lines|
			# --- basic find-and-replace
			lines.find_and_replace!(/CLASS/,  data['CLASS'])
			lines.find_and_replace!(/FIELDS/, data['FIELDS'].join(', '))
			lines.find_and_replace!(/OBJECT/, data['OBJECT'])
			
			
			# --- parse body formatting in template
			
			# body is specified thusly:
				# BODY {
				# 	line_processing_method_1
				# 	line_processing_method_2
				# 	line_processing_method_3
				# }.document_process_a.document_process_b
			# 
			
			start, stop = find_body(lines)
			body_template, lines = extract_body(lines, start, stop)
			
			line_commands, document_commands = parse_template_body(body_template)
			
			
			# --- apply formatting to body data from source file
			line_commands.each do |command|
				body.collect!{ |line| LineTransforms.send command, line, data }
			end
			# TODO: allow for line transforms to send multiple lines back (would just need to flatten)
			
			document_commands.each do |command|
				DocumentTransforms.send command, body, data
			end
			
			
			# --- inject proper body into the template
			lines = lines.insert(start, body).flatten!
			
			
			
			# pseudo return
			lines
		end
	end
	
	
	private
	



	def make_from_template(input_file, output_file, &block)
		# read in template
		lines = File.readlines(input_file)
		
		# mutate text
		lines.each{ |line|  line.chomp! } # strip trailing newline from every line
		
		lines = block.call lines         # let block mutate lines
		
		str = lines.join("\n")           # merge the lines back into one text blob
		
		# output new file
		File.open(output_file, 'w') do |f|
			f.puts str
		end
		
		return str
	end
	
	
	
	
	
	
	# --- Deal with source file  ---
	# separate header from body
	# (header exists between two lines that only consist of '---')
	def split_header_from_body(lines)
		head, tail = 
			lines
			.each_with_index                          # iterate with indexes (generates pairs)
			.partition{|x,i| i < lines.rindex('---')} # split into before and after the final '---'
			.collect{|i| i.collect{|j|  j.first}}     # flatten inner array, discarding indexes
		
		# discard first element of both arrays
		# (those are just the '---' lines)
		head.shift
		tail.shift
		
		return head, tail
	end


	def parse_header(header)
		header.reject!{|i| i == '' }
		
		hash = 
			header.inject(Hash.new) do |collection, statement|
				name, *body = statement.split
				
				collection[name] = body
				
				collection # pseudo return
			end
		
		
		# hash['FIELDS'] # this is totally fine
		
		hash['OBJECT'] = hash['OBJECT'].first # only one
		

		return hash
	end
	
	def parse_body(body, header_data)
		# --- find the line where the OBJECT is initialized, and extract class and arguments
		line = body.find{ |line|  line =~ /#{header_data['OBJECT']}\s*=\s*.*/ }
		
		object_name, initialization_step = line.split('=').collect!{ |x|  x.strip! }
		
		# initialization can have two formats
		# => CLASS(arg, arg, ..., arg)
		# => CLASS arg, arg, ..., arg
		# (essentially, with or without parentheses)
		
		
		# regex explanation:
			# match class as portion before '.new',
			# and then match either
			# args1 : includes parentheses
			# args2 : no parentheses
		
		regexp = /(?<class>.*)(?:\.new)((\(\s*(?<args1>.*?)\s*\))|(\s*(?<args2>.*)\s*))/
		# this works fine, but it assumes that parentheses are balanced if they exist
		
		raise "Unmatched parenthesis in #{header_data['OBJECT']} initialization." unless initialization_step.balanced_parens?
		
		
		
		
		matchdata = initialization_step.match regexp
		
		klass = matchdata['class']
		args = matchdata['args1'] || matchdata['args2']
		
		
		
		args = args.split(/\s*,\s*/) # comma delineated list, any amount of whitespace is OK
		
		hash = {'CLASS' => klass, 'ARGS' => args}
		
		
		return hash
	end
	
	
	
	
	
	
	
	
	
	# --- Deal with template ---
	def find_body(template_lines)
		start = template_lines.each_with_index.find{|x,i| x =~ /BODY\s*\{/ }.last
			puts "start : #{start}"
		offset  = template_lines[start..-1].each_with_index.find{|x,i| x =~ /\}/ }.last
		stop = offset + start
			puts "stop  : #{stop}"
		
		
		return start, stop
	end

	def extract_body(lines, start, stop)
		range = (start..stop)
		body_template, lines = lines
								.each_with_index
								.partition{ |x,i|  range.include? i }
								.collect{|i| i.collect{|j|  j.first}}
		return body_template, lines
	end

	def parse_template_body(template_body_lines)
		# --- get rid of unnecessary whitespace around the lines
		# (indentation, etc)
		template_body_lines.each{ |i|  i.strip! }
		
		
		# --- separate the body into relevant segements
		template_body_lines.shift    # discard the first line ('BODY {' isn't that useful)
		document_command_data = template_body_lines.pop  # save the last line for later
		
		
		# --- clean up the segments
		line_commands = template_body_lines.reject{ |i|  i == '' }
		
		document_commands = document_command_data.split('.')
		document_commands.shift # first item is just '}' which is not useful
		
		
		return line_commands, document_commands
	end
end



end
