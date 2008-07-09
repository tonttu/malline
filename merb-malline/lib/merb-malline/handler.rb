module Merb::Template
	class MallineHandler

		def self.compile_template io, name, mod
			rpath = File.expand_path(if io.is_a?(String)
				tmp, io = io, File.open(io)
				tmp
			else
				io.path
			end)
			path_escaped = rpath.gsub('\\', '\\\\\\').gsub("'", "\\\\'")
			mod.send mod.is_a?(Module) ? :module_eval : :instance_eval, <<-END, rpath
				def #{name}
					mn = Malline::Base.new
					mn.path = '#{path_escaped}'
					@_engine = 'malline'
					mn.render do
						@malline_is_active = true
						#{io.read}
					end
				end
			END
			name
		end

		module Mixin
			def concat_malline str, binding
				self << str
			end
		end
	end

	register_extensions MallineHandler, ['mn']
end
