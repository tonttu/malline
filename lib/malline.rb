require 'malline/view_proxy.rb'
require 'malline/view_wrapper.rb'
require 'malline/view_xhtml.rb'

module Malline
	class Base
		@@options = { :strict => true, :xhtml => true, :encoding => 'UTF-8', :lang => 'en' }
		attr_reader :view

		def initialize(*opts)
			@options = @@options.dup
			@options.merge! opts.pop if opts.last.is_a?(Hash)

			@view = opts.pop || Class.new
			@view.extend ViewWrapper
			@view.init_wrapper @options

			Malline::XHTML.load_plugin self if @options[:xhtml]
		end

		def self.setopt hash
			output = nil
			if block_given?
				o = @@options.dup
				@@options.merge!(hash) if hash
				begin
					output = yield
				ensure
					@@options = o
				end
			else
				@@options.merge!(hash)
			end
			output
		end

		def render(tpl, local_assigns = {}, n = nil)
			run(local_assigns) { eval tpl }
		end

		def self.run local_assigns = {}, &block
			self.new.run(local_assigns, &block)
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
				evaluate_assigns if respond_to?(:evaluate_assigns, true)
				class << self; self; end.send(:attr_accessor, *(l.keys))
			end
		end
	end
end
