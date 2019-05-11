class ExploreController < ApplicationController
  def recent
    @user = current_user
    @lists = List.where(private: false).paginate(page: params[:page])
  end

  def popular
    @user = current_user
    @lists = List.unscoped.where(private: false).order(saves: :desc).limit(100).paginate(page: params[:page])
  end
end
