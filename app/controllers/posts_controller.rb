class PostsController < ApplicationController
  before_action :authenticate_user,{only: [:new]}
  before_action :ensure_correct_user,{only: [:update,:destroy,:edit]}

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end

  def new
    @post = Post.new
  end
  

  def create
    @post = Post.new(
      context: params[:context],
      user_id: @current_user.id
    )
    if @post.save 
      flash[:notice]="投稿しました"
      redirect_to("/posts/index")
    else
      render("posts/new")
    end
  end

  def edit
    @post=Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.context = params[:context]
    if @post.save
      flash[:notice] = "編集が成功しました"
      redirect_to("/posts/index")
    else
      render("posts/edit")
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice]="投稿を削除しました"
    redirect_to("/posts/index")
  end


  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @current_user.id != @post.user_id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

end
