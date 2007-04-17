module Malline
	# grep ELEMENT xhtml1-transitional.dtd | cut -d' ' -f2 | tr "\n" " "
	XHTML_TAGS = %w{html head title base meta link style script noscript iframe noframes body div p h1 h2 h3 h4 h5 h6 ul ol menu dir li dl dt dd address hr pre blockquote center ins del a span bdo br em strong dfn code samp kbd var cite abbr acronym q sub sup tt i b big small u s strike basefont font object param applet img map area form label input select optgroup option textarea fieldset legend button isindex table caption thead tfoot tbody colgroup col tr th td}
end
