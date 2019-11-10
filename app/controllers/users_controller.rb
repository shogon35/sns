class UsersController < ApplicationController
  before_action :authenticate_user,{only: [:edit,:update]}
  before_action :forbid_login_user,{only: [:login,:login_form,:signup,:create]}
  before_action :ensure_correct_user,{only: [:edit,:update]}

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def signup
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      user_image_name: "unknown.jpg",
      password: params[:password]
      )
    if @user.save
      flash[:notice] ="新規登録に成功しました"
      session[:user_id] = @user.id
      redirect_to("/users/#{@user.id}")
    else
      render("users/signup")
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    if params[:image]
      @user.user_image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_image/#{@user.user_image_name}",image.read)
    end

    if @user.save
      flash[:notice] = "編集が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    flash[:notice]="アカウントを削除しました"
    redirect_to("/users/index")
  end

  
  def login_form
    
  end

  def login
    @user = User.find_by(
      email: params[:email],
      password: params[:password]
    )

    if @user
      flash[:notice]="ログインしました"
      session[:user_id] = @user.id
      redirect_to("/posts/index")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end


  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
    # redirect_to("/posts/index")
  end
end
