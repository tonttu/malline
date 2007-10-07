# Copyright © 2007 Riku Palomäki
#
# This file is part of Malline.
#
# Malline is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Malline is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Malline.  If not, see <http://www.gnu.org/licenses/>.

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
		Base.setopt :strict => false, :xhtml => false do
			assert_xml_equal('<foo id="a"><bar class="a b"/></foo>',
				Base.run do
					foo.a! do
						bar.a.b
					end
				end
			)
		end
	end

	def test_basics
		images = [Image.new(1, '/image/img1', 'Image 1'), Image.new(2, '/2', 'Image 2')]

		out = Base.new(View.new).run :images => images do
			html do
				body do
					div.header!
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
		assert_xml_equal('<html><body><div id="header"></div><div class="imagelist" id="images">There are some images:<a href="/images/1"><img src="/image/img1"/></a><span class="caption imagetext">Image 1</span><a href="/images/2"><img src="/2"/></a><span class="caption imagetext">Image 2</span>No more images</div><div id="footer"><span>footer</span></div></body></html>', out)
	end

	def test_tag!
		Base.setopt :strict => false, :xhtml => false do
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
	end

	def test_defined_tags
		tpl = Base.setopt :strict => false, :xhtml => false do
			Base.new(View.new)
		end
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

		out = Base.setopt :strict => false, :xhtml => false do
			Base.run &b
		end
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

			assert_xml_equal('<html><body></body></html>', out)

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

	def test_file
		Base.setopt :strict => true, :xhtml => true do
			tpl = Base.new(View.new)
			html = File.read(File.join(File.dirname(__FILE__), 'kernel.org.html'))
			mn = tpl.render(File.read(File.join(File.dirname(__FILE__), 'kernel.org.mn')))
			assert_equal(html, mn)
		end
	end

	def test_capture
		Base.setopt :strict => false, :xhtml => false do
			out = Base.run do
				foo do
					@captured = capture do
						a { b 'Yo' }
					end
					x
				end
				bar { self << @captured }
				txt! 'EOF'
			end
			assert_xml_equal('<foo><x/></foo><bar><a><b>Yo</b></a></bar>EOF', out)
		end
	end
end
