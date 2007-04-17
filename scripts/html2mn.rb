#!/usr/bin/env ruby

require "rexml/document"
include REXML

def esc str
	# todo
	str.split("'").join("\\'")
end

def attributes element
	element.attributes.keys.collect {|k| "'#{esc k}' => '#{esc element.attributes[k]}'" }.join(', ')
end

def txtize txt
	#txt.gsub(/(\s)\s*$/, '\1').gsub(/^(\s)\s*/, '\1')
	txt.gsub(/\s*$/, '').gsub(/^\s*/, '')
end

def convert element, prefix=''
	output = ''
	if element.is_a?(Array)
		element.each {|e| output << convert(e) }
	elsif element.is_a?(Element)
		output << prefix << element.name
		txt = ''
		children = element.children
		unless children.empty?
			if children.first.is_a?(Text)
				txt = txtize children.shift.to_s
				output << " '#{esc txt}'" unless txt.empty?
			end
		end

		output << (txt.empty? ? ' ' : ', ') << attributes(element) if element.has_attributes?
		unless children.empty?
			output << " do\n"
			children.each {|e| output << convert(e, prefix + "\t") }
			output << prefix << "end"
		end
		output << "\n"
	elsif element.is_a?(Text)
		txt = txtize(element.to_s)
		output << prefix << "txt! '#{esc txt}'\n" unless txt.empty?
	end
	output
end

input = File.open(ARGV.shift, 'r') rescue $stdin
output = File.open(ARGV.shift, 'w') rescue $stdout

doc = Document.new input


output.puts convert(doc.children)
