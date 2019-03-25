class ApplicationController < ActionController::Base
  before_action :authenticate_user! if Rails.env!="development"
  helper_method :current_user
  include Pundit
  protect_from_forgery
  before_action :detect_user_switch
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  alias :devise_current_user :current_user
  def current_user
    if ENV.fetch('user_mode'){ 'devise' }=='switchable'
      @current_user ||= User.find_by(id: session[:user_id]) || User.first
    else
      devise_current_user
    end
  end

  def detect_user_switch
    if ENV.fetch('user_mode'){ 'devise' }=='switchable' && params[:switch_to_user]
      prev_session_user_id = params[:user_id]
      session[:user_id] = params[:switch_to_user]
      # puts "--> User switched from #{prev_session_user_id} to #{session[:user_id]}"
    end
  end




  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:alert] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
end

end
