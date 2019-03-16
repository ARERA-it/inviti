class CheckNewEmailsJob < ApplicationJob
  queue_as :default

  def perform
    Rake::Task['inviti:check_emails'].invoke
  end
end
