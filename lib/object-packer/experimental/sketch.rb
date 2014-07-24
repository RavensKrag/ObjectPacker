config = {
	# source files, and output directory
	source:
	dest:
	
	# templates
	pack:
	unpack:
}




# --- load files into memory
# --- filling out fields
# --- basic replacement
# --- body compilation
# --- write compiled file

# return a list of all files generated (pack and unpack) ? [I that's what this does?]






task :data_packing => all





file path_to_target => dependencies do
	# DEATH BALL
end


# basically, you're saying..
# + output file is dependent on some things
# + in order to generate this file, there is some procedure that needs to be run






# IMPORTANT!
# if any of the build system files change,
# you need to rebuild EVERYTHING

# always make sure that the output directories exist before starting up this whole process
# the files can not be written if the output directory does not exist
# DO NOT check for the directory every time,
# just check for the output directory before you spool up over-arching process



compiled_pack, compiled_unpack => source, pack_template, unpack_template

# may want to separate these two things out?
compiled_pack   => source, pack_template
compiled_unpack => source, unpack_template

# follow the same general procedure for both pack and unpack
# there are specifics routines that are only followed in one or the other



block = Proc.new do ||
	
end










source_files = Dir['./source/*']

source_files.each do |filename|
	source = filename
	
	templates = ["pack.rb", "unpack.rb"]
	compiled_files = templates.collect{ |type| "#{filename}_#{type}" }
	
	
	
	file compiled_pack   => source, pack_template do
		
	end

	file compiled_unpack => source, unpack_template do
		
	end
	
	
end






