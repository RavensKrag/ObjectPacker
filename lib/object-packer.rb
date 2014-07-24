# require 'object-packer/object-packer' # Load c extension files

require 'rubygems'
require 'require_all'

require 'pathname'

path_to_file = File.expand_path(File.dirname(__FILE__))
Dir.chdir path_to_file do
	require_all './object-packer/build_system/'
end




class Foo


def initialize(source_dir, output_dir)
	@source_dir = source_dir
	@output_dir = output_dir
	
	puts "input  = #{File.expand_path @source_dir}"
	puts "output = #{File.expand_path @output_dir}"
end

def run
	# find all files with ruby extension in the source dir, and get only the file names
	# (take the path off)
	source_files = Dir[File.join(@source_dir, '*.rb')].collect{|i| Pathname.new(i).basename.to_s}
	
	# process filenames
	source_files.each do |filename|
		source = filename
		
		templates = ["pack.rb", "unpack.rb"] # TODO: just use every template in the template dir
		compiled_files = templates.collect{ |type| "#{filename.strip_extension}_#{type}" }
		
		
		templates.zip(compiled_files).each do |template_name, complied_filename|
			
			# ---------
			# file complied_filename => source, template_name do
				input_filepath  = File.expand_path  source,            @source_dir
				output_filepath = File.expand_path  complied_filename, @output_dir
				
				
				make_from_template input_filepath, output_filepath do |lines|
					# --- operations that apply to ALL lines ---
					lines
						.collect!{|l| l.strip_comment }
						.strip_blank_lines!
					# ------------------------------------------
					
					
					
					header, body = split_header_from_body(lines)
					
					hash = parse_header(header)
					
					
					puts "#{source} ---"
					p hash
					puts "\n\n"
					
					
					
					# pseudo return
					lines
				end
			# end
			# ---------
			
		end
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

# separate header from body
# (header exists between two lines that only consist of '---')
def split_header_from_body(lines)
	head, tail = 
		lines
			.each_with_index                          # iterate with indexes (generates pairs)
			.partition{|x,i| i < lines.rindex('---')} # split into before and after the final '---'
			.collect{|i| i.collect{|j|  j.first}}     # flatten array, discarding indexes
	
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
	
	
	
	
	hash['CLASS'] = hash['CLASS'].first # only one
	
	
	# hash['ARGS'] # this is totally fine
	
	
	
	hash['OBJECT'] = hash['OBJECT'].join # got split in a weird place
		# name(arg, arg, arg, ..., arg)
		
		# name : part before the parens start
		# args : part inside the parens (excluding parens)
		
		matchdata = /(?<name>.*?)\s*\((?<args>.*)\)/.match hash['OBJECT']
		
		
		p matchdata
		
		
		# format it
		name = matchdata[:name]
		args = matchdata[:args].split /,\s*/
		
		
		# pack it up
		# TODO: pack this data better. consider a struct or something (or even just a hash)
		hash['OBJECT'] = [name, *args]
	

	return hash
end



end

