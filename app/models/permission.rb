# == Schema Information
#
# Table name: permissions
#
#  id          :bigint           not null, primary key
#  description :text
#  domain      :string
#  controller  :string
#  action      :string
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Permission < ApplicationRecord
  # belongs_to :role
  has_many :permission_roles, dependent: :destroy
  validates :action, uniqueness: { scope: [:controller] }
  default_scope { order(:position, :domain, :controller, :action) }
  after_create :create_all_permission_roles

  def controller_and_action
    "#{controller} / #{action}"
  end

  def description!
    description || controller_and_action
  end

  def create_all_permission_roles
    Role.all.each do |role|
      PermissionRole.find_or_create_by(role: role, permission: self) do |pr|
        pr.permitted = false
      end
    end
  end
end
