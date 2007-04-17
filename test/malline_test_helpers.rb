module Kernel
	def xxx *args
	end
end
module MallineTestHelpers
	Image = Struct.new "Image", :id, :url, :caption
	def assert_xml_equal a, b
		assert_equal a, b
	end
end
