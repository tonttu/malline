class Test1Controller < ApplicationController
	def index
		render :layout => params['layout']
	end
	def eindex
		render :layout => params['layout']
	end
	def simple
		render :layout => nil
	end
end
