class ExploreController < ApplicationController
  def recent
    @lists = List.paginate(page: params[:page])
  end

  def popular
    @lists = List.unscoped.order(saves: :desc).limit(100).paginate(page: params[:page])
  end
end
