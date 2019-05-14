require 'rails_helper'

RSpec.describe "user_interactions/edit", type: :view do
  before(:each) do
    @user_interaction = assign(:user_interaction, UserInteraction.create!(
      :user => nil,
      :controller_name => "MyString",
      :action_name => "MyString"
    ))
  end

  it "renders the edit user_interaction form" do
    render

    assert_select "form[action=?][method=?]", user_interaction_path(@user_interaction), "post" do

      assert_select "input[name=?]", "user_interaction[user_id]"

      assert_select "input[name=?]", "user_interaction[controller_name]"

      assert_select "input[name=?]", "user_interaction[action_name]"
    end
  end
end
