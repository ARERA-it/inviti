class CheckNewEmailsJob < ApplicationJob
  queue_as :default

  def perform
    # Rails.logger.info("-> CheckNewEmailsJob.perform here.")
    # Rake::Task['inviti:check_emails'].invoke

    Rails.logger.info "-----> Check for new emails -------"

    imap = InvitiIMAP.new
    while msg = imap.get_one_msg
      if Invitation.where(email_id: Mail.new(msg[:body]).message_id).none?
        puts "--- message ----------------------------------------"
        puts msg.inspect
        puts "--- ------- ----------------------------------------"
        email = Email.new(msg)
        email.import
      end
    end
  end
end
