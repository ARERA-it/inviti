require 'rails_helper'

RSpec.describe "permissions/edit", type: :view do
  before(:each) do
    @permission = assign(:permission, Permission.create!(
      :role => nil,
      :controller => "MyString",
      :action => "MyString",
      :permitted => false
    ))
  end

  it "renders the edit permission form" do
    render

    assert_select "form[action=?][method=?]", permission_path(@permission), "post" do

      assert_select "input[name=?]", "permission[role_id]"

      assert_select "input[name=?]", "permission[controller]"

      assert_select "input[name=?]", "permission[action]"

      assert_select "input[name=?]", "permission[permitted]"
    end
  end
end
