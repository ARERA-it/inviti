# == Schema Information
#
# Table name: permissions
#
#  id          :bigint           not null, primary key
#  role_id     :bigint
#  description :text
#  controller  :string
#  action      :string
#  permitted   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Permission < ApplicationRecord
  belongs_to :role
  validates :action, uniqueness: { scope: [:role_id, :controller] }

  def controller_and_action
    "#{controller} / #{action}"
  end

  def description!
    description || controller_and_action
  end
end
