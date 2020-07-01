# == Schema Information
#
# Table name: permission_roles
#
#  id            :bigint           not null, primary key
#  role_id       :bigint
#  permission_id :bigint
#  permitted     :boolean          default(FALSE)
#
require 'rails_helper'

RSpec.describe PermissionRole, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
