require "rails_helper"

RSpec.feature "Creating a group", type: :feature do
  before do
    @mrossi   = User.create(username: "mrossi", display_name: "Marco Rossi", role: "admin")
    @averdi   = User.create(username: "averdi", display_name: "Anna Verdi", role: "viewer")
    @rbianchi = User.create(username: "rbianchi", display_name: "Rosa Bianchi", role: "viewer")
  end

	scenario "A user creates a new group" do
	  visit "/groups"
    click_link "Nuovo gruppo"
    # find('.archive-btn').click
    expect(page).to have_content("Nuovo gruppo")

    # confirm
	  fill_in "Nome del gruppo", with: "Collegio"
	  fill_in "group[user_ids][]", with: @mrossi.id, name: "group[user_ids][]", multiple: true
	  click_button "Salva"
	  # expect(page).to have_content("Il gruppo è stato creato correttamente")
    # expect(page.current_path).to eq(groups_path) 
	end
end
