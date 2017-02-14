class ExploreController < ApplicationController
  def recent
    #TODO make recent
    @lists = List.paginate(page: params[:page])
  end

  def popular
    #TODO
    @lists = List.paginate(page: params[:page])
  end
end
