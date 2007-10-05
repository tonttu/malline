module Malline::XHTML
	CUSTOM_TAGS = %w{head title meta}
	# grep ELEMENT xhtml1-transitional.dtd | cut -d' ' -f2 | tr "\n" " "
	XHTML_TAGS = %w{html head title base meta link style script noscript iframe noframes body div p h1 h2 h3 h4 h5 h6 ul ol menu dir li dl dt dd address hr pre blockquote center ins del a span bdo br em strong dfn code samp kbd var cite abbr acronym q sub sup tt i b big small u s strike basefont font object param applet img map area form label input select optgroup option textarea fieldset legend button isindex table caption thead tfoot tbody colgroup col tr th td} - CUSTOM_TAGS
	# grep 'ELEMENT.*EMPTY' xhtml1-transitional.dtd | cut -d' ' -f2 | tr "\n" " "
	SHORT_TAG_EXCLUDES = XHTML_TAGS + CUSTOM_TAGS - %w{base meta link hr br basefont param img area input isindex col}

	module Tags
	 	def xhtml *args, &block
			attrs = { :xmlns => 'http://www.w3.org/1999/xhtml', 'xml:lang' => @options[:lang] }
			attrs.merge!(args.pop) if args.last.is_a?(Hash)
			self << "<?xml version=\"1.0\" encoding=\"#{@options[:encoding] || 'UTF-8'}\"?>\n"
			self << "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 #{@options[:xhtml_dtd] || 'Transitional'}//EN\"\n"
			self << "  \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-#{(@options[:xhtml_dtd] || 'Transitional').downcase}.dtd\">\n"
			tag! 'html', args.flatten.join(''), attrs, &block
		end

		def title *args, &block
			@__xhtml_title = true
			tag! 'title', *args, &block
		end

		def meta *args, &block
			@__xhtml_meta = true
			tag! 'meta', *args, &block
		end

		def head *args, &block
			@__xhtml_title = false
			proxy = tag! 'head', *args, &block
			proxy.__yld { title } unless @__xhtml_title
			proxy.__yld do
				meta :content => "text/html; charset=#{@options[:encoding] || 'UTF-8'}", 'http-equiv' => 'Content-Type'
			end unless @__xhtml_meta
		end
	end

	def self.load_plugin malline
		malline.definetags *XHTML_TAGS
		malline.view.short_tag_excludes += SHORT_TAG_EXCLUDES
		malline.view.extend Tags
	end
end
