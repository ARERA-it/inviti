class AppointeeMailer < ApplicationMailer

  # incaricato

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

end
