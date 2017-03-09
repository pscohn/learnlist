class LandingController < ApplicationController
  layout 'landing'

  def index
    @lists = List.unscoped.order(saves: :desc).limit(20)
    render 'static_pages/home'
  end
end
