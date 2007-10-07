# Copyright © 2007 Riku Palomäki
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

module Malline
	class ViewProxy

		def initialize wrapper, tag
			@wrapper = wrapper
			@tag = tag
		end

		def __yld &block
			@wrapper.__yld @tag[:children], &block
		end

		def txt! value
			@tag[:children] << value
		end

		def method_missing(s, *args, &block)
			if args.last.is_a?(Hash)
				@tag[:attrs].merge!(args.pop)
			end

			if /\!$/ =~ s.to_s
				@tag[:attrs]['id'] = s.to_s.chomp('!')
			else
				@tag[:attrs]['class'] ||= ''
				@tag[:attrs]['class'] << " #{s.to_s}"
				@tag[:attrs]['class'].strip!
			end

			whitespace = @wrapper.__whitespace
			@wrapper.__whitespace = true if args.delete(:whitespace)
			txt = args.flatten.join('')
			@tag[:children] << txt unless txt.empty?

			@wrapper.__yld @tag[:children], &block if block_given?
			@wrapper.__whitespace = whitespace
			self
		end

	end
end
