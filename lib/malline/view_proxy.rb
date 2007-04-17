module Malline
	class ViewProxy

		def initialize wrapper, tag
			@wrapper = wrapper
			@tag = tag
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

			txt = args.flatten.join('')
			@tag[:children] << txt unless txt.empty?

			@wrapper.__yld @tag[:children], &block if block_given?
			self
		end

	end
end
