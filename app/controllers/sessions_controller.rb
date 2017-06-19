class SessionsController < ApplicationController
  def new
  end

  def create
    return unless env('ALLOW_REGISTRATION', true)
    user = User.find_by(email: params['session']['email'].downcase)
    if user && user.authenticate(params['session']['password'])
      if true || user.activated? # set up email activation later
        log_in user
        redirect_back_or home_path
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
