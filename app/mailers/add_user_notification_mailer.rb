class AddUserNotificationMailer < ApplicationMailer

  def added_these
    @users_added = params[:display_names]
    mail(to: ENV['SUPERUSER_EMAIL'], subject: 'Aggiunti uno o più utenti')
  end

end
