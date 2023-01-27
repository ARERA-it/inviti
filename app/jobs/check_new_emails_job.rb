class CheckNewEmailsJob < ApplicationJob
  queue_as :default
  # rescue_from(Net::IMAP::NoResponseError) do |exception|
  #   ExceptionNotifier.notify_exception(exception) unless Project.primo.refresh_tokens
  # end


  def perform
    # Rails.logger.info("-> CheckNewEmailsJob.perform here.")
    # Rake::Task['inviti:check_emails'].invoke

    Rails.logger.info "-----> Check for new emails -------"

    imap = InvitiIMAP.new
    while msg = imap.get_one_msg
      unless Invitation.find_by(email_id: Mail.new(msg[:body]).message_id)
        email = Email.new(msg)
        email.import
      end
    end

  rescue Net::IMAP::NoResponseError => e
    Rails.logger.error "-----> Check for new emails failed: #{e.message}"
    Project.primo.refresh_tokens
  end

end
