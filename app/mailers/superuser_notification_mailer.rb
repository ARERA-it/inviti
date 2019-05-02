class SuperuserNotificationMailer < ApplicationMailer

  # SuperuserNotificationMailer.with(count: 1).expired_statuses.deliver_later
  def expired_statuses
    @count = params[:count]
    mail(to: ENV['SUPERUSER_EMAIL'], subject: 'Notifica inviti archiviati')
  end

end
