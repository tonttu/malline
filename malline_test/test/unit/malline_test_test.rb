require File.dirname(__FILE__) + '/../test_helper'
require 'vendor/plugins/malline/test/malline_test_helpers.rb'
require 'malline.rb'

class MallineTestTest < ActiveSupport::TestCase
	include Malline
	include MallineTestHelpers
	def test_examples
		Dir.glob(File.join(File.dirname(__FILE__), 'code', '*.mn')).each do |file|
			assert_xml_equal(File.read(file.sub(/\.mn$/, '.target')),
				Base.new(View.new).render(File.read(file))+"\n", file)
		end
	end
end
