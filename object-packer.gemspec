require File.expand_path("../lib/object-packer/version", __FILE__)

ENABLE_C_EXTENSION = false

Gem::Specification.new do |s|
	s.name        = "object-packer"
	s.version     = ObjectPacker::VERSION
	s.date        = "2014-07-23"
	s.platform    = Gem::Platform::RUBY
	s.authors     = ["Raven"]
	s.email       = "AvantFlux.Raven@gmail.com"
	s.homepage    = "https://github.com/RavensKrag"
	
	s.summary     = "Move data from objects to arrays and back. Useful in serialization pipeline."
	s.description = "\tThe way data is stored on disk is fairly similar to an array.\n\tIt's a bunch of data layed out in a line. So, it's easy to go from\n\tand array to any serialization format. This library focuses on converting\n\tfrom objects to arrays, so you can delay picking a serialization format.\n\t\n\tOr, even switch between formats (YAML, CSV, Array#pack, etc) as much as you like.\n\t\n\tIt's much easier when you separate object-to-data translation from memory-to-disk transfer.\n"
	
	s.required_rubygems_version = ">= 1.3.6"
	
	# lol - required for validation
	#~ s.rubyforge_project         = "newgem"
	
	# If you have other dependencies, add them here
	# s.add_dependency "another", "~> 1.2"
	s.add_dependency "require_all", ">=1.3.2"
	s.add_dependency "rake", ">=10.1.0"
	
	if ENABLE_C_EXTENSION
		s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
		s.extensions = ['ext/object-packer/extconf.rb']
	else
		s.files = Dir["{lib}/**/*.rb", "bin/*", "{ext}/**/*.{c,h,rb}", "LICENSE", "*.md"]
	end
	puts s.files
	
	s.require_path = 'lib'
	
	# If you need an executable, add it here
	s.executables = ["object-packer.rb"]
end
