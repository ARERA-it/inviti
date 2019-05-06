class AppointeeMailer < ApplicationMailer

  # incaricato

  # Mail destinata a colui/colei che viene incaricato/a
  # AppointeeMailer.with(inv: invitation.id, acc: id).appointed.deliver_later
  def appointed
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

end
