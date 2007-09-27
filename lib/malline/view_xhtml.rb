module Malline::XHTML
	CUSTOM_TAGS = %w{}
	# grep ELEMENT xhtml1-transitional.dtd | cut -d' ' -f2 | tr "\n" " "
	XHTML_TAGS = %w{html head title base meta link style script noscript iframe noframes body div p h1 h2 h3 h4 h5 h6 ul ol menu dir li dl dt dd address hr pre blockquote center ins del a span bdo br em strong dfn code samp kbd var cite abbr acronym q sub sup tt i b big small u s strike basefont font object param applet img map area form label input select optgroup option textarea fieldset legend button isindex table caption thead tfoot tbody colgroup col tr th td} - CUSTOM_TAGS
	# grep 'ELEMENT.*EMPTY' xhtml1-transitional.dtd | cut -d' ' -f2 | tr "\n" " "
	SHORT_TAG_EXCLUDES = XHTML_TAGS + CUSTOM_TAGS - %w{base meta link hr br basefont param img area input isindex col}

	module Tags
	 	def xhtml *args, &block
			attrs = { :xmlns => 'http://www.w3.org/1999/xhtml', 'xml:lang' => @options[:lang] }
			attrs.merge!(args.pop) if args.last.is_a?(Hash)
			self << "<?xml version=\"1.0\" encoding=\"#{@options[:encoding] || 'UTF-8'}\"?>\n"
			tag! 'html', args.flatten.join(''), attrs, &block
		end
	end

	def self.load_plugin malline
		malline.definetags *XHTML_TAGS
		malline.view.short_tag_excludes += SHORT_TAG_EXCLUDES
		malline.view.extend Tags
	end
end
