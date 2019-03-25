require 'net/imap'

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

      inv = Invitation.find_by(email_id: mail.message_id)
      if inv.nil?
        inv = Invitation.new
        inv.email_from_name = ff.name
        inv.email_from_address = "#{ff.mailbox}@#{ff.host}"
        inv.email_subject = e.subject
        inv.email_body_preview = (mail.text_part && mail.text_part.body.to_s) || ""
        inv.email_body = mail.html_part && mail.html_part.body.raw_source.gsub("\r\n", "\n")
        inv.email_received_date_time = datetime
        inv.save

        mail.attachments.each do |att|
          inv.files.attach(io: att.body.decoded, filename: att.filename)
        end
      end
    end
  end


  desc "Simply put hello message"
  task :hello => :environment do
    puts "Hello!!"
  end
end
