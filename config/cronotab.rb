# cronotab.rb — Crono configuration file
#
# Here you can specify periodic jobs and schedule.
# You can use ActiveJob's jobs from `app/jobs/`
# You can use any class. The only requirement is that
# class should have a method `perform` without arguments.
#
# class TestJob
#   def perform
#     puts 'Test!'
#   end
# end
#
# Crono.perform(TestJob).every 2.days, at: '15:30'
#
require 'rake'

Rails.app_class.load_tasks

# Crono.perform(CheckNewEmailsJob).every 30.seconds
Crono.perform(CheckNewEmailsJob).every 2.minutes

Crono.perform(UpdateInvitationsJob).every 1.days, at: '00:01'

Crono.perform(SyncUsersJob).every 1.days, at: '00:35'
