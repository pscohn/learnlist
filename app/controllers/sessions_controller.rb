class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params['session']['email'].downcase)
    if user && user.authenticate(params['session']['password'])
      if true || user.activated?
        log_in user
        redirect_back_or user
      else
        flash[:danger] = 'Account not activated. Check your email for the activation link.'
        redirect_to login_url
      end
    else
      flash.now[:danger] = 'Invalid username or password'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_url
  end
end
