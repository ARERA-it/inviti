# == Schema Information
#
# Table name: assignment_steps
#
#  id               :bigint(8)        not null, primary key
#  invitation_id    :bigint(8)
#  description      :string
#  curr_user_id     :integer
#  assigned_user_id :integer
#  step             :integer
#  timestamp        :datetime
#

class AssignmentStep < ApplicationRecord
  belongs_to :invitation
  belongs_to :curr_user, class_name: "User", foreign_key: "curr_user_id", optional: true
  belongs_to :assigned_user, class_name: "User", foreign_key: "assigned_user_id", optional: true
  enum step: [:nil, :assigned, :accepted, :rejected, :mailed, :declined, :assigned_yet_accepted]

  # before_validation :set_curr_user
  before_create :set_curr_user, :set_timestamp, :generate_description

  def set_curr_user
    self.curr_user = User.current if curr_user.nil?
  end

  def set_timestamp
    self.timestamp = Time.now
  end

  def generate_description
    self.description = case step.to_sym
    when :assigned
      "#{curr_user.name} ha incaricato #{assigned_user.name}"
    when :accepted
      "#{assigned_user.name} ha accettato l'incarico"
    when :rejected
      "#{assigned_user.name} ha rifiutato l'incarico"
    when :mailed
      "è stata inviata una email a #{assigned_user.name} per la conferma"
    when :assigned_yet_accepted
      "#{assigned_user.name} è stato incaricato"
    when :declined
      "#{curr_user.name} ha declinato l'invito"
    else
      nil
    end
  end
end
