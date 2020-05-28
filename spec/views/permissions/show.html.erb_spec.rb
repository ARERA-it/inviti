require 'rails_helper'

RSpec.describe "permissions/show", type: :view do
  before(:each) do
    @permission = assign(:permission, Permission.create!(
      :role => nil,
      :controller => "Controller",
      :action => "Action",
      :permitted => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Controller/)
    expect(rendered).to match(/Action/)
    expect(rendered).to match(/false/)
  end
end
