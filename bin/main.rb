#!/usr/bin/env ruby

path_to_file = File.expand_path(File.dirname(__FILE__))
Dir.chdir path_to_file do
	require '../lib/object-packer'
end


Dir.chdir File.join(path_to_file, '..', 'lib', 'object-packer') do
	puts Dir.pwd
	
	x = Foo.new('./source/', './compiled_files/')
	x.run
end