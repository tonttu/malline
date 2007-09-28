module Malline
	class ErbOut
		def initialize view
			@view = view
		end
		def concat value
			@view << value
		end
	end
	module ViewWrapper
		alias_method :super_method_missing, :method_missing unless method_defined?(:super_method_missing)

		attr_accessor :_erbout
		attr_accessor :options
		attr_accessor :short_tag_excludes

		def init_wrapper opts
			@__stack = []
			@options = opts
			@short_tag_excludes = []
			@_erbout = ErbOut.new(self)
			class << self; self; end.send(:define_method, :method_missing,
																		method(@options[:strict] ? :helper! : :tag!))
		end

		# These two are stolen from Erb
		def self.html_escape(s)
			s.to_s.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;")
		end
		def self.url_encode(s)
			s.to_s.gsub(/[^a-zA-Z0-9_\-.]/n){ sprintf("%%%02X", $&.unpack("C")[0]) }
		end

		def __yld dom
			tmp = @__dom
			@__dom = dom
			yield
			@__dom = tmp
		end

		def txt! value
			@__dom << ViewWrapper.html_escape(value)
		end

		def << value
			@__dom << value
		end

		def helper! s, *args, &block
			helper = (s.to_s[0].chr == '_') ? s.to_s[1..255].to_sym : s.to_sym
			if respond_to?(helper)
				tmp = send(helper, *args, &block)
				@__dom << tmp.to_s
				tmp
			else
				super_method_missing(helper, *args)
			end
		end

		def tag! s, *args, &block
			if s.to_s[0].chr == '_' && respond_to?(s.to_s[1..255].to_sym)
				tmp = send(s.to_s[1..255].to_sym, *args, &block)
				@__dom << tmp.to_s
				return tmp
			end

			tag = {:name => s.to_s, :attrs => {}, :children => []}
			if args.last.is_a?(Hash)
				tag[:attrs].merge!(args.pop)
			end
			txt = args.flatten.join('')
			tag[:children] << ViewWrapper.html_escape(txt) unless txt.empty?

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
					attr_str = tag[:attrs].keys.collect{|key| "#{key}=\"#{ViewWrapper.html_escape(tag[:attrs][key])}\"" }.join(" ")
					out << " #{attr_str}" unless attr_str.nil? || attr_str.empty?
					if tag[:children].empty?
						if short_tag_excludes.include?(tag[:name])
							out << "></#{tag[:name]}>"
						else
							out << '/>'
						end
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
			@__stack.push @__dom
			@__dom = []
			instance_eval &block
			out = __render
			@__dom = @__stack.pop
			out
		end
	end
end
