# Copyright © 2007,2008 Riku Palomäki
#
# This file is part of Malline.
#
# Malline is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Malline is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Malline.  If not, see <http://www.gnu.org/licenses/>.


class ActionView::Template
	alias_method :orig_render, :render
	def render *args, &block
		old, @view.malline_is_active = @view.malline_is_active, false
		ret = orig_render *args, &block
		@view.malline_is_active = old
		ret
	end
end

module Malline
	class RailsHandler < ActionView::TemplateHandler
		include ActionView::TemplateHandlers::Compilable

		def self.line_offset
			3
		end

		def compile template
			puts "Compiling #{template.path}"
			path = template.path.gsub('\\', '\\\\\\').gsub("'", "\\\\'")
			"__malline_handler = Malline::Base.new self
			malline.path = '#{path}'
			__malline_handler.render do
				#{template.source}
			end"
		end

		def cache_fragment block, name = {}, options = nil
			puts "Cache_fragment"
			@view.fragment_for(block, name, options) do
				eval("__malline_handler.rendered", block.binding)
			end
		end
	end
end

ActionView::Template.register_template_handler 'mn', Malline::RailsHandler
