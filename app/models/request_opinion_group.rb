# == Schema Information
#
# Table name: request_opinion_groups
#
#  id                 :bigint(8)        not null, primary key
#  request_opinion_id :bigint(8)
#  group_id           :bigint(8)
#

class RequestOpinionGroup < ApplicationRecord
  belongs_to :request_opinion
  belongs_to :group
end
