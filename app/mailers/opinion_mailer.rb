class OpinionMailer < ApplicationMailer


  # OpinionMailer.with(req_opinion: id).request_opinion.deliver_later
  def request_opinion
    req_op = RequestOpinion.find params[:req_opinion]
    users = User.advisor_users req_op.destination.split(',')
    @inv = req_op.invitation

    mail(bcc: users.map(&:email), subject: 'Richiesto parere su partecipazione ad evento')
  end

end
