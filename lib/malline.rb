require 'malline/view_proxy.rb'
require 'malline/view_wrapper.rb'
require 'malline/view_xhtml.rb'

module Malline
	class Base
		@@options = { :strict => false, :xhtml => false }
		def initialize(view)
			@view = view
			@view.extend ViewWrapper

			@view.instance_eval do
				@_erbout = ErbOut.new(self)
				class << self; self; end.send(:define_method, :method_missing, method(:tag!))
			end unless @@options[:strict]

			definetags *Malline::XHTML_TAGS if @@options[:xhtml]
		end

		def self.setopt hash
			if block_given?
				o = @@options.dup
				@@options.merge!(hash)
				begin
					yield
				ensure
					@@options = o
				end
			else
				@@options.merge!(hash)
			end
		end

		def render(tpl, local_assigns = {}, n = nil)
			run(local_assigns) { eval tpl }
		end

		def self.run local_assigns = {}, &block
			self.new(Class.new).run(local_assigns, &block)
		end

		def run local_assigns = {}, &block
			add_local_assigns local_assigns
			@view.__run &block
		end

		def definetags *tags
			tags.each do |tag|
				eval %{
					def @view.#{tag}(*args, &block)
						tag!('#{tag}', *args, &block)
					end
				}
			end
		end

		private
		def add_local_assigns l
			@view.instance_eval do
				l.each { |key, value| instance_variable_set "@#{key}", value }
				evaluate_assigns if respond_to?(:evaluate_assigns)
				class << self; self; end.send(:attr_accessor, *(l.keys))
			end
		end
	end
end
