class TasksController < ApplicationController
	respond_to :html, :js
	before_action :authenticate_user!
	before_action :instantiate_current_list_cookie
	before_action :find_current_users_lists
	before_action :set_current_list
	before_action :find_current_list_tasks
	before_action :set_form_instance_variables


	def create
		List.find(@current_list.id).tasks.create(task_params)
	end

		private

			def task_params
				params.require(:task).permit(:content, :list_id)
			end

		  # Sets the current_list session cookie if it doesn't already exist.
      # default is set as the users first list. The session

			def instantiate_current_list_cookie
				if session[:current_list].blank?
			  	session[:current_list]=current_user.lists.first.id
			  end
			end

			# Sets the @current_list variable based on request.
			# If no specific request to change the current list
			# has been made, sets current list as the current_list
			# session store, which is set each time a request to 
			# lists#show is made. If no specific request has been made,
			# and session[:current_list] is blank, it defaults to the
			# current users first list.

			def set_current_list
				if params[:set_current_list].blank? && session[:current_list].blank?
					@current_list=current_user.lists.first
				elsif params[:set_current_list].blank?
					@current_list=current_user.lists.find(session[:current_list])
				else
					@current_list=current_user.lists.find(params[:set_current_list])
				end
			end	

			# Finds the related tasks for the @current_list instance variable
			# previously defined.

			def find_current_list_tasks
				@tasks=@current_list.tasks.all
			end

			# Set the required instance variables for rendering
			# the new list and task forms.

			def set_form_instance_variables
				@list=List.new
				@task=@current_list.tasks.new
			end

			# Finds all the current users lists and sets as the @users_lists
			# instance variable.

			def find_current_users_lists
				@user_lists=current_user.lists.all
			end


end
