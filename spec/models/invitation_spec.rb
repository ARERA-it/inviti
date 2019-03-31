# == Schema Information
#
# Table name: invitations
#
#  id                       :bigint(8)        not null, primary key
#  title                    :string
#  location                 :string
#  from_date_and_time       :datetime
#  to_date_and_time         :datetime
#  organizer                :string
#  notes                    :text
#  email_id                 :string
#  email_from_name          :string
#  email_from_address       :string
#  email_subject            :string
#  email_body_preview       :string
#  email_body               :text
#  email_received_date_time :datetime
#  has_attachments          :boolean
#  attachments              :string
#  appointee_id             :integer
#  alt_appointee_name       :string
#  delegation_notes         :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  decision                 :integer          default("waiting")
#  need_info                :boolean          default(TRUE)
#  opinion_expressed        :boolean          default(FALSE)
#  expired                  :boolean          default(FALSE)
#  state                    :integer          default("no_info")
#  appointee_message        :string
#

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
