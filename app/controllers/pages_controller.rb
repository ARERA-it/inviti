class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :welcome if Rails.env!="development"
  layout 'layouts/welcome', only: :welcome

  def welcome
  end

  def dashboard
  end
end
