class CheckNewEmailsJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info("-> CheckNewEmailsJob.perform here.")
    Rake::Task['inviti:check_emails'].invoke
  end
end
