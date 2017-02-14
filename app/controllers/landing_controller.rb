class LandingController < ApplicationController
  layout 'landing'

  def index
    render 'static_pages/home'
  end
end
