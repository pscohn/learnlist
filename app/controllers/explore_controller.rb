class ExploreController < ApplicationController
  def recent
    @lists = List.where(private: false).paginate(page: params[:page])
  end

  def popular
    @lists = List.unscoped.where(private: false).order(saves: :desc).limit(100).paginate(page: params[:page])
  end
end
