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

module Malline
	# Since some parts of Rails use ERB directly instead of current template
	# handler, we have to capture all that data.
	#
	# In practice the erb buffer object (named ActiveView::Base.erb_variable)
	# is a string, where data is simply concatted.
	class ErbOut
		def initialize view
			@view = view
		end
		# Redirect all data to view
		def concat value
			@view << value
		end
		alias_method :<<, :concat
	end
end
