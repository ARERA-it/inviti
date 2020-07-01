# == Schema Information
#
# Table name: permission_roles
#
#  id            :bigint           not null, primary key
#  role_id       :bigint
#  permission_id :bigint
#  permitted     :boolean          default(FALSE)
#
class PermissionRole < ApplicationRecord
  belongs_to :role
  belongs_to :permission
end
