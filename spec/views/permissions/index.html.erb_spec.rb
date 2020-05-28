require 'rails_helper'

RSpec.describe "permissions/index", type: :view do
  before(:each) do
    assign(:permissions, [
      Permission.create!(
        :role => nil,
        :controller => "Controller",
        :action => "Action",
        :permitted => false
      ),
      Permission.create!(
        :role => nil,
        :controller => "Controller",
        :action => "Action",
        :permitted => false
      )
    ])
  end

  it "renders a list of permissions" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Controller".to_s, :count => 2
    assert_select "tr>td", :text => "Action".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
