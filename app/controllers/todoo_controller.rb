class TodooController < ApplicationController
	before_filter :authenticate_user!
	
	def index
		if !current_user.subscribed
			redirect_to new_subscribe_path, :notice => "To view the active todoos you must subscribe"
		end
		
		@todos = Todoo.where(done: false)
		@todone = Todoo.where(done: true)
	end

	def new
		@todo = Todoo.new
	end

	def todo_params
		params.require(:todoo).permit(:name, :done) 
	end

	def create
		@todo = Todoo.new(todo_params)

		if @todo.save
			redirect_to todoo_index_path, :notice => "Your todo item has been created"
		else
			render "new"
		end
	end

	def update
		@todo = Todoo.find(params[:id])

		if @todo.update_attribute(:done, true)
			redirect_to todoo_index_path, :notice => "Your todo item was marked as done!"
		else
			redirect_to todoo_index_path, :notice => "Your todo item was unable to be marked as done"
		end
	end

	def destroy
		@todo = Todoo.find(params[:id])
		@todo.destroy
	
		redirect_to todoo_index_path, :notice => "Your todo item was deleted."
	end
end
