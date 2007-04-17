require 'malline/view_proxy.rb'
require 'malline/view_wrapper.rb'

module Malline
	class Base
		def initialize(view)
			@view = view
			@view.extend ViewWrapper
		end

		def render(tpl, local_assigns = {}, n = nil)
			add_local_assigns local_assigns
			@view.instance_eval do
				@__dom = []
				eval tpl
				__render
			end
		end

		private
		def add_local_assigns l
			@view.instance_eval do
				l.each do |key, value|
					instance_variable_set "@#{key}", value
				end
				class << self; self; end.send(:attr_accessor, *(l.keys))
			end
		end
	end
end
