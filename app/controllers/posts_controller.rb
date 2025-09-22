# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :authorize_user, only: [:edit, :update, :destroy]
  
  def index
    if user_signed_in?
      @posts = Post.where(user_id: current_user.following_ids + [current_user.id])
                  .includes(:user, :likes)
                  .order(created_at: :desc)
                  .page(params[:page])
    else
      @posts = Post.includes(:user, :likes)
                  .order(created_at: :desc)
                  .page(params[:page])
    end
  end
  
  def show
  end
  
  def new
    @post = current_user.posts.new
  end
  
  def create
    @post = current_user.posts.new(post_params)
    
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully deleted.'
  end
  
  def search
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
               .includes(:user)
               .order(created_at: :desc)
               .page(params[:page])
  end
  
  def like
    current_user.likes.create(post: @post)
    redirect_back fallback_location: root_path
  end
  
  def unlike
    current_user.likes.where(post: @post).destroy_all
    redirect_back fallback_location: root_path
  end
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  end
  
  def authorize_user
    unless @post.user == current_user
      redirect_to @post, alert: 'You are not authorized to perform this action.'
    end
  end
  
  def post_params
    params.require(:post).permit(:image, :caption)
  end
end
