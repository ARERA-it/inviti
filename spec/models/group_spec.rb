# == Schema Information
#
# Table name: groups
#
#  id          :bigint           not null, primary key
#  name        :string(40)
#  in_use      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ask_opinion :boolean          default(FALSE)
#  appointable :boolean
#

require 'rails_helper'

RSpec.describe Group, type: :model do

  it "is valid with valid attributes" do
    expect(build(:group)).to be_valid
  end

  it "is not valid without a name" do
    expect(build(:group, name: '')).to_not be_valid
  end

  it "is not valid if name is not unique" do
    create :group
    expect(build :group).to_not be_valid
  end

  it "is not valid if the name is used by a user" do
    u = create :user, display_name: "Collegio"
    expect(build :group, name: "Collegio").to_not be_valid
  end
end
