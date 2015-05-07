class ListsController < ApplicationController
respond_to :html, :js
before_action :check_user_signed_in
before_action :instantiate_current_list_cookie
before_action :find_current_users_lists
before_action :set_current_list
before_action :find_current_list_tasks
before_action :set_form_instance_variables

#FFFFIIIIXXXXXX INDEX ACTION TO DISPLAY CUURENT LIST NOT 4
def index
end

def show
	session[:current_list]=params[:id]
end

def new
end

def create
	current_user.lists.create!(list_params)
	redirect_to root_url
end

def update
	list_to_edit=List.find(params[:id])
	list_to_edit.update_attributes(list_params)
	redirect_to root_url
end

def destroy
	List.find(params[:id]).destroy
end



	private

	def list_params
		params.require(:list).permit(:name, :user_id, :list_id)
	end


  # Sets the current_list session cookie if it doesn't already exist.
  # Each user is instantiated instantiated with an "Inbox" list. It isn't
  # possible to delete this list or change its name. As such, it is set
  # as the default current list.

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
			@current_list=current_user.lists.find_by_id(session[:current_list]) 
		elsif
			@current_list=current_user.lists.find_by_id(params[:set_current_list])
		end

		if @current_list==nil
			@current_list=current_user.lists.first
		end

	end	

	# Finds the related tasks for the @current_list instance variable
	# previously defined.

	def find_current_list_tasks
		@tasks=@current_list.tasks.where(completed: [false, nil])
		@completed_tasks=@current_list.tasks.where(completed: true)	
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

	def check_user_signed_in
		render 'static_pages/home.html.erb' unless user_signed_in?
	end


end
