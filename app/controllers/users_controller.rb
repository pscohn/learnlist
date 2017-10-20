class UsersController < ApplicationController
  include ApplicationHelper

  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:update]

  def show
    set_user
  end

  def created
    set_user
    @lists = @user.lists
    unless @is_owner
      @lists = @lists.where(private: false)
    end
    @label = 'Created'
    render 'user_lists'
  end

  def saved
    set_user
    list_ids = @user.list_users.where(saved: true).pluck(:list_id)
    @lists = lists_maybe_private(list_ids)
    @label = 'Saved'
    render 'user_lists'
  end

  def in_progress
    set_user
    list_ids = @user.list_users.where(state: 'in_progress').pluck(:list_id)
    @lists = lists_maybe_private(list_ids)
    @label = 'In Progress'
    render 'user_lists'
  end

  def completed
    set_user
    list_ids = @user.list_users.where(state: 'completed').pluck(:list_id)
    @lists = lists_maybe_private(list_ids)
    @label = 'Completed'
    render 'user_lists'
  end

  def new
    redirect_to home_path if current_user
    @user = User.new
  end

  def create
    return unless env('ALLOW_REGISTRATION', true)
    @user = User.new(user_params)
    if @user.save
#      @user.send_activation_email
#      flash[:info] = 'Please check your email to activate your account'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    set_user
    if @user.update_attributes(user_params)
      flash[:success] = 'User edited'
      redirect_to settings_path
    else
      render :edit
    end
  end

  private

  def lists_maybe_private(list_ids)
    if @is_owner
      List.where(id: list_ids)
    else
      List.where(id: list_ids, private: false)
    end
  end

  def set_user
    @user ||= User.where('lower(username) = ?', params[:username].downcase).first
    @is_owner ||= @user == current_user
  end

  def user_params
    params.require(:user).permit(:username, :email, :description, :password, :password_confirmation)
  end
end
