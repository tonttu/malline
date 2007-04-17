require 'test/unit'
require 'test/malline_test_helpers.rb'
require 'malline.rb'

class View
	def img_path(im)
		"/images/#{im.id}"
	end
end


class MallineTest < Test::Unit::TestCase
	include Malline
	include MallineTestHelpers

	def test_simple
		assert_xml_equal('<foo id="a"><bar class="a b"/></foo>',
			Base.run do
				foo.a! do
					bar.a.b
				end
			end
		)

	end

  def test_basics
		images = [Image.new(1, '/image/img1', 'Image 1'), Image.new(2, '/2', 'Image 2')]

		out = Base.new(View.new).run :images => images do
			html do
				body do
					div.imagelist.images! "There are some images:" do
						@images.each do |im|
							a(:href => img_path(im)) { img :src => im.url }
							span.caption.imagetext im.caption
						end
						txt! "No more images"
					end
					div.footer! { span 'footer' }
				end
			end
		end
		assert_xml_equal('<html><body><div class="imagelist" id="images">There are some images:<a href="/images/1"><img src="/image/img1"/></a><span class="caption imagetext">Image 1</span><a href="/images/2"><img src="/2"/></a><span class="caption imagetext">Image 2</span>No more images</div><div id="footer"><span>footer</span></div></body></html>', out)
	end

	def test_tag!
		out = Base.run do
			foo do
				tag!('foobar', :foobar => 'foobar') do
					tag!('foobar2', :foobar => 'foobar2') do
						bar do
							foo
						end
					end
				end
			end
		end
		assert_xml_equal('<foo><foobar foobar="foobar"><foobar2 foobar="foobar2"><bar><foo/></bar></foobar2></foobar></foo>', out)
	end

	def test_defined_tags
		tpl = Base.new(View.new)
		b = Proc.new do
			foo do
				xxx :a => 'b' do
					bar
				end
			end
		end
		out = tpl.run &b
		assert_xml_equal('<foo/>', out)

		tpl.definetags :xxx
		out = tpl.run &b
		assert_xml_equal('<foo><xxx a="b"><bar/></xxx></foo>', out)

		out = Base.run &b
		assert_xml_equal('<foo/>', out)
	end

	def test_xhtml
		Base.setopt :strict => true, :xhtml => true do
			out = Base.run do
				html do
					body do
					end
				end
			end

			assert_xml_equal('<html><body/></html>', out)

			error = ''
			begin
				Base.run do
					foo
				end
			rescue => e
				error = e.message
			end
			assert(error =~ /undefined local variable or method/)
		end
	end
end
