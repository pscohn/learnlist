class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def created
    @user = User.find(params[:id])
    @lists = @user.lists
  end

  def saved
    @user = User.find(params[:id])
    @lists = List.where(id: @user.list_users.where(saved: true).pluck(:list_id))
  end

  def in_progress
    @user = User.find(params[:id])
    @lists = List.where(id: @user.list_users.where(state: 'in_progress').pluck(:list_id))
  end

  def completed
    @user = User.find(params[:id])
    @lists = List.where(id: @user.list_users.where(state: 'completed').pluck(:list_id))
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the sample app"
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
    if @user.update_attributes(user_params)
      flash[:success] = 'User edited'
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
