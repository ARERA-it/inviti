namespace :inviti do

  desc "Update invitation expired statuses"
  task :update_invitation_expired_statuses => :environment do
    Invitation.update_invitation_expired_statuses
  end

  desc "Check for new emails"
  task :check_emails => :environment do
    imap = InvitiIMAP.new
    while msg = imap.get_one_msg
      e = msg[:envelope]
      b = msg[:body]
      mail = Mail.new(b)
      ff = e.from.first
      datetime = DateTime.parse(e.date)

      Invitation.find_or_create_by(email_id: mail.message_id) do |inv|
        inv.email_from_name = ff.name,
        inv.email_from_address = "#{ff.mailbox}@#{ff.host}"
        inv.email_subject = e.subject
        inv.email_body_preview = (mail.text_part && mail.text_part.body.to_s) || ""
        inv.email_body = mail.html_part && mail.html_part.body.raw_source.gsub("\r\n", "\n")
        inv.email_received_date_time = datetime
      end
    end

  end
end
