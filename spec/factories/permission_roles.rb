# == Schema Information
#
# Table name: permission_roles
#
#  id            :bigint           not null, primary key
#  role_id       :bigint
#  permission_id :bigint
#  permitted     :boolean          default(FALSE)
#
FactoryBot.define do
  factory :permission_role do
    role { nil }
    permission { nil }
    permitted { false }
  end
end
