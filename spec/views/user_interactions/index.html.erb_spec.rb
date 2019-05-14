require 'rails_helper'

RSpec.describe "user_interactions/index", type: :view do
  before(:each) do
    assign(:user_interactions, [
      UserInteraction.create!(
        :user => nil,
        :controller_name => "Controller Name",
        :action_name => "Action Name"
      ),
      UserInteraction.create!(
        :user => nil,
        :controller_name => "Controller Name",
        :action_name => "Action Name"
      )
    ])
  end

  it "renders a list of user_interactions" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Controller Name".to_s, :count => 2
    assert_select "tr>td", :text => "Action Name".to_s, :count => 2
  end
end
