class Users::UsersController < ApplicationController

  before_action :authentiq

  def authentiq
    if params['sid']
      Rails.cache.write("application:#{:authentiq}:#{params['sid']}", params['sid'], expires_in: 28800)
      session[:authentiq_tickets] ||= {}
      session[:authentiq_tickets][:authentiq] = params['sid']
    end
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user != nil
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => :authentiq) if is_navigational_format?
    else
      session["devise.authentiq_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end