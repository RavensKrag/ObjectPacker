#!/usr/bin/env ruby

path_to_file = File.expand_path(File.dirname(__FILE__))
Dir.chdir path_to_file do
	require '../lib/object-packer'
end

x = Foo.new('./source/', '')
x.run