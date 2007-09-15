module Malline
	module ViewWrapper

		def __yld dom
			tmp = @__dom
			@__dom = dom
			yield
			@__dom = tmp
		end

		def txt! value
			@__dom << value
		end

		def << value
			@__dom << value
		end

		def tag! s, *args, &block
			if s.to_s[0].chr == '_' && respond_to?(s.to_s[1..255].to_sym)
				tmp = send(s.to_s[1..255].to_sym, *args, &block)
				@__dom << tmp.to_s
				return tmp
			end

			tag = {:name => s, :attrs => {}, :children => []}
			if args.last.is_a?(Hash)
				tag[:attrs].merge!(args.pop)
			end
			txt = args.flatten.join('')
			tag[:children] << txt unless txt.empty?

			@__dom << tag
			__yld tag[:children], &block if block_given?
			ViewProxy.new self, tag
		end

		def __render dom=nil
			dom = @__dom if dom.nil?
			out = ''
			dom.each do |tag|
				if tag.is_a?(String)
					out << tag
				else
					out << "<#{tag[:name]}"
					attr_str = tag[:attrs].keys.collect{|key| "#{key}=\"#{tag[:attrs][key]}\"" }.join(" ")
					out << " #{attr_str}" unless attr_str.nil? || attr_str.empty?
					if tag[:children].empty?
						out << '/>'
					else
						out << '>'
						out << __render(tag[:children])
						out << "</#{tag[:name]}>"
					end
				end
			end
			out
		end

		def __run &block
			@__dom = []
			instance_eval &block
			__render
		end

		# TOOD: include this from some module and use only if xhtml is used
		# custom lang and encoding?
		def xhtml *args, &block
			attrs = {:xmlns => 'http://www.w3.org/1999/xhtml', 'xml:lang' => 'fi'}
			attrs.merge!(args.pop) if args.last.is_a?(Hash)
			txt! "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
			tag! 'html', args.flatten.join(''), attrs, &block
		end
	end
end
