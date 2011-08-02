require "spec_helper"

describe DecksController do
  describe "routing" do

    it "routes to #index" do
      get("/decks").should route_to("decks#index")
    end

    it "routes to #new" do
      get("/decks/new").should route_to("decks#new")
    end

    it "routes to #show" do
      get("/decks/1").should route_to("decks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/decks/1/edit").should route_to("decks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/decks").should route_to("decks#create")
    end

    it "routes to #update" do
      put("/decks/1").should route_to("decks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/decks/1").should route_to("decks#destroy", :id => "1")
    end

  end
end
