#!/usr/bin/env ruby

require 'rubygems'
require 'rake'


path_to_file = File.expand_path(File.dirname(__FILE__))



# code below on how to load and run a rakefile through ruby code is taken from stackexchange
# src: http://stackoverflow.com/questions/3530/how-do-i-rake-tasks-within-a-ruby-script

app = Rake.application
app.init


Dir.chdir path_to_file do
path_to_rakefile = File.join('.', 'Rakefile')
app.add_import path_to_rakefile
end

app.load_rakefile



puts Dir.pwd

app['default'].invoke
