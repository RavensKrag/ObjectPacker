#!/usr/bin/env ruby

require 'rubygems'

require 'yaml'





puts "execution directory: #{Dir.pwd}"

config_filepath = File.join('.', 'object-packer.config.yml')
data = YAML.load_file config_filepath

source_dir = File.absolute_path data[:source_directory]
output_dir = File.absolute_path data[:output_directory]





path_to_file = File.expand_path(File.dirname(__FILE__))
Dir.chdir path_to_file do
	system "rake source_dir='#{source_dir}' output_dir='#{output_dir}'"
end
