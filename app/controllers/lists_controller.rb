class ListsController < ApplicationController
before_action :authenticate_user!, :except => :index

def index
	if user_signed_in?
		@list=current_user.lists.new
  	@lists=current_user.lists
  else
  	render 'static_pages/home.html.erb'
  end
end

def show
end

def new
end

def create
	@list=current_user.lists.create!(list_params)
	redirect_to root_url
end

	private

	def list_params
		params.require(:list).permit(:name, :user_id, :list_id)
	end				



end
