class LineItemsController < ApplicationController
	include CurrentCart
	before_action :set_cart, only: [:create, :decrement]
	before_action :set_line_item, only: [:show, :edit, :update, :destroy]

	def index
		@line_items = LineItem.all
	end

	def show
	end

	def new
		@line_item = LineItem.new
	end

	def edit
	end

	def create
		product = Product.find(params[:product_id])
		@line_item = @cart.add_product(product.id, product.price)

		respond_to do |format|
			if @line_item.save
				session[:counter] = nil 

				format.html { redirect_to store_url }
				format.js 	{ @current_item = @line_item }
				format.json { render :show, status: :created, location: @line_item }
			else
				format.html { render :new }
				format.json { render json: @line_item.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @line_item.update(line_item_params)
				format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
				format.json { render :show, status: :ok, location: @line_item }
			else
				format.html { render :edit }
				format.json { render json: @line_item.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /line_items/1
	# PUT /line_items/1.json
  	def decrement
 		@line_item = @cart.decrement_line_item_quantity(params[:id])

 		# alternate
 		#@line_item = @cart.line_items.find_by_id(params[:id])
    	#@line_item = @line_item.decrement_quantity(@line_item.id)

		respond_to do |format|
			if @line_item.save
				format.html { redirect_to store_url }
				format.js 	{ @current_item = @line_item }
				format.json { head :ok }
		 	else
		        format.html { render action: "edit" }
				format.js 	{ @current_item = @line_item }
        		format.json { render json: @line_item.errors, status: :unprocessable_entity }
      		end
		end
	end

	def destroy
		@line_item.destroy
		respond_to do |format|
			format.html { redirect_to line_items_url, notice: 'Line item was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_line_item
			@line_item = LineItem.find(params[:id])
		end

		def line_item_params
			params.require(:line_item).permit(:product_id)
		end
end
