# == Schema Information
#
# Table name: request_opinion_groups
#
#  id                 :bigint           not null, primary key
#  request_opinion_id :bigint
#  group_id           :bigint
#

FactoryBot.define do
  factory :request_opinion_group do
    request_opinion { nil }
    group { nil }
  end
end
