class UsersController < ApplicationController
  # before_filter will be applied to any acton defined in UserController
  # with proper filtering
  before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  before_filter :signed_in_user_try_to_signup, only: [:new, :create]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if(@user.save)
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user   # we need to re-signin the user, as after saving the user
                      # the remember_token gets reset; and we have to in turn 
                      # update @user as well
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
	  if ( User.find(params[:id]) == current_user)
		  flash[:warning] = "You cannot delete yourself!"
      redirect_to users_url
		else
    	User.find(params[:id]).destroy
			flash[:success] = "User deleted."
    	redirect_to users_url
  	end
	end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)	
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def signed_in_user_try_to_signup
      if signed_in?
        flash[:warning] = "You already have an account!"
        redirect_to root_path
      end
    end
end
