class CheckNewEmailsJob < ApplicationJob
  queue_as :default
  rescue_from(Net::IMAP::NoResponseError) do |exception|
    msg = Project.primo.refresh_tokens ? "Tokens refreshed, go on!" : "Tokens not refreshed, bad!"
    ExceptionNotifier.notify_exception(
      exception,
      env: request.env, data: { message: msg }
    )    
  end


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
  end

end
