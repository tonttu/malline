# make sure we're running inside Merb
if defined?(Merb::Plugins)
	require 'malline'
	require 'merb-malline/handler'
end
