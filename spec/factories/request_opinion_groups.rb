# == Schema Information
#
# Table name: request_opinion_groups
#
#  id                 :bigint(8)        not null, primary key
#  request_opinion_id :bigint(8)
#  group_id           :bigint(8)
#

FactoryBot.define do
  factory :request_opinion_group do
    request_opinion { nil }
    group { nil }
  end
end
