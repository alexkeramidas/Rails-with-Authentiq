class ApplicationController < ActionController::Base
  before_action :validate_authentiq_session!
  protect_from_forgery with: :exception

  def validate_authentiq_session!
    return unless current_user && session[:authentiq_tickets]

    valid = session[:authentiq_tickets].all? do |provider, ticket|
      Rails.cache.read("application:#{provider}:#{ticket}").present?
    end

    unless valid
      session[:authentiq_tickets] = nil
      reset_session
      redirect_to root_path
    end
  end
  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  helper_method :current_user
end
