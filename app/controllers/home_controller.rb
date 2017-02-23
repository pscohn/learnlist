class HomeController < ApplicationController
  before_action :logged_in_user

  def created
    #TODO n+1?
    @user = current_user
    @lists = @user.lists
    render 'users/user_lists'
  end

  def saved
    @user = current_user
    @lists = List.where(id: @user.list_users.where(saved: true).pluck(:list_id))
    render 'users/user_lists'
  end

  def in_progress
    @user = current_user
    @lists = List.where(id: @user.list_users.where(state: 'in_progress').pluck(:list_id))
    render 'users/user_lists'
  end

  def completed
    @user = current_user
    @lists = List.where(id: @user.list_users.where(state: 'completed').pluck(:list_id))
    render 'users/user_lists'
  end
end
