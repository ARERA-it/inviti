class OpinionMailer < ApplicationMailer

  # Send e-mail to all groups users (batch)
  def OpinionMailer.send_request_opinion(req_opinion_id)
    req_op = RequestOpinion.find req_opinion_id
    groups = req_op.groups.includes(:users)

    users_hash = {}
    groups.each do |group|
      group.users.each do |user|
        users_hash[user.id] = [] if !users_hash.has_key?(user.id)
        users_hash[user.id] << group
      end
    end

    users_hash.each do |user_id, groups|
      OpinionMailer.with(req_opinion: req_opinion_id, user: user_id, group_names: groups.map(&:name).to_sentence).request_opinion.deliver_later
    end
  end

  # Send a single e-mail
  def request_opinion
    req_op     = RequestOpinion.find params[:req_opinion]
    @inv       = req_op.invitation
    user       = User.find params[:user]
    receiver   = ensure_receiver(user)

    # puts "----> send email to #{user.name} / #{receiver.email} (#{Time.now})"

    mail(to: receiver.email, subject: 'Richiesto parere su partecipazione ad evento') do |format|
      format.html {
        render locals: { username: user.name, group_names: params[:group_names] }
      }
    end
  end

  private

  def ensure_receiver(user)
    Rails.env=="development" ? User.find_by(username: ENV["test_username"]) : user
  end
end
