# require 'object-packer/object-packer' # Load c extension files

require 'rubygems'
require 'require-all'

path_to_file = File.expand_path(File.dirname(__FILE__))
Dir.chdir path_to_file do
	require_all './object-packer/build_sytem'
end




class Foo


def initialize(source_dir, output_dir)
	@source_dir = source_dir
	@output_dir = output_dir
end

def run
	source_files = Dir[File.join(@source_dir, '*')]

	source_files.each do |filename|
		source = filename
		
		templates = ["pack.rb", "unpack.rb"] # TODO: just use every template in the template dir
		compiled_files = templates.collect{ |type| "#{filename}_#{type}" }
		
		
		templates.zip(compiled_files).each do |template_name, complied_filename|
			
			# ---------
			file complied_filename => source, template_name do
				input_filepath  = File.expand_path  source,            @source_dir
				output_filepath = File.expand_path  complied_filename, @output_dir
				
				
				make_from_template input_filepath, output_filepath do |lines|
					# basic find and replace
					lines.find_and_replace!(/ARGS/, args)
					lines.find_and_replace!(/OBJECT/, obj)
				end
			end
			# ---------
			
		end
	end
end


private

def make_from_template(input_file, output_file, &block)
	# read in template
	lines = File.readlines(input_file)
	
	# mutate text
	lines = block.call lines
	
	str = lines.join('') # TODO: see if this line is necessary
	
	# output new file
	File.open(output_file, 'w') do |f|
		f.puts str
	end
	
	return str
end



end

