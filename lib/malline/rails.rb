module ActionView
	class Base
		alias_method :orig_render_template, :render_template
		def render_template template_extension, template, file_path = nil, *rest
			@current_tpl_path = file_path
			orig_render_template(template_extension, template, file_path, *rest)
		end

		alias_method :orig_delegate_render, :delegate_render
		def delegate_render(handler, template, local_assigns)
			if handler == Malline::Base
				h = handler.new(self)
				h.set_path(@current_tpl_path)
				h.render(template, local_assigns)
			else
				orig_delegate_render(handler, template, local_assigns)
			end
		end
	end
end
