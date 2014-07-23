

# structure for specifying order of procedures independently of the declaration order

line = get_some_input()

code = {
	:foo =>	Proc.new {
				line = line.split('=').collect{ |i| i.strip }.reverse.join(' = ')
			}
	
	:baz =>	Proc.new {
				if line.include? '.new'
					# format: Class.new arg1, arg2, ..., argn = var
					# result: arg = var.arg
					
					parts = line.split('=').collect{ |i| i.strip }
					# ['Class.new arg1, arg2, ..., argn', 'var']
					
					
					# split up into three segments
					a = parts[0].split('.new')[0].strip
					b = parts[0].split('.new')[1].strip
					c = parts[1]
					
					
					# take all arguments,
					# create one line for each argument that needs to be extracted from the object
					lines =	b.split(/,\s/).collect do |arg|
								"#{arg} = #{c}.#{arg}"
							end
					
					# merge the lines into one blob that will be appended to file
					line = lines.join("\n")
				end
			}
	
	:bar =>	Proc.new {
				
			}
}

[
	:foo,
	:baz,
	:bar
].each do |name|
	procedure = code[name]
	
	
	# this style can use Proc or lambda
	out = procedure.call line
	line = out unless out.nil?
	
	
	
	# for the 'variable leak' method, you must use Proc objects instead of lambda
	instance_eval &procedure # allows for using all variables from calling context
	# this will probably also pollute variable space
end