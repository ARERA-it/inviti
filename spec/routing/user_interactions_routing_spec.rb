require "rails_helper"

RSpec.describe UserInteractionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/user_interactions").to route_to("user_interactions#index")
    end

    it "routes to #new" do
      expect(:get => "/user_interactions/new").to route_to("user_interactions#new")
    end

    it "routes to #show" do
      expect(:get => "/user_interactions/1").to route_to("user_interactions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/user_interactions/1/edit").to route_to("user_interactions#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/user_interactions").to route_to("user_interactions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/user_interactions/1").to route_to("user_interactions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/user_interactions/1").to route_to("user_interactions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user_interactions/1").to route_to("user_interactions#destroy", :id => "1")
    end
  end
end
