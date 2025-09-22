class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(12)
  end
  
  def follow
    @user = User.find(params[:id])
    current_user.follow(@user)
    redirect_back fallback_location: root_path
  end
  
  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow(@user)
    redirect_back fallback_location: root_path
  end
end
