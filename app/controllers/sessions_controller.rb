class SessionsController < ApplicationController

  def create
    if params['user_id']
      Rails.cache.write("omnivise:#{:authentiq}:#{params['user_id']}", params['user_id'], expires_in: 28800)
      session[:service_tickets] ||= {}
      session[:service_tickets][:authentiq] = params['user_id']
    end
    begin
      @user = User.from_omniauth(request.env['omniauth.auth'])
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}!"
    rescue
      flash[:warning] = "There was an error while trying to authenticate you..."
    end
    redirect_to root_path
  end

  def destroy
    if current_user
      session.delete(:user_id)
      flash[:success] = 'See you!'
    end
    redirect_to root_path
  end

  def auth_failure
    redirect_to root_path
  end
end