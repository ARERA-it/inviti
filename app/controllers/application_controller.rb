class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  helper_method :current_user
  include Pundit
  protect_from_forgery


  def current_user
    # User.find_by_email('ibuetti@arera.it') # TODO: rimuovi!!!
    User.first # TODO: rimuovi!!!
  end
end
