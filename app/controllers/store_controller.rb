class StoreController < ApplicationController
	include CurrentCart
	before_action :set_cart

	def index
		@session_counter = increment_session_counter
		@session_counter = 0 if @session_counter <= 5

 		@products = Product.order(:title)
	end

	def increment_session_counter
		session[:counter] ||= 0  # init
		session[:counter] += 1  # increment
	end
end
