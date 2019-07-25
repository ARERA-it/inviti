class AppointeeMailer < ApplicationMailer

  # incaricato

  # Mail destinata a colui/colei che viene incaricato/a
  # AppointeeMailer.with(inv: invitation.id, acc: id).appointed.deliver_later
  def appointed_old
    @inv = Invitation.find params[:inv]
    @acc = Accept.find params[:acc]
    @summary = []
    @summary << "L'evento"
    @summary << ", organizzato da #{@inv.organizer}," unless @inv.organizer.blank?
    @summary << " avrà luogo"
    @summary << " a #{@inv.location}" unless @inv.location.blank?
    @summary << " in data #{I18n.localize(@inv.from_date_and_time.to_date, format: :long_w_weekday)}" if @inv.from_date_and_time
    @summary << " e" if !@inv.location.blank? || @inv.from_date_and_time
    @summary << " avrà per tema '#{@inv.title}'."
    @summary = @summary.join
    # @url =
    @preheader = "Richiesta partecipazione ad un evento in rappresentanza di ARERA"

    mail(to: @inv.appointee.email, subject: 'Partecipazione ad un evento')

  end

  # sollevato dall'incarico
  def relieved

  end



  # Mail destinata a tutti i membri del collegio nella forma di proposta
  def proposal_to_a_board_members
    @inv = Invitation.find params[:inv]
    @acc = Accept.find params[:acc]

    @summary = []
    @summary << "L'evento"
    @summary << ", organizzato da #{@inv.organizer}," unless @inv.organizer.blank?
    @summary << " avrà luogo"
    @summary << " a #{@inv.location}" unless @inv.location.blank?
    @summary << " in data #{I18n.localize(@inv.from_date_and_time.to_date, format: :long_w_weekday)}" if @inv.from_date_and_time
    @summary << " e" if !@inv.location.blank? || @inv.from_date_and_time
    @summary << " avrà per tema '#{@inv.title}'."
    @summary = @summary.join
    # @url =
    @preheader = "Proposta di partecipazione ad un evento in rappresentanza di ARERA"

    user = Rails.env=="development" ? User.find_by(username: ENV["test_username"]) : @acc.user

    Sidekiq::Logging.logger.info "Sending an email 'Proposta di incarico' to #{user.display_name} [#{user.email}]"
    mail(to: user.email, subject: 'Proposta di incarico')

  end

  # ===============================
  # New ones:

  def appointment
    @ur        = UserReply.find params[:user_reply_id]
    @appointee = @ur.appointment_action.appointee
    @inv       = @appointee.invitation
    @summary   = event_summary(@inv)
    @preheader = "Richiesta partecipazione ad un evento in rappresentanza di ARERA"
    @user      = @appointee.user
    receiver   = ensure_receiver(@user)
    mail(to: receiver.email, subject: 'Partecipazione ad un evento')
  end


  def direct_appointment
    @ur        = UserReply.find params[:user_reply_id]
    @appointee = @ur.appointment_action.appointee
    @inv       = @appointee.invitation
    @summary   = event_summary(@inv)
    @preheader = "Richiesta partecipazione ad un evento in rappresentanza di ARERA"
    @user      = @appointee.user
    receiver   = ensure_receiver(@user)
    mail(to: receiver.email, subject: 'Partecipazione ad un evento')
  end


  def proposal
    @ur        = UserReply.find params[:user_reply_id]
    @appointee = @ur.appointment_action.appointee
    @inv       = @appointee.invitation
    @summary   = event_summary(@inv)
    @preheader = "Proposta di partecipazione ad un evento in rappresentanza di ARERA"
    @user      = @appointee.user
    receiver   = ensure_receiver(@user)
    mail(to: receiver.email, subject: 'Proposta di partecipazione ad un evento')
  end

  # user participation canceled
  def canceled
    @ur        = UserReply.find params[:user_reply_id]
    @appointee = @ur.appointment_action.appointee
    @inv       = @appointee.invitation
    @summary   = event_summary(@inv)
    @preheader = "L'evento o la partecipazione ad esso è stata annullata"
    @user      = @appointee.user
    receiver   = ensure_receiver(@user)
    mail(to: receiver.email, subject: 'Evento o partecipazione annullato')
  end

  #
  # def canceled
  #   @app_action = AppointmentAction.find params[:app_action_id]
  #   @appointee = @app_action.appointee
  #   @inv       = @appointee.invitation
  #   @summary   = event_summary(@inv, canceled: true)
  #   @preheader = "L'evento o la partecipazione ad esso è stata annullata"
  #   @user      = @appointee.user
  #   receiver   = ensure_receiver(@user)
  #   mail(to: receiver.email, subject: 'Evento o partecipazione annullato')
  # end


  private

  def ensure_receiver(user)
    Rails.env=="development" ? User.find_by(username: ENV["test_username"]) : user
  end

  def event_summary(inv, canceled: false)
    summary = []
    # summary << "L'evento"
    summary << "L'#{view_context.link_to 'evento', inv}".html_safe
    summary << ", organizzato da #{inv.organizer}," unless inv.organizer.blank?
    summary << (canceled ? " aveva luogo" : " avrà luogo")  unless inv.location.blank?
    summary << " a #{inv.location}" unless inv.location.blank?
    summary << " in data #{I18n.localize(inv.from_date_and_time.to_date, format: :long_w_weekday)}" if inv.from_date_and_time
    summary << " e" if !inv.location.blank? || inv.from_date_and_time
    summary << (canceled ? " aveva per tema '#{inv.title}'." : " avrà per tema '#{inv.title}'.")
    summary.join.html_safe
  end

end
