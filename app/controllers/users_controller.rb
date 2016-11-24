class UsersController < ApplicationController
	def index
		@user = User.all
		gon.user = @user
	end
end
