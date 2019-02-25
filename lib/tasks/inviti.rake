namespace :inviti do

  desc "Update invitation expired statuses"
  task :update_invitation_expired_statuses => :environment do
    Invitation.update_invitation_expired_statuses
  end
end
