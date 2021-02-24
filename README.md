# README

Webapp to manage invitations




# Setup

```
gem install bundler -v 2.1.4
bundle install
rails db:create db:migrate

rails db:seed
rails r lib/get_rules_from_google_sheet.rb

redis-server

rails c

irb(main):003:0> Invitation.create_fake_records(30, email_status_only: true)


```

