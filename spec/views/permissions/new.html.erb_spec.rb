require 'rails_helper'

RSpec.describe "permissions/new", type: :view do
  before(:each) do
    assign(:permission, Permission.new(
      :role => nil,
      :controller => "MyString",
      :action => "MyString",
      :permitted => false
    ))
  end

  it "renders new permission form" do
    render

    assert_select "form[action=?][method=?]", permissions_path, "post" do

      assert_select "input[name=?]", "permission[role_id]"

      assert_select "input[name=?]", "permission[controller]"

      assert_select "input[name=?]", "permission[action]"

      assert_select "input[name=?]", "permission[permitted]"
    end
  end
end
