class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :welcome if Rails.env!="development"
  layout 'layouts/welcome', only: :welcome

  def welcome
  end

  def dashboard
    if current_user.secretary? || current_user.admin?
      r1 = Rejection.pluck(:id)
      r2 = RejUser.where(user: current_user).pluck(:rejection_id)
      (r1-r2).each do |r_id|
        RejUser.create(rejection_id: r_id, user: current_user)
      end

      @rejections = Rejection.joins(:invitation, :rej_users).where('rej_users.user_id' => current_user.id).order('rej_users.dismissed', 'rejections.created_at DESC').page params[:page]
    else
      @rejections = nil
    end
  end
end
