# == Schema Information
#
# Table name: request_opinion_groups
#
#  id                 :bigint           not null, primary key
#  request_opinion_id :bigint
#  group_id           :bigint
#

class RequestOpinionGroup < ApplicationRecord
  belongs_to :request_opinion
  belongs_to :group
end
