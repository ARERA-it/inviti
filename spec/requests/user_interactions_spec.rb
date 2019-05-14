require 'rails_helper'

RSpec.describe "UserInteractions", type: :request do
  describe "GET /user_interactions" do
    it "works! (now write some real specs)" do
      get user_interactions_path
      expect(response).to have_http_status(200)
    end
  end
end
