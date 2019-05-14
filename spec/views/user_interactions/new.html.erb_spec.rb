require 'rails_helper'

RSpec.describe "user_interactions/new", type: :view do
  before(:each) do
    assign(:user_interaction, UserInteraction.new(
      :user => nil,
      :controller_name => "MyString",
      :action_name => "MyString"
    ))
  end

  it "renders new user_interaction form" do
    render

    assert_select "form[action=?][method=?]", user_interactions_path, "post" do

      assert_select "input[name=?]", "user_interaction[user_id]"

      assert_select "input[name=?]", "user_interaction[controller_name]"

      assert_select "input[name=?]", "user_interaction[action_name]"
    end
  end
end
