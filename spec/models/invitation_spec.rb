# == Schema Information
#
# Table name: invitations
#
#  id                       :bigint           not null, primary key
#  title                    :string           default("")
#  location                 :string           default("")
#  from_date_and_time       :datetime
#  to_date_and_time         :datetime
#  organizer                :string           default("")
#  notes                    :text             default("")
#  email_from_name          :string
#  email_from_address       :string
#  email_subject            :string
#  email_body_preview       :text
#  email_body               :text
#  email_received_date_time :datetime
#  delegation_notes         :text             default("")
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  decision                 :integer          default("waiting")
#  state                    :integer          default("no_info")
#  appointee_message        :string           default("")
#  email_decoded            :text
#  appointee_status         :integer          default("nobody")
#  appointee_steps_count    :integer          default(0)
#  public_event             :boolean          default(FALSE)
#  org_category             :integer          default("undefined")
#  email_id                 :string
#

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
