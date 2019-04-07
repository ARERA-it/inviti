require "rails_helper"

RSpec.feature "Deleting an Invitation" do
  before do
    mrossi = User.create(username: "mrossi", display_name: "Marco Rossi", role: "admin")
    @inv = Invitation.create(
      email_id: "abc456def",
      email_from_name: "Paolo Verdi",
      email_from_address: "pverdi@example.com",
      email_subject: "Tavola Rotonda XYZ",
      email_body: "Con la presente invitiamo vossignoria...",
      email_received_date_time: Time.now
    )
  end

	scenario "A user creates a new article" do
	  visit "/invitations"
    # click_link "New Article"
    find('.archive-btn').click
    expect(page).to have_content("Richiesta conferma")

    # confirm
	  # fill_in “Title”, with: “Creating a blog” 
	  # fill_in “Body”, with: “Lorem Ipsum” 
	  # click_button “Create Article”
	  # expect(page).to have_content(“Article has been created”)
    # expect(page.current_path).to eq(articles_path) 
	end
end
