class ApplicationController < ActionController::Base
  before_action :authenticate_user! if Rails.env!="development"
  helper_method :current_user
  include Pundit
  protect_from_forgery
  before_action :detect_user_switch
  before_action :set_current_user # GET CURRENT_USER IN MODEL
  before_action :set_current_project
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  puts ENV.fetch('user_mode').inspect

  alias :devise_current_user :current_user
  def current_user
    if ENV.fetch('user_mode'){ 'devise' }=='switchable'
      @current_user ||= User.find_by(id: session[:user_id]) || User.first
      @current_user
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


  protected
    def after_sign_in_path_for(resource)
      request.env['omniauth.origin'] || stored_location_for(resource) || dashboard_path
    end

    def set_current_user
      User.current = current_user
    end

    def set_current_project
      @project = Project.primo
    end

  private

    def user_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore

      flash[:alert] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
      # redirect_to(request.referrer || dashboard_path)
      redirect_to dashboard_path
    end
end
