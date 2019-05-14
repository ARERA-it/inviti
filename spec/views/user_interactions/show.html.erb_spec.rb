require 'rails_helper'

RSpec.describe "user_interactions/show", type: :view do
  before(:each) do
    @user_interaction = assign(:user_interaction, UserInteraction.create!(
      :user => nil,
      :controller_name => "Controller Name",
      :action_name => "Action Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Controller Name/)
    expect(rendered).to match(/Action Name/)
  end
end
