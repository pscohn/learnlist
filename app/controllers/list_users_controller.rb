class ListUsersController < ApplicationController
  before_action :logged_in_user, only: [:save, :unsave, :in_progress, :completed, :reset]
  before_action :correct_user_if_private

  def save
    list = List.find(params[:id])
    list_user = current_user.list_users.find_or_create_by(list: list)
    list_user.saved = true
    if list_user.save
      list.update_saves
      flash[:success] = 'Saved'
      redirect_back(fallback_location: list)
    else
      flash[:error] = list_user.errors
      redirect_back(fallback_location: list)
    end
  end

  def unsave
    list = List.find(params[:id])
    list_user = current_user.list_users.find_or_create_by(list: list)
    list_user.saved = false
    if list_user.save
      list.update_saves
      flash[:success] = 'Saved'
      redirect_back(fallback_location: list)
    else
      flash[:error] = list_user.errors
      redirect_back(fallback_location: list)
    end
  end

  def in_progress
    save_with_state('in_progress')
  end

  def completed
    save_with_state('completed')
  end

  def reset
    save_with_state('todo')
  end

  private
  def save_with_state(state)
    list = List.find(params[:id])
    list_user = current_user.list_users.find_or_create_by(list: list)
    list_user.state = state
    list_user.saved = true
    if list_user.save
      flash[:success] = 'Saved'
      redirect_back(fallback_location: list)
    else
      flash[:error] = list_user.errors
      redirect_back(fallback_location: list)
    end
  end

  def correct_user_if_private
    @list ||= List.find(params[:id])
    redirect_to(login_path) if @list.private && !current_user?(@list.user)
  end
end
